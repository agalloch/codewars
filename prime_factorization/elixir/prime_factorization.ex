defmodule PrimesInNumbers do
  def insp(list), do: IO.inspect(list, charlists: :as_lists)

  def prime_factors(n) do
    n |> prime_divisors
      |> Enum.reduce([], fn
          item, [head = [h | _] | tail] when item == h -> [[item | head] | tail]
          item, acc -> [[item] | acc]
        end)
      |> Enum.reverse
      |> Enum.map(fn([h | _] = list) ->
          len = length(list)

          "(#{if len > 1, do: "#{h}**#{len}", else: h})"
        end)
      |> Enum.join
  end

  def prime_divisors(num) do
    divisor = Stream.iterate(2, &(&1 + 1))
      |> Stream.take_while(fn(p) -> p * p <= num end)
      |> Enum.find(fn(p) -> rem(num, p) == 0 end)

    if divisor == nil do
      [num]
    else
      [divisor | prime_divisors(div(num, divisor))]
    end
  end

  def test do
    [
      prime_factors(7775460) == "(2**2)(3**3)(5)(7)(11**2)(17)",
      prime_factors(7919) == "(7919)",
      prime_factors(17*17*93*677) == "(3)(17**2)(31)(677)",
      prime_factors(933555431) == "(7537)(123863)",
      prime_factors(342217392) == "(2**4)(3)(11)(43)(15073)",
      prime_factors(285852) == "(2**2)(3)(7)(41)(83)",
    ]
  end
end
