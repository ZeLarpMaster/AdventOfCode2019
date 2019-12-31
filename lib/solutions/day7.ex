defmodule Aoc.Solutions.Day7 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(program) do
    program
    |> IntcodeMachine.new()
    |> find_best_sequence()
  end

  defp find_best_sequence(machine) do
    for seq <- permutations(Enum.to_list(5..9)) do
      run_with_sequence(machine, seq)
    end
    |> Enum.max()
  end

  defp run_with_sequence(machine, seq) do
    pids = Enum.map(seq, &start_machine(machine, &1))

    run_machines(pids, 0)
  end

  defp run_machines([], value), do: value

  defp run_machines([pid | tail], value) do
    send(pid, {:input, value})

    receive do
      {:display, value} -> run_machines(tail ++ [pid], value)
      {:halted, ^pid} -> run_machines(tail, value)
    end
  end

  defp start_machine(machine, phase) do
    parent = self()
    pid = spawn_link(fn -> send(parent, {IntcodeMachine.run(machine, parent), self()}) end)
    send(pid, {:input, phase})

    pid
  end

  # From https://stackoverflow.com/a/33756397
  defp permutations([]), do: [[]]
  defp permutations(list), do: for(h <- list, t <- permutations(list -- [h]), do: [h | t])
end
