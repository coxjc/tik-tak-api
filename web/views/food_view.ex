defmodule Api.FoodView do
  use Api.Web, :view

  def render("index.json", %{food: food}) do
    %{data: render_many(food, Api.FoodView, "food.json")}
  end

  def render("show.json", %{food: food}) do
    %{data: render_one(food, Api.FoodView, "food.json")}
  end

  def render("food.json", %{food: food}) do
    %{id: food.id,
      post_id: food.post_id,
      location_string: food.location_string,
      expires_at: food.expires_at}
  end
end
