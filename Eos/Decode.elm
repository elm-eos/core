module Eos.Decode
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
        , permissionName
        , privateKey
        , publicKey
        , pushedCode
        , pushedTransaction
        , signature
        , tableName
        , tableRows
        , transaction
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
@docs permissionName
@docs privateKey
@docs publicKey
@docs pushedCode
@docs pushedTransaction
@docs signature
@docs tableName
@docs tableRows
@docs transaction

-}

import Date exposing (Date)
import Eos
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


{-| -}
account : Decoder Eos.Account
account =
    decode Eos.Account
        |> required "account_name" accountName
        |> required "eos_balance" string
        |> required "staked_balance" string
        |> required "unstaking_balance" string
        |> required "last_unstaking_time" date


{-| -}
accountName : Decoder Eos.AccountName
accountName =
    map Eos.accountName string


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
        |> required "previous" string
        |> required "timestamp" date
        |> required "transaction_merkle_root" string
        |> required "producer" accountName
        |> required "producer_signature" string
        |> required "id" string
        |> required "block_num" int
        |> required "ref_block_prefix" int


{-| -}
blockRef : Decoder Eos.BlockRef
blockRef =
    oneOf
        [ map Eos.blockNum int
        , map Eos.blockId string
        ]


{-| -}
code : Decoder Eos.Code
code =
    decode Eos.Code
        |> required "account_name" accountName
        |> required "code_hash" string
        |> required "wast" string


{-| -}
createdAccount : Decoder Eos.CreatedAccount
createdAccount =
    decode Eos.CreatedAccount
        |> required "creator" accountName
        |> required "name" accountName
        |> required "deposit" string


{-| -}
info : Decoder Eos.Info
info =
    decode Eos.Info
        |> required "server_version" string
        |> required "head_block_num" int
        |> required "last_irreversible_block_num" int
        |> required "head_block_id" string
        |> required "head_block_time" date
        |> required "head_block_producer" accountName
        |> required "recent_slots" string
        |> required "participation_rate" string

{-| -}
message : Decoder data -> Decoder (Eos.Message data)
message data =
    decode Eos.Message
        |> required "code" accountName
        |> required "type" string
        |> required "authorization" (list accountPermission)
        |> required "data" data


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
        |> required "transaction_id" string
        |> required "transaction" (transaction messageData)


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
        |> required "ref_block_num" int
        |> required "ref_block_prefix" int
        |> required "expiration" date
        |> required "scope" (list accountName)
        |> required "messages" (list <| message messageData)
        |> required "signatures" (list string)



-- INTERNAL


date : Decoder Date
date =
    customDecoder Date.fromString string


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
