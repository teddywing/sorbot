{-# LANGUAGE OverloadedStrings #-}

module IRC
    ( connectIRC
    ) where

import Control.Monad (sequence_)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Maybe (MaybeT(MaybeT), runMaybeT)
import qualified Data.ByteString as B
import qualified Data.Text as T

import qualified Network.IRC.Client as IRC

import Message
import Plugin (matchPlugin, performPlugin)
import Plugin.Base (queryOnly)

connectIRC :: B.ByteString -> Int -> T.Text -> IO ()
connectIRC host port nick = do
    conn <- IRC.connectWithTLS host port 0.2
    let cfg = IRC.defaultIRCConf nick
    let cfg' = cfg
            {
              IRC._eventHandlers = handlePrivmsg : IRC._eventHandlers cfg
            , IRC._channels = ["#test-chan-13513"]
            }
    IRC.start conn cfg'

handlePrivmsg :: IRC.EventHandler s
handlePrivmsg = IRC.EventHandler
    { IRC._description = ""
    , IRC._matchType = IRC.EPrivmsg
    , IRC._eventFunc = \evt -> dispatchEvent evt
    }
  where
    dispatchEvent :: IRC.UnicodeEvent -> IRC.StatefulIRC s ()
    dispatchEvent (IRC.Event _ (IRC.User nick) (IRC.Privmsg _ (Right msg))) = do
        let message = Message
                { text    = msg
                , channel = nick
                , nick    = nick
                }
        response <- lift $ runMaybeT $ privmsgFromPlugin message
        case response of
            Nothing -> return ()
            Just r  -> sequence_ r
    dispatchEvent (IRC.Event
      _ (IRC.Channel chan nick) (IRC.Privmsg _ (Right msg))) = do
        let message = Message
                { text    = msg
                , channel = chan
                , nick    = nick
                }
        case messageForBot message of
            Nothing      -> return ()
            Just message -> do
                response <- lift $ runMaybeT $ privmsgFromPlugin message
                case response of
                    Nothing -> return ()
                    Just r  -> sequence_ r

privmsgFromPlugin :: Message -> MaybeT IO [IRC.StatefulIRC s ()]
privmsgFromPlugin message = do
    plugin <- liftMaybe $ matchPlugin message
    response <- liftIO $ performPlugin plugin message
    return $ case response of
        Left err -> [IRC.send $ IRC.Privmsg
            (toChannel plugin message)
            (Right err)]
        Right r  -> map
            (\r -> IRC.send $ IRC.Privmsg
                (toChannel plugin message)
                (Right r) )
            (splitAtNewlines $ splitLongLines r)
  where
    liftMaybe = MaybeT . return

    -- IRC only permits 512 bytes per line. Use less to allow for protocol
    -- information that gets sent in addition to the message content.
    splitLongLines txt = T.chunksOf 400 txt

    splitAtNewlines lst = foldr (\s acc -> (T.lines s) ++ acc) [] lst

    toChannel plugin message = case queryOnly plugin of
        False -> channel message
        True  -> nick message

messageForBot :: Message -> Maybe Message
messageForBot m = case T.stripPrefix "sorbot: " (text m) of
    Nothing -> Nothing
    Just t  -> Just m { text = t }
