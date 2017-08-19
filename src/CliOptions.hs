module CliOptions
    ( parseOptions
    ) where

import Data.Semigroup ((<>))
import Options.Applicative

data Options = Options
    { slackApiToken :: String
    }

options :: Parser Options
options = Options
    <$> strOption
         ( long "slack-token"
        <> metavar "TOKEN"
        <> value ""
        <> help "Token to access Slack's real-time messaging API" )

parseOptions :: IO ()
parseOptions = do
    execParser opts
    return ()
  where
    opts = info (options <**> helper)
         ( fullDesc
        <> progDesc "A chat bot with a plugin interface that does a bunch of \
            \random things." )
