defmodule Api.FlagTest do
  use Api.ModelCase

  alias Api.Flag

  @valid_attrs %{active: true, reason: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Flag.changeset(%Flag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Flag.changeset(%Flag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
