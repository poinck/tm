# Readme: temperature measurement

![Eclipse 2015](/tm/150320eclipse.png)

**One wire sensor temperature measurement application written in Vala.**
This readme explains how to install and use "temperature measurement". It consists of a server and client component. It uses the Linux-kernel modules "w1_gpio" and "w1_therm" to read the output of temperature sensors.

## Components

### tmd
**temperature measurement deamon (Temperaturmessdienst)**
Following features are part of "tmd":
 - record one wire sensor readings
 - submit measurements to Open Weather Map

**Status:** implementation in progress

### tmc
**temperature measurement cli-client (Temperaturmessclient)**
command-line client which can read "tm.csv" directly and connect to a local or remote "tmd"

![tmc](/tm/tmc.png)

**Status:** in planning

### tmc-gtk
**temperature measurement gtk-client (Temperaturmessclient)**
Gtk3 application which can read "tm.csv" directly and connect to a local or remote "tmd"

**Status:** Mockup in planning

## Licenses
**exceptions from CC0**
- tm/favicon.ico: CC-BY-SA 3.0, by Gnome, https://github.com/GNOME/gnome-icon-theme-symbolic/blob/master/gnome/scalable/status/weather-few-clouds-symbolic.svg 
