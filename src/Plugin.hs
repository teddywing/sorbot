module Plugin
    ( matchPlugin
    , performPlugin
    , plugins
    ) where

import qualified Data.Text as T

import Text.Regex.TDFA

import qualified Message as M
import Plugin.Base
import Plugin.GitHubCommit

-- | Get the first plugin that matches the given message text.
matchPlugin :: M.Message -> Maybe Plugin
matchPlugin message = firstPlugin $ matchPlugins message plugins
  where
    firstPlugin []     = Nothing
    firstPlugin (p:ps) = Just p

-- | Filter the list of plugins to those that match the given message.
matchPlugins :: M.Message -> [Plugin] -> [Plugin]
matchPlugins message plugins =
    [p | p <- plugins, M.textStr message =~ matchRegex p]

-- | Run the action belonging to the plugin, stored in its `perform` field.
performPlugin :: Plugin -> PluginAction
performPlugin p message = perform p $ message

-- | The list of plugins to load
plugins :: [Plugin]
plugins =
    [ gitHubCommit
    ]
