# HELP
Small collection of tips and tricks to survive the Temperaturmessdienst-challange.

## clean *"tm.csv"* if you find temperature from 1.1.1970
If system got wrong date, you can do following to recover
```bash
systemctl --user stop tmd.service
sed '/^1970./D' tm.csv > tm.csv2
cp tm.csv tm.csv.backup
cp tm.csv2 tm.csv
systemdctl --user restart tmd.service
```

"tm_720.csv" can be cleaned, too, but it will be cleaned after 720s, if systemdate was corrected.
