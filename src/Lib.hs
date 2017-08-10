module Lib
    ( someFunc
    ) where

import Database.SQLite.Simple

import Message
import Plugin

someFunc :: IO ()
someFunc = do
    let message = Message
            { text    = "75ac7b18a009ffe7a77a17a61d95c01395f36b44"
            , channel = "#a-channel"
            , nick    = "anon"
            }
        Just plugin = matchPlugin message
    dbConn <- open "db/sorbot_development.sqlite3"
    response <- performPlugin plugin message dbConn
    putStrLn $ case response of
        Left e  -> e
        Right r -> r
    close dbConn
