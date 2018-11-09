module Codewars.Kata.BackWardsPrime where

backwardsPrime :: Integer -> Integer -> [Integer]
backwardsPrime start stop = filter reversePrime [start..stop]

reversePrime :: Integer -> Bool
reversePrime n = n > 12 && n /= rev && prime n && prime rev
    where rev = reverseInt n

reverseInt :: Integer -> Integer
reverseInt = read . reverse . show

prime :: Integer -> Bool
prime num
    | num < 2   = False
    | num <= 3  = True
    | even num  = False
    | otherwise = all (\n -> num `mod` n /= 0) [3, 5..squared]
    where squared = floor . sqrt $ fromIntegral num

test :: [Bool]
test =
    [ null $ backwardsPrime 1 11
    , (backwardsPrime 1 31) == [13, 17, 31]
    , (backwardsPrime 1 100) == [13, 17, 31, 37, 71, 73, 79, 97]
    , (backwardsPrime 7000 7100) == [7027, 7043, 7057]
    , (backwardsPrime 70000 70245) == [70001, 70009, 70061, 70079, 70121, 70141, 70163, 70241]
    , (backwardsPrime 70485 70600) == [70489, 70529, 70573, 70589]]
