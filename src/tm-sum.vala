void help() {
	stdout.printf("Temperaturmessung Summary by @poinck (2014), GPLv3, tm-sum:\n -w, --tm-workdir [PATH]\n\tdefault: current directory './' (directory, where 'tm.csv' is located)\n -h, --help\n\tshow this help\n");
}

int main(string[] args) {
	string workDir = "./"; // default: current directory
	
	// parse application parameters
	if (args.length == 2 && (args[1] == "-h" || args[1] == "--help")) {
		workDir = "";
	} else if (args.length >= 3) {
		workDir = "";
		for (int i = 0 ; args.length > i ; i++) {
			// debug
			stdout.printf("arg: %s\n", args[i]);
			
			// workdir
			if (args[i] == "-w" || args[i] == "--tm-workdir") {
				if (args.length > i + 1) {
					workDir = args[i + 1];
				}
			}
			
			// full-generate
				// TODO
		}
	} else if (args.length == 1) {
		stdout.printf("[main] using defaults.\n");
	} else {
		workDir = "";
	}

	if (workDir != "") {
		// init
		TmSum tmSum = new TmSum(workDir);
		tmSum.generateSum();
			// TODO  do generateSum() periodically (use thread)
				
	} else {
		help();
	}
	
    return 0;
}
