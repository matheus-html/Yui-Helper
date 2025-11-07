defmodule YuiHelper.Invocar do
  @base_url "https://api.waifu.pics/sfw/"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 2)
    |> case do
      ["!invocar", categoria] ->
        call_api(categoria)

      _ ->
        "Comando inválido. Use: `!invocar [categoria]` (ex: `!invocar waifu`)"
    end
  end

  defp call_api(categoria) do
    url = @base_url <> categoria

    case Finch.build(:get, url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)
        json["url"]

      {:error, _reason} ->
        "Não foi possível invocar. A API (waifu.pics) pode estar offline ou a categoria '#{categoria}' é inválida."
    end
  end
end
