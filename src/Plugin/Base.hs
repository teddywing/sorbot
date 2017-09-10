{-# LANGUAGE OverloadedStrings #-}

module Plugin.Base
    ( PluginAction

    , Plugin(..)
    , defaultPlugin
    ) where

import Control.Monad.Trans.Class (lift)
import qualified Data.Text as T

import Database.SQLite.Simple

-- import Config (Config)
import Bot (Bot(Bot))
import Message

type PluginAction = Message -> Bot (Either T.Text T.Text)

-- newtype Foo = Config Plugin

data Plugin = Plugin
    { matchRegex  :: String
    , perform     :: PluginAction
    , command     :: T.Text
    , description :: T.Text
    , queryOnly   :: Bool
    }

instance Show Plugin where
    show (Plugin r _ _ _ _) = "matchRegex = " ++ r

defaultPlugin :: Plugin
defaultPlugin = Plugin
    { matchRegex  = ""
    , perform     = \m -> return (Left "")
    , command     = ""
    , description = ""
    , queryOnly   = False
    }
