module Message
    ( Message(..)
    , Channel
    , Nick
    ) where

import qualified Data.Text as T

type Channel = T.Text

type Nick = T.Text

data Message = Message
    { text    :: T.Text
    , channel :: Channel
    , nick    :: Nick
    }
