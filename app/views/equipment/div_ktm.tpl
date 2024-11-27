<!-- Device GTCS Ediet Setting -->
    <div id="Ktm_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 68px">KTM - <?php echo $text['Setting_text']; ?></label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>

        <div class="main-content">
            <div class="center-content">
                <div class="navbutton-content">
                    <div class="wrapper" style="top: 0">
                        <div class="navbutton active" onclick="handleButtonClick(this, 'ktmconnection')">
                            <span data-content="<?php echo $text['Connection_setting_text']; ?>" onclick="showContent('ktmconnection')"></span><?php echo $text['Connection_setting_text']; ?>
                        </div>
                        <!--
                        <div class="navbutton" onclick="handleButtonClick(this, 'armsteting')">
                            <span data-content="<?php echo $text['Arm_Encoders_setting_text']; ?>" onclick="showContent('armsteting')"></span><?php echo $text['Arm_Encoders_setting_text']; ?>
                        </div>
                        -->
                    </div>

                    <div id="ktmconnectionContent" class="content">
                        <div style="padding-left: 7%; padding: 50px">
                            <div style="padding: 5px">
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                    <b><?php echo $text['Connection_control_text']; ?></b>
                                </label>
                            </div>
                            
                            <div class="row t3">
                                <div class="col-2 t3">
                                    <select id="comport" style="width: 110px; margin-right: 10px">
                                        <?php 
                                            foreach ($data['comPorts'] as $key => $value) {
                                                echo '<option value="'.$value.'">'.$value.'</option>';
                                            }
                                        ?>
                                    </select>
                                    <select id="baudRate" style="width: 110px; margin-right: 10px" disabled>
                                        <option value="115200">115200</option>
                                        <option value="57600">57600</option>
                                        <option value="38400">38400</option>
                                        <option value="9600" selected>19200</option>
                                        <option value="4800">4800</option>
                                        <option value="2400">2400</option>
                                        <option value="1200">1200</option>
                                    </select>
                                    <select id="parity" style="width: 110px; margin-right: 10px" disabled>
                                        <option value="None" selected>None</option>
                                        <option value="Odd">Odd</option>
                                        <option value="Even">Even</option>
                                        <option value="Mark">Mark</option>
                                        <option value="Space">Space</option>
                                    </select>
                                    <select id="dataBits" style="width: 110px; margin-right: 10px" disabled>
                                        <option value="8" selected>8</option>
                                        <option value="7">7</option>
                                        <option value="6">6</option>
                                        <option value="5">5</option>
                                        <option value="4">4</option>
                                        <option value="3">3</option>
                                        <option value="2">2</option>
                                        <option value="1">1</option>
                                    </select>
                                    <select id="stopBits" style="width: 110px; margin-right: 10px" disabled>
                                        <option value="1" selected>1</option>
                                        <option value="2">2</option>
                                    </select>
                                </div>
                            </div>

                            <hr style="color: #000;border: 0.5px solid #000;">
                        
                            <div>
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                                    <b><?php echo $text['Test_adjust_text']; ?></b>
                                </label>
                            </div>

                            <div class="row t4">
                                <div class="col t3"><?php echo $text['Status_text']; ?>:
                                    <label id="service_status_device_1" style="color: red; padding-left: 5%; display: block; margin-right: 20px"> <?php echo $text['Offline_text']; ?></label>
                                    <label id="service_status_device_2" style="color: green; padding-left: 5%; display: none; margin-right: 20px"> <?php echo $text['Online_text']; ?></label>
                                    
                                    <button type="button" class="btn btn_All"  onclick="connect_test_ktm()"><?php echo $text['Service_Start_text']; ?></button>
                                    <button type="button" class="btn btn_All"  onclick="abort_ktm()"><?php echo $text['Service_Stop_text'];?></button>
                                </div>


                            </div>
                            <div class="row t4">
                                <div class="col t3"><b><?php echo $text['Communication_log_text']; ?></b></div>
                            </div>
                            
                            <div class="scrollbar-Communicationlog" id="style-Communicationlog">
                                    <div id="connect_log_ktm" class="force-overflow-Communicationlog" style="padding-left: 5%">
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
     var pidFileAppCheck = '<?php echo $data['pidFile_app_check'] ?>';
     window.onload = function() {
        if (pidFileAppCheck) {
            // 判斷是否為 "Y"
            if (pidFileAppCheck === "Y") {
                console.log("檔案檢查狀態：存在且為 'Y'");
                document.getElementById('service_status_device_2').style.display = 'block';
                 document.getElementById('service_status_device_1').style.display = 'none';
            } else {
                console.log("檔案檢查狀態：存在但不為 'Y'");
               document.getElementById('service_status_device_1').style.display = 'block';
                document.getElementById('service_status_device_2').style.display = 'none';
            }
        } else {
            console.log("檔案檢查狀態：不存在");
            document.getElementById('service_status_device_1').style.display = 'block';
            document.getElementById('service_status_device_2').style.display = 'none';
        }
    }

    let currentComPort = '';

    function connect_test_ktm() {
        var selectElement = document.getElementById('comport');
        currentComPort = selectElement.value;

        // 显示加载动画（overlay）
        $('#overlay').removeClass('hidden');

        let log_div = document.getElementById('connect_log');

        $.ajax({
            type: 'POST',
            url: '?url=Equipments/ktm_connect',
            data: { comport: currentComPort },
            dataType: 'json',
            success: function(response) {
                let message = response.result || response.error;
                let outputMessage = response.output ? "\nOutput: " + response.output : '';

                // 更新日志信息
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                let log_div = document.getElementById('connect_log_ktm');
                log_div.innerHTML = `${momo}  Connect try<br>${momo}  Connection success<br>${message}${outputMessage}<br><br>`;

                // 隐藏 service_status_device_1，显示 service_status_device_2
                document.getElementById('service_status_device_1').style.display = 'none';
                document.getElementById('service_status_device_2').style.display = 'block';

                // 隐藏加载动画
                $('#overlay').addClass('hidden');
            },
            error: function(jqXHR, textStatus, errorThrown) {
                // 错误日志
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                let log_div = document.getElementById('connect_log_ktm');
                log_div.innerHTML = `${momo}  Connect try<br>${momo}  Connection failed: ${textStatus} - ${errorThrown}<br><br>`;

                // 隐藏加载动画
                $('#overlay').addClass('hidden');

                // 显示错误的状态
                document.getElementById('service_status_device_1').style.display = 'none';
                document.getElementById('service_status_device_2').style.display = 'block';
            }
        });
    }


    function abort_ktm() {
        $.ajax({
            type: 'POST',
            url: '?url=Equipments/ktm_aborted',
            data: { comport: currentComPort },
            dataType: 'json',
            success: function(response) {
                console.log(response);
                let message = response.result || response.error;

                // 隱藏 service_status_device_1
                document.getElementById('service_status_device_1').style.display = 'block';

                // 顯示 service_status_device_2
                document.getElementById('service_status_device_2').style.display = 'none';

                history.go(0);
                document.getElementById('Ktm_Edit_Setting').style.display = 'block';
                document.getElementById('Equipment_Setting').style.display = 'none';

                // 移除 cookie 和 localStorage
                delCookie('implement_count');
                localStorage.removeItem('implement_count');
            },
            error: function(jqXHR, textStatus, errorThrown) {
                // 隱藏 service_status_device_1
                document.getElementById('service_status_device_1').style.display = 'block';

                // 顯示 service_status_device_2
                document.getElementById('service_status_device_2').style.display = 'none';

                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                let log_div = document.getElementById('connect_log_ktm');
                
                // 將最新日志插入到最上方，而不是追加到底部
                log_div.innerHTML = momo + "  Connect try<br>" + momo + "  Connection fail<br><br>" + log_div.innerHTML;
            }
        });
    }


    </script>

    <style>
        /* Loading 圓圈動畫 */
        .loader {
            border: 16px solid #f3f3f3; /* 背景顏色 */
            border-top: 16px solid #3498db; /* 轉動部分顏色 */
            border-radius: 50%;
            width: 120px;
            height: 120px;
            animation: spin 2s linear infinite;
        }

        /* 旋轉動畫 */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
