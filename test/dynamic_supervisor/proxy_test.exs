defmodule DynamicSupervisor.ProxyTest.DynSup do
  use DynamicSupervisor.Proxy

  alias __MODULE__

  @spec start_link :: Supervisor.on_start()
  def start_link, do: start_link(DynSup, :ok, name: DynSup)

  ## Callbacks

  @spec init(term) :: {:ok, DynamicSupervisor.sup_flags()} | :ignore
  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)
end

defmodule DynamicSupervisor.ProxyTest do
  use ExUnit.Case, async: true

  alias __MODULE__.DynSup
  alias DynamicSupervisor.Proxy

  doctest Proxy

  describe "Proxy.start_link/3" do
    test "returns {:ok, pid} or {:error, reason}" do
      assert {:ok, pid} = DynSup.start_link()
      assert {:error, {:already_started, ^pid}} = DynSup.start_link()
    end
  end
end
