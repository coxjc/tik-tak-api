defmodule Api.PhoneTest do
  use Api.ModelCase

  alias Api.Phone

  @valid_attrs %{code: "some content", code_sent: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, number: "some content", verified: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Phone.changeset(%Phone{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Phone.changeset(%Phone{}, @invalid_attrs)
    refute changeset.valid?
  end
end
