# build a debian package using equivs-build
#
.PHONY: deb
deb:
	equivs-build equivs.control


# install the latest debian package
#
.PHONY: debinstall
debinstall:
	sudo dpkg -i lan-chat_*_all.deb


.PHONY: clean
clean:
	rm -f *~
	rm -f lan-chat_*.deb
	rm -f lan-chat_*.buildinfo
	rm -f lan-chat_*.changes
