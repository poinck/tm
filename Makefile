default: compile

all: clean compile

clean:
	# rm tm-sum

compile:
	valac -g -v --pkg gio-2.0 src/tm-sum.vala src/SumFile.vala src/CsvFile.vala src/TmFile.vala src/TmSum.vala
	
	
