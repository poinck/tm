void help() {
	stdout.printf("tmd (Temperaturmessdienst) by André Klausnitzer, CC0\n -r, --reset-sum\n\trewrites entire tm_sum.csv including header.\n -w, --tm-workdir [PATH]\n\tdefault: current directory './' (directory, where 'tm.csv' is located)\n -h, --help\n\tshow this help\n");
}

int main(string[] args) {
	string workDir; // default: current directory
	bool resetSum = false;

	// load settings from .tm.conf
	TmConfig config = new TmConfig();
	workDir = config.workDir;

	// parse application parameters (overwrite settings from .tm.conf)
	for (int i = 0 ; args.length > i ; i++) {
		// debug
		stdout.printf("arg: %s\n", args[i]);

		// help
		if (args[1] == "-h" || args[1] == "--help") {
			workDir = "";
			break;
		}
		
		// workdir
		if (args[i] == "-w" || args[i] == "--tm-workdir") {
			if (args.length > i + 1) {
				workDir = args[i + 1];
				config.workDir = workDir;
			} else {
				workDir = "";
			}
		}
		
		// reset daily temperature summary: generateSum()
		if (args[i] == "-r" || args[i] == "--reset-sum") {
			resetSum = true;
		}

		// TODO  implement config-file reader (with option -c/--config-file and defaults $USER_HOME/.tm.conf), later support for tmd run as root or even a seperate system-user
		// TODO  split functionality into seperate binaries. for example: tmc for viewing temperatures in console and gtmc for gnome3-frontend 

	}

	if (workDir == TmConfig.DEFAULT_WORKDIR) {
		stdout.printf("[main] using default workdir '%s'\n", TmConfig.DEFAULT_WORKDIR);
	} else {
		stdout.printf("[main] using workdir '%s'\n", workDir);
	}
	if (workDir != "") {
		// init
		TmSum tmSum = new TmSum(workDir);
		if (resetSum) {
			tmSum.generateSum();
		}
		
		// TODO  do generate sum periodically of last full day, if not already generated (call seperate method as thread); implement TmSum.dailySum()
		// FIXME use one central thread that triggers events for regular measurement, owm-submit and dailySum()
		try {
			// Thread<int> sumThread = new Thread<int>.try("starting tm-sum thread", tmSum.dailySum);
			// int result = sumThread.join();
			TmLoop loop = new TmLoop(config);
			Thread<int> tmThread = new Thread<int>.try("[main] starting tmLoop", loop.run);
			int result = tmThread.join();
			stdout.printf("[main] stopped tmLoop with status %d\n", result);
		}
		catch (Error e) {
			stdout.printf("[main] ERROR during tmLoop : %s\n", e.message);
		}
	} else {
		help();
	}
	
    return 0;
}
