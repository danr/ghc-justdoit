{-# OPTIONS_GHC -fplugin=GHC.JustDoIt.Plugin #-}
{-# OPTIONS_GHC -fplugin=Test.Inspection.Plugin #-}
{-# LANGUAGE TemplateHaskell, LambdaCase, EmptyCase #-}
import GHC.JustDoIt
import Test.Inspection

import Prelude hiding (id, flip, const, curry)

-- Some auxillary definitions

data Unit = Unit
data Void
data MyLargeSum a b c d e = MkA a | MkB b | MkC c | MkD d | MkE e
newtype Id a = Id a

-- All these functions have basically one sensible implementation.
-- With GHC.JustDoIt, we don’t have to write them.

id :: a -> a
id = justDoIt

const :: a -> b -> a
const = (…)

flip :: (a -> b -> c) -> (b -> a -> c)
flip = (…)

dup :: a -> (a,a)
dup = (…)

pair :: a -> b -> (a,b)
pair = (…)

tripl :: a -> b -> c -> (a,b,c)
tripl = (…)

proj :: (a,b,c,d) -> c
proj = (…)

curry :: ((a,b) -> c) -> a -> b -> c
curry = (…)

curryFlip :: ((a,b) -> c) -> b -> a -> c
curryFlip = (…)

contBind :: ((a -> r) -> r) -> (a -> ((b -> r) -> r)) -> ((b -> r) -> r)
contBind = (…)

unit :: Unit
unit = (…)

swapEither :: Either a b -> Either b a
swapEither = (…)

swapEitherCont :: (((Either a b) -> r) -> r) -> (((Either b a) -> r) -> r)
swapEitherCont = (…)

randomCrap :: (a -> b) -> (a,c,d) -> (d,b,b)
randomCrap = (…)

absurd :: Void -> a
absurd = (…)

convert :: MyLargeSum a b c d e -> Either a (Either b (Either c (Either d e)))
convert = (…)

mapId :: (a -> b) -> Id a -> Id b
mapId = (…)

-- Just for comparison, here are the implementations that you might write by
-- hand

id' x = x
const' x _= x
flip' f a b = f b a
dup' x = (x,x)
pair' x y = (x,y)
tripl' x y z = (x,y,z)
proj' (_,_,c,_) = c
curry' f a b = f (a,b)
curryFlip' f a b = f (b,a)
unit' = Unit
contBind' :: ((a -> r) -> r) -> (a -> ((b -> r) -> r)) -> ((b -> r) -> r)
contBind' ca cb k = ca (\a -> cb a k)
swapEither' (Left a) = (Right a)
swapEither' (Right a) = (Left a)
swapEitherCont' :: (((Either a b) -> r) -> r) -> (((Either b a) -> r) -> r)
swapEitherCont' ca k = ca $ \case Left a -> k (Right a)
                                  Right a -> k (Left a)
absurd' :: Void -> a
absurd' = \case{}
mapId' f (Id x) = Id (f x)

-- And here we use inspection-testing to check that these are indeed the
-- definitions that GHC.JustDoIt created for us.

inspect $ 'id             === 'id'
inspect $ 'const          === 'const'
inspect $ 'flip           === 'flip'
inspect $ 'dup            === 'dup'
inspect $ 'pair           === 'pair'
inspect $ 'tripl          === 'tripl'
inspect $ 'proj           === 'proj'
inspect $ 'curry          === 'curry'
inspect $ 'curryFlip      === 'curryFlip'
inspect $ 'unit           === 'unit'
inspect $ 'contBind       === 'contBind'
inspect $ 'swapEither     === 'swapEither'
inspect $ 'swapEitherCont === 'swapEitherCont'
inspect $ 'absurd         === 'absurd'
inspect $ 'mapId          === 'mapId'

main :: IO ()
main = putStrLn "☺"
