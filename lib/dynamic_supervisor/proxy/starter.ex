defmodule DynamicSupervisor.Proxy.Starter do
  use PersistConfig

  alias DynamicSupervisor.Proxy.Log

  @supervisor_restart_backoff get_env(:supervisor_restart_backoff)
  @timeout get_env(:timeout)
  @times get_env(:times)

  @doc """
  Starts a module-based dynamic supervisor process with the given `module` and
  `init_arg`. The `:name` option _must_ be specified in order to register a
  supervisor name. Will wait a bit if the supervisor name is still registered
  on restarts. See [Supervisor restart backoff](#{@supervisor_restart_backoff}).
  """
  @spec start_link(module, term, GenServer.options()) :: Supervisor.on_start()
  def start_link(module, init_arg, opts) do
    case DynamicSupervisor.start_link(module, init_arg, opts) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid} = reason} ->
        name = opts[:name]
        still_registered = {name, @timeout, @times, reason, __ENV__}
        :ok = Log.warning(:still_registered, still_registered)
        :ok = wait(name, pid, @times)
        DynamicSupervisor.start_link(module, init_arg, opts)

      other ->
        other
    end
  end

  ## Private functions

  # On restarts, wait if `name` still registered...
  @spec wait(GenServer.name(), pid, non_neg_integer) :: :ok
  defp wait(_name, _pid, 0) do
    :ok
  end

  defp wait(name, pid, times_left) do
    Process.sleep(@timeout)
    times_left = times_left - 1

    case Process.whereis(name) do
      nil ->
        times = @times - times_left
        now_unregistered = {name, pid, @timeout, times, __ENV__}
        :ok = Log.notice(:now_unregistered, now_unregistered)

      ^pid ->
        log(name, pid, times_left)
        wait(name, pid, times_left)
    end
  end

  @spec log(GenServer.name(), pid, non_neg_integer) :: :ok
  defp log(name, pid, 0) do
    remains_registered = {name, pid, @timeout, @times, __ENV__}
    :ok = Log.error(:remains_registered, remains_registered)
  end

  defp log(name, pid, times_left) do
    still_registered = {{name, pid}, @timeout, times_left, __ENV__}
    :ok = Log.warning(:still_registered, still_registered)
  end
end
