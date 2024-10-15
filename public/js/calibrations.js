
function html_download() {
    var fileName3 = document.getElementById('fileName3').value;
    var save_type3 = document.getElementById('Save-as3').value;

    var chartDataURL = myChart.getDataURL({
        pixelRatio: 2,
        backgroundColor: '#fff'
    });


    if (save_type3 === "html") {
        
        // 直接移除指定的元素
        var mainMenu = document.querySelector('.main-menu');
        if (mainMenu) {
            mainMenu.parentNode.removeChild(mainMenu);
        }


        var zip = new JSZip();
        var pageContent = document.documentElement.outerHTML;

        // 获取当前文件所在路径
        var baseUrl = window.location.origin + '/'; // 根路径

        var images = document.getElementsByTagName('img');
        var imagePromises = [];

        Array.from(images).forEach(function(image) {
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

        Array.from(stylesheets).forEach(function(stylesheet) {
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

        Array.from(scripts).forEach(function(script) {
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
            var htmlFileName = fileName3 + '.html'; // 用户自定义的 HTML 文件名
            pageContent = pageContent.replace(/href="css\//g, 'href="css/');
            pageContent = pageContent.replace(/src="js\//g, 'src="js/');
            pageContent = pageContent.replace(/src="img\//g, 'src="img/');

            zip.file(htmlFileName, pageContent);

            // 生成 ZIP 文件并触发下载
            zip.generateAsync({ type: 'blob' }).then(function(content) {
                saveAs(content, fileName3 + '.zip'); // 用户自定义的 ZIP 文件名
            });
        });
     
    }else if(save_type3 === "xml") {
        // 下載 XML 檔案
        fetch('../public/index.php?url=Calibrations/get_xml')
            .then(response => response.text())
            .then(xmlData => {
                var blob = new Blob([xmlData], { type: 'text/xml' });
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);
                link.download = fileName3 + '.xml';
                link.click();
            })
            .catch(error => {
                //console.error('获取 XML 数据时出错:', error);
            });
    }else if(save_type3 === "csv") {
        var job_id = 221;
        downloadCSV(job_id, fileName3);

    }else if(save_type3 === "jpg"){
        downloadChartAsImage(chartDataURL, fileName3, 'jpg');

    }else {
        //console.log("不支持的保存類型.");
    }
}

// 將 Data URI 轉換為 Blob 物件的輔助函式
function dataURItoBlob(dataURI) {
    var byteString = atob(dataURI.split(',')[1]);
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
    var ab = new ArrayBuffer(byteString.length);
    var ia = new Uint8Array(ab);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    return new Blob([ab], { type: mimeString });
}



function downloadChartAsImage(chartDataURL, fileName, format) {
 
    var blob = dataURLToBlob(chartDataURL);
    var link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.download = fileName + '.' + format;
    link.click();
}

function dataURLToBlob(dataURL) {
    var arr = dataURL.split(','),
        mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]),
        n = bstr.length,
        u8arr = new Uint8Array(n);

    while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
    }

    return new Blob([u8arr], { type: mime });
}

// function calljoball(){
//     document.getElementById("get_joball").style.display = "block";
// }


// function JobCheckbox()
// {
//     //取得 job被checked的值
//     var checked_jobid = document.querySelectorAll('input[type="checkbox"][name="jobid"]:checked');
//     var checkedjobidarr = [];
//     checked_jobid.forEach(function(checkbox) {
//         checkedjobidarr.push(checkbox.value);
//     });
// }

// function JobCheckbox_seq(){

//     //取得 job被checked的值
//     var checked_jobid = document.querySelectorAll('input[type="checkbox"][name="jobid"]:checked');
//     var checkedjobidarr = [];
//     checked_jobid.forEach(function(checkbox) {
//         checkedjobidarr.push(checkbox.value);
//     });

//     //取得 seq被checked的值
//     var checked_seqid = document.querySelectorAll('input[type="checkbox"][name="seqid"]:checked');
//     var checkedseqidarr = [];
//     checked_seqid.forEach(function(checkbox) {
//         checkedseqidarr.push(checkbox.value);
//     });

//     //checkedjobidarr &&  checkedseqidarr  不等於空值 要取得對應的task_id
//     if(checkedjobidarr != '' && checkedseqidarr  != ''){
//          $.ajax({
//             type: "POST",
//             data: {job_id: checkedjobidarr,seq_id: checkedseqidarr},
//             url: '?url=Calibrations/get_correspond_val',
//             success: function(response) {
//                 if (response.trim() === '') {
//                     alert('查無資料');
//                     window.location.href = '?url=Calibrations';

//                 } else {
//                     var taskListElement = document.getElementById('Task-list');
//                     taskListElement.style.display = 'block';
//                     document.getElementById("Task-list").innerHTML = response;
//                 }
//             },
//             error: function(error) {
//             }
//         }).fail(function () {
//         });


//     }
// }

function getCookie(cookieName) {
    var cookies = document.cookie.split(';');
    
    for (var i = 0; i < cookies.length; i++) {
        var cookie = cookies[i].trim(); 
        if (cookie.startsWith(cookieName + '=')) {
            return cookie.substring(cookieName.length + 1); 
        }
    }
    return '';
}


function downloadCSV(job_id, fileName3) {
    if (job_id) {
        $.ajax({
            type: "POST",
            data: { job_id: job_id },
            xhrFields: {
                responseType: 'blob'
            },
            url: '?url=Calibrations/csv_download',
            success: function (response) {
                var blob = new Blob([response], { type: 'text/csv' });
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);
                link.setAttribute('download', fileName3 + '.csv');

                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            },
            error: function (error) {
                console.error('下载 CSV 数据时出错:', error);
                alert('下载 CSV 数据时出错，请稍后重试');
            }
        });
    } else {
        alert('无效的 job_id，请检查您的设置。');
    }
}

