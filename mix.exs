defmodule Kaibosh.MixProject do
  use Mix.Project

  def project do
    [
      app: :kaibosh,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: dialyzer(),
      releases: [
        kaibosh: [
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      plt_add_apps: [:ex_unit]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kaibosh.Application, []},
      extra_applications: env_extra_apps() ++ [:ssl, :logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Default Phoenix dependencies
      {:phoenix, "~> 1.6"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:ecto_sql, "~> 3.12"},
      {:postgrex, "~> 0.19"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.3"},
      {:plug_crypto, "~> 2.1"},

      # Prod
      {:argon2_elixir, "~> 4.0"},
      {:timex, "~> 3.6"},
      {:bamboo, "~> 2.2"},
      {:bamboo_phoenix, "~> 1.0"},
      {:sentry, "~> 10.0"},
      {:csv, "~> 3.0"},

      # Test
      {:ex_machina, "~> 2.4", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.10", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: [:dev, :test], runtime: false},

      # Dev
      {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false},
      {:phoenix_live_reload, "~> 1.2", only: :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp env_extra_apps do
    case Mix.env() do
      :prod -> [:os_mon]
      _ -> []
    end
  end
end
