<!-- Station Rule -->
<div id="station_ruleContent" class="content" style="display: none">
    <div id="StationRuleDisplay" style="margin-top: 40px">
        <div class="container" style="box-shadow: 0px 2px 4px 0px rgba(0, 0, 0, 0.2); height: calc(100vh - 150px);">

            <div class="row">
                <div class="col-md-12">
                    <label for="server_ip">monitor server ip:</label>
                    <input id="server_ip" type="" name="" value="<?php echo $data['monitor_server_ip']; ?>">
                    <button onclick="save_server_ip()">save</button>
                </div>
                <div class="col-md-12 mt-3">
                    <button onclick="monitor_service('start')">start</button>
                    <button onclick="monitor_service('check')">check</button>
                    <button onclick="monitor_service('stop')">stop</button>
                </div>

                <div class="col-md-6 mt-3">
                    <div id="connect_log" style="padding: 3%;min-height: 30vh;background-color: #e1e1e1;border-radius: 10px;max-height: 30vh;overflow-y: scroll;">
                        
                    </div>
                </div>

                <!-- <div class="col-md-6 mt-3">
                    <div id="receive_log" style="padding: 3%;min-height: 30vh;background-color: #e1e1e1;border-radius: 10px;">
                        

                    </div>
                </div> -->

            </div>



              
        </div>
        
    </div>
</div>

<script type="text/javascript">
    function monitor_service(action) {
        console.log(action)
        let log_div = document.getElementById('connect_log')

        let formData = {};
        formData.action = action;
        // formData.OK_green_light = +document.getElementById("OK_Green").checked;

        $.ajax({
            url: '?url=Monitors/MonitorService', // 
            // async: false,
            method: 'POST',
            data: formData,
            dataType: "json",
            beforeSend: function() {
                $('#overlay').removeClass('hidden');
                const timeElapsed = Date.now();
                const today = new Date(timeElapsed);
                
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                let log = document.createElement('div');
                    log.className = 'col t3';
                    log.innerText = momo + ' try to '+action+' service';
                // log_div.appendChild(log);
                log_div.insertBefore(log,log_div.childNodes[0]);
            },
        }).done(function(response) { //成功且有回傳值才會執行
            $('#overlay').addClass('hidden');
            // console.log(data);
            console.log(response);
            let log = document.createElement('div');
            let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
            log.className = 'col t3';
            log.innerText = momo + ' response: ' + response.result;
            log_div.insertBefore(log,log_div.childNodes[0]);

            if(response.service_status == 'yes'){
                document.getElementById('service_status').innerText = ' <?php echo $text['Online_text']; ?>'
                document.getElementById('service_status').style = "color:green";
            }else{
                document.getElementById('service_status').innerText = ' <?php echo $text['Offline_text']; ?>'
                document.getElementById('service_status').style = "color:red";
            }

            if(action == 'start'){//如果是嘗試啟動 就把狀態改為-
                document.getElementById('service_status').innerText = '-'
            }

        }).fail(function() {
            // history.go(0);//失敗就重新整理
        });;

    }

    function save_server_ip() {

        let formData = {};
        formData.server_ip = document.getElementById('server_ip').value

        $.ajax({
            url: '?url=Monitors/SaveMonitorServerIp', // 
            // async: false,
            method: 'POST',
            data: formData,
            dataType: "json",
            beforeSend: function() {
                $('#overlay').removeClass('hidden');
            },
        }).done(function(response) { //成功且有回傳值才會執行
            $('#overlay').addClass('hidden');
            alert('saved')
           

        }).fail(function() {
            // history.go(0);//失敗就重新整理
            alert('fail')
        });;

    }

</script>