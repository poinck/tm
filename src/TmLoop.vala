class TmLoop : Object {
	public TmConfig config;
	private DateTime time;

	private DateTime lastSensorReading;
	private DateTime lastOwmSubmit;
	private Array<W1Sensor> w1SensorArray;

	public TmLoop(TmConfig config) {
		this.config = config;
		this.lastSensorReading = new DateTime.now_local();

		// initialize list of one wire sensors
		this.w1SensorArray = new Array<W1Sensor>();
		W1Sensor sensor;
		for (int i = 0 ; config.sensorLabels.length > i ; i++) {
			sensor = new W1Sensor(config.sensorFiles[i], config.sensorLabels[i]);
			this.w1SensorArray.append_val(sensor);
		}
	}

	public bool itIsTime(DateTime last, int minutes) {		
		if ((this.time.difference(last) >= minutes * 60 * 1000000)
		&& (this.time.get_second() == 0)) {
			// debug
			stdout.printf("[TmLoop] difference = %" + int64.FORMAT + "\n", this.time.difference(last));
			stdout.printf("[TmLoop] more than %d minute(s) is/are over.\n", minutes);

			return true;
		}

		return false;
	}

	public int run() {
		while (true) {
			// stdout.printf("[TmSum] dailySum() has been called for the %d. time.\n", i);
			Thread.usleep(1000000); // 1 second
			this.time = new DateTime.now_local();

			// read one wire sensors
			if (itIsTime(this.lastSensorReading, this.config.sensorInterval)) {
				stdout.printf("[TmLoop] time = %s \n", this.time.format("%Y-%m-%d %H:%M:%S"));			
				for (int i = 0; i < this.w1SensorArray.length ; i++) {
					if (this.w1SensorArray.index(i).read()) {
						// SensorResults results = this.w1SensorArray.index(i).getSensorResults();
						stdout.printf("[TmLoop] %s = %d\n", this.w1SensorArray.index(i).getLabel(), this.w1SensorArray.index(i).getVal());
					}
				}
				this.lastSensorReading = new DateTime.now_local();
			}

			// TODO  submit sensor reading to OWM
		}

		// return 4;
	}
}
