defmodule Revrot do
  def revrot(_, sz) when sz <= 0, do: ""
  def revrot("", _), do: ""

  def revrot(str, sz) do
    if sz > String.length(str) do
      ""
    else
      String.codepoints(str)
        |> Enum.map(&String.to_integer &1)
        |> Enum.chunk_every(sz, sz, :discard)
        |> Enum.map(fn([head | tail] = list) ->
            if even(trunc(sum_cubes(list))) do
              Enum.reverse(list)
            else
              tail ++ [head]
            end
          end)
        |> List.flatten
        |> Enum.join
    end
  end

  def test_revrot_too_short do
    revrot("1234", 0) == ""
  end

  def test_revrot_empty do
    revrot("", 0) == ""
  end

  def test_revrot_too_long do
    revrot("1234", 5) == ""
  end

  def test_revrot do
    revrot("733049910872815764", 5) == "330479108928157"
  end

  defp sum_cubes(list) do
    Enum.reduce list, 0, fn(x, acc) -> acc + :math.pow(x, 3) end
  end

  defp even(num) do
    rem(num, 2) == 0
  end
end
