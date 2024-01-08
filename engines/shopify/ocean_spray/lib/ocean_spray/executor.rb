module Slide
  class Executor
    def initialize(script_path)
      @script_path = script_path
    end
    def make_executable
      if system("chmod +x #{@script_path}")
        puts "File permissions changed: script is now executable."
        true
      else
        puts "Failed to change file permissions."
        false
      end
    end
    def execute_script
      begin
        Dir.chdir(File.dirname(@script_path)) do
          system("./#{File.basename(@script_path)}")
        end
        puts "Script executed successfully."
      rescue StandardError => e
        puts "Error executing script: #{e.message}"
      end
    end
  end
end
 script_path = '/path/to/your/script.sh'
 executor = MoveFinalToUser::Executor.new(script_path)
#
 if executor.make_executable
   executor.execute_script
 end
