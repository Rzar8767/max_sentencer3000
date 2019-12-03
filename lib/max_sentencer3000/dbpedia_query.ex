defmodule MS3000.DbpediaQuery do
  @moduledoc """
  Responsible for querying Dbpedia and handing over the result.
  """
  #TODO: GenServer with process pool/that spawns new processes
  @spec query_dbpedia(String.t()) :: {:ok, %SPARQL.Query.Result{}} | {:error, Error.t()}
  def query_dbpedia(entity_name) do
    query = query_builder(entity_name)
    query |> SPARQL.Client.query("http://dbpedia.org/sparql")
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
