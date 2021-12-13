defmodule Origami do
  def fold(data, {coord, f}) do
    Enum.reduce(data, MapSet.new(), fn
      {x, y}, acc when coord == :x and x > f -> MapSet.put(acc, {x - (x - f) * 2, y})
      {x, y}, acc when coord == :y and y > f -> MapSet.put(acc, {x, y - (y - f) * 2})
      other, acc -> MapSet.put(acc, other)
    end)
  end

  def draw(data) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(data, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(data, fn {_, y} -> y end)

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x -> if MapSet.member?(data, {x, y}), do: "🍆", else: "  " end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end

data =
  MapSet.new([
    {6, 10},
    {0, 14},
    {9, 10},
    {0, 3},
    {10, 4},
    {4, 11},
    {6, 0},
    {6, 12},
    {4, 1},
    {0, 13},
    {10, 12},
    {3, 4},
    {3, 0},
    {8, 4},
    {1, 10},
    {2, 14},
    {8, 10},
    {9, 0}
  ])

folding_list = [
  {:y, 7},
  {:x, 5}
]

result = data |> Origami.fold(hd(folding_list)) |> MapSet.size()

IO.puts("Result (part one): #{result}")
IO.puts("Result (part two):")

folding_list
|> Enum.reduce(data, &Origami.fold(&2, &1))
|> Origami.draw()
|> IO.puts()
