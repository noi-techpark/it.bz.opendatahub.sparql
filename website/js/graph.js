// SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>
//
// SPDX-License-Identifier: AGPL-3.0-or-later

function handleGraph(temperatureData, bolzanoTemp) {
    const onIntervals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    //                -30-25-20-15-10-5 - 0-5-10 -15-20-25-30
    // frequency of temperatures inside intervals starting from lower than -30, to [-30, -25] to ....

    let sum = 0;
    temperatureData.forEach(element => {
        sum += element;
        // this is so that [-35, -30] returns 0, for index 0
        const mdl = parseInt(element/5)+6;
        onIntervals[mdl] += 1;
    });
    const averageTemp = sum / temperatureData.length;
    // const bolzanoTemp = 16.724;
    const averagePosition = (parseInt(averageTemp) + 30) / 5; // this is the position of the line in the graph
    // the position is the index of where the line is on the X axis, remember we have 12 labels, or 12 indexes
    const bolzanoPosition = (parseInt(bolzanoTemp) + 30) / 5;




    // setup block
    const data = {
    labels: ['-30°C', '-25°C', '-20°C', '-15°C', '-10°C', '-5°C', '0°C', '5°C', '10°C', '15°C', '20°C', '25°C', '30°C', '35°C', '40°C'],
    datasets: [{
        label: 'Frequency',
		font: 'Open Sans, sans-serif',
        data: onIntervals,
        // backgroundColor: 'rgba(193, 110, 112, 0.8)',   // line color
        // borderColor: 'rgba(193, 110, 112, 0.8)',
        backgroundColor: 'rgba(0,0,0, 0.3)',
        borderColor: 'rgba(0,0,0, 0.3)',
        tension: 1,
        pointRadius: 5,
        pointBorderWidth: 2,
        pointBorderColor: 'white',
    }]
    };

    //arbitraryLine plugin
    const arbitraryLine = {
        id: 'arbitraryLine',
        beforeDraw(chart, args, options){
            const {
                ctx,
                chartArea: { top, right, bottom, left, width, height },
                scales: {x, y}
            } = chart;
            ctx.save();

            //line 1
            const xWidth = 3
            ctx.fillStyle = options.arbitraryLineColor1;
            ctx.fillRect(x.getPixelForValue(options.LineXPosition1) - (xWidth / 2), top, xWidth, height);
            //line 2
            // const xWidth = 3
            ctx.fillStyle = options.arbitraryLineColor2;
            ctx.fillRect(x.getPixelForValue(options.LineXPosition2) - (xWidth / 2), top, xWidth, height);

            //text 1
            ctx.font = `${options.textSize1}px Open Sans, sans-serif`;
            ctx.fillStyle = options.arbitraryLineColor1;
            ctx.fillText(options.text1, x.getPixelForValue(options.textXIndex) + 5, options.textY1);
            //text 2
            ctx.font = `${options.textSize2}px Open Sans, sans-serif`;
            ctx.fillStyle = options.arbitraryLineColor2;
            ctx.fillText(options.text2, x.getPixelForValue(options.textXIndex) + 5, options.textY2);
            // ctx.textAlign = 'center';

            ctx.restore();
        }
    };

    // config block
    const config = {
        type: 'bar',
        // type: 'line',
        data: data,
        options: {
            scales: {
            y: {
                beginAtZero: true
            }
            },
            plugins: {
            legend: {
                // position: 'left',
            },
            title: {
                display: true,
                text: 'How warm is it right now in South Tyrol?',
				font: 'Open Sans, sans-serif'
            },
            arbitraryLine: {
                arbitraryLineColor1: 'red',
                LineXPosition1: bolzanoPosition, // data index
                text1: 'Bolzano Temperature: ' + Math.round(bolzanoTemp * 10) / 10,
                textY1: 100,
                textSize1: 17,

                arbitraryLineColor2: 'green',
                LineXPosition2: averagePosition, // data index
                text2: 'Mean Temperature: ' + Math.round(averageTemp * 10) / 10, //round one decimal
                textY2: 120,
                textSize2: 17,

                textXIndex: 0,
            },
            }
        },
        plugins: [arbitraryLine]
    };

    // render / init block
    const myChart = new Chart(
        document.getElementById('myChart'),//.getContext('2d'),
        config
    );


}
