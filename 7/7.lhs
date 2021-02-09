Problem 7
---------

Source: http://projecteuler.net/index.php?section=problems&id=7

By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can
see that the 6th prime is 13.

What is the 10001st prime number?

Input: None

Output: 42

Solution
--------

> import Text.Printf
> import System.CPUTime

Any natural number is representable as a product of powers of its
prime factors, hence a prime number has no prime divisors other than
itself.

There are 100500 algorithms how to find a prime number, let's describe
just some of them.

By the way, one of the solutions we have already implemented in the
problem 3 (http://epicmonkey.livejournal.com/21596.html). For the
archive I am copying it here.

A factor of a number n is a number which divides into another number
without leaving a reminder. Therefore factors of a number n is a list
of all possible factors in a range [1..x].

> factors_1 x = [p | p <- [1..x], x `mod` p == 0]

A prime number is a natural number which has exactly two distinct
natural number divisors: 1 and itself. Thus, the smallest prime is 2.

> primes_1 = [p | p <- [2..], length (factors_1 p) == 2]

Another beautiful and ancient algorithm for finding all the prime
numbers up to a n number is Sieve of Eratosthenes. Let's assume we
have written out all the numbers from 2 to n. The first number which
is not crossed out will be a prime number. After that we will cross
out all numbers divisible by it. Then we will repeat that process
until we reach n. All the numbers in the sieve which are not crossed
out will be prime numbers.

However, as we do not know the upper limit for the 10001th prime
number we have to slightly adapt Sieve of Eratosthenes algorithm.

There is an well-known and elegant solution.

> sieve_2 (p:xs) = p : sieve_2 [x | x <- xs, x `mod` p > 0]
> primes_2 = sieve_2 [2..]

Nevertheless, it has been stated many times this is not the genuine
algorithm, but is instead its naive version. Actually, it was not
immediately obvious when looking at it.

We start with a list of all integers greater than or equal to 2. Take
the first element from the list - prime number - and then cross off
all the multiplies of it. Repeating this process we get a list of all
the prime numbers.

But. We do some redundant steps here.

When we find a prime number we need to cross off numbers in the list
starting at the square. For example, if we find 13 is a prime number
we can start crossing out numbers in the list at 169.

For another little thing, it uses divisibility check rather than a
simple increment.

However there is a more important difference. We cross off numbers
differently. Basically, sieve_2 function takes a head of an infinite
list and passes to itself another list that is formed from a tail and
a guard function that checks _every number_ to be divisible by a
prime.

Thus by the second step, when sieve function is called with a list
[3,5..] half of the integers greater than 3 are having two
divisibility checks calculated. The situation becomes more and more
dramatic with each step.

We can transform Sieve of Eratosthenes into a trial division algorithm
without any specific restrictions.

> primes_3 = [x | x <- [2..], isPrime_3 x]
> isPrime_3 x = all (\p -> x `mod` p > 0) (factors_3 x)
>     where
>       factors_3 x = takeWhile (\p -> p*p <= x) [2..]

Another optimization is to factor out 2. It's almost half of our
work. Additionally, we can check factors using only prime numbers.

> primes_4 = 2 : [x | x <- [3,5..], isPrime_4 x]
> isPrime_4 x = all (\p -> x `mod` p > 0) (factors_4 x)
>     where
>       factors_4 x = takeWhile (\p -> p*p <= x) primes_4

Furthermore, we can factor out other small prime numbers: 3, 5, 7,
etc. This optimization is called Prime Wheel or Wheel Factorization.

For example, if the wheel is a list of [2,3], then we can begin our
algorithm at 5 and add 2 then 4. This will eliminate more than 2/3 of
all of the calculations. Let's write a function that will compute the
Wheel.

Let's take first 5 prime numbers using the previous algorithm as a
seed, that hypothetically should reduce a number of calculations
roughly by 80% in comparison to prime_3 algorithm.

> seedPrimes = take 5 $ primes_4

Then we define a function that returns which columns of the wheel we
need to use.

> patternWheel c = map ((== 1) . gcd c) [1..c]

After that we repeat this pattern and use only the numbers from the
correct columns.

> primeWheel ps = drop 1 . map snd . filter fst $
>            zip (cycle . patternWheel $ product ps) [1..]

Finally, we are good to upgrade the main algorithm.

> primes_5 = seedPrimes ++ 
>            [x | x <- primeWheel seedPrimes, isPrime_5 x]

> isPrime_5 x = all (\p -> x `mod` p > 0) (factors_5 x)
>     where
>       factors_5 x = takeWhile (\p -> p*p <= x) primes_5

> problem_7 = primes_3 !! 10000

Huh. That's all. 

Ultimately let's do a quick performance test.

Performance
-----------

Basically, we will iterate through all the algorithms with an input
set [11, 101, 1001, 10001 and 100001].

> time a = do
>     start <- getCPUTime
>     v <- a
>     end <- getCPUTime
>     let diff = (fromIntegral (end - start)) / (10^12)
>     printf "%0.3f\n" (diff :: Double)
>     return v
 
> main = do 
>        mapM_ (\n -> time $ primes_5 !! n `seq` return ()) 
>                  [11,101,1001,10001,100001]

Results: https://raw.githubusercontent.com/oneearedrabbit/projecteuler/master/7/7_perf.png

The graphic clearly shows that the optimized primes_5 version is just
a little bit faster than primes_4 and about 60-80% faster than
primes_3.

Afterwords
----------

Of course, it is preferable to use functions like minus and union
from the Data.List.Ordered module or optimized structures, however for
this particular problem I decided to make a "pure" solution.

More ideas are available at
http://www.haskell.org/haskellwiki/Prime_numbers
