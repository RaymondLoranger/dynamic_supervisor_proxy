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
        DynamicSupervisor.start_link(mod, arg, opts)
    end
  end

  ## Private functions

  # On restarts, wait if name still registered...
  @spec wait(atom, term, non_neg_integer) :: :ok
  defp wait(name, reason, 0) do
    Log.warn(:remains_registered, {name, @timeout, @times, reason})
  end

  defp wait(name, reason, times_left) do
    Log.info(:still_registered, {name, @timeout, times_left, reason})
    Process.sleep(@timeout)

    case Process.whereis(name) do
      nil ->
        times = @times - times_left + 1
        Log.info(:now_unregistered, {name, @timeout, times, reason})

      pid when is_pid(pid) ->
        wait(name, reason, times_left - 1)
    end
  end
end
