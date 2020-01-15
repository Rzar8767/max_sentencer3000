defmodule MS3000.Formatter do
   @moduledoc """
  This module is responsible for transforming known entities into RDF xml.

  """

  @doc """
  In case of list of entities being empty, it returns an error, otherwise it returns RDF xml.
  """

  def create_response(_sentence, []) do
    {:error, :no_recognized_entities}
  end

  def create_response(sentence, recognized_entities) do
    response =
      create_prefix()
      |> add_sentence_section(sentence)
      |> add_sections(sentence, recognized_entities)

    {:ok, response}
  end

  defp create_prefix() do
    """
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
    @prefix nif: <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
    @prefix dbpedia: <http://dbpedia.org/resource/> .
    @prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
    """
  end

  defp add_sentence_section(response, sentence) do
    %MS3000.Sentence{content: content, link: link, indexes: {begin_index, end_index}} = sentence

    response <>
      """
      <#{link}#char=#{begin_index},#{end_index}>
      a                     nif:RFC5147String , nif:String , nif:Context ;
      nif:beginIndex        "#{begin_index}"^^xsd:nonNegativeInteger ;
      nif:endIndex          "#{end_index}"^^xsd:nonNegativeInteger ;
      nif:isString          "#{content}"@en .
      """
  end

  defp add_sections(response, sentence, recognized_entities) do
    Enum.reduce(
      recognized_entities,
      response,
      fn recognized_entity, acc -> add_section(acc, sentence, recognized_entity) end
    )
  end

  defp add_section(response, sentence, recognized_entity) do
    %MS3000.Entity{class: class, indexes: {entity_begin_index, entity_end_index}, name: name} =
      recognized_entity

    %MS3000.Sentence{
      content: _content,
      link: link,
      indexes: {sentence_begin_index, sentence_end_index}
    } = sentence

    response <>
      """
      <#{link}#char=#{entity_begin_index},#{entity_end_index}>
      a                     nif:RFC5147String , nif:String ;
      nif:anchorOf          "#{name}"@en ;
      nif:beginIndex        "#{entity_begin_index}"^^xsd:nonNegativeInteger ;
      nif:endIndex          "#{entity_end_index}"^^xsd:nonNegativeInteger ;
      nif:referenceContext  <#{link}#char=#{sentence_begin_index},#{sentence_end_index}> ;
      itsrdf:taIdentRef     dbpedia:#{class} .
      """
  end
end
