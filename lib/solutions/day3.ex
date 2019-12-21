defmodule Aoc.Solutions.Day3 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    [wire1, wire2] =
      input
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&parse_wires/1)

    %{}
    |> map_wire(wire1, {0, 0}, :wire1)
    |> map_wire(wire2, {0, 0}, :wire2)
    |> find_intersections()
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  defp map_wire(map, [{dx, dy, num} | parts], {x, y}, wire) do
    new_pos = {x + dx, y + dy}

    map =
      Map.update(map, new_pos, wire, fn
        # Can't intersect with yourself
        val when val == wire -> val
        _ -> :intersection
      end)

    if num == 1 do
      map_wire(map, parts, new_pos, wire)
    else
      map_wire(map, [{dx, dy, num - 1} | parts], new_pos, wire)
    end
  end

  defp map_wire(map, [], _, _), do: map

  defp find_intersections(map) do
    map
    |> Map.to_list()
    |> Enum.filter(fn {_pos, val} -> val == :intersection end)
    |> Enum.map(&elem(&1, 0))
  end

  defp parse_wires(wires), do: Enum.map(wires, &parse_wire/1)
  defp parse_wire("L" <> num), do: {-1, 0, String.to_integer(num)}
  defp parse_wire("R" <> num), do: {+1, 0, String.to_integer(num)}
  defp parse_wire("U" <> num), do: {0, -1, String.to_integer(num)}
  defp parse_wire("D" <> num), do: {0, +1, String.to_integer(num)}
end
