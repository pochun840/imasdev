
//清除 資料  回到最原始的紀錄
function clear_button() {
    // 直接轉回到 Historicals 頁面
    window.location.href = '?url=Historicals';
}


//刪除(可支援複選)
function deleteinfo() {
    var checkboxes = document.querySelectorAll('input[type="checkbox"][name="test1"]:checked');
    var checkedValues = [];

    checkboxes.forEach(function(checkbox) {
        checkedValues.push(checkbox.value);
    });



    //如果沒有選值 就跳出
    if (!checkedValues.length) {
        alert('no data');
        return;  
    }else{

        //alert(checkedValues);
        //return;

    }

    var yes = confirm('Are you sure you want to delete the selected data ?');
    if (yes) {
         $.ajax({
                type: "POST",
                data: {values: checkedValues},
                url: '?url=Historicals/del_info',
                success: function(response) {
                    //console.log(response);
                    history.go(0);
                },
                error: function(error) {
                   
                }
            }).fail(function () {
                
            });
    }else{

    }
}

// Next To Combine data(最多只能選2筆)
function NextToCombineData() {    
    // 獲取所有選中的checkbox元素
    var checkboxes = document.querySelectorAll('input[type="checkbox"][name="test1"]:checked');
    var checkedValues = [];

    console.log(checkboxes);
    

    // 收集選中的值
    checkboxes.forEach(function(checkbox) {
        checkedValues.push(checkbox.value);
    });

    // 檢查是否選中至少兩項
    if (checkedValues.length < 2) {
        alert('請選擇至少兩筆資料進行合併');
        return;
    }

    // 檢查選中項的角度是否為 0
    for (var i = 0; i < checkboxes.length; i++) {
        var angleCell = checkboxes[i].parentNode.parentNode.cells[12]; // 獲取角度欄位
        if (angleCell && angleCell.innerHTML.trim() === '0 deg') {
            alert('請選擇鎖附角度不為0的資料');
            return;
        }
    }

    // 合併選中項的資料
    var checkedsn = checkedValues.join(', ');
    // 設定cookie，保存選中的系統序號
    document.cookie = "checked_system_sn=" + checkedsn + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
    
    // 跳轉到合併資料頁面
    window.location.href = '?url=Historicals/combinedata';    
}


var queryresult ='';
// 下載CSV
function csv_download(){

    if(queryresult != null){
        var data_csv = queryresult;
    }else{
        var systemSnval = 'total';
    }
    
    //正則表達式
    var regex = /<td id='system_sn'>(.*?)<\/td>/g;
    var systemSns = [];
    var match;
    while ((match = regex.exec(data_csv)) !== null) {
        systemSns.push(match[1]);
        systemSns.push(match[1]);
        var systemSnval = systemSns.join(',');
    }
    
    
    if(systemSnval  == undefined){
        var systemSnval = 'total';
    }
    
    var xhr = new XMLHttpRequest();
    document.cookie = "systemSnval=" + systemSnval + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
    xhr.open('POST', '?url=Historicals/csv_downland', true);
    xhr.responseType = 'blob'; 
    xhr.onload = function() {
        if (xhr.status === 200) {
            var blob = new Blob([xhr.response],{ type:'text/csv'});
            var link = document.createElement('a');
            link.href = window.URL.createObjectURL(blob);
            link.download = 'data.csv';
            link.click();
        }
    };
    xhr.send();
}

//搜尋
function search_info(page = 1){

    var barcodesn    = document.getElementById('barcodesn').value;
    var fromdate     = document.getElementById('FromDate').value;
    var todate       = document.getElementById('ToDate').value;
    var sname        = document.getElementById('search_name').value; //search bar

    var fromdate     = fromdate.replace("T", " ");
    var todate       = todate.replace("T", " ");
    var status_val   = document.getElementById("status").value;
    var operator     = document.getElementById("operator").value;

    var select_controller = document.getElementById("controller");
    var controller_val    = select_controller.value;

    var select_program    = document.getElementById("Program");
    var program_val       = select_program.value;

    //job 
    var checked_jobid = document.querySelectorAll('input[type="checkbox"][name="jobid"]:checked');
    var checkedjobidarr = [];
    checked_jobid.forEach(function(checkbox) {
        checkedjobidarr.push(checkbox.value);
    });

    var checked_jobname = document.querySelectorAll('[id^="job_name-"]');
    var jobNames = [];
    checked_jobname.forEach(function(label) {
        var job_name = label.innerText.trim();
        jobNames.push(job_name); 
       
    });

    var checked_seqname = document.querySelectorAll('[id^="seqid-name-"]');
    var seqNames = [];
    checked_seqname.forEach(function(label) {
        var seq_name = label.innerText.trim();
        seqNames.push(seq_name); 
       
    });

    //seq 
    var checked_seqid = document.querySelectorAll('input[type="checkbox"][name="seqid"]:checked');
    var checkedseqidarr = [];
    checked_seqid.forEach(function(checkbox) {
        checkedseqidarr.push(checkbox.value);
    });

    //task 
    var checked_taskid = document.querySelectorAll('input[type="checkbox"][name="taskid"]:checked');
    var checkedtaskidarr = [];
    checked_taskid.forEach(function(checkbox) {
        checkedtaskidarr.push(checkbox.value);
    });

    $.ajax({
        type: "POST",
        data: {
                barcodesn: barcodesn,
                fromdate: fromdate,
                todate: todate,
                status_val: status_val,
                sname: sname,
                job_id: checkedjobidarr,
                job_name:globalJobLabel,
                sequence_id: checkedseqidarr,
                seq_name:seqNames,
                cc_task_id:checkedtaskidarr,
                controller_val:controller_val,
                program_val:program_val,
                checkedjobidarr:checkedjobidarr,
                checkedseqidarr:checkedseqidarr,
                checkedtaskidarr:checkedtaskidarr,
                operator: operator,
                page: page
              },
        url: '?url=Historicals/search_info_list',
        success: function(response) {
            if (response.trim() === '') {
               alert('查無資料');
               window.location.href = '?url=Historicals';

            } else {
                queryresult = response;
                document.getElementById("tbody1").innerHTML = response;

                // 移除分頁元素（如果有）
                var paginationElement = document.querySelector('.pagination');
                if (paginationElement) {
                    paginationElement.remove();
                }
                updatePagination(data.totalPages, page);  

            }
        },
        error: function(error) {
        }
    }).fail(function () {
    });

}

function updatePagination(totalPages, currentPage) {
    // 根据 totalPages 和 currentPage 更新分页控件
    let paginationHTML = '';
    for (let i = 1; i <= totalPages; i++) {
        paginationHTML += `<button onclick="search_info(${i})">${i}</button>`;
    }
    document.getElementById("pagination_new").innerHTML = paginationHTML;
}

function JobCheckbox_seq(){

    //取得 job被checked的值
    var checked_jobid = document.querySelectorAll('input[type="checkbox"][name="jobid"]:checked');
    var checkedjobidarr = [];
    checked_jobid.forEach(function(checkbox) {
        checkedjobidarr.push(checkbox.value);
    });

    //取得 seq被checked的值
    var checked_seqid = document.querySelectorAll('input[type="checkbox"][name="seqid"]:checked');
    var checkedseqidarr = [];
    checked_seqid.forEach(function(checkbox) {
        checkedseqidarr.push(checkbox.value);
    });

    //alert(checkedseqidarr);
    

    //checkedjobidarr &&  checkedseqidarr  不等於空值 要取得對應的task_id
    if(checkedjobidarr != '' && checkedseqidarr  != ''){
         $.ajax({
            type: "POST",
            data: {job_id: globalJob_id ,seq_id: checkedseqidarr},
            url: '?url=Historicals/get_correspond_val',
            success: function(response) {
                if (response.trim() === '') {
                    //alert('查無資料');
                    window.location.href = '?url=Historicals';

                } else {
                    var taskListElement = document.getElementById('Task-list');
                    taskListElement.style.display = 'block';
                    document.getElementById("Task-list").innerHTML = response;
                }
            },
            error: function(error) {
            }
        }).fail(function () {
        });


    }
}

var globalJobLabel = '';
var globalJob_id = '';

function JobCheckbox(checkbox) {
    // 確保只有一個 checkbox 被選中
    if (checkbox.checked) {
        document.querySelectorAll('input[type="checkbox"][name="jobid"]').forEach(function(cb) {
            if (cb !== checkbox) {
                cb.checked = false;
            }
        });

        var checkedjobidarr = [checkbox.value];
        var jobLabel = document.querySelector('label[for="' + checkbox.id + '"]').textContent;

        var dataToSend = {
            job_id: checkedjobidarr,
            job_label: jobLabel
        };

        globalJobLabel = jobLabel.trim();
        globalJob_id   = checkedjobidarr;
   
        // 發送 AJAX 請求
        $.ajax({
            type: "POST",
            data: dataToSend,
            url: '?url=Historicals/get_correspond_val',
            success: function(response) {
                if (response.trim() === '') {
                    alert('查無資料');
                    window.location.href = '?url=Historicals';
                } else {
                    var seqListElement = document.getElementById('Seq-list');
                    seqListElement.style.display = 'block';
                    seqListElement.innerHTML = response;
                }
            },
            error: function(error) {
                console.error('AJAX error:', error);
            }
        }).fail(function () {
            console.error('AJAX request failed.');
        });
    } else {
        // 如果取消選中，清空 Seq-list 的內容
        document.getElementById('Seq-list').style.display = 'none';
        document.getElementById('Seq-list').innerHTML = '';
    }
}


//曲線圖模式選擇
function chat_mode(selectOS) {
 
    var selectElement = document.getElementById('Chart-seting');
    var selectedOptions = [];
    // 獲取所有被選中的選項
    for (var i = 0; i < selectElement.options.length; i++) {
        var option = selectElement.options[i];
        if (option.selected) {
            selectedOptions.push(option.value);
        }
    }

    document.cookie = "chat_modeno=" + selectedOptions + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
    history.go(0);

}


function chat_mode(selectOS) {
 
    var selectElement = document.getElementById('Chart-seting');
    var selectedOptions = [];
    // 獲取所有被選中的選項
    for (var i = 0; i < selectElement.options.length; i++) {
        var option = selectElement.options[i];
        if (option.selected) {
            selectedOptions.push(option.value);
        }
    }
    document.cookie = "chat_modeno=" + selectedOptions + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
    history.go(0);

}

//單位選擇 
var nextinfo_url = ''; 
function unit_change() {
    var selectElement = document.getElementById('Torque-Unit');
    var selectedOption = selectElement.options[selectElement.selectedIndex];
    var selectedValue = selectedOption.value;
    var selectedText = selectedOption.textContent;

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var convertedValue = this.responseText;
            var currentUrl = window.location.href;
            var unitvalueIndex = currentUrl.indexOf('unitvalue=');
            if (unitvalueIndex !== -1) {
                var nextinfo_url = currentUrl.substring(0, unitvalueIndex) + 'unitvalue=' + selectedValue;
            } else {
                var nextinfo_url = currentUrl + (currentUrl.indexOf('?') !== -1 ? '&' : '?') + 'unitvalue=' + selectedValue;
            }
            window.location.assign(nextinfo_url);
            console.log(nextinfo_url);
        }
    };
    xhttp.open("GET", nextinfo_url, true);
    xhttp.send();
}


function angle_change_combine(){
    var selectElement = document.getElementById('angle_combine');
    var selectedOption = selectElement.options[selectElement.selectedIndex];
    var selectedValue = selectedOption.value;
    var selectedText = selectedOption.textContent;

    var currentUrl = window.location.href;
    var anglecombineIndex = currentUrl.lastIndexOf('anglecombine=');

    var nextinfo_url;

    if (anglecombineIndex !== -1) {
        nextinfo_url = currentUrl.substring(0, anglecombineIndex) + 'anglecombine=' + selectedValue;
    } else {
        nextinfo_url = currentUrl + (currentUrl.indexOf('?') !== -1 ? '&' : '?') + 'anglecombine=' + selectedValue;
    }

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {

            window.location.assign(nextinfo_url);
        }
    };
    xhttp.open("GET", nextinfo_url, true);
    xhttp.send();
}

function chart_change(selectElement){
    var selectedValue = selectElement.value; 
    var currentUrl = window.location.href;
    var unitIndex = currentUrl.indexOf('unit=');
    var unitValue = '';
    if (unitIndex !== -1) {
        var nextAmpersandIndex = currentUrl.indexOf('&', unitIndex);
        if (nextAmpersandIndex !== -1) {
            unitValue = currentUrl.substring(unitIndex + 5, nextAmpersandIndex);
        } else {
            unitValue = currentUrl.substring(unitIndex + 5);
        }
    }
    var chartIndex = currentUrl.indexOf('chart=');

    var nextinfo_url;

    if (chartIndex !== -1) {
        var nextChartValue = 'chart=' + selectedValue;
        nextinfo_url = currentUrl.substring(0, chartIndex) + nextChartValue;
    } else {
        var separator = currentUrl.indexOf('?') !== -1 ? '&' : '?';
        nextinfo_url = currentUrl + separator + 'chart=' + selectedValue;
    }
    nextinfo_url += '&unit=' + "1";

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            window.location.assign(nextinfo_url);
        }
    };
    xhttp.open("GET", nextinfo_url, true);
    xhttp.send();
}


function unit_change_combine(){
    var selectElement = document.getElementById('unit');
    var selectedOption = selectElement.options[selectElement.selectedIndex];
    var selectedValue = selectedOption.value;
    var selectedText = selectedOption.textContent;

    var currentUrl = window.location.href;
    var unitcombineIndex = currentUrl.lastIndexOf('unit=');

    var nextinfo_url;

    if (unitcombineIndex!== -1) {
        nextinfo_url = currentUrl.substring(0, unitcombineIndex) + 'unit=' + selectedValue;
    } else {
        nextinfo_url = currentUrl + (currentUrl.indexOf('?') !== -1 ? '&' : '?') + 'unit=' + selectedValue;
    }

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {

            window.location.assign(nextinfo_url);
        }
    };
    xhttp.open("GET", nextinfo_url, true);
    xhttp.send();
}
//讀取cookie 
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

function setCookie(name, value) {
    document.cookie = `${name}=${value}; path=/;`;
}

function updateUrlParam(param, value) {
    const url = new URL(window.location);
    if (value === null) {
        url.searchParams.delete(param);
    } else {
        url.searchParams.set(param, value);
    }
    window.history.replaceState({}, '', url.toString());
}

function nopage() {
    const currentValue = getCookie('nopage') || '0';  // 默认为 '0'，表示不分页
    const newValue = currentValue === '1' ? '0' : '1';

    // 只在分页状态发生变化时更新 cookie 和 URL
    if (currentValue !== newValue) {
        setCookie('nopage', newValue);  // 更新 cookie

        // 如果禁用分页（newValue == '0'），删除分页参数 'p'，否则保留分页
        if (newValue === '0') {
            updateUrlParam('p', null);  // 删除分页参数
        }

        // 刷新页面，更新状态
        history.go(0);
    }
}



//回到上一頁
function goBack() {
    if (window.history.length > 1) {
        window.history.back(); 
        //window.location.href = '?url=Historicals';
    } else {
        window.location.href = '?url=Historicals';
    }
}

//勾選上下限
function check_limit(checkbox){
     limit_val = checkbox.checked;
     if (limit_val) {
         var limit_val = '1';
     } else {
         var limit_val = '0';
     }
     document.cookie = "limit_val=" + limit_val + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
     history.go(0);

}

var chat_modeno = getCookie('chat_modeno');
var limit_val = getCookie('limit_val');
var chat_mode_change = getCookie('chat_mode_change');


//處理 Torque
function processTorque(torqueValue, labelPrefix, color) {
    if (torqueValue !== 0 && torqueValue !== 0.0) {
        console.log(`${labelPrefix}:`, torqueValue);

        for (var i = 0; i <= max_count; i++) {
            // 如果該曲線被隱藏，則跳過
            if (!legendStatus[`chart${i}`]) continue;

            var yData = getChartData(i);
            if (!yData.length) continue;

            var found = false;

            // 精準匹配
            found = findExactMatch(yData, torqueValue, labelPrefix, color);
            if (!found) {
                // 模糊匹配
                findRangeMatch(yData, torqueValue, labelPrefix, color);
            }
        }
    }
}


//獲取圖表數據
function getChartData(chartIndex) {
    return chartData[`chart${chartIndex}_ycoordinate`]
        ? JSON.parse(chartData[`chart${chartIndex}_ycoordinate`])
        : [];
}


//精準匹配
function findExactMatch(yData, targetValue, labelPrefix, color) {
    for (var j = 0; j < yData.length; j++) {
        if (Math.abs(yData[j] - targetValue) < 0.0001) {
            addMarkPoint(j, yData[j], targetValue, labelPrefix, color);
            return true;
        }
    }
    return false;
}


//模糊匹配
function findRangeMatch(yData, targetValue, labelPrefix, color) {
    var rangeStart = targetValue + 0.001;
    var rangeEnd = targetValue + 0.099;

    for (var j = 0; j < yData.length; j++) {
        if (yData[j] >= rangeStart && yData[j] <= rangeEnd) {
            addMarkPoint(j, yData[j], targetValue, labelPrefix, color);
            break;
        }
    }
}

//添加標記點 
function addMarkPoint(index, yValue, targetValue, labelPrefix, color) {
    markPointData.push({
        xAxis: xData[index],
        yAxis: yValue,
        symbol: 'circle',
        symbolSize: 10,
        itemStyle: {
            color: color,
        },
        label: {
            position: 'top',
            formatter: `${labelPrefix}: ${targetValue.toFixed(1)}`,
        },
    });
}

//合併專用的調色盤
function getColorPalette() {
    return [
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
}

//日期時間選擇器
flatpickr("#FromDate", {
    enableTime: true,  // 啟用時間選擇
    dateFormat: "Y-m-d H:i",  // 設定日期與時間的顯示格式
    time_24hr: true,  // 使用24小時制（可選）
    className: "custom-flatpickr-input"
});


flatpickr("#ToDate", {
    enableTime: true,  // 啟用時間選擇
    dateFormat: "Y-m-d H:i",  // 設定日期與時間的顯示格式
    time_24hr: true,  // 使用24小時制（可選）
    className: "custom-flatpickr-input"
});
