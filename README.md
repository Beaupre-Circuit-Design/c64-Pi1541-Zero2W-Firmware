# Pi1541 Firmware for the Raspberry Pi Zero 2W

The Raspberry Pi Zero 2W is not supported out of the box by the official build of the firmware, the simplest option is to recompile it on the Pi itself and do a few tweaks to the config.txt and options.txt files.

To make things easier, this Makefile will recompile a new kernel, download all the support files and make all the changes to config.txt and options.txt for you. Once everything is done, simply copy the content of the 'Pi1541-Zero2W' directory to the root of a Fat32 SD card and boot your Pi1541 with it.

## Step by step configuration.

1. Create an SD card with the official Raspberry Pi OS distribution and boot your RPI Zero 2W with it.
2. Connect to your RPI Zero 2W via SSH, or use a keyboard/mouse/monitor.
3. Update your RPI Zero 2W (apt update, apt dist-upgrade).
4. Install the toolchain:

```
apt install git build-essential binutils-arm-none-eabi gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib
```

5. Clone this repository: 

```
git clone --recurse-submodules https://github.com/Beaupre-Circuit-Design/c64-Pi1541-Zero2W-Firmware.git
```

6. Build the kernel and SD Image:

```
make
```

7. Copy everything from the directory 'Pi1541-Zero2W' to the root of a Fat32 formatted SD Card and boot your RPI Zero 2W with it.

8. (Optionnal) Create a zip file with everything needed to create the SD Card:

```
make package
```

# Licence

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
