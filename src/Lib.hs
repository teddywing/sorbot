module Lib
    ( someFunc
    ) where

import Text.Regex.TDFA

someFunc :: IO ()
someFunc
    | rex == True = putStrLn "Match!!"
    | otherwise   = putStrLn "No match"


rex :: Bool
rex = "75ac7b18a009ffe7a77a17a61d95c01395f36b44" =~ "^[0-9a-f]{40}$"
