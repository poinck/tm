function parseRow(row) {

	// fix non-standard date format
	var crippledDate = row.datum.split(' ')
	var fixedDate = crippledDate[0] + 'T' + crippledDate[1]

	return {
		date: new Date(fixedDate),
		outside: parseFloat(row.aussen) / 1000,
		inside: parseFloat(row.innen) / 1000
	}
}

function generateGraph() {

	d3.csv('../tm_720.csv', parseRow, function(parsedData) {
		// console.log(parsedData)

		MG.data_graphic({
			title: "Aussentemperaturen",
			data: parsedData,
			width: 500,
			height: 250,
			target: ".outside",
			// baselines: [{value: 0}],
			x_accessor: "date",
			y_accessor: "outside",
			area: false,
			missing_is_hidden: true,
			y_extended_ticks: true,
			interpolate: "monotone"
		});

		MG.data_graphic({
			title: "Innentemperaturen",
			data: parsedData,
			width: 500,
			height: 250,
			target: ".inside",
			// baselines: [{value: 0}],
			x_accessor: "date",
			y_accessor: 'inside',
			area: false,
			missing_is_hidden: true,
			y_extended_ticks: true,
			interpolate: "monotone"
		});

	})
}

function init() {

	generateGraph()

	// update every second
	setInterval(generateGraph, 60000);

}

window.onload = init
