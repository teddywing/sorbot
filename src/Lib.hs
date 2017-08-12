{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import qualified Data.ByteString as B
import qualified Data.Text as T

import Database.SQLite.Simple
import Network.IRC.Client

import Message
import Plugin

someFunc :: IO ()
someFunc = do
    connectIRC "irc.freenode.net" 6697 "test-bot-7890asdf"
    -- let message = Message
    --         { text    = "75ac7b18a009ffe7a77a17a61d95c01395f36b44"
    --         , channel = "#a-channel"
    --         , nick    = "anon"
    --         }
    --     Just plugin = matchPlugin message
    -- dbConn <- open "db/sorbot_development.sqlite3"
    -- response <- performPlugin plugin message dbConn
    -- putStrLn $ case response of
    --     Left e  -> e
    --     Right r -> r
    -- close dbConn

connectIRC :: B.ByteString -> Int -> T.Text -> IO ()
connectIRC host port nick = do
    conn <- connectWithTLS host port 1
    let cfg = defaultIRCConf nick
    -- let cfg' = cfg { _eventHandlers = yourCustomEventHandlers : _eventHandlers cfg }
    let cfg' = cfg {
          _channels = ["#test-chan-13513"]
        }
    start conn cfg'
