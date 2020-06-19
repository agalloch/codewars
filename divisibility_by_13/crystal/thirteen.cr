def thirt(n)
  old_sum = partial_sum n

  loop do
    old_sum = partial_sum old_sum
    new_sum = partial_sum old_sum

    break old_sum if old_sum == new_sum
  end
end

def partial_sum(n)
  n.to_s
    .reverse
    .each_char
    .zip([1, 10, 9, 12, 3, 4].cycle)
    .map { |(x, y)| x.to_i * y }
    .sum
end

REMAINDERS = [1, 10, 9, 12, 3, 4]

def thirt_alternative(n)
  sum = n.to_s.chars.reverse.each_with_index.sum { |c, i| c.to_i * REMAINDERS[i % REMAINDERS.size] }
  sum == n ? sum : thirt(sum)
end

pp thirt(1234567) == 87
pp thirt(8529) == 79
pp thirt(85299258) == 31
pp thirt(5634) == 57
pp thirt(1111111111) == 71
pp thirt(1111111111111111111)
pp thirt(9992131213249999123)
