defmodule Fuel do
  def count1(data), do: count(data, &abs(&1 - &2))
  def count2(data), do: count(data, &Enum.sum(0..abs(&1 - &2)))

  defp count(data, fun) do
    {min, max} = Enum.min_max(data)

    min..max
    |> Enum.map(fn pos ->
      data
      |> Enum.map(&fun.(pos, &1))
      |> Enum.sum()
    end)
    |> Enum.min()
  end
end

data = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

IO.puts("Result (part one): #{Fuel.count1(data)}")
IO.puts("Result (part two): #{Fuel.count2(data)}")
