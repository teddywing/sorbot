module Message
    ( Message(..)
    , Channel
    , Nick
    ) where

type Channel = String

type Nick = String

data Message = Message
    { text    :: String
    , channel :: Channel
    , nick    :: Nick
    }
