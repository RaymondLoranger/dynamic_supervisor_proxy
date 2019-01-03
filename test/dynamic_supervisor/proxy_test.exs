defmodule DynamicSupervisor.ProxyTest do
  use ExUnit.Case, async: true

  alias DynamicSupervisor.Proxy

  doctest Proxy

  test "the truth" do
    assert 1 + 2 == 3
  end
end
