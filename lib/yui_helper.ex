defmodule YuiHelper do
  use Nostrum.Consumer
  alias Nostrum.Api

  @prefix "!"

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
   cond do
     String.starts_with?(msg.content, "!ping") -> Api.Message.create(msg.channel_id, "pong!")
     true -> :ignore
   end
  end
end
