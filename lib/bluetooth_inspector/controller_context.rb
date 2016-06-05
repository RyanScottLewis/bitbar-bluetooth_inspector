module BluetoothInspector

  # The DSL context for the configuration block given to the Controller.
  class ControllerContext

    def initialize(controller)
      @controller = controller
    end

    # Get all devices.
    #
    # @return [<Device>]
    def devices
      @controller.devices
    end

    # Find a device by it's name or shortname.
    #
    # @param [#to_s] value
    # @return [<Device>]
    def device(value, &block)
      value = value.to_s
      device = devices.find { |d| d.name == value || d.shortname == value }

      run_device_block_if_needed(device, &block)

      device
    end

    def bar_format(value)
      @controller.formatter.bar_format = value
    end

    def item_format(value)
      @controller.formatter.item_format = value
    end

    protected

    def run_device_block_if_needed(device, &block)
      return nil unless !device.nil? && block_given?

      block.arity > 0 ? yield(device) : run_in_device_context(device, &block)
    end

    def run_in_device_context(device, &block)
      DeviceContext.new(device).instance_eval(&block)
    end

  end

end
