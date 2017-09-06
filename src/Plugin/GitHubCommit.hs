{-# LANGUAGE OverloadedStrings #-}

module Plugin.GitHubCommit
    ( gitHubCommit
    ) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Reader (ask)
import qualified Data.Text as T

import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Text.Regex.TDFA

-- import Config (Config(..))
import Bot (Bot, runBot)
import I18n
import qualified Message as M
import qualified CliOptions as Cli (lang)
import Plugin.Base

gitHubCommit :: Bot Plugin
gitHubCommit = do
    cfg <- ask
    return $ defaultPlugin
        { matchRegex  = "^[0-9a-f]{40}$"
        , perform     = gitHubCommitAction
        , command     = "<git_sha>"
        , description = translate (lang cfg) GitHubCommitDescription
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

    liftIO $ respond rs
  where
    respond :: Bot (Either T.Text T.Text)
    respond [] = do
        lang <- Cli.lang
        -- TODO: remove need for `lang`
        return $ Left $ translate (lang cfg) GitHubCommitRepoURLNotFound
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
