{-# LANGUAGE OverloadedStrings #-}

module IRC
    ( connectIRC
    ) where

import qualified Data.ByteString as B
import qualified Data.Text as T

import qualified Network.IRC.Client as IRC

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
    dispatchEvent (IRC.Event _ (IRC.User nick) (IRC.Privmsg _ (Right msg))) =
        IRC.send $ IRC.Privmsg nick (Right "test")
    dispatchEvent (IRC.Event
      _ (IRC.Channel chan nick) (IRC.Privmsg _ (Right msg))) =
        IRC.send $ IRC.Privmsg chan (Right "test")
