
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="../public/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="60x60" href="../public/img/icon.svg">
    <link rel="icon" sizes="192x192" href="../public/img/icon.svg>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/print-styles.css">
    <link rel="stylesheet" type="text/css" href="css/datatables.min.css">
    <script src="js/echarts.min.js"></script>
    <script src="js/jszip.min.js"></script>
    <script src="js/FileSaver.min.js"></script>



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
            <?php $base_url = "../public/img/logo.jpg"; ?>
            <h2><img src="<?php echo $base_url; ?>" alt="Logo"></h2>
            <p style="font-weight: bold; font-size: 34px; padding-bottom: 5px">Certificate of Calibration</p>
            <p>Kilews Industrial Co., Ltd.</p>
            <p>No. 30, Lane 83, Hwa Cheng Rd., Hsin Chuang Dist., New Taipei City, Taiwan, R.O.C</p>
            <p>Tel: +886-2-2997-1912 &nbsp;&nbsp;&nbsp; Fax: +886-2-2996-9023</p>
        </header>

        <div style="font-size: 14px; padding-bottom: 10px; padding-top: 10px">
            <label for="Tool-SN" style="width: 24%">Tool model : <?php echo $data['tools_sn'];?></label>
            <label for="Serial-Number" style="width: 24%">Serial Number : TPS192865</label>
            <label for="Target-Torque" id="Target-Torque" style="width: 27%">Target Torque :  (N.m)</label>
            <label for="RPM" id="rpm" style="width: 11%">RPM : </label>
        </div>

        <div style="font-size: 14px; padding-bottom: 10px;">
            <label for="Upper-Limit" id="highLimitTorque" style="width: 24%">Upper Limit :</label>
            <label for="Lower-Limit" id="lowLimitTorque" style="width: 24%">Lower Limit : </label>
            <label for="Tolerance" id="bias" style="width: 27%">Tolerance +/-% : %</label>
            <label for="Offset" id="offset" style="width: 16%">Offset : </label>
        </div>

        <div style="font-size: 14px; padding-bottom: 10px; width: 100%">
            <label for="Std-dev-s" style="width: 24%">Std dev s(Cv) : <?php echo isset($data['meter']['stddev1']) ? $data['meter']['stddev1'] : 0; ?></label>
            <label for="Lower-Limit-B" style="width: 24%">3 Std dev s :  <?php echo isset($data['meter']['stddev3']) ? $data['meter']['stddev3'] : 0; ?></label>
            <label for="Cm" style="width: 27%">Cm : <?php echo isset($data['meter']['cm']) ? $data['meter']['cm'] : 0; ?></label>
            <label for="CmK">Cmk : <?php echo isset($data['meter']['cmk']) ? $data['meter']['cmk'] : 0; ?></label>
            
        </div>

        
        <div style="font-size: 14px; padding-bottom: 10px; width: 100%">
            <label for="Adapter Type" style="width: 24%">Adapter Type : </label>
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
                                <td style="word-spacing: 50px"><?php echo isset($data['meter']['max_torque']) ? $data['meter']['max_torque'] : '';?> (N.m)</td>
                            </tr>
                            <tr>
                                <td>Min</td>
                                <td style="word-spacing: 50px"><?php echo isset($data['meter']['min_torque']) ? $data['meter']['min_torque'] : '';?> (N.m)</td>
                            </tr>
                            <tr>
                                <td>Mean</td>
                                <td style="word-spacing: 50px"><?php echo isset($data['meter']['avg_torque']) ? $data['meter']['avg_torque'] : '';?> (N.m)</td>
                            </tr>
                            <tr>
                                <td>Std Dev s (Cv)</td>
                                <td><?php echo isset($data['meter']['stddev1']) ? $data['meter']['stddev1'] : '';?></td>
                            </tr>
                            <tr style="background-color: #FFFF5C">
                                <td>3 Std dev s</td>
                                <td><?php echo isset($data['meter']['stddev3']) ? $data['meter']['stddev3'] : '';?></td>
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
                                <td><?php echo isset($data['meter']['cm']) ? $data['meter']['cm'] : '';?></td>
                            </tr>
                            <tr style="background-color: #FFFF5C">
                                <td>CmK</td>
                                <td><?php echo isset($data['meter']['cmk']) ? $data['meter']['cmk'] : '';?></td>
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
            <span style="padding-left: 3%">Tested by :<?php echo $_SESSION['user']; ?></span> <span style="padding-left: 40%">Approved by :</span>
        </div>
    </div>
</body>

</html>
<?php date_default_timezone_set('Asia/Taipei');?>
<script>

    //讀取 localstorge
    let targetTorque = localStorage.getItem('targetTorque') || 0;
    let highLimitTorque = localStorage.getItem('highLimitTorque') || 0;
    let lowLimitTorque = localStorage.getItem('lowLimitTorque') || 0;
    let bias = localStorage.getItem('bias') || 0;
    let rpm = localStorage.getItem('rpm') || 0;
    let offset = localStorage.getItem('offset') || 0;
    let adapter_type = localStorage.getItem('adapter_type') || 0;


    if(targetTorque !== null){
        document.getElementById('Target-Torque').innerText = `Target Torque : ${targetTorque} (N.m)`;
    } 

    if(highLimitTorque !== null){
        document.getElementById('highLimitTorque').innerText = `Upper Limit : ${highLimitTorque} (N.m)`;
    } 
    if(lowLimitTorque !== null){
        document.getElementById('lowLimitTorque').innerText = `Lower Limit : ${lowLimitTorque} (N.m)`; 
    }

    if(bias !== null){
        document.getElementById('bias').innerText = `Tolerance +/-% : ${bias}%`;
    }

    if(rpm !== null){
        document.getElementById('rpm').innerText = `RPM :  ${rpm}`;
    }

    if(offset !== null){
        document.getElementById('offset').innerText = `Offset  :  ${offset}`;
    }

    
    if(adapter_type !== null){
        document.querySelector('label[for="Adapter Type"]').textContent = 'Adapter Type: ' + adapter_type;
    }



    var myChart = echarts.init(document.getElementById('mychart'));

    
    var x_val = <?php echo isset($data['echart']['x_val']) ? json_encode($data['echart']['x_val']) : '[]'; ?>; 
    var y_val_torque_1 = <?php echo isset($data['echart']['y_val_torque_1']) ? json_encode($data['echart']['y_val_torque_1']) : '[]'; ?>; 
    var y_val_torque_2 = <?php echo isset($data['echart']['y_val_torque_2']) ? json_encode($data['echart']['y_val_torque_2']) : '[]'; ?>; 

    x_val = convertToNumberArray(x_val);
    y_val_torque_1 = convertToNumberArray(y_val_torque_1);
    y_val_torque_2 = convertToNumberArray(y_val_torque_2);
    renderChart(x_val,y_val_torque_1,y_val_torque_2);

    
    function renderChart(x_val, y_val_torque_1, y_val_torque_2) {
        if (!x_val || !y_val_torque_1 || !y_val_torque_2 || x_val.length === 0 || y_val_torque_1.length === 0 || y_val_torque_2.length === 0) {
            console.error('Data arrays are empty or undefined!');
            return;
        }

        var chartContainer = document.getElementById('mychart');
        if (!chartContainer) {
            console.error('Chart container not found!');
            return;  // Prevent rendering if container is not found
        }

        var myChart = echarts.init(chartContainer);

        var upper_limit = parseFloat(localStorage.getItem('highLimitTorque'));
        var lower_limit = parseFloat(localStorage.getItem('lowLimitTorque'));


        if (isNaN(upper_limit)) upper_limit = null;
        if (isNaN(lower_limit)) lower_limit = null;

        var option = {
            title: {
                text: ''
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'cross',
                    crossStyle: {
                        color: '#999'
                    }
                },
                formatter: function (params) {
                    var tooltipContent = params[0].name + '<br>';
                    params.forEach(function (param) {
                        tooltipContent += param.seriesName + ': ' + param.value + '<br>';
                    });
                    return tooltipContent;
                }
            },
            legend: {
                data: ['ktm_Torque', 'controller_Torque'],
                top: 'top'
            },
            xAxis: {
                type: 'category',
                name: 'Count',
                data: x_val,
                boundaryGap: false,
            },
            yAxis: {
                type: 'value',
                name: 'Torque',
                min: Math.min(
                    lower_limit !== null ? lower_limit - 0.05 : Math.min(...y_val_torque_1, ...y_val_torque_2),  // Ensure the lower limit is visible
                    Math.min(...y_val_torque_1, ...y_val_torque_2)  // If lower_limit is null, use the minimum of the data
                ),
                max: Math.max(
                    upper_limit !== null ? upper_limit + 0.05 : Math.max(...y_val_torque_1, ...y_val_torque_2),  // Ensure the upper limit is visible
                    Math.max(...y_val_torque_1, ...y_val_torque_2)  // If upper_limit is null, use the maximum of the data
                ),
                axisLine: {
                    onZero: false
                }
            },
            series: [{
                    name: 'ktm_Torque',
                    type: 'line',
                    symbol: 'none',
                    sampling: 'average',
                    lineStyle: {
                        width: 0.75,
                        color: 'rgb(255,0,0)'
                    },
                    itemStyle: {
                        normal: {
                            color: 'rgb(255,0,0)'
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: 'rgb(255,255,255)' },
                                { offset: 1, color: 'rgb(255,255,255)' }
                            ])
                        }
                    },
                    data: y_val_torque_1,
                },
                {
                    name: 'controller_Torque',
                    type: 'line',
                    symbol: 'none',
                    sampling: 'average',
                    lineStyle: {
                        width: 0.75,
                        color: 'rgb(0,0,255)'
                    },
                    itemStyle: {
                        normal: {
                            color: 'rgb(0,0,255)'
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: 'rgb(255,255,255)' },
                                { offset: 1, color: 'rgb(255,255,255)' }
                            ])
                        }
                    },
                    data: y_val_torque_2,
                }
            ]
        };


        if (upper_limit !== null && lower_limit !== null) {
            option.series.push({
                name: 'Upper Limit',
                type: 'line',
                symbol: 'none',
                lineStyle: {
                    type: 'dashed',
                    color: 'green',
                    width: 0.75
                },
                data: new Array(x_val.length).fill(upper_limit),
                markPoint: {
                    data: [{
                        name: 'Upper Limit Value',
                        label: {
                            show: true,
                            position: 'top',
                            formatter: `Upper Limit: ${upper_limit}`
                        }
                    }]
                }
            });

            option.series.push({
                name: 'Lower Limit',
                type: 'line',
                symbol: 'none',
                lineStyle: {
                    type: 'dashed',
                    color: 'orange',
                    width: 0.75
                },
                data: new Array(x_val.length).fill(lower_limit),
                markPoint: {
                    data: [{
                        name: 'Lower Limit Value',
                        label: {
                            show: true,
                            position: 'bottom',
                            formatter: `Lower Limit: ${lower_limit}`
                        }
                    }]
                }
            });
        }

        myChart.setOption(option, true);
    }



    function convertToNumberArray(data) {
        if (Array.isArray(data)) {
            return data.map(Number);  
        }

        try {
            return JSON.parse(data).map(Number);
        } catch (e) {
            console.error('Invalid JSON format:', e);
            return [];
        }
    }


    
</script>
<script>
var type = '<?php echo $data['type']; ?>';
if (type  == "download") {

    var today = new Date();
    var day = String(today.getDate()).padStart(2, '0');
    var month = String(today.getMonth() + 1).padStart(2, '0'); 
    var year = today.getFullYear();
    today = year + month + day;

    var zip = new JSZip();
    var pageContent = document.documentElement.outerHTML;

    // 获取当前文件所在路径
    var baseUrl = window.location.origin + '/'; // 根路径

    var images = document.getElementsByTagName('img');
    var imagePromises = [];

    Array.from(images).forEach(function(image, index) {
        var imageUrl = image.src;
        if (!imageUrl.startsWith("http://") && !imageUrl.startsWith("https://")) {
            imageUrl = baseUrl + imageUrl;
        }

        var imageName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);

        var imagePromise = fetch(imageUrl)
            .then(response => response.blob())
            .then(blob => {
                zip.file('img/' + imageName, blob);
            });

        imagePromises.push(imagePromise);
    });

    var stylesheets = document.getElementsByTagName('link');
    var cssPromises = [];

    Array.from(stylesheets).forEach(function(stylesheet, index) {
        var cssUrl = stylesheet.href;
        if (!cssUrl.startsWith(baseUrl)) {
            cssUrl = baseUrl + cssUrl;
        }

        var cssName = cssUrl.substring(cssUrl.lastIndexOf("/") + 1);
        var cssPromise = fetch(cssUrl)
            .then(response => response.text())
            .then(text => {
                zip.file('css/' + cssName, text); 
            })
            .catch(error => {
                console.error('Failed to fetch CSS:', cssUrl, error);
            });

        cssPromises.push(cssPromise);
    });

    var scripts = document.getElementsByTagName('script');
    var jsPromises = [];

    Array.from(scripts).forEach(function(script, index) {
        if (script.src) {
            var jsUrl = script.src;
            if (!jsUrl.startsWith(baseUrl)) {
                jsUrl = baseUrl + jsUrl;
            }

            var jsName = jsUrl.substring(jsUrl.lastIndexOf("/") + 1);
            var jsPromise = fetch(jsUrl)
                .then(response => response.text())
                .then(text => {
                    zip.file('js/' + jsName, text);  
                })
                .catch(error => {
                    console.error('Failed to fetch JS:', jsUrl, error);
                });

            jsPromises.push(jsPromise);
        }
    });

    
    Promise.all([...imagePromises, ...cssPromises, ...jsPromises]).then(function() {
        var htmlFileName = 'calibration_chart_' + today + '.html';
        pageContent = pageContent.replace(/href="css\//g, 'href="css/');
        pageContent = pageContent.replace(/src="js\//g, 'src="js/');
        pageContent = pageContent.replace(/src="img\//g, 'src="img/'); 
        pageContent = pageContent.replace(/src="\.\.\/public\//g, 'src="');

        zip.file(htmlFileName, pageContent); 

        zip.generateAsync({ type: 'blob' }).then(function(content) {
            saveAs(content, 'all_calibration' + today + '.zip');
        });
    });


    
}
</script>