module Eos.Fuzz
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

@docs accountName, account, createdAccount, code, info
@docs accountPermission
@docs message
@docs permissionName
@docs tableName, tableRows
@docs privateKey
@docs publicKey
@docs signature, transaction
@docs blockRef, block, pushedTransaction, pushedCode

-}

import Date exposing (Date)
import Eos
import Fuzz exposing (..)
import Time exposing (Time)


{-| -}
account : Fuzzer Eos.Account
account =
    map Eos.Account accountName
        |> andMap string
        |> andMap string
        |> andMap string
        |> andMap date


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
    map Eos.Block string
        |> andMap date
        |> andMap string
        |> andMap accountName
        |> andMap string
        |> andMap string
        |> andMap int
        |> andMap int


{-| -}
blockRef : Fuzzer Eos.BlockRef
blockRef =
    oneOf
        [ map Eos.blockNum int
        , map Eos.blockId string
        ]


{-| -}
code : Fuzzer Eos.Code
code =
    map Eos.Code accountName
        |> andMap string
        |> andMap string


{-| -}
createdAccount : Fuzzer Eos.CreatedAccount
createdAccount =
    map Eos.CreatedAccount accountName
        |> andMap accountName
        |> andMap string


{-| -}
info : Fuzzer Eos.Info
info =
    map Eos.Info string
        |> andMap int
        |> andMap int
        |> andMap string
        |> andMap date
        |> andMap accountName
        |> andMap string
        |> andMap string


{-| -}
message : Fuzzer data -> Fuzzer (Eos.Message data)
message data =
    map Eos.Message accountName
        |> andMap string
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
    map Eos.PushedCode accountName
        |> andMap int
        |> andMap int
        |> andMap string


{-| -}
pushedTransaction : Fuzzer data -> Fuzzer (Eos.PushedTransaction data)
pushedTransaction data =
    map Eos.PushedTransaction string
        |> andMap (transaction data)


{-| -}
transaction : Fuzzer data -> Fuzzer (Eos.Transaction data)
transaction data =
    map Eos.Transaction int
        |> andMap int
        |> andMap date
        |> andMap (list accountName)
        |> andMap (list <| message data)
        |> andMap (list string)


{-| -}
signature : Fuzzer Eos.Signature
signature =
    map Eos.signature string


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


time : Fuzzer Time
time =
    map ((*) Time.second) <| Fuzz.floatRange 0 2524608000


date : Fuzzer Date
date =
    map Date.fromTime time
