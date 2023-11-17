defmodule DynamicSupervisor.Proxy.Starter do
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
        name = opts[:name]
        still_registered = {name, @timeout, @times, reason, __ENV__}
        :ok = Log.warning(:still_registered, still_registered)
        :ok = wait(name, @times)
        DynamicSupervisor.start_link(mod, arg, opts)

      other ->
        other
    end
  end

  ## Private functions

  # On restarts, wait if `name` still registered...
  @spec wait(atom, non_neg_integer) :: :ok
  defp wait(name, 0) do
    remains_registered = {name, @timeout, @times, __ENV__}
    :ok = Log.warning(:remains_registered, remains_registered)
  end

  defp wait(name, times_left) do
    Process.sleep(@timeout)
    times_left = times_left - 1

    case Process.whereis(name) do
      nil ->
        times = @times - times_left
        now_unregistered = {name, @timeout, times, __ENV__}
        :ok = Log.warning(:now_unregistered, now_unregistered)

      pid when is_pid(pid) ->
        still_registered = {name, @timeout, times_left, __ENV__}
        :ok = Log.warning(:still_registered, still_registered)
        wait(name, times_left)
    end
  end
end
