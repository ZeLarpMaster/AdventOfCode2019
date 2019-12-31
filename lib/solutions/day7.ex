defmodule Aoc.Solutions.Day7 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(program) do
    program
    |> IntcodeMachine.new()
    |> find_best_sequence()
  end

  defp find_best_sequence(machine) do
    for seq <- permutations(Enum.to_list(0..4)) do
      run_with_sequence(machine, 0, seq)
    end
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.max()
  end

  defp run_with_sequence(machine, input, [phase]), do: run_with_phase(input, machine, phase)

  defp run_with_sequence(machine, input, [phase | tail]),
    do: run_with_sequence(machine, run_with_phase(input, machine, phase), tail)

  defp run_with_phase(input, machine, phase) do
    {:ok, device} = StringIO.open("#{phase}\n#{input}\n")

    IntcodeMachine.run(machine, device)

    {_, output} = StringIO.contents(device)
    StringIO.close(device)

    output
  end

  # From https://stackoverflow.com/a/33756397
  defp permutations([]), do: [[]]
  defp permutations(list), do: for(h <- list, t <- permutations(list -- [h]), do: [h | t])
end
