module Eos.Test
    exposing
        ( account
        , accountName
        , accountPermission
        , block
        , blockRef
        , code
        , createdAccount
        , info
        , message
        , messageSamples
        , permissionName
        , privateKey
        , publicKey
        , pushedCode
        , pushedTransaction
        , pushedTransactionSamples
        , signature
        , tableName
        , tableRows
        , tableRowsSamples
        , transaction
        , transactionSamples
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
            thing
                |> encode
                |> Decode.decodeValue decoder
                |> Expect.equal (Ok thing)
