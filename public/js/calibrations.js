
function html_download() {
    var fileName3 = document.getElementById('fileName3').value;
    var save_type3 = document.getElementById('Save-as3').value;



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
     
    }
    
    if(save_type3 === "xml") {
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
        saveChartAsImage('mychart'); 
      
    }else {
        //console.log("不支持的保存類型.");
    }
}





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

function saveChartAsImage(chartId, backgroundColor = '#ffffff', ) {
    
    var fileName3 = document.getElementById('fileName3').value; 
    var chartElement = document.getElementById(chartId);

    chartElement.style.backgroundColor = backgroundColor;

    html2canvas(chartElement, {
        backgroundColor: backgroundColor,  
        logging: true,                      
        useCORS: true,                    
        onrendered: function (canvas) {
            var img = canvas.toDataURL('image/jpeg');

            var link = document.createElement('a');
            link.href = img;
            link.download = fileName3;
            link.click();
        }
    });
}