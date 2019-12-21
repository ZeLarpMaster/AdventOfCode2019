defmodule Aoc.Solutions.Day4 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    [min, max] =
      input
      |> String.trim()
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    min..max
    |> Flow.from_enumerable()
    |> Flow.map(&Integer.to_string/1)
    |> Flow.filter(&check_criteria/1)
    |> Enum.count()
  end

  defp check_criteria(password), do: check_duplicates(password) and check_increasing(password)

  defp check_duplicates(<<x, y, _rest::binary>>) when x == y, do: true
  defp check_duplicates(<<_x, rest::binary>>), do: check_duplicates(rest)
  defp check_duplicates(<<>>), do: false

  defp check_increasing(<<x, y, rest::binary>>) when x <= y, do: check_increasing(<<y>> <> rest)
  defp check_increasing(<<_x>>), do: true
  defp check_increasing(<<_x, _rest::binary>>), do: false
end
