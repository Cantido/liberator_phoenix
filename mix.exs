# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT

defmodule Liberator.Phoenix.MixProject do
  use Mix.Project

  def project do
    [
      app: :liberator_phoenix,
      description: "Phoenix integration for Liberator",
      package: package(),
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Rosa Richter"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Cantido/liberator_phoenix",
        "sourcehut" => "https://git.sr.ht/~cosmicrose/liberator_phoenix"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:liberator, "~> 2.0.0"},
      {:mime, "~> 2.0.0"},
      {:nimble_options, "~> 0.3.0"},
      {:phoenix_view, "~> 1.0"},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false}
    ]
  end
end
