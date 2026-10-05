# build a debian package
#
deb:
	$(MAKE) -C debian_build deb


# install the latest debian package
#
debinstall:
	$(MAKE) -C debian_build debinstall


clean:
	rm -f *~
	$(MAKE) -C debian_build clean


.PHONY: deb debinstall clean
