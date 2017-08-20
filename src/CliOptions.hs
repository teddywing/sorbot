module CliOptions
    ( Options(..)

    , parseOptions
    ) where

import Data.Semigroup ((<>))
import Options.Applicative

data Options = Options
    { slackApiToken :: String
    , language      :: String
    }

options :: Parser Options
options = Options
    <$> strOption
         ( long "slack-token"
        <> metavar "TOKEN"
        <> value ""
        <> help "Token to access Slack's real-time messaging API" )
    <*> strOption
         ( long "language"
        <> short 'l'
        <> metavar "en"
        <> value "en"
        <> help "Set the language Sorbot will speak in (en | fr)" )

parseOptions :: IO Options
parseOptions = do
    execParser opts
  where
    opts = info (options <**> helper)
         ( fullDesc
        <> progDesc "A chat bot with a plugin interface that does a bunch of \
            \random things." )
