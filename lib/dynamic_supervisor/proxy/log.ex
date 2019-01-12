defmodule DynamicSupervisor.Proxy.Log do
  use File.Only.Logger

  warn :remains_registered, {name, timeout, times, reason} do
    """
    \nSupervisor remains registered...
    • Supervisor: #{inspect(name, pretty: true)}
    • Waited: #{timeout} ms
    • Times: #{times}
    • Reason:
      #{inspect(reason, pretty: true)}
    • App: #{:application.get_application() |> elem(1)}
    • Library: #{Application.get_application(__MODULE__)}
    • Module: #{inspect(__MODULE__)}
    """
  end

  info :still_registered, {name, timeout, times_left, reason} do
    """
    \nSupervisor still registered...
    • Supervisor: #{inspect(name, pretty: true)}
    • Waiting: #{timeout} ms
    • Times left: #{times_left}
    • Reason:
      #{inspect(reason, pretty: true)}
    • App: #{:application.get_application() |> elem(1)}
    • Library: #{Application.get_application(__MODULE__)}
    • Module: #{inspect(__MODULE__)}
    """
  end

  info :now_unregistered, {name, timeout, times, reason} do
    """
    \nSupervisor now unregistered...
    • Supervisor: #{inspect(name, pretty: true)}
    • Waited: #{timeout} ms
    • Times: #{times}
    • Reason:
      #{inspect(reason, pretty: true)}
    • App: #{:application.get_application() |> elem(1)}
    • Library: #{Application.get_application(__MODULE__)}
    • Module: #{inspect(__MODULE__)}
    """
  end
end
