defmodule MS3000.FormatterTest do
  use ExUnit.Case
  doctest MS3000.Formatter

  test "create response" do
    content = "Elvis Presley was a thing."
    link = "http://example.com/example-task1"

    sentence = %MS3000.Sentence{
      content: content,
      link: link,
      indexes: {0, String.length(content)}
    }

    recognized_entities = [
      %MS3000.Entity{
        class: :person,
        indexes: {0, 13},
        name: "Elvis Presley"
      }
    ]

    assert MS3000.Formatter.create_response(sentence, recognized_entities) == {
             :ok,
             """
             @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
             @prefix nif: <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
             @prefix dbpedia: <http://dbpedia.org/resource/> .
             @prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
             <http://example.com/example-task1#char=0,26>
             a                     nif:RFC5147String , nif:String , nif:Context ;
             nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
             nif:endIndex          "26"^^xsd:nonNegativeInteger ;
             nif:isString          "Elvis Presley was a thing."@en .
             <http://example.com/example-task1#char=0,13>
             a                     nif:RFC5147String , nif:String ;
             nif:anchorOf          "Elvis Presley"@en ;
             nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
             nif:endIndex          "13"^^xsd:nonNegativeInteger ;
             nif:referenceContext  <http://example.com/example-task1#char=0,26> ;
             itsrdf:taIdentRef     dbpedia:person .
             """
           }
  end
end
