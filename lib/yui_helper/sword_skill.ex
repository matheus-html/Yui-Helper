defmodule YuiHelper.SwordSkill do
  @api_url "https://api.mathjs.org/v4/"

  def run(message_content) do
    message_content
    |> String.split(" ", parts: 3)
    |> case do
      ["!sword_skill", base, multiplier] ->
        call_api(base, multiplier)

      _ ->
        "Comando inválido. Use: `!sword_skill [base] [multiplicador]` (ex: `!sword_skill 150 2.5`)"
    end
  end

  defp call_api(base, multiplier) do
    expression = "#{base} * #{multiplier}"
    body = %{expr: expression} |> JSON.encode!()
    headers = [{"Content-Type", "application/json"}]

    case Finch.build(:post, @api_url, headers, body) |> Finch.request(MyFinch) do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)

        if json["error"] do
          "**Erro de Cálculo (Yui):** #{json["error"]}"
        else
          "⚔️ **Dano da Sword Skill:** #{json["result"]}!"
        end

      {:error, _reason} ->
        "O Sistema Cardinal (math.js) parece estar offline."
    end
  end
end
