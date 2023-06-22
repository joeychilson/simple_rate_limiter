# SimpleRateLimiter

`SimpleRateLimiter` is a simple rate limiter library for Elixir. It allows you to limit the number of actions (e.g., API requests, database calls, etc.) that can be performed within a specific time interval. It is particularly useful when dealing with APIs that have rate limit restrictions, and you want to ensure your application stays within those limits.

## Installation

`SimpleRateLimiter` is available on Hex. Add it to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:simple_rate_limiter, "~> 0.1.0"}
  ]
end
```

## Usage

Add `SimpleRateLimiter` to your supervision tree, and specify the `interval` and `max` options. The `interval` option specifies the time interval in milliseconds, and the `max` option specifies the maximum number of actions that can be performed within that time interval. For example, if you want to limit the number of API requests to 10 per second, you would specify `interval: 1_000` and `max: 10`.

```elixir
defmodule MyApp do
  use Application

  def start(_type, _args) do
    children = [
      {SimpleRateLimiter, interval: 1_000, max: 10}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Then, in your application code, you can call `SimpleRateLimiter.can_proceed?/0` to check if an action can be performed. If the action can be performed, `:ok` is returned. If the action cannot be performed, `{:error, :rate_limit_exceeded, remaining_time: remaining_time}` is returned, where `remaining_time` is the number of milliseconds until the next action can be performed.

```elixir
defmodule MyApp.Task do

  def perform() do
    case SimpleRateLimiter.can_proceed?() do
      :ok ->
        do_task()
      {:error, :rate_limit_exceeded, remaining_time: remaining_time} ->
        :timer.sleep(remaining_time)
        perform()
    end
  end
end
```

Here we sleep for the `remaining_time` before trying again. This is just a simple way to ensure that the rate limit is not exceeded. There are other ways to handle this, such as using a GenServer to queue up the tasks, and then process them when the rate limit allows.


