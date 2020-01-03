defmodule Aoc.Solutions.Day11 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    parent = self()

    spawn_link(fn ->
      input
      |> IntcodeMachine.new()
      |> IntcodeMachine.run(parent)

      send(parent, :halted)

      receive do
        :finished -> :ok
      end
    end)
    |> Process.register(:robot)

    process_robot(%{{0, 0} => 1}, {0, -1}, {0, 1})
    # For part 1
    # |> map_size()
    |> display_map()
  end

  defp display_map(map) do
    {min_x, max_x} = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    for x <- min_x..max_x do
      for y <- min_y..max_y do
        case Map.get(map, {x, y}, 0) do
          0 -> " "
          1 -> "#"
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end

  # Send current color
  # Receive color then direction
  # Paint
  # Turn
  # Move
  # Repeat
  # 0 = black; 1 = white
  # 0 = left;  1 = right

  defp process_robot(map, position, direction) do
    position = move(position, direction)
    send(:robot, {:input, Map.get(map, position, 0)})

    receive do
      {:display, paint} ->
        receive do
          {:display, turn_dir} ->
            process_robot(Map.put(map, position, paint), position, turn(direction, turn_dir))
        end

      :halted ->
        send(:robot, :finished)
        map
    end
  end

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}
  defp turn({dx, dy}, 0), do: {-dy, dx}
  defp turn({dx, dy}, 1), do: {dy, -dx}
end
