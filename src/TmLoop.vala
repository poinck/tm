class TmLoop : Object {
	public TmConfig config;
	private DateTime time;

	private DateTime lastSensorReading;
	private DateTime lastOwmSubmit;
	private Array<W1Sensor> w1SensorArray;
	
	private int lastOwmTemp;
	private bool firstOwmTemp;
		// FIXME move to seperate OWM-class?

	public TmLoop(TmConfig config) {
		this.config = config;
		this.lastSensorReading = new DateTime.now_local();
		this.lastOwmSubmit = new DateTime.now_local();
		
		this.lastOwmTemp = -273000;
		this.firstOwmTemp = true;
			// FIXME move to seperate OWM-class?

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
			// FIXME es kann derzeit passieren, dass eine Minute ausgelassen wird, wenn ein Task (OWM-Submit oder Sensorabfrage zusammen länger als eine Sekunde benötigen)
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
				this.lastSensorReading = new DateTime.now_local();
			
				// debug
				stdout.printf("[TmLoop] time = %s \n", this.time.format("%Y-%m-%d %H:%M:%S"));			
				
				for (int i = 0; i < this.w1SensorArray.length ; i++) {
					if (this.w1SensorArray.index(i).read()) {
						// SensorResults results = this.w1SensorArray.index(i).getSensorResults();
						
						// debug
						stdout.printf("[TmLoop] %s = %d\n", this.w1SensorArray.index(i).getLabel(), this.w1SensorArray.index(i).getVal());
					}
				}
			}

			// TODO  submit sensor reading to OWM
			if (itIsTime(this.lastOwmSubmit, this.config.owmInterval)) {
				this.lastOwmSubmit = new DateTime.now_local();
			
				// debug
				stdout.printf("[TmLoop] time = %s \n", this.time.format("%Y-%m-%d %H:%M:%S"));	
				
				int owmTemp = -273000;
				for (int i = 0; i < this.w1SensorArray.length ; i++) {
					if (this.w1SensorArray.index(i).getLabel() == this.config.owmSensor) {
						owmTemp = this.w1SensorArray.index(i).getVal();
					}
				}
				if ((this.firstOwmTemp || this.lastOwmTemp != owmTemp) && owmTemp != -273000) {
					float owmTempF = owmTemp / 1000.0f;
					string owmTempS = owmTempF.to_string("%.1f");
					string owmData = "'temp=" + owmTempS + "&lat=" + this.config.owmLat + "&long=" + this.config.owmLong + "&alt=" + this.config.owmAlt + "&name=" + this.config.owmName + "'";
					string owmCredentials = this.config.owmUser + ":" + this.config.owmPassword;
					string owmSubmit = "curl -s -d " + owmData + " --user '" + owmCredentials + "' " + this.config.owmPostUrl;
					
					// debug
					stdout.printf("owmSubmit = %s\n", owmSubmit);
					
					int cmdResult = Posix.system(owmSubmit);
					this.lastOwmTemp = owmTemp;
					this.firstOwmTemp = false;
						// FIXME create seperate class for OWM?
				
					// debug
					stdout.printf("cmdResult = %d\n", cmdResult);	
				}
			}
			
		}

		// return 4;
	}
}