Problem 4
---------

Source: http://projecteuler.net/index.php?section=problems&id=4

A palindromic number reads the same both ways. The largest palindrome
made from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit
numbers.

Input: None

Output: 42

Solution
--------

A palindrome is a word that reads the same forward and backward or:

> isPalindrome a = reverse a == a

This problem has baby constraints, we may use a brute-force algorithm,
we might check all the products of two 3-digit numbers:

> problem_4' = maximum [ x*y | x <- [100..999],
>                        y <- [100..999],
>                        isPalindrome . show $ (x * y)]

(here's a little trick: "show a". It is an elegant way to
convert Integer to String in Haskell)

It works, but we can do better. If we look closer, we will see we do a
double work by checking 100*999, and then by checking its good twin
999*100. In other words, we can skip half of the calculations:

> problem_4'' = maximum [ x*y | x <- [100..999],
>                         y <- [x..999],
>                         isPalindrome . show $ (x * y)]

Alright. Now, let's look at our palindrome from the math perspective
to find out a more optimal way to solve this problem. Let m be the
first number and n the second.

The palindrome can be written as: abccba = m*n

Which simplifies to: 100000*a + 10000*b + 1000*c + 100*c + 10*b + a =
m*n

Which equals to: 100001*a + 10010*b + 1100*c = m*n

And factoring out 11, we get: 11 * (9091*a + 910*b + 100*c) = m*n

What does it mean? It means either m or n must be divisible by 11
without a reminder. That leads to another solution, we cycle variable
m with a step 11:

> problem_4''' = maximum [ m * n |
>                    m <- [990,979..110],
>                    n <- [999,998..100],
>                    isPalindrome . show $ (m * n)]

Much better. However, we don't need to calculate all the palindromes.
It would be great if we find the first palindrome and it will be the
answer.

Alright, let's back to the equation: 9091*a + 910*b + 100*c = m*n/11

a, b and c being 1 digit integers and m and n being 3 digit integers
and 100/11 <= m <= 999/11 or 10 <= m <= 99. If we generate all the
palindromes starting from the largest one, then we can take just the
first one from the list and it will be the answer. Lazy evaluation:

> problem_4 = 11 * head [ num a b c |
>                         a <- [9,8..1],
>                         b <- [9,8..0],
>                         c <- [9,8..0],
>                         m <- [90,89..10],
>                         num a b c `mod` m == 0 &&
>                         num a b c `div` m < 1000]
>     where num a b c = 9091*a + 910*b + 100*c

> main = print problem_4

Performance
-----------

real	0m0.752s
user	0m0.676s
sys	0m0.068s
