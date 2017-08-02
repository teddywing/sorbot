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

-- gitHubCommitAction :: IO PluginAction
-- gitHubCommitAction :: M.Message -> Connection -> IO String
gitHubCommitAction :: PluginAction
gitHubCommitAction message dbConn = do
    rs <- query_ dbConn "SELECT id, channel, repo_url \
        \ FROM plugin_github_commit_channel_repo_urls \
        \ LIMIT 1" :: IO [ChannelRepoUrl]
    return $ response rs
  where
    response []     = ""
    response (r:rs) =
        repoUrl r ++ "/commits/" ++ M.text message =~ matchRegex gitHubCommit
-- TODO: Make an Either type for plugins to return errors

type Id = Int

type RepoUrl = String

-- | A type to match the database table for this plugin.
-- data ChannelRepoUrl = ChannelRepoUrl Id M.Channel RepoUrl deriving (Show)
data ChannelRepoUrl = ChannelRepoUrl
    { id      :: Id
    , channel :: M.Channel
    , repoUrl :: RepoUrl
    } deriving (Show)

instance FromRow ChannelRepoUrl where
    fromRow = ChannelRepoUrl <$> field <*> field <*> field
