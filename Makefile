VALA_OPTS=-v --pkg gio-2.0
CC_OPTS=-X -O2
SRC_FILES=src/tmd.vala src/SumFile.vala src/CsvFile.vala src/TmFile.vala src/TmSum.vala

default: compile

all: clean compile

test: clean debug

clean:
	rm tmd

compile:
	valac $(VALA_OPTS) $(CC_OPTS) $(SRC_FILES)

debug: 
	valac -g $(VALA_OPTS) $(CC_OPTS) $(SRC_FILES) 
