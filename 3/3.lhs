Problem 3
---------

Source: http://projecteuler.net/index.php?section=problems&id=3

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

Input: None

Output: 42

Solution
--------

Let's start with a brute-force algorithm. To find the largest factor
of a number we will generate a list of all factors of a given number.
Then we'll select prime numbers from that list and, finally, take the
largest one. Here is a couple of cute and useless functions.

A factor of a number n is a number which divides into another number
without leaving a reminder. Therefore factors of a number n is a list of
all possible factors in a range [1..x].

> factors' x = [n | n <- [1..x], x `mod` n == 0]

A prime number is a number that has exactly two distinct factors: 1 and
itself.

> primes' = [n | n <- [2..], length (factors' n) == 2]

That leads to the solution:

> primeFactors' x = [n | n <- takeWhile (<= x) primes', x `mod` n == 0]

Do not even think about the complexity of this code. It is terribly slow.

> problem_3' = maximum $ primeFactors' 600851475143

Let's write a faster solution and start with a small optimization of our
prime numbers sequence. For example, we may factor 2.

> primes'' = 2 : [n | n <- [3,5..], length (factors' n) == 2]

Now let's optimize our second function, primeFactors. It is quite
obvious that it is not necessary to use our original value at all
times. We can divide it on each step by a prime number. Additionally,
as our primes are sorted in ascending order we can stop as soon as the
candidate factor exceeds the square root of n:

> primeFactors'' (x:xs) n | x*x > n = [n]
>                         | n `mod` x /= 0 = primeFactors'' xs n
>                         | otherwise = x : primeFactors'' (x:xs) (n `div` x)

> problem_3'' = maximum $ primeFactors'' primes'' 600851475143

Looks good. We also can embed our primes'' function into primeFactors''.

> primeFactors'''' = factors primes
>     where factors (x:xs) n | x*x > n = [n]
>                            | n `mod` x /= 0 = factors xs n
>                            | otherwise = x : factors (x:xs) (n `div` x)
>           primes = 2 : [n | n <- [3,5..], length (factors' n) == 2]

And finally, let's notice that we may optimize the prime numbers generator
by using the same primeFactors function:

> primeFactors''''' = factors primes
>     where factors (x:xs) n | x*x > n = [n]
>                            | n `mod` x /= 0 = factors xs n
>                            | otherwise = x : factors (x:xs) (n `div` x)
>           primes = 2 : [n | n <- [3,5..], length (primeFactors''''' n) == 1]

Ultimately, let's do the final trick and re-write primes function without a
list comprehension to avoid a dummy variable n.

> primeFactors = factors primes
>     where factors (x:xs) n | x*x > n = [n]
>                            | n `mod` x /= 0 = factors xs n
>                            | otherwise = x : factors (x:xs) (n `div` x)
>           primes = 2 : filter ((==1) . length . primeFactors) [3,5..]

> problem_3 = maximum $ primeFactors 600851475143

> main = print problem_3

Performance
-----------

real	0m0.897s
user	0m0.676s
sys	0m0.208s
