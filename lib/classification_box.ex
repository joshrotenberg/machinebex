defmodule ClassificationBox do
  @moduledoc """
  """

  use MachinebEx
  alias ClassificationBox.{Model, ModelList, ModelStatistics, Input, Prediction, Predictions}

  @default_prediction_limit 10
  @default_download_recv_timeout 10000

  def prediction_limit do
    Application.get_env(:classification_box, :prediction_limit, @default_prediction_limit)
  end

  def create_model(model) do
    post("classificationbox/models", model, opts: [decode_as: %Model{}])
  end

  def list_models do
    get("classificationbox/models", opts: [decode_as: %ModelList{models: [%Model{}]}])
  end

  def get_model(model_id) do
    get("classificationbox/models/#{model_id}", opts: [decode_as: %Model{}])
  end

  def delete_model(model_id) do
    delete("classificationbox/models/#{model_id}")
  end

  def model_statistics(model_id) do
    get("classificationbox/models/#{model_id}/stats", opts: [decode_as: %ModelStatistics{}])
  end

  def download(model_id, opts \\ []) do
    timeout = Keyword.get(opts, :recv_timeout, @default_download_recv_timeout)

    get("classificationbox/state/#{model_id}",
      opts: [adapter: [recv_timeout: timeout]]
    )
  end

  def upload(data) do
    encoded_data = Base.encode64(data)

    post(
      "classificationbox/state",
      %{base64: encoded_data},
      headers: ["Content-type": "application/json; charset=utf-8"],
      opts: [decode_as: %Model{}]
    )
  end

  def teach(model_id, input = %Input{}) do
    post("classificationbox/models/#{model_id}/teach", input, opts: [decode_as: :json])
  end

  def teach_multi(model_id, inputs) when is_list(inputs) do
    examples =
      inputs
      |> Enum.group_by(fn m -> Map.get(m, :class) end)
      |> Enum.map(fn {k, v} ->
        {k, Enum.map(v, fn m -> Map.drop(m, [:class]) end)}
      end)
      |> Enum.map(fn {k, v} -> %{class: k, inputs: v} end)

    post("classificationbox/models/#{model_id}/teach-multi", %{examples: examples},
      opts: [decode_as: :json]
    )
    end

  def predict(model_id, inputs, limit \\ prediction_limit()) do
    post("classificationbox/models/#{model_id}/predict", %{inputs: inputs, limit: limit},
      opts: [decode_as: %Predictions{classes: [%Prediction{}]}]
    )
  end

end
