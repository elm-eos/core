module Eos.Fuzz
    exposing
        ( abi
        , account
        , accountName
        , accountPermission
        , accountPermissionWeight
        , action
        , actionName
        , asset
        , authority
        , block
        , blockId
        , blockNum
        , blockRef
        , code
        , controlledAccounts
        , createdAccount
        , fieldName
        , funcName
        , info
        , keyAccounts
        , keyPermissionWeight
        , message
        , permission
        , permissionName
        , privateKey
        , publicKey
        , pushedCode
        , pushedTransaction
        , pushedTransactions
        , shareType
        , signature
        , struct
        , table
        , tableName
        , tableRows
        , transaction
        , transactionId
        , typeDef
        , typeName
        )

{-| Docs

@docs accountName, account, createdAccount, code, info
@docs accountPermission
@docs message
@docs permissionName
@docs tableName, tableRows
@docs privateKey
@docs publicKey
@docs signature, transaction, transactionId
@docs blockRef, block, pushedTransaction, pushedCode

@docs abi, accountPermissionWeight, action, actionName, asset, authority
@docs blockId, blockNum, fieldName, funcName, keyPermissionWeight
@docs shareType, struct, table, typeDef, typeName
@docs controlledAccounts, permission, pushedTransactions
@docs keyAccounts

-}

import Date exposing (Date)
import Eos
import EveryDict exposing (EveryDict)
import Fuzz exposing (..)
import Time exposing (Time)
-- import Random.Pcg as Random exposing (Generator)
-- import Shrink

{-| -}
account : Fuzzer Eos.Account
account =
    map Eos.Account
        accountName
        |> andMap shareType
        |> andMap shareType
        |> andMap shareType
        |> andMap date
        |> andMap (list permission)


{-| -}
shareType : Fuzzer Eos.ShareType
shareType =
    map Eos.shareType string


{-| -}
permission : Fuzzer Eos.Permission
permission =
    map Eos.Permission
        permissionName
        |> andMap (maybe permissionName)
        |> andMap authority


{-| -}
authority : Fuzzer Eos.Authority
authority =
    map Eos.Authority
        (maybe int)
        |> andMap (list keyPermissionWeight)
        |> andMap (list accountPermissionWeight)


{-| -}
keyPermissionWeight : Fuzzer Eos.KeyPermissionWeight
keyPermissionWeight =
    map Eos.KeyPermissionWeight
        publicKey
        |> andMap int


{-| -}
accountPermissionWeight : Fuzzer Eos.AccountPermissionWeight
accountPermissionWeight =
    map Eos.AccountPermissionWeight
        accountPermission
        |> andMap int


{-| -}
keyAccounts : Fuzzer Eos.KeyAccounts
keyAccounts =
    map Eos.KeyAccounts (list accountName)


{-| -}
abi : Fuzzer Eos.Abi
abi =
    map Eos.Abi
        (list typeDef)
        |> andMap (list struct)
        |> andMap (list action)
        |> andMap (list table)


{-| -}
typeDef : Fuzzer Eos.TypeDef
typeDef =
    map Eos.TypeDef typeName
        |> andMap typeName


{-| -}
typeName : Fuzzer Eos.TypeName
typeName =
    map Eos.typeName string


{-| -}
struct : Fuzzer Eos.Struct
struct =
    map Eos.Struct typeName
        |> andMap (maybe typeName)
        |> andMap (everyDict fieldName typeName)


{-| -}
fieldName : Fuzzer Eos.FieldName
fieldName =
    map Eos.fieldName string


{-| -}
action : Fuzzer Eos.Action
action =
    map Eos.Action actionName
        |> andMap typeName


{-| -}
actionName : Fuzzer Eos.ActionName
actionName =
    map Eos.actionName string


{-| -}
accountName : Fuzzer Eos.AccountName
accountName =
    map Eos.accountName string


{-| -}
accountPermission : Fuzzer Eos.AccountPermission
accountPermission =
    map Eos.AccountPermission accountName
        |> andMap permissionName


{-| -}
block : Fuzzer Eos.Block
block =
    map Eos.Block blockId
        |> andMap date
        |> andMap string
        |> andMap accountName
        |> andMap signature
        |> andMap blockId
        |> andMap blockNum
        |> andMap int


{-| -}
blockRef : Fuzzer Eos.BlockRef
blockRef =
    oneOf
        [ map Eos.BlockNumRef blockNum
        , map Eos.BlockIdRef blockId
        ]


{-| -}
blockId : Fuzzer Eos.BlockId
blockId =
    map Eos.blockId string


{-| -}
blockNum : Fuzzer Eos.BlockNum
blockNum =
    map Eos.blockNum int


{-| -}
code : Fuzzer Eos.Code
code =
    map Eos.Code
        accountName
        |> andMap string
        |> andMap string
        |> andMap abi


{-| -}
createdAccount : Fuzzer Eos.CreatedAccount
createdAccount =
    map Eos.CreatedAccount
        accountName
        |> andMap accountName
        |> andMap authority
        |> andMap authority
        |> andMap authority
        |> andMap asset


{-| -}
controlledAccounts : Fuzzer Eos.ControlledAccounts
controlledAccounts =
    map Eos.ControlledAccounts
        (list accountName)


{-| -}
info : Fuzzer Eos.Info
info =
    map Eos.Info
        string
        |> andMap blockNum
        |> andMap blockNum
        |> andMap blockId
        |> andMap date
        |> andMap accountName
        |> andMap string
        |> andMap string


{-| -}
message : Fuzzer data -> Fuzzer (Eos.Message data)
message data =
    map Eos.Message
        accountName
        |> andMap funcName
        |> andMap (list accountPermission)
        |> andMap data


{-| -}
permissionName : Fuzzer Eos.PermissionName
permissionName =
    map Eos.permissionName string


{-| -}
privateKey : Fuzzer Eos.PrivateKey
privateKey =
    map Eos.privateKey string


{-| -}
publicKey : Fuzzer Eos.PublicKey
publicKey =
    map Eos.publicKey string


{-| -}
pushedCode : Fuzzer Eos.PushedCode
pushedCode =
    map Eos.PushedCode
        accountName
        |> andMap int
        |> andMap int
        |> andMap string


{-| -}
pushedTransaction : Fuzzer data -> Fuzzer (Eos.PushedTransaction data)
pushedTransaction data =
    map Eos.PushedTransaction
        transactionId
        |> andMap (transaction data)


{-| -}
pushedTransactions : Fuzzer data -> Fuzzer (Eos.PushedTransactions data)
pushedTransactions data =
    map Eos.PushedTransactions
        bool
        |> andMap (list <| pushedTransaction data)


{-| -}
transaction : Fuzzer data -> Fuzzer (Eos.Transaction data)
transaction data =
    map Eos.Transaction
        blockNum
        |> andMap int
        |> andMap date
        |> andMap (list accountName)
        |> andMap (list <| message data)
        |> andMap (list signature)


{-| -}
transactionId : Fuzzer Eos.TransactionId
transactionId =
    map Eos.transactionId string


{-| -}
signature : Fuzzer Eos.Signature
signature =
    map Eos.signature string


{-| -}
table : Fuzzer Eos.Table
table =
    map Eos.Table
        tableName
        |> andMap typeName
        |> andMap (list fieldName)
        |> andMap (list typeName)
        |> andMap typeName


{-| -}
asset : Fuzzer Eos.Asset
asset =
    map Eos.asset string


{-| -}
funcName : Fuzzer Eos.FuncName
funcName =
    map Eos.funcName string


{-| -}
tableName : Fuzzer Eos.TableName
tableName =
    map Eos.tableName string


{-| -}
tableRows : Fuzzer row -> Fuzzer (Eos.TableRows row)
tableRows row =
    map Eos.TableRows (list row)
        |> andMap bool



-- INTERNAL


everyDict : Fuzzer key -> Fuzzer value -> Fuzzer (EveryDict key value)
everyDict key value =
    map EveryDict.fromList <| list <| tuple ( key, value )


time : Fuzzer Time
time =
    map ((*) Time.second) <| Fuzz.floatRange 0 2524608000


date : Fuzzer Date
date =
    map Date.fromTime time


-- name : Fuzzer String
-- name =
--     let
--         lowercaseLetter =
--             Random.map Char.fromCode <| int (Char.toCode 'a') (Char.toCode 'z')
--
--         digit =
--             Random.map Char.fromCode <| int (Char.toCode '0') (Char.toCode '5')
--
--
--     in
--
