module Plugin.GitHubCommit
    ( gitHubCommit
    ) where

import Text.Regex.TDFA

import qualified Message as M
import Plugin.Base

gitHubCommit = Plugin
    { matchRegex = "^[0-9a-f]{40}$"
    , perform = gitHubCommitAction
    }

gitHubCommitAction :: PluginAction
gitHubCommitAction message =
    "https://github.com/" ++ M.text message =~ matchRegex gitHubCommit

type Id = Int

type RepoUrl = String

-- | A type to match the database table for this plugin.
data ChannelRepoUrl = ChannelRepoUrl Id M.Channel RepoUrl deriving (Show)

instance FromRow ChannelRepoUrl where
    fromRow = ChannelRepoUrl <$> field <*> field <*> field
