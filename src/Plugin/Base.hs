module Plugin.Base
    ( PluginAction

    , Plugin(..)
    ) where

import Message

type PluginAction = Message -> String

data Plugin = Plugin
    { matchRegex :: String
    , perform    :: PluginAction
    }

instance Show Plugin where
    show (Plugin r p) = "matchRegex = " ++ r
