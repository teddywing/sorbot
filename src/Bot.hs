-- {-# LANGUAGE ConstraintKinds #-}
-- {-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Bot
    ( Bot(..)
    ) where

import Control.Monad.Reader

import CliOptions (Options)

newtype Bot a = Bot
    { runBot :: ReaderT Options IO a
    } deriving (Monad, Functor, Applicative, MonadIO)
