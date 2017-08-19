{-# LANGUAGE OverloadedStrings #-}

module Plugin.Help
    ( help
    ) where

import qualified Data.Text as T

import qualified Plugin.PluginList as PL (plugins)
import Plugin.Base

help = Plugin
    { matchRegex  = "^help$"
    , perform     = helpAction
    , command     = "help"
    , description = "Show a list of available bot commands."
    }

helpAction :: PluginAction
helpAction _ = do
    return $ Right $ T.concat
        [command p `T.append` "\t" `T.append` description p | p <- plugins]

plugins :: [Plugin]
plugins = PL.plugins ++ [help]
