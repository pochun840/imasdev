<?php 
if(!empty($data['buzzer_switch'])) {
    if ($data['buzzer_switch'] == "1") {
        $buzzer_status = 'checkmark checkmark_buzzer';
        $is_disabled = '';     
    } else {
        $buzzer_status = 'checkmark checkmark_buzzer disabled';
    }
} else {
    $buzzer_status = 'checkmark checkmark_buzzer disabled';
    $is_disabled = 'disabled';
}

if(!empty($data['tower_light_switch'])) {
    if ($data['tower_light_switch'] == "1") {
         $is_disabled = '';       
    } else {
        $is_disabled = 'disabled';
    }
}else{
    $is_disabled = 'disabled';
}

?>
<!-- Tower Light Edit Setting -->
    <div id="TowerLight_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%"><?php echo $text['Tower_Light_Setting_text'];?></label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>
        <div class="center-content">
            <div class="container">
                <div class="wrapper" style="top: 0">
                    <div class="navbutton active" onclick="handleButtonClick(this, 'towerlight')">
                        <span data-content="<?php echo $text['Connection_setting_text']; ?>" onclick="showContent('towerlight')"></span><?php echo $text['Connection_setting_text']; ?>
                    </div>
                    <div class="navbutton" onclick="handleButtonClick(this, 'towerlightsetting')">
                        <span data-content="<?php echo $text['Light_Setting_text']; ?>" onclick="showContent('towerlightsetting')"></span><?php echo $text['Light_Setting_text']; ?>
                    </div>
                </div>


                <div id="towerlightContent" class="content">
                    <div style="padding: 40px">
                        <div class="row" style="padding-left: 5.5%">
                            <div class="col-1 t3"><?php echo $text['Name_text']; ?>:</div>
                            <div class="col-2 t3">
                                <input type="text" id="connect-name" class="t5 form-control input-ms" value="" maxlength="">
                            </div>
                        </div>

                        <div class="left-right-setting">
                            <div class="left-column">
                                <div style="padding: 5px">
                                    <label style="font-size: 18px">
                                        <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                        <b><?php echo $text['Connection_control_text']; ?></b>
                                    </label>
                                </div>
                                <!-- <div class="row t3">
                                    <div class="col-3 t3 form-check form-check-inline">
                                        <input class="" type="radio" name="connection-control" id="plc" value="1" checked="checked" style="zoom:1.2; vertical-align: middle;">&nbsp;&nbsp;
                                        <label class="form-check-label" for="plc">PLC</label>
                                    </div>
                                </div> -->

                                <div class="row t3">
                                    <div class="col-3 t3"><?php echo $text['Red_text']; ?></div>
                                    <div class="col-1 t3">
                                        <select id="unit" style="width: auto" disabled>
                                            <option value="0"></option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option selected value="5">pin5</option>
                                            <option value="6">pin6</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row t3">
                                    <div class="col-3 t3"><?php echo $text['Green_text']; ?></div>
                                    <div class="col-1 t3">
                                        <select id="unit" style="width: auto" disabled>
                                            <option value="0"></option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option selected value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row t3">
                                    <div class="col-3 t3"><?php echo $text['Yellow_text']; ?></div>
                                    <div class="col-1 t3">
                                        <select id="unit" style="width: auto" disabled>
                                            <option value="0"></option>
                                            <option selected value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row t3">
                                    <div class="col-3 t3"><?php echo $text['Buzzer_text']; ?></div>
                                    <div class="col-1 t3">
                                        <select id="unit" style="width: auto" disabled>
                                            <option selected value="0">pin0</option>
                                            <option value="1">pin1</option>
                                            <option value="2">pin2</option>
                                            <option value="3">pin3</option>
                                            <option value="4">pin4</option>
                                            <option value="5">pin5</option>
                                            <option value="6">pin6</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="right-column">
                                <div style="padding: 5px">
                                    <label style="font-size: 18px">
                                        <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                                        <b><?php echo $text['Test_adjust_text']; ?></b>
                                    </label>
                                </div>
                                <div class="row t4">
                                    <div class="col t3 coler-setting">
                                        <label class="light_test"><?php echo $text['Red_text']; ?>
                                          <input id="test_Red" type="checkbox" checked="checked">
                                          <span class="checkmark checkmark_red"></span>
                                        </label>
                                        <label class="light_test"><?php echo $text['Green_text']; ?>
                                          <input id="test_Green" type="checkbox">
                                          <span class="checkmark checkmark_green"></span>
                                        </label>
                                        <label class="light_test"><?php echo $text['Yellow_text']; ?>
                                          <input id="test_Yellow" type="checkbox">
                                          <span class="checkmark checkmark_yellow"></span>
                                        </label>
                                        <label class="light_test"><?php echo $text['Buzzer_text']; ?>
                                          <input id="test_Buzzer" type="checkbox">
                                          <span class="checkmark checkmark_buzzer"></span>
                                        </label>
                                    </div>
                                </div>

                                <div class="row t4">
                                    <div class="col-3 t3"><?php echo $text['Status_text']; ?>:
                                        <label style="color: red; padding-left: 3%"> </label>
                                    </div>
                                    <div class="col-3 t1">
                                        <button type="button" class="btn btn-Reconnect" onclick="connect_test()"><?php echo $text['TEST_text']; ?></button>
                                    </div>
                                </div>
                                <div class="row t4">
                                    <div class="col t3"><b><?php echo $text['Communication_log_text']; ?></b></div>
                                </div>
                                <div class="scrollbar-Communicationlog" id="style-Communicationlog-towerlight">
                                    <div id="connect_log" class="force-overflow-Communicationlog" style="padding-left: 5%">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="towerlightsettingContent" class="content" style="display: none">
                    <div class="label-text" style="padding-left: 7%; padding: 50px">
                        <div style="padding: 5px">
                            <label style="font-size: 18px;font-weight: bold">
                                <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                    <?php echo $text['Light_Setting_text']; ?>
                            </label>
                        </div>

                        <div class="row t4">
                            <div class="col-2 t3">
                                <label><?php echo $text['Type_text']; ?></label>
                            </div>
                            <div class="col-4 t1">
                                <label style="font-weight: bold"><?php echo $text['Color_Configuration_text']; ?></label>
                            </div>
                            <div class="col t3">
                                <label style="font-weight: bold; margin-left: 6.2%"><?php echo $text['Length_of_time_text']; ?></label>
                            </div>
                        </div>
                        <!-- <div class="col t3" style="padding-left: 18%">
                            <label style="margin-right: 48px; color: #339900">GREEN</label> <label style="margin-right: 42px; color: red">RED</label> <label style="color: orange">YELLOW</label>
                        </div> -->

                        <div class="row t4">
                            <div class="col-2 t3">
                                <label>OK</label>
                            </div>
                            <div class="col-4 t1 coler-setting">
                                <label class="light_test">
                                    <input id="OK_Red" type="checkbox" checked="checked">
                                    <span class="<?php echo 'checkmark checkmark_red' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OK_Green" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_green' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OK_Yellow" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_yellow' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OK_Buzzer" type="checkbox"> 
                                    <span class="<?php echo $buzzer_status;?>"><?php echo $text['Buzzer_text']; ?></span>
                                </label>
                            </div>
                            <div class="col t3">
                                <div class="form-check form-check-inline">
                                    <!-- <input class="form-check-input" type="radio" name="OK-option" id="OK-solid-light" value="" style="zoom:1.0; vertical-align: middle"> -->
                                    <label class="form-check-label" for="OK-solid-light">
                                        <img class="length-signal" src="./img/signal02.png" alt="">
                                    </label>
                                </div>
                                <div>
                                    <input id="OK_time" class="lighttime" type="" name="" <?php echo $is_disabled;?> >
                                    <span><?php echo $text['ms_text']; ?></span>
                                </div>
                            </div>
                        </div>

                        <div class="row t4">
                            <div class="col-2 t3">
                                <label>NG</label>
                            </div>
                            <div class="col-4 t1 coler-setting">
                                <label class="light_test">
                                    <input id="NG_Red" type="checkbox" checked="checked">
                                    <span class="<?php echo 'checkmark checkmark_red' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="NG_Green" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_green' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="NG_Yellow" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_yellow' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="NG_Buzzer" type="checkbox">
                                    <span class="<?php echo $buzzer_status;?>""><?php echo $text['Buzzer_text']; ?></span>
                                </label>
                            </div>
                            <div class="col t3">
                                <div class="form-check form-check-inline">
                                    <!-- <input class="form-check-input" type="radio" name="NG-option" id="NG-solid-light" value="" style="zoom:1.0; vertical-align: middle"> -->
                                    <label class="form-check-label" for="NG-solid-light">
                                        <img class="length-signal" src="./img/signal02.png" alt="">
                                    </label>
                                </div>
                                <div>
                                    <input id="NG_time" class="lighttime" type="" name="" <?php echo $is_disabled;?> >
                                    <span><?php echo $text['ms_text']; ?></span>
                                </div>
                            </div>
                        </div>

                        <div class="row t4">
                            <div class="col-2 t3">
                                <label>OK Sequence</label>
                            </div>
                            <div class="col-4 t1 coler-setting">
                                <label class="light_test">
                                    <input id="OK_SEQ_Red" type="checkbox" checked="checked">
                                    <span class="<?php echo 'checkmark checkmark_red' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OK_SEQ_Green" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_green' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OK_SEQ_Yellow" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_yellow' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OK_SEQ_Buzzer" type="checkbox">
                                    <span class="<?php echo $buzzer_status;?>""><?php echo $text['Buzzer_text']; ?></span>
                                </label>
                            </div>
                            <div class="col t3">
                                <div class="form-check form-check-inline">
                                    <!-- <input class="form-check-input" type="radio" name="OKALL-option" id="OKALL-solid-light" value="" style="zoom:1.0; vertical-align: middle"> -->
                                    <label class="form-check-label" for="OKALL-solid-light">
                                        <img class="length-signal" src="./img/signal02.png" alt="">
                                    </label>
                                </div>
                                <div>
                                    <input id="OK_SEQ_time" class="lighttime" type="" name="" <?php echo $is_disabled;?> >
                                    <span><?php echo $text['ms_text']; ?></span>
                                </div>
                            </div>
                        </div>

                        <div class="row t4">
                            <div class="col-2 t3">
                                <label>OK-ALL</label>
                            </div>
                             <div class="col-4 t1 coler-setting">
                                <label class="light_test">
                                    <input id="OKALL_Red" type="checkbox" checked="checked">
                                     <span class="<?php echo 'checkmark checkmark_red' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OKALL_Green" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_green' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OKALL_Yellow" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_yellow' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="OKALL_Buzzer" type="checkbox">
                                    <span class="<?php echo $buzzer_status;?>""><?php echo $text['Buzzer_text']; ?></span>
                                </label>
                            </div>
                           <div class="col t3">
                                <div class="form-check form-check-inline">
                                    <!-- <input class="form-check-input" type="radio" name="OKALL-option" id="OKALL-solid-light" value="" style="zoom:1.0; vertical-align: middle"> -->
                                    <label class="form-check-label" for="OKALL-solid-light">
                                        <img class="length-signal" src="./img/signal02.png" alt="">
                                    </label>
                                </div>
                                <div>
                                    <input id="OKALL_time" class="lighttime" type="" name="" <?php echo $is_disabled;?> >
                                    <span><?php echo $text['ms_text']; ?></span>
                                </div>
                            </div>
                        </div>

                        <div class="row t4">
                            <div class="col-2 t3">
                                <label>Sensor Error</label>
                            </div>
                            <div class="col-4 t1 coler-setting">
                                <label class="light_test">
                                    <input id="ERROR_Red" type="checkbox" checked="checked">
                                     <span class="<?php echo 'checkmark checkmark_red' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="ERROR_Green" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_green' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="ERROR_Yellow" type="checkbox">
                                    <span class="<?php echo 'checkmark checkmark_yellow' .' ' .$is_disabled;?>"></span>
                                </label>
                                <label class="light_test">
                                    <input id="ERROR_Buzzer" type="checkbox">
                                    <span class="<?php echo $buzzer_status;?>""><?php echo $text['Buzzer_text']; ?></span>
                                </label>
                            </div>
                            <div class="col t3">
                                <div class="form-check form-check-inline">
                                    <!-- <input class="form-check-input" type="radio" name="Error-option" id="Error-solid-light" value="" style="zoom:1.0; vertical-align: middle"> -->
                                    <label class="form-check-label" for="Error-solid-light">
                                        <img class="length-signal" src="./img/signal02.png" alt="">
                                    </label>
                                </div>
                                <div>
                                    <input id="ERROR_time" class="lighttime" type="" name="" <?php echo $is_disabled;?> >
                                    <span><?php echo $text['ms_text']; ?></span>
                                </div>
                           </div>
                        </div>

                    </div>
                </div>
                <button class="saveButton" id="saveButton" onclick="save_setting()"><?php echo $text['Save_text']; ?></button>
            </div>
        </div>
    </div>


<script type="text/javascript">
    $( document ).ready(function() {
        initial();
    });

    function connect_test(argument) {
        let red_light = +document.getElementById("test_Red").checked;
        let green_light = +document.getElementById("test_Green").checked;
        let yellow_light = +document.getElementById("test_Yellow").checked;
        let buzzer = +document.getElementById("test_Buzzer").checked;

        let log_div = document.getElementById('connect_log')

        console.log(red_light,green_light,yellow_light,buzzer);
        $.ajax({
            url: '?url=Equipments/TowerLightTest', // 指向服務器端檢查更新的 PHP 腳本
            // async: false,
            method: 'GET',
            data: { 
                'light_signal': 'io_test',
                'red_light': red_light,
                'green_light': green_light,
                'yellow_light': yellow_light,
                'buzzer': buzzer
            },
            dataType: "json",
            beforeSend: function(){
                const timeElapsed = Date.now();
                const today = new Date(timeElapsed);

                console.log(today)
                
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                let log = document.createElement('div');
                    log.className = 'col t3';
                    log.innerText = momo + ' connect try';
                // log_div.appendChild(log);
                log_div.insertBefore(log,log_div.childNodes[0]);

            },
            success: function(response) {
                // 處理服務器返回的響應
                console.log(response);
                let momo = moment().format('YYYY/MM/DD HH:mm:ss A');
                if(response.result == true){
                    let log = document.createElement('div');
                    log.className = 'col t3';
                    log.innerText = momo + ' connect success';
                    // log_div.appendChild(log);
                    log_div.insertBefore(log,log_div.childNodes[0]);
                }else{
                    let log = document.createElement('div');
                    log.className = 'col t3';
                    log.innerText = momo + ' connect fail';
                    // log_div.appendChild(log);
                    log_div.insertBefore(log,log_div.childNodes[0]);
                }
                let divElement = document.getElementById('connect_log');
                // Scroll to the bottom of the div
                divElement.scrollTop = divElement.scrollHeight;

            },
            complete: function(XHR, TS) {
                XHR = null;
                console.log("connect_test 執行完成");
            },
            error: function(xhr, status, error) {
                // console.log("fail");
            }
        });
    }

    function save_setting(argument) {
        let formData = {};
        formData.OK_red_light = +document.getElementById("OK_Red").checked;
        formData.OK_green_light = +document.getElementById("OK_Green").checked;
        formData.OK_yellow_light = +document.getElementById("OK_Yellow").checked;
        formData.OK_buzzer = +document.getElementById("OK_Buzzer").checked;
        formData.OK_time = +document.getElementById("OK_time").value;

        formData.NG_red_light = +document.getElementById("NG_Red").checked;
        formData.NG_green_light = +document.getElementById("NG_Green").checked;
        formData.NG_yellow_light = +document.getElementById("NG_Yellow").checked;
        formData.NG_buzzer = +document.getElementById("NG_Buzzer").checked;
        formData.NG_time = +document.getElementById("NG_time").value;

        formData.OK_SEQ_red_light = +document.getElementById("OK_SEQ_Red").checked;
        formData.OK_SEQ_green_light = +document.getElementById("OK_SEQ_Green").checked;
        formData.OK_SEQ_yellow_light = +document.getElementById("OK_SEQ_Yellow").checked;
        formData.OK_SEQ_buzzer = +document.getElementById("OK_SEQ_Buzzer").checked;
        formData.OK_SEQ_time = +document.getElementById("OK_SEQ_time").value;

        formData.OKALL_red_light = +document.getElementById("OKALL_Red").checked;
        formData.OKALL_green_light = +document.getElementById("OKALL_Green").checked;
        formData.OKALL_yellow_light = +document.getElementById("OKALL_Yellow").checked;
        formData.OKALL_buzzer = +document.getElementById("OKALL_Buzzer").checked;
        formData.OKALL_time = +document.getElementById("OKALL_time").value;

        formData.ERROR_red_light = +document.getElementById("ERROR_Red").checked;
        formData.ERROR_green_light = +document.getElementById("ERROR_Green").checked;
        formData.ERROR_yellow_light = +document.getElementById("ERROR_Yellow").checked;
        formData.ERROR_buzzer = +document.getElementById("ERROR_Buzzer").checked;
        formData.ERROR_time = +document.getElementById("ERROR_time").value;

        console.log(formData);
        $.ajax({
            url: '?url=Equipments/TowerLightSetting', // 
            // async: false,
            method: 'POST',
            data: formData ,
            dataType: "json",
            success: function(response) {
                // 處理服務器返回的響應
                // isSendingRequest = false;
                if(response){
                    alert('save success');
                }else{
                    alert('save fail')
                }
            },
            complete: function(XHR, TS) {
                XHR = null;
                console.log("connect_test 執行完成");
            },
            error: function(xhr, status, error) {
                // console.log("fail");
            }
        });
    }

    function initial() {

        <?php 
            foreach ($data['TowerLightSetting'] as $key => $value) {
                if($value['light_event_id'] == 0){
                    echo 'let NG_Red = '. $value['red_light'].';';
                    echo 'let NG_Green = '. $value['green_light'].';';
                    echo 'let NG_Yellow = '. $value['yellow_light'].';';
                    echo 'let NG_Buzzer = '. $value['buzzer'].';';
                    echo 'let NG_time = '. $value['pulse_time'].';';
                }
                if($value['light_event_id'] == 1){
                    echo 'let OK_Red = '. $value['red_light'].';';
                    echo 'let OK_Green = '. $value['green_light'].';';
                    echo 'let OK_Yellow = '. $value['yellow_light'].';';
                    echo 'let OK_Buzzer = '. $value['buzzer'].';';
                    echo 'let OK_time = '. $value['pulse_time'].';';
                }
                if($value['light_event_id'] == 2){
                    echo 'let OKALL_Red = '. $value['red_light'].';';
                    echo 'let OKALL_Green = '. $value['green_light'].';';
                    echo 'let OKALL_Yellow = '. $value['yellow_light'].';';
                    echo 'let OKALL_Buzzer = '. $value['buzzer'].';';
                    echo 'let OKALL_time = '. $value['pulse_time'].';';
                }
                if($value['light_event_id'] == 3){
                    echo 'let OK_SEQ_Red = '. $value['red_light'].';';
                    echo 'let OK_SEQ_Green = '. $value['green_light'].';';
                    echo 'let OK_SEQ_Yellow = '. $value['yellow_light'].';';
                    echo 'let OK_SEQ_Buzzer = '. $value['buzzer'].';';
                    echo 'let OK_SEQ_time = '. $value['pulse_time'].';';
                }
                if($value['light_event_id'] == 4){
                    echo 'let ERROR_Red = '. $value['red_light'].';';
                    echo 'let ERROR_Green = '. $value['green_light'].';';
                    echo 'let ERROR_Yellow = '. $value['yellow_light'].';';
                    echo 'let ERROR_Buzzer = '. $value['buzzer'].';';
                    echo 'let ERROR_time = '. $value['pulse_time'].';';
                }
            }
        ?>

        document.getElementById("NG_Red").checked = +NG_Red;
        document.getElementById("NG_Green").checked = +NG_Green;
        document.getElementById("NG_Yellow").checked = +NG_Yellow;
        document.getElementById("NG_Buzzer").checked = +NG_Buzzer;
        document.getElementById("NG_time").value = NG_time;

        document.getElementById("OK_Red").checked = +OK_Red;
        document.getElementById("OK_Green").checked = +OK_Green;
        document.getElementById("OK_Yellow").checked = +OK_Yellow;
        document.getElementById("OK_Buzzer").checked = +OK_Buzzer;
        document.getElementById("OK_time").value = OK_time;

        document.getElementById("OKALL_Red").checked = +OKALL_Red;
        document.getElementById("OKALL_Green").checked = +OKALL_Green;
        document.getElementById("OKALL_Yellow").checked = +OKALL_Yellow;
        document.getElementById("OKALL_Buzzer").checked = +OKALL_Buzzer;
        document.getElementById("OKALL_time").value = OKALL_time;

        document.getElementById("OK_SEQ_Red").checked = +OK_SEQ_Red;
        document.getElementById("OK_SEQ_Green").checked = +OK_SEQ_Green;
        document.getElementById("OK_SEQ_Yellow").checked = +OK_SEQ_Yellow;
        document.getElementById("OK_SEQ_Buzzer").checked = +OK_SEQ_Buzzer;
        document.getElementById("OK_SEQ_time").value = OK_SEQ_time;

        document.getElementById("ERROR_Red").checked = +ERROR_Red;
        document.getElementById("ERROR_Green").checked = +ERROR_Green;
        document.getElementById("ERROR_Yellow").checked = +ERROR_Yellow;
        document.getElementById("ERROR_Buzzer").checked = +ERROR_Buzzer;
        document.getElementById("ERROR_time").value = ERROR_time;
    }


</script>

<style>

    .disabled {
        opacity: 0.5; 
        pointer-events: none; 
        cursor: not-allowed; 
    }


    /* The light_test */
    .light_test {
      display: block;
      position: relative;
      padding-left: 80px;
      padding-right: 10px;
      margin-bottom: auto;
      cursor: pointer;
      font-size: 22px;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      user-select: none;
    }

    /* Hide the browser's default checkbox */
    .light_test input {
      position: absolute;
      opacity: 0;
      cursor: pointer;
      height: 0;
      width: 0;
    }

    /* Create a custom checkbox */
    .checkmark {
      position: absolute;
      top: 0;
      left: 0;
/*      height: 25px;*/
/*      width: 25px;*/
      background-color: #eee;
      width: 70px;
      height: 30px;
      border: 1px solid #999999;
      border-radius: .25rem;
    }

    /* On mouse-over, add a grey background color */
    .light_test:hover input ~ .checkmark {
      background-color: #ccc;
    }

    /* When the checkbox is checked, add a blue background */
    .light_test input:checked ~ .checkmark {
      background-color: #00CCCC;
    }

    .light_test input:checked ~ .checkmark_red {
      background-color: red;
    }

    .light_test input:checked ~ .checkmark_green {
      background-color: green;
    }

    .light_test input:checked ~ .checkmark_yellow {
      background-color: #ffeb3b;
    }

    /* Create the checkmark/indicator (hidden when not checked) */
    .checkmark:after {
      content: "";
      position: absolute;
      display: none;
    }

    /* Show the checkmark when checked */
    .light_test input:checked ~ .checkmark:after {
      display: block;
    }

    /* Style the checkmark/indicator */
    .light_test .checkmark:after {
      left: 9px;
      top: 5px;
      width: 5px;
      height: 10px;
/*      border: solid white;*/
/*      border-width: 0 3px 3px 0;*/
      -webkit-transform: rotate(45deg);
      -ms-transform: rotate(45deg);
      transform: rotate(45deg);
    }

</style>
