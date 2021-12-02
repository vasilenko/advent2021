defmodule Submarine do
  def position([]), do: 0
  def position(commands), do: position(commands, 0, 0)
  def position([], depth, hor), do: depth * hor
  def position(["up " <> pos | rest], depth, hor), do: position(rest, depth - parse(pos), hor)
  def position(["down " <> pos | rest], depth, hor), do: position(rest, depth + parse(pos), hor)

  def position(["forward " <> pos | rest], depth, hor),
    do: position(rest, depth, hor + parse(pos))

  defp parse(str) do
    {int, _} = Integer.parse(str)
    int
  end
end

defmodule AdvancedSubmarine do
  def position([]), do: 0
  def position(commands), do: position(commands, 0, 0, 0)
  def position([], _, depth, hor), do: depth * hor

  def position(["up " <> pos | rest], aim, depth, hor),
    do: position(rest, aim - parse(pos), depth, hor)

  def position(["down " <> pos | rest], aim, depth, hor),
    do: position(rest, aim + parse(pos), depth, hor)

  def position(["forward " <> pos | rest], aim, depth, hor) do
    value = parse(pos)
    position(rest, aim, depth + aim * value, hor + value)
  end

  defp parse(str) do
    {int, _} = Integer.parse(str)
    int
  end
end

commands = [
  "forward 5",
  "down 5",
  "forward 8",
  "up 3",
  "down 8",
  "forward 2"
]

IO.puts("Result (part one): #{Submarine.position(commands)}")
IO.puts("Result (part two): #{AdvancedSubmarine.position(commands)}")
