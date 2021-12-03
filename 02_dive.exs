defmodule Submarine do
  defdelegate to_integer(string), to: String

  def position([]), do: 0
  def position(commands), do: position(commands, 0, 0)
  def position([], depth, hor), do: depth * hor

  def position(["up " <> pos | rest], depth, hor),
    do: position(rest, depth - to_integer(pos), hor)

  def position(["down " <> pos | rest], depth, hor),
    do: position(rest, depth + to_integer(pos), hor)

  def position(["forward " <> pos | rest], depth, hor),
    do: position(rest, depth, hor + to_integer(pos))
end

defmodule AdvancedSubmarine do
  defdelegate to_integer(string), to: String

  def position([]), do: 0
  def position(commands), do: position(commands, 0, 0, 0)
  def position([], _, depth, hor), do: depth * hor

  def position(["up " <> pos | rest], aim, depth, hor),
    do: position(rest, aim - to_integer(pos), depth, hor)

  def position(["down " <> pos | rest], aim, depth, hor),
    do: position(rest, aim + to_integer(pos), depth, hor)

  def position(["forward " <> pos | rest], aim, depth, hor) do
    value = to_integer(pos)
    position(rest, aim, depth + aim * value, hor + value)
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
