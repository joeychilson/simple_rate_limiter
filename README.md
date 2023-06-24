# SimpleRateLimiter

`SimpleRateLimiter` is a simple rate limiter library for Elixir. It allows you to limit the number of actions (e.g., API requests, database calls, etc.) that can be performed within a specific time interval. It is particularly useful when dealing with APIs that have rate limit restrictions, and you want to ensure your application stays within those limits.

## Installation

`SimpleRateLimiter` is available on Hex. Add it to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_rate_limiter, "~> 0.2.1"}
  ]
end
```

## Usage

Add `SimpleRateLimiter` to your supervision tree, and specify the `interval` and `max` options. The `interval` option specifies the time interval in milliseconds, and the `max` option specifies the maximum number of actions that can be performed within that time interval. For example, if you want to limit the number of API requests to 10 per second, you would specify `interval: 1_000` and `max: 10`.

```elixir
defmodule APIClient do
  use Application

  def start(_type, _args) do
    children = [
      {SimpleRateLimiter, interval: 1_000, max: 10}
    ]

    opts = [strategy: :one_for_one, name: APIClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Then, in your application code, you can call `SimpleRateLimiter.wait_and_proceed/1` with a function that performs the action you want to limit. For example, if you want to limit the number of API requests to 10 per second, you would do something like this:

```elixir
defmodule APIClient.Client do
  def get(url, headers) do
    SimpleRateLimiter.wait_and_proceed(fn -> HTTPoison.get(url, headers) end)
  end
end
```


