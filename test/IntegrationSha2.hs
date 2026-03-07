module Main (main) where

import Test.Tasty (defaultMain, testGroup)
import qualified CachingSha2

main :: IO ()
main = defaultMain $ testGroup "mysql-sha2-integration" [CachingSha2.tests]
