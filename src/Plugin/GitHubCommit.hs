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
