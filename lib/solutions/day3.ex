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
    |> map_wire(wire1, {0, 0}, :wire1, 0)
    |> map_wire(wire2, {0, 0}, :wire2, 0)
    |> find_intersections()
    |> Enum.map(&elem(&1, 1))
    |> Enum.min()
  end

  defp map_wire(map, [{dx, dy, num} | parts], {x, y}, wire, steps) do
    new_pos = {x + dx, y + dy}
    steps = steps + 1

    map =
      Map.update(map, new_pos, {wire, steps}, fn
        # Can't intersect with yourself
        {^wire, _} = val -> val
        # Keep shortest number of steps on existing intersections
        {:intersection, _} = val -> val
        {_other, other_steps} -> {:intersection, steps + other_steps}
      end)

    if num == 1 do
      map_wire(map, parts, new_pos, wire, steps)
    else
      map_wire(map, [{dx, dy, num - 1} | parts], new_pos, wire, steps)
    end
  end

  defp map_wire(map, [], _, _, _), do: map

  defp find_intersections(map) do
    map
    |> Map.to_list()
    |> Enum.filter(fn {_pos, {val, _steps}} -> val == :intersection end)
    |> Enum.map(fn {pos, {:intersection, steps}} -> {pos, steps} end)
  end

  defp parse_wires(wires), do: Enum.map(wires, &parse_wire/1)
  defp parse_wire("L" <> num), do: {-1, 0, String.to_integer(num)}
  defp parse_wire("R" <> num), do: {+1, 0, String.to_integer(num)}
  defp parse_wire("U" <> num), do: {0, -1, String.to_integer(num)}
  defp parse_wire("D" <> num), do: {0, +1, String.to_integer(num)}
end
