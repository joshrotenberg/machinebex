defmodule ClassificationBox.Model do
  @derive [Poison.Decoder]
  defstruct [:id, :name, :classes, :options, :predict_only]

  @type t :: %__MODULE__{
          id: String.t() | atom(),
          name: String.t() | atom(),
          classes: [String.t() | atom()],
          options: ClassificationBox.ModelOptions.t(),
          predict_only: boolean()
        }
end

defmodule ClassificationBox.ModelList do
  defstruct [:models, :success]

  @type t :: %__MODULE__{
          models: [ClassificationBox.Model.t()],
          success: boolean()
        }
end

defmodule ClassificationBox.ModelOptions do
  @derive [Poison.Encoder]
  defstruct [:ngrams, :skipgrams]

  @type t :: %__MODULE__{
          ngrams: integer(),
          skipgrams: integer()
        }

  defimpl Poison.Encoder, for: ClassificationBox.ModelOptions do
    def encode(value, _options) do
      value
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
      |> Poison.encode!()
    end
  end
end

defmodule ClassificationBox.ModelStatistics do
  defstruct [:classes, :examples, :predictions, :success]
end

defmodule ClassificationBox.Input do
  @enforce_keys [:key, :type, :value]
  defstruct class: nil, key: nil, type: nil, value: nil
  @type t :: %__MODULE__{}
end

defmodule ClassificationBox.Prediction do
  defstruct [:id, :score]
end

defmodule ClassificationBox.Predictions do
    defstruct [:classes, :success]
end
