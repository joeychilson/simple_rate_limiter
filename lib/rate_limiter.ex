defmodule RateLimiter do
  @moduledoc """
  A GenServer module that implements token bucket rate limiting.

  To start the rate limiter, specify the maximum number of tokens and the
  refill interval in milliseconds. The token bucket is initially filled to
  the maximum.

  To check if an action can proceed, call `RateLimiter.can_proceed?/1`.
  It will return `:ok` if there are tokens available, and decrement the
  token count by 1. If there are no tokens available, it will return an
  error tuple with the amount of time remaining until the next token is
  available.
  """
  use GenServer

  @doc """
  Starts the rate limiter.

    ## Options

    - `:interval`: The refill interval in milliseconds (default `1_000`).
    - `:max`: The maximum number of tokens (default `10`).

    ## Example

        iex> {:ok, pid} = RateLimiter.start_link(interval: 1_000, max: 10)
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc false
  def init(opts) do
    interval = Keyword.get(opts, :interval, 1_000)
    max = Keyword.get(opts, :max, 10)
    {:ok, %{interval: interval, max: max, tokens: max, last_token_time: :os.system_time(:millisecond)}}
  end

  @doc """
    Checks if an action can proceed by trying to consume a token.

    ## Example

        iex> RateLimiter.can_proceed?(pid)
        :ok
  """
  def can_proceed?(server \\ __MODULE__) do
    GenServer.call(server, :can_proceed?)
  end

  @doc false
  def handle_call(:can_proceed?, _from, state) do
    current_time = :os.system_time(:millisecond)
    elapsed_time = current_time - state.last_token_time

    added_tokens = div(elapsed_time, state.interval)
    new_tokens = min(state.tokens + added_tokens, state.max)

    if new_tokens > 0 do
      new_state = %{state | tokens: new_tokens - 1, last_token_time: current_time}
      {:reply, :ok, new_state}
    else
      remaining_time = state.interval - rem(elapsed_time, state.interval)
      {:reply, {:error, :rate_limit_exceeded, remaining_time: remaining_time}, state}
    end
  end
end
