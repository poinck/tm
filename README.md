# Readme: temperature measurement

**One wire sensor temperature measurement application suite written in Python, Bash and Javascript.**
It uses the Linux-kernel modules "w1_gpio" and "w1_therm" to read the output of temperature sensors. Further more at least one webfront is available.

*NEWS: `tmd` was rewiritten in Python*

## Components

### tmd
**temperature measurement deamon (Temperaturmessdienst)**
Following features are part of "tmd":
 - record one wire sensor readings
 - generate "tm.csv", daily "tm\_\<date\>.csv" and "tm\_sum.csv".

**Status:** stable

### tmc
**temperature measurement cli-client (Temperaturmessclient)**
command-line client which can read "tm.csv" and "tm_sum.csv" provided by "tmd" on a remote or local webserver. It can show the current temperature, the temperatures of the last 12 hours and by default the temperature-summary of the last 30 days.

![tmc](/tmc.png)

**Options:**
```
-d <days>    adjust days of summary, last 30 days
```

**Status:** will be depricated, new implementation will use `dzen2` or `ocelot-dzen`

### tm/web
**temperature measurement web-ui**

**Status:** in progress, possible deprication, if a nice dashboard can be implements with use of `dzen2` or `ocelot-dzen`


## License

Everyting is **CC0**

