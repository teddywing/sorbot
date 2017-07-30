module Lib
    ( someFunc
    ) where

import Text.Regex.TDFA

import Plugin

someFunc :: IO ()
someFunc = do
    let Just plugin = realMatchPlugin "75ac7b18a009ffe7a77a17a61d95c01395f36b44"
    putStrLn $ performPlugin plugin
