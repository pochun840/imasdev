<?php if ($path == "nextinfo" && isset($data['chart_info']['chat_mode']) && $data['chart_info']['chat_mode'] != "6") { ?>
<script>

    
    var myChart = echarts.init(document.getElementById('chartinfo'));

    var x_data_val = <?php echo  $data['chart_info']['x_val']; ?>;
    var y_data_val = <?php echo  $data['chart_info']['y_val']; ?>;

    var min_val = <?php echo  $data['chat_y_min_val'];?>;
    var max_val = <?php echo  $data['chat_y_max_val'];?>;

    var x_title = '<?php echo $data['chart_info']['x_title'];?>';
    var y_title = '<?php echo $data['chart_info']['y_title'];?>';

    var chat_mode = '<?php echo $data['chart_info']['chat_mode'];?>';
    var step_prr_rpm   = '<?php echo $data['job_info'][0]['step_prr_rpm'];?>';
    var step_prr_angle = '<?php echo $data['job_info'][0]['step_prr_angle'];?>';
    var step_threshold_angle = '<?php echo $data['job_info'][0]['step_threshold_angle'];?>';
    var downshift_torque = '<?php echo $data['job_info'][0]['downshift_torque'];?>';
    var threshold_torque = '<?php echo $data['job_info'][0]['threshold_torque'];?>';

    

    var option = {
            
            grid: GridConfig.generate('90%', '70%', '3%', '20%'),
            tooltip: {
                trigger: 'axis',
                position: function (pt) {
                    return [pt[0], '10%'];
                },
                formatter: function (params) {
                    var state = '<span style="color: red;">' + y_title + '</span>';
                    var value = '<span style="color: red;">' + params[0].value + '</span>';
                    return state + ': ' + value; 
                },
                
            },
            title: {left: 'center',text: '',},
            xAxis: {
                type: 'category',
                boundaryGap: true,
                name: x_title,
                data: x_data_val
            },
            yAxis: {
                type: 'value',
                name: y_title,
                boundaryGap: [0, '10%'],
                ...(chat_mode == 1 || chat_mode == 5 ? { max: max_val } : {})
            },
        dataZoom: generateDataZoom(),
        series: [
            {
                name:'',
                type:'line',
                symbol: 'none',
                sampling: 'average',
                
                itemStyle: {
                    normal: {
                        color: 'rgb(255,0,0)'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 0, [{
                            offset: 0,
                            color: 'rgb(255,255,255)'
                        }, {
                            offset: 0,
                            color: 'rgb(255,255,255)'
                        }])
                    }
                },
                lineStyle: {width: 0.75},
                data: y_data_val
            }
        ]
    };

    
      // 尋牙角度(for chat_mode == 2)
    if (chat_mode == '2' && ( step_threshold_angle != '0') ) {
      

        // 如果 step_threshold_angle 不等於 '0'
        if (step_threshold_angle != '0') {
            if (y_data_val.includes(step_threshold_angle.toString())) {
                var index = y_data_val.indexOf(step_threshold_angle.toString());
                var x_value = x_data_val[index];  // 获取对应的 x 轴值

                option.series[0].markPoint = option.series[0].markPoint || { data: [] };
                option.series[0].markPoint.data.push({
                    xAxis: x_value,  
                    yAxis: step_threshold_angle,  
                    symbol: 'circle',
                    symbolSize: 10,
                    itemStyle: {
                        color: 'red'  
                    },
                    label: {
                        position: 'top',
                        formatter: 'Step Threshold Angle: ' + step_threshold_angle
                    }
                });
            }
        }
    }

    //step_prr_rpm
    if ((chat_mode == '1') && (step_prr_rpm != '0' || step_prr_angle != '0')) {
        
        //檢查 y_data_val = 0的 都要隱藏
        for (var i = 0; i < y_data_val.length; i++) {
            if (y_data_val[i] == 0) {
                y_data_val[i] = null; 
            }
        }
        option.series[0].data = y_data_val;
        myChart.setOption(option);
    }

    
  
    if ((chat_mode == '1') && (downshift_torque != '0' || threshold_torque != '0')) {
 
        if (parseFloat(downshift_torque) !== 0) {

                var downshift_torque_num = parseFloat(downshift_torque);
                for (var i = 0; i < y_data_val.length; i++) {
                    var y_val = parseFloat(y_data_val[i]); 
                    if (y_val >= downshift_torque_num && y_val < downshift_torque_num + 0.1) {
                        var x_value = x_data_val[i]; 

                        option.series[0].markPoint = option.series[0].markPoint || { data: [] };
                        option.series[0].markPoint.data.push({
                            xAxis: x_value,
                            yAxis: y_val,  
                            symbol: 'circle',
                            symbolSize: 10,
                            itemStyle: {
                                color: 'red'
                            },
                            label: {
                                position: 'top',
                                formatter: 'downshift_torque : ' + downshift_torque
                            }
                        });
                        break;
                    }
                }
            }

            if (parseFloat(threshold_torque) != '0') {
                var threshold_torque_num = parseFloat(threshold_torque);
                for (var i = 0; i < y_data_val.length; i++) {
                    var y_val = parseFloat(y_data_val[i]);

                    if (y_val >= threshold_torque_num && y_val < threshold_torque_num + 0.1) {
                        var x_value = x_data_val[i];  
                        option.series[0].markPoint = option.series[0].markPoint || { data: [] };
                        option.series[0].markPoint.data.push({
                            xAxis: x_value,
                            yAxis: y_val,
                            symbol: 'circle',
                            symbolSize: 10,
                            itemStyle: {
                                color: 'blue'  
                            },
                            label: {
                                position: 'top',
                                formatter: 'threshold_torque : ' + threshold_torque
                            }
                        });
                        break;
                    }
                }
            }
    }

    // 尋找並顯示 step_threshold_angle（如果在 chat_mode == '5'）
    if (chat_mode == '5') {
        var step_threshold_angle_num = parseFloat(step_threshold_angle);


        // 如果 x_data_val 中有與 step_threshold_angle 相等的值，則找到對應的 X 軸位置
        if (x_data_val.includes(step_threshold_angle_num.toString())) {
            var index = x_data_val.indexOf(step_threshold_angle_num.toString());
            var x_value = x_data_val[index];

            // 確保 markLine 存在，如果不存在則初始化
            option.series[0].markLine = option.series[0].markLine || { data: [] };

            // 隱藏虛線
            option.series[0].markLine.data.push({
                xAxis: x_value,  // 在 X 軸上標註 step_threshold_angle 值
                name: 'Step Threshold Angle',
                symbol: 'none',  // 确保移除箭头
                symbolSize: 0,    // 确保没有箭头
                clip: true,
                lineStyle: {
                    type: 'dashed',  // 虚线
                    color: 'green',   // 绿色
                    width: 0.75,         // 线宽
                    opacity: 0    
                },
                label: {
                    //position: 'start',  // 标签位置
                    //formatter: 'threshold_angle: ' + step_threshold_angle
                },

                show: true  
            });

            option.series[0].markPoint = option.series[0].markPoint || { data: [] };
            option.series[0].markPoint.data.push({
                xAxis: x_value,  
                yAxis: threshold_torque,  // 对应的 Y 轴值
                symbol: 'circle',  // 圆点标注
                symbolSize: 8,  // 圆点的大小
                itemStyle: {
                    color: 'pink'  
                },
                label: {
                    position: 'top',  // 圆点标签位置
                    formatter: 'threshold_angle:' + step_threshold_angle
                }
            });

           
        }
    }



    
    //如果 limit_val=1 曲線圖 要顯示上下限 min_val 及 max_val
    if ((x_title === "Time(MS)" && (y_title === "Power" || y_title === "RPM")) ||chat_mode == 2) {
        document.cookie = "limit_val=" + limit_val + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
        var limit_val = 0;
    }
    
    if ( limit_val == 1) {
        
        if(x_title  == "Time(MS)" && y_title =="Angle"){
            var t1 = 'low angle';
            var t2 = 'high angle';
        }else{
            var t1 = 'low torque';
            var t2 = 'high torque';
        }

        option.series[0].markLine = {
            data: [
                {yAxis: min_val, name: '',label: {position: 'middle',formatter: t1}}, 
                {yAxis: max_val, name: '',label: {position: 'middle',formatter: t2}}  
            ],
            symbol: 'none',
            lineStyle: {
            } 
        };
    }
    myChart.setOption(option);
    myChart.resize({
      width: window.innerWidth*0.8,
      height: 400,
    });


</script>
<?php } ?>

針對這段 修改
if ((chat_mode == '1') && (step_prr_rpm != '0' || step_prr_angle != '0')) {
    
    //檢查 y_data_val = 0的 都要隱藏
    for (var i = 0; i < y_data_val.length; i++) {
        if (y_data_val[i] == 0) {
            y_data_val[i] = null; 
        }
    }
    option.series[0].data = y_data_val;
    myChart.setOption(option);

    如果 某一段 前後都被隱藏 那中間那段也需要
}
