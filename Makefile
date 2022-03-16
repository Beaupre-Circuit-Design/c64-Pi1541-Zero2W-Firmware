DEST = Pi1541-Zero2W

all: $(DEST)/dos1541 $(DEST)/1541/fb.d64 $(DEST)/kernel.img $(DEST)/bootcode.bin $(DEST)/fixup.dat $(DEST)/start.elf $(DEST)/config.txt $(DEST)/options.txt
	@echo "Done. Copy the files in $(DEST) to the root dorectory of a FAT32 SD-Card to use Pi1541."

.directories:
	@echo "Creating destination directory $(DEST)."
	@[ -d Pi1541-Zero2W ] || mkdir -p $(DEST)
	@[ -d $(DEST)/1541 ] || mkdir -p $(DEST)/1541
	@touch .directories

$(DEST)/kernel.img: .directories
	@echo "Compiling Kernel."
	@make -C Pi1541 V=1
	@rm -f $(DEST)/kernel.img
	@echo "Copying kernel to $(DEST)."
	@cp Pi1541/kernel.img $(DEST)/

$(DEST)/1541/fb.d64: .directories $(DEST)/kernel.img
	@echo "Downloading fb.d64 to $(DEST)/1541"
	@rm -f $(DEST)/1541/fb.d64
	@wget -q https://cbm-pi1541.firebaseapp.com/fb.d64 -O $(DEST)/1541/fb.d64
	@touch $(DEST)/1541/fb.d64

$(DEST)/dos1541: .directories $(DEST)/kernel.img
	@echo "Creating dos1541."
	@rm -f $(DEST)/dos1541
	@wget -q http://www.zimmers.net/anonftp/pub/cbm/firmware/drives/new/1541/1541-c000.325302-01.bin http://www.zimmers.net/anonftp/pub/cbm/firmware/drives/new/1541/1541-e000.901229-05.bin -O $(DEST)/dos1541
	@touch $(DEST)/dos1541

$(DEST)/bootcode.bin: .directories $(DEST)/kernel.img
	@echo "Copying bootcode.bin to $(DEST)."
	@rm -f $(DEST)/bootcode.bin
	@cp /boot/bootcode.bin $(DEST)/

$(DEST)/fixup.dat: .directories $(DEST)/kernel.img
	@echo "Copying fixup.dat to $(DEST)."
	@rm -f $(DEST)/fixup.dat
	@cp /boot/fixup.dat $(DEST)/

$(DEST)/start.elf: .directories $(DEST)/kernel.img
	@echo "Copying start.elf to $(DEST)."
	@rm -f $(DEST)/start.elf
	@cp /boot/start.elf $(DEST)/

$(DEST)/config.txt: .directories $(DEST)/kernel.img
	@echo "Creating config.txt"
	@rm -f $(DEST)/config.txt
	@echo "kernel_address=0x1f00000" > $(DEST)/config.txt
	@echo "force_turbo=1" >> $(DEST)/config.txt
	@echo "arm_freq=1200" >> $(DEST)/config.txt
	@echo "#over_voltage=6" >> $(DEST)/config.txt

$(DEST)/options.txt: .directories $(DEST)/kernel.img
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
