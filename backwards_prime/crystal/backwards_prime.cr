def backwards_prime(start, stop)
  (start..stop).select do |n|
    n > 12 &&
      (rev = n.to_s.reverse.to_i) &&
      n != rev &&
      prime?(n) &&
      prime?(rev)
  end
end

def prime?(num)
  return false if num < 2
  return true  if num <= 3

  num.odd? && 3.step(to: Math.sqrt(num), by: 2).all? { |n| num % n != 0 }
end

def test
  p [
      backwards_prime(1, 11).empty?,
      backwards_prime(1, 31) == [13, 17, 31],
      backwards_prime(1, 100) == [13, 17, 31, 37, 71, 73, 79, 97],
      backwards_prime(7000, 7100) == [7027, 7043, 7057],
      backwards_prime(70000, 70245) == [70001, 70009, 70061, 70079, 70121, 70141, 70163, 70241],
      backwards_prime(70485, 70600) == [70489, 70529, 70573, 70589],
  ]
end

test
