# DynamicSupervisor Proxy

Starts a module-based supervisor process.

Will wait a bit if the supervisor name is still registered on restarts.
See: [Supervisor restart backoff](https://github.com/erlang/otp/pull/1287)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dynamic_supervisor_proxy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dynamic_supervisor_proxy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dynamic_supervisor_proxy](https://hexdocs.pm/dynamic_supervisor_proxy).

