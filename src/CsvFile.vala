public class CsvFile {
	protected string uri = "";
	
	public CsvFile(string uri) {
		this.uri = uri;
	}
	
	public int dumpFile() {
		var csvFile = File.new_for_path(uri);
		
		if (csvFile.query_exists() == false) {
		    stderr.printf("[CsvFile] ERROR File '%s' does not exist.\n", csvFile.get_path());
		    return 1;
		}
		
		try {
		    // Open file for reading and wrap returned FileInputStream into a
		    // DataInputStream, so we can read line by line
		    var dis = new DataInputStream (csvFile.read());
		    string line;
		    // Read lines until end of file (null) is reached
		    stdout.printf("[CsvFile] dumpFile() START\n");
		    while ((line = dis.read_line(null)) != null) {
		        stdout.printf("%s\n", line);
		    }
		    stdout.printf("[CsvFile] dumpFile() END\n");
		} catch (Error e) {
		    error("%s", e.message);
		}
		
		return 0;
	}
	
	// public DateTime parseDateTime(string line)
}
