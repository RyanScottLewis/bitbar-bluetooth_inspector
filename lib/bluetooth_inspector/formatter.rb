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
