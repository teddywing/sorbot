module Plugin
    ( matchPlugin
    , performPlugin
    , plugins
    ) where

import Control.Monad (mzero)
import qualified Data.Text as T

import Text.Regex.TDFA

import Bot (Bot)
import qualified Message as M
import Plugin.Base
import qualified PluginList as PL (plugins)
import Plugin.Help (help)

-- | Get the first plugin that matches the given message text.
matchPlugin :: M.Message -> Maybe (Bot Plugin)
matchPlugin message = do
    -- plugins' <- return $ sequence plugins
    -- firstPlugin $ matchPlugins message plugins'
    return $ firstPlugin $ matchBotPlugins message
  where
    firstPlugin :: Bot [Plugin] -> Bot Plugin
    -- firstPlugin []     = Nothing
    -- firstPlugin (p:ps) = Just p
    firstPlugin plugins = do
        plugins' <- plugins
        case plugins' of
            -- []     -> mzero
            []     -> fail "Empty plugin list"
            (p:ps) -> return p

    -- matchBotPlugins :: M.Message -> [Bot Plugin]
    -- matchBotPlugins message = do
    --     -- plugins' <- sequence plugins
    --     -- return $ matchPlugins message plugins'
    --     return $ matchPlugins message plugins
    matchBotPlugins :: M.Message -> Bot [Plugin]
    matchBotPlugins message = do
        plugins' <- sequence plugins
        return $ matchPlugins message plugins'

-- | Filter the list of plugins to those that match the given message.
matchPlugins :: M.Message -> [Plugin] -> [Plugin]
matchPlugins message plugins =
    [p | p <- plugins, M.textStr message =~ matchRegex p]
  -- where
  --   matches :: M.Message -> Bot Plugin -> Bool
  --   matches message pluginM = do
  --       p <- pluginM
  --       M.textStr message =~ matchRegex p
-- ---
-- matchPlugins :: M.Message -> [Bot Plugin] -> [Bot Plugin]
-- matchPlugins message plugins =
--     [p | p <- plugins, matches message p]
--   where
--     matches :: M.Message -> Bot Plugin -> Bool
--     matches message pluginM = do
--         p <- pluginM
--         M.textStr message =~ matchRegex p
-- ---
-- matchPlugins :: M.Message -> [Bot Plugin] -> [Bot Plugin]
-- matchPlugins message plugins = do
--     _ <- return $ sequence plugins
--     [return p | p <- plugins', M.textStr message =~ matchRegex p]

-- | Run the action belonging to the plugin, stored in its `perform` field.
performPlugin :: Bot Plugin -> PluginAction
performPlugin p message = do
    plugin <- p
    perform plugin $ message

plugins :: [Bot Plugin]
plugins = PL.plugins ++ [help]
