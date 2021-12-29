defmodule DynamicSupervisor.Proxy.Log do
  use File.Only.Logger

  warn :already_registered, {name, timeout, times, reason, env} do
    """
    \n'DynamicSupervisor.start_link/3' failed: supervisor already registered...
    • Supervisor: #{inspect(name)}
    • Waiting: #{timeout} ms
    • Times left: #{times}
    • Reason: #{inspect(reason)}
    #{from(env, __MODULE__)}
    """
  end

  warn :remains_registered, {name, timeout, times, reason, env} do
    """
    \nSupervisor remains registered...
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times: #{times}
    • Reason: #{inspect(reason)}
    #{from(env, __MODULE__)}
    """
  end

  warn :still_registered, {name, timeout, times_left, reason, env} do
    """
    \nSupervisor still registered...
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times left: #{times_left}
    • Reason: #{inspect(reason)}
    #{from(env, __MODULE__)}
    """
  end

  warn :now_unregistered, {name, timeout, times, env} do
    """
    \nSupervisor now unregistered...
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times: #{times}
    #{from(env, __MODULE__)}
    """
  end
end
