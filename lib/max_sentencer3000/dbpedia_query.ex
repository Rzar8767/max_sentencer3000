defmodule MS3000.DbpediaQuery do
  def test() do
    query = """
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    SELECT DISTINCT ?resource ?p ?value where {
    ?resource rdfs:label "screen"@en.
    ?resource ?p ?value
    }
    """

    query |> SPARQL.Client.query("http://dbpedia.org/sparql")
  end
end
