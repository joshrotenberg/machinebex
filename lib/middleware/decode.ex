defmodule MachinebEx.Middleware.DecodeResponse do
  alias Tesla.Env

  @impl Tesla.Middleware
  def call(env, next, _) do
    decode(Tesla.run(env, next), env.opts[:decode_as])
  end

  defp decode({:ok, %Env{status: status, body: body}}, nil) when status in 200..299,
    do: {:ok, body}

  defp decode({:ok, %Env{status: status, body: body}}, :json) when status in 200..299,
    do: Poison.decode(body, keys: :atoms)

  defp decode({:ok, %Env{status: status, body: body}}, as) when status in 200..299,
    do: Poison.decode(body, as: as, keys: :atoms)

  defp decode({:ok, %Env{status: status, body: body}}, _as) when status in 400..599,
    do: {:error, body}

  defp decode({:ok, %Env{body: ""} = env}, _), do: {:error, %Env{env | body: %{}}}

  defp decode(error, _), do: error
end
