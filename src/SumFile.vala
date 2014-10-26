public class SumFile : CsvFile {
	public static const string TM_SUM_FILE = "tm_sum.csv";
	public static const string TM_SUM_FILE_UNIX = "tm_sum_UNIX.csv";
	
	public class SumEntry {
		public string datum;
		public DateTime unixTimestamp;
		public int maxTemperatur[2];
		public int minTemperatur[2];
		public int avgTemperatur[2];
	}
	
	public SumFile(string uri) {
		base(uri);
		var sumFile = File.new_for_path(uri);
		
		// create sumFile if it does not exist
		if (sumFile.query_exists() == false) {
		    stdout.printf("[SumFile] File '%s' does not exist; attempt to create it.\n", sumFile.get_path());
		    
		    try {
				// Create a new file with this name
		        var file_stream = sumFile.create(FileCreateFlags.NONE);
		        if (sumFile.query_exists()) {
		            stdout.printf("[SumFile] 'tm_sum.csv' successfully created.\n");
		            
		            // Write text data to file
			        var data_stream = new DataOutputStream(file_stream);
			        data_stream.put_string ("datum,innen_min,aussen_min,innen_max,aussen_max,innen_avg,aussen_avg\n");
		        } else {
		        	stderr.printf("[SumFile] ERROR File '%s' was not created.\n", sumFile.get_path());
		        }
            } catch (Error e) {
				error("%s", e.message);
			}
		} else {
			stdout.printf("[SumFile] File '%s' already exists, I will use this.\n", sumFile.get_path());
		}
	}
	
	public File file;
	public FileOutputStream fos;
	
	public bool openFile() {
		file = File.new_for_path(uri);
		
		try {
			fos = file.append_to (FileCreateFlags.NONE);
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
			return false;
		}

		return true;
	}

	public bool writeLine(string line) {
		try {
			fos.write(line.data);
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
			return false;
		}

		return true;
	}
}
