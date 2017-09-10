{-# LANGUAGE OverloadedStrings #-}

module I18n
    ( Locale(..)
    , Message(..)

    , translate
    ) where

import qualified Data.Text as T

data Locale = EN | FR deriving (Show)

data Message
    = GitHubCommitDescription
    | GitHubCommitRepoURLNotFound
    | GitRemoteSetOriginUpdatedRepoURL T.Text

translate_en_US :: Message -> T.Text
translate_en_US GitHubCommitDescription = "Generate a commit URL based on the given SHA."
translate_en_US GitHubCommitRepoURLNotFound = "I couldn't find a repo URL for \
    \this channel. Try `git remote set origin REPO_URL`."
translate_en_US (GitRemoteSetOriginUpdatedRepoURL url) =
    "I updated the channel's repo URL to '" `T.append` url `T.append` "'."

translate_fr_FR :: Message -> T.Text
-- TODO: translate
translate_fr_FR GitHubCommitDescription = "Generate a commit URL based on the given SHA."
translate_fr_FR GitHubCommitRepoURLNotFound = "Je n'ai pas trouvé une URL de \
    \repo pour ce channel. Essaye `git remote set origin REPO_URL`."
translate_fr_FR (GitRemoteSetOriginUpdatedRepoURL url) =
    "J'ai mis à jour l'URL de repo pour ce channel ("
        `T.append` url `T.append` ")."

translate :: Locale -> Message -> T.Text
translate EN = translate_en_US
translate FR = translate_fr_FR
