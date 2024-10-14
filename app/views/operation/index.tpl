<?php require APPROOT . 'views/inc/header.tpl'; ?>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/operation.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/clickcircle.css" type="text/css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<?php echo $data['nav']; ?>
<style>
.t1{color: #14A800; background-color: #E8F9F1; border-radius: 10px; padding-right: 5%; padding: 0 5px;}
.t2{color: #555555; background-color: #DDDDDD; border-radius: 10px; padding: 0 5px}

.t3{font-size: 5vmin; margin-top: 3%; padding-left: 5%}                 /* target_torque */
.t4{height: 18px; width: 21px; margin-top: 5px; margin-right: 80px;}    /* img hi lo */
.t5{margin-right: 2px;margin-top: 5px}                                 /* Hi Torque & Hi Angle */

.t6{float: left; height: 25px; width: 25px; margin-right: 5px; margin-top: 5px}  /* Sensor icon */
.t7{font-size: 20px; margin: 3px 0px; display: flex; align-items: center;}

</style>

<?php 
    
    //判斷 $data['seq_list'] 有幾筆 
    if(!empty($data['total_seq'] )){

        if($data['total_seq'] == 1){
            $new_index_seq = 0;
            $data['ok_sequence'] =  $data['seq_list'][0]['ok_sequence'];
        }else{

            #陣列重整  key值 用  $vv['seq_id'] 取代      
            $temp = array();
            foreach($data['seq_list'] as $kk =>$vv){
                $temp[$vv['seq_id']]= $vv;
            }
            $data['ok_sequence'] = $temp[$data['seq_id']]['ok_sequence'];

        } 

    }
   
    
?>
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
            <input id="last_sn" value="<?php echo $data['last_sn']; ?>" > 
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
        <div class="scrollbar-Message_text">
            <div class="force-overflow_Message_text">
                <div id="Message_text" style="padding-left: 6%" align="center">
                    <form action="">
                        <textarea id="w3review" name="w3review" rows="4" cols="0">
                        </textarea>
                    </form>
                </div>
                <div style="padding-left: 6%;" >
                    <video id="myvideo" width="250" height="300" controls autoplay muted style="display: none";>
                        <source id="video_source" src="" type="video/mp4">
                    </video> 
                    <img id="myimage" src="" style="height: 250px; width: 300px; display: none;">  
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
                                <input id="barcode" type="password" class="form-control" placeholder="<?php echo $data['barcode']; ?>" style="font-size: 1.5vmin;height: 28px;">
                            </div>
                        </div>

                        <div class="scrollbar-tasklist" id="style-tasklist">
                            <div class="force-overflow-tasklist">
                                <div id="task_list" class="tasklist">
                                    <?php
                                        echo '<ol class="ol">';
                                        foreach ($data['task_list'] as $key => $value) {
                                            // echo '<ol>';
                                            echo '<div>';
                                            if($value['last_targettype'] == 1){//angle
                                                echo '<a id="step'.$value['task_id'].'" ><img src="./img/angle.png" alt="" style="height: 25px; width: 25px; float: left"> | SGT-CS303 | '.$text['Step_text'].$value['last_step_count'].' | '.$value['last_step_name'].' | '.$value['last_step_targetangle'].'&ordm;</a>';
                                                echo '<div class="dropdown-content" id="target_torque-'.$value['task_id'].'" style="display:none;" step-id="'.$value['task_id'].'">';

                                                if($value['last_job_type'] == 'normal'){
                                                    echo '<div id="">Step1 '. $value['last_step_name'] .' | <span>'.$value['last_step_targetangle'].'&ordm;| Hi '.$value['last_step_highangle'].' | Lo '.$value['last_step_lowangle'].'</span></div>';
                                                }else{
                                                    foreach ($value['program'] as $key => $value) {
                                                        if($value['step_targettype'] == 1 ){//angle
                                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targetangle'].'&ordm;| Hi '.$value['step_highangle'].' | Lo '.$value['step_lowangle'].'</span></div>';
                                                        }else{
                                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targettorque'].'-Nm| Hi '.$value['step_hightorque'].' | Lo '.$value['step_lowtorque'].'</span></div>';
                                                        }
                                                    }
                                                }


                                            }else{//torque
                                                echo '<a id="step'.$value['task_id'].'" ><img src="./img/torque.png" alt="" style="height: 25px; width: 25px; float: left"> | SGT-CS303 | '.$text['Step_text'].$value['last_step_count'].' | '.$value['last_step_name'].' | '.$value['last_step_targettorque'].'-Nm</a>';
                                                echo '<div class="dropdown-content" id="target_torque-'.$value['task_id'].'" style="display:none;" step-id="'.$value['task_id'].'">';

                                                if($value['last_job_type'] == 'normal'){
                                                    echo   '<div id="">'.$text['Step_text'].'1 '. $value['last_step_name'] .' | <span>'.$value['last_step_targettorque'].'-Nm| Hi '.$value['last_step_hightorque'].' | Lo '.$value['last_step_lowtorque'].'</span></div>';
                                                }else{
                                                    foreach ($value['program'] as $key => $value) {
                                                        if($value['step_targettype'] == 1 ){//angle
                                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targetangle'].'&ordm;| Hi '.$value['step_highangle'].' | Lo '.$value['step_lowangle'].'</span></div>';
                                                        }else{
                                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targettorque'].'-Nm| Hi '.$value['step_hightorque'].' | Lo '.$value['step_lowtorque'].'</span></div>';
                                                        }
                                                    }
                                                }

                                            }
                                            echo    '</div>';
                                            echo '</div>';
                                            // echo '</ol>';
                                        }
                                        echo '</ol>';
                                    ?>
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
                            <div id="tightening_status" class="w3-display-middle">OK</div>
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
                                <b><span id="screw_info" style="margin-bottom: 10px">9/12</span></b>
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

<script>

    function completeTask()
    {
        var completedIcon = document.getElementById('completedIcon');
        completedIcon.style.display = 'block';
        completedIcon.style.fontSize = "3vmin";
    }

    // function updateParameters()
    // {

    //     var target_detail = document.getElementById('target_detail');
    //     if (target_detail.style.display === 'none')
    //     {
    //         target_detail.style.display = 'block';
    //     }
    //     else
    //     {
    //         target_detail.style.display = 'none';
    //     }

    // }

    function updateParameters(index)
    {
        var target_torque = document.getElementById('target_torque-'+index);
        var step = document.getElementById('step'+index);
        var last_step = document.getElementById('step'+ (index - 1 ) );

        let targettype = document.getElementById('task_'+index+'_targettype');
        let target_value = document.getElementById('task_'+index+'_target_value');
        let target_hi = document.getElementById('task_'+index+'_target_hi');
        let target_lo = document.getElementById('task_'+index+'_target_lo');

        //先關閉全部
        var Divs = document.querySelectorAll("div[id^='target_torque-']");
        Divs.forEach(function(div) {        
            div.style.display = 'none';
            // div.previousElementSibling.style.color = 'black';
            // div.previousElementSibling.style.backgroundColor = '#fff';
            div.classList.remove("seleted");
        });

        if (target_torque.style.display.trim() === 'none')
        {
            target_torque.style.display = 'block';
            // step.style.color = 'white';
            // step.style.backgroundColor = '#2A7E54';
            target_torque.classList.add("seleted");
        }
        else
        {
            target_torque.style.display = 'none';
            // step.style.color = 'black';
            // step.style.backgroundColor = '#fff';
            target_torque.classList.remove("seleted");
        }

        //index bg-color = #44d0ff => runnuing
        step.style.backgroundColor = '#44d0ff';

        //smaller index-1 bg-color = green => finished
        if(last_step != null){
            last_step.style.color = 'white';
            last_step.style.backgroundColor = 'green';
            last_step.style.borderColor = 'green';
        }

        console.log('task_'+index+'_targettype')
        console.log(targettype.value);
        console.log(target_hi.value);
        console.log(target_lo.value);
        console.log(target_value.value);
        if(targettype.value == 1){//angle
            document.getElementById('target_angle').innerHTML = target_value.value;
            document.getElementById('target_angle').value = target_value.value;
            document.getElementById('high_angle').value = target_hi.value;
            document.getElementById('low_angle').value = target_lo.value;
            document.getElementById('target_torque').innerHTML = 0;
            document.getElementById('target_torque').value = '';
        }else{//torque
            document.getElementById('target_torque').innerHTML = target_value.value;
            document.getElementById('target_torque').value = target_value.value;
            document.getElementById('high_torque').value = target_hi.value;
            document.getElementById('low_torque').value = target_lo.value;
            document.getElementById('target_angle').innerHTML = 0;
            document.getElementById('target_angle').value = '';
            document.getElementById('high_angle').value = 999999;
            document.getElementById('low_angle').value = 0;
        }

        document.getElementById('tool_task_id').innerHTML = 'Task'+index;
        // arm_status
        document.getElementById('arm_status').value = document.getElementById('task_'+index+'_enable_arm').value;

        //socket hole div
        if(document.getElementById('task_'+index+'_hole_id').value == '-1'){
            document.getElementById('socket_tray_div').classList.add('gray-out');
            document.getElementById('socket_hole_number').value = '';
        }else{
            document.getElementById('socket_hole_number').value = document.getElementById('task_'+index+'_hole_id').value;
            document.getElementById('socket_tray_div').classList.remove('gray-out');
        }

    }


</script>

<script type="text/javascript">
let isSendingRequest = false;
let isFulfilled = false; //前置條件是否滿足
let light_signal = false;
let right_position = false;

let job_singal;
let seq_sinal;
let total_seq;
let ct_seq_id;
let system_no;
let ng_auto;
let ok_auto;
let ok_job_auto;
let ok_seq_auto;

$(document).ready(function () {
    initail();
    //img帶入
    document.getElementById('imgId').src = '<?php echo $data['seq_img']; ?>';
});

function initail() {
    // body...
    document.getElementById('barcode').value = '';
    document.getElementById('job_name').value = '<?php echo $data['job_data']['job_name']; ?>';
    document.getElementById('seq_name').value = '<?php echo $data['seq_data']['seq_name']; ?>';
    // document.getElementById('task_time') = '';
    document.getElementById('tightening_status').innerHTML = '';
    document.getElementById('tightening_repeat').value = ' 0 / 1';
    document.getElementById('tightening_time').value = '0';
    document.getElementById('target_torque').innerHTML = '<?php echo $data['task_list'][0]['last_step_targettorque']; ?>';
    document.getElementById('high_torque').value = '<?php echo  $data['task_list'][0]['last_step_hightorque']; ?>';
    document.getElementById('low_torque').value = '<?php echo  $data['task_list'][0]['last_step_lowtorque']; ?>';
    document.getElementById('target_angle').innerHTML = '<?php echo  $data['task_list'][0]['last_step_targetangle']; ?>';
    document.getElementById('high_angle').value = '<?php echo  $data['task_list'][0]['last_step_highangle']; ?>';
    document.getElementById('low_angle').value = '<?php echo  $data['task_list'][0]['last_step_lowangle']; ?>';
    // document.getElementById('screw_info_div').value = '';
    document.getElementById('screw_info').innerHTML = ' - / ' + document.getElementById('stop_on_ng').value;
    // document.getElementById('arm_div').value = '';
    // document.getElementById('coordinate').innerHTML = '';
    // document.getElementById('tool_div').value = '';
    // document.getElementById('tool_name').innerHTML = '';
    document.getElementById('task_serail').value = '<?php echo $data['task_id'].'  /  '.$data['task_count'] ?>';
    // document.getElementById('task_list') = '';
    document.getElementById('task_time').value = 0;
    let task_id = document.getElementById('task_id').value;
    updateParameters(task_id);
    let aa = document.querySelector("div[data-id='"+task_id+"']");
    // aa.classList.add('running')
    aa.style.backgroundColor = '#44d0ff';
    aa.childNodes[1].classList.add('running');
    call_job();
    document.getElementById('Change_Job_Id').value = document.getElementById('job_id').value;
    document.getElementById('socket_hole_number').style.backgroundColor = 'transparent';

    job_singal = '<?php echo $data['job_data']['ok_job']; ?>'; //是否有ok-job的訊號
    seq_singal  = '<?php echo $data['new_seq_list'][$data['seq_id']]['ok_sequence']; ?>'; //是否有ok-seq的訊號
    total_seq  = '<?php echo $data['total_seq'];?>'; //seq的數量
    ct_seq_id  = '<?php echo $data['seq_id'];?>';//當前的seq_id 編號

    task_message_list = '<?php echo $data['jsonTaskMessageList']; ?>';
    task_message_list_nn = '<?php echo $data['jsonTaskMessageList']; ?>';

    ng_auto = '<?php echo $data['ng_auto']; ?>'; 
    ok_auto = '<?php echo $data['ok_auto'];?>';

    ok_job_auto = '<?php echo $data['ok_job_auto']; ?>'; 
    ok_seq_auto = '<?php echo $data['ok_seq_auto'];?>';
}
   
</script>

<!-- arm socket link -->
<script type="text/javascript">
    // const wsServer = 'ws://192.168.0.115:9527';
    const wsServer = 'ws://localhost:9527';
    const websocket = new WebSocket(wsServer);

    
    websocket.onopen = function (evt) {
        console.log("Connected to WebSocket server.");
        let random = Math.floor(Math.random() * 100) + 1;
        document.getElementById('arm_div').classList.remove('gray-out');
        // send(random);
    };

    websocket.onclose = function (evt) {
        console.log("Disconnected");
        //把arm div反灰 gray-out
        document.getElementById('arm_div').classList.add('gray-out');
    };

    websocket.onmessage = function (evt) {
        // console.log('Retrieved data from server: ' + evt.data);
        let axis = evt.data.split(',');
        coordinate(axis);
        // document.getElementById('axis_x').value = axis[0];
        // document.getElementById('axis_y').value = axis[1];
    };

    websocket.onerror = function (evt, e) {
        console.log('Error occured: ' + evt.data);
    };

    function coordinate(axis) {
        // 关节角度（以弧度表示）
        let theta1 = deg2rad(axis[0]/32767 * 360); // 第一个关节的角度（弧度）
        let theta2 = deg2rad(axis[1]/32767 * 360 + 180); // 第二个关节的角度（弧度）

        // 机械臂长度
        let L1 = 50; // 第一个关节到第二个关节的长度
        let L2 = 50; // 第二个关节到末端的长度

        // 计算末端执行器的位置
        let x = L1 * Math.cos(theta1) + L2 * Math.cos(theta1 + theta2);
        let y = L1 * Math.sin(theta1) + L2 * Math.sin(theta1 + theta2);


        let round_x = Math.round(x*100);
        let round_y = Math.round(y*100);
        // document.getElementById('coordinate').innerHTML = round_x+','+round_y+'['++']';

        let task_id = document.getElementById('task_id').value;

        let target_x = +document.getElementById('task_'+task_id+'_x').value;
        let target_y = +document.getElementById('task_'+task_id+'_y').value;
        let bias = +document.getElementById('task_'+task_id+'_tolerance').value;

        document.getElementById('coordinate').innerHTML = round_x+','+round_y+'['+bias+']';

        let arm_status = +document.getElementById('arm_status').value
        if (arm_status == 0) {
            right_position = true;
            return;
        }

        let modbus_switch = document.getElementById('modbus_switch').value;
        let current_tool_status = document.getElementById('tool_status').value;

        if(round_x >= target_x-bias && round_x<= target_x+bias && round_y >= target_y-bias && round_y<= target_y+bias){
            document.getElementById('coordinate').style.backgroundColor = 'green';
            right_position = true;
            // if(modbus_switch == 1 && current_tool_status == 0 && isSendingRequest == false){ //目前起子與要改變的狀態相反才發送
            //     // isSendingRequest = true;
            //     // websocket.send('enable');
            //     // isSendingRequest = false;
            //     console.log('send enable');
            //     right_position = true;
            //     // switch_tool(1);
            // }
        }else{
            document.getElementById('coordinate').style.backgroundColor = 'red';
            right_position = false;
            // if(modbus_switch == 1 && current_tool_status == 1 && isSendingRequest == false){ //目前起子與要改變的狀態相反才發送
            //     // isSendingRequest = true;
            //     // websocket.send('disable');
            //     // isSendingRequest = false;
            //     console.log('send disable');
            //     right_position = false;
            //     // switch_tool(0);
            // }
        }
    }

    function deg2rad(degrees) {
      return degrees * (Math.PI / 180);
    }

</script>

<!-- operation -->
<script type="text/javascript">

    const fasten_status = [
          { index: 0, status: "Initialize", color: "" },
          { index: 1, status: "Tool Ready", color: "" },
          { index: 2, status: "Tool running", color: "" },
          { index: 3, status: "Reverse", color: "" },
          { index: 4, status: "OK", color: "green" },
          { index: 5, status: "OK-SEQ", color: "" },
          { index: 4, status: "OK", color: "" },
          { index: 7, status: "NG", color: "red" },
          { index: 8, status: "NG Stop", color: "red" },
          { index: 9, status: "Setting", color: "" },
          { index: 10, status: "EOC", color: "" },
          { index: 11, status: "C1", color: "" },
          { index: 12, status: "C2", color: "" },
          { index: 13, status: "C4", color: "" },
          { index: 14, status: "C5", color: "" },
          { index: 15, status: "BS", color: "" },
        ];

    const error_message = [
        { index: 0, status: "NO Error", color: "" },
        { index: 1, status: "<?php echo $error_message['ERR_CONT_TEMP'] ?>", color: "" },
        { index: 2, status: "<?php echo $error_message['ERR_MOT_TEMP'] ?>", color: "" },
        { index: 3, status: "<?php echo $error_message['ERR_MOT_CURR'] ?>", color: "" },
        { index: 4, status: "<?php echo $error_message['ERR_MOT_PEAK_CURR'] ?>", color: "" },
        { index: 5, status: "<?php echo $error_message['ERR_HIGH_TORQUE'] ?>", color: "" },
        { index: 6, status: "<?php echo $error_message['ERR_DEADLOCK'] ?>", color: "" },
        { index: 7, status: "<?php echo $error_message['ERR_PROC_MINTIME'] ?>", color: "" },
        { index: 8, status: "<?php echo $error_message['ERR_PROC_MAXTIME'] ?>", color: "" },
        { index: 9, status: "<?php echo $error_message['ERR_ENCODER'] ?>", color: "" },
        { index: 10, status: "<?php echo $error_message['ERR_HALL'] ?>", color: "" },
        { index: 11, status: "<?php echo $error_message['ERR_BUSVOLT_HIGH'] ?>", color: "" },
        { index: 12, status: "<?php echo $error_message['ERR_BUSVOLT_LOW'] ?>", color: "" },
        { index: 13, status: "<?php echo $error_message['ERR_PROC_NA'] ?>", color: "" },
        { index: 14, status: "<?php echo $error_message['ERR_STEP_NA'] ?>", color: "" },
        { index: 15, status: "<?php echo $error_message['ERR_DMS_COMM'] ?>", color: "" },
        { index: 16, status: "<?php echo $error_message['ERR_FLASH'] ?>", color: "" },
        { index: 17, status: "<?php echo $error_message['ERR_FRAM'] ?>", color: "" },
        { index: 18, status: "<?php echo $error_message['ERR_HIGH_ANGLE'] ?>", color: "" },
        { index: 19, status: "<?php echo $error_message['ERR_PROTECT_CIRCUIT'] ?>", color: "" },
        { index: 20, status: "<?php echo $error_message['ERR_SWITCH_CONFIG'] ?>", color: "" },
        { index: 21, status: "<?php echo $error_message['ERR_STEP_NOT_REC'] ?>", color: "" },
        { index: 22, status: "<?php echo $error_message['ERR_TMD_FRAM'] ?>", color: "" },
        { index: 23, status: "<?php echo $error_message['ERR_LOW_TORQUE'] ?>", color: "" },
        { index: 24, status: "<?php echo $error_message['ERR_LOW_ANGLE'] ?>", color: "" },
        { index: 25, status: "<?php echo $error_message['ERR_PROC_NOT_FINISH'] ?>", color: "" },
        { index: 26, status: "", color: "" },
        { index: 27, status: "", color: "" },
        { index: 28, status: "", color: "" },
        { index: 29, status: "", color: "" },
        { index: 30, status: "", color: "" },
        { index: 31, status: "", color: "" },
        { index: 32, status: "<?php echo $error_message['SEQ_COMPLETED'] ?>", color: "" },
        { index: 33, status: "<?php echo $error_message['JOB_COMPLETED'] ?>", color: "" },
        { index: 34, status: "<?php echo $error_message['WORKPIECE_RECOVERY'] ?>", color: "" },
    ];

  //----------------------------------------
  let socket; // WebSocket对象
  const server_ip = '<?php echo $data['controller_ip']; ?>';
  const serverUrl = 'ws://'+server_ip+':9501';

  const ipToTableRow = new Map();

  function connectWebSocket() {
      socket = new WebSocket(serverUrl);

      socket.addEventListener('open', (event) => {
          console.log('WebSocket连接已建立');
          // 在连接建立时可以执行其他逻辑
      });

      socket.addEventListener('message', (event) => {
          // 处理接收到的WebSocket消息
        if(isFulfilled){
          handleWebSocketMessage(event);
        }
          // console.log(event);
      });

      socket.addEventListener('close', (event) => {
          console.log('WebSocket连接已关闭');
          // 连接关闭时，设置定时器以尝试重新连接
          // setTimeout(connectWebSocket, 5000); // 2秒后重新连接
      });

      socket.addEventListener('error', (event) => {
          console.error('WebSocket连接发生错误', event);
          // 在发生错误时也可以执行其他逻辑
      });
  }  

  // 初始连接
  connectWebSocket();

let retry_time = 0;
const tt = new Map();
tt.set('start_time',new Date())


  function handleWebSocketMessage(event) {
      const message = event.data;

      // 检查消息是否以 "client X said:" 开头
      const match = message.match(/^Client (\d+) said: (.*)/);

      if (match) {
          const clientNumber = match[1];
          const jsonMessage = match[2];

          try {
              const data = JSON.parse(jsonMessage);

              //判斷是否要更新
              let record_data_time = data.data_time
              // let record_date = new Date('6/29/2011 4:52:48 PM UTC+8');
              let formattedDate = record_data_time.substring(0, 4) + "-" + record_data_time.substring(4, 6) + "-" + record_data_time.substring(6, 8) + " " + record_data_time.substring(9) + ' UTC+0';
              var date = new Date(formattedDate);
              date.toString(); // "Wed Jun 29 2011 09:52:48 GMT-0700 (PDT)"

              // record_data_time = Date(formattedDate)
              let task_id = +document.getElementById('task_id').value;
              let gtcs_job_id = document.getElementById('task_'+task_id+'_gtcs_job_id').value;
              let task_count = document.getElementById('task_count').value;
              let start_time = tt.get('start_time');



               // start_time = start_time - 100000; //往前推100秒避免秒差
              let last_sn = document.getElementById('last_sn').value;

              // if(date > start_time){//紀錄比開啟網頁的時間還新
              if(data.system_sn > last_sn){//紀錄比開啟網頁的時間還新


                if(data.job_id == gtcs_job_id && tt.has(data.system_sn) == false ){
                    console.log('---123----');
                    document.getElementById('modbus_switch').value = 0;
            
                    tt.set(data.system_sn,data.system_sn)
                    //確認紀錄是否為當前設定對應的job
                    //yes:更新顯示 > 觸發下一個task(要更新task_id、加總task time) > call new job
                    //no:不作動

                    document.getElementById('tightening_status').innerHTML = fasten_status[data.fasten_status].status;
                    document.getElementById('tightening_status').style.backgroundColor = fasten_status[data.fasten_status].color;
                    document.getElementById('tightening_status').style.width = 'max-content';
                    document.getElementById('tightening_repeat').value = ' 1 / 1';
                    document.getElementById('tightening_time').value = data.fasten_time;
                    let ttime = +document.getElementById('task_time').value
                    ttime = ttime + +data.fasten_time;
                    ttime = ttime.toFixed(2);
                    document.getElementById('task_time').value = ttime;
                    document.getElementById('screw_info').value = data.fasten_torque;

                    let stop_on_ng = document.getElementById('stop_on_ng').value;

                    //顯示最終鎖附扭力/角度
                    document.getElementById('target_torque2').innerHTML = data.fasten_torque;
                    document.getElementById('target_angle2').innerHTML = data.fasten_angle;
                    document.getElementById('error1').innerHTML = 'Error : '
                    document.getElementById('error2').innerHTML = 'Error : '
                    if(data.step_targettype == 1){// target = angle
                        document.getElementById('high_torque').value = data.step_hightorque;
                        document.getElementById('target_torque').value = 0;
                        document.getElementById('low_torque').value = data.step_lowtorque;
                        document.getElementById('high_angle').value = data.step_highangle;
                        document.getElementById('target_angle').value = data.step_targetangle;
                        document.getElementById('low_angle').value = data.step_lowangle;
                    }else{// target = torque
                        document.getElementById('high_torque').value = data.step_hightorque;
                        document.getElementById('target_torque').value = data.step_targettorque;
                        document.getElementById('low_torque').value = data.step_lowtorque;
                        document.getElementById('high_angle').value = data.step_highangle;
                        document.getElementById('target_angle').value = 0;
                        document.getElementById('low_angle').value = data.step_lowangle;
                    }

                    localStorage.setItem('seq_id', <?php echo $data['seq_id']; ?>); //1
                    localStorage.setItem('seq_count', <?php echo $data['total_seq']; ?>); //2

                    var seq_id_nn = <?php echo json_encode($data['seq_id']); ?>;
                    var total_seq_nn = <?php echo json_encode($data['total_seq']); ?>;


          

                    let  seq_id_new = '<?php echo $data['seq_id']; ?>'
                    let  seq_count = <?php echo $data['total_seq']; ?>;            

                        if(task_id <= task_count){

                            let current_circle = document.querySelector("div[data-id='"+task_id+"']");
                            current_circle.childNodes[1].classList.remove('running')
                            // current_circle.classList.remove('running')
                            current_circle.classList.remove('ng')


                            if(data.fasten_status == 4 || data.fasten_status == 5 || data.fasten_status == 6 ){
                                //OK、OK-JOB、OK-SEQ
                                //save_result(data);
                                retry_time = 0;//retry測試歸零
                                document.getElementById('screw_info').innerHTML = retry_time + ' / '+ stop_on_ng;
                                current_circle.classList.add('finished')
                                current_circle.childNodes[1].classList.remove('circle-border')
                             

                                task_id = task_id + 1;

                                localStorage.setItem('task_id',task_id);
                                localStorage.setItem('task_count',task_count);
                                localStorage.setItem('job_singal',job_singal);
                                localStorage.setItem('seq_singal',seq_singal);
                                localStorage.setItem('system_no',data.system_sn);


                                    
                                if(task_id <= task_count){

                                        document.getElementById('task_id').value = task_id;
                                        updateParameters(task_id)
                                        //call_job();
                                        // document.getElementById('modbus_switch').value = 1;
                                        let next_circle = document.querySelector("div[data-id='"+task_id+"']");
                                        // next_circle.classList.add('running')
                                        next_circle.childNodes[1].classList.add('running')
                                        next_circle.style.backgroundColor = '#44d0ff';
                                        // next_circle.childNodes[0].classList.add('inner-text');
                                        document.getElementById('task_serail').value = task_id+' / '+task_count;

                                        document.getElementById('tightening_status').innerHTML = 'OK';
                                        document.getElementById('tightening_status').style.backgroundColor = 'green';
                                        document.getElementById('tightening_status_div').style.backgroundColor = 'green';

                                        light_signal = 'OK';

                                        var fasten_status_new = 4;
                                        var new_task_id = task_id -1;
                                        save_result_new(data,fasten_status_new,new_task_id );

                                        //播放OK 語音
                                        if(ok_auto){
                                            var path =  '../public/voice/'; 
                                            var fullPath = path + ok_auto;

                                            var audio = new Audio(fullPath);
                                            audio.play().catch(function(error) {
                                                console.log('自動播放被阻止:', error);
                                                alert('自動播放被阻止:', error);
                                            });
                                  
                                        }                  
                                      
                                        let system_no = data.system_sn;
                                       
                                        afterward();

                                        if(task_message_list == ''){ //完全沒有virtual message
                                            call_job();
                                        }else{ //至少有一個virtaul message
                                            try{
                                                var element = document.getElementById('VirtualMessage');
                                                var task_message_list_nn = JSON.parse(task_message_list);
                                                var nn_task_id_first = task_id-1;
                                                var nn_task_id_str_f = String(nn_task_id_first);

                                                if (typeof task_message_list_nn[nn_task_id_str_f] !== 'undefined') {
                                                    var task_f = task_message_list_nn[nn_task_id_str_f];
                                                    var e_timeStr1 = task_f.timeout +'000';
                                                    var e_time1 = parseInt(e_timeStr1, 10);

                                                    if(task_f.timeout !== '0'){
                                                        force_switch_tool(0);
                                                        
                                                        document.getElementById('VirtualMessage').style.display = 'block';
                                                        document.getElementById('w3review').value = task_f.text;

                                                        if(task_f.img == ""){
                                                            const element_11 = document.querySelector('.scrollbar-Message_text');
                                                            if (element_11) {
                                                                element_11.className = 'scrollbar-Message_text_s';
                                                            }
                                           
                                                        }else{
                                                            if(task_f.type ==="video"){
                                                                document.getElementById('myvideo').style.display = 'block';
                                                                document.getElementById('myimage').style.display = 'none';
                                                                var videoElement = document.getElementById('myvideo');
                                                                var sourceElement = document.getElementById('video_source');
                                                                sourceElement.src = task_f.img;
                                                                videoElement.load();
                                                            }else{
                                                                document.getElementById('myvideo').style.display = 'none';
                                                                document.getElementById('myimage').style.display = 'block';
                                                                document.getElementById('myimage').src = task_f.img;
                                                            }
                                                        
                                                        }

                                                        element.style.display = 'block';
                                                        
                                                        setTimeout(function() {
                                                            element.style.display = 'none';
                                                            //force_switch_tool(1);    
                                                            call_job();
                                                        }, e_time1); 

                                                    }else{
                                                        call_job();
                                                    
                                                        //force_switch_tool(0); 
                                                    }
                                                }else{
                                                    call_job();
                                                }

                                            }catch (e) {
                                                console.log(e)
                                            }
                                        }
                                                                                
                                }else{
                                    
                                        //若OK Job 開啟，OK sequence 開啟，每一個sequence 傳出OK-SEQ信號，最後一個sequence 是傳出OK-Job信號
                                        if( job_singal == 1 && seq_singal == 1 && seq_id_nn < total_seq_nn && task_id > task_count){
                                            document.getElementById('tightening_status').innerHTML = 'OK-SEQ';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = '#FFCC00';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = '#FFCC00';
                                            document.getElementById('tightening_status').style.backgroundColor = '#FFCC00';
                                            document.getElementById('tightening_status_div').style.backgroundColor = '#FFCC00';
                                            current_circle.classList.add('finished_job');  


                                            var fasten_status_new = 5;
                                            save_result(data,fasten_status_new);

                                            if(ok_seq_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_seq_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                    
                                            }     
                                            

                                        }

                                        if( job_singal == 1 && seq_singal == 1 && seq_id_nn == total_seq_nn && task_id > task_count){
                                            document.getElementById('tightening_status').innerHTML = 'OK-JOB';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = '#FFCC00';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = '#FFCC00';
                                            document.getElementById('tightening_status').style.backgroundColor = '#FFCC00';
                                            document.getElementById('tightening_status_div').style.backgroundColor = '#FFCC00';
                                            current_circle.classList.add('finished_job');  

                                            
                                            var fasten_status_new = 6;
                                            save_result(data,fasten_status_new);

                                             if(ok_job_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_job_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                    
                                            }

                                           
                                        }

                                        //若OK Job 關閉，OK sequence 關閉 顯示 OK
                                        if(job_singal == 0 && seq_singal == 0 ){
                                            document.getElementById('tightening_status').innerHTML = 'OK';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = 'green';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = 'green';
                                            document.getElementById('tightening_status').style.backgroundColor = 'green';
                                            document.getElementById('tightening_status_div').style.backgroundColor = 'green';
                                            current_circle.classList.add('finished'); 

                                            
                                            var fasten_status_new = 4;
                                            save_result(data,fasten_status_new);

                                            //播放OK 語音
                                            if(ok_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                    
                                            }              
                                            
                                    

                                        }


                                        //若OK Job 關閉，OK sequence 開啟，每一個sequence 傳出OK-SEQ信號 
                                        if(job_singal == 0 && seq_singal == 1 && seq_id_nn < total_seq_nn && task_id > task_count){
                                            document.getElementById('tightening_status').innerHTML = 'OK-SEQ';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = '#FFCC00';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = '#FFCC00';
                                            document.getElementById('tightening_status').style.backgroundColor = '#FFCC00';
                                            document.getElementById('tightening_status_div').style.backgroundColor = '#FFCC00';
                                            current_circle.classList.add('finished_job');


                                            
                                            var fasten_status_new = 5;
                                            save_result(data,fasten_status_new);

                                            if(ok_seq_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_seq_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                    
                                            }         

                                        }
                                        if(job_singal == 0 && seq_singal == 1 && seq_id_nn == total_seq_nn && task_id > task_count){
                                            document.getElementById('tightening_status').innerHTML = 'OK-SEQ';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = '#FFCC00';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = '#FFCC00';
                                            document.getElementById('tightening_status').style.backgroundColor = '#FFCC00';
                                            document.getElementById('tightening_status_div').style.backgroundColor = '#FFCC00';
                                            current_circle.classList.add('finished_job');

                                            if(ok_seq_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_seq_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                
                                            }   

                                            
                                            var fasten_status_new = 5;
                                            save_result(data,fasten_status_new); 

                                        }

                                        //若OK Job 開啟，Oksequence，關閉，最後一個seq 傳出OK-JOB信號
                                        if(job_singal == 1 && seq_singal == 0 &&  seq_id_nn < total_seq_nn && task_id > task_count){
                                            document.getElementById('tightening_status').innerHTML = 'OK';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = 'green';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = 'green';
                                            document.getElementById('tightening_status').style.backgroundColor = 'green';
                                            document.getElementById('tightening_status_div').style.backgroundColor = 'green';
                                            current_circle.classList.add('finished');  

                                            
                                            var fasten_status_new = 4;
                                            save_result(data,fasten_status_new);

                                            //播放OK 語音
                                            if(ok_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                    
                                            }  

                                  

                                        }

                                        if(job_singal == 1 && seq_singal == 0 &&  seq_id_nn == total_seq_nn && task_id > task_count){
                                            document.getElementById('tightening_status').innerHTML = 'OK-JOB';
                                            document.getElementById('step'+(task_id-1)).style.backgroundColor = '#FFCC00';
                                            document.getElementById('step'+(task_id-1)).style.borderColor = '#FFCC00';
                                            document.getElementById('tightening_status').style.backgroundColor = '#FFCC00';
                                            document.getElementById('tightening_status_div').style.backgroundColor = '#FFCC00';
                                            current_circle.classList.add('finished_job');  


                                            var fasten_status_new = 6;
                                            save_result(data,fasten_status_new);

                                            if(ok_job_auto){
                                                var path =  '../public/voice/'; 
                                                var fullPath = path + ok_job_auto;

                                                var audio = new Audio(fullPath);
                                                audio.play().catch(function(error) {
                                                    console.log('自動播放被阻止:', error);
                                                    alert('自動播放被阻止:', error);
                                                });
                                    
                                            }        
                                        }
                                        


                                        
                                        //這邊要執行 文字訊息的動作
                                        if(task_message_list == ''){//如果沒有virtual message
                                            document.getElementById('modbus_switch').value = 0;
                                            // setTimeout(() => { websocket.send('disable'); }, 1000);
                                            
                                            // isSendingRequest = true;
                                            let current_seq_id = +document.getElementById('seq_id').value;
                                            let max_seq_id = +document.getElementById('max_seq_id').value;
                                            if(current_seq_id < max_seq_id){
                                                // change to next seq
                                                // change_job(current_seq_id + 1);
                                                setTimeout(() => { change_job(current_seq_id + 1,'next'); }, 500);
                                            }else{
                                                setTimeout(() => { force_switch_tool(0); }, 1000);
                                                document.getElementById('modbus_switch').value = 0;
                                            }
                                        }else{
                                            try{
                                                var task_message_list_nn = JSON.parse(task_message_list);
                                                var nn_task_id = task_id - 1;
                                                var nn_task_id_str = String(nn_task_id);
                                                var task = task_message_list_nn[nn_task_id_str];

                                                if (typeof task_message_list_nn[nn_task_id_str_f] !== 'undefined') {
                                                    if (task) {
                                                        let type = task.type ? task.type.trim() : '';

                                                        document.getElementById('VirtualMessage').style.display = 'block';
                                                        document.getElementById('w3review').value = task.text;

                                                        if(task.img == '') {
                                                            const element = document.querySelector('.scrollbar-Message_text');
                                                            if (element) {
                                                                document.getElementById('myvideo').style.display = 'none';
                                                                document.getElementById('myimage').style.display = 'none';

                                                                document.getElementById('myvideo').removeAttribute('id');
                                                                document.getElementById('myimage').removeAttribute('id');

                                                                element.className = 'scrollbar-Message_text_s';
                                                            }
                                                        }

                                                        if(type ==="image"){
                                                   
                                                            document.getElementById('myvideo').style.display = 'none';
                                                            document.getElementById('myimage').style.display = 'block';
                                                            document.getElementById('myimage').src = task.img + '?t=' + new Date().getTime();

                                                        }

                                                        if(type ==="video"){
                                                            document.getElementById('myvideo').style.display = 'block';
                                                            document.getElementById('myimage').style.display = 'none';
                                                            var videoElement = document.getElementById('myvideo');
                                                            var sourceElement = document.getElementById('video_source');
                                                            sourceElement.src = task.img;
                                                            videoElement.load();
                                                        }

                                                        var e_timeStr = task.timeout +'000';
                                                        var e_time = parseInt(e_timeStr, 10); 
                            
                                                        var element = document.getElementById('VirtualMessage');
                                                        element.style.display = 'block';
                                                       
                                                        force_switch_tool(0);// 起子disable

                                                        setTimeout(() => {
                                                            element.style.display = 'none';
                                                
                                                            document.getElementById('modbus_switch').value = 0;
                                                            
                                                            //setTimeout(() => { websocket.send('disable'); }, 1000);
                                                            
                                                            let current_seq_id = +document.getElementById('seq_id').value;
                                                            let max_seq_id = +document.getElementById('max_seq_id').value;
                                                            
                                                            if (current_seq_id < max_seq_id) {
                                                                setTimeout(() => { change_job(current_seq_id + 1, 'next'); }, 500);
                                                            } else {
                                                                setTimeout(() => { force_switch_tool(0); }, 1000);
                                                                document.getElementById('modbus_switch').value = 0;
                                                            }

                                                        }, e_time);

                                                    }
                                                }else{
                                                    document.getElementById('modbus_switch').value = 0;
                                                    // setTimeout(() => { websocket.send('disable'); }, 1000);
                                                    
                                                    // isSendingRequest = true;
                                                    let current_seq_id = +document.getElementById('seq_id').value;
                                                    let max_seq_id = +document.getElementById('max_seq_id').value;
                                                    if(current_seq_id < max_seq_id){
                                                        // change to next seq
                                                        // change_job(current_seq_id + 1);
                                                        setTimeout(() => { change_job(current_seq_id + 1,'next'); }, 500);
                                                    }else{
                                                        setTimeout(() => { force_switch_tool(0); }, 1000);
                                                        document.getElementById('modbus_switch').value = 0;
                                                    }
                                                }

                                            }catch (e) {
                                                console.log(e)
                                            }
                                        }

                                        // var task_message_list_nn = JSON.parse(task_message_list);
                                        // var nn_task_id = task_id - 1;
                                        // var nn_task_id_str = String(nn_task_id);
                                        // var task = task_message_list_nn[nn_task_id_str];
                                        // if (task) {
                                        //     let type = task.type ? task.type.trim() : '';

                                        //     document.getElementById('VirtualMessage').style.display = 'block';
                                        //     document.getElementById('w3review').value = task.text;

                                        //     if(task.img == '') {
                                        //         const element = document.querySelector('.scrollbar-Message_text');
                                        //         if (element) {
                                        //             document.getElementById('myvideo').style.display = 'none';
                                        //             document.getElementById('myimage').style.display = 'none';

                                        //             document.getElementById('myvideo').removeAttribute('id');
                                        //             document.getElementById('myimage').removeAttribute('id');

                                        //             element.className = 'scrollbar-Message_text_s';
                                        //         }
                                        //     }

                                        //     if(type ==="image"){
                                       
                                        //         document.getElementById('myvideo').style.display = 'none';
                                        //         document.getElementById('myimage').style.display = 'block';
                                        //         document.getElementById('myimage').src = task.img + '?t=' + new Date().getTime();

                                        //     }

                                        //     if(type ==="video"){
                                        //         document.getElementById('myvideo').style.display = 'block';
                                        //         document.getElementById('myimage').style.display = 'none';
                                        //         var videoElement = document.getElementById('myvideo');
                                        //         var sourceElement = document.getElementById('video_source');
                                        //         sourceElement.src = task.img;
                                        //         videoElement.load();
                                        //     }

                                        //     var e_timeStr = task.timeout +'000';
                                        //     var e_time = parseInt(e_timeStr, 10); 
                
                                        //     var element = document.getElementById('VirtualMessage');
                                        //     element.style.display = 'block';
                                           
                                        //     force_switch_tool(0);// 起子disable

                                        //     setTimeout(() => {
                                        //         element.style.display = 'none';
                                    
                                        //         document.getElementById('modbus_switch').value = 0;
                                                
                                        //         //setTimeout(() => { websocket.send('disable'); }, 1000);
                                                
                                        //         let current_seq_id = +document.getElementById('seq_id').value;
                                        //         let max_seq_id = +document.getElementById('max_seq_id').value;
                                                
                                        //         if (current_seq_id < max_seq_id) {
                                        //             setTimeout(() => { change_job(current_seq_id + 1, 'next'); }, 500);
                                        //         } else {
                                        //             setTimeout(() => { force_switch_tool(0); }, 1000);
                                        //             document.getElementById('modbus_switch').value = 0;
                                        //         }

                                        //     }, e_time);

                                        // }else{
                                            
                                        //     document.getElementById('modbus_switch').value = 0;
                                        //     // setTimeout(() => { websocket.send('disable'); }, 1000);
                                            
                                        //     // isSendingRequest = true;
                                        //     let current_seq_id = +document.getElementById('seq_id').value;
                                        //     let max_seq_id = +document.getElementById('max_seq_id').value;
                                        //     if(current_seq_id < max_seq_id){
                                        //         // change to next seq
                                        //         // change_job(current_seq_id + 1);
                                        //         setTimeout(() => { change_job(current_seq_id + 1,'next'); }, 500);
                                        //     }else{
                                        //         setTimeout(() => { force_switch_tool(0); }, 1000);
                                        //         document.getElementById('modbus_switch').value = 0;
                                        //     }
                                        //     alert(456)
                                        // }

                                        

                                        light_signal = 'okall';
                                        afterward();
                                       
                                }

                                
                            }else if(data.fasten_status == 7 || data.fasten_status == 8){
                                let fs_status = data.fasten_status
                                let err_status = data.error_message
                                //NG、NG-STOP
                                //播放NG 語音
                                var path =  '../public/voice/';
                                var fullPath = path + ng_auto;

                                var audio = new Audio(fullPath);
                                audio.play().catch(function(error) {
                                    console.log('自动播放被阻止:', error);
                                    alert('自动播放被阻止:', error);
                                });

                                

                                save_result(data);

                                current_circle.childNodes[1].classList.add('running')
                                current_circle.classList.add('ng');
                                retry_time = retry_time + 1;
                                document.getElementById('step'+task_id).style.backgroundColor = 'red';
                                document.getElementById('tightening_status_div').style.backgroundColor = 'red';

                                document.getElementById('screw_info').innerHTML = retry_time + ' / '+ stop_on_ng;
                                document.getElementById('modbus_switch').value = 1;

                                // console.log(data.fasten_status)
                                // console.log(fasten_status[7].status)
                                document.getElementById('error1').innerHTML = 'Error : ' + fasten_status[fs_status].status;
                                document.getElementById('error2').innerHTML = 'Error : ' + error_message[err_status].status;
                                light_signal = 'ng';
                                afterward();

                                if( +retry_time == +stop_on_ng && +stop_on_ng != 0 ){
                                    // force_switch_tool(0);
                                    switch_tool(0);
                                    // function_auth_check('stop_on_ng')
                                }


                            }
                        }else{
                            //
                        }
                }

              }


              
          } catch (error) {
              console.error("Error parsing JSON message: " + error);
          }
      }
  }

function call_job() {
    let task_id = +document.getElementById('task_id').value;
    let gtcs_job_id = document.getElementById('task_'+task_id+'_gtcs_job_id').value;
    let url = '?url=Operations/Call_Controller_Job';

    document.getElementById('modbus_switch').value = 0;

    setTimeout(() => {
        $.ajax({
            type: "POST",
            timeout: 3000, 
            url: url,
            data: { 'job_id': gtcs_job_id },
            // dataType: "json",
            // async:false
        }).done(function(response) { //成功且有回傳值才會執行
            // alert(123)
            document.getElementById('modbus_switch').value = 1;
        });
    }, 333);

    
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
        // alert(123)
        // console.log(response);
        history.go(0);
    });
}

function change_seq(direction) {

    let seq_id = document.getElementById('seq_id').value;
    let total_seq = document.getElementById('max_seq_id').value;
    if (direction == 'previous') {
        seq_id = +seq_id - 1; 
    }else if(direction == 'next'){
        seq_id = +seq_id + 1; 
    }else{
        seq_id = document.getElementById('SeqNameSelect').value;
        console.log(seq_id);
    }

    if (seq_id > total_seq) {
        alert('last seq');
        return 0;
    }

    if (seq_id < 1) {
        alert('first seq');
        return 0;
    }

    change_job(seq_id,direction)
}


// let isSendingRequest = false;

// setInterval(check_tool_status, 200); // 每隔x秒發送一次請求，可以根據需要調整時間間隔

function check_tool_status(){
    let modbus_switch = document.getElementById('modbus_switch').value
    // 發送 AJAX 請求到服務器
    if (isSendingRequest || modbus_switch == 0) {
        // 如果正在發送，不執行新的请求
        return;
    }
    isSendingRequest = true;
    $.ajax({
        url: '?url=Operations/ToolStatusCheck', // 指向服務器端檢查更新的 PHP 腳本
        method: 'GET',
        dataType: "json",
        success: function(response) {
            // 處理服務器返回的響應
            document.getElementById('tool_status').value = response.result;
            if(response.result == 1){//tool enable
                document.getElementById('tool_status_icon').innerHTML = '<svg width="24px" height="24px" viewBox="0 0 281.25 281.25" id="svg2" version="1.1" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <defs id="defs4"></defs> <g id="layer1" transform="translate(6693.6064,-4597.9898)"> <path d="m -6552.9808,4636.829 c -56.159,0 -101.7865,45.6275 -101.7865,101.7865 0,56.1591 45.6274,101.7847 101.7865,101.7847 56.1592,0 101.7847,-45.6256 101.7847,-101.7847 0,-56.159 -45.6256,-101.7865 -101.7847,-101.7865 z m 0,9.375 c 51.0925,0 92.4097,41.319 92.4097,92.4115 0,51.0925 -41.3171,92.4097 -92.4097,92.4097 -51.0924,0 -92.4115,-41.3172 -92.4115,-92.4097 0,-51.0925 41.3191,-92.4115 92.4115,-92.4115 z m 48.0341,54.2413 a 4.6875,4.6875 0 0 0 -3.3142,1.3733 l -63.1055,63.1055 -28.1653,-26.0669 a 4.6875,4.6875 0 0 0 -6.6229,0.2563 4.6875,4.6875 0 0 0 0.2563,6.6248 l 31.4722,29.1284 a 4.6879687,4.6879687 0 0 0 6.5002,-0.1245 l 66.2934,-66.2952 a 4.6875,4.6875 0 0 0 0,-6.6284 4.6875,4.6875 0 0 0 -3.3142,-1.3733 z" id="circle1193" style="color:#008000;fill:#008000;fill-opacity:1;fill-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;-inkscape-stroke:none"></path> </g> </g></svg>';
            }else{//tool disable
                document.getElementById('tool_status_icon').innerHTML = '<svg width="24px" height="24px" viewBox="0 0 1024 1024" fill="red" class="icon" version="1.1" xmlns="http://www.w3.org/2000/svg" stroke="red"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M512 897.6c-108 0-209.6-42.4-285.6-118.4-76-76-118.4-177.6-118.4-285.6 0-108 42.4-209.6 118.4-285.6 76-76 177.6-118.4 285.6-118.4 108 0 209.6 42.4 285.6 118.4 157.6 157.6 157.6 413.6 0 571.2-76 76-177.6 118.4-285.6 118.4z m0-760c-95.2 0-184.8 36.8-252 104-67.2 67.2-104 156.8-104 252s36.8 184.8 104 252c67.2 67.2 156.8 104 252 104 95.2 0 184.8-36.8 252-104 139.2-139.2 139.2-364.8 0-504-67.2-67.2-156.8-104-252-104z" fill=""></path><path d="M707.872 329.392L348.096 689.16l-31.68-31.68 359.776-359.768z" fill=""></path><path d="M328 340.8l32-31.2 348 348-32 32z" fill=""></path></g></svg>';
            }

            isSendingRequest = false;
        },
        complete: function(XHR, TS) {
            XHR = null;
            
        },
        error: function(xhr, status, error) {
      
        }
    });
}



async function switch_tool(status) {
    let modbus_switch = document.getElementById('modbus_switch').value;
    let current_tool_status = +document.getElementById('tool_status').value;
    if( current_tool_status == status){
        return;
    }


    if (isSendingRequest || modbus_switch == 0) {
        // 如果正在發送，不執行新的请求
        return;
    }
    isSendingRequest = true;
    $.ajax({
        url: '?url=Operations/Switch_Tool_Status', // 指向服務器端檢查更新的 PHP 腳本
        method: 'POST',
        async: false,
        data: { 'tool_status': status },
        dataType: "json",
        success: function(response) {
            // 處理服務器返回的響應
            if(response.result){
                document.getElementById('tool_status').value = status;
            }

            isSendingRequest = false;
        },
        complete: function(XHR, TS) {
            XHR = null;
           
        },
        error: function(xhr, status, error) {

        }
    });
}


async function force_switch_tool(status) {
    let done = true;
    while(done){

        let modbus_switch = document.getElementById('modbus_switch').value;
        console.log(isSendingRequest)
        console.log(modbus_switch)
        document.getElementById('modbus_switch').value = 1;
        isSendingRequest = false;
        if (isSendingRequest || modbus_switch == 0) {
            // 如果正在發送，不執行新的请求
            continue;
        }
        isSendingRequest = true;
        document.getElementById('modbus_switch').value = 0;
        // isSendingRequest = true;
        $.ajax({
            url: '?url=Operations/Switch_Tool_Status', // 指向服務器端檢查更新的 PHP 腳本
            async: false,
            method: 'POST',
            data: { 'tool_status': status },
            dataType: "json",
            success: function(response) {
                // 處理服務器返回的響應
                // document.getElementById('tool_status').value = response.result;
                // document.getElementById('tool_status_icon').innerHTML = '<svg width="24px" height="24px" viewBox="0 0 1024 1024" fill="red" class="icon" version="1.1" xmlns="http://www.w3.org/2000/svg" stroke="red"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M512 897.6c-108 0-209.6-42.4-285.6-118.4-76-76-118.4-177.6-118.4-285.6 0-108 42.4-209.6 118.4-285.6 76-76 177.6-118.4 285.6-118.4 108 0 209.6 42.4 285.6 118.4 157.6 157.6 157.6 413.6 0 571.2-76 76-177.6 118.4-285.6 118.4z m0-760c-95.2 0-184.8 36.8-252 104-67.2 67.2-104 156.8-104 252s36.8 184.8 104 252c67.2 67.2 156.8 104 252 104 95.2 0 184.8-36.8 252-104 139.2-139.2 139.2-364.8 0-504-67.2-67.2-156.8-104-252-104z" fill=""></path><path d="M707.872 329.392L348.096 689.16l-31.68-31.68 359.776-359.768z" fill=""></path><path d="M328 340.8l32-31.2 348 348-32 32z" fill=""></path></g></svg>';
                isSendingRequest = false;
                return 0;
                // document.getElementById('modbus_switch').value = 0;
            },
            complete: function(XHR, TS) {
                XHR = null;
                // console.log("执行一次"); 
            },
            error: function(xhr, status, error) {
                // console.log("fail");
            }
        });

        done = false;
    }
}

</script>


<script>

    $(document).ready(async function () {
        // setInterval(main_workflow, 300);
        // 设置循环条件
        let loop_condition = true;
        let loop_count = 0;

        await switch_tool(1);//預設先讓起子enable

        // while 循环
        while (loop_condition) {
            // console.log(`Loop ${loop_count + 1}`);
            await main_workflow(); // 调用 main_workflow 函数

            // 检查循环结束条件
            // 此处需要根据具体情况设置条件
            if (loop_count >= 10) {
                // loop_condition = false; // 当循环达到指定次数时结束
            }

            // 模拟等待一段时间后再次执行循环
            await new Promise(resolve => setTimeout(resolve, 300)); // 等待 1 秒
            loop_count++;
        }
    });
    // main_workflow();

    // setInterval(main_workflow, 3000); // 每隔x秒發送一次請求，可以根據需要調整時間間隔

    //operation main workflow
    async function main_workflow(argument) {
        // body...
        // prerequisite ，判斷時否達到當前task的前置條件 ex: arm、socket tray、...等等
        // console.log('-----start prerequisite------');
        let aa = await prerequisite();
        // console.log('-----end prerequisite------');

        // console.log('-----start tool enable or disable------');
        // await ;
        // await switch_tool(0)
        console.log(aa)
        if( aa == true ){
            await switch_tool(1)
            // force_switch_tool(1)
            isFulfilled = true;
        }else{
            await switch_tool(0)
            isFulfilled = false;
        }

        // await switch_tool(1)
        // console.log('-----end tool enable or disable------');

        // console.log('-----start afterward------');
         // afterward();
        // console.log('-----end afterward------');

        // receive fasten result，接收控制器的鎖附結果產生對應的NG或OK等訊息
        // afterward ，如果鎖附結果OK，進行當前task對應的後續資訊 ex:三色燈、message、video、audio、...等等


    }

    async function prerequisite(arguments) {
        //get arm status
        let arm_status = +document.getElementById('arm_status').value
        //get socket tray status
        let socket_tray_status = +document.getElementById('socket_tray_status').value
        // console.log(arm_status,socket_tray_status)
        let task_id = document.getElementById('task_id').value;
        let hole_id = document.getElementById('task_'+task_id+'_hole_id').value;
        console.log(hole_id);

        let flag = false;

        let stop_on_ng = document.getElementById('stop_on_ng').value;
        if( +retry_time == +stop_on_ng && +stop_on_ng != 0 ){
            console.log('ng stop')
            return false;
        }

        if (hole_id != '' &&  hole_id != '-1') {
            //先set io的input  來顯示目標hole
            $.ajax({
                url: '?url=Operations/Set_Socket_Hole', // 指向服務器端檢查更新的 PHP 腳本
                async: false,
                method: 'POST',
                data: { 'hole_id': hole_id, 'Socket_Hole': true  },
                dataType: "json",
                complete: function(XHR, TS) {
                    XHR = null;
                },
                error: function(xhr, status, error) {
                }
            });
            //在get io的output 來確認user是否有拿對
            $.ajax({
                url: '?url=Operations/Get_Socket_Hole', // 指向服務器端檢查更新的 PHP 腳本
                async: false,
                method: 'GET',
                timeout: 500,
                data: { 'hole_id': hole_id },
                dataType: "json",
                success: function(response) {
                    // 處理服務器返回的響應

                    if(response.result == 'yes'){
                        flag = true;
                        document.getElementById('socket_hole_number').style.backgroundColor = '#7ECA86';

                        //把arm判斷放在socket tray之後
                        if (arm_status != 0 && !right_position) { //task有啟用arm 且 arm不在正確位置
                            console.log('ng position')
                            flag = false;
                        }
                        
                    }else{
                        console.log('ng socket tray')
                        flag = false;
                        document.getElementById('socket_hole_number').style.backgroundColor = '#f63e3e';
                    }
                    //find task hole id then 

                    isSendingRequest = false;
                },
                complete: function(XHR, TS) {
                    XHR = null;
                    // console.log("执行一次"); 
                },
                error: function(xhr, status, error) {
                    // console.log("fail");
                }
            });
        }else{//沒有設定socket hole
            flag = true;
            if (arm_status != 0 && !right_position) { //task有啟用arm 且 arm不在正確位置
                if(!right_position){
                    console.log('ng position')
                     flag = false;
                }
            }
        }

         //把arm判斷放在socket tray之後
        // if (arm_status != 0 && !right_position) { //task有啟用arm 且 arm不在正確位置
        //     // if(!right_position){
        //     console.log('ng position')
        //     return false;
        //     // }
        // }

        return flag;

        // return sleep(1000);
    }

    function afterward(arguments) {
        //關閉所有output
        // $.ajax({
        //     url: '?url=Operations/Set_IO_Signal', // 指向服務器端檢查更新的 PHP 腳本
        //     async: true, // 將此設置為 true 表示請求是非同步的
        //     method: 'GET',
        //     data: { 'light_signal': 'stop' },
        //     dataType: "json"
        // });


        if(light_signal != false){
            $.ajax({
                url: '?url=Operations/Set_IO_Signal', // 指向服務器端檢查更新的 PHP 腳本
                async: true, // 將此設置為 true 表示請求是非同步的
                method: 'GET',
                data: { 'light_signal': light_signal },
                dataType: "json"
            });
        }
    }

    function sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    function save_result(data, fasten_status_new) {

        data.cc_job_id = document.getElementById('job_id').value;
        data.cc_seq_id = document.getElementById('seq_id').value;

        data.cc_task_id = document.getElementById('task_id').value;
        data.cc_equipment = '<?php echo $data['job_data']['controller_id'];?>';
        data.cc_barcodesn = document.getElementById('barcode').placeholder;
        data.cc_station = '';
        data.cc_operator = '<?php echo $_SESSION['user']; ?>';



        data.task_count_final = '<?php echo $data['task_count'];?>';
        data.cc_program_id = '<?php echo $data['task_list'][0]['template_program_id'];?>';
        data.total_seq_count ='<?php echo $data['total_seq'];?>';
        data.ok_job ='<?php echo $data['job_data']['ok_job'];?>';
        data.ok_sequence ='<?php echo $data['ok_sequence'];?>';
        data.job_singal  = job_singal;  //OK-JOB 訊號
        data.seq_singal  = seq_singal;   //OK-SEQ 訊號 
        data.total_seq =  total_seq; //需要執行SEQ的數量
        data.ct_seq_id = ct_seq_id;// 當前的seq_id 

        data.new_task_id    = localStorage.getItem('task_id');
        data.new_task_count = localStorage.getItem('task_count');
        data.new_seq_id     = localStorage.getItem('seq_id');
        data.new_seq_count    = localStorage.getItem('seq_count');


        data.fasten_status = fasten_status_new;
    



        $.ajax({
            url: '?url=Operations/Save_Result',
            // async: false,
            method: 'GET',
            data: { 'data': data },
            dataType: "json",
            success: function(response) {
            // Store the response in a global variable
            if (response.system_no) {
                globalSystemNo = response.system_no;
                console.log('System No from AJAX response:', globalSystemNo);
                // Optionally, store the value in localStorage
                localStorage.setItem('system_no', globalSystemNo);
            } else if (response.error) {
                console.error('Error from server:', response.error);
            }
        },
            error: function(xhr, status, error) {
                // Handle error
                console.error('AJAX error:', status, error);
                // Optionally, handle error UI feedback
            }

        });
    }


    function save_result_new(data, fasten_status_new,new_task_id) {

        data.cc_job_id = document.getElementById('job_id').value;
        data.cc_seq_id = document.getElementById('seq_id').value;

        data.cc_task_id = new_task_id;
        data.cc_equipment = '<?php echo $data['job_data']['controller_id'];?>';
        data.cc_barcodesn = document.getElementById('barcode').placeholder;
        data.cc_station = '';
        data.cc_operator = '<?php echo $_SESSION['user']; ?>';



        data.task_count_final = '<?php echo $data['task_count'];?>';
        data.cc_program_id = '<?php echo $data['task_list'][0]['template_program_id'];?>';
        data.total_seq_count ='<?php echo $data['total_seq'];?>';
        data.ok_job ='<?php echo $data['job_data']['ok_job'];?>';
        data.ok_sequence ='<?php echo $data['ok_sequence'];?>';
        data.job_singal  = job_singal;  //OK-JOB 訊號
        data.seq_singal  = seq_singal;   //OK-SEQ 訊號 
        data.total_seq =  total_seq; //需要執行SEQ的數量
        data.ct_seq_id = ct_seq_id;// 當前的seq_id 

        data.new_task_id    = localStorage.getItem('task_id');
        data.new_task_count = localStorage.getItem('task_count');
        data.new_seq_id     = localStorage.getItem('seq_id');
        data.new_seq_count    = localStorage.getItem('seq_count');


        data.fasten_status = fasten_status_new;
    



        $.ajax({
            url: '?url=Operations/Save_Result',
            // async: false,
            method: 'GET',
            data: { 'data': data },
            dataType: "json",
            success: function(response) {
            // Store the response in a global variable
            if (response.system_no) {
                globalSystemNo = response.system_no;
                console.log('System No from AJAX response:', globalSystemNo);
                // Optionally, store the value in localStorage
                localStorage.setItem('system_no', globalSystemNo);
            } else if (response.error) {
                console.error('Error from server:', response.error);
            }
        },
            error: function(xhr, status, error) {
                // Handle error
                console.error('AJAX error:', status, error);
                // Optionally, handle error UI feedback
            }

        });
    }



    async function function_auth_check(action) {
        let pass = false;
        document.getElementById('verify_action').value = action;
        if(action == 'change_job'){
            if(document.getElementById('button_auth_switch_job').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
        if(action == 'skip_seq'){
            if(document.getElementById('button_auth_switch_next_seq').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
        if(action == 'back_seq'){
            if(document.getElementById('button_auth_switch_previous_seq').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
        if(action == 'reset_task'){
            if(document.getElementById('button_auth_task_reset').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
        if(action == 'stop_on_ng'){
            if(document.getElementById('button_auth_stop_on_ng').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
        if(action == 'change_seq'){
            if(document.getElementById('button_auth_switch_seq').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
        if(action == 'barcode'){
            if(document.getElementById('button_auth_switch_job').value == '1' ){
                verify_action(action);
            }else{
                verify_form_display();
            }
        }
    }

    function verify_form_display() {
        toggleIdentityVerify();
        document.getElementById('id_verify').value = '';
        document.getElementById('id_verify').focus()
    }

    async function call_job_check(){

        let action = document.getElementById('verify_action').value;
        let card = document.getElementById('id_verify').value;
        $.ajax({
            url: '?url=Operations/button_auth_check', // 指向服務器端檢查更新的 PHP 腳本
            // async: false,
            method: 'POST',
            data: { 'card': card, 'action': action },
            dataType: "json"
        }).done(function(response) { //成功且有回傳值才會執行
            // alert(456)
            console.log(response)
            if(response.result){
                verify_action(action)
            }else{
                alert('verify fail')
            }
            toggleIdentityVerify();
        });
    }

    function verify_action(action) {
        if(action == 'change_job'){
            document.getElementById('change_job').style.display='block';
        }
        if(action == 'skip_seq'){
            change_seq('next')
        }
        if(action == 'back_seq'){
            change_seq('previous')
        }
        if(action == 'reset_task'){
            let seq_id = document.getElementById('seq_id').value;
            change_job(seq_id);
        }
        if(action == 'stop_on_ng'){
            console.log('stop_on_ng');
            retry_time = 0
            let stop_on_ng = document.getElementById('stop_on_ng').value;
            document.getElementById('screw_info').innerHTML = retry_time + ' / '+ stop_on_ng;
            // reset 
        }
        if(action == 'change_seq'){
            document.getElementById('SeqSelect').style.display='block';
        }
        if(action == 'barcode'){
            barcode_change_job();
        }
    }

    function task_reset_check() {
        
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
        // barcode_change_job();
        function_auth_check('barcode')
        
      }
    });


</script>


<script>

    let messageCount = 0;

    function addMessage() {
        messageCount++;
        document.getElementById('messageCount').innerText = messageCount;
    }

    function ClickNotification() {
        let messageBox = document.getElementById('messageBox');
        let closeBtn = document.getElementsByClassName("close")[0];
        messageBox.style.display = (messageBox.style.display === 'block') ? 'none' : 'block';
    }

    addMessage();



    function ClickVirtualMessage()
    {
        document.getElementById('VirtualMessage').style.display = 'none';
        force_switch_tool(1);
    }

    function toggleIdentityVerify()
    {
        let IdentityVerify = document.getElementById('IdentityVerify');
        let closeBtn = document.getElementsByClassName("close")[0];
        IdentityVerify.style.display = (IdentityVerify.style.display === 'block') ? 'none' : 'block';
        //document.getElementById('IdentityVerify').style.display = 'none';


    }

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
function setCookie(name, value, days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days*24*60*60*1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}

function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}


function eraseCookie(name) {
    document.cookie = name+'=; Max-Age=-99999999;';
}


function initializeMessageAutoClose() {
        var messageElement = document.getElementById('VirtualMessage');
        
        if (messageElement) {
            setTimeout(function() {
                ClickVirtualMessage();
            }, 5000);
            messageElement.style.display = 'block';
        }
    }

function setCookie(name, value, days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
} 

function update_status(system_no, new_status) {

    $.ajax({
        url: '?url=Operations/update_status', // 确保这个 URL 与后端匹配
        method: "POST",
        data: { 
            system_no: system_no,  
            new_status: new_status 
        },
        success: function(response) {
            // 处理成功的情况
            console.log('AJAX success:', response);
            // 例如，刷新页面或更新 UI
            // history.go(0);  // 刷新页面
        },
        error: function(xhr, status, error) {
            // 处理错误的情况
            console.error('AJAX error:', status, error);
        }
    });
}
function readFromLocalStorage(key) {
    return localStorage.getItem(key);
}


function playAudio(filename) {
    var path = '../public/voice/';
    var fullPath = path + filename;

    var audio = new Audio(fullPath);
    audio.play().catch(function(error) {
        console.log('自動播放被阻止:', error);
        alert('自動播放被阻止: ' + error);
    });
}
<script>