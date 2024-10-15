
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

        zip.file(htmlFileName, pageContent); 

        // 生成 ZIP 文件并触发下载
        zip.generateAsync({ type: 'blob' }).then(function(content) {
            saveAs(content, 'all_calibration' + today + '.zip');
        });
    });
}
</script>