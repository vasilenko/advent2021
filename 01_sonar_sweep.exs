defmodule Sonar do
  def count(depths) do
    depths
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> left < right end)
  end
end

defmodule AdvancedSonar do
  def count(depths) do
    depths
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [[left, _, _], [_, _, right]] -> left < right end)
  end
end

depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

IO.puts("Result (part one): #{Sonar.count(depths)}")
IO.puts("Result (part two): #{AdvancedSonar.count(depths)}")
