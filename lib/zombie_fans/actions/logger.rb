require 'colorize'

module ZombieFans::Actions
  module Logger
    def log_action action, message
      puts "#{action.colorize(:green)} #{message}"
    end

    def log_error message
      puts "#{"Error occurred:".colorize(:red)} #{message}"
    end

    def debug_page page
      File.write("debug.html", page.body)
    end
  end
end
