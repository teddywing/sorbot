module Plugin
    ( realMatchPlugin
    , Plugin
    , performPlugin
    , plugins
    ) where

import Text.Regex.TDFA

data Plugin = Plugin
    { matchRegex :: String
    , perform    :: String -> String
    }

instance Show Plugin where
    show (Plugin r p) = "matchRegex = " ++ r

realMatchPlugin :: String -> Maybe Plugin
realMatchPlugin message = matchPlugin message plugins

matchPlugin :: String -> [Plugin] -> Maybe Plugin
matchPlugin message plugins = firstPlugin $ matchPlugins message plugins

matchPlugins :: String -> [Plugin] -> [Plugin]
matchPlugins message plugins = [p | p <- plugins, message =~ matchRegex p]

firstPlugin :: [Plugin] -> Maybe Plugin
firstPlugin []     = Nothing
firstPlugin (p:ps) = Just p

-- TODO: Make a type for the `perform` function
performPlugin :: Plugin -> String -> String
performPlugin p message = perform p $ message =~ matchRegex p

gitHubCommit = Plugin
    { matchRegex = "^[0-9a-f]{40}$"
    , perform = gitHubCommitAction
    }

gitHubCommitAction :: String -> String
gitHubCommitAction match = "https://github.com/" ++ match

plugins :: [Plugin]
plugins =
    [ gitHubCommit
    ]
