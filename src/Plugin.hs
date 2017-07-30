module Plugin
    ( matchPlugin
    , performPlugin
    , plugins
    ) where

import Text.Regex.TDFA

import Plugin.Base
import Plugin.GitHubCommit

-- | Get the first plugin that matches the given message text.
matchPlugin :: String -> Maybe Plugin
matchPlugin message = firstPlugin $ matchPlugins message plugins
  where
    firstPlugin []     = Nothing
    firstPlugin (p:ps) = Just p

-- | Filter the list of plugins to those that match the given message.
matchPlugins :: String -> [Plugin] -> [Plugin]
matchPlugins message plugins = [p | p <- plugins, message =~ matchRegex p]

-- | Run the action belonging to the plugin, stored in its `perform` field.
performPlugin :: Plugin -> String -> String
performPlugin p message = perform p $ message =~ matchRegex p

-- | The list of plugins to load
plugins :: [Plugin]
plugins =
    [ gitHubCommit
    ]
