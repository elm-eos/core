module Eos.Encode
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
@docs signature
@docs blockRef, block
@docs transaction, transactionId
@docs pushedCode, pushedTransaction, pushedTransactions
@docs controlledAccounts, keyAccounts
@docs blockId, blockNum, asset, shareType
@docs abi, accountPermissionWeight, action, actionName, authority
@docs fieldName, funcName, keyPermissionWeight, permission, table, typeDef
@docs struct, typeName

-}

import Date exposing (Date)
import Date.Extra
import Eos
import EveryDict exposing (EveryDict)
import Json.Encode exposing (..)


{-| -}
abi : Eos.Abi -> Value
abi a =
    object
        [ ( "types", list <| List.map typeDef a.types )
        , ( "structs", list <| List.map struct a.structs )
        , ( "actions", list <| List.map action a.actions )
        , ( "tables", list <| List.map table a.tables )
        ]


{-| -}
typeDef : Eos.TypeDef -> Value
typeDef t =
    object
        [ ( "new_type_name", typeName t.newTypeName )
        , ( "type", typeName t.type_ )
        ]


{-| -}
struct : Eos.Struct -> Value
struct s =
    object
        [ ( "name", typeName s.name )
        , ( "base", maybe typeName s.base )
        , ( "fields", everyDict Eos.fieldNameString typeName s.fields )
        ]


{-| -}
action : Eos.Action -> Value
action a =
    object
        [ ( "action_name", actionName a.actionName )
        , ( "type", typeName a.type_ )
        ]


{-| -}
actionName : Eos.ActionName -> Value
actionName =
    Eos.actionNameString >> string


{-| -}
typeName : Eos.TypeName -> Value
typeName =
    Eos.typeNameString >> string


{-| -}
account : Eos.Account -> Value
account a =
    object
        [ ( "account_name", accountName a.accountName )
        , ( "eos_balance", shareType a.eosBalance )
        , ( "staked_balance", shareType a.stakedBalance )
        , ( "unstaking_balance", shareType a.unstakingBalance )
        , ( "last_unstaking_time", date a.lastUnstakingTime )
        , ( "permissions", list <| List.map permission a.permissions )
        ]


{-| -}
permission : Eos.Permission -> Value
permission p =
    object
        [ ( "perm_name", permissionName p.permName )
        , ( "parent", maybe permissionName p.parent )
        , ( "required_auth", authority p.requiredAuth )
        ]


{-| -}
authority : Eos.Authority -> Value
authority a =
    object
        [ ( "threshold", maybe int a.threshold )
        , ( "keys", list <| List.map keyPermissionWeight a.keys )
        , ( "accounts", list <| List.map accountPermissionWeight a.accounts )
        ]


{-| -}
keyPermissionWeight : Eos.KeyPermissionWeight -> Value
keyPermissionWeight k =
    object
        [ ( "key", publicKey k.key )
        , ( "weight", int k.weight )
        ]


{-| -}
accountPermissionWeight : Eos.AccountPermissionWeight -> Value
accountPermissionWeight a =
    object
        [ ( "permission", accountPermission a.permission )
        , ( "weight", int a.weight )
        ]


{-| -}
shareType : Eos.ShareType -> Value
shareType =
    Eos.shareTypeString >> string


{-| -}
accountName : Eos.AccountName -> Value
accountName =
    Eos.accountNameString >> string


{-| -}
accountPermission : Eos.AccountPermission -> Value
accountPermission { account, permission } =
    object
        [ ( "account", accountName account )
        , ( "permission", permissionName permission )
        ]


{-| -}
asset : Eos.Asset -> Value
asset =
    Eos.assetString >> string


{-| -}
block : Eos.Block -> Value
block b =
    object
        [ ( "previous", blockId b.previous )
        , ( "timestamp", date b.timestamp )
        , ( "transaction_merkle_root", string b.transactionMerkleRoot )
        , ( "producer", accountName b.producer )
        , ( "producer_signature", signature b.producerSignature )
        , ( "id", blockId b.id )
        , ( "block_num", blockNum b.blockNum )
        , ( "ref_block_prefix", int b.refBlockPrefix )
        ]


{-| -}
blockRef : Eos.BlockRef -> Value
blockRef br =
    case br of
        Eos.BlockNumRef x ->
            blockNum x

        Eos.BlockIdRef x ->
            blockId x


{-| -}
blockId : Eos.BlockId -> Value
blockId =
    Eos.blockIdString >> string


{-| -}
blockNum : Eos.BlockNum -> Value
blockNum =
    Eos.blockNumInt >> int


{-| -}
code : Eos.Code -> Value
code c =
    object
        [ ( "account_name", accountName c.accountName )
        , ( "code_hash", string c.codeHash )
        , ( "wast", string c.wast )
        , ( "abi", abi c.abi )
        ]


{-| -}
controlledAccounts : Eos.ControlledAccounts -> Value
controlledAccounts c =
    object
        [ ( "controlled_accounts", list <| List.map accountName c.controlledAccounts ) ]


{-| -}
createdAccount : Eos.CreatedAccount -> Value
createdAccount a =
    object
        [ ( "creator", accountName a.creator )
        , ( "name", accountName a.name )
        , ( "owner", authority a.owner )
        , ( "active", authority a.active )
        , ( "recovery", authority a.recovery )
        , ( "deposit", asset a.deposit )
        ]


{-| -}
keyAccounts : Eos.KeyAccounts -> Value
keyAccounts c =
    object
        [ ( "account_names", list <| List.map accountName c.accountNames ) ]


{-| -}
info : Eos.Info -> Value
info i =
    object
        [ ( "server_version", string i.serverVersion )
        , ( "head_block_num", blockNum i.headBlockNum )
        , ( "last_irreversible_block_num", blockNum i.lastIrreversibleBlockNum )
        , ( "head_block_id", blockId i.headBlockId )
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
        , ( "type", funcName msg.type_ )
        , ( "authorization", list <| List.map accountPermission msg.authorization )
        , ( "data", data msg.data )
        ]


{-| -}
funcName : Eos.FuncName -> Value
funcName =
    Eos.funcNameString >> string


{-| -}
fieldName : Eos.FieldName -> Value
fieldName =
    Eos.fieldNameString >> string


{-| -}
permissionName : Eos.PermissionName -> Value
permissionName =
    Eos.permissionNameString >> string


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
        [ ( "transaction_id", transactionId t.transactionId )
        , ( "transaction", transaction msgData t.transaction )
        ]


{-| -}
pushedTransactions : (msgData -> Value) -> Eos.PushedTransactions msgData -> Value
pushedTransactions msgData t =
    object
        [ ( "time_limit_exceeded_error", bool t.timeLimitExceededError )
        , ( "transactions", list <| List.map (pushedTransaction msgData) t.transactions )
        ]


{-| -}
privateKey : Eos.PrivateKey -> Value
privateKey =
    Eos.privateKeyString >> string


{-| -}
publicKey : Eos.PublicKey -> Value
publicKey =
    Eos.publicKeyString >> string


{-| -}
signature : Eos.Signature -> Value
signature =
    Eos.signatureString >> string


{-| -}
table : Eos.Table -> Value
table t =
    object
        [ ( "name", tableName t.name )
        , ( "index_type", typeName t.indexType )
        , ( "key_names", list <| List.map fieldName t.keyNames )
        , ( "key_types", list <| List.map typeName t.keyTypes )
        , ( "type", typeName t.type_ )
        ]


{-| -}
tableName : Eos.TableName -> Value
tableName =
    Eos.tableNameString >> string


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
        [ ( "ref_block_num", blockNum t.refBlockNum )
        , ( "ref_block_prefix", int t.refBlockPrefix )
        , ( "expiration", date t.expiration )
        , ( "scope", list <| List.map accountName t.scope )
        , ( "messages", list <| List.map (message msgData) t.messages )
        , ( "signatures", list <| List.map signature t.signatures )
        ]


{-| -}
transactionId : Eos.TransactionId -> Value
transactionId =
    Eos.transactionIdString >> string



-- INTERNAL


everyDict : (key -> String) -> (value -> Value) -> EveryDict key value -> Value
everyDict keyToString valueToValue e =
    e
        |> EveryDict.toList
        |> List.map (\( k, v ) -> ( keyToString k, valueToValue v ))
        |> object


maybe : (thing -> Value) -> Maybe thing -> Value
maybe toValue maybeThing =
    maybeThing
        |> Maybe.map toValue
        |> Maybe.withDefault null


date : Date -> Value
date d =
    d
        |> Date.Extra.toIsoString
        |> string
