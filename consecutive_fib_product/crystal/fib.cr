def productFib(prod : UInt64)
  a = b = 1_u64

  while a * b < prod
    a, b = b, a + b
  end

  [a, b, a * b == prod]
end

def fib(n)
  a = 0_u64
  b = 1_u64
  i = 0_u64

  while i < n
    a, b = b, a + b
    i += 1
  end

  b
end

pp productFib(4895_u64) == [55, 89, true]
pp productFib(5895_u64) == [89, 144, false]
pp productFib(74049690_u64) == [6765, 10946, true]

pp fib(1)
pp fib(2)
pp fib(92)
