Problem 6
---------

Source: http://projecteuler.net/index.php?section=problems&id=6

The sum of the squares of the first ten natural numbers is, 1^2 + 2^2
+ ... + 10^2 = 385

The square of the sum of the first ten natural numbers is, (1 + 2 +
... + 10)^2 = 55^2 = 3025

Hence the difference between the sum of the squares of the first ten
natural numbers and the square of the sum is 3025 − 385 = 2640.

Find the difference between the sum of the squares of the first one
hundred natural numbers and the square of the sum.

Input: None

Output: 42

Solution
--------

As usual let's start with a brute-force algorithm.

For the given range from 1 to 100...

> range = [1..100]

...we need to find the sum of the squares...

> sumOfSquares' = sum $ map (^2) range

...then find the squares of the sum...

> squareOfSum' = (^2) $ sum range

...and calculate the difference.

> problem_6' = sumOfSquares' - squareOfSum'

Nevertheless, it is well known that the sum of the range from 1 to n
can be calculated by the formula n*(n+1)/2, i.e. if we have a sequence
[1,2,3,4] we may write it as:

  1 2 3 4
+ 4 3 2 1
= 5 5 5 5

This is a triangular number and it gives us another implementation for
the square of the sum.

> squareOfSum'' = let n = last range
>                     sum = n*(n+1) `div` 2
>                 in sum^2

Pretty much the same we can do with the second function with only
difference that the sum of the squares is pyramidical number and it is
calculated by formula: n*(n+1)*(2*n+1)/6.

> sumOfSquares'' = let n = last range
>                  in n*(n+1)*(2*n+1) `div` 6

Actually, both triangular and pyramidical numbers are special cases of
Faulhaber's formula (the first and the second degrees
correspondingly).

> problem_6'' = sumOfSquares'' - squareOfSum''

Ultimately, as we know math formulas we can solve this problem
mathematically: (n*(n+1)/2)^2 - n*(n+1)*(2*n+1)/6.

Which equals to: n^2*(n^2+2*n+1)/4 - 2*n^3/6 - 3*n^2/6 - n/6

Which simplifies to: 3*n^4/12 + 6*n^3/12 + 3*n^2/12 - 4*n^3/12 -
6*n^2/12 - 2*n/12

Hence, the answer is: (3*n^4 + 2*n^3 - 3*n^2 - 2*n)/12

> problem_6 = let n = last range
>             in (3*n^4 + 2*n^3 - 3*n^2 - 2*n) `div` 12

> main = print problem_6

Performance
-----------

real	0m0.649s
user	0m0.564s
sys	0m0.080s
