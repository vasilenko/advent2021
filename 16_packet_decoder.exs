defmodule Decoder do
  def parse(hex) do
    bit_length = String.length(hex) * 4

    hex
    |> Integer.parse(16)
    |> elem(0)
    |> Integer.to_string(2)
    |> String.pad_leading(bit_length, "0")
  end

  def decode(<<ver::binary-size(3)>> <> "100" <> message) do
    {literal, tail} = decode_literal(message)

    {{:literal, to_integer(ver), literal}, tail}
  end

  def decode(
        <<ver::binary-size(3)>> <>
          <<id::binary-size(3)>> <> "0" <> <<size::binary-size(15)>> <> message
      ) do
    packet_size = to_integer(size)
    <<packets::binary-size(packet_size)>> <> tail = message

    stream =
      packets
      |> Stream.unfold(&decode/1)
      |> Stream.take_while(&(!is_nil(&1)))

    {{parse_id(id), to_integer(ver), Enum.to_list(stream)}, tail}
  end

  def decode(
        <<ver::binary-size(3)>> <>
          <<id::binary-size(3)>> <> "1" <> <<length::binary-size(11)>> <> message
      ) do
    packet_length = to_integer(length)

    {result, tail} =
      Enum.reduce(1..packet_length, {[], message}, fn _, {acc, tail} ->
        {result, new_tail} = decode(tail)
        {acc ++ [result], new_tail}
      end)

    {{parse_id(id), to_integer(ver), result}, tail}
  end

  def decode(_), do: nil

  defp decode_literal(message, acc \\ "")

  defp decode_literal("1" <> <<group::binary-size(4)>> <> tail, acc),
    do: decode_literal(tail, acc <> group)

  defp decode_literal("0" <> <<group::binary-size(4)>> <> tail, acc),
    do: {to_integer(acc <> group), tail}

  defp parse_id("000"), do: :sum
  defp parse_id("001"), do: :product
  defp parse_id("010"), do: :min
  defp parse_id("011"), do: :max
  defp parse_id("100"), do: :literal
  defp parse_id("101"), do: :gt
  defp parse_id("110"), do: :lt
  defp parse_id("111"), do: :eq

  defp to_integer(str), do: String.to_integer(str, 2)

  def sum_versions({_, ver, terms}), do: sum_versions(terms, ver)
  def sum_versions([{:literal, ver, _} | next], sum), do: sum_versions(next, sum + ver)

  def sum_versions([{_, ver, terms} | next], sum),
    do: sum_versions(next, sum + ver + sum_versions(terms, 0))

  def sum_versions([], sum), do: sum

  def calculate({op, _, terms}), do: calculate(op, terms)
  def calculate(terms), do: Enum.map(terms, &calculate/1)
  def calculate(:sum, terms), do: terms |> calculate() |> Enum.sum()
  def calculate(:product, terms), do: terms |> calculate() |> Enum.product()
  def calculate(:min, terms), do: terms |> calculate() |> Enum.min()
  def calculate(:max, terms), do: terms |> calculate() |> Enum.max()
  def calculate(:literal, value), do: value
  def calculate(:gt, [left, right]), do: (calculate(left) > calculate(right) && 1) || 0
  def calculate(:lt, [left, right]), do: (calculate(left) < calculate(right) && 1) || 0
  def calculate(:eq, [left, right]), do: (calculate(left) == calculate(right) && 1) || 0
end

message = "8A004A801A8002F478"

{decoded_message, _} = message |> Decoder.parse() |> Decoder.decode()
IO.inspect(decoded_message)

result1 = Decoder.sum_versions(decoded_message)
result2 = Decoder.calculate(decoded_message)

IO.puts("Result (part one): #{result1}")
IO.puts("Result (part two): #{result2}")
