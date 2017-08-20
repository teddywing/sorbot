{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import Database.SQLite.Simple

import CliOptions (Options(language), parseOptions)
import IRC (connectIRC)
import Message
import Plugin

someFunc :: IO ()
someFunc = do
    options <- parseOptions
    connectIRC "irc.freenode.net" 6697 "test-bot-7890asdf"
