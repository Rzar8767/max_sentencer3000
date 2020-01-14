defmodule MS3000 do
  @moduledoc """
  Documentation for MaxSentencer3000.
  """

  alias MS3000.Parser
  alias MS3000.DbpediaQuery

  @doc """
  Locates people, places and organizations in the sentence and returns a rdf document.


  ## Examples

      ie> MS3000.analyze_sentence("Elvis Presley was a thing.")
      <rfc>

  """
  def analyze_sentence(sentence, _opts \\ []) do
    with sentence_info <- get_sentence_info(sentence),
         entities <- get_entities(sentence),
         {known_entities, unknown_entities} <- split_entities(entities),
         {:ok, response} <- create_response(sentence_info, known_entities) do
      IO.puts("Known entities: #{inspect known_entities}")
      IO.puts("Unknown entities: #{inspect unknown_entities}")
      IO.puts("Response: #{response}")
    else
      error ->
        {:error, error}
        |> IO.inspect()
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
