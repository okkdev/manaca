defmodule ManacaWeb.Router do
  use ManacaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ManacaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ManacaWeb.ApiAuthPlug
  end

  scope "/", ManacaWeb do
    pipe_through :browser

    live_session :default do
      live "/", HomeLive.Index
      live "/new", HomeLive.Index, :new

      live "/users", UserLive.Index, :index
      live "/users/new", UserLive.Index, :new
      live "/users/:id/edit", UserLive.Index, :edit

      live "/users/:id", UserLive.Show, :show
      live "/users/:id/show/edit", UserLive.Show, :edit
    end
  end

  scope "/api", ManacaWeb do
    pipe_through :api

    resources "/cards", CardController, only: [:show, :update]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:manaca, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ManacaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
