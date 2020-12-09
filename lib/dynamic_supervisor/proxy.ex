defmodule DynamicSupervisor.Proxy do
  @moduledoc """
  Starts a module-based dynamic supervisor process with a registered name.
  Will wait a bit if the supervisor name is still registered on restarts.
  See [Supervisor restart backoff](https://github.com/erlang/otp/pull/1287).
  """

  @doc """
  Uses `DynamicSupervisor`. Also either aliases `DynamicSupervisor.Proxy`
  (this module) and requires the alias or imports `DynamicSupervisor.Proxy`.

  ## Examples

      use DynamicSupervisor.Proxy, alias: Proxy

      use DynamicSupervisor.Proxy
  """
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
  Starts a module-based dynamic supervisor process with the given`module`
  and `init_arg`. The `:name` option __must__ be given in order to register a
  supervisor name. Will wait a bit if the supervisor name is still
  registered on restarts. See: [Supervisor restart backoff](https://github.com/erlang/otp/pull/1287).

  To start the supervisor, the `c:DynamicSupervisor.init/1` callback will be
  invoked in the given `module`, with `init_arg` as its argument. The
  `c:DynamicSupervisor.init/1` callback must return a supervisor specification
  which can be created with the help of the `DynamicSupervisor.init/1` function.

  ## Examples

      use DynamicSupervisor.Proxy

      @spec start_link(term) :: Supervisor.on_start()
      def start_link(:ok), do: start_link(__MODULE__, :ok, name: __MODULE__)

      @spec init(term) :: {:ok, DynamicSupervisor.sup_flags()} | :ignore
      def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)
  """
  defmacro start_link(module, init_arg, opts) do
    quote bind_quoted: [mod: module, arg: init_arg, opts: opts] do
      DynamicSupervisor.Proxy.Starter.start_link(mod, arg, opts)
    end
  end
end
