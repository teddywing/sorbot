-- {-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

module Plugin.GitHubCommit
    ( gitHubCommit
    ) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Reader (ask, asks)
import qualified Data.Text as T

import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Text.Regex.TDFA

-- import Config (Config(..))
import Bot (Bot, runBot, BotConfig)
import I18n
import qualified Message as M
import qualified CliOptions as Cli (lang, language)
import Plugin.Base

-- gitHubCommit :: BotConfig m => m Plugin
gitHubCommit :: Bot Plugin
gitHubCommit = do
    -- cfg <- asks Cli.language
    cfg <- ask
    return defaultPlugin
        { matchRegex  = "^[0-9a-f]{40}$"
        , perform     = gitHubCommitAction
        , command     = "<git_sha>"
        , description = translate (Cli.language cfg) GitHubCommitDescription
            -- "Generate a commit URL based on the given SHA."
        }

gitHubCommitAction :: PluginAction
gitHubCommitAction message = do
    dbConn <- liftIO $ open "db/sorbot_development.sqlite3"
    rs <- liftIO $ query dbConn "SELECT repo_url \
        \ FROM plugin_github_commit_channel_repo_urls \
        \ WHERE channel = ? \
        \ LIMIT 1"
        (Only (M.channel message))
        :: Bot [RepoUrlRow]
    liftIO $ close dbConn

    respond rs
  where
    respond :: Bot (Either T.Text T.Text)
    respond [] = do
        cfg <- ask
        -- lang <- Cli.lang
        -- TODO: remove need for `lang`
        return $ Left $ translate (Cli.language cfg) GitHubCommitRepoURLNotFound
    respond ((RepoUrlRow r):_) = do
        -- bot <- ask
        -- plugin <- runBot bot >>= gitHubCommit
        plugin <- gitHubCommit
        return $ Right $ r `T.append` "/commits/" `T.append` T.pack (
            M.textStr message =~ matchRegex plugin)

type RepoUrl = T.Text

-- | A type to match the database table for this plugin.
data RepoUrlRow = RepoUrlRow RepoUrl

instance FromRow RepoUrlRow where
    fromRow = RepoUrlRow <$> field
