{-# LANGUAGE ConstraintKinds #-}
-- {-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Bot
    ( Bot(..)
    , BotConfig
    ) where

import Control.Monad.Reader

import CliOptions (Options)

type BotConfig = MonadReader Options

newtype Bot a = Bot
    { runBot :: ReaderT Options IO a
    -- } deriving (Monad, Functor, Applicative, BotConfig, MonadIO)
    } deriving (Monad, Functor, Applicative, MonadReader Options, MonadIO)

-- instance MonadPlus Bot
