/**
 * main javascript for temperature graphs
 * - uses tmconfig.js
 */

var tmsum_count = 272;
function get_x(d, i) {
    return i - tmsum_count + 272;
}

var avgline = d3.line()
.x(function(d, i) { return get_x(d, i) + 1; })
.y(function(d) {
    if (isNaN(parseInt(d["aussen_avg"])) == false) {
        t = (parseFloat(d["aussen_avg"]) / 1000) * 1.5;
        if (t < 0) {
            r = 75 - t;
        }
        else {
            r = 75 - t;
        }

        //DEBUG(r + ", t=" + (t / 1.5));
    }
    else {
        r = 75;
    }
    return r;
});

var maxarea = d3.area()
.x(function(d, i) { return get_x(d, i) + 1; })
.y(function(d) {
    if (isNaN(parseInt(d["aussen_max"])) == false) {
        t = (parseFloat(d["aussen_max"]) / 1000) * 1.5;
        if (t < 0) {
            r = 75 - t;
        }
        else {
            r = 75 - t;
        }

        //DEBUG("area y=" + r + ", t=" + (t / 1.5));
    }
    else {
        r = 75;
    }
    return r;
})
.y1(function(d) {
    if (isNaN(parseInt(d["aussen_avg"])) == false) {
        t = (parseFloat(d["aussen_avg"]) / 1000) * 1.5;
        if (t < 0) {
            r = 75 - t;
        }
        else {
            r = 75 - t;
        }

        //DEBUG("area y1=" + r + ", t=" + (t / 1.5));
    }
    else {
        r = 75;
    }
    return r;
});

var minarea = d3.area()
.x(function(d, i) { return get_x(d, i) + 1; })
.y(function(d) {
    if (isNaN(parseInt(d["aussen_min"])) == false) {
        t = (parseFloat(d["aussen_min"]) / 1000) * 1.5;
        if (t < 0) {
            r = 75 - t;
        }
        else {
            r = 75 - t;
        }

        //DEBUG("area_min y=" + r + ", t=" + (t / 1.5));
    }
    else {
        r = 75;
    }
    return r;
})
.y1(function(d) {
    if (isNaN(parseInt(d["aussen_avg"])) == false) {
        t = (parseFloat(d["aussen_avg"]) / 1000) * 1.5;
        if (t < 0) {
            r = 75 - t;
        }
        else {
            r = 75 - t;
        }

        //DEBUG("area_min y1=" + r + ", t=" + (t / 1.5));
    }
    else {
        r = 75;
    }
    return r;
});

function update_tmsum() {
    d3.csv(tm_ep + '/tm_sum.csv', function(tmsum) {
        DEBUG(tmsum);
        //DEBUG("tmsum.length" + tmsum.length);

        tmsum_count = tmsum.length;

        // max
        d3.select("#sum").select("#tmsum").selectAll('.tsmaxarea').remove()

        var l_ts_avg = d3.select("#sum").select("#tmsum").select('g');

        l_ts_avg
        .append('path')
        .datum(tmsum)
        .classed('tsmaxarea', true)
        .attr('d', maxarea);

        // min
        d3.select("#sum").select("#tmsum").selectAll('.tsminarea').remove()

        var l_ts_avg = d3.select("#sum").select("#tmsum").select('g');

        l_ts_avg
        .append('path')
        .datum(tmsum)
        .classed('tsminarea', true)
        .attr('d', minarea);

        // avg
        d3.select("#sum").select("#tmsum").selectAll('.tsavgline').remove()

        var l_ts_avg = d3.select("#sum").select("#tmsum").select('g');

        l_ts_avg
        .append('path')
        .datum(tmsum)
        .classed('tsavgline', true)
        .attr('d', avgline);

    });
}

update_tmsum();
setInterval(update_tmsum, 600000); // every 10 minutes
