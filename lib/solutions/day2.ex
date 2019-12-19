defmodule Aoc.Solutions.Day2 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    # Set noun and verb
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> run_machine(0)
  end

  defp try_nouns(initial_memory) do
    nil
  end

  defp run_machine(memory, pc) do
    IO.inspect(pc, label: "Program Counter")
    IO.inspect(memory, label: "Memory")

    memory
    |> Enum.at(pc)
    |> case do
      1 ->
        memory
        |> execute_add(pc)
        |> run_machine(pc + 4)

      2 ->
        memory
        |> execute_multiply(pc)
        |> run_machine(pc + 4)

      99 ->
        memory
        |> Enum.at(0)
    end
  end

  defp indirect_load(memory, address), do: Enum.at(memory, Enum.at(memory, address))

  defp execute_add(memory, pc) do
    left = indirect_load(memory, pc + 1)
    right = indirect_load(memory, pc + 2)
    output = Enum.at(memory, pc + 3)
    List.replace_at(memory, output, left + right)
  end

  defp execute_multiply(memory, pc) do
    left = indirect_load(memory, pc + 1)
    right = indirect_load(memory, pc + 2)
    output = Enum.at(memory, pc + 3)
    List.replace_at(memory, output, left * right)
  end
end
