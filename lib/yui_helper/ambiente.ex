defmodule YuiHelper.Ambiente do
  @base_url "https://api.open-meteo.com/v1/forecast"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 2)
    |> case do
      ["!ambiente", cidade] ->
        call_api(String.capitalize(cidade))

      _ ->
        "Comando inválido. Use: `!ambiente [cidade]` (ex: `!ambiente Tokyo`)"
    end
  end

  defp call_api(cidade) do
    case get_coords(cidade) do
      {:ok, lat, lon} ->
        url = @base_url <> "?latitude=#{lat}&longitude=#{lon}&current=temperature_2m"

        case Finch.build(:get, url) |> Finch.request(MyFinch) do
          {:ok, response} ->
            {:ok, json} = JSON.decode(response.body)
            temp = json["current"]["temperature_2m"]
            "Análise de ambiente em **#{cidade}**: #{temp}°C"

          {:error, _reason} ->
            "A API de clima (Open-Meteo) está offline."
        end

      {:error, reason} ->
        reason
    end
  end

  defp get_coords("Tokyo"), do: {:ok, 35.68, 139.69}
  defp get_coords("Fortaleza"), do: {:ok, -3.71, -38.54}
  defp get_coords("London"), do: {:ok, 51.50, -0.12}

  defp get_coords(cidade),
    do: {:error, "Yui não reconhece o 'ambiente' **#{cidade}**. Tente 'Tokyo', 'Fortaleza' ou 'London'."}
end
