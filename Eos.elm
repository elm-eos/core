module Eos
    exposing
        ( Abi
        , Account
        , AccountName
        , AccountPermission
        , AccountPermissionWeight
        , Action
        , ActionName
        , Asset
        , Authority
        , BaseUrl
        , Block
        , BlockId
        , BlockNum
        , BlockRef(..)
        , Code
        , ControlledAccounts
        , CreatedAccount
        , FieldName
        , FuncName
        , Info
        , KeyAccounts
        , KeyPermissionWeight
        , Message
        , Permission
        , PermissionName
        , PrivateKey
        , PublicKey
        , PushedCode
        , PushedTransaction
        , PushedTransactions
        , ShareType
        , Signature
        , Struct
        , Table
        , TableName
        , TableRows
        , Transaction
        , TransactionId
        , TypeDef
        , TypeName
        , accountName
        , accountNameString
        , actionName
        , actionNameString
        , asset
        , assetString
        , baseUrl
        , blockId
        , blockIdRef
        , blockIdString
        , blockNum
        , blockNumInt
        , blockNumRef
        , fieldName
        , fieldNameString
        , funcName
        , funcNameString
        , permissionName
        , permissionNameString
        , privateKey
        , privateKeyString
        , publicKey
        , publicKeyString
        , shareType
        , shareTypeString
        , signature
        , signatureString
        , tableName
        , tableNameString
        , transactionId
        , transactionIdString
        , typeName
        , typeNameString
        )

{-| See: libraries/types/include/eos/types/generated.hpp
See: libraries/types/include/eos/types/native.hpp


## Basics

@docs BaseUrl, baseUrl
@docs AccountName, accountNameString, accountName, funcName, FuncName, funcNameString
@docs Asset, asset, assetString
@docs ShareType, shareType, shareTypeString
@docs AccountPermissionWeight, Authority, KeyPermissionWeight, Permission
@docs Action, ActionName, actionName, actionNameString


## Blocks

@docs Block, BlockRef, blockId, blockNum, Info
@docs BlockNum, BlockId, blockIdRef, blockNumRef, blockIdString, blockNumInt


## Keys

@docs PublicKey, publicKeyString, publicKey
@docs PrivateKey, privateKeyString, privateKey


## Signatures

@docs Signature, signatureString, signature


## Accounts and Permissions

@docs Account
@docs CreatedAccount, ControlledAccounts, KeyAccounts
@docs AccountPermission
@docs PermissionName, permissionNameString, permissionName


## Tables

@docs TableName, tableName, tableNameString
@docs TableRows, Table


## Transactions

@docs Transaction, Message, PushedTransaction, PushedTransactions
@docs TransactionId, transactionId, transactionIdString


## Code

@docs Code, PushedCode

@docs Abi, FieldName, Struct, TypeDef, TypeName, fieldName, fieldNameString
@docs typeName, typeNameString

-}

import Date exposing (Date)
import Erl
import EveryDict exposing (EveryDict)


{-| -}
type alias Abi =
    { types : List TypeDef
    , structs : List Struct
    , actions : List Action
    , tables : List Table
    }


{-| -}
type alias TypeDef =
    { newTypeName : TypeName
    , type_ : TypeName
    }


{-| -}
type alias Struct =
    { name : TypeName
    , base : Maybe TypeName
    , fields : EveryDict FieldName TypeName
    }


{-| -}
type alias Action =
    { actionName : ActionName
    , type_ : TypeName
    }


{-| -}
type ActionName
    = ActionName String


{-| -}
actionName : String -> ActionName
actionName =
    ActionName


{-| -}
actionNameString : ActionName -> String
actionNameString (ActionName str) =
    str


{-| -}
type alias Table =
    { name : TableName
    , indexType : TypeName
    , keyNames : List FieldName
    , keyTypes : List TypeName
    , type_ : TypeName
    }


{-| -}
type alias Account =
    { accountName : AccountName
    , eosBalance : ShareType
    , stakedBalance : ShareType
    , unstakingBalance : ShareType
    , lastUnstakingTime : Date
    , permissions : List Permission
    }


{-| -}
type AccountName
    = AccountName String


{-| -}
accountName : String -> AccountName
accountName =
    AccountName


{-| -}
accountNameString : AccountName -> String
accountNameString (AccountName str) =
    str


{-| -}
type alias Permission =
    { permName : PermissionName
    , parent : Maybe PermissionName
    , requiredAuth : Authority
    }


{-| -}
type alias Authority =
    { threshold : Maybe Int
    , keys : List KeyPermissionWeight
    , accounts : List AccountPermissionWeight
    }


{-| -}
type alias KeyPermissionWeight =
    { key : PublicKey
    , weight : Int
    }


{-| -}
type alias AccountPermissionWeight =
    { permission : AccountPermission
    , weight : Int
    }


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
    { previous : BlockId
    , timestamp : Date
    , transactionMerkleRoot : String
    , producer : AccountName
    , producerSignature : Signature
    , id : BlockId
    , blockNum : BlockNum
    , refBlockPrefix : Int
    }


{-| -}
type BlockRef
    = BlockNumRef BlockNum
    | BlockIdRef BlockId


{-| -}
blockNumRef : Int -> BlockRef
blockNumRef =
    BlockNumRef << blockNum


{-| -}
blockIdRef : String -> BlockRef
blockIdRef =
    BlockIdRef << blockId


{-| -}
type BlockId
    = BlockId String


{-| -}
blockId : String -> BlockId
blockId =
    BlockId


{-| -}
blockIdString : BlockId -> String
blockIdString (BlockId str) =
    str


{-| -}
type BlockNum
    = BlockNum Int


{-| -}
blockNum : Int -> BlockNum
blockNum =
    BlockNum


{-| -}
blockNumInt : BlockNum -> Int
blockNumInt (BlockNum i) =
    i


{-| -}
type alias Code =
    { accountName : AccountName
    , codeHash : String
    , wast : String
    , abi : Abi
    }


{-| -}
type alias ControlledAccounts =
    { controlledAccounts : List AccountName }


{-| -}
type alias CreatedAccount =
    { creator : AccountName
    , name : AccountName
    , owner : Authority
    , active : Authority
    , recovery : Authority
    , deposit : Asset
    }


{-| -}
type FieldName
    = FieldName String


{-| -}
fieldName : String -> FieldName
fieldName =
    FieldName


{-| -}
fieldNameString : FieldName -> String
fieldNameString (FieldName str) =
    str


{-| -}
type FuncName
    = FuncName String


{-| -}
funcName : String -> FuncName
funcName =
    FuncName


{-| -}
funcNameString : FuncName -> String
funcNameString (FuncName str) =
    str


{-| -}
type alias Info =
    { serverVersion : String
    , headBlockNum : BlockNum
    , lastIrreversibleBlockNum : BlockNum
    , headBlockId : BlockId
    , headBlockTime : Date
    , headBlockProducer : AccountName
    , recentSlots : String
    , participationRate : String
    }


{-| -}
type alias KeyAccounts =
    { accountNames : List AccountName }


{-| -}
type alias Message data =
    { code : AccountName
    , type_ : FuncName
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
permissionNameString : PermissionName -> String
permissionNameString (PermissionName str) =
    str


{-| -}
type PrivateKey
    = PrivateKey String


{-| -}
privateKey : String -> PrivateKey
privateKey =
    PrivateKey


{-| -}
privateKeyString : PrivateKey -> String
privateKeyString (PrivateKey str) =
    str


{-| -}
type PublicKey
    = PublicKey String


{-| -}
publicKey : String -> PublicKey
publicKey =
    PublicKey


{-| -}
publicKeyString : PublicKey -> String
publicKeyString (PublicKey str) =
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
    { transactionId : TransactionId
    , transaction : Transaction data
    }


{-| -}
type alias PushedTransactions data =
    { timeLimitExceededError : Bool
    , transactions : List (PushedTransaction data)
    }


{-| -}
type ShareType
    = ShareType String


{-| -}
shareType : String -> ShareType
shareType =
    ShareType


{-| -}
shareTypeString : ShareType -> String
shareTypeString (ShareType str) =
    str


{-| -}
type Asset
    = Asset String


{-| -}
asset : String -> Asset
asset =
    Asset


{-| -}
assetString : Asset -> String
assetString (Asset str) =
    str


{-| -}
type Signature
    = Signature String


{-| -}
signature : String -> Signature
signature =
    Signature


{-| -}
signatureString : Signature -> String
signatureString (Signature str) =
    str


{-| -}
type TableName
    = TableName String


{-| -}
tableName : String -> TableName
tableName =
    TableName


{-| -}
tableNameString : TableName -> String
tableNameString (TableName str) =
    str


{-| -}
type alias TableRows row =
    { rows : List row
    , more : Bool
    }


{-| -}
type TypeName
    = TypeName String


{-| -}
typeName : String -> TypeName
typeName =
    TypeName


{-| -}
typeNameString : TypeName -> String
typeNameString (TypeName str) =
    str


{-| -}
type alias Transaction data =
    { refBlockNum : BlockNum
    , refBlockPrefix : Int
    , expiration : Date
    , scope : List AccountName

    --, readScope
    , messages : List (Message data)
    , signatures : List Signature
    }


{-| -}
type TransactionId
    = TransactionId String


{-| -}
transactionId : String -> TransactionId
transactionId =
    TransactionId


{-| -}
transactionIdString : TransactionId -> String
transactionIdString (TransactionId str) =
    str
