defmodule SimpleRateLimiterTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = SimpleRateLimiter.start_link(max: 2, interval: 1_000)
    {:ok, pid: pid}
  end

  test "allows to proceed under the limit", context do
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
  end

  test "doesn't allow to proceed over the limit", context do
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert {:error, :rate_limit_exceeded, remaining_time: _} = SimpleRateLimiter.can_proceed?(context[:pid])
  end

  test "allows to proceed after enough time has passed", context do
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert {:error, :rate_limit_exceeded, remaining_time: _} = SimpleRateLimiter.can_proceed?(context[:pid])

    :timer.sleep(2_000)

    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert :ok == SimpleRateLimiter.can_proceed?(context[:pid])
    assert {:error, :rate_limit_exceeded, remaining_time: _} = SimpleRateLimiter.can_proceed?(context[:pid])
  end
end
