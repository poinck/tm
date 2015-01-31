### HELP
small collection of tips and tricks to survive the Temperaturmessdienst-challange.

**clean "tm.csv" if you find temperature from 1.1.1970**
 - if system got wrong date
   stop tmd.service
   sed '/^1970./D' tm.csv > tm.csv2
   backup original tm.csv
   replace tm.csv with cleand tm.csv2
   (tm_720.csv can be cleaned, too, but it will be cleaned after 720s, if systemdate was corrected)
   restart tmd.service
