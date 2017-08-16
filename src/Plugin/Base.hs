module Plugin.Base
    ( PluginAction

    , Plugin(..)
    ) where

import qualified Data.Text as T

import Database.SQLite.Simple

import Message

type PluginAction = Message -> IO (Either T.Text T.Text)

data Plugin = Plugin
    { matchRegex :: String
    , perform    :: PluginAction
    }

instance Show Plugin where
    show (Plugin r p) = "matchRegex = " ++ r
