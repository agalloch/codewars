POWERS_OF_TWO   = [6, 2, 4, 8]
POWERS_OF_THREE = [1, 3, 9, 7]
POWERS_OF_FOUR  = [4, 6]
POWERS_OF_SEVEN = [1, 7, 9, 3]
POWERS_OF_EIGHT = [8, 4, 2, 6]
POWERS_OF_NINE  = [1, 9]

def last_digit(num_string, pow_string)
  last_digit = num_string[-1].to_i
  power      = (pow_string[-2..-1] || pow_string).to_i

  return 1 if last_digit == 1 || (power.zero? && pow_string.size == 1)
  return 0 if last_digit.zero?
  return last_digit if [5, 6].include? last_digit
  return POWERS_OF_TWO[power % 4] if last_digit == 2
  return POWERS_OF_THREE[power % 4] if last_digit == 3
  return POWERS_OF_FOUR[(power - 1) % 2] if last_digit == 4
  return POWERS_OF_SEVEN[power % 4] if last_digit == 7
  return POWERS_OF_EIGHT[(power - 1) % 4] if last_digit == 8
  return POWERS_OF_NINE[power % 2] if last_digit == 9

  -1
end


eq = ->(a, b) { a == b ? "Passed. #{a}" : "FAILED: expected #{b}, got #{a}" }

pp eq.(last_digit("4", "1"), 4)
pp eq.(last_digit("4", "2"), 6)
pp eq.(last_digit("4", "13"), 4)
pp eq.(last_digit("8", "13"), 8)
pp eq.(last_digit("9", "7"), 9)
pp eq.(last_digit("77", "7"), 3)
pp eq.(last_digit("10","10000000000"), 0)
pp eq.(last_digit("1606938044258990275541962092341162602522202993782792835301376","2037035976334486086268445688409378161051468393665936250636140449354381299763336706183397376"), 6)
pp eq.(last_digit("3715290469715693021198967285016729344580685479654510946723", "68819615221552997273737174557165657483427362207517952651"), 7)
pp eq.(last_digit("16709895655561134878745562439056049269175", "0"), 1)
pp eq.(last_digit("0", "0"), 1)
