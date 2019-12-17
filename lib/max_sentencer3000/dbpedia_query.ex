defmodule MS3000.DbpediaQuery do
  @moduledoc """
  Responsible for querying Dbpedia and handing over the result.
  """
  @doc """

  [
  {"Florence May Harding", {0, 20}},
  {"Sydney", {44, 50}},
  {"Douglas Robert Dundas", {61, 82}}
  ]
  """

  def identify_sentence(sentence) do
    stream = Task.async_stream(sentence, &per_entity/1, [])
    Enum.to_list(stream)
  end

  defp per_entity({text, indexes}) do
    entity = query_dbpedia(text) |> format_result
    Map.put(entity, :indexes, indexes)
  end

  @spec query_dbpedia(String.t()) :: {:ok, %SPARQL.Query.Result{}} | {:error, Error.t()}
  def query_dbpedia(entity_name) do
    query = query_builder(entity_name)
    {:ok, result} = query |> SPARQL.Client.query("http://dbpedia.org/sparql")
    result
  end

  defp format_result(%SPARQL.Query.Result{results: [%{"person" => sigil}]}) do
    uri = RDF.IRI.parse(sigil)
    "/resource/" <> name = uri.path
    %{class: :person, name: name}
  end

  defp query_builder(entity) do
    _query2 = """
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    select *
    where {
      {
        ?person rdfs:label "#{entity}"@en.
        ?person a dbo:Person
      }
      UNION {
        ?place rdfs:label "#{entity}"@en.
        ?place a dbo:Place
      }
      UNION {
        ?organisation rdfs:label "#{entity}"@en.
        ?organisation a dbo:Organisation
      }
    }
    LIMIT 10
    """
  end
end
