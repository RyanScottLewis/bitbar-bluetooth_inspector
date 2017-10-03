require 'open3'

module BluetoothInspector

  # The plugin controller.
  class Controller

    class << self

      # Collect bluetooth devices, format for bitbar output, and print to output.
      #
      # @return [String]
      def run(&block)
        new.run(&block)
      end

    end

    def initialize
      collect_devices
      setup_formatter
    end

    # Get all devices.
    #
    # @return [<Device>]
    attr_reader :devices

    # Get the formatter.
    #
    # @return [Formatter]
    attr_reader :formatter

    # Collect bluetooth devices, format for bitbar output, and print to output.
    #
    # @return [String]
    def run(&block)
      run_config_block_if_needed(&block)

      output = @formatter.format(@devices)

      print output
    end

    protected

    def collect_devices
      stdout_str, stderr_str, status = Open3.capture3("system_profiler SPBluetoothDataType")

      @devices = Parser.parse(stdout_str)
    end

    def setup_formatter
      @formatter = Formatter.new
    end

    def run_config_block_if_needed(&block)
      return nil unless block_given?

      block.arity > 0 ? yield(self) : run_in_controller_context(&block)
    end

    def run_in_controller_context(&block)
      ControllerContext.new(self).instance_eval(&block)
    end

  end

end
