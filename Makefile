puppet:
	puppet apply --modulepath=modules -e "class { 'm8_gpe': target => '$(PWD)' }"

clean:
	-rm -rf boot.img build cm csplitb dt dtbtool e2fsprogs m8_gpe.zip mkbootimg ruu supersu sqlite

distclean: clean
	-rm -rf sources
