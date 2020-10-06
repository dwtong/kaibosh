defmodule KaiboshWeb.Router do
  use KaiboshWeb, :router
  alias KaiboshWeb.Plugs.Authenticate

  @csp "default-src 'self'; script-src 'self' plausible.io api.usersnap.com cdn.lr-ingest.io cdn.usersnap.com use.fontawesome.com 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline' 'unsafe-eval'; img-src 'self' data:"

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Authenticate
  end

  scope "/api/auth", KaiboshWeb do
    pipe_through :api

    post "/sign_in", AuthController, :create
    delete "/sign_out", AuthController, :delete
    post "/reset_password", AuthController, :password_reset
    put "/update_password", AuthController, :update_password
  end

  scope "/api/signup", KaiboshWeb do
    pipe_through [:api]

    get "/bases", SignupController, :bases
    post "/", SignupController, :create
  end

  scope "/api", KaiboshWeb do
    pipe_through [:api]

    get "/status", StatusController, :show
  end

  scope "/api", KaiboshWeb do
    pipe_through [:api, :api_auth]

    resources "/users", UserController, only: [:index, :create, :update]
    resources "/categories", CategoryController, only: [:index]

    resources "/bases", BaseController, only: [:index] do
      resources "/sessions", SessionController, only: [:index]
      resources "/plans", SessionPlanController, only: [:index, :show]
    end

    resources "/recipients", RecipientController, except: [:new, :edit] do
      resources "/sessions", RecipientSessionController, except: [:new, :edit]
      resources "/holds", HoldController, only: [:create, :delete]
    end
  end

  scope "/api/admin", KaiboshWeb.Admin do
    pipe_through [:api, :api_auth]

    resources "/organisations", OrganisationController, except: [:new, :edit]
    resources "/categories", CategoryController, except: [:new, :edit]
    resources "/bases", BaseController, except: [:new, :edit]
    resources "/staff", StaffController, except: [:new, :edit]
    resources "/sessions", SessionController, except: [:new, :edit, :index]
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

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", KaiboshWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
