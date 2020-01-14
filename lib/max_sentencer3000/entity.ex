defmodule MS3000.Entity do
  defstruct name: nil, class: nil, indexes: nil

  @moduledoc """
  `Struct` representing an `Entity`.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          class: Atom.t(),
          indexes: {non_neg_integer, non_neg_integer}
        }
end
