<!-- Device GTCS Ediet Setting -->
    <div id="Ktm_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%">KTM - <?php echo $text['Setting_text']; ?></label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>

        <div class="main-content">
            <div class="center-content">
                <div class="container">
                    <div id="connectionContent" class="content ">
                        <div style="padding-left: 7%; padding: 50px">
                            <div>
                                <label style="font-size: 18px">
                                    <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                                    <b><?php echo $text['Test_adjust_text']; ?></b>
                                </label>
                            </div>
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
                                        <option value="9600" selected>19200</option>
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
                                        <option value="1" selected>1</option>
                                        <option value="2">2</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row t4">
                                <div class="col-3 t3"><?php echo $text['Status_text']; ?>:
                                    <label id="service_status_device_1" style="color: red; padding-left: 5%; display: block;"> <?php echo $text['Offline_text']; ?>/<?php echo $text['Online_text']; ?></label>
                                    <label id="service_status_device_2" style="color: green; padding-left: 5%; display: none;"> <?php echo $text['Offline_text']; ?>/<?php echo $text['Online_text']; ?></label>
                                </div>
                                
                                <div class="col">
                                    <button type="button" class="btn btn-Reconnect"  onclick="connect_test_ktm()"><?php echo $text['Connect_Test_text']; ?></button>
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

                    <!-- <button class="saveButton" id="saveButton" onclick="save_controller_ip()"><?php echo $text['Save_text']; ?></button> -->
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript">

       function connect_test_ktm() {
            var selectElement = document.getElementById('comport');
            var comport = selectElement.value;
            
            $.ajax({
                type: 'POST',
                url: '?url=Equipments/ktm_connect',
                data: { comport: comport },
                dataType: 'json',
                success: function(response) {
                    console.log(response); 
                    
                    // 处理输出
                    let message = response.result || response.error;
                    if (response.output) {
                        message += "\nOutput: " + response.output; // 添加 Node.js 输出
                    }
                    
                  
                    
                    // 隐藏 service_status_device_1
                    document.getElementById('service_status_device_1').style.display = 'none';
                    
                    // 显示 service_status_device_2
                    document.getElementById('service_status_device_2').style.display = 'block'; 
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("Error Status: " + textStatus); 
                    console.error("Error Thrown: " + errorThrown); 

                    // 隐藏 service_status_device_1
                    document.getElementById('service_status_device_1').style.display = 'none';
                    
                    // 显示 service_status_device_2
                    document.getElementById('service_status_device_2').style.display = 'block'; 
                }
            });

  
        }

    
    </script>