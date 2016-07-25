#!/bin/bash
# this script is used for development; adjust to your needs

if [[ "$1" == "local" ]] ; then
    # fetch csv from original location to prevent cross-origin-problem.
    ./get_tmcsv.sh
fi

cp /home/poinck/gits/tm/tm/web/* /var/www/localhost/htdocs/.

chmod a+r /var/www/localhost/htdocs/index.html
chmod a+r /var/www/localhost/htdocs/tmconfig.js
chmod a+r /var/www/localhost/htdocs/tm.js
chmod a+r /var/www/localhost/htdocs/tm_*.csv
