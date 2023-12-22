DEST = Pi1541-Zero2W
#FIRMWARE = 1.20180919
FIRMWARE = 1.20230405

all: $(DEST)/kernel.img $(DEST)/dos1541 $(DEST)/chargen $(DEST)/config.txt $(DEST)/options.txt $(DEST)/bootcode.bin $(DEST)/fixup.dat $(DEST)/start.elf $(DEST)/1541/fb.d64
	@echo "Done. Copy the files in $(DEST) to the root dorectory of a FAT32 SD-Card to use Pi1541."

package: all
	@zip -r Pi1541-Zero2W.zip Pi1541-Zero2W/

.directories:
	@echo "Creating destination directory $(DEST)."
	@[ -d Pi1541-Zero2W ] || mkdir -p $(DEST)
	@[ -d $(DEST)/1541 ] || mkdir -p $(DEST)/1541
	@touch .directories

firmware-$(FIRMWARE).zip:
	@echo "Downloading Raspberry PI Firmware"
	@rm -f firmware-$(FIRMWARE).zip
	@wget -q https://github.com/raspberrypi/firmware/archive/$(FIRMWARE).zip -O firmware-$(FIRMWARE).zip

$(DEST)/kernel.img: .directories
	@echo "Compiling Kernel."
	@make -C Pi1541 V=1
	@rm -f $(DEST)/kernel.img
	@echo "Copying kernel to $(DEST)."
	@cp Pi1541/kernel.img $(DEST)/

$(DEST)/1541/fb.d64: .directories
	@echo "Downloading fb.d64 to $(DEST)/1541"
	@rm -f $(DEST)/1541/fb.d64
	@wget -q https://cbm-pi1541.firebaseapp.com/fb.d64 -O $(DEST)/1541/fb.d64
	@touch $(DEST)/1541/fb.d64

$(DEST)/chargen: .directories
	@echo "Downloading chargen to $(DEST)/1541"
	@rm -f $(DEST)/chargen
	@wget -q http://www.zimmers.net/anonftp/pub/cbm/firmware/computers/c64/characters.901225-01.bin -O $(DEST)/chargen
	@touch $(DEST)/chargen

$(DEST)/dos1541: .directories
	@echo "Creating dos1541."
	@rm -f $(DEST)/dos1541
	@wget -q http://www.zimmers.net/anonftp/pub/cbm/firmware/drives/new/1541/1541-c000.325302-01.bin http://www.zimmers.net/anonftp/pub/cbm/firmware/drives/new/1541/1541-e000.901229-05.bin -O $(DEST)/dos1541
	@touch $(DEST)/dos1541

$(DEST)/bootcode.bin: .directories firmware-$(FIRMWARE).zip
	@echo "Copying bootcode.bin to $(DEST)."
	@rm -f $(DEST)/bootcode.bin
	@unzip -j firmware-$(FIRMWARE).zip firmware-$(FIRMWARE)/boot/bootcode.bin  -d $(DEST)/
	@touch $(DEST)/bootcode.bin

$(DEST)/fixup.dat: .directories firmware-$(FIRMWARE).zip
	@echo "Copying fixup.dat to $(DEST)."
	@rm -f $(DEST)/fixup.dat
	@unzip -j firmware-$(FIRMWARE).zip firmware-$(FIRMWARE)/boot/fixup.dat  -d $(DEST)/
	@touch $(DEST)/fixup.dat

$(DEST)/start.elf: .directories firmware-$(FIRMWARE).zip
	@echo "Copying start.elf to $(DEST)."
	@rm -f $(DEST)/start.elf
	@unzip -j firmware-$(FIRMWARE).zip firmware-$(FIRMWARE)/boot/start.elf  -d $(DEST)/
	@touch $(DEST)/start.elf

$(DEST)/config.txt: .directories
	@echo "Creating config.txt"
	@rm -f $(DEST)/config.txt
	@echo "kernel_address=0x1f00000" > $(DEST)/config.txt
	@echo "force_turbo=1" >> $(DEST)/config.txt
	@echo "boot_delay=1" >> $(DEST)/config.txt
	@echo "arm_freq=1200" >> $(DEST)/config.txt
	@echo "#over_voltage=6" >> $(DEST)/config.txt

$(DEST)/options.txt: .directories
	@echo "Copying options.txt to $(DEST) and configuring."
	@rm -f $(DEST)/options.txt
	@cp Pi1541/options.txt $(DEST)/
	@echo "$(DEST)/option.txt : Enabling splitIECLines."
	@sed -i 's/\/\/splitIECLines = 1/splitIECLines = 1/g' $(DEST)/options.txt
	@echo "$(DEST)/option.txt : Using LCD driver ssd1306_128x64."
	@sed -i 's/\/\/LCDName = ssd1306_128x64/LCDName = ssd1306_128x64/g' $(DEST)/options.txt
	@echo "$(DEST)/option.txt : Enabling KeyboardBrowseLCDScreen."
	@sed -i 's/\/\/KeyboardBrowseLCDScreen = 1/KeyboardBrowseLCDScreen = 1/g' $(DEST)/options.txt
	@echo "$(DEST)/option.txt : LCD i2cBusMaster set to 0."
	@sed -i 's/\/\/i2cBusMaster = 0/i2cBusMaster = 0/g' $(DEST)/options.txt
	@echo "$(DEST)/option.txt : Automounting image fb.d64."
	@sed -i 's/\/\/AutoMountImage = fb.d64/AutoMountImage = fb.d64/g' $(DEST)/options.txt
	@echo "$(DEST)/option.txt : Disabling GraphIEC."
	@sed -i 's/GraphIEC = 1/\/\/GraphIEC = 1/g' $(DEST)/options.txt

clean:
	@make -C Pi1541 clean
	@rm -rf $(DEST)
	@rm -f .directories
	@rm -f firmware-$(FIRMWARE).zip
	@rm -f Pi1541-Zero2W.zip
