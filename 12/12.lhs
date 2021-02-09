Problem 12
----------

Source: http://projecteuler.net/index.php?section=problems&id=12

The sequence of triangle numbers is generated by adding the natural numbers. So the 7th triangle number would be 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28. The first ten terms would be:

1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...

Let us list the factors of the first seven triangle numbers:

     1: 1
     3: 1,3
     6: 1,2,3,6
    10: 1,2,5,10
    15: 1,3,5,15
    21: 1,3,7,21
    28: 1,2,4,7,14,28

We can see that 28 is the first triangle number to have over five divisors.

What is the value of the first triangle number to have over five hundred divisors?

Input:
None

Output:


Solution
--------

> import Data.List.Ordered (minus,union)

> triangleNumbers = [sum [1..n] | n <- [1..]]

> primes = 2: 3: [5,7..] `minus` foldr union' []
>          [ [p*p,p*p+2*p..] | p<- tail primes ]
>     where
>     union' (q:qs) xs = q : union qs xs

> divisors n = [x | x <- takeWhile (\x -> 2*x < n) primes, n `mod` x == 0]

> uniq_divisors n = filter (< n `div` head d) d
>     where 
>     d = divisors n

> length_divisors n = 2 + 2 * (length . uniq_divisors $ n)

> problem_12 = last $ takeWhile (\x -> length_divisors x <= 6) triangleNumbers

> main = print $ problem_12

triangle1 = scanl (+) 1 [2..]
triangle2 = 1 : [x+y | x <- [2..] | y <- triangle2]