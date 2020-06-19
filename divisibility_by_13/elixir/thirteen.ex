defmodule Divisible13 do
  def thirt(n) do
    repeat 0, partial_sum(n)
  end

  def repeat(old_sum, new_sum) do
    if old_sum == new_sum do
      old_sum
    else
      repeat new_sum, partial_sum(new_sum)
    end
  end
  
  def partial_sum(n) do
    Integer.digits(n)
      |> Enum.reverse
      |> Stream.zip(Stream.cycle([1, 10, 9, 12, 3, 4]))
      |> Stream.map(fn({x, y}) -> x * y end)
      |> Enum.to_list
      |> Enum.sum
  end
end
