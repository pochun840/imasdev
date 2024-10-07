<!-- Socket Tray Edit Setting -->
    <div id="SocketTray_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%"><?php echo $text['Socket_tray_Setting_text']; ?></label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>
        <div class="center-content">
            <div class="container">
                <div class="wrapper" style="top: 0;">
                    <div class="navbutton active" onclick="handleButtonClick(this, 'sockettray')">
                        <span data-content="<?php echo $text['Connection_setting_text']; ?>" onclick="showContent('sockettray')"></span><?php echo $text['Connection_setting_text']; ?>
                    </div>
                </div>


                <div id="sockettrayContent" class="content">
                    <div style="padding: 40px">
                        <!-- <div class="row" style="padding-left: 4.2%">
                            <div class="col-1 t3">Name:</div>
                            <div class="col-2 t3">
                                <input type="text" id="connect-name" class="t5 form-control input-ms" value="" maxlength="">
                            </div>
                        </div> -->
                        <div style="padding-left: 5.5%">
                                <div style="padding: 5px">
                                    <label style="font-size: 18px">
                                        <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                        <b><?php echo $text['Connection_control_text']; ?></b>
                                    </label>
                                </div>
                                <!-- <div class="row t3">
                                    <div class="col-3 t3 form-check form-check-inline">
                                        <input class="" type="radio" name="connection-control-socket-tray" id="socket-tray-test" value="1" checked="checked" style="zoom:1.2; vertical-align: middle;">&nbsp;&nbsp;
                                         <label class="form-check-label" for="socket-tray-test">PLC</label>
                                    </div>
                                </div> -->

                                <div class="row t3">
                                    <div class="col-2 t3"><?php echo $text['Output_text']; ?> 1</div>
                                    <div class="col-3 t3">
                                        <select id="unit1" style="width: 80px" disabled>
                                            <option value="0" selected>pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                            <option value="7">pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                        </select>
                                    </div>
                                    <div class="col-2 t3"><?php echo $text['Input_text']; ?> 1</div>
                                    <div class="col-3 t3">
                                        <select id="unit2" style="width: 80px" disabled>
                                            <option value="0">pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5" selected>pin5</option>
                                            <option value="6">pin6</option>
                                            <option value="7">pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                            <option value="12">pin12</option>
                                            <option value="13">pin13</option>
                                            <option value="14">pin14</option>
                                            <option value="15">pin15</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row t3">
                                    <div class="col-2 t3"><?php echo $text['Output_text']; ?> 2</div>
                                    <div class="col-3 t3">
                                        <select id="unit3" style="width: 80px" disabled>
                                            <option value="0">pin0</option>
                                            <option value="1" selected>pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                            <option value="7">pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                        </select>
                                    </div>
                                    <div class="col-2 t3"><?php echo $text['Input_text']; ?> 2</div>
                                    <div class="col-3 t3">
                                        <select id="unit4" style="width: 80px" disabled>
                                            <option value="0">pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6" selected>pin6</option>
                                            <option value="7">pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                            <option value="12">pin12</option>
                                            <option value="13">pin13</option>
                                            <option value="14">pin14</option>
                                            <option value="15">pin15</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row t3">
                                    <div class="col-2 t3"><?php echo $text['Output_text']; ?> 3</div>
                                    <div class="col-3 t3">
                                        <select id="unit5" style="width: 80px" disabled>
                                            <option value="0">pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4" selected>pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                            <option value="7">pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                        </select>
                                    </div>
                                    <div class="col-2 t3"><?php echo $text['Input_text']; ?> 3</div>
                                    <div class="col-3 t3">
                                        <select id="unit6" style="width: 80px" disabled>
                                            <option value="0">pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                            <option value="7" selected>pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                            <option value="12">pin12</option>
                                            <option value="13">pin13</option>
                                            <option value="14">pin14</option>
                                            <option value="15">pin15</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row t3">
                                    <div class="col-2 t3"><?php echo $text['Output_text']; ?> 4</div>
                                    <div class="col-3 t3">
                                        <select id="unit7" style="width: 80px" disabled>
                                            <option value="0">pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5" selected>pin5</option>
                                            <option value="6">pin6</option>
                                            <option value="7">pin7</option>
                                            <option value="8">pin8</option>
                                            <option value="9">pin9</option>
                                            <option value="10">pin10</option>
                                            <option value="11">pin11</option>
                                        </select>
                                    </div>
                                </div>

                                <div style="padding: 5px">
                                    <label style="font-size: 18px">
                                        <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                                        <b><?php echo $text['Test_adjust_text']; ?></b>
                                    </label>
                                </div>
                                <div class="row t4">
                                    <div class="col-3 t3"><?php echo $text['Status_text']; ?>:
                                        <label style="color: red; padding-left: 3%"> </label>
                                    </div>
                                    <div class="col-1 t1">
                                        <select id="hole_id" style="width: 80px">
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                        </select>
                                    </div>

                                    <div class="col-3 t1">
                                        <button type="button" class="btn btn-Reconnect" onclick="connect_test_socket_tray('test')"><?php echo $text['SET_text']; ?></button>&nbsp;
                                        <button type="button" class="btn btn-Reconnect" onclick="connect_test_socket_tray('clear')"><?php echo $text['Clear_text']; ?></button>
                                    </div>
                                </div>
                                <div class="row t4">
                                    <div class="col t3"><b><?php echo $text['Communication_log_text']; ?></b></div>
                                </div>
                                <!-- <div class="scrollbar-Communicationlog" id="style-Communicationlog">
                                    <div id="connect_log" class="force-overflow-Communicationlog">
                                        <div class="row t4">
                                            <div class="col t3">2024/02/26 14:00 P.M equipment connect successfully</div>
                                        </div>
                                        <div class="row t4">
                                            <div class="col t3">2024/02/26 2:15 P.M equipment connect failed</div>
                                        </div>
                                    </div>
                                </div> -->
                                <div class="scrollbar-Communicationlog" id="style-Communicationlog-sockettray">
                                    <div id="connect_log_sockettray" class="force-overflow-Communicationlog" style="padding-left: 5%">
                                    </div>
                                </div>

                        </div>
                    </div>
                </div>

                <div id="sockettraysettingContent" class="content" style="display: none">
                    <div class="label-text" style="padding-left: 7%; padding: 50px">

                    </div>
                </div>
                
                <button class="saveButton" id="saveButton" onclick="save_setting()"><?php echo $text['Save_text']; ?></button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function connect_test_socket_tray(argument) {
            // alert(456)
            let hole_id = document.getElementById('hole_id').value;
            let log_div = document.getElementById('connect_log_sockettray')

            let formData = {};
            formData.hole_id = hole_id;
            formData.action = argument;
            // formData.OK_green_light = +document.getElementById("OK_Green").checked;

            $.ajax({
                url: '?url=Equipments/SokectTrayTest', // 
                // async: false,
                method: 'POST',
                data: formData,
                dataType: "json",
                timeout: 3000,
                beforeSend: function() {
                    // $('#overlay').removeClass('hidden');
                    const timeElapsed = Date.now();
                    const today = new Date(timeElapsed);
                    
                    let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                    let log = document.createElement('div');
                        log.className = 'col t3';
                        log.innerText = momo + ' Connect try set '+hole_id;
                    // log_div.appendChild(log);
                    log_div.insertBefore(log,log_div.childNodes[0]);
                },
            }).done(function(response) { //成功且有回傳值才會執行
                // $('#overlay').addClass('hidden');
                // console.log(data);
                console.log(response);
                let log = document.createElement('div');
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                log.className = 'col t3';
                log_div.insertBefore(log,log_div.childNodes[0]);

                if(response.service_status == 'yes'){
                    // document.getElementById('service_status_device').innerText = ' Online'
                    // document.getElementById('service_status_device').style = "color:green";
                    log.innerText = momo + ' response: connect success ';
                }else{
                    // document.getElementById('service_status_device').innerText = ' Offline'
                    // document.getElementById('service_status_device').style = "color:red";
                    log.innerText = momo + ' response: connect fail';
                }

                // log.innerText = momo + ' response: connect success ';
                log_div.insertBefore(log,log_div.childNodes[0]);


            }).fail(function() {
                // $('#overlay').addClass('hidden');
                let log = document.createElement('div');
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                log.className = 'col t3';
                log.innerText = momo + ' response: connect fail';
                log_div.insertBefore(log,log_div.childNodes[0]);

                // history.go(0);//失敗就重新整理
            });
        }
    </script>