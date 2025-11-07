defmodule YuiHelper.Rumor do
  @api_url "https://animechan.xyz/api/random"

  def run do
    case Finch.build(:get, @api_url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)

        """
        Yui ouviu um rumor...
        > **"#{json["quote"]}"**
        — *#{json["character"]} (Anime: #{json["anime"]})*
        """

      {:error, _reason} ->
        "A API de rumores (AnimeChan) está offline."
    end
  end
end
