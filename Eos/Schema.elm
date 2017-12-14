module Eos.Schema exposing (..)

import JsonSchema exposing (..)


accountName : Schema
accountName =
    name "Account name"


blockNum : Schema
blockNum =
    integer
        [ description "Block number"
        , minimum 1
        ]


blockId : Schema
blockId =
    string
        [ description "Block ID"
        , minLength 64
        , maxLength 64
        , pattern "^[a-z0-9]{64}$"
        ]


permissionName : Schema
permissionName =
    name "Permission name"


tableName : Schema
tableName =
    name "Table name"


messageName : Schema
messageName =
    name "Message name"


transactionId : Schema
transactionId =
    string
        [ description "Transaction ID"
        , minLength 64
        , maxLength 64
        , pattern "^[a-z0-9]{64}$"
        ]


signature : Schema
signature =
    string
        [ description "Signature"
        , minLength 130
        , maxLength 130
        , pattern "^[a-z0-9]{130}$"
        ]



-- INTERNAL


name : String -> Schema
name desc =
    string
        [ description desc
        , minLength 1
        , maxLength 13
        , pattern "^[a-z0-5\\.]{1,12}[a-p\\.]{0,1}$"
        ]
