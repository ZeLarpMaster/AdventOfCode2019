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
    |> find_cycle()
    |> lcm()

    # Part 1
    # |> simulate(1000)
    # |> total_energy()
  end

  defp find_cycle(state), do: find_cycle(state, state, {1, -1, -1, -1})

  defp find_cycle(_, _, {_, x, y, z}) when x != -1 and y != -1 and z != -1, do: [x, y, z]

  defp find_cycle(state, initial, {step, x, y, z}) do
    new_state = simulate(state, 1)

    x_step = if new_state.x == initial.x and x == -1, do: step, else: x
    y_step = if new_state.y == initial.y and y == -1, do: step, else: y
    z_step = if new_state.z == initial.z and z == -1, do: step, else: z

    find_cycle(new_state, initial, {step + 1, x_step, y_step, z_step})
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

  defp lcm([num1, num2]), do: num1 * num2 / Integer.gcd(num1, num2)
  defp lcm([head | tail]), do: lcm([head, lcm(tail)])

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
