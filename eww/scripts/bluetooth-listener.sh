#!/usr/bin/env bash

bt_power() {
    bluetoothctl show | grep -q "Powered: yes" && echo "yes" || echo "no"
}

bt_device() {
    bluetoothctl devices Connected | head -n1 | cut -d ' ' -f3-
}

emit_state() {
    local power device
    power="$(bt_power)"
    device="$(bt_device)"
    printf '["%s","%s"]\n' "$power" "$device"
}

emit_state

dbus-monitor --system \
    "type='signal',interface='org.freedesktop.DBus.Properties',path='/org/bluez/hci0'" \
    "type='signal',interface='org.freedesktop.DBus.Properties',sender='org.bluez'" \
2>/dev/null | while IFS= read -r line; do
    case "$line" in
        *"Powered"*|*"Connected"*)
            sleep 0.3
            emit_state
            ;;
    esac
done