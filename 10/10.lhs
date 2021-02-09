Problem 10
----------

Source: http://projecteuler.net/index.php?section=problems&id=10

The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

Find the sum of all the primes below two million.

Input:
None

Output:
142913828922

Solution
--------

> import Data.List.Ordered (minus,union)

> primes = 2: 3: [5,7..] `minus` foldr union' []
>          [ [p*p,p*p+2*p..] | p<- tail primes ]
>     where
>     union' (q:qs) xs = q : union qs xs

> problem_10 = sum $ takeWhile (<=2000000) primes

> main = print problem_10
