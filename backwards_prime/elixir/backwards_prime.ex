defmodule Back do
  require Integer

  def backwards_prime(start, stop) do
    start..stop
    |> Stream.filter(fn(x) -> x > 12 && different_primes?(x, reverse(x)) end)
    |> Enum.to_list
  end

  def prime?(1), do: false
  def prime?(num) when num <= 3, do: true
  def prime?(num) do
     Integer.is_odd(num) && Enum.all? odds(num |> :math.sqrt |> trunc), &(rem(num, &1) != 0)
  end

  def different_primes?(x, y) do
    x != y && prime?(x) && prime?(y)
  end

  def reverse(num) do
    num |> Integer.to_string |> String.reverse |> String.to_integer
  end

  def odds(limit) do
    Stream.iterate(3, &(&1 + 2)) |> Enum.take_while(&(&1 <= limit))
  end

  def test() do
    [
      backwards_prime(1, 12) == [],
      backwards_prime(1, 31) == [13, 17, 31],
      backwards_prime(1, 100) == [13, 17, 31, 37, 71, 73, 79, 97],
      backwards_prime(7000, 7100) == [7027, 7043, 7057],
      backwards_prime(70000, 70245) == [70001, 70009, 70061, 70079, 70121, 70141, 70163, 70241],
      backwards_prime(70485, 70600) == [70489, 70529, 70573, 70589],
    ]
  end
end
