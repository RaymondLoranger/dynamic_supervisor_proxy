defmodule DynamicSupervisor.Proxy.Log do
  use File.Only.Logger

  info :still_registered, {name, timeout, times_left, reason, env} do
    """
    \nSupervisor still registered...
    • Inside function:
      #{fun(env)}
    • Supervisor: #{inspect(name)}
    • Waiting: #{timeout} ms
    • Times left: #{times_left}
    • Issue:
      #{inspect(reason)}
    #{from()}
    """
  end

  warn :remains_registered, {name, timeout, times, reason, env} do
    """
    \nSupervisor remains registered...
    • Inside function:
      #{fun(env)}
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times: #{times}
    • Unresolved issue:
      #{inspect(reason)}
    #{from()}
    """
  end

  info :now_unregistered, {name, timeout, times, reason, env} do
    """
    \nSupervisor now unregistered...
    • Inside function:
      #{fun(env)}
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times: #{times}
    • Resolved issue:
      #{inspect(reason)}
    #{from()}
    """
  end
end
