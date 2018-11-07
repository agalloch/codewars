Write a function that takes a positive integer and returns the next smaller positive integer containing the same digits.

For example:
```
nextSmaller(21) == 12
nextSmaller(531) == 513
nextSmaller(2071) == 2017
```

Return `-1` (for Haskell: return `Nothing`), when there is no smaller number that contains the same digits. Also return `-1` when the next smaller number with the same digits would require the leading digit to be zero:
```
nextSmaller(9) == Nothing
nextSmaller(135) == Nothing
nextSmaller(1027) == Nothing -- 0721 is out since we don't write numbers with leading zeros
```

- some tests will include very large numbers.
- test data only employs positive integers.

[Kata link](https://www.codewars.com/kata/5659c6d896bc135c4c00021e)
