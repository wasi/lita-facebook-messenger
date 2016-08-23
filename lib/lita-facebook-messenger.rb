require "lita"
require 'facebook/messenger'

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/adapters/facebook-messenger"
require "lita/handlers/facebook-messenger"
