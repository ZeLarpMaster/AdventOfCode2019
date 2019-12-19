defmodule Aoc.Solutions.Day3 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    wires =
      input
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&parse_wires/1)
  end

  defp parse_wires([wire | wires]), do: [parse_wire(wire) | parse_wires(wires)]
  defp parse_wires([]), do: []
  defp parse_wire("L" <> num), do: {:left, String.to_integer(num)}
end
