defmodule YuiHelper.Post do
  @base_url "https://jsonplaceholder.typicode.com/posts/"

  def run do
    random_id = Enum.random(1..100)
    url = @base_url <> to_string(random_id)

    case Finch.build(:get, url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)
        "Yui interceptou uma mensagem de fórum: **#{json["title"]}**"

      {:error, _reason} ->
        "O 'fórum' (JSONPlaceholder) está offline."
    end
  end
end
