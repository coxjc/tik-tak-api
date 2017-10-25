defmodule Api.Router do
  use Api.Web, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
    plug Api.AuthTokenPlug, repo: Api.Repo
    plug Api.AdminPlug, repo: Api.Repo
  end

  scope "/api", Api do
    pipe_through :api
    get "/them", UserController, :them
    get "/is_admin", UserController, :is_admin
    post "/phones/verify", PhoneController, :verify
    resources "/users", UserController, only: [:create]
    resources "/phones", PhoneController
    resources "/posts", PostController, except: [:create, :update, :delete]
    get "/comments", PostController, :comments
    resources "/auth_tokens", AuthTokenController
  end

  scope "/api/managed", Api do
    pipe_through [:api, :authenticate_auth_token]
    get "/my_posts", PostController, :my_posts
    get "/me", UserController, :me
    resources "/posts", PostController, only: [:create]
    resources "/flags", FlagController, only: [:create]
    post "/vote", VoteController, :vote
    post "/comments", PostController, :comment
  end

  scope "/admin", Api do
    pipe_through [:api, :is_admin?]
    resources "/flags", FlagController, only: [:index, :show, :update]
    post "/users/suspend", UserController, :suspend
    post "/users/expel", UserController, :expel
    resources "/posts", PostController, only: [:update, :delete]
  end

end
