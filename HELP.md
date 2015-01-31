### HELP
small collection of tips and tricks to survive the Temperaturmessdienst-challange.

**clean tm-csv**
 - if system got wrong date 
   sed '/^1970./D' tm.csv > tm.csv2
