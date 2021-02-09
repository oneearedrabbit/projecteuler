def triplet?(a, b, c)
  a*a + b*b == c*c
end

def good?(a,b,c)
  a + b + c == 1000
end

if false
[*0..1000/2].each do |c|
  p c
  [*0..c].each do |a|
    [*0..a].each do |b|
      p [a,b,c] if triplet?(a,b,c) && good?(a,b,c)
    end
  end
end
end

puts [375, 200, 425].reduce(1, &:*)