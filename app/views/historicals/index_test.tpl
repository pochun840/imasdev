<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ECharts Example</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; }
        #chart_combine { width: 80%; height: 500px; margin: 0 auto; }
    </style>
</head>
<body>
    <div id="chart_combine"></div>

<script>
    

    function generateDataZoom() {
        return [
            {
                type: 'inside',
                start: 0,
                end: 100
            },
            {
                show: false,
                type: 'slider',
                start: 0,
                end: 100,
                handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                handleSize: '80%',
                handleStyle: {
                    color: '#fff',
                    shadowBlur: 3,
                    shadowColor: 'rgba(0, 0, 0, 0)',
                    shadowOffsetX: 0,
                    shadowOffsetY: 0
                }
            }
        ];
    }


    var chartData_s = <?php echo json_encode($data); ?>;
    var chat_mode = '<?php echo $data['chat_mode'];?>';

    // Sample data
   

    var myChart_combine = echarts.init(document.getElementById('chart_combine'));

    var colorPalette = [
        '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
        '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'
    ];
    var max_count = '<?php echo $data['id_count'];?>';


    var xCoordinatesArray = chartData_s.chart_xcoordinates.map(x => JSON.parse(x));
    var xData_s = xCoordinatesArray.reduce((longest, current) => {
        return current.length > longest.length ? current : longest;
    }, []);
    
    var seriesData = [];
    var colorIndex = 0;

    for (var i = 0; i <= max_count; i++) {
        var torqueKey = `chart${i}_ycoordinate`;
        var angleKey = `chart${i}_ycoordinate_angle`;

        
        var torqueData1 = chartData_s[torqueKey] ? JSON.parse(chartData_s[torqueKey]) : [];
        var angleData1 = chartData_s[angleKey] ? JSON.parse(chartData_s[angleKey]) : [];

        if (torqueData1.length > 0) {
            seriesData.push({
                name: `Torque ${i}`,
                type: 'line',
                symbol: 'none',
                sampling: 'max',
                alignTicks: true,
                lineStyle: {
                    width: 0.75
                },
                data: torqueData1,
                yAxisIndex: 0,
                color: colorPalette[colorIndex % colorPalette.length]
            });
            colorIndex++;
        }

        if (angleData1.length > 0) {
            seriesData.push({
                name: `Angle ${i}`,
                type: 'line',
                symbol: 'none',
                sampling: 'max',
                alignTicks: true,
                lineStyle: {
                    width: 0.75
                },
                data: angleData1,
                yAxisIndex: 1,
                color: colorPalette[colorIndex % colorPalette.length]
            });
            colorIndex++;
        }
    }

    var option = {
        title: {
            text: '',
            subtext: '',
        },
        tooltip: {
            trigger: 'axis',
            formatter: function (params) {
                return params.map(function (item) {
                    return item.seriesName + ': ' + item.value;
                }).join('<br>');
            }
        },
        legend: {
            data: seriesData.map(series => series.name)
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            name: chat_mode == 6 ? 'Angle' : 'Time',
            nameLocation: 'end',
            nameGap: 30,
            data: xData_s
        },
        yAxis: [
            {
                type: 'value',
                name: 'Torque',
                position: 'left',
                axisLabel: { 
                    formatter: '{value}'
                },
                axisLine: {
                    lineStyle: {
                        color: '#333'
                    }
                }
            },
            {
                type: 'value',
                name: 'Angle',
                position: 'right',
                axisLabel: { 
                    formatter: '{value}' 
                },
                axisLine: {
                    lineStyle: {
                        color: '#333' 
                    }
                }
            }
        ],
        dataZoom: generateDataZoom(),
        color: colorPalette,
        series: seriesData
    };

    myChart_combine.setOption(option);

    // Resize chart on window resize
    window.addEventListener('resize', function() {
        myChart_combine.resize();
    });


</script>
</body>
</html>
