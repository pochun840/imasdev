<script>
        var chartData = <?php echo json_encode($data); ?>;
        var idTotal = <?php echo json_encode($data['id_total']); ?>;
        var chat_mode = '<?php echo $data['chat_mode'];?>';
        var check_limit_val = '<?php echo $data['check_limit_val'];?>';
        var max_count = '<?php echo $data['id_count'];?>';
        var myChart_combine = echarts.init(document.getElementById('chart_combine'));

        
        var threshold_torque_total = <?php echo json_encode($data['threshold_torque']); ?>;
        var downshift_torque_total = <?php echo json_encode($data['downshift_torque']); ?>;

        // 定義顏色調色盤
        var colorPalette = [
            '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
            '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf',
            '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
            '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf',
            '#f5b041', '#5dade2', '#a2d9ce', '#d91d3a', '#ff9c00',
            '#6c5b7b', '#c06c84', '#f67280', '#ffbe0b', '#2a9d8f',
            '#e9c46a', '#f1faee', '#264653', '#2a9d8f', '#e76f51',
            '#f9a826', '#e63946', '#f1faee', '#a8dadc', '#457b9d',
            '#1d3557', '#f1faee', '#e63946', '#f1faee', '#a8dadc',
            '#f77f00', '#d62839', '#003049', '#f1faee', '#e9c46a',
            '#2a9d8f', '#f1faee', '#264653', '#e63946', '#f1faee'
        ];

        // 解析X轴数据
        var xCoordinatesArray = chartData.chart_xcoordinates.map(x => JSON.parse(x));

        // 找到最長的 X 軸數據
        var xData = xCoordinatesArray.reduce((longest, current) => {
            return current.length > longest.length ? current : longest;
        }, []);

        // 針對最長 X 軸數據處理 Y 軸數據
        var seriesData = Array.from({ length: 25 }, (_, i) => {
            var yData = chartData[`chart${i}_ycoordinate`] ? JSON.parse(chartData[`chart${i}_ycoordinate`]) : [];
            return yData.length === xData.length ? yData : [];
        }).filter(data => data.length > 0);

        // 计算最大值和最小值
        var maxValues = [];
        var minValues = [];
        for (var i = 0; i <= max_count; i++) {
            var maxVal, minVal;
            if (chat_mode == 1) {
                maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max_correct`]);
                minVal = parseFloat(chartData[`chart${i}_ycoordinate_min_correct`]);
                threshold_torque =  parseFloat(chartData[`chart${i}_ycoordinate_threshold_torque`]);
                
                console.log(threshold_torque);
            } else if (chat_mode == 5) {
                maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max_correct`]);
                minVal = parseFloat(chartData[`chart${i}_ycoordinate_min_correct`]);
            } else {
                maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max`]);
                minVal = parseFloat(chartData[`chart${i}_ycoordinate_min`]);
            }

            maxValues.push(maxVal);
            minValues.push(minVal);
        }



        // 获取最大值和最小值
        var overallMax = Math.max(...maxValues);
        var overallMin = Math.min(...minValues);

        var markPointData = [];

        if (chat_mode == 1 && threshold_torque_total && downshift_torque_total ) {
            threshold_torque_total.split(',').forEach(function(threshold_torque) {
                threshold_torque = parseFloat(threshold_torque);

                 if (threshold_torque !== 0 && threshold_torque !== 0.0) {
                    console.log("Threshold Torque:", threshold_torque);

                    //檢查每條曲線的值，否有對應的 threshold_torque
                    for (var i = 0; i <= max_count; i++) {
                        var yData = chartData[`chart${i}_ycoordinate`] ? JSON.parse(chartData[`chart${i}_ycoordinate`]) : [];

                        var found = false;

                        //threshold_torque的範圍
                        var rangeStart = threshold_torque + 0.001; 
                        var rangeEnd = threshold_torque + 0.099; 

         

                        //精準匹配
                        for (var j = 0; j < yData.length; j++) {
                            if (Math.abs(yData[j] - threshold_torque) < 0.0001) {
                                markPointData.push({
                                    xAxis: xData[j],
                                    yAxis: yData[j],
                                    symbol: 'circle',
                                    symbolSize: 10,
                                    itemStyle: {
                                        color: 'blue'
                                    },
                                    label: {
                                        position: 'top',
                                        formatter: 'threshold_torque: ' + threshold_torque.toFixed(1)
                                    }
                                });
                                found = true;
                                break;
                            }
                        }

                        //模糊匹配
                        if (!found) {
                            for (var j = 0; j < yData.length; j++) {
                                if (yData[j] >= rangeStart && yData[j] <= rangeEnd) {
                                    markPointData.push({
                                        xAxis: xData[j],
                                        yAxis: yData[j],
                                        symbol: 'circle',
                                        symbolSize: 10,
                                        itemStyle: {
                                            color: 'blue'
                                        },
                                        label: {
                                            position: 'top',
                                            formatter: 'threshold_torque: ' + threshold_torque.toFixed(1)
                                        }
                                    });
                                    found = true;
                                    break;
                                }
                            }
                        }


                    }
                }
            });

        downshift_torque_total.split(',').forEach(function(downshift_torque) {  
            downshift_torque = parseFloat(downshift_torque);
            if (downshift_torque !== 0 && downshift_torque!== 0.0) {
                console.log("Downshift Torque:", downshift_torque);

                //檢查每條曲線的值，否有對應的 downshift_torque
                for (var i = 0; i <= max_count; i++) {
                    var yData = chartData[`chart${i}_ycoordinate`] ? JSON.parse(chartData[`chart${i}_ycoordinate`]) : [];

                    var found = false;

                    //downshift_torque的範圍
                    var rangeStart = downshift_torque + 0.001; 
                    var rangeEnd = downshift_torque + 0.099; 



                    //精準匹配
                    for (var j = 0; j < yData.length; j++) {
                        if (Math.abs(yData[j] - downshift_torque) < 0.0001) {
                            markPointData.push({
                                xAxis: xData[j],
                                yAxis: yData[j],
                                symbol: 'circle',
                                symbolSize: 10,
                                itemStyle: {
                                    color: 'blue'
                                },
                                label: {
                                    position: 'top',
                                    formatter: 'downshift_torque: ' + downshift_torque.toFixed(1)
                                }
                            });
                            found = true;
                            break;
                        }
                    }

                    //模糊匹配
                    if (!found) {
                        for (var j = 0; j < yData.length; j++) {
                            if (yData[j] >= rangeStart && yData[j] <= rangeEnd) {
                                markPointData.push({
                                    xAxis: xData[j],
                                    yAxis: yData[j],
                                    symbol: 'circle',
                                    symbolSize: 10,
                                    itemStyle: {
                                        color: 'blue'
                                    },
                                    label: {
                                        position: 'top',
                                        formatter: 'downshift_torque: ' + downshift_torque.toFixed(1)
                                    }
                                });
                                found = true;
                                break;
                            }
                        }
                    }


                }
            }
        });



    }



    var option = {
        title: {
            text: '',
            subtext: chartData.chart_combine.y_title
        },
        grid: {
            top: 50,
            bottom: 50,
            left: 50,
            right: 50
        },
        tooltip: {
            trigger: 'axis',
            position: function (pt) {
                return [pt[0], '10%'];
            },
            formatter: generateTooltipContent
        },
        legend: {
            data: idTotal.map((id, index) => `${index + 1} (${id})`)
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            name: chat_mode == 5 ? 'Angle' : 'Time(Ms)',
            nameLocation: 'end',
            nameGap: 0,
            data: xData
        },
        yAxis: {
            type: 'value',
            boundaryGap: [0, '10%'],
            min: overallMin,
            max: overallMax,
        },
        dataZoom: generateDataZoom(),
        color: colorPalette,
        series: Array.from({ length: 25 }, (_, i) => {
            if (chartData[`chart${i}_ycoordinate`]) {
                var seriesItem = {
                    name: idTotal[i] ? `${i + 1} (${idTotal[i]})` : `${i + 1}`,
                    type: 'line',
                    symbol: 'none',
                    sampling: 'max',
                    alignTicks: true,
                    lineStyle: {
                        width: 2
                    },
                    data: JSON.parse(chartData[`chart${i}_ycoordinate`]),
                    markPoint: {
                        data: markPointData
                    }
                };

    
                return seriesItem;
            }
            return null;
        }).filter(item => item !== null)
        };

        // 設置圖表選項
        myChart_combine.setOption(option);
        myChart_combine.resize({
            width: window.innerWidth * 0.8,
            height: 400,
        });
    </script>
    
    //修改 如果 該條曲線 隱藏 那  downshift_torque的圓點 及  threshold_torque的圓點 也要隱藏