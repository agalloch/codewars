def next_smaller(num)
  digits = num.to_s.chars.map(&.to_i)

  (2..digits.size).each do |slice_length|
    slice = digits.last slice_length

    next if ordered? slice

    out_of_order = slice.shift
    rest         = slice
    ix           = rest.rindex { |n| n < out_of_order }.not_nil!
    replacement  = rest.delete_at(ix)

    rest << out_of_order
    rest.sort!.reverse!
    rest.unshift replacement

    final_digits = digits.first(digits.size - slice_length).concat rest

    return final_digits.join.to_i if final_digits.first != 0
  end

  -1
end

def ordered?(array)
  array.each_cons(2).all? { |(num1, num2)| num1 <= num2 }
end
