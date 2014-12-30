public class TmConfig {
	public static const string CONFIG_FILE = ".tm.conf";

	public int sensorInterval = 1;
	public string dateLabel = "datum"; // date
	public string workDir;
	public static const string DEFAULT_WORKDIR = "./";

	public string[] sensorLabels;
	public string[] sensorFiles;

	public static const string OWM = "OpenweatherMap";
	public int owmInterval = 10;
	public string owmSensor = "aussen"; // outside
	public bool owmReportUnchanged = true;
	public string owmLat = "";
	public string owmLong = "";
	public string owmAlt = "";
	public string owmName = "";
	public string owmUser = "";
	public string owmPassword = "";
	public string owmPostUrl = "http://openweathermap.org/data/post";
	
	public TmConfig() {
		KeyFile file = new KeyFile();
		file.set_list_separator(',');

		try {
			stdout.printf("[TmConfig] config file location = %s\n", Environment.get_home_dir() + "/" + CONFIG_FILE);
			file.load_from_file(Environment.get_home_dir() + "/"  + CONFIG_FILE, KeyFileFlags.NONE);

			// generic temperature settings
			this.sensorInterval = file.get_integer("Temperature", "interval");
			this.dateLabel = file.get_string("Temperature", "date_label");
			this.workDir = file.get_string("Temperature", "work_dir");
			if (this.workDir.length == 0) {
				this.workDir = DEFAULT_WORKDIR;
			}
		
			// one wire sensor settings
			this.sensorLabels = file.get_string_list("W1Sensors", "sensor_labels");
			this.sensorFiles = file.get_string_list("W1Sensors", "sensor_files");

			// openweather map settings
			this.owmSensor = file.get_string(OWM, "sensor");
			this.owmInterval = file.get_integer(OWM, "interval");
			this.owmReportUnchanged = file.get_boolean(OWM, "report_unchanged");
			this.owmLat = file.get_string(OWM, "lat");
			this.owmLong = file.get_string(OWM, "long");
			this.owmAlt = file.get_string(OWM, "alt");
			this.owmName = file.get_string(OWM, "name");
			this.owmUser = file.get_string(OWM, "user");
			this.owmPassword = file.get_string(OWM, "password");
			this.owmPostUrl = file.get_string(OWM, "post_url");
		} catch (Error e) {
			stdout.printf("[TmConfig] ERROR while reading '~/.tm.conf': %s\n", e.message);
			this.workDir = DEFAULT_WORKDIR;
		}
	}

}
