defmodule Api.FoodTest do
  use Api.ModelCase

  alias Api.Food

  @valid_attrs %{expires_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, location_string: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Food.changeset(%Food{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Food.changeset(%Food{}, @invalid_attrs)
    refute changeset.valid?
  end
end
