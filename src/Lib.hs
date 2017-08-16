{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import Database.SQLite.Simple

import IRC (connectIRC)
import Message
import Plugin

someFunc :: IO ()
someFunc = do
    connectIRC "irc.freenode.net" 6697 "test-bot-7890asdf"
