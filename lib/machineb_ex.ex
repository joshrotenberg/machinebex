defmodule MachinebEx do
  @moduledoc """
  Documentation for MachinebEx.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MachinebEx.hello()
      :world

  """
  defmacro __using__(_) do
    quote do
      use Tesla
      @box_url_default "http://localhost:8080"

      alias MachinebEx.{Info,Healthz}

      plug(
        Tesla.Middleware.BaseUrl,
        Application.get_env(:classification_box, :box_url, @box_url_default)
      )

      plug(Tesla.Middleware.EncodeJson, engine: Poison)
      plug(MachinebEx.Middleware.DecodeResponse)

      plug(Tesla.Middleware.BasicAuth, username: username(), password: password())

      def username do
        Application.get_env(:machinebex, :username) || System.get_env("MB_BASICAUTH_USER")
      end

      def password do
        Application.get_env(:machinebex, :password) || System.get_env("MB_BASICAUTH_PASS")
      end

      @doc """
      """
      def readyz do
        #  opts: [decode_as: :skip])
        get("readyz")
      end

      @doc """
      """
      def healthz, do: get("healthz", opts: [decode_as: %Healthz{}])

      @doc """
      """
      def info do
        get("info", opts: [decode_as: %Info{}])
      end

      @doc """
      """
      def liveness do
        get("liveness")
      end
    end
  end
end
