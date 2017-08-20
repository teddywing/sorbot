module CliOptions
    ( Options(..)

    , lang

    , parseOptions
    ) where

import Data.Semigroup ((<>))
import Options.Applicative

import I18n (Locale(EN, FR))

data Options = Options
    { slackApiToken :: String
    , language      :: Locale
    }

-- | Parse the language command line option string into a `Locale` type
parseLanguage :: ReadM Locale
parseLanguage = eitherReader $ \s -> case s of
    "en" -> Right EN
    "fr" -> Right FR
    _    -> Left "Unrecognised language code"

options :: Parser Options
options = Options
    <$> strOption
         ( long "slack-token"
        <> metavar "TOKEN"
        <> value ""
        <> help "Token to access Slack's real-time messaging API" )
    <*> option parseLanguage
         ( long "language"
        <> short 'l'
        <> metavar "en"
        <> value EN
        <> help "Set the language Sorbot will speak in (en | fr)" )

parseOptions :: IO Options
parseOptions = do
    execParser opts
  where
    opts = info (options <**> helper)
         ( fullDesc
        <> progDesc "A chat bot with a plugin interface that does a bunch of \
            \random things." )

-- | A convenience function to get the configured locale.
lang :: IO Locale
lang = do
    opts <- parseOptions
    return $ language opts
