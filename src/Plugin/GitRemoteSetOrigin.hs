{-# LANGUAGE OverloadedStrings #-}

module Plugin.GitRemoteSetOrigin
    ( gitRemoteSetOrigin
    ) where

import Control.Monad.IO.Class (liftIO)
import qualified Data.Text as T

import Database.SQLite.Simple
import Text.Regex.TDFA ((=~))

import qualified Message as M
import Plugin.Base

gitRemoteSetOrigin = Plugin
    { matchRegex = "^git remote set origin ([^ ]+)$"
    , perform = gitRemoteSetOriginAction
    }

gitRemoteSetOriginAction :: PluginAction
gitRemoteSetOriginAction message = do
    case M.textStr message =~ matchRegex gitRemoteSetOrigin of
        ""  -> return $ Left "blast"
        url -> do
            dbConn <- liftIO $ open "db/sorbot_development.sqlite3"
            liftIO $ execute dbConn "INSERT INTO \
                \ plugin_github_commit_channel_repo_urls \
                \ (channel, repo_url) \
                \ VALUES \
                \ (?, ?)"
                (M.channel message, url)
            liftIO $ close dbConn

            return $ Right $ T.pack url
