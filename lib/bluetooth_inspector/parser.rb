require "yaml"

module BluetoothInspector

  # Parses the output of the `system_profiler` command and returns an Array of Device instances.
  class Parser

    class << self

      # Parse the command output.
      #
      # @param [#to_s] data The command output.
      # @return [<Device>]
      def parse(data)
        new.parse(data)
      end

    end

    # Parse the command output.
    #
    # @param [#to_s] data The command output.
    # @return [<Device>]
    def parse(data)
      data = YAML.load(data.to_s)

      data["Bluetooth"]["Devices (Paired, Configured, etc.)"].collect do |name, attributes|
        Device.new(
          name: name,
          battery: attributes["Battery Level"]
        )
      end
    end

  end

end
