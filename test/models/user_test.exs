defmodule Api.UserTest do
  use Api.ModelCase

  alias Api.User

  @valid_attrs %{expelled: true, lat: "some content", lng: "some content", suspended: true, suspended_until: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, uuid: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
