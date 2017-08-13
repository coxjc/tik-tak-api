defmodule Api.FlagView do
  use Api.Web, :view

  def render("index.json", %{flag: flag}) do
    %{data: render_many(flag, Api.FlagView, "flag.json")}
  end

  def render("show.json", %{flag: flag}) do
    %{data: render_one(flag, Api.FlagView, "flag.json")}
  end

  def render("flag.json", %{flag: flag}) do
    %{id: flag.id,
      flagger_id: flag.flagger_id,
      post_id: flag.post_id,
      reason: flag.reason,
      active: flag.active}
  end
end
