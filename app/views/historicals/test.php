if (chat_mode == 1 && threshold_torque_total) {
    threshold_torque_total.split(',').forEach(function(threshold_torque) {
        threshold_torque = parseFloat(threshold_torque);

        if (threshold_torque !== 0 && threshold_torque !== 0.0) {
            console.log("Threshold Torque:", threshold_torque);

            // 遍歷每條曲線數據，檢查是否有對應的 threshold_torque
            for (var i = 0; i <= max_count; i++) {
                var yData = chartData[`chart${i}_ycoordinate`] ? JSON.parse(chartData[`chart${i}_ycoordinate`]) : [];

                var found = false;
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
                                formatter: 'threshold_torque: ' + threshold_torque.toFixed(4)
                            }
                        });
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    if (threshold_torque >= 0.500 && threshold_torque <= 0.599) {
                        for (var j = 0; j < yData.length; j++) {
                            if (Math.abs(yData[j] - 0.5) < 0.0001) { // 以0.5為範圍中心
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
                                        formatter: 'threshold_torque: ' + threshold_torque.toFixed(4)
                                    }
                                });
                                found = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
    });
}
如果  threshold_torque = 0.5  要怎麼改

        