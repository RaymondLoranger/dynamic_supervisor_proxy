defmodule DynamicSupervisor.Proxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :dynamic_supervisor_proxy,
      version: "0.1.8",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      name: "DynamicSupervisor Proxy",
      source_url: source_url(),
      description: description(),
      package: package(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  defp source_url do
    "https://github.com/RaymondLoranger/dynamic_supervisor_proxy"
  end

  defp description do
    """
    Starts a module-based supervisor process. Will wait a bit if the supervisor name is still registered on restarts.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "config/persist*.exs"],
      maintainers: ["Raymond Loranger"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_tasks,
       github: "RaymondLoranger/mix_tasks", only: :dev, runtime: false},
      {:file_only_logger, "~> 0.1"},
      {:persist_config, "~> 0.1"},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false}
    ]
  end
end
