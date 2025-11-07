# config/config.exs
import Config

config :nostrum,
  gateway_intents: :all,
  ffmpeg: false

import_config "dev.secret.exs"
