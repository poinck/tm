# Temperaturmessung (temperature measurement)
**tm-0.0.1alpha**
This readme explains how to install and use "temperature measurement". It consists of a server and client component and is written in Vala. 

## tmd
**Temperaturmessdienst (temperature measurement deamon)**
Following features are part of "tmd":
 - record one wire sensor readings
 - submit measurements to Open Weather Map

**Status:** implementation in progress

## tmc
**Temperaturmessclient (temperature measurement cli-client)**
command-line client which can read "tm.csv" directly and connect to a local or remote "tmd"

**Status:** in planning

## tmc-gtk
**Temperaturmessclient (temperature measurement gtk-client)**
Gtk3 application which can read "tm.csv" directly and connect to a local or remote "tmd"

**Status:** Mockup in planning
