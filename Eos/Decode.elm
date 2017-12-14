module Eos.Decode
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

@docs account
@docs accountName
@docs accountPermission
@docs block
@docs blockRef
@docs code
@docs createdAccount
@docs info
@docs message
@docs permission
@docs permissionName
@docs privateKey
@docs publicKey
@docs pushedCode
@docs pushedTransaction, pushedTransactions
@docs signature
@docs tableName
@docs tableRows
@docs transaction, transactionId
@docs controlledAccounts, keyAccounts
@docs blockId, blockNum, shareType, asset
@docs abi, accountPermissionWeight, action, actionName, authority
@docs fieldName, funcName, keyPermissionWeight, struct
@docs table, typeDef, typeName

-}

import Date exposing (Date)
import Eos
import EveryDict exposing (EveryDict)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


{-| -}
abi : Decoder Eos.Abi
abi =
    decode Eos.Abi
        |> required "types" (list typeDef)
        |> required "structs" (list struct)
        |> required "actions" (list action)
        |> required "tables" (list table)


{-| -}
typeDef : Decoder Eos.TypeDef
typeDef =
    decode Eos.TypeDef
        |> required "new_type_name" typeName
        |> required "type" typeName


{-| -}
struct : Decoder Eos.Struct
struct =
    decode Eos.Struct
        |> required "name" typeName
        |> required "base" (nullable typeName)
        |> required "fields" (everyDict Eos.fieldName typeName)


{-| -}
action : Decoder Eos.Action
action =
    decode Eos.Action
        |> required "action_name" actionName
        |> required "type" typeName


{-| -}
actionName : Decoder Eos.ActionName
actionName =
    map Eos.actionName string


{-| -}
table : Decoder Eos.Table
table =
    decode Eos.Table
        |> required "name" tableName
        |> required "index_type" typeName
        |> required "key_names" (list fieldName)
        |> required "key_types" (list typeName)
        |> required "type" typeName


{-| -}
fieldName : Decoder Eos.FieldName
fieldName =
    map Eos.fieldName string


{-| -}
typeName : Decoder Eos.TypeName
typeName =
    map Eos.typeName string


{-| -}
account : Decoder Eos.Account
account =
    decode Eos.Account
        |> required "account_name" accountName
        |> required "eos_balance" shareType
        |> required "staked_balance" shareType
        |> required "unstaking_balance" shareType
        |> required "last_unstaking_time" date
        |> required "permissions" (list permission)


{-| -}
accountName : Decoder Eos.AccountName
accountName =
    map Eos.accountName string


{-| -}
permission : Decoder Eos.Permission
permission =
    decode Eos.Permission
        |> required "perm_name" permissionName
        |> optional "parent" (nullable permissionName) Nothing
        |> required "required_auth" authority


{-| -}
authority : Decoder Eos.Authority
authority =
    decode Eos.Authority
        |> optional "threshold" (nullable int) Nothing
        |> required "keys" (list keyPermissionWeight)
        |> required "accounts" (list accountPermissionWeight)


{-| -}
keyPermissionWeight : Decoder Eos.KeyPermissionWeight
keyPermissionWeight =
    decode Eos.KeyPermissionWeight
        |> required "key" publicKey
        |> required "weight" int


{-| -}
accountPermissionWeight : Decoder Eos.AccountPermissionWeight
accountPermissionWeight =
    decode Eos.AccountPermissionWeight
        |> required "permission" accountPermission
        |> required "weight" int


{-| -}
accountPermission : Decoder Eos.AccountPermission
accountPermission =
    decode Eos.AccountPermission
        |> required "account" accountName
        |> required "permission" permissionName


{-| -}
block : Decoder Eos.Block
block =
    decode Eos.Block
        |> required "previous" blockId
        |> required "timestamp" date
        |> required "transaction_merkle_root" string
        |> required "producer" accountName
        |> required "producer_signature" signature
        |> required "id" blockId
        |> required "block_num" blockNum
        |> required "ref_block_prefix" int


{-| -}
blockId : Decoder Eos.BlockId
blockId =
    map Eos.blockId string


{-| -}
blockNum : Decoder Eos.BlockNum
blockNum =
    map Eos.blockNum int


{-| -}
asset : Decoder Eos.Asset
asset =
    map Eos.asset string


{-| -}
shareType : Decoder Eos.ShareType
shareType =
    map Eos.shareType string


{-| -}
blockRef : Decoder Eos.BlockRef
blockRef =
    oneOf
        [ map Eos.blockNumRef int
        , map Eos.blockIdRef string
        ]


{-| -}
code : Decoder Eos.Code
code =
    decode Eos.Code
        |> required "account_name" accountName
        |> required "code_hash" string
        |> required "wast" string
        |> required "abi" abi


{-| -}
controlledAccounts : Decoder Eos.ControlledAccounts
controlledAccounts =
    decode Eos.ControlledAccounts
        |> required "controlled_accounts" (list accountName)


{-| -}
createdAccount : Decoder Eos.CreatedAccount
createdAccount =
    decode Eos.CreatedAccount
        |> required "creator" accountName
        |> required "name" accountName
        |> required "owner" authority
        |> required "active" authority
        |> required "recovery" authority
        |> required "deposit" asset


{-| -}
info : Decoder Eos.Info
info =
    decode Eos.Info
        |> required "server_version" string
        |> required "head_block_num" blockNum
        |> required "last_irreversible_block_num" blockNum
        |> required "head_block_id" blockId
        |> required "head_block_time" date
        |> required "head_block_producer" accountName
        |> required "recent_slots" string
        |> required "participation_rate" string


{-| -}
keyAccounts : Decoder Eos.KeyAccounts
keyAccounts =
    decode Eos.KeyAccounts
        |> required "account_names" (list accountName)


{-| -}
message : Decoder data -> Decoder (Eos.Message data)
message data =
    decode Eos.Message
        |> required "code" accountName
        |> required "type" funcName
        |> required "authorization" (list accountPermission)
        |> required "data" data


{-| -}
funcName : Decoder Eos.FuncName
funcName =
    map Eos.funcName string


{-| -}
permissionName : Decoder Eos.PermissionName
permissionName =
    map Eos.permissionName string


{-| -}
privateKey : Decoder Eos.PrivateKey
privateKey =
    map Eos.privateKey string


{-| -}
publicKey : Decoder Eos.PublicKey
publicKey =
    map Eos.publicKey string


{-| -}
pushedCode : Decoder Eos.PushedCode
pushedCode =
    decode Eos.PushedCode
        |> required "account" accountName
        |> required "vm_type" int
        |> required "vm_version" int
        |> required "code" string


{-| -}
pushedTransaction : Decoder messageData -> Decoder (Eos.PushedTransaction messageData)
pushedTransaction messageData =
    decode Eos.PushedTransaction
        |> required "transaction_id" transactionId
        |> required "transaction" (transaction messageData)


{-| -}
pushedTransactions : Decoder messageData -> Decoder (Eos.PushedTransactions messageData)
pushedTransactions messageData =
    decode Eos.PushedTransactions
        |> optional "time_limit_exceeded_error" bool False
        |> required "transactions" (list <| pushedTransaction messageData)


{-| -}
signature : Decoder Eos.Signature
signature =
    map Eos.signature string


{-| -}
tableName : Decoder Eos.TableName
tableName =
    map Eos.tableName string


{-| -}
tableRows : Decoder row -> Decoder (Eos.TableRows row)
tableRows rowDecoder =
    decode Eos.TableRows
        |> required "rows" (list rowDecoder)
        |> required "more" bool


{-| -}
transaction : Decoder messageData -> Decoder (Eos.Transaction messageData)
transaction messageData =
    decode Eos.Transaction
        |> required "ref_block_num" blockNum
        |> required "ref_block_prefix" int
        |> required "expiration" date
        |> required "scope" (list accountName)
        |> required "messages" (list <| message messageData)
        |> required "signatures" (list signature)


{-| -}
transactionId : Decoder Eos.TransactionId
transactionId =
    map Eos.transactionId string



-- INTERNAL


date : Decoder Date
date =
    customDecoder Date.fromString string


everyDict : (String -> key) -> Decoder value -> Decoder (EveryDict key value)
everyDict keyFromString valueDecoder =
    map
        (EveryDict.fromList << List.map (\( k, v ) -> ( keyFromString k, v )))
        (keyValuePairs valueDecoder)


customDecoder : (b -> Result String a) -> Decoder b -> Decoder a
customDecoder toResult decoder =
    andThen (toResult >> fromResult) decoder


fromResult : Result String a -> Decoder a
fromResult result =
    case result of
        Ok a ->
            succeed a

        Err msg ->
            fail msg
