defmodule Aoc.Solutions.Day2 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    try do
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> try_nouns_and_verbs()
    catch
      value -> value
    else
      _ -> "Didn't find anything"
    end
  end

  defp try_nouns_and_verbs(initial_memory) do
    for noun <- 0..99,
        verb <- 0..99,
        memory = List.replace_at(initial_memory, 1, noun),
        memory = List.replace_at(memory, 2, verb),
        output =
          run_machine(memory, 0) |> IO.inspect(label: "Noun: #{noun}; Verb: #{verb}; Got:"),
        output == 19_690_720 do
      throw(100 * noun + verb)
    end
  end

  defp run_machine(memory, pc) do
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
