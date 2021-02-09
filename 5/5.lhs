Problem 5
---------

Source: http://projecteuler.net/index.php?section=problems&id=5

2520 is the smallest number that can be divided by each of the numbers
from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all
of the numbers from 1 to 20?

Input: None

Output: 42

Solution
--------

The most stupid solution I was able to think up is to find all factors
of the numbers from 1 to 20. Somehow merge them and then find the
product of the resulting list. Furthermore, we have already solved the
problem of prime factors before. Let's reuse our code from the problem
3:

> import Data.List 

> primeFactors = factors primes
>     where factors (x:xs) n | x*x > n = [n]
>                            | n `mod` x /= 0 = factors xs n
>                            | otherwise = x : factors (x:xs) (n `div` x)
>           primes = 2 : filter ((==1) . length . primeFactors) [3,5..]

Excellent, now we can apply that function to the given range:

> f_list = map (primeFactors) [1..20]

Further, we need to merge all the factors, i.e. let [2,2,5] be the
first list and [2,3,5] the second list. Our function needs to return
new list [2,2,3,5] since 3 is an unique number, both lists includes 2,
but the first one has two 2 numbers and 5 exists in both lists.

To be honest, nothing comes to my mind from the standard Haskell
libraries, so let's write our own function.

> merge xs ys = merge' xs ys []
>     where merge' [] ys acc = acc ++ ys
>           merge' xs [] acc = acc ++ xs
>           merge' ax@(x:xs) ay@(y:ys) acc | x == y = merge' xs ys (x:acc)
>                                          | x > y = merge' ax ys (y:acc)
>                                          | otherwise = merge' xs ay (x:acc)

Ultimately, we need to fold of the list with this function and get the
product of the list. It will be the answer of the problem.

> problem_5' = product $ foldl1 (merge . sort) $ map (primeFactors) [1..20]

Two concerns about this algorithm I have: (a) we must sort factors
before we can merge them (but I can get by with the sort function for
now) and (b) it looks massive, not cool.

On the second thought, what merge function is doing is grouping and
filtering the list by a certain condition. Group word is a keyword
here. Let's decompose merge function and start with grouping.

> g_list = concat . map group $ map primeFactors [1..20]

Besides duplicated values like [2,2] or [3] this list looks good. Now
we need to find the longest sequences of primes, i.e. if we have
sublists like [2], [2,2,2,2] and [2,2] we will keep the one
[2,2,2,2]. We can apply group function once again with a custom
condition followed by a maximum function.

> g_list' = groupBy (\a b -> head a == head b) . sort $ g_list
> l_list = map maximum g_list'

(Brain lapse, I do believe it can be done simpler.)

And find the product of the concatenated list. (Let me expand these
functions for you)

> problem_5'' = product . concat $ 
>               map maximum . 
>               groupBy (\a b -> head a == head b) . sort . 
>               concat . map group $ map primeFactors [1..20]

However, it turns out, when we merge/group/filter the list we do the
same thing as in lowest denominator problem. In other words, I may
multiply the first and the second numbers and then divide them by
their greatest common divisor. Luckily, Haskell comes with a handy
function gcd.

> problem_5''' = foldl1 (\a b -> a * b `div` gcd a b) [1..20]

Can we do better? Sure!

The smallest value divisible by two numbers is called the lowest
common multiple. Actually, lcm of two numbers a and b is the smallest
number that is a multiply of both numbers a and b. There need be no
doubt that Haskell has lowest common multiple function. It is called
(surprise!) lcm.

Therefore, we can just fold of the list with the lcm function:

> problem_5 = foldl1 lcm [1..20]

> main = print problem_5

Performance
-----------

real	0m0.675s
user	0m0.568s
sys	0m0.100s

P.S. The main idea of the performance section is to overcome 1 second
barrier. For instance, I do not care about the compilation yet, I just
feel comfortable with runghc against a literate Haskell code.
