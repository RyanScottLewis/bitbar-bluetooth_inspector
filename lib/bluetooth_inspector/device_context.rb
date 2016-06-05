module BluetoothInspector

  # The DSL context for a device.
  class DeviceContext

    def initialize(device)
      @device = device
    end

    # Get the device.
    #
    # @param [String]
    # @return [String]
    attr_reader :device

    # Get/set the name of the device.
    #
    # @param [String]
    # @return [String]
    def name(*arguments)
      get_or_set_attribute(__method__, arguments)
    end

    # Get/set the shortname of the device.
    #
    # @return [nil, String]
    def shortname(*arguments)
      get_or_set_attribute(__method__, arguments)
    end

    # Get/set the battery level of the device.
    #
    # @return [nil, Integer]
    def battery(*arguments)
      get_or_set_attribute(__method__, arguments)
    end

    # Get/set the color of the device.
    #
    # @return [nil, String]
    def color(*arguments)
      get_or_set_attribute(__method__, arguments)
    end

    # Get/set whether the device is shown within the bar.
    #
    # @return [Boolean]
    def bar_item(*arguments)
      get_or_set_attribute(__method__, arguments)
    end

    # Get/set whether the device is shown within the menu.
    #
    # @return [Boolean]
    def menu_item(*arguments)
      get_or_set_attribute(__method__, arguments)
    end

    protected

    def validate_arguments(arguments)
      raise ArgumentError, "wrong number of arguments (given #{arguments.count}, expected 0..1)" if arguments.length > 1
    end

    def get_or_set_attribute(name, arguments)
      validate_arguments(arguments)

      arguments.empty? ? @device.send(name) : @device.send("#{name}=", arguments.first)
    end

  end

end
