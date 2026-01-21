# Keymapper configurations for disabled users

[Keymapper](https://github.com/houmain/keymapper) is an open-source
software by Albert Kalchmair that allows remapping of the keyboard
input and assigning additional functions to key combinations.

The Keymapper installation binaries for Linux, MacOS and Windows are
available on its [Releases
page](https://github.com/houmain/keymapper/releases).

Installation and setup for Ubuntu:

```bash
git clone https://github.com/clackups/keymapper-configs-for-disabled.git
cd keymapper-configs-for-disabled

# Run setup script (configures autostart and selects config)
bash setup_ubuntu.sh
```

The `setup_ubuntu.sh` script will configure autostart and show an interactive menu to select your keyboard configuration.

If you modify the configuration, keymapper detects it automatically,
so you don't need to restart the process.

## Available configurations

### Multi-tap keyboard

The mapping file `multitap.conf` enables multi-tap sequences on bottom row keys (Z, X, C, V, B, N, M, ,, ., /):

- **Single tap**: outputs the key itself
- **Double tap**: backspace + mapped character (e.g., Z Z → backspace + A)
- **Triple tap**: backspace + mapped character (e.g., Z Z Z → backspace + Q)
- **Quad tap**: backspace + mapped character (e.g., Z Z Z Z → backspace + 1)

Each key maps vertically up its QWERTY column, allowing single-handed access to the entire keyboard.


### Right-hand mirrored keyboard

The `right_hand_mirrored_keymapper.conf` maps the right half of the keyboard to produce left half keystrokes on long press (300ms). The left half remains unchanged.

**Use case**: Single-handed operation using the right hand, or when the left hand is unavailable.


### Left-hand mirrored keyboard

The `left_hand_mirrored_keymapper.conf` maps the left half of the keyboard to produce right half keystrokes on long press (300ms). The right half remains unchanged.

**Use case**: Single-handed operation using the left hand, or when the right hand is unavailable.


### Full mirrored keyboard

The `full_mirrored_keymapper.conf` includes both left and right side mappings. Both halves are mirrored along the center line:
- Left half keys map to right half keys on long press
- Right half keys map to left half keys on long press

**Use case**: Maximum flexibility for either-handed or two-handed operation with full keyboard access from either side.


## Copyright and license

This work is licensed under the MIT License.

Copyright (c) 2026 clackups@gmail.com

Fediverse: [@clackups@social.noleron.com](https://social.noleron.com/@clackups)
