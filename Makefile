.Pi1541:
	@[ -d Pi1541 ] || mkdir -p Pi1541
	touch .Pi1541
	
Pi1541/dos1541: .Pi1541
	$(Q)$(RM) 1541-c000.325302-01.bin 1541-e000.901229-05.bin
	wget http://www.zimmers.net/anonftp/pub/cbm/firmware/drives/new/1541/1541-c000.325302-01.bin
	wget http://www.zimmers.net/anonftp/pub/cbm/firmware/drives/new/1541/1541-e000.901229-05.bin
	cat 1541-e000.901229-05.bin >> 1541-c000.325302-01.bin
	mv  1541-c000.325302-01.bin Pi1541/dos1541
	$(Q)$(RM) 1541-e000.901229-05.bin

all: Pi1541/dos1541
	@[ -d Pi1541 ] || mkdir -p Pi1541
	cp dos1541 ./Pi1541/
	
clean:
	rm -rf Pi1541
	rm -f .Pi1541
	
