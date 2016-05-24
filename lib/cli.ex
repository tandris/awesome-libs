defmodule AwesomeLibs.CLI do
  @moduledoc """
  Handle the command line parsing and dispatch to the correct functions.

  Return a tuple of {mode, filter} where mode can :category or :library or :help if help was given
  """

  def parse_args(argv) do
    parsed = OptionParser.parse(argv,
    switches: [help: :boolean, library: :boolean, category: :boolean],
    aliases: [h: :help, l: :library, c: :category])
    case parsed do
      {[help: true], _, _} -> :help
      {[library: true], [cId, lFilter], _} -> {:library, String.to_integer(cId), lFilter}
      {[category: true], [cFilter], _} -> {:category, cFilter, nil}
      _ -> :help
    end
  end


  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
    Print the usage description.

    ##Example

    iex> AwesomeLibs.CLI.process :help
    :ok
  """
  def process(:help) do
    IO.puts """
    Usage: elibs -c | --category | -l | --library <category filter | nil> <library filter | nil>

    -c or --category  filter the Elixir libraries by category
    -l or --library   filter a category by library name (a category id must be provided)
    """
  end

  @doc """
    Processes a library search request in the given category and returns the filtered library list.

    ##Examples

    iex> AwesomeLibs.CLI.process {:library, 2, ""}
    :ok
  """
  def process({:library, cId, lFilter}) do
    IO.puts "Find a library #{cId}:#{lFilter}"
  end

  @doc """
  Processes a category search request and returns the filtered category list.

  ##Example

  iex> AwesomeLibs.CLI.process {:category, "2"}
  :ok
  """
  def process({:category, cFilter}) do
    IO.puts "Find a category #{cFilter}"
  end
end
