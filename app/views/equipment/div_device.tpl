<!-- Device GTCS Ediet Setting -->
    <div id="Device_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%">GTCS - <?php echo $text['Setting_text']; ?></label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>

        <div class="main-content">
            <div class="center-content">
                <div class="container">
                    <div class="wrapper" style=" top: 0">
                        <div class="navbutton active" onclick="handleButtonClick(this, 'connection')">
                            <span data-content="<?php echo $text['Connection_setting_text']; ?>" onclick="showContent('connection')"></span><?php echo $text['Connection_setting_text']; ?>
                        </div>
                        <div class="navbutton" onclick="handleButtonClick(this, 'controller')">
                            <span data-content="<?php echo $text['Contrller_Setting_text']; ?>" onclick="showContent('controller')"></span><?php echo $text['Contrller_Setting_text']; ?>
                        </div>
                        <div class="navbutton" onclick="handleButtonClick(this, 'information')">
                            <span data-content="<?php echo $text['Information_text']; ?>" onclick="showContent('information')"></span><?php echo $text['Information_text']; ?>
                        </div>
                    </div>

                    <div id="connectionContent" class="content ">
                        <div style="padding-left: 7%; padding: 50px">

                            <div style="padding: 5px">
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                    <b><?php echo $text['Connection_control_text']; ?></b>
                                </label>
                            </div>
                            <!-- <div class="row t3">
                                <div class="col-2 t4 form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="connection-control" id="Device-RS232" value="1" style="zoom:1.2; vertical-align: middle">&nbsp;
                                    <label class="form-check-label" for="Device-RS232">Modbus RTU/RS232</label>
                                </div>
                            </div> -->

                            <!-- <div class="row t3">
                                <div class="col-1 t3">
                                    <select id="unit" style="width: 110px">
                                        <option value="1">com 3</option>
                                        <option value="2">com 5</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="unit" style="width: 110px">
                                        <option value="1">115200</option>
                                        <option value="2">57600</option>
                                        <option value="3">38400</option>
                                        <option value="4">9600</option>
                                        <option value="5">4800</option>
                                        <option value="6">2400</option>
                                        <option value="7">1200</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="unit" style="width: 110px">
                                        <option value="1">None</option>
                                        <option value="2">Odd</option>
                                        <option value="2">Even</option>
                                        <option value="2">Mark</option>
                                        <option value="2">Space</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="unit" style="width: 110px">
                                        <option value="1">8</option>
                                        <option value="2">7</option>
                                        <option value="3">6</option>
                                        <option value="4">5</option>
                                        <option value="5">4</option>
                                        <option value="6">3</option>
                                        <option value="7">2</option>
                                        <option value="8">1</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="unit" style="width: 110px">
                                        <option value="1">10</option>
                                        <option value="2">4</option>
                                        <option value="3">1</option>
                                        <option value="4">3</option>
                                    </select>
                                </div>
                            </div> -->

                            <div class="row t3">
                                <div class="col-3 t4 form-check form-check-inline">
                                    <input class="form-check-input" type="radio"  id="Device-TCP-IP" value="1" checked style="zoom:1.2; vertical-align: middle" >&nbsp;
                                    <label class="form-check-label" for="Device-TCP-IP">TCP/IP</label>
                                </div>
                            </div>

                            <div class="row t3">
                                
                                <div class="col-2 t3">
                                    <input type="text" class="t5 form-control input-ms" id="Network-IP-device" value="<?php echo $data['controller_ip'];  ?>" maxlength="15" required>
                                </div>
                                <div class="col-2 t3">
                                    <button onclick="save_controller_ip()"><?php echo $text['Save_text']; ?></button>
                                </div>
                                
                                <!-- <div class="col-2 t3">
                                    <input type="text" class="t5 form-control input-ms" id="Network-IP" value="192.168.0.184" maxlength="" style="opacity: 0.4">
                                </div>
                                <div class="col-2 t3">
                                    <input type="text" class="t5 form-control input-ms" id="Network-IP" value="192.168.0.184" maxlength="" style="opacity: 0.4">
                                </div>
                                <div class="col-1 t3">
                                    <input type="text" class="t5 form-control input-ms" id="Communication-Port" value="502" maxlength="" required >
                                </div> -->
                            </div>

                            <hr style="color: #000;border: 0.5px solid #000;">

                            <div>
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                                    <b><?php echo $text['Test_adjust_text']; ?></b>
                                </label>
                            </div>
                            <div class="row t4">
                                <div class="col-3 t3"><?php echo $text['Status_text']; ?>:
                                    <label id="service_status_device" style="color: red; padding-left: 5%"> <?php echo $text['Offline_text']; ?>/<?php echo $text['Online_text']; ?></label>
                                </div>
                                <div class="col">
                                    <button type="button" class="btn btn-Reconnect" onclick="connect_test_gtcs()"><?php echo $text['Connect_Test_text']; ?></button>
                                </div>
                            </div>
                            <div class="row t4">
                                <div class="col t3"><b><?php echo $text['Communication_log_text']; ?></b></div>
                            </div>
                            <div class="scrollbar-Communicationlog" id="style-Communicationlog-device">
                                <div id="connect_log_device" class="force-overflow-Communicationlog" style="padding-left: 5%">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="controllerContent" class="content"  style="display: none;">
                        <div style="padding-left: 7%; padding: 60px">
                            <div class="col t1" style="padding: 10px"><b><?php echo $text['Contrller_Setting_text']; ?></b></div>
                            <div class="row t1">
                                <div class="col-2 t1" ><?php echo $text['ID_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="number" id="controller-id" class="t2 form-control input-ms" value="1" maxlength="255">
                                </div>

                                <div class="col-3 t1" style="padding-left: 10%;"><?php echo $text['Diskfull_Warning_text']; ?>(&#37;) :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="diskfull-warning" class="t2 form-control input-ms" value="80" maxlength="" disabled>
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Name_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="controller-name" class="t2 form-control input-ms" value="GTCS" maxlength="160" onkeyup="value=value.replace(/[^ -~]/g,'')">
                                </div>

                                <div class="col-3 t1" style="padding-left: 10%;"><?php echo $text['Disk_Storage_Space_text']; ?> :</div>
                                <div class="col progress t2" style="margin-top: 10px;padding-left:0;margin-right: 10px">
                                    <div id="disk_usage" class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100" style="width: 25%">X%</div>
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Unit_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <select id="Torque-Unit" class="t2 Select-All" style="height: 35px; border: 1px solid  #BBBBBB; border-radius: 3px" disabled>
                                        <option value="2">N.m</option>
                                        <option value="1">Kgf.m</option>
                                        <option value="2">Kgf.cm</option>
                                        <option value="2">In.lbs</option>
                                    </select>
                                </div>

                                <div class="col-3 t1" style="padding-left: 10%"><?php echo $text['Export_data_text']; ?> :</div>
                                <div class="col t2">
                                    <button class="export-impost-data w3-button w3-border w3-round-large" style="float: right"><?php echo $text['Copy_data_text']; ?></button>
                                    <button class="export-impost-data w3-button w3-border w3-round-large" style="float: right"><?php echo $text['Export_text']; ?></button>
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Language_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="language" class="t2 form-control input-ms" value="English" maxlength="" disabled="disabled">
                                </div>

                                <div class="col-3 t1" style="padding-left: 10%"><?php echo $text['Import_data_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="file" id="export-data-uploader" data-target="import-file-uploader" accept=".cfg" style="display: inline-block;" class="t2 form-control">
                                </div>
                                <div class="col t2">
                                    <button class="expost-impost-data w3-button w3-border w3-round-large" style="float: right"><?php echo $text['Import_text']; ?></button>
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Torque_Filter_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="torque-filter" class="t2 form-control input-ms" value="0.0" maxlength="" disabled>
                                </div>

                                <div class="col-3 t1" style="padding-left: 10%"><?php echo $text['Firmware_update_text']; ?> :</div>
                                <div class="col t2">
                                    <input type="file" id="firmware-uploader" data-target="import-file-uploader" accept=".cfg" style="display: inline-block;" class="t2 form-control">
                                </div>
                                <div class="col t2">
                                    <button class="expost-impost-data w3-button w3-border w3-round-large" style="float: right;"><?php echo $text['Update_text']; ?></button>
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Batch_Mode_text']; ?> :</div>
                                <div class="switch menu col-3 t2">
                                    <input id="Batch-Mode" type="checkbox" checked>
                                    <label><i></i></label>
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Blackout_Recovery_text']; ?> :</div>
                                <div class="switch menu col-3 t2">
                                    <input id="Blackout-Recovery" type="checkbox" checked>
                                    <label><i></i></label>
                                </div>
                            </div>
                        </div>
                        <button class="saveButton" style="right:110px;" onclick="load_device_setting()"><?php echo $text['Read_text']; ?></button>
                        <button class="saveButton" id="saveButton" onclick="save_controller_device_name()"><?php echo $text['Save_text']; ?></button>
                    </div>

                    <div id="informationContent" class="content"  style="display: none;">
                        <div style="padding-left: 5%; padding: 60px">
                            <div class="row t1">
                                <div class="col-5 t1" style="padding: 10px;"><b><?php echo $text['Tool_Information_text']; ?></b></div>
                                <div class="col t1" style="padding: 10px; padding-left: 5%"><b><?php echo $text['Controller_Information_text']; ?></b></div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1" ><?php echo $text['Tool_Type_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="tool-type" class="form-control input-ms" value="SGT-CS" maxlength="" disabled="disabled">
                                </div>

                                <div class="col-3 t1" style="padding-left: 12%"><?php echo $text['Controller_SN_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="controller-sn" class="form-control input-ms" value="" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Tool_SN_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="tool-sn" class="form-control input-ms" value="PTS" maxlength="" disabled="disabled">
                                </div>

                                <div class="col-3 t1" style="padding-left: 12%"><?php echo $text['Controller_Ver_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="controller-version" class="form-control input-ms" value="1.25-J7" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['SW_Version_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="sw-version" class="form-control input-ms" value="1.09" maxlength="" disabled="disabled">
                                </div>

                               <div class="col-3 t1" style="padding-left: 12%"><?php echo $text['MCB_Version_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="MCB-version" class="form-control input-ms" value="V02.91_T1_Svn369" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Total_Counts_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="total-counts" class="form-control input-ms" value="" maxlength="" disabled="disabled">
                                </div>

                                <div class="col-3 t1" style="padding-left: 12%"><?php echo $text['Image_Version_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="image-version" class="form-control input-ms" value="V2.00" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Max_Torque_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="max-torque" class="form-control input-ms" value="3.0" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Max_Speed_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="max-speed" class="form-control input-ms" value="980" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Calibration_Value_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="calibration-value" class="form-control input-ms" value="1.839" maxlength="" disabled="disabled">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-2 t1"><?php echo $text['Maintain_Counts_text']; ?> :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="maintain-counts" class="form-control input-ms" value="2289" maxlength="" disabled="disabled">
                                </div>

                                <div class="col t2">
                                    <button class="expost-impost-data w3-button w3-border w3-round-large"><?php echo $text['Refresh_text']; ?></button>
                                </div>
                            </div>

                        </div>
                    </div>
                    <!-- <button class="saveButton" id="saveButton" onclick="save_controller_ip()"><?php echo $text['Save_text']; ?></button> -->
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript">
        function connect_test_gtcs(argument) {
            // alert(456)
            let ip = document.getElementById('Network-IP-device').value;
            let log_div = document.getElementById('connect_log_device')

            let formData = {};
            formData.ip = ip;
            // formData.OK_green_light = +document.getElementById("OK_Green").checked;

            $.ajax({
                url: '?url=Equipments/DeviceConnectTest', // 
                // async: false,
                method: 'POST',
                data: formData,
                dataType: "json",
                timeout: 3000,
                beforeSend: function() {
                    $('#overlay').removeClass('hidden');
                    const timeElapsed = Date.now();
                    const today = new Date(timeElapsed);
                    
                    let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                    let log = document.createElement('div');
                        log.className = 'col t3';
                        log.innerText = momo + ' Connect try';
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
                log_div.insertBefore(log,log_div.childNodes[0]);

                if(response.service_status == 'yes'){
                    document.getElementById('service_status_device').innerText = ' Online'
                    document.getElementById('service_status_device').style = "color:green";
                    log.innerText = momo + ' response: connect success ';
                }else{
                    document.getElementById('service_status_device').innerText = ' Offline'
                    document.getElementById('service_status_device').style = "color:red";
                    log.innerText = momo + ' response: connect fail ';
                }

                log.innerText = momo + ' response: connect success ';
                log_div.insertBefore(log,log_div.childNodes[0]);


            }).fail(function() {
                $('#overlay').addClass('hidden');
                let log = document.createElement('div');
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                log.className = 'col t3';
                log.innerText = momo + ' response: connect fail ';
                log_div.insertBefore(log,log_div.childNodes[0]);

                // history.go(0);//失敗就重新整理
            });
        }

        function save_controller_ip(argument) {
            let ip = document.getElementById('Network-IP-device').value;

            let formData = {};
            formData.ip = ip;

            $.ajax({
                url: '?url=Equipments/SaveControllerIP', // 
                // async: false,
                method: 'POST',
                data: formData,
                dataType: "json",
                // timeout: 3000,
                beforeSend: function() {
                   
                },
            }).done(function(response) { //成功且有回傳值才會執行
                // Swal.fire('Saved!', '', 'success');
                alert('Saved!')
            }).fail(function() {
                // history.go(0);//失敗就重新整理
            });
        }

        function save_controller_device_name(argument) {
            let device_id = document.getElementById('controller-id').value;
            let device_name = document.getElementById('controller-name').value;

            let formData = {};
            formData.device_id = device_id;
            formData.device_name = device_name;

            $.ajax({
                url: '?url=Settings/GTCS_DB_SYNC', // 
                // async: false,
                method: 'POST',
                data: formData,
                // dataType: "json",
                // timeout: 3000,
                beforeSend: function() {
                   $('#overlay').removeClass('hidden');
                },
            }).done(function(response) { //成功且有回傳值才會執行
                // Swal.fire('Saved!', '', 'success');
                $('#overlay').addClass('hidden');
                alert('Saved!')
            }).fail(function() {
                // history.go(0);//失敗就重新整理
            });
        }

        function load_device_setting(argument) {
            let ip = document.getElementById('Network-IP-device').value;

            let formData = {};
            formData.ip = ip;

            $.ajax({
                url: '?url=Equipments/LoadControllerSetting', // 
                method: 'POST',
                data: formData,
                dataType: "json",
                beforeSend: function() {
                   $('#overlay').removeClass('hidden');
                },
            }).done(function(response) { //成功且有回傳值才會執行
                // Swal.fire('Saved!', '', 'success');
                $('#overlay').addClass('hidden');

                document.getElementById('controller-id').value = response.result.device_id
                document.getElementById('controller-name').value = response.result.device_name
                alert('Finish!')

            }).fail(function() {
                // history.go(0);//失敗就重新整理
            });
        }
    </script>