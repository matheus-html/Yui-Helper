defmodule YuiHelper.Ambiente do
  @base_url "https://wttr.in/"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 2)
    |> case do
      ["!ambiente", cidade] ->
        call_api(cidade)

      _ ->
        "Comando inválido. Use: `!ambiente [cidade]` (ex: `!ambiente Tokyo`)"
    end
  end

  defp call_api(cidade) do
    cidade_encodada = URI.encode_www_form(cidade)
    url = @base_url <> cidade_encodada <> "?format=j1"

    headers = [{"Accept", "application/json"}]

    case Finch.build(:get, url, headers) |> Finch.request(MyFinch) do
      {:ok, response} ->
        case JSON.decode(response.body) do
          {:ok, json} ->
            case json["current_condition"] do
              [condicao_atual | _] ->
                temp = condicao_atual["temp_C"]
                "Análise de ambiente em **#{cidade}**: #{temp}°C"

              _ ->
                "Yui não conseguiu encontrar dados para **#{cidade}**."
            end

          {:error, _} ->
            "Yui não conseguiu encontrar o 'ambiente' **#{cidade}**. (Cidade não encontrada?)"
        end

      {:error, _reason} ->
        "A API de clima (wttr.in) está offline."
    end
  end
end
