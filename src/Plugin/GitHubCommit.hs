module Plugin.GitHubCommit
    ( gitHubCommit
    ) where

import Plugin.Base

gitHubCommit = Plugin
    { matchRegex = "^[0-9a-f]{40}$"
    , perform = gitHubCommitAction
    }

gitHubCommitAction :: PluginAction
gitHubCommitAction match = "https://github.com/" ++ match
