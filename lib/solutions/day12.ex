defmodule Aoc.Solutions.Day12 do
  @behaviour Aoc.Solutions

  defmodule Vector do
    defstruct x: 0, y: 0, z: 0
  end

  @impl true
  def execute(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim_leading(&1, "<"))
    |> Enum.map(&String.trim_trailing(&1, ">"))
    |> Enum.map(&String.split(&1, ", "))
    |> Enum.map(&parse_position/1)
    |> Enum.map(fn pos -> {struct(Vector, pos), %Vector{}} end)
    |> simulate(1000)
    |> total_energy()
  end

  defp simulate(list, 0), do: list

  defp simulate(list, step) do
    list
    |> Enum.map(&apply_gravity(&1, list))
    |> Enum.map(&apply_velocity/1)
    |> simulate(step - 1)
  end

  defp apply_velocity({pos, vel}) do
    {
      %Vector{
        x: pos.x + vel.x,
        y: pos.y + vel.y,
        z: pos.z + vel.z
      },
      vel
    }
  end

  defp apply_gravity(moon, []), do: moon

  defp apply_gravity({pos, vel}, [{other, _} | tail]) do
    {
      pos,
      %Vector{
        x: vel.x + compare(pos.x, other.x),
        y: vel.y + compare(pos.y, other.y),
        z: vel.z + compare(pos.z, other.z)
      }
    }
    |> apply_gravity(tail)
  end

  defp compare(pos1, pos2) when pos1 > pos2, do: -1
  defp compare(pos1, pos2) when pos1 < pos2, do: 1
  defp compare(pos1, pos2) when pos1 == pos2, do: 0

  defp total_energy([]), do: 0
  defp total_energy([{pos, vel} | tail]), do: sum(pos) * sum(vel) + total_energy(tail)
  defp sum(%Vector{x: x, y: y, z: z}), do: abs(x) + abs(y) + abs(z)

  defp parse_position(coords) do
    coords
    |> Enum.map(&String.split(&1, "="))
    |> Enum.map(fn [key, value] -> {to_atom(key), String.to_integer(value)} end)
    |> Enum.into(%{})
  end

  defp to_atom("x"), do: :x
  defp to_atom("y"), do: :y
  defp to_atom("z"), do: :z
end
