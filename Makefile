puppet:
	puppet apply --modulepath=modules -e "class { 'm8_gpe': target => '$(PWD)' }"

clean:
	-rm -rf build-* cm csplitb dt-* dtbtool e2fsprogs firmware-* m8_gpe-*.zip mkbootimg ruu supersu sqlite ota-*

distclean: clean
	-rm -rf sources
