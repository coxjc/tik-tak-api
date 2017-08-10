defmodule Api.AuthTokenControllerTest do
  use Api.ConnCase

  alias Api.AuthToken
  @valid_attrs %{token: "some content", valid: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, auth_token_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    auth_token = Repo.insert! %AuthToken{}
    conn = get conn, auth_token_path(conn, :show, auth_token)
    assert json_response(conn, 200)["data"] == %{"id" => auth_token.id,
      "token" => auth_token.token,
      "user_id" => auth_token.user_id,
      "valid" => auth_token.valid}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, auth_token_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, auth_token_path(conn, :create), auth_token: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AuthToken, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, auth_token_path(conn, :create), auth_token: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    auth_token = Repo.insert! %AuthToken{}
    conn = put conn, auth_token_path(conn, :update, auth_token), auth_token: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AuthToken, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    auth_token = Repo.insert! %AuthToken{}
    conn = put conn, auth_token_path(conn, :update, auth_token), auth_token: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    auth_token = Repo.insert! %AuthToken{}
    conn = delete conn, auth_token_path(conn, :delete, auth_token)
    assert response(conn, 204)
    refute Repo.get(AuthToken, auth_token.id)
  end
end
