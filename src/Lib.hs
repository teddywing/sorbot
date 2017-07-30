module Lib
    ( someFunc
    ) where

import Text.Regex.TDFA

import Plugin

someFunc :: IO ()
someFunc = do
    let message = "75ac7b18a009ffe7a77a17a61d95c01395f36b44"
        Just plugin = realMatchPlugin message
    putStrLn $ performPlugin plugin message
