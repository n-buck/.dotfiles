#/bin/bash

# link the rules
cp ./60-onbattery.rules /etc/udev/rules.d/60-onbattery.rules
cp ./61-onacpower.rules /etc/udev/rules.d/61-onacpower.rules
cp ./62-lowbattery.rules /etc/udev/rules.d/62-lowbattery.rules

# link the script
cp ./onBatteryLevelChanged.sh /usr/share/onBatteryLevelChanged.sh
