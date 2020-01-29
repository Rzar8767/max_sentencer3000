# MaxSentencer3000
Basic test of named entity identification in Elixir language.
## Links:
* https://project-hobbit.eu/challenges/oke2018-challenge-eswc-2018/tasks/
* https://github.com/marcelotto/sparql-ex
* https://github.com/marcelotto/sparql_client
* https://github.com/marcelotto/rdf-ex
* https://rdf-elixir.dev/sparql-ex/

## How to generate documentation
In the project's directory run `mix docs` command.
You can view the generated documentation by opening the "doc/index.html" file in your favorite browser.

# How to run
Download Elixir v1.8+
In project's root directory type "mix deps.get" to get the dependencies.
To run project type "iex -S mix run" (in Windows' case is it may require to run iex.bat instead).
Next type MS3000.analyze_sentence(text), where 'text' is a sentence you wish to get the rdf document for.




