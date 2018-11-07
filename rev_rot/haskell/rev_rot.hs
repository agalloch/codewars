module Codewars.Revrot where

import Data.Char

revRot :: [Char] -> Int -> [Char]
revRot "" _ = ""
revRot str sz
    | sz <= 0 = ""
    | sz > length str = ""
    | otherwise =
      (concat . map rotOrRev . filter (\chunk -> length chunk == sz))
      $ chunks sz str

rotOrRev xs
    | (even . cubesum) xs = reverse xs
    | otherwise = tail xs ++ [head xs]

cubesum :: [Char] -> Int
cubesum xs = foldl (\acc x -> acc + (digitToInt x :: Int) ^ 3) 0 xs

chunks _ [] = []
chunks n xs = [take n xs] ++ chunks n (drop n xs)

testRevRotTooShort = (revRot "1234" 0) == ""
testRevRotEmpty = (revRot "" 5) == ""
testRevRotTooLong = (revRot "1234" 5) == ""
testRevRot = (revRot "733049910872815764" 5) == "330479108928157"
