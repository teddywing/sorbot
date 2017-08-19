{-# LANGUAGE OverloadedStrings #-}

module I18n
    ( Locale(..)
    , Message(..)

    , translate
    ) where

import qualified Data.Text as T

data Locale = EN | FR

data Message
    = GitHubCommitRepoURLNotFound
    | GitRemoteSetOriginUpdatedRepoURL T.Text

translate_en_US :: Message -> T.Text
translate_en_US GitHubCommitRepoURLNotFound = "I couldn't find a repo URL for \
    \this channel. Try `git remote set origin REPO_URL`."
translate_en_US (GitRemoteSetOriginUpdatedRepoURL url) =
    "I updated the channel's repo URL to '" `T.append` url `T.append` "'."

translate :: Locale -> Message -> T.Text
translate EN = translate_en_US
