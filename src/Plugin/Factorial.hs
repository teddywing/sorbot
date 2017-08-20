{-# LANGUAGE OverloadedStrings #-}

module Plugin.Factorial
    ( factorial
    ) where

import Text.Regex.TDFA ((=~))
import TextShow (showt)

import qualified Message as M
import Plugin.Base

factorial = Plugin
    { matchRegex  = "^([0-9]+)!$"
    , perform     = factorialAction
    , command     = "<integer>!"
    , description = "Calculate the factorial of <integer>"
    }

factorialAction :: PluginAction
factorialAction message = do
    case M.textStr message =~ matchRegex factorial :: [[String]] of
        []    -> return $ Left "I didn't understand"
        (m:_) -> do
            let number = last m
            return $ Right $ showt $ calculate $ (read number :: Int)

calculate :: (Enum a, Num a) => a -> a
calculate n = product [1..n]
