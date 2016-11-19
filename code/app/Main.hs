module Main where

import Lib
import Control.Monad.Cont

main :: IO ()
main = do
  runContT contMain (return)

contMain :: ContT () IO ()
contMain = do
  trace "contMain starting"
  x <- funcA
  trace $ "contMain: funcA returned " ++ show x
  y <- callCC funcB
  trace $ "contMain: funcB returned " ++ show y

  z <- callCC funcC
  trace $ "contMain: funcC returned " ++ show z

  trace "contMain finished"

funcA = do
  trace "funcA - inside"
  return 3 -- the returned value is the value of the last statement in the do block

-- we can return early...
funcB return' = do
  trace "funcB - inside"
  return' 7
  trace "funcB - part 2"
  return 10

-- and we can return from deep inside a
-- nested function. like throwing an
-- exception.

funcC return' = do
  trace "funcC - inside"
  funcC2 return'
  trace "funcC - step 2"
  return 20

funcC2 return' = do
  trace "funcC2 - inside"
  return' 21
  trace "funcC2 - step 2"


trace = liftIO . putStrLn
