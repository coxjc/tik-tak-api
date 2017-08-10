defmodule Api.Router do
  use Api.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Api do
    pipe_through :api
    post "/phones/verify", PhoneController, :verify
    resources "/users", UserController
    resources "/phones", PhoneController
    resources "/posts", PostController
    resources "/auth_tokens", AuthTokenController
  end
end
