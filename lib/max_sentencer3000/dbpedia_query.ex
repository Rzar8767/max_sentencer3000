defmodule MS3000.DbpediaQuery do
  @moduledoc """
  Responsible for querying Dbpedia and handing over the result.
  """
  alias MS3000.Entity
  require Logger

  @doc """
  For every existing potential entity performs a general dbpedia query and categorizes every single one of them into one of few predefined categories.

  These are:
  `:person`, `:place`, `:organisation` and `:unknown`.

  ## Examples

      iex> input = [{"Florence May Harding", {0, 20}}, {"Sydney", {44, 50}}, {"Douglas Robert Dundas", {61, 82}}]
      iex> MS3000.DbpediaQuery.identify_entities(input)
      [
        %MS3000.Entity{class: :person, indexes: {0, 20}, name: "Florence May Harding"},
        %MS3000.Entity{class: :place, indexes: {44, 50}, name: "Sydney"},
        %MS3000.Entity{
          class: :unknown,
          indexes: {61, 82},
          name: "Douglas Robert Dundas"
        }
      ]
  """
  def identify_entities(entities) do
    stream = Task.async_stream(entities, &per_entity/1, [])
    Enum.map(stream, fn {:ok, ent} -> ent end)
  end

  defp per_entity({text, indexes}) do
    %Entity{}
    |> add_class(retry_query(text, 5))
    |> Map.put(:name, text)
    |> Map.put(:indexes, indexes)
  end

  @doc """
  In case of failure queries DBpedia SPARQL Endpoint up till retry count reaches `0`.
  In case of retry count reaching 0 defines entity as `:unknown`.
  """
  @spec retry_query(String.t(), number) :: map()
  def retry_query(entity_name, 0) do
    Logger.info("Gave up querying for #{entity_name}, returning empty")
    %{results: []}
  end

  def retry_query(entity_name, retry_count) do
    case query_dbpedia(entity_name) do
      {:ok, result} ->
        %{results: result.results}

      {:error, reason} ->
        Logger.debug("Query failed with reason: #{inspect(reason)}")
        Process.sleep(200)
        retry_query(entity_name, retry_count - 1)
    end
  end

  @doc """
  Extracts information from DBpedia's SPARQL Endpoint about whether an entity belongs to
  one of interesting for us categories.

  These are as follows:
  * dbo:Person
  * dbo:Entity
  * dbo:Organisation
  """

  @spec query_dbpedia(String.t()) :: {:ok, SPARQL.Query.Result.t()} | {:error, Error.t()}
  def query_dbpedia(entity_name) do
    query = query_builder(entity_name)
    query |> SPARQL.Client.query("http://dbpedia.org/sparql")
  end

  defp add_class(entity, %{results: result}) do
    result = List.first(result)

    case result do
      %{"person" => _sigil} ->
        Map.put(entity, :class, :person)

      %{"place" => _sigil} ->
        Map.put(entity, :class, :place)

      %{"organisation" => _sigil} ->
        Map.put(entity, :class, :organisation)

      _other ->
        Map.put(entity, :class, :unknown)
    end
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
