defmodule KaiboshWeb.Router do
  use KaiboshWeb, :router
  # alias KaiboshWeb.Plugs.Authenticate

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    # plug Authenticate
  end

  pipeline :admin do
    # TODO: check user is admin
  end

  scope "/", KaiboshWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", KaiboshWeb do
    pipe_through :api

    post "/sign_in", UserSessionController, :create
    delete "/sign_out", UserSessionController, :delete
  end

  scope "/api", KaiboshWeb do
    pipe_through [:api, :api_auth]

    resources "/organisations", OrganisationController, only: [:show] do
      resources "/bases", BaseController, only: [:index]
      resources "/staff", StaffController, only: [:index]
    end
  end

  scope "/admin", KaiboshWeb.Admin do
    pipe_through [:api, :api_auth, :admin]

    resources "/organisations", OrganisationController, except: [:new, :edit]
    resources "/allocation_categories", AllocationCategoryController, except: [:new, :edit]
    resources "/bases", BaseController, except: [:new, :edit]
    resources "/staff", StaffController, except: [:new, :edit]
    resources "/sessions", SessionController, except: [:new, :edit]

    resources "/recipients", RecipientController, except: [:new, :edit]
    resources "/allocations", AllocationController, except: [:new, :edit]
    resources "/contacts", ContactController, except: [:new, :edit, :index]
    resources "/recipient_sessions", RecipientSessionController, except: [:new, :edit]
    resources "/holds", HoldController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: KaiboshWeb.Telemetry
    end
  end
end
