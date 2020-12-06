defmodule DynamicSupervisor.Proxy.Log do
  use File.Only.Logger

  error :already_registered, {name, timeout, times, reason, env} do
    """
    \nSupervisor already registered...
    • Inside function:
      #{fun(env)}
    • Supervisor: #{inspect(name)}
    • Waiting: #{timeout} ms
    • Times left: #{times}
    • Reason:
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
    • Issue remaining 'unresolved':
      #{inspect(reason)}
    #{from()}
    """
  end

  info :still_registered, {name, timeout, times_left, reason, env} do
    """
    \nSupervisor still registered...
    • Inside function:
      #{fun(env)}
    • Supervisor: #{inspect(name)}
    • Waited: #{timeout} ms
    • Times left: #{times_left}
    • Issue still 'unresolved':
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
    • Issue now 'resolved':
      #{inspect(reason)}
    #{from()}
    """
  end
end
