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
      case action["type"]
      when "command"
        execute_command(action)
      else
        puts "Unsupported action type: #{action['type']}. Only 'command' type is supported."
      end
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
        .gsub("{{event_type}}", determine_event_type)
    end

    def determine_event_type
      return "create" if @event.kind.create?
      return "modify" if @event.kind.modify?
      return "remove" if @event.kind.remove?
      return "access" if @event.kind.access?
      "unknown"
    end
  end
end
