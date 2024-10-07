<!-- ARM Edit Setting -->
    <div id="ARM_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%"><?php echo $text['ARM_Setting_text']; ?></label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>
        <div class="main-content">
            <div class="center-content">
                <div class="container">
                    <div class="wrapper" style="top: 0">
                        <div class="navbutton active" onclick="handleButtonClick(this, 'armconnection')">
                            <span data-content="<?php echo $text['Connection_setting_text']; ?>" onclick="showContent('armconnection')"></span><?php echo $text['Connection_setting_text']; ?>
                        </div>
                        <div class="navbutton" onclick="handleButtonClick(this, 'armsteting')">
                            <span data-content="<?php echo $text['Arm_Encoders_setting_text']; ?>" onclick="showContent('armsteting')"></span><?php echo $text['Arm_Encoders_setting_text']; ?>
                        </div>
                    </div>

                    <div id="armconnectionContent" class="content ">
                        <div style="padding-left: 7%; padding: 50px">
                            <!-- <div class="row t1">
                                <div class="col-1 t3">Name:</div>
                                <div class="col-2 t2">
                                    <input type="text" id="connect-name" class="t5 form-control input-ms" value="" maxlength="">
                                </div>
                            </div> -->

                            <div style="padding: 5px">
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                    <b><?php echo $text['Connection_control_text']; ?></b>
                                </label>
                            </div>
                            <!-- <div class="row t3">
                                <div class="col-2 t4 form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="connection-control-arm" id="Device-RS232-arm" value="1" style="zoom:1.2; vertical-align: middle">&nbsp;
                                    <label class="form-check-label" for="Device-RS232-arm">Modbus RTU/RS232</label>
                                </div>
                            </div> -->

                            <div class="row t3">
                                <div class="col-1 t3">
                                    <select id="comport" style="width: 110px">
                                        <?php 
                                            foreach ($data['comPorts'] as $key => $value) {
                                                echo '<option value="'.$value.'">'.$value.'</option>';
                                            }
                                        ?>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="baudRate" style="width: 110px" disabled>
                                        <option value="115200">115200</option>
                                        <option value="57600">57600</option>
                                        <option value="38400">38400</option>
                                        <option value="9600" selected>9600</option>
                                        <option value="4800">4800</option>
                                        <option value="2400">2400</option>
                                        <option value="1200">1200</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="parity" style="width: 110px" disabled>
                                        <option value="None" selected>None</option>
                                        <option value="Odd">Odd</option>
                                        <option value="Even">Even</option>
                                        <option value="Mark">Mark</option>
                                        <option value="Space">Space</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="dataBits" style="width: 110px" disabled>
                                        <option value="8" selected>8</option>
                                        <option value="7">7</option>
                                        <option value="6">6</option>
                                        <option value="5">5</option>
                                        <option value="4">4</option>
                                        <option value="3">3</option>
                                        <option value="2">2</option>
                                        <option value="1">1</option>
                                    </select>
                                </div>
                                <div class="col-1 t3">
                                    <select id="stopBits" style="width: 110px" disabled>
                                        <option value="10">10</option>
                                        <option value="4">4</option>
                                        <option value="1" selected>1</option>
                                        <option value="3">3</option>
                                    </select>
                                </div>
                            </div>

                            <hr style="color: #000;border: 0.5px solid #000;">

                            <div class="row t4" style="padding-bottom: 10px">
                                <div class="col-3 t3">
                                    <label><b><?php echo $text['Zero_point_cali_text']; ?></b></label>
                                </div>
                                <div class="col">
                                    <button type="button" class="btn btn-ZeroReset" onclick="set_arm_zero();"><?php echo $text['Zero_reset_text']; ?></button>
                                </div>
                            </div>

                            <div>
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                                    <b><?php echo $text['Test_adjust_text']; ?></b>
                                </label>
                            </div>
                            <div class="row t4">
                                <div class="col-3 t3"><?php echo $text['Status_text']; ?>:
                                    <label id="service_status" style="color: red; padding-left: 5%"> - </label>
                                </div>
                                <div class="col">
                                    <button type="button" class="btn btn-Reconnect" onclick="Connect_arm_test('start')"><?php echo $text['Service_Start_text']; ?></button>
                                    <button type="button" class="btn btn-Reconnect" onclick="Connect_arm_test('stop')"><?php echo $text['Service_Stop_text']; ?></button>
                                    <button type="button" class="btn btn-Reconnect" onclick="Connect_arm_test('check')"><?php echo $text['Service_Check_text']; ?></button>
                                </div>
                            </div>
                            <div class="row t4">
                                <div class="col t3"><b><?php echo $text['Communication_log_text']; ?></b></div>
                            </div>
                            <div class="scrollbar-Communicationlog" id="style-Communicationlog-arm">
                                <div id="connect_log_arm" class="force-overflow-Communicationlog" style="padding-left: 5%">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Arm Encoders Setting -->
                    <div id="armstetingContent" class="content "  style="display: none;">
                        <div style="padding-left: 7%; padding: 40px">
                            <div class="scrollbar-Arm" id="style-Arm">
                                <div class="force-overflow">
                                    <div class="col t1" style="font-size: 20px; padding-left: 1%"><b><?php echo $text['Screws_text']; ?></b></div>
                                    <div class="col t1" style="font-size: 18px; padding-left: 3%"><?php echo $text['Adjustment_text']; ?></div>
                                    <div style="padding-left: 5%; margin-bottom: 5px" class="border-bottom">
                                        <div class="row">
                                            <div class="col-3 t1"><?php echo $text['Encoder_text']; ?> 1 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2" style="margin-left: 2.4%">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 2 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2" style="margin-left: 2.4%">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col t1" style="font-size: 20px; padding-left: 1%"><b><?php echo $text['Screws_text'].' '.$text['Picking_area_text']; ?></b></div>
                                    <div style="padding-left:4%">
                                        <div class="row">
                                            <div class="col-3 t1" style="font-size: 18px;"><b><?php echo $text['Picking_area_text']; ?> A. <?php echo $text['Name_text']; ?> :</b></div>
                                            <div class="col-3 t2" style="margin-left: 3%">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col t1" style="font-size: 18px; padding-left: 5%"><?php echo $text['Adjustment_text']; ?></div>
                                    <div style="padding-left:8%; margin-bottom: 5px" class="border-bottom">
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 1 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 2 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="padding-left:4%">
                                        <div class="row">
                                            <div class="col-3 t1" style="font-size: 18px;"><b><?php echo $text['Picking_area_text']; ?> B. <?php echo $text['Name_text']; ?> :</b></div>
                                            <div class="col-3 t2" style="margin-left: 3%">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col t1" style="font-size: 18px; padding-left: 5%"><?php echo $text['Adjustment_text']; ?></div>
                                    <div style="padding-left:8%; margin-bottom: 5px" class="border-bottom">
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 1 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 2 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="padding-left:4%">
                                        <div class="row">
                                            <div class="col-3 t1" style="font-size: 18px;"><b><?php echo $text['Picking_area_text']; ?> C. <?php echo $text['Name_text']; ?> :</b></div>
                                            <div class="col-3 t2" style="margin-left: 3%">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col t1" style="font-size: 18px; padding-left: 5%"><?php echo $text['Adjustment_text']; ?></div>
                                    <div style="padding-left:8%; margin-bottom: 5px" class="border-bottom">
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 1 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 2 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="padding-left:4%">
                                        <div class="row">
                                            <div class="col-3 t1" style="font-size: 18px;"><b><?php echo $text['Picking_area_text']; ?> D. <?php echo $text['Name_text']; ?> :</b></div>
                                            <div class="col-3 t2" style="margin-left: 3%">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col t1" style="font-size: 18px; padding-left: 5%"><?php echo $text['Adjustment_text']; ?></div>
                                    <div style="padding-left:8%; margin-bottom: 5px" class="border-bottom">
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 1 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 t1" ><?php echo $text['Encoder_text']; ?> 2 <?php echo $text['Tolerance_setting_text']; ?> :</div>
                                            <div class="col-3 t2">
                                                <input type="text" id="" class="form-control input-ms" value="" maxlength="">
                                            </div>
                                            <div class="col-3 t2">
                                                <button type="button" class="btn btn-Encoder"><?php echo $text['Confirm_text']; ?></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button class="saveButton" id="saveButton"><?php echo $text['Save_text']; ?></button>
                </div>
            </div>
        </div>
    </div>


    <script>
        function set_arm_zero() {
            // body...
            // alert(666);
            // const wsServer = 'ws://127.0.0.1:9527';
            // const wsServer = 'ws://192.168.0.115:9527';
            const wsServer = 'ws://localhost:9527';
            const websocket = new WebSocket(wsServer);
            
            websocket.onopen = function (evt) {
                // console.log("Connected to WebSocket server.");
                let random = Math.floor(Math.random() * 100) + 1;
                // send(random);
                websocket.send('zero');
                websocket.close();
            };

            websocket.onclose = function (evt) {
                // console.log("Disconnected");
            };

            websocket.onmessage = function (evt) {
                // console.log('Retrieved data from server: ' + evt.data);
                // let axis = evt.data.split(',');
                // coordinate(axis);
                // document.getElementById('position').value = axis[0];
                
                // websocket.close();
            };

            websocket.onerror = function (evt, e) {
                console.log('Error occured: ' + evt.data);
            };
        }


    function Connect_arm_test(action) {
        let comport = document.getElementById('comport').value;
        let log_div = document.getElementById('connect_log_arm')

        let formData = {};
        formData.action = action;
        formData.comport = comport;
        // formData.OK_green_light = +document.getElementById("OK_Green").checked;

        $.ajax({
            url: '?url=Equipments/ArmService', // 
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
    </script>