# Readme: temperature measurement

**One wire sensor temperature measurement application suite written in Python, Bash and Javascript.**
It uses the Linux-kernel modules "w1_gpio" and "w1_therm" to read the output of temperature sensors.

*NEWS: `tmd` was rewritten in Python*

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

**Status:** in progress, possible deprication, if a desktop-dashboard can be implemented with use of `dzen2` or `ocelot-dzen`


## License

Everyting is **CC0**

<<<<<<< HEAD
## Licenses
**exceptions from CC0**
- tm/favicon.ico: CC-BY-SA 3.0, by Gnome, https://github.com/GNOME/gnome-icon-theme-symbolic/blob/master/gnome/scalable/status/weather-few-clouds-symbolic.svg

=======
>>>>>>> c18c86b1db2a459f0968be0adf1ce5ba9136b077
