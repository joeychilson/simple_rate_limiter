defmodule RateLimiterTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = RateLimiter.start_link(max: 2, interval: 1_000)
    {:ok, pid: pid}
  end

  test "allows to proceed under the limit", context do
    assert :ok == RateLimiter.can_proceed?(context[:pid])
    assert :ok == RateLimiter.can_proceed?(context[:pid])
  end

  test "doesn't allow to proceed over the limit", context do
    assert :ok == RateLimiter.can_proceed?(context[:pid])
    assert :ok == RateLimiter.can_proceed?(context[:pid])
    assert {:error, :rate_limit_exceeded, remaining_time: _} = RateLimiter.can_proceed?(context[:pid])
  end

  test "allows to proceed after enough time has passed", context do
    assert :ok == RateLimiter.can_proceed?(context[:pid])
    assert :ok == RateLimiter.can_proceed?(context[:pid])
    assert {:error, :rate_limit_exceeded, remaining_time: _} = RateLimiter.can_proceed?(context[:pid])

    # Wait for a second to replenish a token
    :timer.sleep(1_000)

    assert :ok == RateLimiter.can_proceed?(context[:pid])
  end
end
