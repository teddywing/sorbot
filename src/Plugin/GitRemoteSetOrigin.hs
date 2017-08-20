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

gitRemoteSetOrigin = defaultPlugin
    { matchRegex  = "^git remote set origin ([^ ]+)$"
    , perform     = gitRemoteSetOriginAction
    , command     = "git remote set origin <url>"
    , description = "Set the git remote URL for this channel."
    }

gitRemoteSetOriginAction :: PluginAction
gitRemoteSetOriginAction message = do
    case M.textStr message =~ matchRegex gitRemoteSetOrigin :: [[String]] of
        []    -> return $ Left "blast"
        (m:_) -> do
            let url = last m

            dbConn <- liftIO $ open "db/sorbot_development.sqlite3"
            liftIO $ withTransaction dbConn $ do
                let params =
                        [":channel"   := M.channel message
                        , ":repo_url" := url
                        ]

                -- Upsert repo URL for channel
                executeNamed dbConn "UPDATE \
                    \ plugin_github_commit_channel_repo_urls \
                    \ SET channel = :channel, \
                    \     repo_url = :repo_url \
                    \ WHERE channel = :channel"
                    params
                executeNamed dbConn "INSERT INTO \
                    \ plugin_github_commit_channel_repo_urls \
                    \ (channel, repo_url) \
                    \ SELECT \
                    \     :channel, \
                    \     :repo_url \
                    \ WHERE changes() = 0"
                    params
            liftIO $ close dbConn

            return $ Right $ "I updated the channel's repo URL to '"
                `T.append` T.pack url
                `T.append` "'"
