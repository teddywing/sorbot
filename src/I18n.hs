{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module I18n
    ( Locale(..)
    , RenderMessage

    , mkMessage
    , translate
    ) where

import qualified Data.Text as T

import Text.Shakespeare.I18N (mkMessage, renderMessage, RenderMessage)

data Bot = Bot

data Locale = EN | FR

toISOLocale :: Locale -> T.Text
toISOLocale EN = "en"
toISOLocale FR = "fr"

mkMessage "Bot" "messages" "en"

translate :: (RenderMessage Bot b) => Locale -> b -> T.Text
translate locale message =
    renderMessage Bot [(toISOLocale locale)] message
