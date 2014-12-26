void help() {
	stdout.printf("Temperaturmessdienst by @poinck (2014), GPLv3, tmd:\n -r, --reset-sum\n\trewrites entire tm_sum.csv including header.\n -w, --tm-workdir [PATH]\n\tdefault: current directory './' (directory, where 'tm.csv' is located)\n -h, --help\n\tshow this help\n");
}

int main(string[] args) {
	string workDir = "./"; // default: current directory
	bool resetSum = false;
	
	// parse application parameters
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

	if (workDir == "./") {
		stdout.printf("[main] using defaults.\n");
	}
	if (workDir != "") {
		// init
		TmSum tmSum = new TmSum(workDir);
		if (resetSum) {			
			tmSum.generateSum();
		}
		
		// TODO  do generate sum periodically of last full day, if not already generated (call seperate method as thread); implement TmSum.dailySum()
				
	} else {
		help();
	}
	
    return 0;
}
