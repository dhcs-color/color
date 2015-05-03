json.array!(@games) do |game|
  json.extract! game, :id, :from_user_id, :to_user_id, :image_path, :is_accepted
  json.url game_url(game, format: :json)
end
