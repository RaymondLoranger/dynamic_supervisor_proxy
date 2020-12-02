defmodule DynamicSupervisor.Proxy.Broker do
  use PersistConfig

  alias DynamicSupervisor.Proxy.Log

  @timeout get_env(:timeout)
  @times get_env(:times)

  @spec start_link(module, term, GenServer.options()) :: Supervisor.on_start()
  def start_link(mod, arg, opts) do
    case DynamicSupervisor.start_link(mod, arg, opts) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, _pid} = reason} ->
        :ok = wait(opts[:name], reason, @times)
        {:ok, _pid} = DynamicSupervisor.start_link(mod, arg, opts)
    end
  end

  ## Private functions

  # On restarts, wait if name still registered...
  @spec wait(atom, term, non_neg_integer) :: :ok
  defp wait(name, reason, 0) do
    remains_registered_vars = {name, @timeout, @times, reason, __ENV__}
    :ok = Log.warn(:remains_registered, remains_registered_vars)
  end

  defp wait(name, reason, times_left) do
    still_registered_vars = {name, @timeout, times_left, reason, __ENV__}
    :ok = Log.info(:still_registered, still_registered_vars)
    Process.sleep(@timeout)

    case Process.whereis(name) do
      nil ->
        times = @times - times_left + 1
        now_unregistered_vars = {name, @timeout, times, reason, __ENV__}
        :ok = Log.info(:now_unregistered, now_unregistered_vars)

      pid when is_pid(pid) ->
        wait(name, reason, times_left - 1)
    end
  end
end
