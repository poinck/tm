# temperature measurement v0.0.1alpha
**One wire sensor temperature measurement application written in Vala.**
This readme explains how to install and use "temperature measurement". It consists of a server and client component. It uses the Linux-kernel modules "w1_gpio" and "w1_therm" to read the output of temperature sensors.

## tmd
**temperature measurement deamon (Temperaturmessdienst)**
Following features are part of "tmd":
 - record one wire sensor readings
 - submit measurements to Open Weather Map

**Status:** implementation in progress

## tmc
**temperature measurement cli-client (Temperaturmessclient)**
command-line client which can read "tm.csv" directly and connect to a local or remote "tmd"

**Status:** in planning

## tmc-gtk
**temperature measurement gtk-client (Temperaturmessclient)**
Gtk3 application which can read "tm.csv" directly and connect to a local or remote "tmd"

**Status:** Mockup in planning
