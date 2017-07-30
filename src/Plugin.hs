module Plugin
    ( Plugin
    , matchPlugin
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

matchPlugin :: String -> Maybe Plugin
matchPlugin message = firstPlugin $ matchPlugins message plugins
  where
    firstPlugin []     = Nothing
    firstPlugin (p:ps) = Just p

matchPlugins :: String -> [Plugin] -> [Plugin]
matchPlugins message plugins = [p | p <- plugins, message =~ matchRegex p]

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
