# frozen_string_literal: true

require "psych"

module Zwerg
  class Config
    attr_reader :watches

    def initialize(data)
      @watches = parse_watches(data["watches"] || [])
    end

    def self.load(file_path)
      unless File.exist?(file_path)
        raise Error, "Configuration file not found: #{file_path}"
      end

      begin
        data = Psych.load_file(file_path)
        new(data)
      rescue Psych::SyntaxError => e
        raise Error, "Invalid YAML syntax in #{file_path}: #{e.message}"
      end
    end

    private

    def parse_watches(watches_data)
      watches_data.map do |watch_config|
        {
          path: watch_config["path"],
          recursive: watch_config.fetch("recursive", true),
          patterns: watch_config["patterns"] || [],
          actions: watch_config["actions"] || []
        }
      end
    end
  end
end
