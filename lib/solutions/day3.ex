defmodule Aoc.Solutions.Day3 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    wires =
      input
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&parse_wires/1)

    map_wires(%{}, wires)
    |> find_intersections()
    |> Enum.map(fn {x, y} -> x + y end)
    |> Enum.min()
  end

  defp map_wire(map, [{dx, dy, num} | parts], {x, y}) do
    new_pos = {x + dx, y + dy}
    map = Map.update(map, new_pos, :path, fn _value -> :intersection end)

    if num == 1 do
      map_wire(map, parts, new_pos)
    else
      map_wire(map, [{dx, dy, num - 1} | parts], new_pos)
    end
  end

  defp map_wire(map, [], _), do: map
  defp map_wires(map, [wire | wires]), do: map |> map_wire(wire, {0, 0}) |> map_wires(wires)
  defp map_wires(map, []), do: map

  defp find_intersections(map) do
    map
    |> Map.to_list()
    |> Enum.filter(fn {_pos, val} -> val == :intersection end)
    |> Enum.map(&elem(&1, 0))
  end

  defp parse_wires(wires), do: Enum.map(wires, &parse_wire/1)
  defp parse_wire("L" <> num), do: {-1, 0, String.to_integer(num)}
  defp parse_wire("R" <> num), do: {+1, 0, String.to_integer(num)}
  defp parse_wire("U" <> num), do: {0, +1, String.to_integer(num)}
  defp parse_wire("D" <> num), do: {0, -1, String.to_integer(num)}
end
