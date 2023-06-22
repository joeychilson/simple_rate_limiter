# RateLimiter

`RateLimiter` is a simple library for Elixir, that provides rate limiting functionality. It allows you to limit the number of actions (e.g., API requests, database calls, etc.) that can be performed within a specific time interval. It is particularly useful when dealing with APIs that have rate limit restrictions, and you want to ensure your application stays within those limits.

## Installation

`RateLimiter` is available on Hex. Add it to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rate_limiter, "~> 0.1.0"}
  ]
end
```
