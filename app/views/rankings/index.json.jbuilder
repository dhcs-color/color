json.array!(@rankings) do |ranking|
  json.extract! ranking, :id, :game_id, :user_colors
  json.url ranking_url(ranking, format: :json)
end
