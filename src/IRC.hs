{-# LANGUAGE OverloadedStrings #-}

module IRC
    ( connectIRC
    ) where

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
    let cfg' = cfg {
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
                { text    = T.unpack msg
                , channel = T.unpack nick
                , nick    = T.unpack nick
                }
            Just plugin = matchPlugin message
        response <- liftIO $ performPlugin plugin message
        IRC.send $ case response of
            Left err -> IRC.Privmsg nick (Right (T.pack err))
            Right r  -> IRC.Privmsg nick (Right (T.pack r))
    dispatchEvent (IRC.Event
      _ (IRC.Channel chan nick) (IRC.Privmsg _ (Right msg))) = do
        let message = Message
                { text    = T.unpack msg
                , channel = T.unpack chan
                , nick    = T.unpack nick
                }
        -- case privmsgFromPlugin message of
            -- ()   -> return ()
            -- msg  -> IRC.send msg
        -- response <- privmsgFromPlugin message
        response <- liftIO $ privmsgFromPlugin message
        IRC.send response

privmsgFromPlugin :: Message -> IO (IRC.Message T.Text)
privmsgFromPlugin message = do
    case matchPlugin message of
        -- Nothing -> 
        Just plugin -> do
            -- let response = liftIO $ performPlugin plugin message in
            response <- liftIO $ performPlugin plugin message
            return $ case response of
                Left err -> IRC.Privmsg
                    (T.pack (channel message))
                    (Right (T.pack err))
                Right r  -> IRC.Privmsg
                    (T.pack (channel message))
                    (Right (T.pack r))
