module Codewars.Kata.PrFactors where

import Data.List

prime_factors :: Integer -> String
prime_factors n = intercalate "" . map repetitions . chunks $ primeFactors n
    where
        repetitions [x]        = "(" ++ show x ++ ")"
        repetitions list@(x:_) = "(" ++ show x ++ "**" ++ show (length list) ++ ")"

chunks :: [Integer] -> [[Integer]]
-- implementation of Data.List.group :)
chunks = reverse . foldl groupEqual [] where
    groupEqual (chunk@(y:ys):tail) x | x == y = (x:chunk) : tail
    groupEqual acc x = [x] : acc

isPrime :: Integer -> Bool
isPrime n | n < 2 = False
isPrime n = all (\p -> n `mod` p /= 0) . takeWhile ((<= n) . (^ 2)) $ primes

primes :: [Integer]
primes = 2 : filter isPrime [3,5..]

primeFactors :: Integer -> [Integer]
primeFactors n = iter n primes where
    iter n (p:_) | n < p ^ 2 = [n | n > 1]
    iter n ps@(p:ps') =
        let (d, r) = n `divMod` p
        in if r == 0 then p : iter d ps else iter n ps'

test :: [Bool]
test =
    [ prime_factors(7775460) == "(2**2)(3**3)(5)(7)(11**2)(17)"
    , prime_factors(7919) == "(7919)"
    , prime_factors(17 * 17 * 93 * 677) == "(3)(17**2)(31)(677)"
    , prime_factors(933555431) == "(7537)(123863)"
    , prime_factors(342217392) == "(2**4)(3)(11)(43)(15073)"
    , prime_factors(285852) == "(2**2)(3)(7)(41)(83)"]
