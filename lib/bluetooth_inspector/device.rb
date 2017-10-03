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

    # Get the major type of the device.
    #
    # @return [String]
    attr_reader :major_type

    # Set the major_type of the device.
    #
    # @param [#to_s] value
    # @return [String]
    def major_type=(value)
      @major_type = value.to_s
    end

    # Get the minor type of the device.
    #
    # @return [String]
    attr_reader :minor_type

    # Set the minor_type of the device.
    #
    # @param [#to_s] value
    # @return [String]
    def minor_type=(value)
      @minor_type = value.to_s
    end

    # Get whether the device is paired.
    #
    # @return [Boolean]
    def paired?
      @paired
    end

    # Get whether the device is not paired.
    #
    # @return [Boolean]
    def unpaired?
      !@paired
    end

    # set whether the device is paired.
    #
    # @param [Boolean] value
    # @return [Boolean]
    def paired=(value)
      @paired = !!value
    end

    # Get whether the device is connected.
    #
    # @return [Boolean]
    def connected?
      @connected
    end

    # Get whether the device is not connected.
    #
    # @return [Boolean]
    def disconnected?
      !@connected
    end

    # set whether the device is connected.
    #
    # @param [Boolean] value
    # @return [Boolean]
    def connected=(value)
      @connected = !!value
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
