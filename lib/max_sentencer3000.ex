defmodule MS3000 do
  @moduledoc """
  Documentation for MaxSentencer3000.
  """

  alias MS3000.Parser

  @doc """
  Locates people, places and organizations in the sentence and prints them on console in
  rdf format.

  ## Examples

      iex> MaxSentencer3000.analyze_sentence("Elvis Presley was a thing.")
      :ok

  """
  def analyze_sentence(sentence, _opts \\ []) do
    sentence
    |> Parser.parse()
  end
end
