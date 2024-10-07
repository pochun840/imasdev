<?php require APPROOT . 'views/inc/header.tpl'; ?>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/operation.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/clickcircle.css" type="text/css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<?php echo $data['nav']; ?>
<style>
.t1{color: #14A800; background-color: #E8F9F1; border-radius: 10px; padding-right: 5%; padding: 0 5px; }
.t2{color: #555555; background-color: #DDDDDD; border-radius: 10px; padding: 0 5px}

.t3{font-size: 5vmin; margin-top: 3%; padding-left: 5%}                 /* target_torque */
.t4{height: 18px; width: 21px; margin-top: 5px; margin-right: 80px;}    /* img hi lo */
.t5{margin-right: 2px;margin-top: 5px}                                 /* Hi Torque & Hi Angle */

.t6{float: left; height: 25px; width: 25px; margin-right: 5px; margin-top: 5px}  /* Sensor icon */
.t7{font-size: 20px; margin: 3px 0px; display: flex; align-items: center;}


</style>
<div class="container-ms">

    <header>
        <div class="operation">
            <img id="header-img" src="./img/operation-head.svg"><?php echo $text['main_operation_text']; ?>
        </div>

        <div class="notification">
            <i style=" width:auto; height: 40px;" class="fa fa-bell" onclick="ClickNotification()"></i>
            <span id="messageCount" class="badge"></span>
        </div>
        <div class="personnel"><i style=" width:auto; height: 40px" class="fa fa-user"></i> <?php echo $_SESSION['user']; ?></div>

        <div class="ipconnection">
            <i style=" width:auto; height: 40px" class="fa fa-desktop"></i> <?php echo $_SERVER['SERVER_ADDR']; ?>
        </div>

        <div style="display: none;">
            <input id="job_id" value="<?php echo $data['job_id']; ?>" disabled>
            <input id="seq_id" value="<?php echo $data['seq_id']; ?>" disabled>
            <input id="task_id" value="<?php echo $data['task_id']; ?>" disabled>
            <input id="task_count" value="<?php echo $data['task_count']; ?>" disabled>
            <input id="total_seq_count" value="<?php echo $data['total_seq']; ?>" disabled>
            <input id="max_seq_id" value="<?php echo $data['max_seq_id']; ?>" disabled>
            <input id="modbus_switch" value="1" >
            <input id="tool_status" value="-1" > 
        </div>
      

        <div id="task_coordinate" style="display:none;">
            <?php foreach ($data['task_list'] as $key => $task){
                echo '<input id="task_'.$task['task_id'].'_enable_arm" value="'.$task['enable_arm'].'">';
                echo '<input id="task_'.$task['task_id'].'_x" value="'.$task['position_x'].'">';
                echo '<input id="task_'.$task['task_id'].'_y" value="'.$task['position_y'].'">';
                echo '<input id="task_'.$task['task_id'].'_tolerance" value="'.$task['tolerance'].'">';
                echo '<input id="task_'.$task['task_id'].'_gtcs_job_id" value="'.$task['gtcs_job_id'].'">';
                echo '<input id="task_'.$task['task_id'].'_hole_id" value="'.$task['hole_id'].'">';

                echo '<input id="task_'.$task['task_id'].'_targettype" value="'.$task['last_targettype'].'">'; //targettype
                if($task['last_targettype'] == 1){// angle
                    echo '<input id="task_'.$task['task_id'].'_target_value" value="'.$task['last_step_targetangle'].'">'; //target torque
                    echo '<input id="task_'.$task['task_id'].'_target_hi" value="'.$task['last_step_highangle'].'">'; //hi angle
                    echo '<input id="task_'.$task['task_id'].'_target_lo" value="'.$task['last_step_lowangle'].'">'; //lo angle
                }else{// torque
                    echo '<input id="task_'.$task['task_id'].'_target_value" value="'.$task['last_step_targettorque'].'">'; //target torque
                    echo '<input id="task_'.$task['task_id'].'_target_hi" value="'.$task['last_step_hightorque'].'">'; //hi torque
                    echo '<input id="task_'.$task['task_id'].'_target_lo" value="'.$task['last_step_lowtorque'].'">'; //lo torque
                    echo '<input id="task_'.$task['task_id'].'_last_target_value" value="'.$task['last_step_targettorque'].'">'; //target torque
                    echo '<input id="task_'.$task['task_id'].'_last_target_hi" value="'.$task['last_step_hightorque'].'">'; //hi torque
                    echo '<input id="task_'.$task['task_id'].'_last_target_lo" value="'.$task['last_step_lowtorque'].'">'; //lo torque
                }
            }?>
            <?php foreach ($data['button_auth'] as $key => $value) {
                echo '<input id="button_auth_'.$key.'" value="'.$value.'">';
            }?>
            <?php 
                echo '<input id="stop_on_ng" value="'.$data['seq_data']['ng_stop'].'">';
            ?>

        </div>
        <!-- for sensor position or status -->
        <div style="display:none;">
            <input id="arm_status" value="0" disabled>
            <input id="arm_x" value="" disabled>
            <input id="arm_y" value="" disabled>
            <input id="socket_tray_status" value="1" disabled>
            <input id="socket_tray" value="" disabled>
            <input id="color_light_status" value="" disabled>
            <input id="color_light_ok" value="" disabled>
            <input id="color_light_ng" value="" disabled>
            <input id="color_light_ok_sequence" value="" disabled>
            <input id="color_light_ok_all" value="" disabled>
            <input id="buzzer_status" value="" disabled>
        </div>

    </header>

    <!-- Notification -->
    <div id="messageBox" class="messageBox" style="display: none;">
        <div class="topnav-message">
            <label type="text" style="font-size: 24px; padding-left: 3%; margin: 7px 0; color: #000"><b>Notification</b></label>
            <span class="close w3-display-topright" onclick="ClickNotification()">&times;</span>
        </div>
        <div class="scrollbar-message" id="style-message">
            <div class="force-overflow-message">
                <div style="padding: 0 10px; padding-bottom: 20px">
                    <div id="EquipmentWarning" style="font-size: 18px">
                        <a><b>Equipment Warning</b></a>
                        <a style="float: right">11m</a>
                    </div>
                    <div id="EW-Mess" style="font-size: 15px; padding-bottom: 5px" class="checkboxFour">
                        <a>recycle box: a-111s2 is reached the <br> threshold count for <a style="color: red">80%</a>. please reset recycle box.</a>
                        <a style="float: right; margin: 5px;">
                            <input type="checkbox" value="1" id="checkboxFourInput" name="" hidden="hidden" checked="checked">
                            <label for="checkboxFourInput"></label>
                        </a>
                    </div>
                    <div>
                        <label class="t1">Recycle box</label>
                        <label class="t2">workstation 3</label>
                    </div>
                </div>

                <div style="padding: 0 10px; padding-bottom: 20px">
                    <div id="EquipmentRecovery" style="font-size: 18px">
                        <a><b>Equipment recovery</b></a>
                        <a style="float: right">1m</a>
                    </div>
                    <div id="ER-Mess" style="font-size: 15px; padding-bottom: 5px" class="checkboxFour">
                        <a>recycle box: a-111s2 is clear the threshold count.</a>
                        <a style="float: right; margin: 5px;">
                            <input type="checkbox" value="1" id="checkboxFourInput" name="" hidden="hidden" checked="checked">
                            <label for="checkboxFourInput"></label>
                        </a>
                    </div>
                    <div>
                        <label class="t1">Recycle box</label>
                        <label class="t2">workstation 3</label>
                    </div>
                </div>

                <div style="padding: 0 10px; padding-bottom: 20px">
                    <div id="EquipmentRecovery" style="font-size: 18px">
                        <a><b>Equipment Warning</b></a>
                        <a style="float: right">2h</a>
                    </div>
                    <div id="ER-Mess" style="font-size: 15px; padding-bottom: 10px" class="checkboxFour">
                        <a>Controller:GTCS has............</a>
                        <a style="float: right; margin: 5px;">
                            <input type="checkbox" value="1" id="checkboxFourInput" name="" hidden="hidden" checked="checked">
                            <label for="checkboxFourInput"></label>
                        </a>
                    </div>
                    <div>
                        <label class="t1">Recycle box</label>
                        <label class="t2">workstation 3</label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Virtual Message -->
    <div id="VirtualMessage" class="virtual-message" style="display: none; vertical-align: middle;">
        <div class="topnav">
            <label type="text" style="font-size: 20px; padding-left: 3%; margin: 7px 0"><b>Virtual Message</b></label>
            <span class="close w3-display-topright" onclick="ClickVirtualMessage()">&times;</span>
        </div>
        <div class="scrollbar-Message_text" id="style-Message_text">
            <div class="force-overflow_Message_text">
                <div id="Message_text" style="padding-left: 6%">
                    <form action="">
                        <textarea id="w3review" name="w3review" rows="4" cols="40">
                            <?php echo $data['task_message_list'][$data['task_id']]['text'];?>
                        </textarea>
                    </form>
                </div>
                <div style="padding-left: 6%;">
                    <?php $img = empty($data['task_message_list'][$data['task_id']]['img']) ? './img/message.svg' : $data['task_message_list'][$data['task_id']]['img']; ?>
                    <img src="<?php echo htmlspecialchars($img); ?>" style="height: 250px; width: 300px" alt="Nature">
                </div>
            </div>
        </div>
        <label style="bottom:0px; float:right; color:red; margin-right: 5px; padding: 5px"></label>
    </div>



    <!-- Identity Verify -->
    <div id="IdentityVerify" class="identity-verify" style="display: none;vertical-align: middle;">
        <div class="topnav">
            <label type="text" style="font-size: 20px; padding-left: 3%; margin: 7px 0"><b><?php echo $text['Identity_verify_text']; ?></b></label>
            <span class="close w3-display-topright" onclick="toggleIdentityVerify()">&times;</span>
        </div>
        <div class="w3-center identity-input">
            <input id="verify_action" type="text" name="" value="" style="display:none;">
            <form id="verify_form" action="javascript:void(0);" onsubmit="call_job_check()">
            <label style="text-align: center; font-size: 18px"><?php echo $text['Enter_identity_text']; ?></label>
            <input type="password" class="form-control" id="id_verify" maxlength="" value="">
            <input class="VerifyButton" type="submit" name="" value="<?php echo $text['Verify_text']; ?>" style="width:auto;float: right;">
            </form>
        </div>
        <!-- <button class="VerifyButton" id="VerifyButton">Verify</button> -->
    </div>

    <div class="main-content">
        <div class="operation_setting">
            <div class="img_task">
                <div class="column" style="width: 60%;">
                    <div class="center-content">
                        <div id="img-container" class="img">
                            <?php
                                if( !empty($data['task_list'] )){
                                    // echo $data['task_list'][count($data['task_list'])-1]['circle_div'];

                                    echo '<img id="imgId" src="'.$data['seq_img'].'">';
                                    foreach ($data['task_list'] as $key => $value) {
                                        echo '<div class="circle" data-id="'.($key+1).'" '.$value['circle_div'].'>';
                                        echo '<span class="">'.($key+1).'</span>';
                                        echo '<div class="circle-border"></div>';
                                        echo '</div>';
                                    }
                                }

                            ?>
                        </div>
                        <div class="btn-menu">
                            <button id="" class="btn-previous" onclick="function_auth_check('back_seq')">&#10094;</button>
                            <button id="" class="btn-seq-list" onclick="function_auth_check('change_seq')">&#9776;</button>
                            <button id="" class="btn-next" onclick="function_auth_check('skip_seq')">&#10095;</button>
                        </div>
                    </div>
                </div>

                <div class="column" style="width: 40%">
                    <div id="task-setting" style=" height: 445px">
                        <div class="row" style="padding: 0 20px">
                            <label class="col-3 t7" style="margin: 2px 2px"><?php echo $text['Job_Name_text']; ?>:</label>
                            <div class="col-6" style="margin: 2px 2px">
                                <input id="job_name" type="text" class="form-control" disabled="disabled" style="font-size: 1.8vmin; background-color: #DDDDDD; height: 28px; border: 0">
                            </div>
                            <div class="col" style="margin: 2px 2px">
                                <button class="btn-calljob" type="button" style="vertical-align: sub;font-size: 1.5vmin;" onclick="function_auth_check('change_job')"><?php echo $text['Call_Job_text']; ?></button>
                            </div>
                            <label class="col-3 t7" style="margin: 2px 2px"><?php echo $text['Seq_Name_text']; ?>:</label>
                            <div class="col-6" style="margin: 2px 2px">
                                <input id="seq_name" type="text" class="form-control"  disabled="disabled" style="font-size: 1.8vmin; background-color: #DDDDDD; height: 28px; border: 0" >
                            </div>

                        </div>
                        <div class="row" style="padding: 0 20px">
                            <label class="col-3 t7" style="margin: 2px 2px"><?php echo $text['barcode_text']; ?>:</label>
                            <div class="col" style="margin: 2px 2px">
                                <input id="barcode" type="password" class="form-control" placeholder="" style="font-size: 1.5vmin;height: 28px;">
                            </div>
                        </div>

                        <div class="scrollbar-tasklist" id="style-tasklist">
                            <div class="force-overflow-tasklist">
                                <div id="task_list" class="tasklist">
                                  
                                </div>
                            </div>
                        </div>
                        <div class="row" style="font-size: 18px;padding: 0 20px;">
                            <div class="col-6" style="padding-left: 40%; margin: 3px"><?php echo $text['Task_text']; ?></div>
                                <div class="col-4">
                                    <input id="task_serail" type="text" class="form-control" placeholder="" disabled>
                                    <input id="task_time" type="text" class="form-control" hidden="hidden" style="font-size: 2vmin; background-color: #DDDDDD;">
                                </div>
                                <div class="col">
                                    <button class="btn-secondary" type="submit" onclick="function_auth_check('reset_task')">&#8635;</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            <div class="target_sensor">
                <!-- Target Setting -->
                <div class="column column-target">
                    <div class="row target_style">
                        <div id="Torque" class="w3-display-container" style="font-size: 18px">
                            <div id="target_torque2" class="t3 w3-display-topleft text-black"></div>
                            <div class="w3-display-left text-black" style="font-size: 18px; margin-top: 7%; padding-left: 7%">Nm</div>

                            <div class="t4 w3-display-topright"><img src="./img/hi.png"></div>
                            <div class="w3-display-right"><img src="./img/Ellipse.png" style="height: 20px; width: 20px; margin-right: 80px"></div>
                            <div class="w3-display-bottomright"><img src="./img/lo.png" style="margin-bottom: 5px;margin-right: 80px"></div>

                            <div class="t5 w3-display-topright">
                                <input id="high_torque" type="text" size="4" placeholder="" value="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: right">
                            </div>
                            <div class="t5 w3-display-right">
                                <input id="target_torque" type="text" size="4" placeholder="" value="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: right">
                            </div>
                            <div class="t5 w3-display-bottomright">
                                <input id="low_torque" type="text" size="4" placeholder="" value="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: right">
                            </div>
                        </div>
                    </div>
                    <div class="row target_style">
                        <div id="Thread" class="w3-display-container" style="font-size: 18px">
                            <div id="target_angle2" class="t3 w3-display-topleft text-black"></div>
                            <div class="w3-display-left text-black" style="font-size: 18px; margin-top: 7%; padding-left: 7%">deg</div>

                            <div class="t4 w3-display-topright"><img src="./img/hi.png"></div>
                            <div class="w3-display-right"><img src="./img/Ellipse.png" style="height: 20px; width: 20px; margin-right: 80px"></div>
                            <div class="w3-display-bottomright"><img src="./img/lo.png" style="margin-bottom: 5px;margin-right: 80px"></div>

                            <div type="text" class="t5 w3-display-topright">
                                <input id="high_angle" size="4" type="text" placeholder="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: right">
                            </div>
                            <div class="t5 w3-display-right">
                                <input id="target_angle" size="4" type="text" placeholder="" value="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: right">
                            </div>
                            <div class="t5 w3-display-bottomright">
                                <input id="low_angle" size="4" type="text" placeholder="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: right">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="column column-target" style="margin-right: 20px">
                    <div id="tightening_status_div" class="row target_style" style="background-color: #7ECA86;">
                        <div class="w3-display-container" style="font-size: 5vmin">
                            <div id="tightening_status" class="w3-display-middle"></div>
                        </div>
                    </div>
                    <div class="row target_style">
                        <div class="">
                            <span><?php echo $text['TR_text']; ?> :</span>&nbsp;
                            <input id="tightening_repeat" size="3" type="text" placeholder="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: center">
                        </div>
                        <div class="">
                            <span><?php echo $text['Job_Time_text']; ?> :</span>&nbsp;
                            <input id="tightening_time" size="5" type="text" placeholder="" disabled="disabled" style="background-color: #B5BBBE; border: none; text-align: center"> ms
                        </div>
                        <div id="error1" class=""><?php echo $text['Error_text']; ?> : </div>
                        <div id="error2" class=""><?php echo $text['Error_text']; ?> :</div>
                    </div>
                </div>

                <!-- Sensor Setting -->
                <div class="column column-sensor" style="margin-left: 3%">
                    <div class="row">
                        <div id="screw_info_div" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left"><?php echo $text['Screw_info_text']; ?></h5>
                            <label style="color: green; font-size: 2.5vmin;">
                                <b><span id="screw_info" style="margin-bottom: 10px"></span></b>
                                <span onclick="function_auth_check('stop_on_ng')"><img src="./img/screw-reset.png" style="margin-left: 10%; height: 25px; width: 25px; margin-bottom: 10px"></span>
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div id="tool_div" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; text-align: left;">
                                <img class="t6 images" src="./img/torque.png"><?php echo $text['Tool_text']; ?> :<span id="tool_name" style="padding-left:5%">SGT-CS303</span>
                            </h5>
                            <div id="completedIcon" style="display:block; text-align: left;padding-left: 31px">
                                <span id="tool_task_id" style="color: #000"></span>
                                <span id="tool_status_icon"></span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div id="picking module" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left"><?php echo $text['Picking_Module_text']; ?></h5>
                        </div>
                    </div>
                </div>
                <div class="column column-sensor">
                    <div class="row">
                        <div id="arm_div" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">
                                <img class="t6 images" src="./img/operation-arm.svg" style="">
                                <?php echo $text['Arm_text']; ?>
                            </h5>
                            <label style="color: #FFFF00; font-size: 2.5vmin; text-align: left; padding-left: 25px">
                                <b><span id="coordinate"></span></b>
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div id="socket_tray_div" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">
                                <img class="t6 images" src="./img/socket-tray.png"><?php echo $text['Socket_Tray_text']; ?>
                            </h5>
                            <div class="row">
                                <div>
                                    <input id="socket_hole_number" size="1" style="text-align: center; border-radius: 40%; border: 1px solid;border-color: green;" value="" disabled >
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div id="screw_feeder" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">
                                <?php echo $text['Screw_Feeder_text']; ?>
                            </h5>
                            <label style="font-size: 1.8vmin; text-align: left; padding-left: 25px">
                                <span id="screwfeeder_count"><?php echo $text['Count_text']; ?> : 100</span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="column column-sensor">
                    <div class="row">
                        <div id="recycle_box" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">
                                <?php echo $text['Recycle_box_text']; ?>
                            </h5>
                            <label style="font-size: 1.8vmin; text-align: left; padding-left: 25px">
                                <span id="recyclebox_count"><?php echo $text['Count_text']; ?> : 100</span>
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div id="" class="row sensor_style">
                            <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">
                                <?php echo $text['Button_text']; ?>
                            </h5>
                            <div class="custom-checkbox">
                                <input type="checkbox" id="" name="">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="row sensor_style">
                            <div id="" class=""></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Call Job -->
            <div id="change_job" class="modal" style="top: 12%; left: 40%">
                <form class="w3-modal-content w3-animate-zoom" action="" style="width: 250px;box-shadow: 0 3px 7px 1px #AAA; ">
                    <div class=" w3-light-grey">
                        <header class=" w3-container modal-header">
                            <span onclick="document.getElementById('change_job').style.display='none'"
                            class="w3-button w3-dark-grey w3-display-topright" style="margin: 0px; height: 48px; width: 45px">&times;</span>
                            <div style="text-align:center; font-size: 20px; color: #000"><?php echo $text['Job_List_text']; ?></div>
                        </header>
                        <table id="job_list" style="margin: 5px 10px 0px;width: 100%; height: 80px">
                            <tr>
                                <td style=" text-align: center; ">
                                    <select style="font-size: larger; width: 180px" id="Change_Job_Id">
                                    <?php
                                        foreach ($data['job_list'] as $key => $job) {
                                            echo '<option value="'.$job['job_id'].'">'.$job['job_name'].'</option>';
                                        }
                                    ?>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-primary" onclick="change_job(1);"><?php echo $text['OK_text']; ?></button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Sequence Select Modal -->
            <div id="SeqSelect" class="modal" style="top: 28%; left: 10%">
                <form class="w3-modal-content w3-animate-zoom" action="" style="width:280px; height: 150px">
                    <div class=" w3-light-grey">
                        <header class=" w3-container modal-header">
                            <span onclick="document.getElementById('SeqSelect').style.display='none'"
                            class="w3-button w3-dark-grey w3-display-topright" style="margin: 0px; height: 48px; width: 45px">&times;</span>
                            <div style="text-align:center; font-size: 20px; color: #000"><?php echo $text['Seq_List_text']; ?></div>
                        </header>
                        <table id="seq_list" style="margin: 5px 10px 0px">
                            <tr>
                                <td align="left"><?php echo $text['Total_Seq_text']; ?> :
                                    <input style="text-align: center; margin-bottom: 2%" id="RecordCnt" name="RecordCnt" readonly="readonly" disabled size="3" maxlength="3" value="<?php echo $data['total_seq']; ?>">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select style="margin: center" id="SeqNameSelect" name="SeqNameSelect" size="5">
                                         <?php foreach ($data['seq_list'] as $key => $seq) {
                                            echo "<option value=".$seq['seq_id'].">{$seq['seq_id']} &nbsp;{$seq['seq_name']}</option>";
                                        } ?>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <div class="modal-footer justify-content-center">
                             <button type="button" class="btn btn-primary" onclick="change_seq('')" ><?php echo $text['OK_text']; ?></button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>

<!--
    <footer class="footer">
        <div id="screw_info_div" class="column">
            <div class="zoom">
                <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">Screw info</h5>
                <label style="color: green; font-size: 2.8vmin;"><b><span id="screw_info"></span></b></label>
           </div>
        </div>

        <div id="arm_div" class="column">
            <div class="zoom" style="">
                <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left"><img class="images" src="./img/operation-arm.svg" style="float: left">ARM</h5>
                <label style="color: #FFFF00; font-size: 2.5vmin; text-align: left;padding-left: 31px"><b><span id="coordinate"></span></b></label>
            </div>
        </div>

        <div id="tool_div" class="column" onclick="completeTask()">
            <div class="zoom" style="">
                <h5 style="font-size: 2.3vmin; text-align: left;">
                    <img class="images" src="./img/torque.png" style="float: left; height: 20px;">Tool<br><span id="tool_name" style="padding-left:3px">SGT-CS303</span>
                </h5>
                <div id="completedIcon" style="display:block; text-align: left;padding-left: 31px">
                    <span id="tool_task_id" style="color: #000"></span>
                    <span id="tool_status_icon">
                    </span>
                </div>
            </div>
        </div>

        <div id="socket_tray_div" class="column">
            <div class="zoom">
                <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left"><img class="images" src="./img/socket-tray.png" style="float: left">Socket tray</h5>
            </div>
        </div>

        <div id="picking_module" class="column">
            <div class="zoom">
                <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left"><img class="images" src="./img/picking-module.png" style="float: left; height: 20px; width: 30px">Picking module</h5>
            </div>
        </div>

        <div id="screw_feeder_div" class="column">
            <div class="zoom">
                <h5 style="font-size: 2.3vmin; line-height: 30px; text-align: left">Screw feeder</h5>
            </div>
        </div>
    </footer>
-->
</div>
<style>
#completedIcon
{
    display: none;
    color: #2A7E54;
}
</style>


<script>
// Get the modal
var modal = document.getElementById('SeqSelect');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>



<script type="text/javascript">



$(document).ready(function () {
    initail();
    //img帶入
    
});

</script>










</script>

<style>
    .running {
/*      width: 200px;*/
/*      height: 200px;*/
      background-color: #00bcd400;
      color: black;
      border-color: #44d0ff !important;
      border: 2px dashed #000;
      display: flex;
      justify-content: center;
      align-items: center;
      animation: container-rotate 2s linear infinite;
    }

    .inner-text {
      transform: rotate(0deg);
      animation: no-rotate 2s linear infinite;
    }

    /* OK */
    .finished {
      background-color: green !important;
      color: black;
      border: none;
    }

    /* OK-SEQ */
    .finished_seq {
      background-color: #FFCC00 !important;
      color: black;
      border: none;
    }

    /* OK-JOB */
    .finished_job {
      background-color: #FFCC00 !important;
      color: black;
      border: none;
    }



    .waitting {

    }

    .ng {
      background-color: red !important;
      color: black;
      border: none;
    }

    @keyframes no-rotate {
      0% {
        transform: rotate(-0deg);
      }
      100% {
        transform: rotate(-360deg);
      }
    }

    @keyframes container-rotate {
      0% {
        transform: rotate(0deg) scale(1.2);
      }
      50% {
        transform: rotate(180deg) scale(1.5);
      }
      100% {
        transform: rotate(360deg) scale(1.2);
      }
    }

    .gray-out {
      pointer-events: none;
      opacity: 0.5;
    }

</style>

<style>
/*調整 circle的顯示size*/
.circle{
    scale:<?php echo (1 + 1*($data['job_data']['point_size']/100) );?>;
}
</style>



<?php require APPROOT . 'views/inc/footer.tpl'; ?>

<script>
function function_auth_check(action) {
    document.getElementById('verify_action').value = action;
    if(action == 'change_job'){
      verify_action('change_job');
        
    }
    
}


function verify_action(action) {
    if(action == 'change_job'){
        document.getElementById('change_job').style.display='block';
    }
    
}



function change_job(seq_id,direction=''){
    let job_id = document.getElementById('Change_Job_Id').value
    // let seq_id = 1;
    $.ajax({
        type: "POST",
        url: '?url=Operations/Change_Job',
        timeout: 3000,
        data: { 'job_id': job_id,'seq_id': seq_id ,'direction': direction },
    }).done(function(response) { //成功且有回傳值才會執行
        
        history.go(0);
    });
}


function barcode_change_job(argument) {
    let barcode = document.getElementById('barcode').value

    $.ajax({
        url: '?url=Operations/Barcode_ChangeJob', // 指向服務器端檢查更新的 PHP 腳本
        method: 'POST',
        data: { 'barcode': barcode },
        dataType: "json"
    }).done(function(response) { //成功且有回傳值才會執行
        if(response.result == 'yes'){
            history.go(0);
        }
        barcode_input.value = '';
    });
}

var barcode_input = document.getElementById("barcode");

barcode_input.addEventListener("keypress", function(event) {
  // If the user presses the "Enter" key on the keyboard
  if (event.key === "Enter") {
    // Cancel the default action, if needed
    event.preventDefault();
    // Trigger the button element with a click
    barcode_change_job();
    // function_auth_check('barcode')
    // alert(document.getElementById('barcode').value)
    
  }
});



</script>
