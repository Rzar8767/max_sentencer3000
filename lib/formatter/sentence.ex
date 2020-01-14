defmodule MS3000.Sentence do
  defstruct content: nil, link: nil, indexes: nil

  @type t :: %__MODULE__{
          content: String.t(),
          link: String.t(),
          indexes: {non_neg_integer, non_neg_integer}
        }
end
