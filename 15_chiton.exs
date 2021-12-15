defmodule Chiton do
  def a_star(map, goal) do
    queue = Heap.new()

    a_star(map, goal, Heap.push(queue, {{0, 0}, 0}), %{{0, 0} => 0}, %{})
  end

  def a_star(map, goal, queue, scores, path) do
    case Heap.split(queue) do
      {{^goal, _}, _} ->
        path

      {{curr, _}, queue} ->
        {new_queue, new_scores, new_path} =
          map
          |> get_next(curr)
          |> Enum.reduce({queue, scores, path}, &add_next(goal, curr, &1, &2))

        a_star(map, goal, new_queue, new_scores, new_path)
    end
  end

  defp add_next(goal, curr, {next, next_val}, {queue, scores, path}) do
    next_score = next_val + scores[curr]

    if next_score < scores[next] do
      sort_factor = next_score + manhattan_distance(next, goal)

      {
        Heap.push(queue, {next, sort_factor}),
        Map.put(scores, next, next_score),
        Map.put(path, next, curr)
      }
    else
      {queue, scores, path}
    end
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: x2 - x1 + (y2 - y1)

  defp get_next(map, {x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.reduce(%{}, fn idx, acc ->
      case map[idx] do
        nil -> acc
        val -> Map.put(acc, idx, val)
      end
    end)
  end

  def score(map, path, idx, total \\ 0)
  def score(_, _, {0, 0}, total), do: total
  def score(map, path, idx, total), do: score(map, path, path[idx], total + map[idx])
end

data = [
  "1163751742",
  "1381373672",
  "2136511328",
  "3694931569",
  "7463417111",
  "1319128137",
  "1359912421",
  "3125421639",
  "1293138521",
  "2311944581"
]

map =
  data
  |> Enum.with_index()
  |> Enum.flat_map(fn {line, y} ->
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index(&{{&2, y}, &1})
  end)
  |> Map.new()

goal = {9, 9}
path = Chiton.a_star(map, goal)
score = Chiton.score(map, path, goal)

IO.puts("Result (part one): #{score}")
