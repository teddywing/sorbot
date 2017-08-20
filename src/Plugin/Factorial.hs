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
            return $ Right $ result (read number :: Integer)
  where
    result n = case calculate n of
        Nothing -> "Input is too large."
        Just n  -> showt n

calculate :: Integer -> Maybe Integer
calculate n
    | n <= 0      = Just 0
    | n <= 35000  = Just $ product [1..n]
    | otherwise   = Nothing
