defmodule Diagnostic do
  def power(data) do
    [gamma, epsilon] =
      data
      |> List.zip()
      |> Enum.map(&get_min_max_by_frequency/1)
      |> List.zip()

    to_integer(gamma) * to_integer(epsilon)
  end

  defp get_min_max_by_frequency(row) do
    {{min, _}, {max, _}} =
      row
      |> Tuple.to_list()
      |> Enum.frequencies()
      |> Enum.min_max_by(&elem(&1, 1))

    {min, max}
  end

  defp to_integer(row) do
    row
    |> Tuple.to_list()
    |> List.to_string()
    |> String.to_integer(2)
  end
end

data =
  ~w(
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
  )
  |> Enum.map(&String.graphemes/1)

IO.puts("Result (part one): #{Diagnostic.power(data)}")
