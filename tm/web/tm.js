/**
 * main javascript for temperature graphs
 * - uses tmconfig.js
 *
 * test on resolution: 725×480 (for official Raspberry Pi display with
 * place for side panel)
 */

var tmsum_count = 272;

/**
 * d:   current datum (not d["datum"] or not d.datum)
 * i:   current index
 */
function get_x(d, i) {
    return i - tmsum_count + 272;
}

/**
 * v:   e.g.: d["aussen_max"] or d.aussen_max
 */
function get_y(v) {
    let r = 75;
    if (isNaN(parseInt(v)) == false) {
        let t = (parseFloat(v) / 1000) * 1.5;
        r = 75 - t;

        //DEBUG(r + ", t=" + (t / 1.5));
    }
    return r;
}

var avgline = d3.line()
.x( get_x )  // d and i will be appended as arguments
.y( (d) => get_y(d.aussen_avg) );  // from d use d.aussen_avg as argument

var maxarea = d3.area()
.x( get_x )
.y( (d) => get_y(d.aussen_max) )
.y1( (d) => get_y(d.aussen_avg) );

var minarea = d3.area()
.x( get_x )
.y( (d) => get_y(d.aussen_min) )
.y1( (d) => get_y(d.aussen_avg) );

function update_tmsum() {
    d3.csv(tm_ep + '/tm_sum.csv', function(tmsum) {
        //DEBUG(tmsum);
        //
        tmsum_count = tmsum.length;
        DEBUG("tmsum_count = " + tmsum_count);

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

function get_t_x(d, i) {
    return i / 1440 * 116;
}

var tline = d3.line()
.x( get_t_x )
.y( (d) => get_y(d.aussen) );

var tarea = d3.area()
.x( get_t_x )
.y( (d) => get_y(d.aussen) )
.y1( 75 );

function update_tmtoday() {
    let timeformat = d3.timeFormat("%Y-%m-%d");
    let d = new Date();
    let n = timeformat(d);

    DEBUG("today is " + n)

    d3.csv(tm_ep + '/tm_' + n + '.csv', function(tmtoday) {
        //DEBUG(tmtoday);

        tmtoday_count = tmtoday.length;
        DEBUG("tmtoday_count = " + tmtoday_count);

        // area
        d3.select("#today").select("#tmtoday").selectAll('.ttarea').remove()

        let a_t_today = d3.select("#today").select("#tmtoday").select('g');

        a_t_today
        .append('path')
        .datum(tmtoday)
        .classed('ttarea', true)
        .attr('d', tarea);

        // area
        d3.select("#today").select("#tmtoday").selectAll('.ttline').remove()

        let l_t_today = d3.select("#today").select("#tmtoday").select('g');

        l_t_today
        .append('path')
        .datum(tmtoday)
        .classed('ttline', true)
        .attr('d', tline);
    });
}


update_tmsum();
setInterval(update_tmsum, 600000); // every 10 minutes
update_tmtoday();
setInterval(update_tmtoday, 600000);

