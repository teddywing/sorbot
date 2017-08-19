{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module I18n where

import qualified Data.Text as T

import Text.Shakespeare.I18N (mkMessage, renderMessage)

data Bot = Bot

mkMessage "Bot" "messages" "en"
