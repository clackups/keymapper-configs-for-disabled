# Keymapper configurations for disabled users

[Keymapper](https://github.com/houmain/keymapper) is an open-source
software by Albert Kalchmair that allows remapping of the keyboard
input and assigning additional functions to key combinations.

The Keymapper installation binaries for Linux, MacOS and Windows are
available on its [Releases
page](https://github.com/houmain/keymapper/releases).

## Installation and Setup

### Ubuntu/Linux

```bash
# Install Keymapper first
wget https://github.com/houmain/keymapper/releases/download/5.3.1/keymapper-5.3.1-Linux-x86_64.deb
sudo apt install ./keymapper-5.3.1-Linux-x86_64.deb

# Clone the keymapper configurations
git clone https://github.com/clackups/keymapper-configs-for-disabled.git
cd keymapper-configs-for-disabled

# Run setup script (configures autostart and selects config)
bash setup_ubuntu.sh
```

The `setup_ubuntu.sh` script will:
1. Check and install Keymapper if needed
2. Enable the keymapper daemon
3. Create a user session autostart entry
4. Show an interactive menu to select your keyboard configuration

### Windows

1. Download and install the Keymapper Windows installer from the
[project release page](https://github.com/houmain/keymapper/releases)
(keymapper-5.3.0-Windows-x86_64.msi or newer).

2. During the installation, it will complain that configuration is not
found (which is alright).

3. Once it's installed, there's the Keymapper icon in the corner of
your taskbar. Right-click it, choose Configuration, and choose Notepad
or your favorite editor for it.

4. Copy the content of one of configurations from this github
repository into the editor window and adapt, if needed.

5. Save the file, and Keymapper will automatically load the update. If
you don't plan to edit the configuration further, yoou can close the
editor.


## Available configurations

### Multi-tap keyboard

The mapping file `multitap.conf` enables multi-tap sequences with up to 12 taps per key for single-handed keyboard access.

**Bottom row keys (Z, X, C, V, B, N, M, Comma, Period, Slash):**
- Each key cycles through 3 mapped characters (e.g., Z → A → Q → Z...)
- Supports up to 12 taps with repeating pattern
- Example: Z key cycles through Q, A, Z

**Home row keys (A, S, D, F, G, H, J, K, L, Semicolon):**
- Each key cycles through 2 mapped characters (different from bottom row)
- Map to top row characters above them
- Example: A key cycles through Q, A

**Special keys (Backslash, Quote):**
- Backslash → cycles between BracketRight (]) and Backslash (\)
- Quote (') → cycles between BracketLeft ([) and Quote (')

**Numpad keys (Numpad1, Numpad2, Numpad3):**
- Numpad1 → cycles through 1, 4, 7
- Numpad2 → cycles through 2, 5, 8
- Numpad3 → cycles through 3, 6, 9

Each key's multi-tap sequence repeats its pattern across 12 taps, allowing single-handed access to the entire keyboard layout.


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
