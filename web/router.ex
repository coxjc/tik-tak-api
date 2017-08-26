defmodule Api.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Api.AuthTokenPlug, repo: Api.Repo
    plug Api.AdminPlug, repo: Api.Repo
  end

  scope "/api", Api do
    pipe_through :api
    post "/phones/verify", PhoneController, :verify
    resources "/users", UserController, only: [:create]
    resources "/phones", PhoneController
    resources "/posts", PostController, except: [:create, :update, :delete]
    resources "/auth_tokens", AuthTokenController
  end

  scope "/api/managed", Api do
    pipe_through [:api, :authenticate_auth_token]
    get "/my_posts", PostController, :my_posts
    resources "/posts", PostController, only: [:create]
    resources "/flags", FlagController, only: [:create]
    post "/vote", VoteController, :vote
  end

  scope "/admin", Api do
    pipe_through [:api, :is_admin?]
    resources "/flags", FlagController, only: [:index, :show, :update]
    post "/users/suspend", UserController, :suspend
    post "/users/expel", UserController, :expel
    resources "/posts", PostController, only: [:update, :delete]
  end

end
