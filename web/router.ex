defmodule Api.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Api.AuthTokenPlug, repo: Api.Repo
  end

  scope "/api", Api do
    pipe_through :api
    post "/phones/verify", PhoneController, :verify
    resources "/users", UserController
    resources "/phones", PhoneController
    resources "/posts", PostController, except: [:create]
    resources "/auth_tokens", AuthTokenController
  end

  scope "/api/managed", Api do
    pipe_through [:api, :authenticate_auth_token]
    resources "/posts", PostController, only: [:create]
  end

end
