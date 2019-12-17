defmodule MS3000 do
  @moduledoc """
  Documentation for MaxSentencer3000.
  """

  alias MS3000.Parser
  alias MS3000.DbpediaQuery

  @doc """
  Locates people, places and organizations in the sentence and prints them on console in
  rdf format.

  ## Examples

      iex> MS3000.analyze_sentence("Elvis Presley was a thing.")
      <rfc>

  """
  def analyze_sentence(sentence, _opts \\ []) do
    entities =
      sentence
      |> Parser.parse()
      |> DbpediaQuery.identify_entities()

    {known_entities, unknown_entities} =
      Enum.split_with(entities, fn
        %{class: :unknown} -> false
        _other -> true
      end)

    {known_entities, unknown_entities}
    # Marcin wywołaj swoje na known_entities tutaj
  end
end
