# Copyright (c) 2018-2020 vargaconsulting, Toronto,ON Canada
# Author: Varga, Steven <steven@vargaconsulting.ca>

apps = h5cpp

PREFIX = /usr/local
llvm-config=llvm-config-6.0
CXXFLAGS =  -I../  `$(llvm-config) --cxxflags` -std=c++17
LDFLAGS = `$(llvm-config) --ldflags`
LIBS =  -lclangFrontend -lclangSerialization -lclangDriver \
		-lclangTooling -lclangParse -lclangSema -lclangAnalysis \
		-lclangRewrite -lclangRewriteFrontend \
		-lclangEdit -lclangAST -lclangASTMatchers -lclangLex -lclangBasic \
		`$(llvm-config) --libs` -Wl,-Bdynamic `$(llvm-config) --system-libs`

%.o : $(SRC_DIR)/%.cpp 
	$(CXX) -$(INCLUDES) -o $@  $(CPPFLAGS) $(CXXFLAGS) -c $^

all: $(apps)

h5cpp: h5cpp.o 
	$(CXX)  $^ $(LDFLAGS) $(LIBS)  -o ../$@


clean:
	@$(RM) *.o  ../$(apps)

.PHONY: test

