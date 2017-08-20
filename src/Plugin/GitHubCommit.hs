{-# LANGUAGE OverloadedStrings #-}

module Plugin.GitHubCommit
    ( gitHubCommit
    ) where

import qualified Data.Text as T

import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Text.Regex.TDFA

import I18n
import qualified Message as M
import qualified CliOptions as Cli (lang)
import Plugin.Base

gitHubCommit = defaultPlugin
    { matchRegex  = "^[0-9a-f]{40}$"
    , perform     = gitHubCommitAction
    , command     = "<git_sha>"
    , description = "Generate a commit URL based on the given SHA."
    }

gitHubCommitAction :: PluginAction
gitHubCommitAction message = do
    dbConn <- open "db/sorbot_development.sqlite3"
    rs <- query dbConn "SELECT repo_url \
        \ FROM plugin_github_commit_channel_repo_urls \
        \ WHERE channel = ? \
        \ LIMIT 1"
        (Only (M.channel message))
        :: IO [RepoUrlRow]
    close dbConn

    respond rs
  where
    respond [] = do
        lang <- Cli.lang
        return $ Left $ translate lang GitHubCommitRepoURLNotFound
    respond ((RepoUrlRow r):_) =
        return $ Right $ r `T.append` "/commits/" `T.append` T.pack (
            M.textStr message =~ matchRegex gitHubCommit)

type Id = Int

type RepoUrl = T.Text

-- | A type to match the database table for this plugin.
data RepoUrlRow = RepoUrlRow RepoUrl

instance FromRow RepoUrlRow where
    fromRow = RepoUrlRow <$> field
