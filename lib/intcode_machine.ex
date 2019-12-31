defmodule IntcodeMachine do
  # pc = Program Counter
  # in = INput device
  # out = OUTput device
  defstruct [:memory, pc: 0, device: :stdio]

  @opcodes %{
    1 => 3,
    2 => 3,
    3 => 1,
    4 => 1,
    5 => 2,
    6 => 2,
    7 => 3,
    8 => 3,
    99 => 0
  }

  def new(program) do
    memory =
      program
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {value, index} -> {index, value} end)
      |> Enum.into(%{})

    %IntcodeMachine{memory: memory}
  end

  def run(machine, device) do
    machine
    |> Map.replace!(:device, device)
    |> run()
  end

  def run(machine) do
    {opcode, modes} = machine |> load(:relative, 0) |> parse_opcode()

    parameters =
      modes
      |> Enum.with_index(1)
      |> Enum.map(fn {mode, i} ->
        machine
        |> load(:relative, i)
        |> fetch_param(mode, machine)
      end)

    machine
    |> execute_opcode(opcode, parameters)
    |> case do
      {_machine, :halt} -> :halted
      {machine, offset} -> machine |> increment_pc(offset + 1) |> run()
      machine -> machine |> run()
    end
  end

  # ======== START OF OPCODES ========
  # Addition; arg1 + arg2 -> arg3
  defp execute_opcode(machine, 1, [{_, left}, {_, right}, {out, _}]) do
    {store(machine, out, left + right), 3}
  end

  # Multiply; arg1 * arg2 -> arg3
  defp execute_opcode(machine, 2, [{_, left}, {_, right}, {out, _}]) do
    {store(machine, out, left * right), 3}
  end

  # Input; stdin -> arg1
  defp execute_opcode(machine, 3, [{address, _}]) do
    value =
      IO.read(machine.device, :line)
      |> String.trim()
      |> String.to_integer()

    {store(machine, address, value), 1}
  end

  # Output; arg1 -> stdout
  defp execute_opcode(machine, 4, [{_, value}]) do
    IO.puts(machine.device, value)
    {machine, 1}
  end

  # Jump-if-true; If arg1 is non-zero, jump to arg2
  defp execute_opcode(machine, 5, [{_, 0}, {_, _dst}]), do: {machine, 2}
  defp execute_opcode(machine, 5, [{_, _}, {_, dest}]), do: jump(machine, dest)

  # Jump-if-false; If arg1 is zero, jump to arg2
  defp execute_opcode(machine, 6, [{_, 0}, {_, dest}]), do: jump(machine, dest)
  defp execute_opcode(machine, 6, [{_, _}, {_, _dst}]), do: {machine, 2}

  # Less-than; If arg1 < arg2, 1 -> arg3
  defp execute_opcode(machine, 7, [{_, left}, {_, right}, {out, _}]) do
    value = if left < right, do: 1, else: 0
    {store(machine, out, value), 3}
  end

  # Equal; If arg1 == arg2, 1 -> arg3
  defp execute_opcode(machine, 8, [{_, left}, {_, right}, {out, _}]) do
    value = if left == right, do: 1, else: 0
    {store(machine, out, value), 3}
  end

  # Halts the machine
  defp execute_opcode(machine, 99, _args) do
    {machine, :halt}
  end

  # ======== END OF OPCODES ========

  defp fetch_param(param, :immediate, _machine), do: {param, param}
  defp fetch_param(param, :indirect, machine), do: {param, load(machine, :absolute, param)}

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

  defp jump(machine, new_pc), do: Map.replace!(machine, :pc, new_pc)
  defp increment_pc(machine, offset), do: Map.update!(machine, :pc, &(&1 + offset))

  defp load(machine, :relative, address), do: Map.fetch!(machine.memory, machine.pc + address)
  defp load(machine, :absolute, address), do: Map.fetch!(machine.memory, address)

  defp store(machine, address, value),
    do: Map.update!(machine, :memory, &Map.replace!(&1, address, value))

  defp pad_list(_, _, count) when count <= 0, do: []

  defp pad_list(list, value, count) do
    list ++ List.duplicate(value, count - length(list))
  end
end
