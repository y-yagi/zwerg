# frozen_string_literal: true

require_relative "zwerg/version"
require_relative "zwerg/watcher"
require_relative "zwerg/config"
require_relative "zwerg/action_executor"

module Zwerg
  class Error < StandardError; end

  class << self
    def start(config_file = "zwerg.yml")
      config = Config.load(config_file)
      watcher = Watcher.new(config)
      watcher.start
    rescue => e
      raise Error, "Failed to start Zwerg: #{e.message}"
    end
  end
end
