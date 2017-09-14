{-# LANGUAGE OverloadedStrings #-}

module Plugin.Help
    ( help
    ) where

import Control.Monad (sequence)
import qualified Data.Text as T

import Bot (Bot)
import qualified PluginList as PL (plugins)
import Plugin.Base

help :: Bot Plugin
help = do
    return defaultPlugin
        { matchRegex  = "^help$"
        , perform     = helpAction
        , command     = "help"
        , description = "Show a list of available bot commands."
        , queryOnly   = True
        }

helpAction :: PluginAction
helpAction _ = do
    plugins' <- sequence plugins
    return $ Right $ T.intercalate "\n"
        [T.justifyRight (longestCommandLen plugins') ' ' (command p)
            `T.append` " – "
            `T.append` description p
        | p <- plugins']
  where
    longestCommandLen plugins = foldr (max) 0 (map (T.length . command) plugins)

plugins :: [Bot Plugin]
plugins = PL.plugins ++ [help]
