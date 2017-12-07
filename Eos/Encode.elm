module Eos.Encode
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
@docs signature
@docs blockRef, block
@docs transaction
@docs pushedCode, pushedTransaction

-}

import Date exposing (Date)
import Date.Extra
import Eos
import Json.Encode exposing (..)


{-| -}
account : Eos.Account -> Value
account a =
    object
        [ ( "account_name", accountName a.accountName )
        , ( "eos_balance", string a.eosBalance )
        , ( "staked_balance", string a.stakedBalance )
        , ( "unstaking_balance", string a.unstakingBalance )
        , ( "last_unstaking_time", date a.lastUnstakingTime )
        ]


{-| -}
accountName : Eos.AccountName -> Value
accountName =
    Eos.accountNameToString >> string


{-| -}
accountPermission : Eos.AccountPermission -> Value
accountPermission { account, permission } =
    object
        [ ( "account", accountName account )
        , ( "permission", permissionName permission )
        ]


{-| -}
block : Eos.Block -> Value
block b =
    object
        [ ( "previous", string b.previous )
        , ( "timestamp", date b.timestamp )
        , ( "transaction_merkle_root", string b.transactionMerkleRoot )
        , ( "producer", accountName b.producer )
        , ( "producer_signature", string b.producerSignature )
        , ( "id", string b.id )
        , ( "block_num", int b.blockNum )
        , ( "ref_block_prefix", int b.refBlockPrefix )
        ]


{-| -}
blockRef : Eos.BlockRef -> Value
blockRef br =
    case br of
        Eos.BlockNum i ->
            int i

        Eos.BlockId s ->
            string s


{-| -}
code : Eos.Code -> Value
code c =
    object
        [ ( "account_name", accountName c.accountName )
        , ( "code_hash", string c.codeHash )
        , ( "wast", string c.wast )
        ]


{-| -}
createdAccount : Eos.CreatedAccount -> Value
createdAccount a =
    object
        [ ( "creator", accountName a.creator )
        , ( "name", accountName a.name )
        , ( "deposit", string a.deposit )
        ]


{-| -}
info : Eos.Info -> Value
info i =
    object
        [ ( "server_version", string i.serverVersion )
        , ( "head_block_num", int i.headBlockNum )
        , ( "last_irreversible_block_num", int i.lastIrreversibleBlockNum )
        , ( "head_block_id", string i.headBlockId )
        , ( "head_block_time", date i.headBlockTime )
        , ( "head_block_producer", accountName i.headBlockProducer )
        , ( "recent_slots", string i.recentSlots )
        , ( "participation_rate", string i.participationRate )
        ]


{-| -}
message : (data -> Value) -> Eos.Message data -> Value
message data msg =
    object
        [ ( "code", accountName msg.code )
        , ( "type", string msg.type_ )
        , ( "authorization", list <| List.map accountPermission msg.authorization )
        , ( "data", data msg.data )
        ]


{-| -}
permissionName : Eos.PermissionName -> Value
permissionName =
    Eos.permissionNameToString >> string


{-| -}
pushedCode : Eos.PushedCode -> Value
pushedCode c =
    object
        [ ( "account", accountName c.account )
        , ( "vm_type", int c.vmType )
        , ( "vm_version", int c.vmVersion )
        , ( "code", string c.code )
        ]


{-| -}
pushedTransaction : (msgData -> Value) -> Eos.PushedTransaction msgData -> Value
pushedTransaction msgData t =
    object
        [ ( "transaction_id", string t.transactionId )
        , ( "transaction", transaction msgData t.transaction )
        ]


{-| -}
privateKey : Eos.PrivateKey -> Value
privateKey =
    Eos.privateKeyToString >> string


{-| -}
publicKey : Eos.PublicKey -> Value
publicKey =
    Eos.publicKeyToString >> string


{-| -}
signature : Eos.Signature -> Value
signature =
    Eos.signatureToString >> string


{-| -}
tableName : Eos.TableName -> Value
tableName =
    Eos.tableNameToString >> string


{-| -}
tableRows : (row -> Value) -> Eos.TableRows row -> Value
tableRows row t =
    object
        [ ( "rows", list <| List.map row t.rows )
        , ( "more", bool t.more )
        ]


{-| -}
transaction : (msgData -> Value) -> Eos.Transaction msgData -> Value
transaction msgData t =
    object
        [ ( "ref_block_num", int t.refBlockNum )
        , ( "ref_block_prefix", int t.refBlockPrefix )
        , ( "expiration", date t.expiration )
        , ( "scope", list <| List.map accountName t.scope )
        , ( "messages", list <| List.map (message msgData) t.messages )
        , ( "signatures", list <| List.map string t.signatures )
        ]



-- INTERNAL


date : Date -> Value
date d =
    d
        |> Date.Extra.toIsoString
        |> string
