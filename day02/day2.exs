defmodule Day02 do

  def count(string_ar, exactly) do
    [head | tail] = string_ar
    Enum.reduce_while(tail ++ ["_", "_"], {head, 1}, fn x, acc ->
      case acc do
        {"_", _} ->
          {:halt, 0}
        {^x, num} ->
          {:cont, {x, num + 1}}
        {_other_letter, ^exactly} ->
          {:halt, 1}
        {_other_letter, _} ->
          {:cont, {x, 1}}
      end
    end)
  end

  def count_string(string_ar) do
    [head | tail] = string_ar
    Enum.reduce_while(tail ++ ["_", "_"], {head, 1}, fn x, acc ->
      case acc do
        {"_", _} ->
          {:halt, nil}
        {^x, num} ->
          {:halt, x}
        {_other_letter, _} ->
          {:cont, {x, 1}}
      end
    end)
  end

  def clean(string) do
    String.split(string, "", trim: true)
  end

  def clean_and_sort(string) do
    String.split(string, "", trim: true)
    |> Enum.sort()
  end

  def data do
    {:ok, contents} = File.read("input.txt")

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&clean_and_sort/1)
  end

  def run do
    twos = data()
    |> Enum.map(fn x -> count(x, 2) end)
    |> Enum.sum()
    threes = data()
    |> Enum.map(fn x -> count(x, 3) end)
    |> Enum.sum()
    IO.puts(twos * threes)
  end

  def run2 do
    {:ok, contents} = File.read("input.txt")
    matrix = contents
    |> String.split("\n", trim: true)
    |> Enum.map(&clean/1)

    len = length(matrix)
    ats = length(List.first(matrix))
    atrange = Range.new(0, ats - 1)
    inputrange = Range.new(0, len - 1)
    Enum.map(atrange, fn at ->
      shortened_matrix = Enum.map(matrix, fn input ->
        {_, shortened} = List.pop_at(input, at)
        Enum.join(shortened)
      end)
      shortened_matrix
      |> Enum.sort
      |> count_string()
    end)
    |> Enum.find(fn x -> x end)
    |> IO.puts()
  end
end

Day02.run2()
