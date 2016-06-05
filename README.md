# Bluetooth Inspector

A [Bitbar][bitbar] plugin showing bluetooth information for all connected bluetooth devices using
the `system_profiler` binary.

## Screenshot

![Screenshot](https://raw.githubusercontent.com/RyanScottLewis/bitbar-bluetooth_inspector/master/bitbar-bluetooth_inspector.png)

## Usage

Compiled plugin is in `build/` directory.  
Download to your bitbar plugin folder.

## Configuration

Within the `BluetoothInspector.run do; ...; end` block at the end of the plugin file is where you can
configure this plugin.  

This configuration block is run in between collecting the devices and formatting the devices before
printing to output:

1. Collect devices
1. Run configuration block
1. Format devices
1. Print bitbar compatible output

### Devices

This plugin will use the `system_profiler` system command to retrieve information on your connect bluetooth devices.

Each device will have the following attributes:

| Name                          | Description
|-------------------------------|---------------------------------------------------------------
| `name` (required)             | The name of the device.  
| `shortname`                   | An arbitrary short name to give to the device. This will return the `name` if unset.  
| `battery`                     | The battery level of the device, if it has one.  
| `color`                       | An arbitary bitbar compatible color.  
| `bar_item` (default: `true`)  | Whether this device will be shown in the bar.  
| `menu_item` (default: `true`) | Whether this device will be shown in the menu.

#### Finding Devices

To retrieve all devices, you can simply use the `devices` method.
This device list is mutable and can be modified how ever you'd like:

```rb
BluetoothInspector.run do

  # Remove all devices without battery levels:
  devices.delete_if { |device| !device.battery? } # Or:
  devices.delete_if(&:no_battery?)

  # Only show devices with battery levels in the bar:
  devices.find_all { |device| !device.battery? }.each { |device| device.bar_item = false } # Or:
  devices.find_all(&:no_battery?).each { |device| device.bar_item = false }

  # Color all low battery level devices red:
  devices.find_all { |device| device.battery? && device.battery < 20 }.each { |device| device.color = "red" }

end
```

You can also retrieve a device by it's name or shortname attributes:

```rb
BluetoothInspector.run do

  device("MyNamedKeyboard").color = "blue"

end
```

You can pass a block which will be run on the found device only if it is found to avoid nil checks.
This block will be run with within a DeviceContext DSL:

```rb
BluetoothInspector.run do

  device("MyNamedKeyboard") do
    # This block is only run if "MyNamedKeyboard" is found

    color "blue"
    shortname "KB"
  end

end
```

If a block argument is given, it will pass the device to it and not change the scope of the block:

```rb
BluetoothInspector.run do

  device("MyNamedKeyboard") do |device|
    # This block is only run if "MyNamedKeyboard" is found

    device.color = "blue"
    device.shortname = "KB"
  end

end
```

### Formatting

The format of a device in the bar or menu are set with the `bar_format` and `item_format` methods:

```rb
BluetoothInspector.run do

  # Defaults:
  bar_format ":shortname :battery%"
  item_format ":name"

end
```

Within the given value, a colon (`:`) followed by a device attribute name will be replaced by that devices attribute
value. As of now, these attributes are `name`, `shortname`, and `battery`.

## Issues

If an exception is reported from the plugin, please open an issue if one is not already opened for
it on GitHub.

If you can, include the exception itself. It can be retrieved with:

```sh
$ ruby /path/to/bitbar/plugins/bluetooth_inspector.10m.rb
```

## Copyright

Copyright © 2016 Ryan Scott Lewis <ryan@rynet.us>.

The MIT License (MIT) - See LICENSE for further details.

[bitbar]: https://getbitbar.com/
