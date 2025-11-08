defmodule YuiHelper.Ambiente do
  @weather_url "https://api.open-meteo.com/v1/forecast"
  @geo_url "https://geocoding-api.open-meteo.com/v1/search"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 2)
    |> case do
      ["!ambiente", cidade] ->
        call_geocoding_api(cidade)

      _ ->
        "Comando inválido. Use: `!ambiente [cidade]` (ex: `!ambiente Tokyo`)"
    end
  end

  defp call_geocoding_api(cidade) do
    query_string = URI.encode_query(%{"name" => cidade, "count" => 1})
    url = @geo_url <> "?" <> query_string

    case Finch.build(:get, url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)
        handle_geocoding_result(json, cidade)

      {:error, _reason} ->
        "A API de Geocodificação (Open-Meteo) está offline."
    end
  end

defp handle_geocoding_result(json, cidade_original) do
    if not Map.has_key?(json, "results") do
      "Yui não conseguiu processar o 'ambiente' **#{cidade_original}**. (API de Geocodificação falhou)"
    else
      case json["results"] do
        [primeiro_resultado | _] ->
          lat = primeiro_resultado["latitude"]
          lon = primeiro_resultado["longitude"]
          nome_real = primeiro_resultado["name"]

          call_weather_api(lat, lon, nome_real)

        [] ->
          "Yui não conseguiu encontrar o 'ambiente' **#{cidade_original}**."
      end
    end
  end

  defp call_weather_api(lat, lon, nome_real) do
    url = @weather_url <> "?latitude=#{lat}&longitude=#{lon}&current=temperature_2m"

    case Finch.build(:get, url) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)
        temp = json["current"]["temperature_2m"]
        "Análise de ambiente em **#{nome_real}**: #{temp}°C"

      {:error, _reason} ->
        "A API de clima (Open-Meteo) está offline."
    end
  end
end
