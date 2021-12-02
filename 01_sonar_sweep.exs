defmodule Sonar do
  def count([]), do: 0
  def count([first | rest]), do: count(rest, first, 0)
  def count([], _, result), do: result
  def count([curr | rest], prev, result) when curr > prev, do: count(rest, curr, result + 1)
  def count([curr | rest], _, result), do: count(rest, curr, result)
end

defmodule AdvancedSonar do
  def count(depths) do
    depths
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(fn chunk -> Enum.sum(chunk) end)
    |> Enum.reduce({nil, 0}, fn
      curr, {prev, result} when curr > prev -> {curr, result + 1}
      curr, {_, result} -> {curr, result}
    end)
    |> elem(1)
  end
end

depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

IO.puts("Result (part one): #{Sonar.count(depths)}")
IO.puts("Result (part two): #{AdvancedSonar.count(depths)}")
