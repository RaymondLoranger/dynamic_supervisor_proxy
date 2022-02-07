import Config

import_config "config_logger.exs"

# In case maybe_break is ever used...
config :file_only_logger, line_length: 80
