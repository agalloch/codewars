def expand(expr)
  return '1' if expr.end_with? '^0'

  a, x, b, n = expr.match(/\(((?:\+|-)?\d*)(\w)((?:\+|-)\d+)\)\^(\d+)/)[1..4]
  a = 
    case
    when a.empty? || a == '+' then 1
    when a == '-' then -1
    else a.to_i
    end

  b, n         = b.to_i, n.to_i
  coefficients = n.times.reduce([1]) { |memo, _| [1, *Array(memo).each_cons(2).map(&:sum), 1] }
  tail         = -> (power) { "^#{power}" if power > 1 }

  k = 0
  result = n.downto(0).zip(coefficients).map do |power, coef|
    coef = a**power * coef * b**k
    k += 1

    case
    when coef <  -1 then "#{power.zero?  ? coef : "#{coef}#{x}" }#{tail.(power)}"
    when coef == -1 then "#{power.zero?  ? coef : "-#{x}" }#{tail.(power)}"
    when coef ==  0 then ''
    when coef ==  1 then "+#{power.zero? ? coef : x }#{tail.(power)}"
    else                 "+#{power.zero? ? coef : "#{coef}#{x}" }#{tail.(power)}"
    end
  end.join

  result.start_with?('+') ? result[1..-1] : result
end

def eq(actual, expected)
  if actual == expected
    puts "Passed. #{actual.inspect}"
  else
    puts "FAILED: expected #{expected.inspect}, got #{actual.inspect}"
  end
end


eq(expand('(x+1)^0'),'1')
eq(expand('(x+1)^1'),'x+1')
eq(expand('(x+1)^2'),'x^2+2x+1')

eq(expand('(x-1)^0'),'1')
eq(expand('(x-1)^1'),'x-1')
eq(expand('(x-1)^2'),'x^2-2x+1')

eq(expand('(5m+3)^4'),'625m^4+1500m^3+1350m^2+540m+81')
eq(expand('(2x-3)^3'),'8x^3-36x^2+54x-27')
eq(expand('(7x-7)^0'),'1')

eq(expand('(-5m+3)^4'),'625m^4-1500m^3+1350m^2-540m+81')
eq(expand('(-2k-3)^3'),'-8k^3-36k^2-54k-27')
eq(expand('(-7x-7)^0'),'1')

eq(expand('(9t-0)^2'),'81t^2')
eq(expand('(-9t-0)^2'),'81t^2')
eq(expand('(-0t-4)^2'),'16')

eq(expand('(-n-12)^5'),'-n^5-60n^4-1440n^3-17280n^2-103680n-248832')

eq(expand('(-50z+26)^20'),'9536743164062500000000000000000000z^20-99182128906250000000000000000000000z^19+489959716796875000000000000000000000z^18-1528674316406250000000000000000000000z^17+3378370239257812500000000000000000000z^16-5621608078125000000000000000000000000z^15+7308090501562500000000000000000000000z^14-7600414121625000000000000000000000000z^13+6422349932773125000000000000000000000z^12-4452829286722700000000000000000000000z^11+2547018352005384400000000000000000000z^10-1204045039129818080000000000000000000z^9+469577565260629051200000000000000000z^8-150264820883401296384000000000000000z^7+39068853429684337059840000000000000z^6-8126321513374342108446720000000000z^5+1320527245923330592622592000000000z^4-161570392442383978391470080000000z^3+14002767345006611460594073600000z^2-766467265200361890474622976000z+19928148895209409152340197376')
