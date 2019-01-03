defmodule DynamicSupervisor.Proxy.Log do
  use File.Only.Logger

  warn :remains_registered, {name, timeout, times, reason} do
    """
    \nSupervisor #{inspect(name)} remains registered after:
    • Waiting: #{timeout} ms
    • Times: #{times}
    • Reason:
    #{inspect(reason)}
    """
  end

  info :still_registered, {name, timeout, times_left, reason} do
    """
    \nSupervisor #{inspect(name)} still registered:
    • Waiting: #{timeout} ms
    • Times left: #{times_left}
    • Reason:
    #{inspect(reason)}
    """
  end

  info :now_unregistered, {name, timeout, times, reason} do
    """
    \nSupervisor #{inspect(name)} now unregistered after:
    • Waiting: #{timeout} ms
    • Times: #{times}
    • Reason:
    #{inspect(reason)}
    """
  end
end
