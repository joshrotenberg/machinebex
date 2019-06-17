defmodule MachinebEx.Healthz do
  defstruct [:errors, :hostname, :metadata, :success]

  @type t :: %__MODULE__{
          errors: [String.t()],
          hostname: String.t(),
          success: boolean,
          metadata: map()
        }
end
