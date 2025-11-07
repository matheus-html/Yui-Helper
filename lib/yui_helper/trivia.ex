defmodule YuiHelper.Trivia do
  @api_url "https://uselessfacts.jsph.pl/api/v2/facts/random"

  def run do
    headers = [{"Accept", "application/json"}]

    case Finch.build(:get, @api_url, headers) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)
        "Yui encontrou um dado aleatório no Sistema: *#{json["text"]}*"

      {:error, _reason} ->
        "A API de fatos (Useless Facts) está offline."
    end
  end
end
