import Config

site = "https://github.com/erlang/otp/pull/1287"
config :dynamic_supervisor_proxy, supervisor_restart_backoff: site
config :dynamic_supervisor_proxy, timeout: 10
config :dynamic_supervisor_proxy, times: 20
