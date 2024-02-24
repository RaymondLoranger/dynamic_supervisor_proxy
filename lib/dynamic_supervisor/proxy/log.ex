defmodule DynamicSupervisor.Proxy.Log do
  use File.Only.Logger

  warning :still_registered, {name, timeout, times, reason, env} do
    """
    \n'DynamicSupervisor.start_link/3' failed: supervisor still registered...
    • Supervisor: #{inspect(name)}
    • Reason: #{inspect(reason)}
    • Waiting: #{timeout} ms
    • Times left: #{times}
    #{from(env, __MODULE__)}\
    """
  end

  warning :still_registered, {name, timeout, times_left, env} do
    """
    \nSupervisor still registered...
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times left: #{times_left}
    #{from(env, __MODULE__)}\
    """
  end

  warning :now_unregistered, {name, timeout, times, env} do
    """
    \nSupervisor now unregistered...
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times: #{times}
    #{from(env, __MODULE__)}\
    """
  end

  warning :remains_registered, {name, timeout, times, env} do
    """
    \nSupervisor remains registered...
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times: #{times}
    #{from(env, __MODULE__)}\
    """
  end
end
