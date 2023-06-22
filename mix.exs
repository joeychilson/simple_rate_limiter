defmodule SimpleRateLimiter.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description "SimpleRateLimiter is a simple rate limiter for Elixir that allows you to limit the number of actions per period of time."

  def project do
    [
      app: :simple_rate_limiter,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: @description,
      deps: deps(),
      package: package(),
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :docs}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joeychilson/simple_rate_limiter"},
      maintainers: ["Joey Chilson"]
    ]
  end
end
