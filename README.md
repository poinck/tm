# Readme: temperature measurement

![Eclipse 2015](/150320eclipse.png)

**One wire sensor temperature measurement application suite written in Python and Javascript.**
It uses the Linux-kernel modules "w1_gpio" and "w1_therm" to read the output of temperature sensors. Further more at least one webfront is available.

*ATTENTION: `tmd` and tmc-webui will be rewritten in the next weeks*

## Components

### tmd
**temperature measurement deamon (Temperaturmessdienst)**
Following features are part of "tmd":
 - record one wire sensor readings
 - generate "tm.csv", daily "tm\_\<date\>.csv" and "tm\_sum.csv".

**Status:** two seperate implementations in progress (bash and Vala)

### tmc
**temperature measurement cli-client (Temperaturmessclient)**
command-line client which can read "tm.csv" and "tm_sum.csv" provided by "tmd" on a remote or local webserver. It can show the current temperature, the temperatures of the last 12 hours and by default the temperature-summary of the last 30 days.

![tmc](/tmc.png)

**Options:**
```
-d <days>    adjust days of summary, last 30 days
```

**Status:** implementation in progress

### tmc-webui
**temperature measurement web-ui**
Web frontends which show the file "tm_720.csv" in your browser and others available through new implementation of `tmd`

**Status:** two implementations ready to use using existing "tm_720.csv"


## Licenses
**exceptions from CC0**
- tm/favicon.ico: CC-BY-SA 3.0, by Gnome, https://github.com/GNOME/gnome-icon-theme-symbolic/blob/master/gnome/scalable/status/weather-few-clouds-symbolic.svg
