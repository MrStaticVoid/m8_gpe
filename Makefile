puppet:
	puppet apply --modulepath=modules -e "class { 'm8_gpe': target => '$(PWD)' }"

clean:
	-rm -rf boot build compiler digitalhigh dt.img dtbtool e2fsprogs kernel m8_gpe.zip mkbootimg ruu supersu

distclean: clean
	-rm -rf sources
