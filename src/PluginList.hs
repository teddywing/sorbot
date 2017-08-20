module PluginList
    ( plugins
    ) where

import Plugin.Base (Plugin)
import Plugin.Factorial
import Plugin.GitHubCommit
import Plugin.GitRemoteSetOrigin

-- | The list of plugins to load, minus the Help plugin, which would otherwise
-- cause a circular import.
plugins :: [Plugin]
plugins =
    [ factorial
    , gitHubCommit
    , gitRemoteSetOrigin
    ]
