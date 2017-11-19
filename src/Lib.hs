{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import Database.SQLite.Simple

import Bot (Bot(runBot))
import CliOptions (Options(language), parseOptions)
-- import IRC (connectIRC)
import Message
-- import Plugin
import Plugin.Base (Plugin)
import PluginList as PL (plugins)
-- TODO: tmp test
import Control.Monad.Reader (runReaderT)
import CliOptions (Options(..))
import Plugin.Help as Help (help)
import I18n (Locale(EN))
import Plugin (performPlugin)
import qualified Data.Text.IO as TIO

someFunc :: IO ()
someFunc = do
    -- options <- parseOptions
    -- halp <- runReaderT (runBot Help.help) Options
    --     { slackApiToken = "booya"
    --     , language = EN
    --     }
    -- case performPlugin halp "hello" of
    --     Left s -> TIO.putStrLn s
    --     Right s -> TIO.putStrLn s

    -- halp <- performPlugin Help.help "_msg"
    hilp <- runReaderT
        (runBot
            (performPlugin Help.help Message
                { text = "_msg"
                , channel = "#?"
                , nick = "zyx"
                }))
        Options
            { slackApiToken = "booya"
            , language = EN
            }
    case hilp of
        Left x -> TIO.putStrLn x
        Right x -> TIO.putStrLn x

    -- connectIRC "irc.freenode.net" 6697 "test-bot-7890asdf"

initializePlugins :: Options -> [IO Plugin]
initializePlugins options =
    map
        (\p -> runReaderT (runBot p) options)
        plugins
