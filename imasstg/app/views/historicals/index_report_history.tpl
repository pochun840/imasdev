<?php date_default_timezone_set('Asia/Taipei');?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="<?php echo URLROOT; ?>css/print-history-excel.css?v=202405131030">
<link rel="stylesheet" type="text/css" href="<?php echo URLROOT; ?>css/datatables.min.css">



<script src="<?php echo URLROOT; ?>js/echarts.min.js"></script>
<script src="<?php echo URLROOT; ?>js/historical.js?v=202405021000"></script>

</head>

<body>
    
    <div class="excel-sheet" id='excelsheet'>
        <header class="border-bottom">
            <h2><img src="../public/img/logo.jpg" alt="Logo"></h2>
            <p  style="font-weight: bold; font-size: 34px; padding-bottom: 5px">Fastening Statistics Report</p>
        </header>

        <div style="padding-top: 10px;">
            <table class="table table-bordered" style="">
                <tr>
                    <td colspan="4" style="text-align: left; padding-left: 5.7%"> Report Time :<?php echo date("Y-m-d H:i:s");?></td>
                </tr>
                <tr>
                    <td>Screw drivers : 3</td>
                    <td>Program : 3</td>
                    <td>Sample quantity : 65</td>
                    <td>Operator : <?php echo $_SESSION['user']; ?></td>
                </tr>
                <tr>
                    <td>Station : station1</td>
                    <td>Job quantity: 20</td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
        </div>
        <label style="font-weight: bold">Lock Status Statistics</label> 
        
        <!--<label style="font-weight: bold; margin-left: 50%">Fastening Status</label>-->
        <div style="padding-bottom: 20px">
    
            <div  align='center' id="lineChart" style="width: 950px;height:400px;"></div>
            <div  align='center' id="fastening_status_chart" style="width: 40%; height: 400px;"></div>
        </div>
        <hr>
        <label style="font-weight: bold">Screw Time</label> 
        <div style="padding-bottom: 20px">
            
            <div  align='center' id="main" style="width: 60%;height:400px;"></div>
            <div  align='center' id="jobtime" style="width: 40%;height:400px;"></div>
        </div>
        <hr>
        <!--<label style="font-weight: bold">Station Time</label>
        <div style="padding-bottom: 20px">
            <img src="img/station-time.png" width="70%" height="200" alt="">
        </div>-->
        
        
        <div style="padding-bottom: 40px">
            <div id="chart" style="width: 600px; height: 400px;"></div>
        </div>
        <hr>
        <!--<label style="font-weight: bold">NG Error v.s Operator</label>
        <div style="padding-bottom: 20px">
            <img src="img/NG v.s Operator.png" width="60%" height="200" alt="">
        </div>-->
    </div>
</body>
</html>
<script>
    var ng_reason = <?php echo $data['ng_reason_json']; ?>;
    var myChart = echarts.init(document.getElementById('chart'));
    var option = {
        title: {
            text: 'NG Reason',
            top: 'top', // 調整標題的位置到最上方
            left: 'center'
            
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c} ({d}%)'
        },
        /*legend: {
            orient: 'vertical',
            left: 'left',
            top: 'bottom',
            data: ng_reason.map(function(item) { return item.name; })
        },*/
        series: [
            {
                name: 'Error Type',
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: ng_reason,
                animationType: 'scale', 
                animationEasing: 'elasticOut' 
            }
        ]
    };
    myChart.setOption(option);

    var job_time = <?php echo $data['job_time_json']; ?>;
    var jobtimeChart = echarts.init(document.getElementById('jobtime'));
      var option = {
        title: {
            text: 'JOB VS TIME',
            left: 'center'
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c} ({d}%)'
        },
        legend: {
            orient: 'vertical',
            left: 'left',
            data: job_time.map(function(item) { return item.name; })
        },
        series: [
            {
                name: 'Time Required',
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: job_time,
                animationType: 'scale', 
                animationEasing: 'elasticOut' 
            }
        ]
    };
    jobtimeChart.setOption(option);



    var fastening_status =<?php echo $data['fastening_status']; ?>;
       var colors = ['#FFCC00', '#99CC66', '#E60000', '#FFCC00'];
    var fChart = echarts.init(document.getElementById('fastening_status_chart'));
    var option = {
        title: {
            text: 'fastening_status',
            left: 'center'
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c} ({d}%)'
        },
        /*legend: {
            orient: 'vertical',
            left: 'left',
            top: 'bottom',
            data: fastening_status.map(function(item) { return item.name; })
        },*/
        /*series: [
            {
                name: 'Status',
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: fastening_status,
                animationType: 'scale', 
                animationEasing: 'elasticOut' 
            }
        ]*/
        series: [
            {
                name: 'Status',
                type: 'pie',
                radius: '55%',
                center: ['50%', '60%'],
                data: fastening_status,
                itemStyle: {
                    color: function(params) {
                        // Assign colors to pie chart slices based on the index
                        return colors[params.dataIndex % colors.length];
                    }
                },
                animationType: 'scale',
                animationEasing: 'elasticOut'
            }
        ]
    };
    fChart.setOption(option);

    var maimchart = echarts.init(document.getElementById('main'));
    var job_name  =<?php echo $data['job_info']['job_name']; ?>;
    var fasten_time  =<?php echo $data['job_info']['fasten_time']; ?>;

    var option = {
        tooltip: {
            trigger:'axis',
            formatter: '{b0}({a0}): {c0}'
        },
        legend: {
            data:['']
        },
        xAxis: {
            data: job_name
        },
        yAxis: [ {
            type: 'value',
            name: '毫秒',
            show:true,
            interval: 10,
            axisLine: {
                lineStyle: {
                    color: '#5e859e',
                    width: 2
                }
            }
        },{
            type: 'value',
            name: '',
            //min: 0,
            //max: 100,
            interval: 10,
            axisLabel: {
                //formatter: '{value} %'
            },
            axisLine: {
                lineStyle: {
                    color: '#5e859e',
                    width: 2
                }
            }
        }],
        series: [{
            name: '毫秒',
            type: 'bar',
            barWidth : '50%',
            data: fasten_time
        }]
    };

    maimchart.setOption(option);

    var lineChart = echarts.init(document.getElementById('lineChart'));

    var line_title =<?php echo $data['statistics']['date'];?>;
    var line_ng =<?php echo $data['statistics']['ng'];?>;
    var line_ok =<?php echo $data['statistics']['ok'];?>;
    var line_okall =<?php echo $data['statistics']['ok_all'];?>;

        // ECharts 的配置選項
        var options = {
            title: {
                text: ''
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data:['', '', '']
            },
            xAxis: {
                type: 'category',
                data: line_title
            },
            yAxis: {
                type: 'value'
            },
            series: [
                {
                    name: 'OK',
                    type: 'line',
                    data: line_ok,
                    itemStyle: {
                        color: 'green' 
                    }   
                },
                {
                    name: 'NG',
                    type: 'line',
                    data: line_ng,
                    itemStyle: {
                        color: '#F44336' 
                    }   
                },
                {
                    name: 'OKALL',
                    type: 'line',
                    data: line_okall,
                     itemStyle: {
                        color: '#FFCC00' 
                    }   
                }
            ]
        };

    lineChart.setOption(options);

  
    
</script>

<script>
if ("<?php echo $data['type']; ?>" == "download") {

        var today = new Date();
        var day = String(today.getDate()).padStart(2, '0');
        var month = String(today.getMonth() + 1).padStart(2, '0'); 
        var year = today.getFullYear();

        today = year + month + day;

        document.getElementById('fastening_status_chart').style.marginLeft = "auto";
        document.getElementById('fastening_status_chart').style.marginRight = "auto";

        document.getElementById('main').style.marginLeft = "auto";
        document.getElementById('main').style.marginRight = "auto";

        document.getElementById('jobtime').style.marginLeft  = "auto";
        document.getElementById('jobtime').style.marginRight = "auto";

        document.getElementById('chart').style.marginLeft  = "auto";
        document.getElementById('chart').style.marginRight = "auto";

    
        var images = document.getElementsByTagName('img');
        var baseUrl = window.location.origin;

        var imagesHTML = Array.from(images)
            .map(image => {
                var src = image.src.startsWith(baseUrl) ? image.src : baseUrl + image.src;
                return `<img src="${src}" alt="${image.alt}">`;
            })
            .join('\n');
            


        var stylesheets = document.getElementsByTagName('link');
        var cssString = Array.from(stylesheets)
            .map(stylesheet => `<link rel="stylesheet" href="${stylesheet.href}">`)
            .join('\n');
        var newContent = ["<head>"];

        Array.from(stylesheets).forEach(function(stylesheet) {
            newContent.push(`<link rel="stylesheet" href="${stylesheet.href}">`);
        });

        newContent.push("</head><body>");
        newContent.push(document.documentElement.innerHTML);

        newContent.push("</body>");
        var blob = new Blob([newContent.join('\n')], { type: 'text/html' });
        var link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = 'history_chart_' + today + '.html';
        link.click();

        //localStorage.setItem('downloaded', 'true');
}
</script>


<style>
    #jobtime{
        width: 40%;
        height: 400px;
        margin: 0 auto; 
    }

    #main{
        width: 60%;
        height: 400px;
        margin: 0 auto; 
    }

    #fastening_status_chart{
        width: 40%;
        height: 400px;
        margin: 0 auto; 
    }

    #chart{
        width: 600px;
        height: 400px;
        margin: 0 auto; 
    }
</style>