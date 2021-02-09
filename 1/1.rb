# Problem 1
# ---------
# 
# Source: http://projecteuler.net/index.php?section=problems&id=1
# 
# If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
# 
# Find the sum of all the multiples of 3 or 5 below 1000.
# 
# Input:
# None
# 
# Output:
# 233168
# 
# Solution
# --------
# 
# Well... straightforward.

problem_1 = lambda { (1..999).select { |n| n % 3 == 0 || n % 5 == 0 }.inject(0, &:+) }

puts problem_1.call
