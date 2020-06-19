def convertFracts(lst)
  denominators = lst.map(&:last)

  lcm = primes(denominators.max).reduce(1) do |lcm, factor|
    max_divisions = 
      denominators.map do |denom|
        p, q = denom, factor

        i = 0
        i += 1 while (p, r = p.divmod(q)) && r == 0
        i
      end.max

    lcm *= (factor ** max_divisions) unless max_divisions.zero?
    lcm
  end
  
  lst.map { |num, denom| [num * lcm / denom, lcm] } 
end

def primes(n)
  return [] if n < 2

  (2..n).select do |num| 
    num == 2 || num.odd? && 3.step(to: Math.sqrt(num), by: 2).all? { |x| num % x != 0 }
  end
end

def equals(x, y)
  if x == y
    puts "PASSED. #{x}"
  else
    puts "Failed: expected #{y.inspect}, got #{x.inspect}"
  end
end

equals convertFracts([[1, 2], [1, 3], [1, 4]]), [[6, 12], [4, 12], [3, 12]]
equals convertFracts([[1, 2], [1, 16], [1, 24]]), [[24, 48], [3, 48], [2, 48]]
equals convertFracts([[1, 7], [1, 17], [1, 23]]), [[391, 2737], [161, 2737], [119, 2737]]
