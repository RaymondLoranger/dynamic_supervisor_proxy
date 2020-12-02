defmodule DynamicSupervisor.Proxy do
  defmacro __using__(options) do
    alias = options[:alias]

    if alias do
      quote do
        use DynamicSupervisor
        alias unquote(__MODULE__), as: unquote(alias)
        require unquote(alias)
      end
    else
      quote do
        use DynamicSupervisor
        import unquote(__MODULE__)
      end
    end
  end

  @doc """
  Starts a module-based supervisor process with the given `module` and `init_arg`. Will wait a bit if the supervisor name is still registered on restarts. See: [Supervisor restart backoff](https://github.com/erlang/otp/pull/1287).

  To start the supervisor, the `init/1` callback will be invoked in the given
  `module`, with `init_arg` as its argument. The `init/1` callback must return
  a supervisor specification which can be created with the help of the `init/1`
  function.

  The `:name` option must be given in order to register a supervisor name.

  ## Examples

      use DynamicSupervisor.Proxy

      def start_link(:ok), do: start_link(DynSup, :ok, name: DynSup)
  """
  defmacro start_link(module, init_arg, opts) do
    quote bind_quoted: [mod: module, arg: init_arg, opts: opts] do
      DynamicSupervisor.Proxy.Broker.start_link(mod, arg, opts)
    end
  end
end
