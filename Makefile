# build a debian package
#

deb:
	$(MAKE) -C debian_build deb


# install the latest debian package
#
debinstall:
	sudo dpkg -i debian_build/lan-chat_*_all.deb


clean:
	rm -f *~
	$(MAKE) -C debian_build clean


.PHONY: deb debinstall clean
