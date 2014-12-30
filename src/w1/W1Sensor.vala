class W1Sensor {
	public static const int WRONG_VALUE = 85000;

	private string sensor;
	private string label;

	private int val;
	// public string time;

	public W1Sensor(string sensor, string label) {
		this.sensor = sensor;
		this.label = label;
	}
	
	public bool read() {
		var sensorFile = File.new_for_path(this.sensor);
		int i = 0;
		string lines[2];
		string line;

		try {
		    var dis = new DataInputStream(sensorFile.read());
			while ((line = dis.read_line(null)) != null) {
		        stdout.printf("[W1Sensor] %s = %s\n", this.label, line);
				lines[i] = line;
				i++;
		    }

			if (lines.length >= 2) {
				// crc
				if (lines[0].contains("YES")) {
					// temperature
					string[] entries = lines[1].split("=");
					if (entries.length >= 2) {
						this.val = int.parse(entries[1]);
						if (this.val == WRONG_VALUE) {
							stdout.printf("[W1Sensor] %s : wrong value detected\n", this.label);
							return false;
						}
						stdout.printf("[W1Sensor] %s = %d\n", this.label, this.val);
					} else {
						stdout.printf("[W1Sensor] %s : .split('=') failed\n", this.label);
						return false;
					}
				} else {
					stdout.printf("[W1Sensor] %s : crc not correct\n", this.label);
					return false;
				}
			} else {
				stdout.printf("[W1Sensor] %s : lines.length >= 2 failed\n", this.label);
			}
		} catch (Error e) {
			error("%s", e.message);
			return false;
		}

		return true;
	}
	
	public string getLabel() { return this.label; }
	public int getVal() { return this.val; }
}
