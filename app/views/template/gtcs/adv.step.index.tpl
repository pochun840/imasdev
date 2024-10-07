<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/advance_step.css" type="text/css">

<?php echo $data['nav']; ?>

<style>

.t1{font-size: 18px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 18px; margin: 3px 0px;}
</style>

<div class="container-ms">

    <header>
        <div class="program">
            <img id="header-img" src="./img/template-head.svg"><?php echo $text['Program_Template_text']; ?>
        </div>
        <div class="notification">
            <i style="width:auto; height:40px" class="fa fa-bell" onclick="ClickNotification()"></i>
            <span id="messageCount" class="badge"></span>
        </div>
        <div class="personnel"><i style="width:auto; height: 40px;font-size: 26px" class="fa fa-user"></i> <?php echo $_SESSION['user']; ?></div>
    </header>

    <!-- Notification -->
    <div id="messageBox" class="messageBox" style="display: none;">
        <div class="topnav-message">
            <label type="text" style="font-size: 24px; padding-left: 3%; margin: 7px 0; color: #000"><b>Notification</b></label>
            <span class="close-message w3-display-topright" onclick="ClickNotification()">&times;</span>
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
                        <label class="recyclebox">Recycle box</label>
                        <label class="workstation">workstation 3</label>
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
                        <label class="recyclebox">Recycle box</label>
                        <label class="workstation">workstation 3</label>
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
                        <label class="recyclebox">Recycle box</label>
                        <label class="workstation">workstation 3</label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="topnav">
        <label type="text" style="font-size: 22px; margin: 4px;"><?php echo $text['Advanced_Step_text']; ?></label>
        <div class="topnav-right">
            <button class="btn" id="back-btn" type="button" onclick="location.href = '?url=Templates/advancedstep_index';">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="row" style="margin-bottom: 5px;">
                <div for="porgram-id" class="col-1 t1"><?php echo $text['Program_ID_text']; ?>:</div>
                <div class="col-1 t2" style="margin-right: 1%">
                    <input type="number" class="form-control input-ms" id="porgram-id" value="<?php echo $data['program_id']; ?>" maxlength="" disabled="disabled">
                </div>

                <div for="program-name" class="col-2 t1" style="margin-right: -5%"><?php echo $text['Program_Name_text']; ?>:</div>
                <div class="col-2 t2">
                    <input type="text" class="form-control input-ms" id="program-name" value="<?php echo $data['program_name']; ?>" maxlength="" disabled="disabled" >
                </div>

                <div class="col t1">
                    <button id="add-step" type="button" onclick="new_step()">
                        <img id="img-add" src="./img/add-program.svg" alt=""><?php echo $text['Add_Step_text']; ?>
                    </button>

                    <button id="copy-step" type="button" onclick="copy_step_div()">
                        <img id="img-copy" src="./img/program-copy.svg" alt=""><?php echo $text['Copy_text']; ?>
                    </button>

                    <button id="delete-step" type="button" onclick="delete_advanced_step()">
                        <img id="img-delete" src="./img/program-delete.svg" alt=""><?php echo $text['Delete_text']; ?>
                    </button>

                    <button id="test" type="button">
                        <img id="img-test" src="./img/check-all.png"> <?php echo $text['Test_text']; ?>
                    </button>

                    <button id="add-step" type="button" onclick="sync_program()">
                        <img id="img-add" src="./img/add-program.svg" alt=""><?php echo $text['Sync_Program_text']; ?>                   
                    </button>

                </div>
            </div>

            <div class="scrollbar" id="style-program">
                <div class="force-overflow">
                    <table class="table table-bordered" id="table">
                        <thead id="header-table" style="background-color: #A3A3A3; font-size: 2vmin">
                            <tr style="text-align: center; vertical-align: middle;">
                                <th width="5%"></th>
                                <th width="8%"><?php echo $text['Step_ID_text']; ?></th>
                                <th width="15%"><?php echo $text['Step_Name_text']; ?></th>
                                <th width="10%"><?php echo $text['Target_Q_text']; ?> (N.m)</th>
                                <th width="10%"><?php echo $text['Target_A_text']; ?> (&#186;)</th>
                                <th width="10%"><?php echo $text['Hi_Q_text']; ?></th>
                                <th width="10%"><?php echo $text['Lo_Q_text']; ?></th>
                                <th width="10%"><?php echo $text['Hi_A_text']; ?></th>
                                <th width="10%"><?php echo $text['Lo_A_text']; ?></th>
                                <th width="10%"><?php echo $text['Edit_text']; ?></th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                            <?php 
                                foreach ($data['steps'] as $key => $step) {
                                    echo '<tr>';
                                    echo '<td><input class="form-check-input" type="checkbox" name="" value="0" style="zoom:1.0; vertical-align: middle"></td>';
                                    echo '<td>'.$step['template_step_id'].'</td>';
                                    echo '<td>'.$step['step_name'].'</td>';
                                    echo '<td>'.$step['step_targettorque'].'</td>';
                                    echo '<td>'.$step['step_targetangle'].'</td>';
                                    echo '<td>'.$step['step_hightorque'].'</td>';
                                    echo '<td>'.$step['step_lowtorque'].'</td>';
                                    echo '<td>'.$step['step_highangle'].'</td>';
                                    echo '<td>'.$step['step_lowangle'].'</td>';
                                    echo '<td>';
                                    if($step['step_targettype'] == 2){  //edit image
                                        echo  '<img src="./img/torque.png" width="40" height="40" alt="" onclick="edit_adv_step('.$step['template_step_id'].')">';
                                    }else{
                                        echo  '<img src="./img/angle.png" width="40" height="40" alt="" onclick="edit_adv_step('.$step['template_step_id'].')">';
                                    }
                                    echo '</td>';
                                    echo '</tr>';
                                }
                            ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

     <!-- New Step -->
    <div id="StepNew" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width:100%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('StepNew').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id="modal_head"><?php echo $text['New_Step_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="new_step_form">
                        <div id="Torque_Parameter" style="display: block">
                            <div style="padding-left: 5%">
                                <div class="row t1">
                                    <div class="col-3 t1" for=""><?php echo $text['Program_ID_text']; ?> :</div>
                                    <div class="col-2 t2">
                                        <input type="text" id="program-id" class="form-control input-ms" value="<?php echo $data['program_id']; ?>" maxlength="" disabled="disabled">
                                    </div>
                                    <div class="col-3 t1" for=""><?php echo $text['Program_Name_text']; ?> :</div>
                                    <div class="col-3 t2">
                                        <input type="text" id="program-name" class="form-control input-ms" value="<?php echo $data['program_name']; ?>" maxlength="" disabled="disabled">
                                    </div>
                                </div>
                            </div>

                            <div class="scrollbar-NewStep" id="style-newstep">
                                <div class="NewStep-force-overflow">
                                    <div style="padding-left: 5%; background-color: #D9D9D9">
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Max_Torque_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="max-torque" class="form-control input-ms" value="5.0" maxlength="" disabled="disabled">
                                            </div>
                                            <div class="col t2">N.m</div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Step_ID_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="step-id" class="form-control input-ms" value="1" maxlength="" disabled="disabled">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Step_Name_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="step-name" class="form-control input-ms" value="Step-1" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Target_Type_text']; ?> :</div>
                                            <div class="col-4 t2">
                              					<select id="target_type" style="width: 215px; height: 32px; border: 0">
                               					    <option value="2"><?php echo $text['Torque_text']; ?></option>
                               					    <option value="1"><?php echo $text['Angle_text']; ?></option>
                                  				</select>
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" style="font-size: 20px"><?php echo $text['Direction_text']; ?> :</div>
                                            <div class="col t2">
                                     	        <div class="col-3 form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" checked="checked" name="direction-option" id="direction-cw" value="0"style="zoom:1.2; vertical-align: middle">
                                                    <label class="form-check-label" for="direction-cw"><?php echo $text['CW_text']; ?></label>
                                                </div>
                                      	        <div class="col form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" name="direction-option" id="direction-ccw" value="1" style="zoom:1.2; vertical-align: middle">
                                                    <label class="form-check-label" for="direction-ccw"><?php echo $text['CCW_text']; ?></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['RunDownSpeed_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="run-down-speed" class="form-control input-ms" value="100" maxlength="">
                                            </div>
                                            <div class="col t2"><?php echo $text['max_rpm_text']; ?> 1100</div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Target_Torque_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="target-torque" class="form-control input-ms" value="0.6" maxlength="">
                                            </div>
                                            <div class="col t2">N.m</div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Target_Angle_text']; ?>(&#186;) :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="target-angle" class="form-control input-ms" value="1800" maxlength="" disabled="disabled">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" for=""><?php echo $text['Delay_Time_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="delay-time" class="form-control input-ms" value="0.0" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1"><?php echo $text['Joint_Offset_text']; ?> :</div>
                                            <div class="col-1 t2">
                              					<select id="joint-offset" style="width: 50px; height: 32px; border: 0">
                               					    <option value="0">&#10010;</option>
                               					    <option value="1">&#9866;</option>
                                  				</select>
                                            </div>
                                            <div class="col-3 t2">
                                                <input type="text" id="offset-value" class="form-control input-ms" value="0.0" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1" style="font-size: 20px"><?php echo $text['Monitor_Mode_text']; ?> :</div>
                                            <div class="col t2">
                                     	        <div class="col-3 form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" name="monitor-option" id="window" value="0"style="zoom:1.2; vertical-align: middle" checked="checked">
                                                    <label class="form-check-label" for="window"><?php echo $text['Window_text']; ?></label>
                                                </div>
                                      	        <div class="col form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" name="monitor-option" id="Hi-Low" value="1" style="zoom:1.2; vertical-align: middle">
                                                    <label class="form-check-label" for="Hi-Low"><?php echo $text['Hi_Low_text']; ?></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1"><?php echo $text['Monitor_Angle_text']; ?> :</div>
                                            <div class="switch MonitorAngle col-5 t2">
                                                <input id="MonitorAngle-ON-OFF" name="MonitorAngle-ON-OFF" type="checkbox" checked>
                                                <label><i></i></label>
                                            </div>
                                        </div>
                                        <div class="row t1" id="Over_Ang_Stop_tr">
                                            <div class="col-3 t1"><?php echo $text['Over_Angle_Stop_text']; ?> :</div>
                                            <div class="switch AngleStop col-5 t2">
                                                <input id="AngleStop-ON-OFF" name="AngleStop-ON-OFF" type="checkbox">
                                                <label><i></i></label>
                                            </div>
                                        </div>
                                        <div class="row t1" id="Torque_Window_tr">
                                            <div class="col-3 t1" for=""><?php echo $text['Torque_Window_text']; ?> :</div>
                                            <div class="col-2 t2">
                                                <input type="text" id="torque-window" class="form-control input-ms" value="0.6" maxlength="" disabled>
                                            </div>
                                            <div class="col-1 t1" for="">+/-</div>
                                            <div class="col-2 t2">
                                                <input type="text" id="torque-window-range" class="form-control input-ms" value="0.6" maxlength="" >
                                            </div>
                                        </div>
                                        <div class="row t1" id="Angle_Window_tr">
                                            <div class="col-3 t1" for=""><?php echo $text['Angle_Window_text']; ?> :</div>
                                            <div class="col-2 t2">
                                                <input type="text" id="angle-window" class="form-control input-ms" value="1800" maxlength="" >
                                            </div>
                                            <div class="col-1 t1" for="">+/-</div>
                                            <div class="col-2 t2">
                                                <input type="text" id="angle-window-range" class="form-control input-ms" value="1800" maxlength="" >
                                            </div>
                                        </div>
                                        <div class="row t1" id="Hi_Torque_tr">
                                            <div class="col-3 t1" for=""><?php echo $text['Hi_Torque_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="hi-torque" class="form-control input-ms" value="0.7" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1" id="Lo_Torque_tr">
                                            <div class="col-3 t1" for=""><?php echo $text['Lo_Torque_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input type="text" id="lo-torque" class="form-control input-ms" value="0.0" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1" id="Hi_Angle_tr">
                                            <div class="col-3 t1"><?php echo $text['Hi_Angle_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input id="hi-angle" type="text" value="30600" class="form-control input-ms" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1" id="Lo_Angle_tr">
                                            <div class="col-3 t1"><?php echo $text['Lo_Angle_text']; ?> :</div>
                                            <div class="col-4 t2">
                                                <input id="lo-angle" type="text" value="0" class="form-control input-ms" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-3 t1"><?php echo $text['Record_Angle_Val_text']; ?> :</div>
                                            <div class="col-1 t2">
                              					<select id="record-angle-val" style="width: 210px; height: 32px; border: 0">
                               					    <option value="0"><?php echo $text['skip_text']; ?></option>
                                                    <option value="1" selected>+</option>
                                                    <option value="2">-</option>
                                  				</select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="new_step_save()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('StepNew').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Step Copy -->
    <div id="Copystep" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 430px">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('Copystep').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3><?php echo $text['Copy_text'].' '.$text['Step_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="copy_step_form">
                        <div class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_from_text']; ?></b></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_step_id" class="col-5 t1"><?php echo $text['Step_ID_text']; ?> :</div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_step_id" disabled>
        				        </div>
        				    </div>
                            <div class="row">
                                <div for="from_step_name" class="col-5 t1"><?php echo $text['Step_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="from_step_name" disabled>
                                </div>
                            </div>
                        </div>

                        <div for="from_step_id" class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_to_text']; ?></b></div>
                        <div style="padding-left: 20px;">
                            <div class="row">
                                <div for="to_step_id" class="col-5 t1"><?php echo $text['Step_ID_text']; ?> :</div>
                				<div class="col-5 t2">
                				    <input type="text" class="form-control" id="to_step_id" disabled>
                				</div>
            				</div>
                            <div class="row">
                                <div for="to_step_name" class="col-5 t1"><?php echo $text['Step_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="to_step_name"> 
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="copy_step_save()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('Copystep').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>


    <!----Program sync Modal op ----->
    <div id="syncProgram" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 430px">
                <header class="w3-container modal-header">
                    <span onclick="cancel_action()"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3><?php echo $text['Sync_Program_text'];?></h3>
                </header>

                <div class="modal-body">
                    <form id="copy_Pro_form">
                        <div class="col" style="font-size: 20px; margin: 5px 0px 5px"><b>d</b></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_pro_id" class="col-5 t1">
                                
                                </div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_pro_id" disabled>
        				        </div>
        				    </div>
                        </div>
                    </form> w
                </div>
                <div class="modal-footer justify-content-center">
                    <input type="checkbox" id="confirmCheckbox"> 
                    <label for="confirmCheckbox" style="color: white;font-size: 18px;"><?php echo $text['iagree_text'];?></label>
                    <button id="button1" class="button button3" onclick="syncProgram_job()"><?php echo $text['SYNC_text'];?></button>
                    <button id="button2" class="button button3" onclick="cancel_action()" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>
    <!----Program sync Modal ed ----->

<script>

// Get the modal
var modal = document.getElementById('ProgramNew');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}

</script>

<script>
$(document).ready(function () {
        highlight_row();
    });

function highlight_row() {
    var table = document.getElementById('table');
    var cells = table.getElementsByTagName('td');

    for (var i = 0; i < cells.length; i++) {
        // Take each cell
        var cell = cells[i];
        // do something on onclick event for cell

        cell.onclick = function() {
            // Get the row id where the cell exists
            var rowId = this.parentNode.rowIndex;

            var rowsNotSelected = table.getElementsByTagName('tr');
            for (var row = 0; row < rowsNotSelected.length; row++) {
                rowsNotSelected[row].style.backgroundColor = "";
                rowsNotSelected[row].classList.remove('selected');
            }
            var rowSelected = table.getElementsByTagName('tr')[rowId];
            // rowSelected.style.backgroundColor = "red";
            rowSelected.style.backgroundColor = "#9AC0CD";
            rowSelected.className += " selected";

            //hide div
        }
    }

} //end of function
</script>

<script>
$(document).ready(function () {

});


//monitor radio button
$('input[type=radio][name="monitor-option"]').on('change', function() {
    option_list_update();
})

//Torque monitor angle mode
$('input[type=checkbox][name="MonitorAngle-ON-OFF"]').on('change', function() {
    option_list_update();
})

// 監聽target_type change事件
document.getElementById('target_type').addEventListener('change', function() {
    option_list_update();
});

document.getElementById('target-torque').addEventListener('change', function() {
    document.getElementById('torque-window').value = document.getElementById('target-torque').value;
});

document.getElementById('target-angle').addEventListener('change', function() {
    document.getElementById('angle-window').value = document.getElementById('target-angle').value;
});


function option_list_update(){
    let target_type = document.getElementById('target_type').value;
    let monitor_mode = $("input[name=monitor-option]:checked").val();
    let monitor_angle = $("input[name=MonitorAngle-ON-OFF]:checked").is(':checked');

    // console.log(target_type)
    // console.log(monitor_mode)
    // console.log(monitor_angle)
    
    if( target_type == 2){ //torque
        document.getElementById('target-torque').disabled = false;
        document.getElementById('target-angle').disabled = true;
        document.getElementById('torque-window').disabled = true;
        document.getElementById('angle-window').disabled = false;
        // document.getElementById('torque-window').value = document.getElementById('target-torque').value;

    }else{ //angle
        document.getElementById('target-torque').disabled = true;
        document.getElementById('target-angle').disabled = false;
        document.getElementById('torque-window').disabled = false;
        document.getElementById('angle-window').disabled = true;
        document.getElementById('angle-window').value = document.getElementById('target-angle').value;
    }

    if (monitor_mode == 1) { // Hi-Lo
        //disable name="Torque_Window_Subtraction"
        $("#Torque_Window_Subtraction").prop('disabled', true);
        $("#Torque_Window_tr").hide();
        //show Hi_Torque tr
        $("#Hi_Torque_tr").show();
        //show Lo_Torque tr
        $("#Lo_Torque_tr").show();

        $("#Angle_Window_tr").hide();

        if (monitor_angle == 'on') {
            //show Hi_Angle tr
            $("#Hi_Angle_tr").show();
            //show Lo_Angle tr
            $("#Lo_Angle_tr").show();
        }
    }else{ // Window
        //undisable name="Torque_Window_Subtraction"
        $("#Torque_Window_Subtraction").prop('disabled', false);
        $("#Torque_Window_tr").show();
        //hide Hi_Torque tr
        $("#Hi_Torque_tr").hide();
        //hide Lo_Torque tr
        $("#Lo_Torque_tr").hide();
        //hide Hi_Angle tr
        $("#Hi_Angle_tr").hide();
        //hide Lo_Angle tr
        $("#Lo_Angle_tr").hide();

        if (monitor_angle == 'on') {
            $("#Angle_Window_tr").show();
        }
    }

    if (monitor_angle == true) { // ON
        //show Over Angle Stop tr
        $("#Over_Ang_Stop_tr").show();
        if (monitor_mode == 1) { // Hi-Lo
            //show Over Angle Stop tr
            $("#Angle_Window_tr").hide();
            //show Hi_Angle tr
            $("#Hi_Angle_tr").show();
            //show Lo_Angle tr
            $("#Lo_Angle_tr").show();
        }
        if (monitor_mode == 0) { // Window
            //show Angle_Window_tr tr
            $("#Angle_Window_tr").show();
        }

    }else{ // OFF
        //hide Over Angle Stop tr
        $("#Angle_Window_tr").hide();
        //hide Hi_Angle tr
        $("#Hi_Angle_tr").hide();
        //hide Lo_Angle tr
        $("#Lo_Angle_tr").hide();

        $("#Over_Ang_Stop_tr").hide();

    }

    if(target_type == 1 && monitor_mode == 0){
        $("#Angle_Window_tr").show();
    }

    if(target_type == 1 && monitor_mode == 1){
        $("#Hi_Angle_tr").show();
        //show Lo_Angle tr
        $("#Lo_Angle_tr").show();
    }
}


//add step
//get job_id
function get_head_step_id() {
    let program_id = document.getElementById('porgram-id').value;
    $.ajax({
        type: "POST",
        url: "?url=Templates/get_head_advanced_step_id",
        data: {'program_id':program_id},
        dataType: "json",
        encode: true,
        async: false, //等待ajax完成
    }).done(function(data) { //成功且有回傳值才會執行
        program_id = data['missing_id'];
    });

    return program_id;
}

//new step 按下add step button
function new_step() {

    //get new step_id
    let step_id = get_head_step_id();
    console.log(step_id);
    if (step_id > 8) { //避免新增超過8個step
        return 0;
    }else{

        document.getElementById('modal_head').innerHTML = '<?php echo $text['New_Step_text']; ?>'; //'New Program'
        // // //帶入預設值
        document.getElementById("step-id").value = step_id;

        // //torque element
        document.getElementById("step-name").value = 'step-' + step_id;
        document.getElementById('target_type').value = 2; //預設用torque
        $('input[name=direction-option][value=0]').prop('checked', true) //預設用CW
        document.getElementById("run-down-speed").value = '100';
        document.getElementById("target-torque").value = '0.6';
        document.getElementById("target-angle").value = '1800';
        document.getElementById("delay-time").value = '0.0';
        document.getElementById('joint-offset').value = 0; //預設用torque
        document.getElementById("offset-value").value = '0.0';
        $('input[name=monitor-option][value=1]').prop('checked', true) //預設用Window
        document.getElementById("MonitorAngle-ON-OFF").checked = false;//預設關閉
        document.getElementById("AngleStop-ON-OFF").checked = false;//預設關閉
        document.getElementById("torque-window").value = '0.6';
        document.getElementById("torque-window-range").value = '0.1';
        document.getElementById("angle-window").value = '1800';
        document.getElementById("angle-window-range").value = '360';

        document.getElementById("hi-torque").value = '0.7';
        document.getElementById("lo-torque").value = '0';
        document.getElementById("hi-angle").value = '30600';
        document.getElementById("lo-angle").value = '0';
        document.getElementById('record-angle-val').value = 1; //預設用torque

        $('input[type=radio][name="monitor-option"]').change();
        $('input[type=checkbox][name="MonitorAngle-ON-OFF"]').change();
        //show modal
        document.getElementById('StepNew').style.display = 'block'
    }

}

//new program 按下save鍵
function new_step_save() {
    //get target type Target-Type
    let program_id = document.getElementById("program-id").value;
    let program_name = document.getElementById("program-name").value;
    let step_id = document.getElementById("step-id").value;
    let step_name = document.getElementById("step-name").value;
    let target_type = document.getElementById('target_type').value; //torque:2 angle:1
    let direction = document.querySelector('input[name="direction-option"]:checked').value;
    let run_down_speed = document.getElementById("run-down-speed").value;
    let target_torque = document.getElementById("target-torque").value;
    let target_angle = document.getElementById("target-angle").value;
    let delay_time = document.getElementById("delay-time").value;
    let joint_offset = document.getElementById("joint-offset").value;
    let offset_value = document.getElementById("offset-value").value;

    let monitor_mode = document.querySelector('input[name="monitor-option"]:checked').value;
    let monitor_angle = +document.querySelector('input[name="MonitorAngle-ON-OFF"]').checked;//true false轉int
    let over_angle_stop = +document.querySelector('input[name="AngleStop-ON-OFF"]').checked;//true false轉int

    let torque_window = document.getElementById("torque-window").value;
    let torque_window_range = document.getElementById("torque-window-range").value;
    let angle_window = document.getElementById("angle-window").value;
    let angle_window_range = document.getElementById("angle-window-range").value;
    
    let hi_torque = document.getElementById("hi-torque").value;
    let lo_torque = document.getElementById("lo-torque").value;
    let hi_angle = document.getElementById("hi-angle").value;
    let lo_angle = document.getElementById("lo-angle").value;

    let record_angle_val = document.getElementById("record-angle-val").value;

    if (monitor_angle == 1) {
        if (over_angle_stop == 1) {
            monitor_angle = 1;
        } else {
            monitor_angle = 2;
        }
    }

    let formData = new FormData();
    // 添加表单数据
    formData.append('program_id', program_id);
    formData.append('program_name', program_name);
    formData.append('step_id', step_id);
    formData.append('step_name', step_name);
    formData.append('target_type', target_type);
    formData.append('direction', direction);
    formData.append('run_down_speed', run_down_speed);
    formData.append('target_torque', target_torque);
    formData.append('target_angle', target_angle);
    formData.append('delay_time', delay_time);
    formData.append('joint_offset', joint_offset);
    formData.append('offset_value', offset_value);
    formData.append('monitor_mode', monitor_mode);
    formData.append('monitor_angle', monitor_angle);
    formData.append('over_angle_stop', over_angle_stop);
    formData.append('hi_torque', hi_torque);
    formData.append('lo_torque', lo_torque);
    formData.append('hi_angle', hi_angle);
    formData.append('lo_angle', lo_angle);
    formData.append('torque_window', torque_window);
    formData.append('torque_window_range', torque_window_range);
    formData.append('angle_window', angle_window);
    formData.append('angle_window_range', angle_window_range);

    formData.append('record_angle_val', record_angle_val);
    

    let url = '?url=Templates/edit_step';
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

function edit_adv_step(step_id) {
    let program_id = document.getElementById('porgram-id').value;
    let url = '?url=Templates/get_advanced_step';
    $.ajax({
        type: "POST",
        data: { 'program_id': program_id, 'step_id': step_id },
        dataType: "json",
        url: url,
        success: function(response) {
            // 成功回調函數，處理伺服器的回應
            console.log(response); // 在控制台輸出伺服器的回應
            console.log(response['template_program_id']); // 在控制台輸出伺服器的回應

            // //帶入預設值
            document.getElementById("step-id").value = step_id;
            document.getElementById("step-name").value = response['step_name'];
            document.getElementById("target_type").value = response['step_targettype'];
            $('input[name=direction-option][value='+ response['step_tooldirection'] +']').prop('checked', true) //預設用CW
            document.getElementById("run-down-speed").value = response['step_rpm'];
            document.getElementById("target-torque").value = response['step_targettorque'];
            document.getElementById("target-angle").value = response['step_targetangle'];
            document.getElementById("joint-offset").value = response['step_offsetdirection'];
            document.getElementById("offset-value").value = response['step_torque_jointoffset'];
            $('input[name=monitor-option][value='+ response['step_monitoringmode'] +']').prop('checked', true) //預設用CW
            // document.getElementById("MonitorAngle-ON-OFF").checked = response['step_monitoringangle'];//預設關閉
            // document.getElementById("AngleStop-ON-OFF").checked = response['step_angle_mode'];//預設關閉

            document.getElementById("torque-window").value = response['step_torwin_target'];
            document.getElementById("torque-window-range").value = response['step_torquewindow'];
            document.getElementById("angle-window").value = response['step_angwin_target'];
            document.getElementById("angle-window-range").value = response['step_anglewindow'];

            document.getElementById("hi-torque").value = response['step_hightorque'];
            document.getElementById("lo-torque").value = response['step_lowtorque'];
            document.getElementById("hi-angle").value = response['step_highangle'];
            document.getElementById("lo-angle").value = response['step_lowangle'];

            document.getElementById("record-angle-val").value = response['step_angle_mode'];

            if (response['step_monitoringangle'] == 0) {//close
                document.getElementById("MonitorAngle-ON-OFF").checked = false;//預設關閉
                document.getElementById("AngleStop-ON-OFF").checked = false;//預設關閉
            }else if(response['step_monitoringangle'] == 1){//both open
                document.getElementById("MonitorAngle-ON-OFF").checked = true;//預設關閉
                document.getElementById("AngleStop-ON-OFF").checked = true;//預設關閉
            }else if(response['step_monitoringangle'] == 2){//only monitor angle not stop
                document.getElementById("MonitorAngle-ON-OFF").checked = true;//預設關閉
                document.getElementById("AngleStop-ON-OFF").checked = false;//預設關閉
            }

            option_list_update();//更新顯示

            document.getElementById('modal_head').innerHTML = '<?php echo $text['Edit_text'].$text['Step_text']; ?>'; //'New Job'
            document.getElementById('StepNew').style.display = 'block'
        },
        error: function(error) {
            // 失敗回調函數，處理錯誤情況
            // console.error('Error:', error); // 在控制台輸出錯誤訊息
        }
    }).fail(function() {
        // history.go(0);//失敗就重新整理
    });

}

function copy_step_div() {
    let rowSelected = document.getElementsByClassName('selected');
    if (rowSelected.length != 0) {
        let step_id = rowSelected[0].childNodes[1].innerHTML;
        let step_name = rowSelected[0].childNodes[2].innerHTML;
        let to_step_id = get_head_step_id();
        if (to_step_id > 8) { to_step_id = 8; }

        document.getElementById('to_step_id').value = to_step_id;
        document.getElementById('from_step_id').value = step_id;
        document.getElementById('from_step_name').value = step_name;
        document.getElementById('Copystep').style.display = 'block'
    }
}

function copy_step_save() {
    let from_pro_id = document.getElementById('porgram-id').value;
    let from_step_id = document.getElementById('from_step_id').value;
    
    let to_step_id = document.getElementById('to_step_id').value;
    let to_step_name = document.getElementById('to_step_name').value;

    let url = '?url=Templates/copy_step';
    $.ajax({
        type: "POST",
        data: {
            'from_pro_id': from_pro_id,
            'from_step_id': from_step_id,
            'to_step_id': to_step_id,
            'to_step_name': to_step_name,
            'job_type': 'advanced'
        },
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
}

function delete_advanced_step() {
    let rowSelected = document.getElementsByClassName('selected');
    let step_id = rowSelected[0].childNodes[1].innerHTML;
    let program_id = document.getElementById('porgram-id').value;

    var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>' + '<?php echo $text['Step_ID_text']; ?> : ' + step_id);

    if (yes) {
        let url = '?url=Templates/delete_advanced_step_by_id';
        $.ajax({
            type: "POST",
            data: { 'program_id': program_id,'step_id': step_id },
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

</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>
<script>

function cancel_action(){
    document.getElementById('syncProgram').style.display='none';
    history.go(0); 
}

//sync-program  檢查 只做單選 
let global_job_id = null;
let global_program_id = null;

function sync_program() {
    let rowSelected = document.getElementsByClassName('selected');
    let url = '?url=Templates/check_task_by_pro_id';

    

    // 确保至少有一个选中的项
    if (rowSelected.length  === 0) {
        // 取第一个选中的行的 program_id
        let program_id = extractPartFromurl();
        global_program_id =  program_id;

        $.ajax({
            type: "POST",
            data: {
                'program_id': program_id
            },
            dataType: "json",
            url: url,
            success: function(response) {
                console.log(response); 
                
                
                let syncProgramElement = document.getElementById('syncProgram');
                let modalBody = syncProgramElement.querySelector('.modal-body');
                modalBody.innerHTML = '';

                let contentDiv = document.createElement('div');
                contentDiv.style.fontSize = '20px';
                contentDiv.style.margin = '5px 0px 5px';
                contentDiv.innerHTML = '<b>Job Details:</b>';

                modalBody.appendChild(contentDiv);

                if (Array.isArray(response) && response.length > 0) {

                    global_job_id = response[0].job_id;

                    let jobListDiv = document.createElement('div');
                    jobListDiv.style.paddingLeft = '20px';
                    
                    response.forEach(job => {
                        let jobDiv = document.createElement('div');

                        //Job ID 和 Job Name 的文字為紅色
                        jobDiv.innerHTML = `
                            <span style="color: red;font-size: 16px;">Job ID:</span> ${job.job_id}, 
                            <span style="color: red;font-size: 16px;">Job Name:</span> ${job.job_name}
                        `;
                        
                        jobListDiv.appendChild(jobDiv);
                    });

                    modalBody.appendChild(jobListDiv);
                } else {
                    let noJobsMessage = document.createElement('p');
                    noJobsMessage.textContent = '<?php echo $text['no_jobs_found'];?>';
                    noJobsMessage.style.textAlign = 'center'; // Center text horizontally
                    noJobsMessage.style.fontSize = '16px'; // Adjust font size if needed
                    noJobsMessage.style.color = 'gray'; // Optional: Change text color

                    modalBody.appendChild(noJobsMessage);
                }

                syncProgramElement.style.display = 'block';
            },
            error: function(error) {
                 alert('Please select a row');
                //history.go(0);
            }
        }).fail(function() {
            history.go(0); 
        });
    } else {

        //alert('Please select a row..');
    }
}

function syncProgram_job(){
    let checkbox = document.getElementById('confirmCheckbox');
    let table_url   = extractPartFromURL(); 
    if(checkbox.checked){
        if (global_job_id && global_program_id && table_url) {
           sync_product(global_job_id, global_program_id, table_url);
        }
    }else{
        //如果沒有選中，alert訊息
        alert('Please agree to the terms before proceeding.');
    }

}

function sync_product(jobId, programId, url) {
    //alert(url);
    if (url) { 
        $.ajax({
            type: "POST",
            data: {
                'jobid' :jobId,
                'program_id': programId,        
                'table_url': url                
            },
            url: '?url=Templates/sync_program_step',
            success: function(response) {
                //console.log(response);
                alert('Success');
                history.go(0); 
            },
            error: function(error) {
                console.error('Error:', error); 
            }
        }).fail(function() {
        });
    } else {
        console.warn('URL parameter is missing');
    }
}


function extractPartFromURL() {
    let queryString = window.location.search;
    let urlParams = new URLSearchParams(queryString);
    
    let urlValue = urlParams.get('url');
    
    if (urlValue) {
        let parts = urlValue.split('/'); 
        let partToExtract = parts[1]; 
        return partToExtract.split('_')[0]; 
    }
    
    return null; 
}

function extractPartFromurl() {
    let queryString = window.location.search; 
    let urlParams = new URLSearchParams(queryString); 

    let urlValue = urlParams.get('url');
    
    if (urlValue) {
        let parts = urlValue.split('/'); 
        return parts[parts.length - 1]; 
    }
    
    return null;
}


</script>