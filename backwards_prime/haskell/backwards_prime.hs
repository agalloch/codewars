module Codewars.Kata.BackWardsPrime where

backwardsPrime :: Integer -> Integer -> [Integer]
backwardsPrime start stop = filter reversePrime [start..stop]

reversePrime :: Integer -> Bool
reversePrime n = n > 12 && n /= rev && prime n && prime rev
    where rev = reverseInt n

infinitePalindromePrime :: Integer -> [Integer]
infinitePalindromePrime start = filter palindromeAndPrime [start..]

palindromePrimes :: Integer -> Integer -> [Integer]
palindromePrimes start stop = takeWhile (<= stop) $ infinitePalindromePrime start

palindromeAndPrime :: Integer -> Bool
palindromeAndPrime n = n == rev && prime n
    where rev = reverseInt n

reverseInt :: Integer -> Integer
reverseInt = read . reverse . show

prime :: Integer -> Bool
prime num
    | num < 2   = False
    | num <= 3  = True
    | even num  = False
    | otherwise = all (\n -> num `mod` n /= 0) [3, 5..square_root]
    where square_root = floor . sqrt $ fromIntegral num

test :: [Bool]
test =
    [ null $ backwardsPrime 1 11
    , (backwardsPrime 1 31) == [13, 17, 31]
    , (backwardsPrime 1 100) == [13, 17, 31, 37, 71, 73, 79, 97]
    , (backwardsPrime 7000 7100) == [7027, 7043, 7057]
    , (backwardsPrime 70000 70245) == [70001, 70009, 70061, 70079, 70121, 70141, 70163, 70241]
    , (backwardsPrime 70485 70600) == [70489, 70529, 70573, 70589]]

testPalindromes :: [Bool]
testPalindromes =
    [ (palindromePrimes 1 31) == [2, 3, 5, 7, 11]
    , (palindromePrimes 1 200) == [2, 3, 5, 7, 11, 101, 131, 151, 181, 191]
    , (palindromePrimes 1 94052) == [2, 3, 5, 7, 11, 101, 131, 151, 181, 191, 313, 353, 373, 383,
                                     727, 757, 787, 797, 919, 929, 10301, 10501, 10601, 11311, 11411,
                                     12421, 12721, 12821, 13331, 13831, 13931, 14341, 14741, 15451,
                                     15551, 16061, 16361, 16561, 16661, 17471, 17971, 18181, 18481,
                                     19391, 19891, 19991, 30103, 30203, 30403, 30703, 30803, 31013,
                                     31513, 32323, 32423, 33533, 34543, 34843, 35053, 35153, 35353,
                                     35753, 36263, 36563, 37273, 37573, 38083, 38183, 38783, 39293,
                                     70207, 70507, 70607, 71317, 71917, 72227, 72727, 73037, 73237,
                                     73637, 74047, 74747, 75557, 76367, 76667, 77377, 77477, 77977,
                                     78487, 78787, 78887, 79397, 79697, 79997, 90709, 91019, 93139,
                                     93239, 93739, 94049]
    , (take 15 $ infinitePalindromePrime 1) == [2, 3, 5, 7, 11, 101, 131, 151, 181, 191, 313, 353, 373, 383, 727]
    , (take 100 $ infinitePalindromePrime 55) == [101, 131, 151, 181, 191, 313, 353, 373, 383, 727, 757, 787,
                                                  797, 919, 929, 10301, 10501, 10601, 11311, 11411, 12421,
                                                  12721, 12821, 13331, 13831, 13931, 14341, 14741, 15451,
                                                  15551, 16061, 16361, 16561, 16661, 17471, 17971, 18181,
                                                  18481, 19391, 19891, 19991, 30103, 30203, 30403, 30703,
                                                  30803, 31013, 31513, 32323, 32423, 33533, 34543, 34843,
                                                  35053, 35153, 35353, 35753, 36263, 36563, 37273, 37573,
                                                  38083, 38183, 38783, 39293, 70207, 70507, 70607, 71317,
                                                  71917, 72227, 72727, 73037, 73237, 73637, 74047, 74747,
                                                  75557, 76367, 76667, 77377, 77477, 77977, 78487, 78787,
                                                  78887, 79397, 79697, 79997, 90709, 91019, 93139, 93239,
                                                  93739, 94049, 94349, 94649, 94849, 94949, 95959]]
