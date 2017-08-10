defmodule Api.AuthTokenTest do
  use Api.ModelCase

  alias Api.AuthToken

  @valid_attrs %{token: "some content", valid: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AuthToken.changeset(%AuthToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AuthToken.changeset(%AuthToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
