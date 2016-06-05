module BluetoothInspector

  class << self

    # Run the plugin controller.
    def run(&block)
      Controller.run(&block)
    end

  end

end
