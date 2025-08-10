# frozen_string_literal: true

module Zwerg
  class ActionExecutor
    def initialize(file_path, event)
      @file_path = file_path
      @event = event
      @file_dir = File.dirname(file_path)
      @file_name = File.basename(file_path)
      @file_ext = File.extname(file_path)
      @file_base = File.basename(file_path, @file_ext)
    end

    def execute(action)
      execute_command(action)
    rescue => e
      puts "Error executing action #{action}: #{e.message}"
    end

    private

    def execute_command(action)
      command = substitute_variables(action["command"])
      puts "Executing: #{command}"

      success = system(command)
      unless success
        puts "Command failed with exit code: #{$?.exitstatus}"
      end
    end

    def substitute_variables(template)
      return template unless template.is_a?(String)

      template
        .gsub("{{file_path}}", @file_path)
        .gsub("{{file_dir}}", @file_dir)
        .gsub("{{file_name}}", @file_name)
        .gsub("{{file_base}}", @file_base)
        .gsub("{{file_ext}}", @file_ext)
    end
  end
end
