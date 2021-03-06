defmodule Rocdev.MeetupAPI do
  @moduledoc """
  Provides access to Meetup API.
  """

  @base_url Application.get_env(:rocdev, :meetup_api_base_url)

  def past do
    HTTPoison.get(
      @base_url <> "/events",
      [],
      [params: [status: "past", page: 3, desc: true]]
    )
    |> handle_response
  end

  def upcoming do
    HTTPoison.get(
      @base_url <> "/events",
      [],
      [params: [status: "upcoming", page: 3]]
    )
    |> handle_response
  end

  def handle_response(response) do
    with {:ok, response} <- response,
         {:ok, body} <- process_response_body(response.body) do
      {:ok, body}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "unknown"}
    end
  end

  def process_response_body(body) do
    case Poison.decode(body) do
      {:ok, json} -> {:ok, json}
      _ -> {:error, body}
    end
  end
end