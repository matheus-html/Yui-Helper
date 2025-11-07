defmodule YuiHelper do
  use Nostrum.Consumer
  alias Nostrum.Api
  @moduledoc """
  Documentation for `YuiHelper`.
  """

  @doc """
  Hello world.
iex -S mix
  ## Examples

      iex> YuiHelper.hello()
      :world

  """
  def hello do
    :world
  end

def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!ping" ->
        Api.Message.create(msg.channel_id, "Pong!")
      _ ->
        :ignore
    end
  end
end
