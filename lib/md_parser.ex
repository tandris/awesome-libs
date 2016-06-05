defmodule AwesomeLibs.MdParser do
  @moduledoc """
    Basic MarkDown parser which only parses the list parts of the document, and converts it to a strucut list.
  """

  @userAgent [{"UserAgent", "andras.toth@chilisoft.org"}]
  @baseUrl Application.get_env(:awesome_libs, :awesome_base_url)
  @tempFile "libraries.json"

  require Logger

  defmodule LibItem do
    @derive [Poison.Encoder]
    defstruct [:id, :name, :level]
  end

  @doc """
    It loads the stored JSON structure and returns the deserialize it.
    _Warn: the process method should be called before_
  """
  def load() do
    case File.read(@tempFile) do
      {:ok, data} -> {:ok, Poison.decode!(data, as: [%LibItem{}])}
      {:error, reason} -> {:error, "Data file not found or invalid call process method to regenerate it"}
    end
  end

  @doc """
    Fetch the given url, parse the markdown file and saves the result in JSON format.

    __Example__
    ```
    iex> AwesomeLibs.MdParser.process "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"
    :ok
  """
  def process(url) do
    Logger.debug("Fetching url #{url}")
    HTTPoison.get(url, @userAgent)
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    items = String.split(body, "\n")
    |> Enum.filter(&(&1 =~ ~r/^[ ]*- \[/))
    |> reformat
    |> Poison.encode!

    File.write(@tempFile, items)
    Logger.debug("Elixir libraries has been parsed and saved to #{@tempFile}")
    :ok
  end

  defp handle_response({:error, %{reason: reason}}) do
    Logger.error("Failed to get data. { reason = #{reason} }")
    :error
  end

  @doc """
    Reformats the given list of strings and converts them to LibItem.
    It expects thaht all the strings are markdown lists, so they are in a format:
    -  some text

  """
  def reformat(lines) do
    for l <- lines do
      [indentation, name] = String.split(l, "- ")
      [_, title] = Regex.run ~r/\[(.*)\]/, name
      %LibItem{id: UUID.uuid1(), name: title, level: div(String.length(indentation), 4)}
    end
  end

end
