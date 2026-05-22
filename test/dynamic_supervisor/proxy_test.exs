defmodule DynamicSupervisor.ProxyTest.DynSup do
  use DynamicSupervisor.Proxy

  alias __MODULE__

  @spec start_link(:ok) :: Supervisor.on_start()
  def start_link(:ok), do: start_link(DynSup, name: DynSup)

  ## Callbacks

  # Injected by the above `use` macro...
  # @impl DynamicSupervisor
  # @spec init(term) :: {:ok, DynamicSupervisor.sup_flags()} | :ignore
  # def init(_arg), do: DynamicSupervisor.init(strategy: :one_for_one)
end

defmodule DynamicSupervisor.ProxyTest do
  use ExUnit.Case, async: true

  require Logger

  alias __MODULE__.DynSup
  alias DynamicSupervisor.Proxy

  doctest Proxy

  describe "Proxy.start_link/2,3" do
    test "returns {:ok, pid} or {:error, reason}" do
      Logger.warning("Starting dynamic supervisor...")
      {:ok, pid} = DynSup.start_link(:ok)

      Logger.error("Dynamic supervisor already started...")
      {:error, {:already_started, ^pid}} = DynSup.start_link(:ok)

      spawn(fn ->
        :timer.sleep(50)
        DynamicSupervisor.stop(DynSup)
      end)

      Logger.notice("Dynamic supervisor restarted...")
      {:ok, restart_pid} = DynSup.start_link(:ok)

      refute pid == restart_pid

      :timer.sleep(200)

      assert File.read!("./log/info.log") =~ """
             Supervisor now unregistered...
             • Supervisor: DynamicSupervisor.ProxyTest.DynSup
             • PID: #{inspect(pid)}
             """
    end
  end
end
