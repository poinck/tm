class TmSum {
	public static const int INNEN = 0;
	public static const int AUSSEN = 1;
	public static const int WRONG_VALUE = 85000;

	private SumFile sumFile;
	private SumFile sumFile_UNIX;
	private string tmFileDir;
	private string sumFileDir;

	public TmSum(string workDir) {
		this.tmFileDir = workDir + "/" + TmFile.TM_FILE;
		this.sumFileDir = workDir  + "/" + SumFile.TM_SUM_FILE;
		this.sumFile = new SumFile(sumFileDir);
		this.sumFile_UNIX = new SumFile(workDir + "/" + SumFile.TM_SUM_FILE_UNIX);
	}
	
	// TODO  start at given date (new method-parameter) 
	// TODO  support parameter for full generate given as application-parameter
	public int generateSum() {
		var tmFile = File.new_for_path(tmFileDir);
		
		if (tmFile.query_exists() == false) {
		    stderr.printf("[TmFile] ERROR File '%s' does not exist.\n", tmFile.get_path());
		    return 1;
		}
		
		string lastDay = "";
		int avgCount = 0;
		long sumTemperatur[2];
		SumFile.SumEntry sumEntry = new SumFile.SumEntry();
		
		try {
		    var dis = new DataInputStream (tmFile.read());
		    string line;
		    TmFile.TmEntry tmEntry;
		    
		    stdout.printf("[TmSum] generateSum() START\n");
		    sumFile.openFile();
		    sumFile_UNIX.openFile(); // FIXME  delete or refactor as new solution
		    while ((line = dis.read_line(null)) != null) {
		        // stdout.printf("%s\n", line);
		        tmEntry = TmFile.parseTmEntry(line);
		        
		        // debug
		        // stdout.printf("datum = %s, innen = %d, aussen = %d\n", tmEntry.datum, tmEntry.temperatur[INNEN], tmEntry.temperatur[AUSSEN]);
		        
		        if (tmEntry.datum == "datum") {
		        	stdout.printf("[TmSum] generateSum() header ignored\n");
		        } else {
		        	if (lastDay != tmEntry.datum) {
		        		// new SumEntry can be written to sumFile
		        		if (avgCount != 0) {
		        			sumEntry.avgTemperatur[INNEN] = (int) (sumTemperatur[INNEN] / avgCount);
				    		sumEntry.avgTemperatur[AUSSEN] = (int) (sumTemperatur[AUSSEN] / avgCount);
				    			
				    			
				    		// debug
				    		// stdout.printf("datum = %s, innen_min = %d, aussen_min = %d, innen_max = %d, aussen_max = %d, innen_avg = %d, aussen_avg = %d\n", sumEntry.datum, sumEntry.minTemperatur[INNEN], sumEntry.minTemperatur[AUSSEN], sumEntry.maxTemperatur[INNEN], sumEntry.maxTemperatur[AUSSEN], sumEntry.avgTemperatur[INNEN], sumEntry.avgTemperatur[AUSSEN]);
				    		
				    		// write summary to sumFile
				    		sumFile.writeLine(sumEntry.datum + " 12:00:00," + sumEntry.minTemperatur[INNEN].to_string() + "," + sumEntry.minTemperatur[AUSSEN].to_string() + "," + sumEntry.maxTemperatur[INNEN].to_string() + "," + sumEntry.maxTemperatur[AUSSEN].to_string() + "," + sumEntry.avgTemperatur[INNEN].to_string() + "," + sumEntry.avgTemperatur[AUSSEN].to_string() + "\n");
				    		
				    		// FIXME  just for the fun with UNIX-timestamp
				    		string[] tmpDate = sumEntry.datum.split("-");
				    		int year = int.parse(tmpDate[0]);
				    		int month = int.parse(tmpDate[1]);
				    		int day = int.parse(tmpDate[2]);
				    		var time = new DateTime.utc(year, month, day, 12, 0, 0);
				    		
				    		sumFile_UNIX.writeLine(time.to_unix().to_string("%" + int64.FORMAT) + "," + sumEntry.minTemperatur[INNEN].to_string() + "," + sumEntry.minTemperatur[AUSSEN].to_string() + "," + sumEntry.maxTemperatur[INNEN].to_string() + "," + sumEntry.maxTemperatur[AUSSEN].to_string() + "," + sumEntry.avgTemperatur[INNEN].to_string() + "," + sumEntry.avgTemperatur[AUSSEN].to_string() + "\n");
		        		}
		        	
		        		// init/reset sumEntry for next day
		        		lastDay = tmEntry.datum;
		        		sumEntry.datum = tmEntry.datum;
		        		sumEntry.maxTemperatur[INNEN] = tmEntry.temperatur[INNEN];
		        		sumEntry.maxTemperatur[AUSSEN] = tmEntry.temperatur[AUSSEN];
		        		sumEntry.minTemperatur[INNEN] = tmEntry.temperatur[INNEN];
		        		sumEntry.minTemperatur[AUSSEN] = tmEntry.temperatur[AUSSEN];
		        		avgCount = 1;
		        		sumTemperatur[INNEN] = (long) tmEntry.temperatur[INNEN];
		        		sumTemperatur[AUSSEN] = (long) tmEntry.temperatur[AUSSEN];
		        		
		        	} else {
		        		if (tmEntry.temperatur[INNEN] != WRONG_VALUE 
		        		&& tmEntry.temperatur[AUSSEN] != WRONG_VALUE) {
		        			if (sumEntry.maxTemperatur[INNEN] < tmEntry.temperatur[INNEN]) {
				    			sumEntry.maxTemperatur[INNEN] = tmEntry.temperatur[INNEN];
				    		}
				    		if (sumEntry.minTemperatur[INNEN] > tmEntry.temperatur[INNEN]) {
				    			sumEntry.minTemperatur[INNEN] = tmEntry.temperatur[INNEN];
				    		}
				    		sumTemperatur[INNEN] += (long) tmEntry.temperatur[INNEN];
				    		if (sumEntry.maxTemperatur[AUSSEN] < tmEntry.temperatur[AUSSEN]) {
				    			sumEntry.maxTemperatur[AUSSEN] = tmEntry.temperatur[AUSSEN];
				    		}
				    		if (sumEntry.minTemperatur[AUSSEN] > tmEntry.temperatur[AUSSEN]) {
				    			sumEntry.minTemperatur[AUSSEN] = tmEntry.temperatur[AUSSEN];
				    		}
				    		sumTemperatur[AUSSEN] += (long) tmEntry.temperatur[AUSSEN];
				    		avgCount++;
		        		} else {
		        			stdout.printf("[TmSum] generateSum() 85000 ignored\n");
		        		}
		        	}	
		        }
		    }
		    stdout.printf("[TmSum] generateSum() END\n");
		} catch (Error e) {
		    error("%s", e.message);
		}
		
		// debug
		sumFile.dumpFile();
		
		return 0;
	}	
}
