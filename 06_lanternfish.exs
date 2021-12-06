defmodule Lanternfish do
  def count(list, days) do
    data =
      list
      |> Enum.frequencies()
      |> Enum.reduce({0, 0, 0, 0, 0, 0, 0, 0, 0}, fn {k, v}, t -> put_elem(t, k, v) end)

    1..days
    |> Enum.reduce(data, fn _, {t0, t1, t2, t3, t4, t5, t6, t7, t8} ->
      {t1, t2, t3, t4, t5, t6, t7 + t0, t8, t0}
    end)
    |> Tuple.sum()
  end
end

data = [3, 4, 3, 1, 2]

IO.puts("Result (part one): #{Lanternfish.count(data, 80)}")
IO.puts("Result (part two): #{Lanternfish.count(data, 256)}")
