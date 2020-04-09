PREFIX = /usr/local

VERSION = 1.10.4.6
DEB = -1~exp1
PROGRAM_NAME=h5cpp-compiler
BIN_DIR = $(PREFIX)/bin
INCLUDE_DIR = $(PREFIX)/include

MAN_BASE_DIR = $(PREFIX)/man
MAN_DIR = $(MAN_BASE_DIR)/man1
MAN_EXT = 1

INSTALL = install	# install : UCB/GNU Install compatiable

RM      = rm -f
MKDIR   = mkdir -p

CC ?= gcc
COMPILER_OPTIONS = -Wall -O -g

INSTALL_PROGRAM = $(INSTALL) -c -m 0755
INSTALL_DATA    = $(INSTALL) -c -m 0644
INSTALL_INCLUDE = $(INSTALL)    -m 0755

OBJECT_FILES = 

#####################################################################
# no need to modify anything beyond this point                      #
#####################################################################

all: h5cpp

h5cpp: 
	$(MAKE) -C src

installdirs:
	test -d $(BIN_DIR) || $(MKDIR) $(BIN_DIR)
	test -d $(MAN_DIR) || $(MKDIR) $(MAN_DIR)
	test -d $(INCLUDE_DIR) || $(MKDIR) $(MAN_DIR)

install: installdirs
	$(INSTALL_PROGRAM)	h5cpp   $(BIN_DIR)/
	$(INSTALL_DATA)		h5cpp.1 $(MAN_DIR)/$(PROGRAM_NAME).$(MAN_EXT)

clean:
	$(RM) -rf debian/h5cpp
	$(RM) -f debian/h5cpp*
	#$(MAKE) -C src clean

dist: h5cpp
	debuild -i -us -uc -b

tar-gz:
	tar --exclude='.[^/]*' --exclude-vcs-ignores -czvf ../${PROGRAM_NAME}_${VERSION}.orig.tar.gz ./ 
	gpg --detach-sign --armor ../${PROGRAM_NAME}_${VERSION}.orig.tar.gz	
	scp ../${PROGRAM_NAME}_${VERSION}.orig.tar.* osaka:h5cpp.org/download/ 

dist-debian-src: tar-gz
	debuild -i -us -uc -S

dist-debian-bin:
	debuild -i -us -uc -b
	gpg --detach-sign --armor ../${PROGRAM_NAME}_${VERSION}${DEB}_amd64.deb

dist-upload: dist-debian-src dist-debian-bin
	scp ../${PROGRAM_NAME}_${VERSION}${DEB}_amd64.deb osaka:h5cpp.org/download/ 	
	scp ../${PROGRAM_NAME}_${VERSION}${DEB}_amd64.deb.asc osaka:h5cpp.org/download/ 	


dist-debian-src-upload: dist-debian-src
	debsign -k 1B04044AF80190D78CFBE9A3B971AC62453B78AE ../${PROGRAM_NAME}_${VERSION}${DEB}_source.changes
	dput mentors ../${PROGRAM_NAME}_${VERSION}${DEB}_source.changes

dist-rpm: dist-debian
	sudo alien -r ../${PROGRAM_NAME}_${VERSION}_all.deb
