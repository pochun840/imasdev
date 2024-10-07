<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<!-- 加入click circle -->
<script defer src="<?php echo URLROOT; ?>/js/clickcircle.js"></script>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/clickcircle.css" type="text/css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/task.css" type="text/css">

<?php echo $data['nav']; ?>
    
<style>

.t1{font-size: 17px; margin: 2px 0px; display: flex; align-items: center;padding-left: 3%;}
.t2{font-size: 17px; margin: 2px 0px; display: flex; align-items: center;}
.t3{font-size: 17px; margin: 2px 0px; align-items: center;}

</style>


<div class="container-ms">
    <header>
        <div class="task">
            <img id="header-img" src="./img/job-head.svg"><?php echo $text['Task_text']; ?>
        </div>

        <div class="notification">
            <i style=" width:auto; height: 40px;" class="fa fa-bell" onclick="ClickNotification()"></i>
            <span id="messageCount" class="badge"></span>
        </div>
        <div class="personnel"><i style="width:auto; height: 40px;font-size: 26px" class="fa fa-user"></i> <?php echo $_SESSION['user']; ?></div>
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
                        <label class="t4">Recycle box</label>
                        <label class="t5">workstation 3</label>
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
                        <label class="t4">Recycle box</label>
                        <label class="t5">workstation 3</label>
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
                        <label class="t4">Recycle box</label>
                        <label class="t5">workstation 3</label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="topnav">
        <div class="row t3">
            <div class="col-1" style="font-size: 1.8vmin; padding-left: 2%;"><?php echo $text['Job_ID_text']; ?></div>
            <div class="col-1 t3">
                <input id="job_id" type="text" class="form-control" value="<?php echo $data['job_id']; ?>" disabled="disabled" style="font-size: 1.8vmin;background-color: #E3E3E3;">
            </div>

            <div class="col-1" style="font-size: 1.8vmin; padding-left: 2%"><?php echo $text['Seq_ID_text']; ?></div>
            <div class="col-1 t3">
                <input id="seq_id" type="text" class="form-control" value="<?php echo $data['seq_id']; ?>" disabled="disabled" style="font-size:1.8vmin;background-color: #E3E3E3;">
            </div>

            <div class="col-1" style="font-size: 1.8vmin; padding-left: 2%"><?php echo $text['Task_Count_text']; ?></div>
            <div class="col-1 t3">
                <input type="text" class="form-control" value="<?php echo count($data['tasks']); ?>" disabled="disabled" style="font-size: 1.8vmin;background-color: #E3E3E3;">
            </div>

            <div class="col t3">
                <button class="btn" id="back-btn" type="button" onclick="history.go(-1);">
                    <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
                </button>
                <button class="btn" id="delete-btn" type="button" onclick="delete_task()">
                    <img id="img-delete" src="./img/delete.svg" alt=""><?php echo $text['Delete_text']; ?>
                </button>
            </div>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="left-column w3-center" style="position:relative;">
                <div id="img-container" class="img">
                    <?php


                        //方法3 只記circle的style 不記data-id 透過foreach自動產生
                        echo '<img id="imgId" style="width: 100%;height: auto;" src="'.$data['seq_img'].'">';
                        foreach ($data['tasks'] as $key => $value) {
                            echo '<div class="circle" data-id="'.($key+1).'" '.$value['circle_div'].'>';
                            echo '<span class="">'.($key+1).'</span>';
                            echo '<div class="circle-border" onclick="updateParameters('. ($key+1) .')"></div>';
                            echo '</div>';
                        }
                    ?>
                </div>
                <input class="saveButton" type="button" style="position: absolute;right: -10px;" onclick="save_position()" value="<?php echo $text['Save_text']; ?>">
            </div>

            <div class="right-column w3-center">
                <div class="container" id="task-setting" style="width: 80%; background-color: #F2F1F1; height: 70vh">
                    <div class="w3-panel w3-round-large" style="background-color: #444; color: #fff; height: 40px; text-align: left">
                        <label style="font-size: 24px; text-align: left"><?php echo $text['Task_text']; ?></label>
                        <button id="edit_task" onclick="edit_task()">
                            <i class="fa fa-pencil" style="font-size: 24px; width:30px; height:30px; color:red; margin-top: 3px"></i>
                        </button>
                        <button id="add_task" onclick="new_task();">
                            <i class="fa fa-plus" style="font-size: 24px; width:30px; height:30px; color:red; margin-top: 4px"></i>
                        </button>
                    </div>
                    <div>
                        <!-- <ol>
                            <div onclick="updateParameters(0)">
                                <a id="step0" ><img src="./img/tool-30.png" alt="" style="height: 25px; width: 25px; float: left"> | GTC-6567 | step3 | P2 | 0.6-Nm</a>
                                <div class="dropdown-content" id="target_torque-0" style="display:none;" step-id="0">
                                    <div id="">Step1 P2 | <span id="torque">3600&ordm;| Hi 3800 | Lo 0</span></div>
                                    <div id="">Step2 P2 | <span id="angle">3600&ordm; | Hi 3800 | Lo 0</span></div>
                                    <div id="">Step3 P2 | <span id="torque">6-Nm | Hi 0.8 | Lo 0.3</span></div>
                                </div>
                            </div>
                        </ol>
                        <ol>
                            <div onclick="updateParameters('a')">
                                <a id="stepa" ><img src="./img/tool-30.png" alt="" style="height: 25px; width: 25px; float: left"> | GTC-6567 | step3 | P2 | 0.6-Nm</a>
                                <div class="dropdown-content" id="target_torque-a" style="display:none;" step-id="a">
                                    <div id="">Step1 P2 | <span id="torque">3600&ordm;| Hi 3800 | Lo 0</span></div>
                                    <div id="">Step2 P2 | <span id="angle">3600&ordm; | Hi 3800 | Lo 0</span></div>
                                    <div id="">Step3 P2 | <span id="torque">6-Nm | Hi 0.8 | Lo 0.3</span></div>
                                </div>
                            </div>
                        </ol> -->
                        <?php
                        foreach ($data['tasks'] as $key => $value) {
                            echo '<ol>';
                            echo '<div onclick="updateParameters('.$value['task_id'].')">';
                            if($value['last_targettype'] == 1){//angle
                                echo '<a id="step'.$value['task_id'].'" ><img src="./img/angle.png" alt="" style="height: 25px; width: 25px; float: left"> | SGT-CS303 | '. $text['Step_text'].$value['last_step_count'].' | '.$value['last_step_name'].' | '.$value['last_step_targetangle'].'&ordm;</a>';
                                echo '<div class="dropdown-content" id="target_torque-'.$value['task_id'].'" style="display:none;" step-id="'.$value['task_id'].'">';

                                if($value['last_job_type'] == 'normal'){
                                    echo '<div id="">'.$text['Step_text'].'1 '. $value['last_step_name'] .' | <span>'.$value['last_step_targetangle'].'&ordm;| '.$text['Hi_text'].' '.$value['last_step_highangle'].' | '.$text['Lo_text'].' '.$value['last_step_lowangle'].'</span></div>';
                                }else{
                                    foreach ($value['program'] as $key => $value) {
                                        if($value['step_targettype'] == 1 ){//angle
                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targetangle'].'&ordm;| '.$text['Hi_text'].' '.$value['step_highangle'].' | '.$text['Lo_text'].' '.$value['step_lowangle'].'</span></div>';
                                        }else{
                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targettorque'].'-Nm| '.$text['Hi_text'].' '.$value['step_hightorque'].' | '.$text['Lo_text'].' '.$value['step_lowtorque'].'</span></div>';
                                        }
                                    }
                                }

                                
                            }else{//torque
                                echo '<a id="step'.$value['task_id'].'" ><img src="./img/torque.png" alt="" style="height: 25px; width: 25px; float: left"> | SGT-CS303 | '.$text['Step_text'].$value['last_step_count'].' | '.$value['last_step_name'].' | '.$value['last_step_targettorque'].'-Nm</a>';
                                echo '<div class="dropdown-content" id="target_torque-'.$value['task_id'].'" style="display:none;" step-id="'.$value['task_id'].'">';

                                if($value['last_job_type'] == 'normal'){
                                    echo   '<div id="">'.$text['Step_text'].'1 '. $value['last_step_name'] .' | <span>'.$value['last_step_targettorque'].'-Nm| '.$text['Hi_text'].' '.$value['last_step_hightorque'].' | '.$text['Lo_text'].' '.$value['last_step_lowtorque'].'</span></div>';
                                }else{
                                    foreach ($value['program'] as $key => $value) {
                                        if($value['step_targettype'] == 1 ){//angle
                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targetangle'].'&ordm;| '.$text['Hi_text'].' '.$value['step_highangle'].' | '.$text['Lo_text'].' '.$value['step_lowangle'].'</span></div>';
                                        }else{
                                            echo '<div id="">'.$text['Step_text'].($key+1).' '. $value['step_name'] .' | <span>'.$value['step_targettorque'].'-Nm| '.$text['Hi_text'].' '.$value['step_hightorque'].' | '.$text['Lo_text'].' '.$value['step_lowtorque'].'</span></div>';
                                        }
                                    }
                                }
                                
                            }
                            echo    '</div>';
                            echo '</div>';
                            echo '</ol>';
                        }
                        ?>
            </div>
        </div>
    </div>

    <!-- New Task -->
    <div id="TaskNew" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width:100%">
                <header class="w3-container modal-header">
                    <span id="close_modal_1" onclick="close_modal()"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id="modal_head">New Task</h3>
                </header>

                <div class="modal-body">
                    <form id="new_task_form">
                        <div class="row">
                            <div class="col-4" style="font-size: 24px; text-align: left"><b><?php echo $text['main_equipment_text']; ?></b></div>

                            <div for="task_id" class="col-2 t1"><?php echo $text['Task_id_text']; ?> :</div>
                            <div class="col-3 t2">
                                <input type="text" min=1 max=99 class="form-control input-ms" id="task_id" maxlength="2" disabled="disabled">
                            </div>
                        </div>

                        <div class="scrollbar_e border-bottom" id="style-E">
                            <div class="scrollbar_e-force-overflow">
                                <div style="padding-left: 10px">
                                    <div class="row">
                                        <div for="new_task_form" class="col-2 t1"><b><?php echo $text['Controller_text']; ?></b></div>
                                        <div class="col-2 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="controller" id="gtcs" value="1" onclick="EquipmentCheckbox('gtcs')" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="gtcs">GTCS</label>
                                        </div>
                               	        <!-- <div class="col-3 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="controller" id="c3" value="2" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="c3">TCG Tool-SN</label>
                                        </div>
                               	        <div class="col-3 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="controller" id="c2" value="2" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="c2">GTCS MTF6000</label>
                                        </div> -->
                                    </div>
                                </div>

                                <div style="padding-left: 10px; margin: 10px 0">
                                    <div class="row">
                                        <div for="new_task_form" class="col-2 t1"><b><?php echo $text['Sensor_text']; ?></b></div>
                               	        <!-- <div class="col-2 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="button" id="button" value="2" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="button">Button</label>
                                        </div> -->
                                        <!-- <div class="col-3 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="pick-to-light" id="pick-to-light" value="3" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="pick-to-light">Pick-To-Light</label>
                                        </div> -->
                                        <div class="col-2 t2 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="" id="message" value="1" onclick="EquipmentCheckbox('message')" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="form-check-label" for="message"><?php echo $text['Virtual_message_text']; ?></label>
                                        </div>
                                        <div class="col t2 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="" id="socket-tray" value="1" style="zoom:1.0; vertical-align: middle" onclick="EquipmentCheckbox('socket-tray')">&nbsp;
                                            <label class="form-check-label" for="socket-tray"><?php echo $text['Socket_Tray_text']; ?></label>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- <div class="col-2 t1"></div>
                                        <div class="col-2 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="sleeve" id="sleeve" value="3" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="sleeve">Sleeve</label>
                                        </div>
                               	        <div class="col-3 t2 form-check form-check-inline">
                                            <input class="t2 form-check-input" type="checkbox" name="recycle-box" id="recycle-box" value="1" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="t2 form-check-label" for="recycle-box">Recycle Box</label>
                                        </div>
                                        <div class="col-3 t2 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="" id="screw-feeder" value="1" onclick="EquipmentCheckbox()" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="form-check-label" for="screw-feeder">Screw feeder</label>
                                        </div> -->
                                        
                                    </div>
                                </div>

                                <div style="padding-left: 10px; margin: 10px 0">
                                    <div class="row">
                                        <div for="new_task_form" class="col-2 t1"><b><?php echo $text['Arm_text']; ?></b></div>
                                        <div class="col-2 t2 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="" id="arm" value="0" onclick="EquipmentCheckbox('arm')" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="form-check-label" for="arm"><?php echo $text['Arm_text']; ?></label>
                                        </div>
                                        <div class="col t2 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="" id="screw-feeder-position" value="1" onclick="EquipmentCheckbox()" style="zoom:1.0; vertical-align: middle">&nbsp;
                                            <label class="form-check-label" for="screw-feeder-position"><?php echo $text['Screw_feeder_position_text']; ?></label>
                                        </div>
                                    </div>
                                </div>

                                <div style="padding-left: 10px; margin: 10px 0">
                                    <div class="row">
                                        <div for="new_task_form" class="col-2 t1"><b><?php echo $text['Timeout_text']; ?></b></div>
                                        <div for="new_task_form" class="col t1" style="padding-left:0;">
                                            <input class="form-control input-ms" id="delaytime" value="0" style="zoom:1.0; vertical-align:middle;width: 75px; margin-left: 0px">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Program Setiing -->
                        <div class="scrollbar-all" id="style-all">
                            <div class="force-overflow-all">
                                <!-- Socket tray Setiing -->
                                <div id="socketTray-setting" style="display:none;">
                                    <div for="new_task_form" class="col-3 t1"><b><?php echo $text['Socket_Tray_text']; ?></b></div>
                                    <div style="padding-left: 5%;margin-bottom: 15px;">
                                        <div class="col t2" style="padding: 5px;">
                                            <div class="row t2">
                                                <div class="col-5 t3 Sockettray" style="display: flex;">
                                                    <select id="hole_select">
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>
                                <!-- program Setiing -->
                                <div id="program-setting" style="display: none;">
                                    <div for="new_task_form" class="col-3 t1"><b><?php echo $text['Program_controller_text']; ?></b></div>
                                    <div class="scrollbar-Program border-bottom-div" id="style-Program">
                                        <div class="force-overflow-Program" style="padding-left: 7%">
                                            <div id="TemplateContainer" class="row">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- ARM Setiing -->
                                <div id="ARM-setting" style="display: none;">
                                    <div for="new_task_form" class="col t1"><b><?php echo $text['Arm_text']; ?></b></div>
                                    <div class="col t1"><?php echo $text['Task_screw_position_text']; ?></div>
                                    <div style="padding-left: 5%;margin-bottom: 15px">
                                        <div style="padding: 5px;">
                                            <div class="row t1">
                                                <div class="col-12 t2">
                                                    <input type="text" class="form-control input-ms" value="(100,100)" id="position" maxlength="50" disabled="disabled" style="margin-right: 10px; background-color: #DEDEDE; font-size: 18px;width: 150px; height: 30px">
                                                    <button id="button-confirm" type="button" onclick="get_arm_position()" value=""><?php echo $text['Confirm_text']; ?></button>
                                                    <button id="button-cancel" type="button"><?php echo $text['Cancel_text']; ?></button>
                                                </div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col-5 t1" for=""><?php echo $text['Encoder_text'].' 1 '.$text['Tolerance_setting_text']; ?></div>
                                                <div class="col-4 t2">
                                                    <input type="text" class="form-control input-ms" value="200" id="tolerance1" maxlength="5" style="margin-right: 10px; font-size: 18px; height: 30px">
                                                </div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col-5 t1" for=""><?php echo $text['Encoder_text'].' 2 '.$text['Tolerance_setting_text']; ?></div>
                                                <div class="col-4 t2">
                                                    <input type="text" class="form-control input-ms" value="200" id="tolerance2" maxlength="5" style="margin-right: 10px; font-size: 18px; height: 30px">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>

                                <!-- Message Setiing -->
                                <div id="Message-setting" style="display: none;">
                                    <div for="new_task_form" class="col-3 t1"><b><?php echo $text['Virtual_message_text']; ?></b></div>
                                    <div style="padding-left: 5%; margin-bottom: 15px">
                                        <div style="padding: 5px;">
                                            <div class="col-2 t2 form-check form-check-inline" style="padding-left: 0px">
                                                <!-- <input class="form-check-input" type="checkbox" name="text" id="text" value="0" style="zoom:1.0; vertical-align: middle">&nbsp; -->
                                                <label class="form-check-label" for="text"><?php echo $text['Text_text']; ?></label>
                                            </div>
                                            <div class="row">
                                                <div class="col" style="padding-left: 15%">
                                                    <textarea id="message_text" class="form-control" rows="2" id="comment" name="text" style="width: 300px;" maxlength="80"></textarea>
                                                </div>
                                            </div>

                                            <div class="col-12 t2 form-check form-check-inline" style="padding-left: 0px">
                                                <!-- <input class="form-check-input" type="checkbox" name="picture" id="picture" value="0" style="zoom:1.0; vertical-align: middle">&nbsp; -->
                                                <label class="form-check-label" for="picture"><?php echo $text['Picture_text']; ?></label>
                                                <label for="fileInput" class="file-label" style="height: 30px; width: 30px; align-content: center;">✚</label>
                                                <input type="file" id="fileInput" name="mediaFile" accept="image/*,video/*,audio/*" style="opacity: 0;">
                                            </div>
                                            <div class="row" style="padding-left: 14%">
                                                <div id="previewContainer" class="col-6 t2">
                                                </div>
                                            </div>

                                            <div class="col-2 t2" for=""><?php echo $text['Timeout_text']; ?></div>
                                            <div class="row" style="padding:3px">
                                                <div class="col-4 t2" style="padding-left: 15%">
                                                    <input type="number" class="form-control input-ms" value="0" id="message_timeout" maxlength="5"><?php echo $text['Sec_text'];?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>

                                <!-- Screw Feeder Position Setiing -->
                                <div id="ScrewFeederPosition" style="display:none;">
                                    <div class="col t1"><b><?php echo $text['Screw_feeder_position_text']; ?></b></div>
                                    <div style="padding-left: 5%;margin-bottom: 15px;">
                                        <div class="col t2" style="padding: 5px;">
                               	            <div class="col form-check form-check-inline">
                                                <input class="form-check-input" type="checkbox" name="A-pickup" id="a-pickup" value="" onclick="EquipmentCheckbox()" style="zoom:1.0; vertical-align: middle">
                                                <label class="form-check-label" for="a-pickup">A pick up area</label>
                                            </div>
                                	        <div class="col form-check form-check-inline">
                                                <input class="form-check-input" type="checkbox" name="B-pickup" id="b-pickup" value="" style="zoom:1.0; vertical-align: middle">
                                                <label class="form-check-label" for="b-pickup">B pick up area</label>
                                            </div>
                                            <div class="col form-check form-check-inline">
                                                <input class="form-check-input" type="checkbox" name="C-pickup" id="c-pickup" value="" style="zoom:1.0; vertical-align: middle">
                                                <label class="form-check-label" for="c-pickup">C pick up area</label>
                                            </div>
                                            <div class="col form-check form-check-inline">
                                                <input class="form-check-input" type="checkbox" name="B-pickup" id="d-pickup" value="" style="zoom:1.0; vertical-align: middle">
                                                <label class="form-check-label" for="d-pickup">D pick up area</label>
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>

                                <!-- Recycle Box Setiing -->
                                <div id="Recycle-Box-setting" style="display:none;">
                                    <div for="new_task_form" class="col-3 t1"><b>Recycle Box</b></div>
                                    <div style="padding-left: 5%;margin-bottom: 15px;">
                                        <div class="row t1" style="padding: 5px;">
                                            <div for="count-mode" class="col-4 t1">Count Mode</div>
                                            <div class="switch menu col-4 t2">
                                                <input id="count-mode-on-off" type="checkbox" checked>
                                                <label><i></i></label>
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>

                                <!-- Pick to light Setiing -->
                                <div id="pick-to-light-setting" style="display:none;">
                                    <div for="new_task_form" class="col-3 t1"><b>Pick-To-Light</b></div>
                                    <div style="padding-left: 5%;margin-bottom: 15px">
                                        <div class="row t1" style="padding: 5px;">
                                            <div for="Pick-To-Light" class="col-4 t1">Mode</div>
                                            <div class="switch menu col-4 t2">
                                                <input id="Light-on-off" type="checkbox" checked>
                                                <label><i></i></label>
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>

                                <!-- Screw Feeder Setiing -->
                                <div id="Screw-Feeder-setting" style="display:none;">
                                    <div for="new_task_form" class="col-3 t1"><b>Screw Feeder</b></div>
                                    <div style="padding-left: 5%; margin-bottom: 15px">
                                        <div class="col t1" style="padding: 5px;">
                                            <div class="col-4 t1" for="">Comtinue times</div>
                                            <div class="col-2 t2">
                                                <input type="number" style="height: 30px" class="form-control" value="0" id="Screw-Feeder" maxlength="5">
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="width: 98%; background-color: #999999">
                                </div>

                                <!-- Button Setiing -->
                                <div id="Button-setting" style="display:none;">
                                    <div for="new_task_form" class="col-3 t1"><b>Button</b></div>
                                    <div style="padding-left: 5%; margin-bottom: 15px">
                                        <div class="row t1" style="padding: 5px;">
                                            <div for="button-mode" class="col-4 t1">Mode</div>
                                            <div class="switch menu col-4 t2">
                                                <input id="button-on-off" type="checkbox" checked>
                                                <label><i></i></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                             </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="new_task_save()"><?php echo $text['Save_text'];?></button>
                    <button id="close_modal_2" class="button button3" onclick="close_modal()" class="cancelbtn"><?php echo $text['Cancel_text'];?></button>
                </div>
            </div>
        </div>
    </div>

<script>
// Get the modal
var modal = document.getElementById('TaskNew');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    // console.log(event.target)
    // console.log(event.target.className)
    // if (event.target == modal) {
    //     modal.style.display = "none";
    // }

    if (event.target.className == 'circle') {

    }
}

// choose controller and sensor  //
function EquipmentCheckbox(item)
{
    let expr = '';
    switch (item) {
      case 'gtcs':
        get_gtcs_template(item);
        // var controller1 = document.getElementById(item);
        // var program1 = document.getElementById("program-setting");
        // if (controller1.checked == true) {
        //     program1.style.display = "block";
        // } else {
        //     program1.style.display = "none";
        // }
        break;
      case 'arm':
        var controller1 = document.getElementById(item);
        var program1 = document.getElementById("ARM-setting");
        if (controller1.checked == true) {
            program1.style.display = "block";
        } else {
            program1.style.display = "none";
        }
        break;
      case 'message':
        var controller1 = document.getElementById(item);
        var program1 = document.getElementById("Message-setting");
        if (controller1.checked == true) {
            program1.style.display = "block";
        } else {
            program1.style.display = "none";
        }

        //message 超時 預設 3秒
        document.getElementById('message_timeout').value = 3;
        break;

      case 'socket-tray':
        var controller1 = document.getElementById(item);
        var program1 = document.getElementById("socketTray-setting");
        if (controller1.checked == true) {
            program1.style.display = "block";
        } else {
            program1.style.display = "none";
        }
        break;
      default:
        console.log(`Sorry, we are out of ${expr}.`);
    }
}

// Task step setting //
function updateParameters(index)
{
    var target_torque = document.getElementById('target_torque-'+index);
    var step = document.getElementById('step'+index);

    //先關閉全部
    var Divs = document.querySelectorAll("div[id^='target_torque-']");
    Divs.forEach(function(div) {        
        div.style.display = 'none';
        div.previousElementSibling.style.color = 'black';
        div.previousElementSibling.style.backgroundColor = '#fff';
        div.classList.remove("seleted");
    });

    if (target_torque.style.display.trim() === 'none')
    {
        target_torque.style.display = 'inline-block';
        // target_torque.style.float = 'inline-start';
        step.style.color = 'white';
        step.style.backgroundColor = '#2A7E54';
        target_torque.classList.add("seleted");
    }
    else
    {
        target_torque.style.display = 'none';
        step.style.color = 'black';
        step.style.backgroundColor = '#fff';
        target_torque.classList.remove("seleted");
    }

    let All_circles = document.querySelectorAll('div[data-id]');
    All_circles.forEach(function(circle) {
        if(circle.getAttribute('data-id') == index){
            circle.style.backgroundColor = 'green';
            circle.style.color = 'white';
        }else{
            circle.style.backgroundColor = 'white';
            circle.style.color = 'black';
        }
    });

}

</script>

<script>

$(document).ready(function () {
    //img帶入
    document.getElementById('imgId').src = '<?php echo $data['seq_img']; ?>';
});

//new seq 按下new seq button
function new_task() {
    //get new seq_id
    let job_id = document.getElementById("job_id").value;
    let seq_id = document.getElementById("seq_id").value;

    let task_id = get_task_id_normal(job_id,seq_id);
    if (task_id > 10) { //避免新增超過10個task
        return 0;
    }
    document.getElementById('gtcs').checked = false;//arm
    document.getElementById('arm').checked = false;
    document.getElementById("program-setting").style.display = 'none';
    document.getElementById("ARM-setting").style.display = 'none';

    document.getElementById('modal_head').innerHTML = '<?php echo $text['New_Task_text']; ?>'; //'New Job'
    //帶入預設值
    document.getElementById("task_id").value = task_id;
    document.getElementById("close_modal_1").setAttribute("onclick", "close_modal()");
    document.getElementById("close_modal_2").setAttribute("onclick", "close_modal()");

    document.getElementById('TaskNew').style.display = 'block'
}

function get_task_id_normal(job_id,seq_id) {
    let task_id = '';
    $.ajax({
        type: "POST",
        url: "?url=Tasks/get_head_task_id",
        data: { 'job_id': job_id, 'seq_id': seq_id },
        dataType: "json",
        encode: true,
        async: false, //等待ajax完成
    }).done(function(data) { //成功且有回傳值才會執行
        task_id = data['missing_id'];
    });

    return task_id;
}

//new task 按下save鍵
function new_task_save() {
    let job_id = document.getElementById("job_id").value;
    let seq_id = document.getElementById("seq_id").value;
    let task_id = document.getElementById("task_id").value;
    let screw_template_id = document.querySelector('input[name="screw"]:checked').value;
    let position = document.getElementById("position").value;
    let tolerance = document.getElementById("tolerance1").value;
    let tolerance2 = document.getElementById("tolerance2").value;
    let message_text = document.getElementById("message_text").value;
    let delaytime = document.getElementById("delaytime").value;
    // let img_div = document.getElementById('img-container').innerHTML;//Tolerance 
    let img_div = document.querySelector('div[data-id="'+task_id+'"]').outerHTML
    let controller_id = document.querySelector('input[name="controller"]:checked').value;
    let enable_arm = document.getElementById('arm').checked;
    let sockect_hole = document.getElementById('hole_select').value;
    

    let circle_width = document.querySelector('div[data-id="'+task_id+'"]').style.width
    let circle_height = document.querySelector('div[data-id="'+task_id+'"]').style.height
    let circle_top = document.querySelector('div[data-id="'+task_id+'"]').style.top
    let circle_left = document.querySelector('div[data-id="'+task_id+'"]').style.left

    img_div = `style="width: `+circle_width+`; height: `+circle_height+`; top: `+circle_top+`; left: `+circle_left+`;"`

    if (!document.getElementById('socket-tray').checked){//沒有打勾
        sockect_hole = -1;
    }

    var formData = new FormData();
    // 添加表单数据
    formData.append('job_id', job_id);
    formData.append('seq_id', seq_id);
    formData.append('task_id', task_id);
    formData.append('screw_template_id', screw_template_id);
    formData.append('position', position);
    formData.append('tolerance', tolerance);
    formData.append('tolerance2', tolerance2);
    formData.append('message_text', message_text);
    formData.append('delaytime', delaytime);
    formData.append('img_div', img_div);
    formData.append('controller_id', controller_id);
    formData.append('enable_arm', +enable_arm);
    formData.append('sockect_hole', +sockect_hole);

    let virtual_message_check = document.getElementById('message').checked
    formData.append('virtual_message_check', virtual_message_check);

    let fileInput = $('#fileInput')[0].files[0];
    formData.append('fileInput', fileInput);

    let message_timeout = document.getElementById("message_timeout").value;
    formData.append('message_timeout', message_timeout);

    console.log(formData);
    console.log(formData.job_id);
    console.log(formData.position);


    let url = '?url=Tasks/edit_task';
    $.ajax({
        type: "POST",
        data: formData,
        dataType: "json",
        url: url,
        processData: false,
        contentType: false,
        success: function(response) {
            // 成功回調函數，處理伺服器的回應
            console.log(response); // 在控制台輸出伺服器的回應
            // history.go(0);
            if (response.error == '') {
                history.go(0);
            } else {

            }
        },
        error: function(error) {
            // 失敗回調函數，處理錯誤情況
            // console.error('Error:', error); // 在控制台輸出錯誤訊息
        }
    }).fail(function() {
        // history.go(0); //失敗就重新整理
    });
}

function close_modal() {
    // body...
    let task_id = document.getElementById('task_id').value;
    console.log(task_id)
    //移除圓形圖示
    let aa = document.querySelector("div[data-id='"+task_id+"']");
    if(aa != null){ aa.remove(); }

    document.getElementById('TaskNew').style.display='none'

}

//get task by id
function edit_task() {
    let job_id = document.getElementById('job_id').value;
    let seq_id = document.getElementById('seq_id').value;
    let task_id = document.getElementsByClassName('dropdown-content seleted')[0].getAttribute('step-id');
    console.log(task_id)
    // let task_id = rowSelected[0].childNodes[0].innerHTML;

    let url = '?url=Tasks/get_task_by_id';
    $.ajax({
        type: "POST",
        url: url,
        data: { 'job_id': job_id,'seq_id': seq_id,'task_id': task_id },
        dataType: "json",
        beforeSend: function( xhr ) {
            document.getElementById('gtcs').checked = false;
            document.getElementById('arm').checked = false;
            document.getElementById('socket-tray').checked = false;
            document.getElementById('message').checked = false;
            EquipmentCheckbox('arm');
            EquipmentCheckbox('gtcs');
            EquipmentCheckbox('socket-tray');
            EquipmentCheckbox('message');
            document.getElementById('fileInput').value = '';
            document.getElementById('previewContainer').innerHTML = '';
            document.getElementById('message_text').value = '';
        }
    }).done(function(response) { //成功且有回傳值才會執行

        document.getElementById('modal_head').innerHTML = '<?php echo $text['Edit_Task_text']; ?>'; //'New Job'
        //帶入預設值
        document.getElementById("task_id").value = task_id;
        document.getElementById("close_modal_1").setAttribute("onclick", "document.getElementById('TaskNew').style.display='none'");
        document.getElementById("close_modal_2").setAttribute("onclick", "document.getElementById('TaskNew').style.display='none'");

        console.log(response)
        if(response['controller'] == 1){//帶入controller
            document.getElementById('gtcs').checked = true;
            EquipmentCheckbox('gtcs');
        }
        if(response['enable_arm'] == 1){//帶入arm
            document.getElementById('arm').checked = true;
            EquipmentCheckbox('arm');
            //position
            document.getElementById('position').value = '('+parseInt(response.position_x)+','+parseInt(response.position_y)+')';
            //tolerance
            document.getElementById('tolerance1').value = response.tolerance;
            document.getElementById('tolerance2').value = response.tolerance2;
        }
        if(response['hole_id'] != null){//帶入controller
            if(response['hole_id'] > 0){
                document.getElementById('hole_select').value = response.hole_id;
                document.getElementById('socket-tray').checked = true;
                EquipmentCheckbox('socket-tray');    
            }
        }
        //帶入template id
        if(response['template_program_id'] != ''){//
            setTimeout(() => { //等待template載入完成
              document.getElementById('screw_'+response['template_program_id']).checked = true;
            }, 200);
        }
        //帶入virtaul message
        if(response['img'] != null || response['text'] != null){
            document.getElementById('message').checked = true;
            EquipmentCheckbox('message');
            document.getElementById('message_text').value = response['text'];
            document.getElementById('message_timeout').value = response['message_timeout'];
            let previewContainer = document.getElementById('previewContainer');
            previewContainer.innerHTML = ''; // 清空以前的预览

            let fileType = response['type'];
            let url = response['img'];

            if (fileType.startsWith('image')) {
                const img = document.createElement('img');
                img.id = 'virtual_file'
                img.src = url;
                img.width = 300;
                img.height = 200;
                previewContainer.appendChild(img);
            } else if (fileType.startsWith('video')) {
                const video = document.createElement('video');
                video.id = 'virtual_file'
                video.src = url;
                video.controls = true;
                video.width = 300;
                video.height = 200;
                previewContainer.appendChild(video);
            } else if (fileType.startsWith('audio')) {
                const audio = document.createElement('audio');
                audio.id = 'virtual_file'
                audio.src = url;
                audio.controls = true;
                previewContainer.appendChild(audio);
            } else {
                // alert('不支持的文件类型');
            }

        }

        document.getElementById('TaskNew').style.display = 'block'
    });

}

function get_gtcs_template(item) {
    
    //load screw templates
    let url = '?url=Templates/get_gtcs_templates';
    $.ajax({
        type: "POST",
        url: url,
        data: {},
        dataType: "json"
    }).done(function(response) { //成功且有回傳值才會執行
        const container = document.getElementById('TemplateContainer'); // 用于放置单选按钮的容器元素
        container.innerHTML = "";

        response.forEach(item => {
            const div = document.createElement('div');
            div.classList.add('col-5', 't1');

            const input = document.createElement('input');
            input.classList.add('form-check-input');
            input.type = 'radio';
            input.name = 'screw';
            input.id = `screw_${item.template_program_id}`;
            input.value = item.template_program_id;
            input.onclick = function() {
                // 在这里放置单选按钮点击后的事件处理逻辑
            };

            const labelDiv = document.createElement('div');
            labelDiv.classList.add('col-2');
            labelDiv.textContent = '';

            const label = document.createElement('label');
            label.classList.add('form-check-label');
            label.htmlFor = `screw_${item.template_program_id}`;

            if(item.step_targettype == 2){//target = torque
                label.textContent = `${item.step_name} | Tool | ${item.step_targettorque} N.m`;
            }else{//target = angle
                label.textContent = `${item.step_name} | Tool | ${item.step_targetangle} º`;
            }

            if (typeof item.template_program_name !== 'undefined') {
                if(item.step_targettype == 2){//target = torque
                    label.textContent = `${item.template_program_name} | Tool | ${item.step_targettorque} N.m`;
                }else{//target = angle
                    label.textContent = `${item.template_program_name} | Tool | ${item.step_targetangle} º`;
                }
            }

            div.appendChild(input);
            div.appendChild(labelDiv);
            div.appendChild(label);
            
            container.appendChild(div);
        });

    });

    //show or hide template div
    var controller1 = document.getElementById(item);
    var program1 = document.getElementById("program-setting");
    if (controller1.checked == true) {
        program1.style.display = "block";
    } else {
        program1.style.display = "none";
    }
}

function delete_task() {
    let job_id = document.getElementById("job_id").value;
    let seq_id = document.getElementById("seq_id").value;
    let task_id = document.getElementsByClassName('dropdown-content seleted')[0].getAttribute('step-id');

    var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>');

    if (yes) {
        let url = '?url=Tasks/delete_task_by_id';
        $.ajax({
            type: "POST",
            data: { 'job_id': job_id, 'seq_id': seq_id, 'task_id': task_id },
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                // console.log(response); // 在控制台輸出伺服器的回應
                history.go(0);
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function() {
            // history.go(0);//失敗就重新整理
        });
    } else {

    }
}

//save img position
function save_position() {
    let job_id = document.getElementById("job_id").value;
    let seq_id = document.getElementById("seq_id").value;
    let items = [];
    let divs = document.querySelectorAll('div[data-id]')
    divs.forEach((div) => {
      let task_id = div.getAttribute("data-id");
      let img_div = '';
      let circle_width = div.style.width
      let circle_height = div.style.height
      let circle_top = div.style.top
      let circle_left = div.style.left
      img_div = `style="width: `+circle_width+`; height: `+circle_height+`; top: `+circle_top+`; left: `+circle_left+`;"`
      items.push( { index: task_id, img_div: img_div } );
    });

    let url = '?url=Tasks/save_position_only';
        $.ajax({
            type: "POST",
            data: { 'job_id': job_id, 'seq_id': seq_id, 'items': items },
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                // console.log(response); // 在控制台輸出伺服器的回應
                history.go(0);
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function() {
            history.go(0);//失敗就重新整理
        });

}

</script>

<script type="text/javascript">
    //upload img/video/audio
    document.getElementById('fileInput').addEventListener('change', function(event) {
            const file = event.target.files[0];
            const previewContainer = document.getElementById('previewContainer');
            previewContainer.innerHTML = ''; // 清空以前的预览

            if (file) {
                const fileType = file.type;
                const url = URL.createObjectURL(file);

                
                const fileSize = file.size; //檔案大小
                const maxSize = 5 * 1024 * 1024; // 檔案上限為5MB
                
                //檢查文件的大小 超過5MB 就跳出提示訊息 且;
                if (fileSize > maxSize) {
                    alert('檔案大小超過限制，最大只允許 5MB。');
                    var nn_job_id = document.getElementById("job_id").value;
                    var nn_seq_id = document.getElementById("seq_id").value;
                    var task_url = '?url=Tasks/index/'+ nn_job_id + '/' + nn_seq_id;

                    //window.location.href = task_url;
                    return false;
                }
                

                if (fileType.startsWith('image/')) {
                    const img = document.createElement('img');
                    img.id = 'virtual_file'
                    img.src = url;
                    img.width = 300;
                    img.height = 200;
                    previewContainer.appendChild(img);
                } else if (fileType.startsWith('video/')) {
                    const video = document.createElement('video');
                    video.id = 'virtual_file'
                    video.src = url;
                    video.controls = true;
                    video.width = 300;
                    video.height = 200;
                    previewContainer.appendChild(video);
                } else if (fileType.startsWith('audio/')) {
                    const audio = document.createElement('audio');
                    audio.id = 'virtual_file'
                    audio.src = url;
                    audio.controls = true;
                    previewContainer.appendChild(audio);
                } else {
                    alert('不支持的文件类型');
                }
                document.getElementById('virtual_file').addEventListener('ended',myHandler,false);
            }
        });

    
    function myHandler(e) {
        // What you want to do after the event
        // alert(123)
    }

</script>

<!-- arm js -->
<script type="text/javascript">

    function get_arm_position() {
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
        };

        websocket.onclose = function (evt) {
            // console.log("Disconnected");
        };

        websocket.onmessage = function (evt) {
            // console.log('Retrieved data from server: ' + evt.data);
            let axis = evt.data.split(',');
            coordinate(axis);
            // document.getElementById('position').value = axis[0];
            
            websocket.close();
        };

        websocket.onerror = function (evt, e) {
            console.log('Error occured: ' + evt.data);
        };
    }



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
        document.getElementById('position').value = `(${round_x},${round_y})`;

        let target_x = 38;
        let target_y = 30.9;
        let bias = 1;
    }

    function deg2rad(degrees) {
      return degrees * (Math.PI / 180);
    }

// Notification ....................
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
</script>
<!-- end arm js -->

<style>
.circle{
    scale:<?php echo (1 + 1*($data['job_data']['point_size']/100) );?>;
}
</style>


</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>