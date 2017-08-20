{-# LANGUAGE OverloadedStrings #-}

module IRC
    ( connectIRC
    ) where

import Control.Monad (sequence_)
import Control.Monad.IO.Class (liftIO)
import qualified Data.ByteString as B
import qualified Data.Text as T

import qualified Network.IRC.Client as IRC

import Message
import Plugin (matchPlugin, performPlugin)

connectIRC :: B.ByteString -> Int -> T.Text -> IO ()
connectIRC host port nick = do
    conn <- IRC.connectWithTLS host port 1
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
    dispatchEvent (IRC.Event _ (IRC.User nick) (IRC.Privmsg _ (Right msg))) = do
        let message = Message
                { text    = msg
                , channel = nick
                , nick    = nick
                }
        response <- liftIO $ privmsgFromPlugin message
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
        response <- liftIO $ privmsgFromPlugin message
        case response of
            Nothing -> return ()
            Just r  -> sequence_ r

privmsgFromPlugin :: Message -> IO (Maybe [IRC.StatefulIRC s ()])
privmsgFromPlugin message = do
    case matchPlugin message of
        Nothing     -> return Nothing
        Just plugin -> do
            response <- liftIO $ performPlugin plugin message
            return $ case response of
                Left err -> Just $
                    [IRC.send $ IRC.Privmsg (channel message) (Right err)]
                Right r  -> Just $
                    map (\r ->
                            IRC.send $ IRC.Privmsg (channel message) (Right r) )
                        (splitAtNewlines $ splitLongLines r)
  where
    -- IRC only permits 512 bytes per line. Use less to allow for protocol
    -- information that gets sent in addition to the message content.
    splitLongLines txt = T.chunksOf 400 txt

    splitAtNewlines lst = foldr (\s acc -> (T.lines s) ++ acc) [] lst
