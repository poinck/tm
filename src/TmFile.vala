public class TmFile : CsvFile {
	public static const string TM_FILE = "tm.csv";
	public static const int MAX_SENSORS = 2; // FIXME support more than 2 sensors
	
	public class TmEntry {
		public string datum;
		public int temperatur[2]; 
	}
	
	// private List<TmEntry> tmList;
	
	public TmFile(string uri) {
		base(uri);

	}
	
	/*
	private int readTm() {
		var tmFile = File.new_for_path(uri);
		
		if (tmFile.query_exists() == false) {
		    stderr.printf("[TmFile] ERROR File '%s' does not exist.\n", tmFile.get_path());
		    return 1;
		}
		
		try {
		    var dis = new DataInputStream (tmFile.read());
		    string line;
		    
		    stdout.printf("[TmFile] readTm() START\n");
		    while ((line = dis.read_line(null)) != null) {
		        // stdout.printf("%s\n", line);
		        tmList.append(parseTmEntry(line));
		        
		        // debug
		        // unowned List<TmEntry> tmpList = tmList.last();
		        // TmEntry tmpEntry = tmpList.data;
		        // stdout.printf("innen = %d\n", tmpEntry.temperatur[INNEN]);
		    }
		    stdout.printf("[TmFile] readTm() END, tmList.length = %d\n", (int) tmList.length());
		} catch (Error e) {
		    error("%s", e.message);
		}
		
		return 0;
	}
	*/

	public static TmEntry parseTmEntry(string line) {
		TmEntry tmEntry = new TmEntry();
		
		string[] entries = line.split(",");
		
		// debug
		// stdout.printf("%d\n", entries.length);
		
		if (entries.length > MAX_SENSORS) {
			// TODO  set tmEntry.dT
			tmEntry.datum = entries[0].split(" ")[0];
			tmEntry.temperatur[0] = int.parse(entries[1]);
			tmEntry.temperatur[1] = int.parse(entries[2]);
			
			// debug
			// stdout.printf("entries[1] = %s\n", entries[1]);
			// stdout.printf("tmEntry.temperatur[0] = %d\n", tmEntry.temperatur[0]);
		}
		
		// debug
		// stdout.printf("%s\n", entries[1]);
	
		return tmEntry;
	}
}
