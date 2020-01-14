defmodule MS3000.Parser do
  @moduledoc """
  Add description for the module in few words here Filip.

  """

  @doc """
  Add description here Filip.

  ## Examples

      iex> sentence = "Florence May Harding studied at a school in Sydney, and with Douglas Robert Dundas, but in effect had no formal training in either botany or art."
      iex> MS3000.Parser.parse(sentence)
      [
        {"Florence May Harding", {0, 20}},
        {"Sydney", {44, 50}},
        {"Douglas Robert Dundas", {61, 82}}
      ]
  """

  def parse(string) do
    without_new_lines = String.replace(string, "\n", "")

    regex =
      ~r/(?!((A)?(The)?(At)?(Over)?(Under)?(Until)?(Through)?(Across)?(With)?(In)?\s))([A-Z]+[a-zA-Z]+)+([\s]([A-Z][a-zA-Z]+))*/

    unfiltered_regex_result = Regex.scan(regex, without_new_lines)
    regex_result = Enum.map(unfiltered_regex_result, fn matches -> List.first(matches) end)

    unfiltered_notsumed_regex_result_indexes =
      Regex.scan(regex, without_new_lines, return: :index)

    notsumed_regex_result_indexes =
      Enum.map(unfiltered_notsumed_regex_result_indexes, fn matches -> List.first(matches) end)

    regex_result_indexes = Enum.map(notsumed_regex_result_indexes, fn {a, b} -> {a, a + b} end)

    Enum.zip([regex_result, regex_result_indexes])
  end
end
