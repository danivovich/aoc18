defmodule Day01 do
  def to_number(item) do
    Regex.named_captures(~r/(?<sign>[+-])(?<number>\d+)/, item)
    |> _to_number()
  end

  def _to_number(%{"sign" => "+", "number" => num}) do
    String.to_integer(num)
  end

  def _to_number(%{"sign" => "-", "number" => num}) do
    String.to_integer(num) * -1
  end

  def data do
    {:ok, contents} = File.read("input.txt")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&to_number/1)
  end

  def look(number, accumulator) do
    new_sum = accumulator["sum"] + number
    case Map.fetch(accumulator, "reached") do
      {:ok, _number} ->
        accumulator
      :error ->
        case Map.fetch(accumulator, new_sum) do
          {:ok, _number} -> Map.put(accumulator, "reached", new_sum)
          :error -> Map.put(accumulator, new_sum, 1)
        end
        |> Map.put("sum", new_sum)
    end
  end

  def run_two(input, accum) do
    data = Enum.reduce(input, accum, &look/2)
    data
    |> Map.fetch("reached")
    |> check_two(input, data)
  end

  def check_two(:error, input, data) do
    run_two(input, data)
  end

  def check_two({:ok, number}, _input, _data) do
    number
  end

  def runone do
    data()
    |> Enum.sum()
    |> IO.inspect
  end

  def runtwo do
    data()
    #[7, 7, -2, -7, -4]
    |> run_two(%{ 0 => 1, "sum" => 0 })
    |> IO.inspect
  end
end

Day01.runone()
Day01.runtwo()
