
//清除 資料  回到最原始的紀錄
function clear_button(){

    //預設status: ALL
    var status_val= '0';
    $.ajax({
        type: "POST",
        data: {
              status_val: status_val
              },
        url: '?url=Historicals/search_info_list',
        success: function(response) {
            if (response.trim() === '') {
               alert('查無資料');
               window.location.href = '?url=Historicals';
               history.go(0);

            } else {
                queryresult = response;
                document.getElementById("tbody1").innerHTML = response;
                history.go(0);
                
            }
        },
        error: function(error) {
        
        }
    }).fail(function () {

    });
    history.go(0); 
}


//刪除(可支援複選)
function deleteinfo() {
    var checkboxes = document.querySelectorAll('input[type="checkbox"][name="test1"]:checked');
    var checkedValues = [];

    checkboxes.forEach(function(checkbox) {
        checkedValues.push(checkbox.value);
    });
    var yes = confirm('確定是否要刪除選定的資料？');
    if (yes) {
         $.ajax({
                type: "POST",
                data: {values: checkedValues},
                url: '?url=Historicals/del_info',
                success: function(response) {
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
function NextToCombineData()
{    
    var checkboxes = document.querySelectorAll('input[type="checkbox"][name="test1"]:checked');
    var checkedValues = [];

    checkboxes.forEach(function(checkbox) {
        checkedValues.push(checkbox.value);
        
    });

    //if(checkedValues.length > 2){
        //alert('最多只能選取2筆鎖附記錄的資料');    
    //}

    //if(checkedValues.length < 2){
        // alert('請選擇2筆鎖附記錄的資料');  
        //alert('請選擇2筆鎖附記錄的資料');  
    //}
    
    if(checkboxes[0].parentNode.parentNode.cells[12].innerHTML == '0 deg' || checkboxes[1].parentNode.parentNode.cells[12].innerHTML == '0 deg' ){
        alert('請選擇鎖附角度不為0的資料');
        return; 
    }

    //if(checkedValues.length == 2){
        var checkedsn = checkedValues.join(', ');
        document.cookie = "checkedsn=" + checkedsn + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
        window.location.href = '?url=Historicals/combinedata';    
    //}
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
function search_info(){

    var barcodesn    = document.getElementById('barcodesn').value;
    var fromdate     = document.getElementById('FromDate').value;
    var todate       = document.getElementById('ToDate').value;
    var sname        = document.getElementById('search_name').value; //search bar

    var fromdate     = fromdate.replace("T", " ");
    var todate       = todate.replace("T", " ");
    var selectElement = document.getElementById("status");
    var status_val    = selectElement.value;

    /*var select_controller = document.getElementById("controller");
    var controller_val    = select_controller.value;*/

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
    //alert(checkedjobidarr);

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
                //controller_val:controller_val,
                program_val:program_val,
                checkedjobidarr:checkedjobidarr,
                checkedseqidarr:checkedseqidarr,
                checkedtaskidarr:checkedtaskidarr
              },
        url: '?url=Historicals/search_info_list',
        success: function(response) {
            if (response.trim() === '') {
               alert('查無資料');
               window.location.href = '?url=Historicals';

            } else {
                queryresult = response;
                document.getElementById("tbody1").innerHTML = response;
            }
        },
        error: function(error) {
        }
    }).fail(function () {
    });

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
function nopage(){
    //0 =>不分頁 1=>分頁
    var currentValue = document.cookie.replace(/(?:(?:^|.*;\s*)nopage\s*\=\s*([^;]*).*$)|^.*$/, "$1");
    var newValue = (currentValue === "1") ? "0" : "1";
    document.cookie = "nopage=" + newValue; 

    if(newValue == "0"){
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.delete('p');
        const newUrl = window.location.pathname + '?' + urlParams.toString();
        window.history.replaceState({}, '', newUrl);
        
    }
    history.go(0);
}


//回到上一頁
function goBack() {
    if (window.history.length > 1) {
        // window.history.back(); 
        window.location.href = '?url=Historicals';
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