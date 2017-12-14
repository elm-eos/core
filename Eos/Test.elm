module Eos.Test
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
        , messageSamples
        , permission
        , permissionName
        , privateKey
        , publicKey
        , pushedCode
        , pushedTransaction
        , pushedTransactionSamples
        , pushedTransactions
        , pushedTransactionsSamples
        , shareType
        , signature
        , struct
        , table
        , tableName
        , tableRows
        , tableRowsSamples
        , transaction
        , transactionSamples
        , typeDef
        , typeName
        )

{-| Docs

@docs account
@docs accountName
@docs accountPermission
@docs block, blockRef
@docs code, createdAccount
@docs info, pushedTransaction, pushedTransactionSamples, pushedCode
@docs info, message, messageSamples, permissionName
@docs privateKey, publicKey, signature, tableName, tableRows, tableRowsSamples
@docs transaction, transactionSamples
@docs abi, typeDef, struct
@docs accountPermissionWeight, action, actionName
@docs asset, authority, blockId, blockNum
@docs controlledAccounts, fieldName, funcName, keyAccounts
@docs keyPermissionWeight, permission, pushedTransaction, pushedTransactions
@docs pushedTransactionsSamples, shareType, table, typeName

-}

import Eos.Decode as Decode
import Eos.Encode as Encode
import Eos.Fuzz as Fuzz
import Expect
import Fuzz exposing (Fuzzer)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Test exposing (Test, describe, fuzz)


{-| -}
abi : Test
abi =
    tests "Abi" Fuzz.abi Encode.abi Decode.abi


{-| -}
action : Test
action =
    tests "Action" Fuzz.action Encode.action Decode.action


{-| -}
actionName : Test
actionName =
    tests "ActionName" Fuzz.actionName Encode.actionName Decode.actionName


{-| -}
asset : Test
asset =
    tests "Asset" Fuzz.asset Encode.asset Decode.asset


{-| -}
authority : Test
authority =
    tests "Authority" Fuzz.authority Encode.authority Decode.authority


{-| -}
blockId : Test
blockId =
    tests "BlockId" Fuzz.blockId Encode.blockId Decode.blockId


{-| -}
blockNum : Test
blockNum =
    tests "BlockNum" Fuzz.blockNum Encode.blockNum Decode.blockNum


{-| -}
controlledAccounts : Test
controlledAccounts =
    tests "ControlledAccounts"
        Fuzz.controlledAccounts
        Encode.controlledAccounts
        Decode.controlledAccounts


{-| -}
fieldName : Test
fieldName =
    tests "FieldName" Fuzz.fieldName Encode.fieldName Decode.fieldName


{-| -}
funcName : Test
funcName =
    tests "FuncName" Fuzz.funcName Encode.funcName Decode.funcName


{-| -}
keyAccounts : Test
keyAccounts =
    tests "KeyAccounts" Fuzz.keyAccounts Encode.keyAccounts Decode.keyAccounts


{-| -}
keyPermissionWeight : Test
keyPermissionWeight =
    tests "KeyPermissionWeight"
        Fuzz.keyPermissionWeight
        Encode.keyPermissionWeight
        Decode.keyPermissionWeight


{-| -}
permission : Test
permission =
    tests "Permission" Fuzz.permission Encode.permission Decode.permission


{-| -}
accountPermissionWeight : Test
accountPermissionWeight =
    tests "AccountPermissionWeight"
        Fuzz.accountPermissionWeight
        Encode.accountPermissionWeight
        Decode.accountPermissionWeight


{-| -}
typeDef : Test
typeDef =
    tests "TypeDef" Fuzz.typeDef Encode.typeDef Decode.typeDef


{-| -}
struct : Test
struct =
    tests "Struct" Fuzz.struct Encode.struct Decode.struct


{-| -}
shareType : Test
shareType =
    tests "ShareType" Fuzz.shareType Encode.shareType Decode.shareType


{-| -}
table : Test
table =
    tests "Table" Fuzz.table Encode.table Decode.table


{-| -}
typeName : Test
typeName =
    tests "TypeName" Fuzz.typeName Encode.typeName Decode.typeName


{-| -}
account : Test
account =
    tests "Account" Fuzz.account Encode.account Decode.account


{-| -}
accountName : Test
accountName =
    tests "AccountName" Fuzz.accountName Encode.accountName Decode.accountName


{-| -}
accountPermission : Test
accountPermission =
    tests "AccountPermission" Fuzz.accountPermission Encode.accountPermission Decode.accountPermission


{-| -}
block : Test
block =
    tests "Block" Fuzz.block Encode.block Decode.block


{-| -}
blockRef : Test
blockRef =
    tests "BlockRef" Fuzz.block Encode.block Decode.block


{-| -}
code : Test
code =
    tests "Code" Fuzz.code Encode.code Decode.code


{-| -}
createdAccount : Test
createdAccount =
    tests "CreatedAccount" Fuzz.createdAccount Encode.createdAccount Decode.createdAccount


{-| -}
info : Test
info =
    tests "Info" Fuzz.info Encode.info Decode.info


{-| -}
message : String -> Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
message label dataFuzzer encodeData dataDecoder =
    tests
        ("Message (" ++ label ++ ")")
        (Fuzz.message dataFuzzer)
        (Encode.message encodeData)
        (Decode.message dataDecoder)


{-| -}
messageSamples : Test
messageSamples =
    describe "Message Samples"
        [ message "CreatedAccount" Fuzz.createdAccount Encode.createdAccount Decode.createdAccount
        ]


{-| -}
permissionName : Test
permissionName =
    tests "PermissionName" Fuzz.permissionName Encode.permissionName Decode.permissionName


{-| -}
privateKey : Test
privateKey =
    tests "PrivateKey" Fuzz.privateKey Encode.privateKey Decode.privateKey


{-| -}
publicKey : Test
publicKey =
    tests "PublicKey" Fuzz.publicKey Encode.publicKey Decode.publicKey


{-| -}
pushedCode : Test
pushedCode =
    tests "PushedCode" Fuzz.pushedCode Encode.pushedCode Decode.pushedCode


{-| -}
pushedTransaction : String -> Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
pushedTransaction label dataFuzzer encodeData dataDecoder =
    tests
        ("PushedTransaction (" ++ label ++ ")")
        (Fuzz.pushedTransaction dataFuzzer)
        (Encode.pushedTransaction encodeData)
        (Decode.pushedTransaction dataDecoder)


{-| -}
pushedTransactionSamples : Test
pushedTransactionSamples =
    describe "PushedTransaction Samples"
        [ pushedTransaction "CreatedAccount" Fuzz.createdAccount Encode.createdAccount Decode.createdAccount
        ]


{-| -}
pushedTransactions : String -> Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
pushedTransactions label dataFuzzer encodeData dataDecoder =
    tests
        ("PushedTransactions (" ++ label ++ ")")
        (Fuzz.pushedTransactions dataFuzzer)
        (Encode.pushedTransactions encodeData)
        (Decode.pushedTransactions dataDecoder)


{-| -}
pushedTransactionsSamples : Test
pushedTransactionsSamples =
    describe "PushedTransactions Samples"
        [ pushedTransactions "CreatedAccount" Fuzz.createdAccount Encode.createdAccount Decode.createdAccount
        ]


{-| -}
signature : Test
signature =
    tests "Signature" Fuzz.signature Encode.signature Decode.signature


{-| -}
tableName : Test
tableName =
    tests "TableName" Fuzz.tableName Encode.tableName Decode.tableName


{-| -}
tableRows : String -> Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
tableRows label dataFuzzer encodeData dataDecoder =
    tests
        ("TableRows (" ++ label ++ ")")
        (Fuzz.tableRows dataFuzzer)
        (Encode.tableRows encodeData)
        (Decode.tableRows dataDecoder)


{-| -}
tableRowsSamples : Test
tableRowsSamples =
    describe "TableRows Samples"
        [ tableRows "CreatedAccount" Fuzz.createdAccount Encode.createdAccount Decode.createdAccount
        ]


{-| -}
transaction : String -> Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
transaction label dataFuzzer encodeData dataDecoder =
    tests
        ("Transaction (" ++ label ++ ")")
        (Fuzz.transaction dataFuzzer)
        (Encode.transaction encodeData)
        (Decode.transaction dataDecoder)


{-| -}
transactionSamples : Test
transactionSamples =
    describe "Transaction Samples"
        [ tableRows "CreatedAccount" Fuzz.createdAccount Encode.createdAccount Decode.createdAccount ]



-- INTERNAL


tests : String -> Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
tests name fuzzer encode decoder =
    describe name
        [ serialization fuzzer encode decoder
        ]


serialization : Fuzzer thing -> (thing -> Value) -> Decoder thing -> Test
serialization fuzzer encode decoder =
    fuzz fuzzer "serialization" <|
        \thing ->
            case thing |> encode |> Decode.decodeValue decoder of
                Ok _ ->
                    Expect.pass

                Err err ->
                    Expect.fail err
