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
        -- IRC.send $ IRC.Privmsg nick (Right "test")
        let message = Message
                { text    = T.unpack msg
                , channel = T.unpack nick
                , nick    = T.unpack nick
                }
            Just plugin = matchPlugin message
        -- rsp =<< performPlugin plugin message
        -- IRC.send case performPlugin plugin message of
        --     Left err -> IRC.Privmsg nick (Right (T.pack err))
        --     Right r  -> IRC.Privmsg nick (Right (T.pack r))
        response <- liftIO $ performPlugin plugin message
        IRC.send $ case response of
            Left err -> IRC.Privmsg nick (Right (T.pack err))
            Right r  -> IRC.Privmsg nick (Right (T.pack r))
    dispatchEvent (IRC.Event
      _ (IRC.Channel chan nick) (IRC.Privmsg _ (Right msg))) = do
        -- IRC.send $ IRC.Privmsg chan (Right "test")
        let message = Message
                { text    = T.unpack msg
                , channel = T.unpack chan
                , nick    = T.unpack nick
                }
            Just plugin = matchPlugin message
        response <- liftIO $ performPlugin plugin message
        IRC.send $ case response of
            Left err -> IRC.Privmsg chan (Right (T.pack err))
            Right r  -> IRC.Privmsg chan (Right (T.pack r))

    -- let Just plugin = matchPlugin message
    -- response <- performPlugin plugin message
    -- putStrLn $ case response of
    --     Left e  -> e
    --     Right r -> r
