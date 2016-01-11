# Readme: temperature measurement

![Eclipse 2015](/tm/150320eclipse.png)

**One wire sensor temperature measurement application suite written in bash, Vala and Javascript.**
This readme explains how to install and use "temperature measurement". It consists of a server and client components. It uses the Linux-kernel modules "w1_gpio" and "w1_therm" to read the output of temperature sensors.

## Components

### tmd
**temperature measurement deamon (Temperaturmessdienst)**
Following features are part of "tmd":
 - record one wire sensor readings
 - submit measurements to Open Weather Map (not working, api has changed)

**Status:** two seperate implementations in progress (bash and Vala)

### tmc
**temperature measurement cli-client (Temperaturmessclient)**
command-line client which can read "tm.csv" directly and connect to a local or remote "tmd". It can show the current temperature, thetemperatures of the last 12 hours and by default the temperature-summary of the last 30 days.

![tmc](/tm/tmc.png)

**Options:**
```
-d <days>    adjust days of summary, last 30 days
```

**Status:** implementation in progress

### tmc-webui
**temperature measurement web-ui**
Web frontends which show the file "tm_720.csv" in your browser

**Status:** two implementations ready to use

### tmc-gtk
**temperature measurement gtk-client (Temperaturmessclient)**
Gtk3 application which can read "tm.csv" directly and connect to a local or remote "tmd"

**Status:** Mockup in planning

## Licenses
**exceptions from CC0**
- tm/favicon.ico: CC-BY-SA 3.0, by Gnome, https://github.com/GNOME/gnome-icon-theme-symbolic/blob/master/gnome/scalable/status/weather-few-clouds-symbolic.svg
