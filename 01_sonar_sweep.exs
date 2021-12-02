defmodule Sonar do
  def count([]), do: 0
  def count([first | rest]), do: count(rest, first, 0)
  def count([], _, result), do: result
  def count([curr | rest], prev, result) when curr > prev, do: count(rest, curr, result + 1)
  def count([curr | rest], _, result), do: count(rest, curr, result)
end

depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
IO.puts("Result: #{Sonar.count(depths)}")
