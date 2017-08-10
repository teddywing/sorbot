module Plugin.Base
    ( PluginAction

    , Plugin(..)
    ) where

import Database.SQLite.Simple

import Message

-- TODO: Replace Connection with a type class
type PluginAction = Message -> Connection -> IO (Either String String)

data Plugin = Plugin
    { matchRegex :: String
    , perform    :: PluginAction
    }

instance Show Plugin where
    show (Plugin r p) = "matchRegex = " ++ r
