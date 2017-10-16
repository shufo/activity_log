defmodule ActivityLog.Mixfile do
  use Mix.Project

  def project do
    [
      app: :activity_log,
      version: "0.1.0",
      elixir: "~> 1.5",
      package: package(),
      description: description(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:poison, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 2.0 or ~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:inch_ex, ">= 0.0.0", only: [:dev, :test]},
      {:cortex, "~> 0.1", only: [:dev, :test]},
    ]
  end

  defp description do
    """
    Logging activities with [Activitiy Streams](https://www.w3.org/TR/activitystreams-core/) like format.
    """
  end

  defp package do
    [
      files: ["config", "lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Shuhei Hayashibara"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/shufo/activity_log",
        "Docs" => "https://hexdocs.pm/activity_log"
      }
    ]
  end
end
