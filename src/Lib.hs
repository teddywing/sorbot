module Lib
    ( someFunc
    ) where

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
    putStrLn $ performPlugin plugin message
