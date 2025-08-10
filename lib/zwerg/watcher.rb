# frozen_string_literal: true

require "watchcat"

module Zwerg
  class Watcher
    def initialize(config)
      @config = config
      @watchers = []
    end

    def start
      puts "Starting Zwerg file watcher..."

      @config.watches.each do |watch_config|
        start_watching_path(watch_config)
      end

      puts "Zwerg is now watching for file changes. Press Ctrl+C to stop."

      # Keep the main thread alive
      begin
        sleep
      rescue Interrupt
        puts "\nStopping Zwerg..."
        stop
      end
    end

    def stop
      @watchers.each(&:stop)
      @watchers.clear
    end

    private

    def start_watching_path(watch_config)
      path = watch_config[:path]

      unless File.exist?(path)
        puts "Warning: Path does not exist: #{path}"
        return
      end

      puts "Watching: #{path} (recursive: #{watch_config[:recursive]})"

      watcher = Watchcat.watch(
        path,
        recursive: watch_config[:recursive],
        wait_until_startup: true,
        debounce: 1000
      ) do |event|
        handle_file_event(event, watch_config)
      end

      @watchers << watcher
    end

    def handle_file_event(event, watch_config)
      event.paths.each do |file_path|
        next unless should_process_file?(file_path, watch_config[:patterns])

        puts "File changed: #{file_path}"
        execute_actions(file_path, event, watch_config[:actions])
      end
    end

    def should_process_file?(file_path, patterns)
      return true if patterns.empty?

      patterns.any? do |pattern|
        File.fnmatch?(pattern, File.basename(file_path)) ||
          File.fnmatch?(pattern, file_path)
      end
    end

    def execute_actions(file_path, event, actions)
      executor = ActionExecutor.new(file_path, event)

      actions.each do |action|
        executor.execute(action)
      end
    end
  end
end
