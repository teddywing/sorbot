module Plugin.Base
    ( PluginAction

    , Plugin(..)
    , matchRegex
    , perform
    ) where

type PluginAction = String -> String

data Plugin = Plugin
    { matchRegex :: String
    , perform    :: PluginAction
    }

instance Show Plugin where
    show (Plugin r p) = "matchRegex = " ++ r
