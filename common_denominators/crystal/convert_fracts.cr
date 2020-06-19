require "big"

def convert_fracts(lst)
  lcm = lst.map(&.last).reduce(BigInt.new(1)) { |acc, x| acc.lcm x }

  lst.map { |(num, denom)| [num * (lcm // denom), lcm] }
end

def primes(n)
  puts "Getting primes for #{n.inspect}"
  return [] of Int32 if n < 2

  ps = (2..n).select do |num|
    num == 2 || num.odd? && 3.step(to: Math.sqrt(num), by: 2).all? { |x| num % x != 0 }
  end

  puts "So many primes! #{ps.size}"
  ps
end

def equals(x, y)
  if x == y
    puts "PASSED. #{x}"
  else
    puts "Failed: expected #{y.inspect}, got #{x.inspect}"
  end
end

equals convert_fracts([[1, 2], [1, 3], [1, 4]]), [[6, 12], [4, 12], [3, 12]]
equals convert_fracts([[1, 2], [1, 16], [1, 24]]), [[24, 48], [3, 48], [2, 48]]
equals convert_fracts([[1, 7], [1, 17], [1, 23]]), [[391, 2737], [161, 2737], [119, 2737]]
equals convert_fracts([[27115, 5262], [87546, 11111111]]), [[301277774765, 58466666082], [460667052, 58466666082]]
