defmodule AikaWeb.Router do
  use AikaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug AikaWeb.ApiAuthPlug
  end

  pipeline :authenticated do
    plug AikaWeb.CurrentUserPlug
  end

  pipeline :admin do
    plug AikaWeb.AdminPlug
  end

  scope "/", AikaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/register", UserController, :create
    get "/logout", SessionController, :delete
    post "/login", SessionController, :create

    get "/invite/:id", InviteController, :show
    post "/invite/:id/accept", InviteController, :accept

    pipe_through :authenticated
    get "/dashboard", DashboardController, :index

    post "/entries/:date", TimeEntryController, :create
    post "/users/generate_api_token", UserController, :generate_api_token
    delete "/entries/:id", TimeEntryController, :delete

    pipe_through :admin

    get "/users", UserController, :index
    post "/invites", InviteController, :create
    delete "/users/:id", UserController, :delete
    get "/users/:id", UserController, :show
    post "/users/:id/set_admin", UserController, :set_admin

    get "/organisation/edit", OrganisationController, :edit
    resources "/organisation", OrganisationController, only: [:update]

    get "/overview", DashboardController, :overview

    resources "/categories", CategoryController, only: [:index, :create, :delete]
  end

  scope "/api", AikaWeb do
    pipe_through :api

    post "/entries/:date", TimeEntryController, :create
  end
end
