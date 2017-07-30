module Plugin
    ( matchPlugin
    , performPlugin
    , plugins
    ) where

import Text.Regex.TDFA

import Plugin.Base
import Plugin.GitHubCommit

matchPlugin :: String -> Maybe Plugin
matchPlugin message = firstPlugin $ matchPlugins message plugins
  where
    firstPlugin []     = Nothing
    firstPlugin (p:ps) = Just p

matchPlugins :: String -> [Plugin] -> [Plugin]
matchPlugins message plugins = [p | p <- plugins, message =~ matchRegex p]

performPlugin :: Plugin -> String -> String
performPlugin p message = perform p $ message =~ matchRegex p

plugins :: [Plugin]
plugins =
    [ gitHubCommit
    ]
