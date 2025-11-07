defmodule YuiHelper.Invocar do
  @base_url "https://api.jikan.moe/v4/characters"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 2)
    |> case do
      ["!invocar", nome] ->
        call_api(nome)

      _ ->
        "Comando inválido. Use: `!invocar [nome do personagem]` (ex: `!invocar Kirito`)"
    end
  end

  defp call_api(nome) do
    query_string = URI.encode_query(%{"q" => nome})
    url = @base_url <> "?" <> query_string

    case Finch.build(:get, url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)

        case json["data"] do
          [primeiro_resultado | _] ->
            nome_personagem = primeiro_resultado["name"]
            imagem_url = primeiro_resultado["images"]["jpg"]["image_url"]

            "Yui invocou: **#{nome_personagem}**\n#{imagem_url}"

          [] ->
            "Yui não encontrou ninguém com o nome: **#{nome}**"
        end

      {:error, _reason} ->
        "A API do MyAnimeList (Jikan) está offline."
    end
  end
end
