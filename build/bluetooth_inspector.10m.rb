#!/usr/bin/env ruby
# <bitbar.title>Bluetooth Inspector</bitbar.title>
# <bitbar.version>0.1.0</bitbar.version>
# <bitbar.author>Ryan Scott Lewis</bitbar.author>
# <bitbar.author.github>RyanScottLewis</bitbar.author.github>
# <bitbar.desc>Show bluetooth information for all connected bluetooth devices using the `system_profiler` binary.</bitbar.desc>

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# -= Note -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #

# See the bottom of this file for configuration documentation.

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# -= Code -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #


module BluetoothInspector

  class << self

    # Run the plugin controller.
    def run(&block)
      Controller.run(&block)
    end

  end

end

module BluetoothInspector

  # A bluetooth device.
  class Device
    def initialize(attributes={})
      @bar_item = true
      @menu_item = true

      update_attributes(attributes)

      raise "name must be given" if @name.nil?
    end

    # Get the name of the device.
    #
    # @return [String]
    attr_reader :name

    # Set the name of the device.
    #
    # @param [#to_s] value
    # @return [String]
    def name=(value)
      @name = value.to_s
    end

    # Get the shortname of the device.
    #
    # @return [nil, String]
    def shortname
      @shortname.nil? ? @name : @shortname
    end

    # Set the shortname of the device.
    #
    # @param [nil, #to_s] value
    # @return [nil, String]
    def shortname=(value)
      @shortname = value.nil? ? nil : value.to_s
    end

    # Get whether this device has a shortname.
    #
    # @return [Boolean]
    def shortname?
      !@shortname.nil?
    end

    # Get the battery level in a range of `0..100`.
    #
    # @return [nil, Float]
    attr_reader :battery

    # Set the battery level in a range of `0..100`.
    #
    # @param [nil, #to_f] value
    # @return [nil Float]
    def battery=(value)
      @battery = value.nil? ? nil : value.to_i
    end

    # Get whether this device has no battery level.
    #
    # @return [Boolean]
    def no_battery?
      @battery.nil?
    end

    # Get whether this device has a battery level.
    #
    # @return [Boolean]
    def battery?
      !no_battery?
    end

    # Get the color of the device.
    #
    # @return [nil, String]
    attr_reader :color

    # Set the name of the device.
    #
    # @param [nil, #to_s] value
    # @return [nil, String]
    def color=(value)
      @color = value.nil? ? nil : value.to_s
    end

    # Get whether this device has a color.
    #
    # @return [Boolean]
    def color?
      !@color.nil?
    end

    # Get whether this device is shown within the bar.
    #
    # @return [Boolean]
    def bar_item?
      @bar_item
    end

    # Set whether this device is shown within the bar.
    #
    # @param [Boolean] value
    # @return [Boolean]
    def bar_item=(value)
      @bar_item = !!value
    end

    # Get whether this device is shown within the menu.
    #
    # @return [Boolean]
    def menu_item?
      @menu_item
    end

    # Set whether this device is shown within the menu.
    #
    # @param [Boolean] value
    # @return [Boolean]
    def menu_item=(value)
      @menu_item = !!value
    end

    # Get device's attributes.
    #
    # @return [Hash]
    def to_h
      {
        name:      @name,
        shortname: @shortname,
        battery:   @battery
      }
    end

    protected

    def update_attributes(attributes)
      attributes.to_h.each do |name, value|
        next unless self.class.method_defined?("#{name}=")

        send("#{name}=", value)
      end
    end

  end

end

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

    # Get/set the color of the device.
    #
    # @return [nil, String]
    def shortname(*arguments)
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

module BluetoothInspector

  # Formats a list of devices for the expected bitbar output.
  class Formatter

    def initialize
      @bar_format = ":shortname :battery%"
      @item_format = ":name"
    end

    # Get the format for a device as a bar item.
    #
    # @return [String]
    attr_reader :bar_format

    # Set the format for a device as a bar item.
    #
    # @param [#to_s] value
    # @return [String]
    def bar_format=(value)
      @bar_format = value.to_s
    end

    # Get the format for a device as a menu item.
    #
    # @return [String]
    attr_reader :item_format

    # Set the format for a device as a menu item.
    #
    # @param [#to_s] value
    # @return [String]
    def item_format=(value)
      @item_format = value.to_s
    end

    def format(devices)
      lines = []

      devices.find_all(&:bar_item?).each { |device| lines << format_device(@bar_format, device) }

      lines << "---"
      devices.find_all(&:menu_item?).each { |device| lines << format_device(@item_format, device) }

      lines.join("\n")
    end

    protected

    def format_device(format_string, device)
      output = format_string
      device.to_h.each { |name, value| output = output.gsub(/:#{name}/, value.to_s) }

      device.color.nil? ? output : output + " | color=#{device.color}"
    end

  end

end

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
      device = devices.find { |device| device.name == value || device.shortname == value }

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
      command_output = `system_profiler SPBluetoothDataType`

      @devices = Parser.parse(command_output)
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


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# -= Configuration =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #

# Within this `BluetoothInspector.run do; ...; end` block is where you can configure this plugin.
# This configuration block is run in between collecting the devices and formatting for output before printing to output.
#
# # Devices
#
# This plugin will use the `system_profiler` system command to retrieve information on your connect bluetooth devices.
#
# Each device will have the following attributes:
#
# `name` (required)                The name of the device.
# `shortname`                      An arbitrary short name to give to the device. This will return the `name` if unset.
# `battery`                        The battery level of the device, if it has one.
# `color`                          An arbitary bitbar compatible color.
# `bar_item` (default: `true`)     Whether this device will be shown in the bar.
# `menu_item` (default: `true`)    Whether this device will be shown in the menu.
#
# # Finding Devices
#
# To retrieve all devices, you can simply use the `devices` method.
# This device list is mutable and can be modified how ever you'd like:
#
# ```rb
# BluetoothInspector.run do
#
#   # Remove all devices without battery levels:
#   devices.delete_if { |device| !device.battery? } # Or:
#   devices.delete_if(&:no_battery?)
#
#   # Only show devices with battery levels in the bar:
#   devices.find_all { |device| !device.battery? }.each { |device| device.bar_item = false } # Or:
#   devices.find_all(&:no_battery?).each { |device| device.bar_item = false }
#
#   # Color all low battery level devices red:
#   devices.find_all { |device| device.battery? && device.battery < 20 }.each { |device| device.color = "red" }
#
# end
# ```
#
# You can also retrieve a device by it's name or shortname attributes:
#
# ```rb
# BluetoothInspector.run do
#
#   device("MyNamedKeyboard").color = "blue"
#
# end
# ```
#
# You can pass a block which will be run on the found device only if it is found to avoid nil checks.
# This block will be run with within a DeviceContext DSL:
#
# ```rb
# BluetoothInspector.run do
#
#   device("MyNamedKeyboard") do
#     # This block is only run if "MyNamedKeyboard" is found
#
#     color "blue"
#     shortname "KB"
#   end
#
# end
# ```
#
# If a block argument is given, it will pass the device to it and not change the scope of the block:
#
# ```rb
# BluetoothInspector.run do
#
#   device("MyNamedKeyboard") do |device|
#     # This block is only run if "MyNamedKeyboard" is found
#
#     device.color = "blue"
#     device.shortname = "KB"
#   end
#
# end
# ```
#
# # Formatting
#
# The format of a device in the bar or menu are set with the `bar_format` and `item_format` methods:
#
# BluetoothInspector.run do
#
#   # Defaults:
#   bar_format ":shortname :battery%"
#   item_format ":name"
#
# end
#
# Within the given value, a colon (`:`) followed by a device attribute name will be replaced by that devices attribute
# value. As of now, these attributes are `name`, `shortname`, and `battery`.

BluetoothInspector.run

# My personal configuration:
#
# BluetoothInspector.run do
#
#   bar_format ":battery%"
#
#   devices.find_all(&:no_battery?).each { |device| device.bar_item = false }
#   devices.find_all { |device| device.battery? && device.battery < 20 }.each { |device| device.color = "red" }
#
#   device("RyBoard") do
#     color     "#008BF1"
#     shortname "K"
#   end
#
#   device("RyMouse") do
#     color     "#92D3FF"
#     shortname "M"
#   end
#
# end
