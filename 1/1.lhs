Problem 1
---------

Source: http://projecteuler.net/index.php?section=problems&id=1

If we list all the natural numbers below 10 that are multiples of 3 or
5, we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.

Input: None

Output: 42

Solution
--------

Well... straightforward.

> problem_1 = sum $ filter (\n -> n `mod` 3 == 0 || n `mod` 5 == 0) [1..999]

> main = print problem_1

Performance
-----------

real    0m0.700s
user    0m0.580s
sys     0m0.112s
