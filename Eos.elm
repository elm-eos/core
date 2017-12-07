module Eos
    exposing
        ( Account
        , AccountName
        , AccountPermission
        , BaseUrl
        , Block
        , BlockRef(..)
        , Code
        , CreatedAccount
        , Info
        , Message
        , PermissionName
        , PrivateKey
        , PublicKey
        , PushedCode
        , PushedTransaction
        , Signature
        , TableName
        , TableRows
        , Transaction
        , accountName
        , accountNameToString
        , baseUrl
        , blockId
        , blockNum
        , permissionName
        , permissionNameToString
        , privateKey
        , privateKeyToString
        , publicKey
        , publicKeyToString
        , signature
        , signatureToString
        , tableName
        , tableNameToString
        )

{-|


# Basics

@docs BaseUrl, baseUrl
@docs AccountName, accountNameToString, accountName
@docs Block, BlockRef, blockId, blockNum, Info


# Keys

@docs PublicKey, publicKeyToString, publicKey
@docs PrivateKey, privateKeyToString, privateKey


# Signatures

@docs Signature, signatureToString, signature


# Accounts and Permissions

@docs Account
@docs CreatedAccount
@docs AccountPermission
@docs PermissionName, permissionNameToString, permissionName


# Tables

@docs TableName, tableName, tableNameToString
@docs TableRows


# Transactions

@docs Transaction, Message, PushedTransaction


# Code

@docs Code, PushedCode

-}

import Date exposing (Date)
import Erl


{-| -}
type alias Account =
    { accountName : AccountName
    , eosBalance : String
    , stakedBalance : String
    , unstakingBalance : String
    , lastUnstakingTime : Date

    -- , permissions : List AccountPermission
    }


{-| -}
type AccountName
    = AccountName String


{-| -}
accountName : String -> AccountName
accountName =
    AccountName


{-| -}
accountNameToString : AccountName -> String
accountNameToString (AccountName str) =
    str


{-| -}
type alias AccountPermission =
    { account : AccountName
    , permission : PermissionName
    }


{-| -}
type alias BaseUrl =
    Erl.Url


{-| -}
baseUrl : String -> BaseUrl
baseUrl =
    Erl.parse


{-| -}
type alias Block =
    { previous : String
    , timestamp : Date
    , transactionMerkleRoot : String
    , producer : AccountName
    , producerSignature : String
    , id : String
    , blockNum : Int
    , refBlockPrefix : Int
    }


{-| -}
type BlockRef
    = BlockNum Int
    | BlockId String


{-| -}
blockNum : Int -> BlockRef
blockNum =
    BlockNum


{-| -}
blockId : String -> BlockRef
blockId =
    BlockId


{-| -}
type alias Code =
    { accountName : AccountName
    , codeHash : String
    , wast : String

    -- abi
    }


{-| -}
type alias CreatedAccount =
    { creator : AccountName
    , name : AccountName

    --, owner
    --, active
    --, recovery
    , deposit : String
    }


{-| -}
type alias Info =
    { serverVersion : String
    , headBlockNum : Int
    , lastIrreversibleBlockNum : Int
    , headBlockId : String
    , headBlockTime : Date
    , headBlockProducer : AccountName
    , recentSlots : String
    , participationRate : String
    }


{-| -}
type alias Message data =
    { code : AccountName
    , type_ : String
    , authorization : List AccountPermission
    , data : data
    }


{-| -}
type PermissionName
    = PermissionName String


{-| -}
permissionName : String -> PermissionName
permissionName =
    PermissionName


{-| -}
permissionNameToString : PermissionName -> String
permissionNameToString (PermissionName str) =
    str


{-| -}
type PrivateKey
    = PrivateKey String


{-| -}
privateKey : String -> PrivateKey
privateKey =
    PrivateKey


{-| -}
privateKeyToString : PrivateKey -> String
privateKeyToString (PrivateKey str) =
    str


{-| -}
type PublicKey
    = PublicKey String


{-| -}
publicKey : String -> PublicKey
publicKey =
    PublicKey


{-| -}
publicKeyToString : PublicKey -> String
publicKeyToString (PublicKey str) =
    str


{-| -}
type alias PushedCode =
    { account : AccountName
    , vmType : Int
    , vmVersion : Int
    , code : String

    -- , codeAbi : Value
    }


{-| -}
type alias PushedTransaction data =
    { transactionId : String
    , transaction : Transaction data
    }


{-| -}
type Signature
    = Signature String


{-| -}
signature : String -> Signature
signature =
    Signature


{-| -}
signatureToString : Signature -> String
signatureToString (Signature str) =
    str


{-| -}
type TableName
    = TableName String


{-| -}
tableName : String -> TableName
tableName =
    TableName


{-| -}
tableNameToString : TableName -> String
tableNameToString (TableName str) =
    str


{-| -}
type alias TableRows row =
    { rows : List row
    , more : Bool
    }


{-| -}
type alias Transaction data =
    { refBlockNum : Int
    , refBlockPrefix : Int
    , expiration : Date
    , scope : List AccountName

    --, readScope
    , messages : List (Message data)
    , signatures : List String
    }
