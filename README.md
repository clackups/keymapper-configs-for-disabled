# Keymapper configurations for disabled users

[Keymapper](https://github.com/houmain/keymapper) is an open-source
software by Albert Kalchmair that allows remapping of the keyboard
input and assigning additional functions to key combinations.

The Keymapper installation binaries for Linux, MacOS and Windows are
available on its [Releases
page](https://github.com/houmain/keymapper/releases).

Installation steps under Ubuntu:

```
wget https://github.com/houmain/keymapper/releases/download/5.3.1/keymapper-5.3.1-Linux-x86_64.deb
sudo apt install ./keymapper-5.3.1-Linux-x86_64.deb

# trying without automatic startup
sudo systemctl start keymapperd

# copy the keymapper configuration
git clone https://github.com/clackups/keymapper-configs-for-disabled.git

cp keymapper-configs-for-disabled/right_hand_mirrored_keymapper.conf ~/.config/keymapper.conf

# start the keymapper
nohup keymapper -u &

######
# setting it up for automatic startup
sudo systemctl enable keymapperd

# add the startup command to the session startup
mkdir -p ~/.config/autostart

cat >~/.config/autostart/keymapper.desktop <<'EOT'
[Desktop Entry]
Type=Application
Exec=sh -c "/usr/bin/keymapper -u >>$HOME/.var/keymapper.log 2>&1"
Hidden=false
Name=Keymapper
Comment=Remaps the keyboard for me
EOT
```

If you modify the configuration, keymapper detects it automatically,
so you don't need to restart the process.


## Right-handed mirrored keyboard

The mapping file `right_hand_mirrored_keymapper.conf` translates long
presses on the keys of the right half of the keyboard into mirrored
keys from the left half: Long-pressing P produces Q, and so on.

The long press timeout is set to 300ms, and can be set to a higher
value in configuration file if needed.



## Copyright and license

This work is licensed under the MIT License.

Copyright (c) 2026 clackups@gmail.com

Fediverse: [@clackups@social.noleron.com](https://social.noleron.com/@clackups)
