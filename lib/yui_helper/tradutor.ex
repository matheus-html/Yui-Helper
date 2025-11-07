defmodule YuiHelper.Tradutor do
  @base_url "https://api.mymemory.translated.net/get"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 4)
    |> case do
      ["!traduzir", de, para, texto] ->
        call_api(de, para, texto)

      _ ->
        "Comando inválido. Use: `!traduzir [de] [para] [texto]` (ex: `!traduzir en pt Hello`)"
    end
  end

  defp call_api(de, para, texto) do
    langpair = "#{de}|#{para}"
    query_string = URI.encode_query(%{"q" => texto, "langpair" => langpair})
    url = @base_url <> "?" <> query_string

    case Finch.build(:get, url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)
        traducao = json["responseData"]["translatedText"]
        "**Tradução (Yui):** #{traducao}"

      {:error, _reason} ->
        "A API de tradução está offline."
    end
  end
end
