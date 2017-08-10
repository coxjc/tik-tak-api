defmodule Api.PhoneControllerTest do
  use Api.ConnCase

  alias Api.Phone
  @valid_attrs %{code: "some content", code_sent: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, number: "some content", verified: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, phone_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = get conn, phone_path(conn, :show, phone)
    assert json_response(conn, 200)["data"] == %{"id" => phone.id,
      "number" => phone.number,
      "code" => phone.code,
      "code_sent" => phone.code_sent,
      "verified" => phone.verified}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, phone_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, phone_path(conn, :create), phone: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Phone, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, phone_path(conn, :create), phone: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = put conn, phone_path(conn, :update, phone), phone: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Phone, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = put conn, phone_path(conn, :update, phone), phone: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = delete conn, phone_path(conn, :delete, phone)
    assert response(conn, 204)
    refute Repo.get(Phone, phone.id)
  end
end
