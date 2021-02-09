max = 2_000_000
sieve = []

for i in 2 .. max
  sieve[i] = i
end

for i in 2 .. Math.sqrt(max)
  next unless sieve[i]
  p i
  (i*i).step(max, i) do |j|
    sieve[j] = nil
  end
end

puts sieve.compact.inject(0, &:+)