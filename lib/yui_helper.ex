defmodule YuiHelper do
  use Nostrum.Consumer
  alias Nostrum.Api

  alias YuiHelper.Trivia
  alias YuiHelper.Ambiente
  alias YuiHelper.Invocar
  alias YuiHelper.Tradutor
  alias YuiHelper.SwordSkill

  @prefix "!"

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
   cond do
    String.starts_with?(msg.content, "!trivia") ->
        Api.Message.create(msg.channel_id, Trivia.run())

      String.starts_with?(msg.content, "!ambiente ") ->
        Api.Message.create(msg.channel_id, Ambiente.run(msg.content))

      String.starts_with?(msg.content, "!invocar ") ->
        Api.Message.create(msg.channel_id, Invocar.run(msg.content))

      String.starts_with?(msg.content, "!traduzir ") ->
        Api.Message.create(msg.channel_id, Tradutor.run(msg.content))

      String.starts_with?(msg.content, "!sword_skill ") ->
        Api.Message.create(msg.channel_id, SwordSkill.run(msg.content))

      String.starts_with?(msg.content, "!ping") ->
        Api.Message.create(msg.channel_id, "pong!")
     true -> :ignore
   end
  end
end
