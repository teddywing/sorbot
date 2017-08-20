module PluginList
    ( plugins
    ) where

import Plugin.Base (Plugin)
import Plugin.Factorial (factorial)
import Plugin.GitHubCommit (gitHubCommit)
import Plugin.GitRemoteSetOrigin (gitRemoteSetOrigin)

-- | The list of plugins to load, minus the Help plugin, which would otherwise
-- cause a circular import.
plugins :: [Plugin]
plugins =
    [ factorial
    , gitHubCommit
    , gitRemoteSetOrigin
    ]
