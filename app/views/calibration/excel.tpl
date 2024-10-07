
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="../public/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="60x60" href="../public/img/icon.svg">
    <link rel="icon" sizes="192x192" href="../public/img/icon.svg>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="<?php echo URLROOT; ?>css/print-styles.css">
    <link rel="stylesheet" type="text/css" href="<?php echo URLROOT; ?>css/datatables.min.css">
    <script src="<?php echo URLROOT;?>js/echarts.min.js"></script>

    <title><?php echo SITENAME; ?></title>
    <style>
        .t2 {
            font-size: 14px;
            margin: 0px 0px;
            height: 25px;
            width: 60%
        }

    </style>
</head>

<body>

    <div class="excel-sheet">
        <header class="border-bottom">
            <h2><img src="../public/img/logo.jpg" alt="Logo"></h2>
            <p style="font-weight: bold; font-size: 34px; padding-bottom: 5px">Certificate of Calibration</p>
            <p>Kilews Industrial Co., Ltd.</p>
            <p>No. 30, Lane 83, Hwa Cheng Rd., Hsin Chuang Dist., New Taipei City, Taiwan, R.O.C</p>
            <p>Tel: +886-2-2997-1912 &nbsp;&nbsp;&nbsp; Fax: +886-2-2996-9023</p>
        </header>

        <div style="font-size: 14px; padding-bottom: 10px; padding-top: 10px">
            <label for="Tool-SN" style="width: 24%">Tool model : <?php echo $data['tools_sn'];?></label>
            <label for="Serial-Number" style="width: 24%">Serial Number : TPS192865</label>
            <label for="Target-Torque" style="width: 27%">Target Torque : <?php echo $data['meter']['avg_torque'];?> (N.m)</label>
            <label for="RPM" style="width: 11%">RPM : 100</label>
        </div>

        <div style="font-size: 14px; padding-bottom: 10px;">
            <label for="Upper-Limit" style="width: 24%">Upper Limit : 0.54</label>
            <label for="Lower-Limit" style="width: 24%">Lower Limit : 0.66</label>
            <label for="Tolerance" style="width: 27%">Tolerance +/-% : 10%</label>
            <label for="Offset" style="width: 16%">Offset : +0.5</label>
        </div>

        <div style="font-size: 14px; padding-bottom: 10px; width: 100%">
            <label for="Std-dev-s" style="width: 24%">Std dev s(Cv) : 0.18%</label>
            <label for="Lower-Limit-B" style="width: 24%">3 Std dev s : 0.55%</label>
            <label for="Cm" style="width: 27%">Cm : 16.83</label>
            <label for="CmK">Cmk : 3.93</label>
        </div>

        <div class="container-table">
            <div class="column column-left">
                <table class="table-bordered">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Torque</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php for ($i = 1; $i <= $data['count']; $i++) { ?>
                            <tr>
                                <td><?php echo $i; ?></td>
                                <td><?php echo $data['meter']['res_total'][$i - 1]['torque']; ?></td>
                            </tr>
                        <?php } ?>

                    </tbody>
                </table>
            </div>

            <div class="column column-right">

                <div id="mychart" style="width: 600px; height: 300px"></div>

                <div id="">
                    <table class="table-bordered">
                        <thead>
                            <tr>
                                <th>Test Result</th>
                                <th>Meter</th>
                            </tr>
                        </thead>
                        <tbody class="tbody-text">
                            <tr>
                                <td>Max</td>
                                <td style="word-spacing: 50px"><?php echo $data['meter']['max_torque']; ?> (N.m)</td>
                            </tr>
                            <tr>
                                <td>Min</td>
                                <td style="word-spacing: 50px"><?php echo $data['meter']['min_torque']; ?> (N.m)</td>
                            </tr>
                            <tr>
                                <td>Mean</td>
                                <td style="word-spacing: 50px"><?php echo $data['meter']['avg_torque']; ?> (N.m)</td>
                            </tr>
                            <tr>
                                <td>Std Dev s (Cv)</td>
                                <td><?php echo $data['meter']['stddev1']; ?></td>
                            </tr>
                            <tr style="background-color: #FFFF5C">
                                <td>3 Std dev s</td>
                                <td><?php echo $data['meter']['stddev3']; ?></td>
                            </tr>
                            <tr>
                                <td>Deviation</td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Range</td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Cm</td>
                                <td><?php echo $data['meter']['cm']; ?></td>
                            </tr>
                            <tr style="background-color: #FFFF5C">
                                <td>CmK</td>
                                <td><?php echo $data['meter']['cmk']; ?></td>
                            </tr>
                            <tr>
                                <td>Positive Tolerance</td>
                                <td>0%</td>
                            </tr>
                            <tr>
                                <td>Negative Tolerance</td>
                                <td>0%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div>
            <span style="padding-left: 3%">Tested by :</span> <span style="padding-left: 40%">Approved by :</span>
        </div>
    </div>
</body>

</html>
<?php date_default_timezone_set('Asia/Taipei');?>
<script>
     var myChart = echarts.init(document.getElementById('mychart'));

    var x_val = <?php echo $data['echart']['x_val']; ?>;
    var y_val = <?php echo $data['echart']['y_val']; ?>;

    var option = {
        title: {
            text: ''
        },
        tooltip: {
            trigger: 'axis'
        },
        xAxis: {
            type: 'category',
            name: 'Count',
            data: x_val,
        },
        yAxis: {
            type: 'value',
            name: 'Torque',
        },
        //dataZoom: generateDataZoom(),
        series: [{
            name: 'Torque',
            type: 'line',
            symbol: 'none',
            sampling: 'average',
            lineStyle: {
                width: 0.75
            },
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


            data: y_val,
        }]
    };

    myChart.setOption(option);
 

    

</script>
<script>
if ("<?php echo $data['type']; ?>" == "download") {

        var today = new Date();
        var day = String(today.getDate()).padStart(2, '0');
        var month = String(today.getMonth() + 1).padStart(2, '0'); 
        var year = today.getFullYear();

        today = year + month + day;
        
        document.getElementById('mychart').style.marginLeft  = "auto";
        document.getElementById('mychart').style.marginRight = "auto";

    
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
        link.download = 'calibrations_chart_' + today + '.html';
        link.click();

}
</script>
