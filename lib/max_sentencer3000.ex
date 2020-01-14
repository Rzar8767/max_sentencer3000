defmodule MS3000 do
  require Logger

  @moduledoc """
  Documentation for MaxSentencer3000.
  """

  alias MS3000.Parser
  alias MS3000.DbpediaQuery

  @doc """
  Locates people, places and organizations in the sentence and prints a rdf document.


  ## Examples

      iex> MS3000.analyze_sentence("Elvis Presley was a thing.")
      :ok

  """
  def analyze_sentence(sentence, _opts \\ []) do
    with sentence_info <- get_sentence_info(sentence),
         entities <- get_entities(sentence),
         {known_entities, unknown_entities} <- split_entities(entities),
         {:ok, response} <- create_response(sentence_info, known_entities) do
      Logger.debug("Known entities: #{inspect(known_entities)}")
      Logger.debug("Unknown entities: #{inspect(unknown_entities)}")
      Logger.debug("Response: #{response}")
      :ok
    else
      error ->
        {:error, error}
        |> inspect
        |> (&Logger.debug("Error: #{&1}")).()

        {:error, error}
    end
  end

  defp get_sentence_info(sentence) do
    %MS3000.Sentence{
      content: sentence,
      link: "http://example.com/example-task1",
      indexes: {0, String.length(sentence)}
    }
  end

  defp get_entities(sentence) do
    sentence
    |> Parser.parse()
    |> DbpediaQuery.identify_entities()
  end

  defp split_entities(entities) do
    Enum.split_with(
      entities,
      fn
        %{class: :unknown} -> false
        _other -> true
      end
    )
  end

  defp create_response(sentence_info, known_entities) do
    MS3000.Formatter.create_response(sentence_info, known_entities)
  end
end
