{-# LANGUAGE OverloadedStrings #-}

module Plugin.GitHubCommit
    ( gitHubCommit
    ) where

import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Text.Regex.TDFA

import qualified Message as M
import Plugin.Base

gitHubCommit = Plugin
    { matchRegex = "^[0-9a-f]{40}$"
    , perform = gitHubCommitAction
    }

gitHubCommitAction :: PluginAction
gitHubCommitAction message dbConn = do
    rs <- query dbConn "SELECT channel, repo_url \
        \ FROM plugin_github_commit_channel_repo_urls \
        \ WHERE channel = ? \
        \ LIMIT 1"
        (Only (M.channel message))
        :: IO [ChannelRepoUrl]
    return $ response rs
  where
    response []     = ""
    response (r:rs) =
        repoUrl r ++ "/commits/" ++ M.text message =~ matchRegex gitHubCommit
-- TODO: Make an Either type for plugins to return errors

type Id = Int

type RepoUrl = String

-- | A type to match the database table for this plugin.
data ChannelRepoUrl = ChannelRepoUrl
    { channel :: M.Channel
    , repoUrl :: RepoUrl
    } deriving (Show)

instance FromRow ChannelRepoUrl where
    fromRow = ChannelRepoUrl <$> field <*> field
