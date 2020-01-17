
PREFIX = /usr/local

VERSION = 1.10.4.5
PROGRAM_NAME=h5cpp
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
#fdupes.o md5/md5.o $(ADDITIONAL_OBJECTS)

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
	$(INSTALL_PROGRAM)	h5cpp   $(BIN_DIR)/$(PROGRAM_NAME)
	$(INSTALL_DATA)		h5cpp.1 $(MAN_DIR)/$(PROGRAM_NAME).$(MAN_EXT)
	$(INSTALL_INCLUDE)	-d $(INCLUDE_DIR)/$(PROGRAM_NAME)-llvm
	
#find h5cpp-llvm -type f -exec install -Dm 755 "{}" "${INCLUDE_DIR}/{}" \;

clean:
	$(RM) -rf debian/h5cpp
	$(RM) -f debian/h5cpp*
	#$(MAKE) -C src clean

dist: h5cpp
	debuild -i -us -uc -b


