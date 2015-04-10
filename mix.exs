defmodule InterlineAPI.Mixfile do
  use Mix.Project

  def project do
    [app: :interlineAPI,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {InterlineAPI, []},
     applications: [:phoenix, :cowboy, :logger, :plug, :httpotion]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.10.0"},
     {:phoenix_ecto, "~> 0.1"},
     {:postgrex, ">= 0.0.0"},
     {:cowboy, "~> 1.0"},
		 {:plug, "~> 0.11.0"},
		 {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"},
		 {:exjsx, github: "talentdeficit/exjsx", tag: "v3.1.0"},
		 {:httpotion, "~> 2.0.0"}]
  end
end
