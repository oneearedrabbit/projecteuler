Problem 9
---------

Source: http://projecteuler.net/index.php?section=problems&id=9

A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
a^2 + b^2 = c^2

For example, 3^2 + 4^2 = 9 + 16 = 25 = 52.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.

Input:
None

Output:
31875000

Solution
--------

> side = 1000

> problem_9 = head [a * b * (side - a - b) | a <- [1..side `div` 3], b <- [(a+1)..side], a^2 + b^2 == (side - a - b)^2, b < side - a - b]

> main = print problem_9
