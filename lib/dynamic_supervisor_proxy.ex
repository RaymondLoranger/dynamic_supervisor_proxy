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
  Starts a module-based supervisor process with the given `module` and `arg`.
  The `:name` option must be given in order to register a supervisor name.
  Will wait a bit if the supervisor name is still registered on restarts.
  See: [Supervisor restart backoff](https://github.com/erlang/otp/pull/1287)

  ## Examples

      use DynamicSupervisor.Proxy

      def start_link(:ok), do: start_link(DynSup, :ok, name: DynSup)
  """
  defmacro start_link(mod, arg, opts) do
    quote bind_quoted: [mod: mod, arg: arg, opts: opts] do
      IO.inspect(">>>>>>>>>> Inserting Agent.start_link >>>>>>>>>>>")
      DynamicSupervisor.Proxy.Agent.start_link(mod, arg, opts)
    end
  end
end
