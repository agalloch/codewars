%w(zero one two three four five six seven eight nine).each_with_index do |name, value|
  define_method name do |f = nil|
    return value unless f
    
    f.call value 
  end
end

def plus(y)
  -> (x) { x + y }
end
def minus(y)
  -> (x) { x - y }
end
def times(y)
  -> (x) { x * y }
end
def divided_by(y)
  -> (x) { x / y }
end

equals = lambda do |x, y|
  if x == y
    puts "PASSED. #{y}"
  else
    puts "Failed: expected #{y}, got #{x}"
  end
end

equals.call seven(times(five())), 35
equals.call four(plus(nine())), 13
equals.call eight(minus(three())), 5
equals.call six(divided_by(two())), 3
