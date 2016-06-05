defmodule AwesomeLibs.Search do
  @moduledoc """
   Library search module which iterates through the parsed (by the MdParser module) Markdown list.
  """

  defmodule Filter do
    defstruct [:level, :pattern]
  end

  def list(level) when is_integer(level) do
    {:ok, items} = AwesomeLibs.MdParser.load
    filter(items, %Filter{level: level, pattern: nil})
    |> Enum.sort(fn(a, b) -> a.name <= b.name end)
    |> printTable
    :ok
  end

  def search(filterPattern, level\\nil) when is_bitstring(filterPattern) do
    {:ok, items} = AwesomeLibs.MdParser.load
    filter(items, %Filter{level: level, pattern: String.downcase(filterPattern)})
    |> Enum.sort(fn(a, b) -> a.name <= b.name end)
    |> printTable
  end

  defp filter(items, %Filter{level: nil, pattern: filterPattern}) do
    for item <- items, String.contains?(String.downcase(item.name), filterPattern) do
      item
    end
  end

  defp filter(items, %Filter{level: level, pattern: nil}) do
    for item <- items, item.level == level do
      item
    end
  end

  defp filter(items, %Filter{level: level, pattern: filterPattern}) do
    for item <- items, String.contains?(String.downcase(item.name), filterPattern) && item.level == level do
      item
    end
  end

  defp printTable(items) when length(items) > 0 do
    maxName = String.length(Enum.max_by(items, &(String.length(&1.name))).name)
    tableBody = for item <- items do
      spaces = String.duplicate(" ", maxName - String.length(item.name))
      "#{item.level}     | #{item.name <> spaces}\n"
    end

    IO.puts "Level | Name"
    IO.puts tableBody
  end

  defp printTable(items) do
    IO.puts "No results"
  end
end
