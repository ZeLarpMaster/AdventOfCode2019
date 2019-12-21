defmodule Aoc.Solutions.Day5 do
  @behaviour Aoc.Solutions

  @opcodes %{
    1 => 3,
    2 => 3,
    3 => 1,
    4 => 1,
    99 => 0
  }

  @impl true
  def execute(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
    |> run_machine(0)
  end

  defp run_machine(memory, pc) do
    {opcode, modes} = memory |> load(pc) |> parse_opcode()

    parameters =
      modes
      |> Enum.with_index(1)
      |> Enum.map(fn {mode, i} ->
        memory
        |> load(pc + i)
        |> fetch_param(mode, memory)
      end)

    memory
    |> execute_opcode(opcode, parameters)
    |> case do
      {_memory, :halt} -> :halted
      {memory, offset} -> memory |> run_machine(pc + offset + 1)
    end
  end

  # ======== START OF OPCODES ========
  # Addition; arg1 + arg2 -> arg3
  defp execute_opcode(memory, 1, [{_, left}, {_, right}, {out, _} | _]) do
    {store(memory, out, left + right), 3}
  end

  # Multiply; arg1 * arg2 -> arg3
  defp execute_opcode(memory, 2, [{_, left}, {_, right}, {out, _} | _]) do
    {store(memory, out, left * right), 3}
  end

  # Input; stdin -> arg1
  defp execute_opcode(memory, 3, [{address, _} | _]) do
    value =
      IO.read(:line)
      |> String.trim()
      |> String.to_integer()

    {store(memory, address, value), 1}
  end

  # Output; arg1 -> stdout
  defp execute_opcode(memory, 4, [{_, value} | _]) do
    IO.puts(value)
    {memory, 1}
  end

  # Halts the machine
  defp execute_opcode(memory, 99, _args) do
    {memory, :halt}
  end

  # ======== END OF OPCODES ========

  defp fetch_param(param, :immediate, _memory), do: {param, param}
  defp fetch_param(param, :indirect, memory), do: {param, load(memory, param)}

  defp parse_opcode(opcode) do
    op = rem(opcode, 100)

    modes =
      opcode
      |> div(100)
      |> Integer.digits()
      |> Enum.reverse()
      |> pad_list(0, Map.fetch!(@opcodes, op))
      |> Enum.map(fn
        0 -> :indirect
        1 -> :immediate
      end)

    {op, modes}
  end

  defp load(memory, address), do: Map.fetch!(memory, address)
  defp store(memory, address, value), do: %{memory | address => value}

  defp pad_list(_, _, count) when count <= 0, do: []

  defp pad_list(list, value, count) do
    list ++ List.duplicate(value, count - length(list))
  end
end
