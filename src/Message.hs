module Message
    ( Message(..)
    , Channel
    , Nick

    , textStr
    ) where

import qualified Data.Text as T

type Channel = T.Text

type Nick = T.Text

data Message = Message
    { text    :: T.Text
    , channel :: Channel
    , nick    :: Nick
    }

textStr :: Message -> String
textStr = T.unpack . text
