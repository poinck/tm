#!/bin/bash

./get_tmcsv.sh
if [[ "$?" -gt 0 ]] ; then
    echo "ERROR  no 'tm_sum.csv'; the deployt tm-web will"
    echo "       show no temperature data"
    echo "       'get_tmcsv.sh' is not part of tm."
fi

cp /home/poinck/gits/tm/tm/web/* /var/www/localhost/htdocs/.

chmod a+r /var/www/localhost/htdocs/farbbalken.csv
chmod a+r /var/www/localhost/htdocs/d3workshop.html
chmod a+r /var/www/localhost/htdocs/index.html
chmod a+r /var/www/localhost/htdocs/tmconfig.js
chmod a+r /var/www/localhost/htdocs/tm.js
chmod a+r /var/www/localhost/htdocs/tm_sum.csv
