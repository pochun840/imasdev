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
                            <div class="row t4">
                                <div class="col-3 t3"><?php echo $text['Status_text']; ?>:
                                    <label id="service_status_device" style="color: red; padding-left: 5%"> <?php echo $text['Offline_text']; ?>/<?php echo $text['Online_text']; ?></label>
                                </div>
                                <div class="col">
                                    <button type="button" class="btn btn-Reconnect" id="runApp" onclick="connect_test_ktm()"><?php echo $text['Connect_Test_text']; ?></button>
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
            $.ajax({
                type: 'POST',
                url: '?url=Equipments/ktm_connect',
                dataType: 'json',
                success: function(response) {
                    // 显示返回的结果
                    $('#output').text(response.output || response.error);
                },
                error: function() {
                    $('#output').text('An error occurred while trying to run the command.');
                }
            });
        }

    </script>