{-# LANGUAGE ScopedTypeVariables #-}

module CachingSha2 (tests) where

import Database.MySQL.Base
import qualified System.IO.Streams as Stream
import Test.Tasty
import Test.Tasty.HUnit

tests :: TestTree
tests = testGroup "caching_sha2_password"
    [ testCaseSteps "SHA256 fast auth" $ \step -> do
        step "connecting as testMySQLHaskellSha2 (caching_sha2_password)..."
        (_, c) <- connectDetail defaultConnectInfo
            { ciUser = "testMySQLHaskellSha2"
            , ciPassword = "testPassword123"
            , ciDatabase = "testMySQLHaskell"
            }

        step "executing SELECT 1..."
        (_, is) <- query_ c "SELECT 1"
        Just row <- Stream.read is
        assertBool "SELECT 1 returns 1" (row == [MySQLInt32 1] || row == [MySQLInt64 1])
        Stream.skipToEof is

        close c

    , testCaseSteps "AuthSwitchRequest handling (mysql_native_password on sha2 server)" $ \step -> do
        step "connecting as testMySQLHaskellNative (mysql_native_password)..."
        (_, c) <- connectDetail defaultConnectInfo
            { ciUser = "testMySQLHaskellNative"
            , ciPassword = "nativePass123"
            , ciDatabase = "testMySQLHaskell"
            }

        step "executing SELECT 1..."
        (_, is) <- query_ c "SELECT 1"
        Just row <- Stream.read is
        assertBool "SELECT 1 returns 1" (row == [MySQLInt32 1] || row == [MySQLInt64 1])
        Stream.skipToEof is

        close c
    ]
