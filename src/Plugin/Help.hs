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
    return $ Right $ T.intercalate "\n"
        [T.justifyRight longestCommandLen ' ' (command p)
            `T.append` " – "
            `T.append` description p
        | p <- plugins]
  where
    longestCommandLen = foldr (max) 0 (map (T.length . command) plugins)

plugins :: [Plugin]
plugins = PL.plugins ++ [help]
