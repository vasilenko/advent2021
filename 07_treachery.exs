defmodule Fuel do
  def count1(data), do: count(data, &(&1))
  def count2(data), do: count(data, &((1 + &1) / 2 * &1))

  defp count(data, fun) do
    {min, max} = Enum.min_max(data)

    min..max
    |> Enum.map(fn pos -> Enum.reduce(data, 0, &fun.(abs(pos - &1)) + &2) end)
    |> Enum.min()
  end
end

data = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

IO.puts("Result (part one): #{Fuel.count1(data)}")
IO.puts("Result (part two): #{Fuel.count2(data)}")
