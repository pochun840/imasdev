<?php require APPROOT . 'views/inc/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/historical.css?v=202404111200" type="text/css">

<script src="<?php echo URLROOT; ?>js/flatpickr.js"></script>
<script src="<?php echo URLROOT; ?>js/historical.js?v=202408151600"></script>

<script src="<?php echo URLROOT; ?>js/echarts_min.js?v=202405080900"></script>
<script src="<?php echo URLROOT; ?>js/html2canvas_min.js?v=202405080900"></script>

<?php if(isset($data['nav'])){
    echo $data['nav'];
}



//
//取得URL 
$path  = $_SERVER['REQUEST_URI'];
$path  = str_replace('/public/index.php?url=Historicals/','',$path);
$path = $data['path'];
if ($path == "combinedata") {
    echo "
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var element = document.getElementById('CombineDataDisplay');
            if (element) {
                element.style.display = 'block';
            }
        
            var otherElement = document.getElementById('FasteningDisplay');
            if (otherElement) {
                otherElement.style.display = 'none';
            }
        });
    </script>
    ";
    echo "<script src='" . URLROOT . "js/chart_share.js?v=202405151200'></script>";

}

if($path == "nextinfo"){
      echo "
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var element = document.getElementById('DetailInfoDisplay');
            if (element) {
                element.style.display = 'block';
            }
        
            var otherElement = document.getElementById('FasteningDisplay');
            if (otherElement) {
                otherElement.style.display = 'none';
            }
        });
    </script>
    ";
    echo "<script src='" . URLROOT . "js/chart_share.js?v=202405151200'></script>";


}

#曲線圖 是否要顯示上下限
if(!empty($_COOKIE['limit_val'])){
    $limit_val = $_COOKIE['limit_val'];
}else{
    $limit_val = '';
}

if(!empty($_COOKIE['unit_mode'])){
    $unit_mode = $_COOKIE['unit_mode'];
}else{
    $unit_mode = '';
}

if(!empty($_COOKIE['chat_mode'])){
    $chat_mode = $_COOKIE['chat_mode'];
}else{
    $chat_mode = '';
}

if(!empty($_COOKIE['chat_mode_change'])){
    $chat_mode_change= $_COOKIE['chat_mode_change'];
}else{
    $chat_mode_change = '';
}

?>

<style>


.t1{font-size: 20px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 17px; margin: 3px 0px;}
.t3{font-size: 17px; margin: 3px 0px; height: 29px;border-radius: 5px;}
.t4{font-size: 17px; margin-right: 5px; border-radius: 5px}
.t5{margin-left: 10px; text-align: center;}
.t6{width: 116px;margin-right:10%}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    list-style: none;
    padding: 0;
}
.pagination li {
    margin-right: 5px;
}
.pagination li a,
.pagination li span {
    padding: 5px 10px;
    text-decoration: none;
    border: 1px solid #ccc;
    border-radius: 3px;
}
.current-page {
    font-weight: bold;
}
                                    
</style>


<script src="<?php echo URLROOT; ?>js/d31.min.js?v=202408141500"></script>
<script src="<?php echo URLROOT; ?>js/c3.min.js?v=202408141500"></script>
<script src="<?php echo URLROOT; ?>js/html2canvas.min.js?v=202408141500"></script>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/c3.min.css?v=202404251500" type="text/css">

<div class="container-ms">
    <header>
        <div class="historical">
            <img id="header-img " src="./img/historical-head.svg"> <?php echo $text['Historical_Record_text']; ?>
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

    <div class="main-content">
        <div class="center-content">
            <div class="wrapper">
                <div class="navbutton active" onclick="handleButtonClick(this, 'fastening')">
                    <span data-content="<?php echo $text['Fastening_Record_text']; ?>" onclick="showContent('fastening')"></span><?php echo $text['Fastening_Record_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'workflowlog')">
                    <span data-content="<?php echo $text['Work_Flow_Log_text']; ?>" onclick="showContent('workflowlog')"></span><?php echo $text['Work_Flow_Log_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'useraccess')">
                    <span data-content="<?php echo $text['User_Access_Logging_text']; ?>" onclick="showContent('useraccess')"></span><?php echo $text['User_Access_Logging_text']; ?>
                </div>
            </div>

            <!-- Fastening Setting -->
            <div id="fasteningContent" class="content">
                <div id="FasteningDisplay" style="margin-top: 40px">
                    <!-- Lana Edit input-group date 2024/10/15 -->
                    <div class="mt-2" style="margin-right: 20%; margin-left: 3%">
                        <div class="input-group mb-2">
                            <span class="input-group-text"><?php echo $text['BarcodeSN_text']; ?>:</span>
                            <input type="text" id="barcodesn" name="barcodesn" class="form-control input-ms" style="margin-right: 7px">

                            <span class="input-group-text"><?php echo $text['Operator_text']; ?>:</span>
                            <input type="text" id="Operator" class="form-control input-ms" style="margin-right: 7px">

                            <span class="input-group-text"><?php echo $text['Select_Job_text']; ?>:</span>
                            <input type="text" class="form-control input-ms" id="JobSelect" placeholder="<?php echo $text['Click_here_text']; ?>.." onfocus="openModal('JobSelect')" onclick="this.blur()">    
                        </div>

                        <div class="input-group mb-2">
                            <span class="input-group-text"><?php echo $text['From_text']; ?>:</span>
                            <input type="datetime-local" id="FromDate" name="FromDate" class="form-control input-ms" style="margin-right: 7px">

                            <span class="input-group-text"><?php echo $text['To_text']; ?>:</span>
                            <input type="datetime-local" id="ToDate" name="ToDate" class="form-control input-ms" style="margin-right: 7px">
                        </div>

                        <div class="input-group mb-2">
                            <span class="input-group-text"><?php echo $text['Result_Status_text']; ?>:</span>
                            <select id="status" class="form-select" name="" style="margin-right: 7px">
                                <?php foreach($data['res_status_arr'] as $key_res =>$val_res){?>
                                    <option value="<?php echo $key_res;?>"><?php echo $val_res;?></option>
                                <?php }?>
                            </select>

                            <span class="input-group-text"><?php echo $text['Controller_text']; ?>:</span>
                            <select id="Controller" class="form-select" name="" style="margin-right: 7px">
                                <?php foreach($data['res_controller_arr'] as $key_res_1 =>$val_res_1){?>
                                    <option value="<?php echo $key_res_1;?>"><?php echo $val_res_1;?></option>
                                <?php }?>
                            </select>

                            <span class="input-group-text"><?php echo $text['Program_text']; ?>:</span>
                            <select id="Program" class="form-select" name="">
                                <option value="-1"><?php echo "select";?></option>
                                <?php foreach($data['res_program'] as $key_res_2 => $val_res_2){?>
                                    <option value="<?php echo $val_res_2['template_program_id'];?>"><?php echo $val_res_2['template_program_id'];?></option>
                                <?php }?>
                            </select>
                        </div>
                        
                    </div>                

<!--                
                    <div style="padding-left: 2%">
                        <div class="row">
                            <div for="BarcodeSN" class="col-2 t1"><?php echo $text['BarcodeSN_text']; ?>:</div>
                            <div class="col-2 t2" style="margin-left: -100px">
                                <input type="text" class="t3 form-control input-ms" id="barcodesn" name="barcodesn" maxlength="" style="width: 190px;">
                            </div>

                            <div for="Operator" class="col-2 t1"><?php echo $text['Operator_text']; ?>:</div>
                            <div class="col-2 t2" style="margin-left: -100px">
                               <!--<input type="text" class="t3 form-control input-ms" id="Operator" maxlength="" value="" style="width: 190px;">-->
                               <!--<select>
                                    <?//php foreach($data['all_roles'] as $key =>$val){ ?>
                                            <!--<option value='<?//php echo $val['ID'];?>'> <?//php echo $val['Title'];?> </option>
                                    <?//php } ?>
                               </select>
                            </div>

                            <div for="SelectJob" class="col-2 t1"><?php echo $text['Select_Job_text']; ?>:</div>
                            <div class="col-2 t3" style="margin-left: -100px">
                                <input type="text" class="t3 form-control input-ms" id="JobSelect" placeholder="<?php echo $text['Click_here_text']; ?>.." onfocus="openModal('JobSelect')" onclick="this.blur()">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-2 t1" for="FromDate"><?php echo $text['From_text']; ?>:</div>
                            <div class="col-2 t1" style="margin-left: -100px">
                                <input type="datetime-local" class="t3" id="FromDate" name="FromDate" style="width: 190px;border-radius: 5px;border: 1px solid #CCCCCC; ">
                            </div>

                            <div class="col-2 t1" for="ToDate"><?php echo $text['To_text']; ?>:</div>
                            <div class="col-2 t1" style="margin-left: -100px">
                                <input type="datetime-local" class="t3" id="ToDate" name="ToDate" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;">
                            </div>
                        </div>

                        <div class="row">
                            <div for="result-status" class="col-2 t1"><?php echo $text['Result_Status_text']; ?>:</div>
                            <div class="col-2 t2" style="margin-left: -100px">
                                <select id="status" style="width: 190px">
                                    <?php foreach($data['res_status_arr'] as $key_res =>$val_res){?>
                                            <option value="<?php echo $key_res;?>"><?php echo $val_res;?></option>
                                    <?php }?>

                                </select>
                            </div>

                            <div for="Controller" class="col-2 t1"><?php echo $text['Controller_text']; ?>:</div>
                            <div class="col-2 t3" style="margin-left: -100px">
                                <select id="Controller" style="width: 190px;">
                                    <?php foreach($data['res_controller_arr'] as $key_res_1 =>$val_res_1){?>
                                            <option value="<?php echo $key_res_1;?>"><?php echo $val_res_1;?></option>
                                    <?php }?>
                                </select>
                            </div>

                            <div for="Program" class="col-2 t1"><?php echo $text['Program_text']; ?>:</div>
                            <div class="col-2 t3"  style="margin-left: -100px">
                                <select id="Program" style="width: 190px;">
                                    <option value="-1"><?php echo "select";?></option>
                                     <?php foreach($data['res_program'] as $key_res_2 => $val_res_2){?>
                                            <option value="<?php echo $val_res_2['template_program_id'];?>"><?php echo $val_res_2['template_program_id'];?></option>
                                    <?php }?>
                                </select>
                            </div>
                        </div>
                    </div>
-->
                    <div class="topnav-menu">
                        <div class="search-container">
                            <input type="text" placeholder="<?php echo $text['Search_text']; ?>.." name="sname" id="search_name" size="40" style="height: 35px">&nbsp;
                            <button id="Search" type="button" class="Search-button" onclick="search_info()"><?php echo $text['Search_text']; ?></button>
                        </div>


                        <div class="topnav-right">
                            <button id="Export-CSV" type="button" class="ExportButton" onclick="csv_download()"><?php echo $text['Export_text']; ?> CSV</button>
                            <button id="Export-Report" type="button" class="ExportButton" onclick="window.open('?url=Historicals/history_result', '_blank');" ><?php echo $text['Export_Report_text']; ?></button>
                            <button id="Combine-btn" type="button" onclick="NextToCombineData()"><?php echo $text['Combine_Data_text']; ?></button>
                            <button id="Clear" type="button" onclick="clear_button() "><?php echo $text['Clear_text']; ?></button>
                            <button id="nopage" type="button" onclick="nopage('nopage')"><?php echo $text['Nopage_text']; ?></button>
                        </div>

                    </div>

                    <div class="scrollbar-fastening" id="style-fastening">
                        <div class="force-overflow-fastening">
                            <table class="table table-bordered table-hover" id="fastening-table">
                                <thead id="header-table" style="text-align: center; vertical-align: middle">
                                    <tr>
                                        <?php 
                                            if(!empty($data['user_role_title'])){
                                                if($data['user_role_title'] =="Super admin"){?>
                                                     <th><i class="fa fa-trash-o" style="font-size:26px;color:black" onclick="deleteinfo()"></i></th>
                                                <?php }else{ ?>
                                                    <th><i></i></th>
                                                <?php }
                                            }
                                        
                                        ?>
                                        <th><?php echo $text['Index_text']; ?></th>
                                        <th><?php echo $text['Time_text']; ?></th>
                                        <th><?php echo $text['Station_text']; ?></th>
                                        <th><?php echo $text['BarcodeSN_text']; ?></th>
                                        <th><?php echo $text['Job_Name_text']; ?></th>
                                        <th><?php echo $text['Seq_Name_text']; ?></th>
                                        <th><?php echo $text['Task_text']; ?></th>
                                        <th><?php echo $text['Equipment_text']; ?></th>
                                        <th><?php echo $text['Torque_range_text']; ?></th>
                                        <th><?php echo $text['Angle_range_text']; ?></th>
                                        <th><?php echo $text['Final_Torque_text']; ?></th>
                                        <th><?php echo $text['Final_Angle_text']; ?></th>
                                        <th><?php echo $text['Status_text']; ?></th>
                                        <th><?php echo $text['Error_text']; ?></th>
                                        <th><?php echo $text['Program_text']; ?></th>
                                        <th><?php echo $text['Action_text']; ?></th>
                                    </tr>
                                </thead>
                                 <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.8vmin;text-align: center; vertical-align: middle;">
                                    
                                    <?php 
                                    if(isset($data['info'])){
                                    foreach($data['info'] as $k_info =>$v_info){
                                    
                                        $link ='?url=Historicals/nextinfo/'.$v_info['system_sn'];
                                        ?>
                                        <tr>
                                            <td style="text-align: center;">
                                                <input class="form-check-input" type="checkbox" name="test1" id="test1"  value="<?php echo $v_info['system_sn'];?>" style="zoom:1.2;vertical-align: middle;">
                                            </td>
                                            <td><?php echo $v_info['system_sn'];?></td>
                                            <td><?php echo $v_info['data_time'];?></td>
                                            <td></td>
                                            <td><?php echo $v_info['cc_barcodesn'];?></td>
                                            <td><?php echo $v_info['job_name'];?></td>
                                            <td><?php echo $v_info['sequence_name'];?></td>
                                            <td><?php echo $v_info['cc_task_id'];?></td>
                                            <td><?php echo "GTCS";?></td>
                                            <td><?php echo $v_info['step_lowtorque']." ~ ".$v_info['step_hightorque'];?></td>
                                            <td><?php echo $v_info['step_lowangle']." ~ ".$v_info['step_highangle'];?></td>
                                            <td><?php echo $v_info['fasten_torque'].$data['torque_arr'][$v_info['torque_unit']] ;?></td>
                                            <td><?php echo $v_info['fasten_angle'] . " deg";?></td>
                                            <td style="background-color:<?php echo $data['status_arr']['status_color'][$v_info['fasten_status']];?> font-size: 20px"><?php echo $data['status_arr']['status_type'][$v_info['fasten_status']];?></td>
                                            <td><?php echo $data['status_arr']['error_msg'][$v_info['error_message']];?></td>
                                            <td><?php echo $v_info['cc_program_id'];?></td>
                                            <td>
                                                <a href=" <?php echo $link;?> " >
                                                    <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" >
                                                </a>
                                            </td>
                                        </tr>
                                    <?php }?>
                                    <?php }?>
                                </tbody>
                               
                            </table>


                            <?php if( $data['nopage'] ==  "1"){ ?>
                            <div class="pagination" align="center">
                                <?php if ($data['page'] > 1): ?>
                                    <a href="?url=Historicals&p=<?php echo ($data['page'] - 1); ?>"> Pre  &nbsp;&nbsp;</a>
                                <?php endif; ?>
                                
                                <?php for ($i = 1; $i <= $data['totalPages']; $i++): ?>
                                    <?php if ($i == $data['page']): ?>
                                        <span class="current-page"><?php echo $i; ?></span>
                                    <?php else: ?>
                                        <a href="?url=Historicals&p=<?php echo $i; ?>"><?php echo "&nbsp;&nbsp$i&nbsp;&nbsp"; ?>&nbsp;&nbsp;</a>
                                    <?php endif; ?>
                                <?php endfor; ?>
                                
                                <?php if ($data['page'] < $data['totalPages']): ?>
                                    <a href="?url=Historicals&p=<?php echo ($data['page'] + 1); ?>"> Next  &nbsp;&nbsp;</a>
                                <?php endif; ?>

                            </div>
                            <?php } ?>
                        </div>
                    </div>
                </div>

                <!-- Click Detail Fastening Record Info -->
                <div id="DetailInfoDisplay" style="display: none">
                    <div class="topnav">
                        <label type="text" style="font-size: 18px; padding-left: 1%; margin: 4px"><?php echo $text['Fastening_Record_text']; ?> &#62; <?php echo $text['Info_text']; ?></label>
                        <button id="back-setting" type="button" onclick="goBack()">
                            <img id="img-back" src="./img/back.svg" alt=" onclick='goBack()'"><?php echo $text['Back_text']; ?>
                        </button>
                    </div>
                    <div id ="jobinfo">
                        <table class="table" style="font-size: 15px;">
                            <tr style="padding: 0 10px">
                                <td><?php echo $text['Index_text']; ?>: <?php echo $data['job_info'][0]['system_sn'];?></td>
                                <td><?php echo $text['Job_info_text']; ?>: <?php echo $data['job_info'][0]['job_name'];?> / <?php echo $data['job_info'][0]['sequence_name']. "/". $data['job_info'][0]['cc_task_name'];?></td>
                                <td><?php echo $text['Controller_text']; ?>: </td>
                                <td><?php echo $text['Error_code_text']; ?>: <?php echo  $data['status_arr']['error_msg'][$data['job_info'][0]['error_message']];?></td>
                                <td><?php echo $text['Status_text']; ?> : <a style="background-color: <?php echo $data['status_arr']['status_color'][$data['job_info'][0]['fasten_status']];?>; padding: 0 10px"><?php echo $data['status_arr']['status_type'][$data['job_info'][0]['fasten_status']];?></a></td>
                            </tr>
                            <tr>
                                <td><?php echo $text['Actual_Torque_text']; ?>: <?php echo $data['job_info'][0]['fasten_torque'];?> N.m</td>
                                <td><?php echo $text['BarcodeSN_text']; ?>: <?php echo $data['job_info'][0]['cc_barcodesn'];?></td>
                                <td><?php echo $text['Direction_text']; ?>: <?php echo  $data['status_arr']['direction'][$data['job_info'][0]['count_direction']];?></td>
                                <td><?php echo $text['Program_text']; ?>: <?php echo $data['job_info'][0]['cc_program_id'];?></td>
                                <td><?php echo $text['Time_text']; ?>: <?php echo $data['job_info'][0]['data_time'];?></td>
                            </tr>
                            <tr  style="vertical-align: middle;">
                                <td><?php echo $text['Member_text']; ?>: <!--<input class="t6" type="text" size="10" value="Esther" disabled="disabled" style="background-color: #F5F5F5">--></td>
                                <td><?php echo $text['Note_text']; ?>: <!--<input class="t6" type="text" value="arm (444,215)[200]" disabled="disabled" style="background-color: #F5F5F5; width: 15vw"></td>-->
                                <td>
                                    <input class="form-check-input" type="checkbox" id="myCheckbox" onchange="check_limit(this)"  <?php if($limit_val=="1"){ echo "checked"; }else{}?>  style="zoom:1.2; float: left">&nbsp; <?php echo $text['Display_lilo_text']; ?>
                                </td>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr style="vertical-align: middle">
                                <td>
                                    <?php echo $text['Chart_Setting_text']; ?>:  
                                    <select id="chartseting" class="t6 Select-All" style="float: none"  onchange="chat_mode_change(this)">
                                        <?php foreach($data['chat_mode_arr'] as $k_chat => $v_chat){?>
                                            <option  value="<?php echo $k_chat;?>"  <?php if($chat_mode_change == $k_chat){echo "selected";}else{echo "";}?>  > <?php echo $text[$v_chat];?> </option>
                                        <?php } ?>                             
                                    </select>
                                </td>
                                <td>
                                    <?php echo $text['Torque_Unit_text']; ?>:  
                                    <select id="Torque-Unit" class="Select-All" style="float: none; width: 100px" onchange="unit_change(this)">
                                        <?php foreach($data['torque_mode_arr'] as $k_torque =>$v_torque){?>
                                                <option  value="<?php echo $k_torque;?>" <?php if($data['unitvalue'] == $k_torque){echo "selected";}else{echo "";}?> > <?php echo $text[$v_torque]; ?> </option>
                                        <?php } ?>
                                    </select>
                                </td>
                                <!--<td>
                                    Angle:  <select id="Angle" class="t6 Select-All" id='angle_type' style="float: none; width: 100px" onchange="angle_select(this)">
                                                <?php foreach($data['angle_mode_arr'] as $ke =>$ve){?>
                                                    <option value="<?php echo $ke;?>" <?php if($data['anglevalue'] == $ke){ echo "selected";}?>><?php echo $ve;?></option>
                                                <?php } ?>
                                            </select>
                                </td>-->
                               <!--<td>
                                    Sampling:  
                                    <select id="SelectOutputSampling" class="t6 Select-All" id='file_type'>
                                                <option value="1">1(ms)</option>
                                                <option value="2">0.5(ms)</option>
                                                <option value="3">2(ms)</option>
                                    </select>
                                </td>-->
                                <td>
                                    <!--<button id="Export-Excel" type="button" class="ExportButton" style="margin-top: 0">Export Excel</button>-->
                                    <!--<button id="Save-info" type="button" style="margin-top: 0">Save</button>-->
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>

                        <?php if(!empty($data['chart_info'])){?>
                            <div>
                                <div style="text-align: center">
                                    <label style="float: left" id='DiagramDisplay'><b><?php echo $text['Diagram_Display_text']; ?></b></label>
                                    <label><?php echo $text[$data['chat']['chat_name']];?></label>
                                </div>

                                <div id="chart-setting">
                                    <div class="chart-container">
                                        <div class="menu-chart"  id="menu-chart" onclick="toggleMenu()">
                                            <i class="fa fa-bars" style="font-size: 26px"></i>
                                            <div class="menu-content" id="myMenu">
                                                <a id="downloadchartbtn"><?php echo $text['Download_text']; ?> HTML</a>
                                            </div> 
                                        </div>
                                        <div id="chartinfo" style="width: 1500px; height: 400px; z-index: 1;"></div>
                                    </div>
                                </div>
                            </div>
                        <?php } ?>
                    </div>
                </div>

                <!-- Click Combine Data -->
                <div id="CombineDataDisplay" style="display: none">
                    <div class="topnav">
                        <label type="text" style="font-size: 20px; padding-left: 1%; margin: 6px"><?php echo $text['Historical_Record_text']; ?> &#62; <?php echo $text['Combine_data_text']; ?></label>
                        <button id="back-setting" type="button"  onclick="goBack()" >
                            <img id="img-back" src="./img/back.svg" alt=""  onclick="goBack()" ><?php echo $text['Back_text']; ?>
                        </button>
                    </div>
                    <div class="topnav-menu" style="background-color: #FFF; margin-top: 3px">
                        <div class="row t1">
                            <div class="col-9 t2 form-check form-check-inline" style="margin-left: 15px">
                                <input class="form-check-input" type="checkbox" id="myCheckbox" onchange="check_limit(this)";  <?php if($limit_val=="1"){ echo "checked"; }else{}?> style="zoom:1.3;vertical-align: middle; margin-top:7px">
                                <label class="form-check-label" for="optioncheck"><?php echo $text['Display_lilo_text']; ?></label>

                                <label style="padding-left: 5%">
                                    <?php echo $text['Chart_Setting_text']; ?> : &nbsp;
                                    <select id="chart" style="width: 220px" onchange="chart_change(this)" >
                                        <?php foreach($data['chat_mode_arr_combine'] as $k_mode => $v_mode){ ?>
                                            <option value="<?php echo $k_mode; ?>" <?php if($data['chat_mode'] == $k_mode){ echo "selected";}?>><?php echo $text[$v_mode]; ?></option>
                                        <?php } ?>
                                    </select>
                                </label>
                                <label style="padding-left: 5%">
                                    <?php echo $text['Torque_Unit_text']; ?> :
                                        <select id="unit" style="width: 100px" onchange="unit_change_combine(this)" >
                                          <?php foreach($data['torque_mode_arr'] as $k_torque => $v_torque){?>
                                                <option  value="<?php echo $k_torque;?>"  <?php if( $data['unit'] == $k_torque){echo "selected";}else{echo "";}?>  > <?php echo $text[$v_torque];?> </option>
                                          <?php } ?>        
                                        </select>
                                </label>&nbsp;
                                <button id="downland_combine" type="button" class="t2 ExportButton"><?php echo $text['Export_text']; ?> HTML</button>
                            </div>
                        </div>
                    </div>

                    <div class="w3-col">
                        <div class="w3-round" style="margin: 5px 0;">
                            <div class="w3-row-padding">
                                <div class="scrollbar-Combine" id="style-Combine">
                                    <div class="force-overflow-Combine" id="combinedata">
                           
                                         <table class="table table-bordered table-hover" id="fastening-table">
                                <thead id="header-table" style="text-align: center; vertical-align: middle">
                                    <tr>
                                        <th><?php echo $text['Index_text']; ?></th>
                                        <th><?php echo $text['Time_text']; ?></th>
                                        <th><?php echo $text['Station_text']; ?></th>
                                        <th><?php echo $text['BarcodeSN_text']; ?></th>
                                        <th><?php echo $text['Job_Name_text']; ?></th>
                                        <th><?php echo $text['Seq_Name_text']; ?></th>
                                        <th><?php echo $text['Task_text']; ?></th>
                                        <th><?php echo $text['Equipment_text']; ?></th>
                                        <th><?php echo $text['Torque_range_text']; ?></th>
                                        <th><?php echo $text['Angle_range_text']; ?></th>
                                        <th><?php echo $text['Final_Torque_text']; ?></th>
                                        <th><?php echo $text['Final_Angle_text']; ?></th>
                                        <th><?php echo $text['Status_text']; ?></th>
                                        <th><?php echo $text['Error_text']; ?></th>
                                        <th><?php echo $text['Program_text']; ?></th>
                                    </tr>
                                </thead>

                                <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.8vmin;text-align: center; vertical-align: middle;">
                                    
                                    <?php 
                                    if(isset($data['info_final'])){
                                    foreach($data['info_final'] as $k_info =>$v_info){
                                        ?>
                                        <tr>
                    
                                            <td><?php echo $v_info['system_sn'];?></td>
                                            <td><?php echo $v_info['data_time'];?></td>
                                            <td></td>
                                            <td><?php echo $v_info['cc_barcodesn'];?></td>
                                            <td><?php echo $v_info['job_name'];?></td>
                                            <td><?php echo $v_info['sequence_name'];?></td>
                                            <td><?php echo $v_info['cc_task_id'];?></td>
                                            <td><?php echo "GTCS";?></td>
                                            <td><?php echo $v_info['step_lowtorque']." ~ ".$v_info['step_hightorque'];?></td>
                                            <td><?php echo $v_info['step_lowangle']." ~ ".$v_info['step_highangle'];?></td>
                                            <td><?php echo $v_info['fasten_torque'].$data['torque_arr'][$v_info['torque_unit']] ;?></td>
                                            <td><?php echo $v_info['fasten_angle'] . " deg";?></td>
                                            <td style="background-color:<?php echo $data['status_arr']['status_color'][$v_info['fasten_status']];?> font-size: 20px"><?php echo $data['status_arr']['status_type'][$v_info['fasten_status']];?></td>
                                            <td><?php echo $data['status_arr']['error_msg'][$v_info['error_message']];?></td>
                                            <td><?php echo $v_info['cc_program_id'];?></td>
                                           
                                        </tr>
                                    <?php }?>
                                    <?php }?>
                                </tbody>
                            </table>

                                        <!---圖表1--->
                                        <div id="empty1" style="width: 800px; height:150px;">
                                        <div id="chart-title" style="visibility: hidden;" >曲線圖資料</div>
                                        <div id="chart_combine" style="width: 1600px; height: 400px;"></div>

                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Work Flow Log Setting -->
            <div id="workflowlogContent" class="content" style="display: none">
                <div id="WorkFlowLogDisplay" style="margin-top: 40px">
                    <div style="padding-left: 2%; width: 70%">
                        <table class="table" style="font-size: 15px; margin-bottom: 0px; border-bottom: hidden;">
                            <tr>
                                <td>Job : <input type="text" class="t3" id="Member-Name" maxlength="" value="Esther" style="float: none;width: 130px"></td>
                                <td>Super Admin : <input type="text" class="t3" id="superAdmin" maxlength="" style="float: none;width: 130px;"></td>
                                <td>From : <input type="datetime-local" class="t3" id="FromDate" name="FromDate" style="width: 190px;border-radius: 5px;border: 1px solid #CCCCCC;float: none"> </td>
                                <td>To : <input type="datetime-local" class="t3" id="ToDate" name="ToDate" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;float: none"></td>
                            </tr>
                        </table>
                    </div>

                    <div class="topnav-menu">
                        <div class="search-container">
                            <form>
                                <input type="text" placeholder="Search.." name="search" size="40" style="height: 35px">&nbsp;
                                <button id="Search" type="submit" class="Search-button">Search</button>
                            </form>
                        </div>
                        <div class="topnav-right">
                            <button id="ExportExcel" type="button" class="ExportButton">Export Excel</button>
                            <button id="ExportReport" type="button" class="ExportButton">Export Report</button>
                            <button id="Reset" type="button">Reset</button>
                        </div>
                    </div>

                    <div class="scrollbar-WorkFlowLog" id="style-WorkFlowLog">
                        <div class="force-overflow-WorkFlowLog">
                            <table class="table table-bordered table-hover" id="WorkFlowLog-table">
                                <thead id="header-table" style="text-align: center; vertical-align: middle">
                                    <tr>
                                        <th>Index</th>
                                        <th>Time</th>
                                        <th>BarcodeSN</th>
                                        <th>Type</th>
                                        <th>Event</th>
                                        <th>Job Name</th>
                                        <th>Seq Name</th>
                                        <th>task</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody1" style="background-color: #F2F1F1;text-align: center; font-size: 1.8vmin; vertical-align: middle;">
                                    <tr>
                                        <td>1</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>567678</td>
                                        <td>job-1</td>
                                        <td>seq-1</td>
                                        <td>task-1</td>
                                        <td>tightening</td>
                                        <td style="text-align: left">0.6 N.m\223 Deg\P1\OK</td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>123456</td>
                                        <td>job-1</td>
                                        <td>seq-2</td>
                                        <td>task-2</td>
                                        <td>Select point</td>
                                        <td style="text-align: left">task1[2]>task2[1]\(111,120)[200]>(222,120)[200]</td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="WorkFlowLogInfo()">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Work Flow Log Info -->
                <div id="WorkFlowLogInfoDisplay" style="display: none">
                    <div class="topnav">
                        <label type="text" style="font-size: 20px; padding-left: 1%; margin: 6px">Work Flow Log &#62; Info</label>
                        <button id="back-setting" type="button" onclick="cancelSetting()">
                            <img id="img-back" src="./img/back.svg" alt="">Back
                        </button>
                    </div>
                    <table class="table table-borderless" style="font-size: 15px; width: 80%">
                        <tr>
                            <td>Index: <input class="t6 input-ms" type="text" size="10" value="2"></td>
                            <td>Barcode: <input class="t6 input-ms" type="text" size="20" value="123456"></td>
                            <td>job Info: <input class="t6 input-ms" type="text" size="25" value="job-1 > seq-2 > task-2" style="width: 190px"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>Member: <input class="t6 input-ms" type="text" size="10" value="Esther" disabled="disabled"></td>
                            <td>Type: <input class="t6 input-ms" type="text" size="20" value="Select point"></td>
                            <td>Event: <input class="t6 input-ms" type="text" size="25" value="task1[2]>task2[1]" style="width: 190px"></td>
                            <td>Arm position: <input class="t6 input-ms" type="text" size="25" value="(111,120)[200]>(222,120)[200]" disabled="disabled" style="width: auto"></td>
                        </tr>
                    </table>
                    <hr style="width: 100%; height: 4px;">
                    <b style="font-size: 20px">Diagram Display</b>
                    <div class="w3-center">
                        <img src="./img/pick-A-screw.svg" style=" height: 40vh; width: 70vw" alt="Nature" class="w3-margin-bottom">--<
                    </div>

                    <button class="Save-button" id="saveButton" onclick="Save_job()">Save</button>
                </div>
            </div>

            <!-- User Access Setting -->
            <div id="useraccessContent" class="content" style="display: none">
                <div style="padding-left: 2%; margin-top: 40px">
                    <table class="table" style="font-size: 15px; margin-bottom: 0px; border-bottom: hidden; width: 70%">
                        <tr>
                            <td>Member Name : <input type="text" class="t3" id="Member-Name" maxlength="" value="Esther" style="float: none;width: 130px"></td>
                            <td>Role Name : <select id="unit" class="t3" style="width: 130px;float: none">
                                                <option value="1">Super Admin</option>
                                                <option value="2">Admin</option>
                                                <option value="2">Operator</option>
                                                <option value="2">Leader</option>
                                            </select>
                            </td>
                            <td>From : <input type="datetime-local" class="t3" id="FromDate" name="FromDate" style="width: 190px;border-radius: 5px;border: 1px solid #CCCCCC;float: none"> </td>
                            <td>To : <input type="datetime-local" class="t3" id="ToDate" name="ToDate" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;float: none"></td>
                        </tr>
                    </table>
                </div>

                <div class="topnav-menu">
                    <div class="search-container">
                        <form>
                            <input type="text" placeholder="Search.." name="search" size="40" style="height: 35px">&nbsp;
                            <button id="Search" type="submit" class="Search-button">Search</button>
                        </form>
                    </div>
                    <div class="topnav-right">
                        <button id="Export_Excel" type="button" class="ExportButton">Export Excel</button>
                        <button id="Export_Report" type="button" class="ExportButton">Export Report</button>
                        <button id="Reset_btn" type="button">Reset</button>
                    </div>
                </div>

                <div class="scrollbar-UserAccess" id="style-UserAccess">
                    <div class="force-overflow-UserAccess">
                        <table class="table table-bordered table-hover" id="UserAccess-table">
                            <thead id="header-table" style="text-align: center; vertical-align: middle">
                                <tr>
                                    <th>Index</th>
                                    <th>Time</th>
                                    <th>Member Namne</th>
                                    <th>Type</th>
                                    <th>Page</th>
                                    <th>Event</th>
                                </tr>
                            </thead>
                            <tbody id="tbody1" style="background-color: #F2F1F1;text-align: center; font-size: 1.8vmin; vertical-align: middle;">
                                <tr>
                                    <td>1</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Esther</td>
                                    <td>Tightening</td>
                                    <td>Job</td>
                                    <td style="text-align: left">0.6 N.m\223 Deg\P1\OK</td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Peter</td>
                                    <td>Select point</td>
                                    <td>Operation</td>
                                    <td style="text-align: left">task1[2]>task2[1]\(111,120)[200]>(222,120)[200]</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals Job Select -->
    <!-- Modals Job Select -->
    <div id="modalJobSelect" class="modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="top: 150px; width: 710px">
                <span class="close-btn" onclick="document.getElementById('modalJobSelect').style.display = 'none';">&times;</span>
                <div class="modal-column modalselect">
                    <h4>Job</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <?php foreach ($data['job_arr'] as $k_job => $v_job) { ?>
                                <div class="row t1">
                                    <div class="col t5 form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="jobid" id="jobid-<?php echo $v_job['job_id']; ?>" value="<?php echo $v_job['job_id']; ?>" onclick="JobCheckbox(this)" style="zoom:1.0; vertical-align: middle;">&nbsp;
                                        <label 
                                            class="form-check-label" 
                                            id="job_name-<?php echo $v_job['job_name']; ?>" 
                                            for="jobid-<?php echo $v_job['job_id']; ?>">
                                            <?php echo htmlspecialchars($v_job['job_name']); ?>
                                        </label>
                                    </div>
                                </div>
                            <?php } ?>
                        </div>
                    </div>
                </div>
                <div class="modal-column modalselect">
                    <h4>Sequence</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <div id="Seq-list" style="display: none"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-column modalselect">
                    <h4>Task</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <div id="Task-list" style="display: none"></div>
                        </div>
                    </div>
                </div>
                <!--<span class="Save-button" onclick='Save_job()'>Save</span>-->
            </div>
        </div>
    </div>
</div>

<script>

// menu nav button
function showContent(contentType)
{
    var contents = document.getElementsByClassName("content");
    for (var i = 0; i < contents.length; i++) {
        contents[i].style.display = "none";
    }

    var contentId = contentType + "Content";
    document.getElementById(contentId).style.display = "block";
}

function handleButtonClick(button, content)
{
    // Remove the active class from all navbuttons
    var buttons = document.querySelectorAll('.navbutton');
    buttons.forEach(function(btn) {
        btn.classList.remove('active');
    });

    // Add the active class to the clicked navbutton
    button.classList.add('active');

    // Call the function to display the content corresponding to the clicked navbutton
    showContent(content);
}


// JavaScript open modal
    function openModal(inputId)
    {
        document.getElementById('modal' + inputId).style.display = 'flex';
        document.getElementById(inputId).focus();
    }

    // JavaScript close modal
    function closeModal(inputId)
    {
        document.getElementById('modal' + inputId).style.display = 'none';
    }

    // press the Esc button close modal
    document.addEventListener('keydown', function(event)
    {
        if (event.key === 'Escape') {
            closeModal('JobSelect');
        }
    });



    // Close the modal when clicking outside the modal content
    window.addEventListener('click', function(event) {
        if (event.target === document.getElementById('modalJobSelect')) {
            closeModal('JobSelect');
        }
    });


// Next To Info
function NextToInfo()
{
    // Show DetailInfo
    // Hide FasteningDisplay
    document.getElementById('DetailInfoDisplay').style.display = 'block';
    document.getElementById('FasteningDisplay').style.display = 'none';
}


function WorkFlowLogInfo()
{
    // Show Work Flow Log Info
    document.getElementById('WorkFlowLogInfoDisplay').style.display = 'block';

    // Hide Work Flow Log
    document.getElementById('WorkFlowLogDisplay').style.display = 'none';
}

/*function cancelSetting()
{
    var FasteningDisplay = document.getElementById('FasteningDisplay');
    var detailInfo = document.getElementById('DetailInfoDisplay');
    var combinedata = document.getElementById('CombineDataDisplay');
    var workflowlog = document.getElementById('WorkFlowLogInfoDisplay');

    // Check the current state and toggle accordingly
    if (detailInfo.style.display === 'block')
    {
        FasteningDisplay.style.display = 'block';
        detailInfo.style.display = 'none';
    }
    else if (combinedata.style.display === 'block')
    {
        // If cmombinedata is currently displayed, switch to FasteningDisplay
        FasteningDisplay.style.display = 'block';
        combinedata.style.display = 'none';
    }
    else if (workflowlog.style.display === 'block')
    {
        // If WorkFlowLogInfoDisplay is currently displayed, switch to WorkFlowLogDisplay
        WorkFlowLogDisplay.style.display = 'block';
        workflowlog.style.display = 'none';
    }
    else
    {
        // If FasteningDisplay is currently displayed or both are hidden, do nothing or handle it as needed
    }
}*/

function toggleMenu() {
    var menuContent = document.getElementById("myMenu");
    menuContent.style.display = (menuContent.style.display === "block") ? "none" : "block";
}



/// Onclick event for row background color
$(document).ready(function () {
    // Call highlight_row function with table id
    highlight_row('fastening-table');
    highlight_row('WorkFlowLog-table');
    highlight_row('UserAccess-table');
});

function highlight_row(tableId)
{
    var table = document.getElementById(tableId);
    var cells = table.getElementsByTagName('td');

    for (var i = 0; i < cells.length; i++) {
        // Take each cell
        var cell = cells[i];
        // do something on onclick event for cell

        cell.onclick = function ()
        {
            // Get the row id where the cell exists
            var rowId = this.parentNode.rowIndex;

            var rowsNotSelected = table.getElementsByTagName('tr');
            for (var row = 0; row < rowsNotSelected.length; row++) {
                rowsNotSelected[row].style.backgroundColor = "";
                rowsNotSelected[row].classList.remove('selected');
            }
            var rowSelected = table.getElementsByTagName('tr')[rowId];
            // rowSelected.style.backgroundColor = "red";
            rowSelected.className += "selected";

            //hide div
        }
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

<style type="text/css">
.selected
{
    background-color: #9AC0CD !important;
}
</style>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>


<!----nextinfo op----->
<?php if ($path == "nextinfo" && isset($data['chart_info']['chat_mode']) && $data['chart_info']['chat_mode'] != "6") { ?>
<script>
    var myChart = echarts.init(document.getElementById('chartinfo'));

    var x_data_val = <?php echo  $data['chart_info']['x_val']; ?>;
    var y_data_val = <?php echo  $data['chart_info']['y_val']; ?>;

    var min_val = <?php echo  $data['chat_y_min_val'];?>;
    var max_val = <?php echo  $data['chat_y_max_val'];?>;

    var x_title = '<?php echo $data['chart_info']['x_title'];?>';
    var y_title = '<?php echo $data['chart_info']['y_title'];?>';

    var chat_mode = '<?php echo $data['chart_info']['chat_mode'];?>';


    var option = {
            
            grid: GridConfig.generate('90%', '70%', '3%', '20%'),
            tooltip: {
                trigger: 'axis',
                position: function (pt) {
                    return [pt[0], '10%'];
                },
                formatter: function (params) {
                    var state = '<span style="color: red;">' + y_title + '</span>';
                    var value = '<span style="color: red;">' + params[0].value + '</span>';
                    return state + ': ' + value; 
                },
                
            },
            title: {left: 'center',text: '',},
            xAxis: {
                type: 'category',
                boundaryGap: true,
                name: x_title,
                data: x_data_val
            },
            yAxis: {
                type: 'value',
                name: y_title,
                boundaryGap: [0, '10%'],
                ...(chat_mode == 1 || chat_mode == 5 ? { max: max_val } : {})
            },
        dataZoom: generateDataZoom(),
        series: [
            {
                name:'',
                type:'line',
                symbol: 'none',
                sampling: 'average',
                
                itemStyle: {
                    normal: {
                        color: 'rgb(255,0,0)'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 0, [{
                            offset: 0,
                            color: 'rgb(255,255,255)'
                        }, {
                            offset: 0,
                            color: 'rgb(255,255,255)'
                        }])
                    }
                },
                lineStyle: {width: 0.75},
                data: y_data_val
            }
        ]
    };

    
    //如果 limit_val=1 曲線圖 要顯示上下限 min_val 及 max_val

   
    if ((x_title === "Time(MS)" && (y_title === "Power" || y_title === "RPM")) ||chat_mode == 2) {
        document.cookie = "limit_val=" + limit_val + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
        var limit_val = 0;
    }
    
    if ( limit_val == 1) {
        
        if(x_title  == "Time(MS)" && y_title =="Angle"){
            var t1 = 'low angle';
            var t2 = 'high angle';
        }else{
            var t1 = 'low torque';
            var t2 = 'high torque';
        }

        option.series[0].markLine = {
            data: [
                {yAxis: min_val, name: '',label: {position: 'middle',formatter: t1}}, 
                {yAxis: max_val, name: '',label: {position: 'middle',formatter: t2}}  
            ],
            symbol: 'none',
            lineStyle: {
            } 
        };
    }
    myChart.setOption(option);
    myChart.resize({
      width: window.innerWidth*0.8,
      height: 400,
    });


</script>
<?php } ?>

<?php if ($path == "nextinfo" && isset($data['chart_info']['chat_mode']) && $data['chart_info']['chat_mode'] == "6") { ?>
    <script>
        var myChart = echarts.init(document.getElementById('chartinfo'));

        var x_data_val = <?php echo $data['chart_info']['x_val']; ?>; // X軸
        var y_data_val = <?php echo $data['chart_info']['y_val']; ?>; // Y軸1(torque)
        var y_data_val_1 = <?php echo $data['chart_info']['y_val_1']; ?>; // Y軸2(angle)

        var max_val = <?php echo $data['chat_y_max_val']; ?>; // Y軸1的上限
        var min_val = <?php echo $data['chat_y_min_val']; ?>; // Y軸1的下限

        var max_val_1 = <?php echo $data['chart_info']['max1']; ?>; // Y軸2的上限
        var min_val_1 = <?php echo $data['chart_info']['min1']; ?>; // Y軸2的上限

        var option = {
            grid: GridConfig.generate('90%', '70%', '3%', '20%'),

            tooltip: {
                trigger: 'axis',
                position: function (pt) {
                    return [pt[0], '10%'];
                },
                formatter: function (params) {
                    var torqueColor = 'rgb(255,0,0)'; 
                    var angleColor = 'rgb(44,55,82)';
                    return '<span style="color:' + torqueColor + '">Torque: ' + params[0].value + '</span><br/>' +
                        '<span style="color:' + angleColor + '">Angle: ' + params[1].value + '</span>';
                }
            },

            title: {left: 'center',text: ''},
            xAxis: {
                type: 'category',
                boundaryGap: false,
                name: 'Time(ms)',
                nameLocation: 'end', 
                nameGap: 50, 
                data: x_data_val
            },
            yAxis: [
                {
                    type: 'value',
                    name: 'Torque',
                    min: min_val,
                    max: max_val,
                    alignTicks: true, 
                     axisLabel: {
                        formatter: function (value) {
                           return value === 0 ? '0' : value.toFixed(1);
                        }
                    }
                },
                {
                    type: 'value',
                    name: 'Angle',
                    min: min_val_1,
                    max: max_val_1,
                    alignTicks: true,
                    axisLabel: {
                        formatter: function (value) {
                           return parseFloat(value).toFixed(0);
                        }
                    }
                }
            ],
            dataZoom: generateDataZoom(), //曲線圖縮放

            series: [
                {
                    name: 'Torque',
                    type: 'line',
                    yAxisIndex: 0,
                    symbol: 'none',
                    sampling: 'average',
                    itemStyle: {
                        color: 'rgb(255,0,0)'
                    },
                    lineStyle: {width: 0.75},
                    data: y_data_val
                },
                {
                    name: 'Angle',
                    type: 'line',
                    yAxisIndex: 1,
                    symbol: 'none',
                    sampling: 'average',
                    itemStyle: {
                        color: 'rgb(44,55,82)'
                    },
                    lineStyle: {width: 0.75},
                    data: y_data_val_1
                }
            ]
        };

        
        //第一條曲線的上下限
        if (limit_val == 1) {
            option.series.push({
                type: 'line',
                markLine: {
                    symbol: 'none',
                    data: [
                        { yAxis: min_val,name: '',label: {position: 'middle',formatter: 'low torque'},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }, 
                        { yAxis: max_val,name: '',label: {position: 'middle',formatter: 'high torque'}, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }
                    ]
                }
            });
        }

        myChart.setOption(option);
    </script>
<?php }?>
<!----nextinfo ed----->

<!----combine op----->

<?php if ($path == "combinedata" && $data['chat_mode'] != "6"){?>
        <script>
            var chartData = <?php echo json_encode($data); ?>;
            var idTotal = <?php echo json_encode($data['id_total']); ?>;
            var chat_mode = '<?php echo $data['chat_mode'];?>';
            var check_limit_val = '<?php echo $data['check_limit_val'];?>';
            var max_count = '<?php echo $data['id_count'];?>';
            var myChart_combine = echarts.init(document.getElementById('chart_combine'));

   
            // 定義顏色調色盤
            var colorPalette = [
                '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
                '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf',
                '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
                '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf',
                '#f5b041', '#5dade2', '#a2d9ce', '#d91d3a', '#ff9c00',
                '#6c5b7b', '#c06c84', '#f67280', '#ffbe0b', '#2a9d8f',
                '#e9c46a', '#f1faee', '#264653', '#2a9d8f', '#e76f51',
                '#f9a826', '#e63946', '#f1faee', '#a8dadc', '#457b9d',
                '#1d3557', '#f1faee', '#e63946', '#f1faee', '#a8dadc',
                '#f77f00', '#d62839', '#003049', '#f1faee', '#e9c46a',
                '#2a9d8f', '#f1faee', '#264653', '#e63946', '#f1faee'
            ];

            // 將所有的 X 軸數據解析成 JavaScript陣列
            var xCoordinatesArray = chartData.chart_xcoordinates.map(x => JSON.parse(x));

            // 找到長度最長的 X 軸數據
            var xData = xCoordinatesArray.reduce((longest, current) => {
                return current.length > longest.length ? current : longest;
            }, []);

            // 針對最長 X 軸數據來處理 Y 軸數據
            var seriesData = Array.from({ length: 25 }, (_, i) => {
                var yData = chartData[`chart${i}_ycoordinate`] ? JSON.parse(chartData[`chart${i}_ycoordinate`]) : [];
                return yData.length === xData.length ? yData : [];
            }).filter(data => data.length > 0);

            // 获取最大值和最小值
            var maxValues = [];
            var minValues = [];
            for (var i = 0; i <= max_count; i++) {
                // 根据 chat_mode 和 chart 条件选择不同的最大最小值
                var maxVal, minVal;
                if (chat_mode == 1) { // 如果 chat_mode 是 1 且是 chart 5
                    maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max_correct`]);
                    minVal = parseFloat(chartData[`chart${i}_ycoordinate_min_correct`]);
                }else if(chat_mode == 5){
                    maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max_correct`]);
                    minVal = parseFloat(chartData[`chart${i}_ycoordinate_min_correct`]);
                }else {
                    maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max`]);
                    minVal = parseFloat(chartData[`chart${i}_ycoordinate_min`]);
                }
                
                maxValues.push(maxVal);
                minValues.push(minVal);
                console.log(`Chart ${i}: Min Value = ${minVal}, Max Value = ${maxVal}`);
            }

            // 比较最大值和最小值
            var overallMax = Math.max(...maxValues);
            var overallMin = Math.min(...minValues);
            console.log("Overall Min Value:", overallMin);
            console.log("Overall Max Value:", overallMax);

            var option = {
                title: {
                    text: '',
                    subtext: chartData.chart_combine.y_title
                },
                grid: {
                    top: 50,
                    bottom: 50,
                    left: 50,
                    right: 50
                },
                tooltip: {
                    trigger: 'axis',
                    position: function (pt) {
                        return [pt[0], '10%'];
                    },
                    formatter: generateTooltipContent
                },
                legend: {
                    data: idTotal.map((id, index) => `${index + 1} (${id})`)
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    name: chat_mode == 5 ? 'Angle' : 'Time(Ms)',
                    nameLocation: 'end',
                    nameGap: 0,
                    data: xData
                },
                yAxis: {
                    type: 'value',
                    boundaryGap: [0, '10%'],
                    min: overallMin, // 使用计算出的 overallMin
                    max: overallMax, // 使用计算出的 overallMax
                },
                dataZoom: generateDataZoom(),
                color: colorPalette,
                series: Array.from({ length: 25 }, (_, i) => {
                    if (chartData[`chart${i}_ycoordinate`]) {
                        return {
                            name: idTotal[i] ? `${i + 1} (${idTotal[i]})` : `${i + 1}`,
                            type: 'line',
                            symbol: 'none',
                            sampling: 'max',
                            alignTicks: true,
                            lineStyle: {
                                width: 2
                            },
                            data: JSON.parse(chartData[`chart${i}_ycoordinate`])
                        };
                    }
                    return null;
                }).filter(item => item !== null)
            };

            // 根據 chat_mode 設置標記線
            if (check_limit_val == "Y") {
                if (limit_val == 1) {
                    var markLineData = [];
                    if (chat_mode == 1 || chat_mode == 5) {
                        markLineData = [
                            { yAxis: overallMin, name: 'Lo Torque', label: { position: 'middle', formatter: 'Lo Torque' }, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                            { yAxis: overallMax, name: 'High Torque', label: { position: 'middle', formatter: 'High Torque' }, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }
                        ];
                    }
                    if (chat_mode == 2) {
                        markLineData = [
                            { yAxis: overallMin, name: 'Lo Angle', label: { position: 'middle', formatter: 'Lo Angle' }, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                            { yAxis: overallMax, name: 'High Angle', label: { position: 'middle', formatter: 'High Angle' }, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }
                        ];
                    }

                    option.series.push({
                        type: 'line',
                        markLine: {
                            data: markLineData,
                            symbol: 'none',
                        }
                    });
                }
            }

            // 設置圖表選項
            myChart_combine.setOption(option);
            myChart_combine.resize({
                width: window.innerWidth * 0.8,
                height: 400,
            });
        </script>


<?php }else if($path == "combinedata" && $data['chat_mode'] == "6"){?>
        <script>
            var chartData_s = <?php echo json_encode($data); ?>;
            var chat_mode = '<?php echo $data['chat_mode'];?>';
            var idTotal = <?php echo json_encode($data['id_total']); ?>;
            var check_limit_val = '<?php echo $data['check_limit_val'];?>';
            var myChart_combine = echarts.init(document.getElementById('chart_combine'));

            var colorPalette = [
                '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
                '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf',
                '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
                '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf',
                '#f5b041', '#5dade2', '#a2d9ce', '#d91d3a', '#ff9c00',
                '#6c5b7b', '#c06c84', '#f67280', '#ffbe0b', '#2a9d8f',
                '#e9c46a', '#f1faee', '#264653', '#2a9d8f', '#e76f51',
                '#f9a826', '#e63946', '#f1faee', '#a8dadc', '#457b9d',
                '#1d3557', '#f1faee', '#e63946', '#f1faee', '#a8dadc',
                '#f77f00', '#d62839', '#003049', '#f1faee', '#e9c46a',
                '#2a9d8f', '#f1faee', '#264653', '#e63946', '#f1faee'
            ];

            var max_count = '<?php echo $data['id_count'];?>';
            var xCoordinatesArray = chartData_s.chart_xcoordinates.map(x => JSON.parse(x));
            var xData_s = xCoordinatesArray.reduce((longest, current) => {
                return current.length > longest.length ? current : longest;
            }, []);

            var seriesData = [];
            var colorIndex = 0;

            var torqueValues = [];
            var angleValues = [];

            for (var i = 0; i <= max_count; i++) {
                var torqueKey = `chart${i}_ycoordinate`;
                var angleKey = `chart${i}_ycoordinate_angle`;

                var torque_max = chartData_s[`chart${i}_ycoordinate_max_correct`] || null;
                var torque_min = chartData_s[`chart${i}_ycoordinate_min_correct`] || null;
                var angle_max = chartData_s[`chart${i}_ycoordinate_max_angle`] || null;
                var angle_min = chartData_s[`chart${i}_ycoordinate_min_angle`] || null;

                if(torque_min == null){ torque_min = 0; }
                if(angle_min == null){ angle_min = 0; }

                if (torque_max !== null) {
                    torqueValues.push({ max: torque_max, min: torque_min });
                }
                if (angle_max !== null) {
                    angleValues.push({ max: angle_max, min: angle_min });
                }

                var torqueData1 = chartData_s[torqueKey] ? JSON.parse(chartData_s[torqueKey]) : [];
                var angleData1 = chartData_s[angleKey] ? JSON.parse(chartData_s[angleKey]) : [];

                if (torqueData1.length > 0) {
                    seriesData.push({
                        name: idTotal[i] + '_Torque',
                        type: 'line',
                        symbol: 'none',
                        sampling: 'max',
                        alignTicks: true,
                        lineStyle: { width: 0.75 },
                        data: torqueData1,
                        yAxisIndex: 0,
                        color: colorPalette[colorIndex % colorPalette.length]
                    });
                    colorIndex++;
                }

                if (angleData1.length > 0) {
                    seriesData.push({
                        name: idTotal[i] + '_Angle',
                        type: 'line',
                        symbol: 'none',
                        sampling: 'max',
                        alignTicks: true,
                        lineStyle: { width: 0.75 },
                        data: angleData1,
                        yAxisIndex: 1,
                        color: colorPalette[colorIndex % colorPalette.length]
                    });
                    colorIndex++;
                }
            }

            var overallTorqueMax = Math.max(...torqueValues.map(v => v.max));
            var overallTorqueMin = Math.min(...torqueValues.map(v => v.min));
            var overallAngleMax = Math.max(...angleValues.map(v => v.max));
            var overallAngleMin = Math.min(...angleValues.map(v => v.min));

            var option = {
                title: { text: '', subtext: '' },
                grid: { top: 80, bottom: 100, left: 50, right: 50 },
                tooltip: {
                    trigger: 'axis',
                    position: pt => [pt[0], '10%'],
                    formatter: generateTooltipContent
                },
                legend: { data: seriesData.map(series => series.name) },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    name: chat_mode == 6 ? 'Angle' : 'Time',
                    nameLocation: 'end',
                    nameGap: 30,
                    data: xData_s
                },
                yAxis: [
                    {
                        type: 'value',
                        name: 'Torque',
                        position: 'left',
                        alignTicks: true,
                        axisLabel: { formatter: '{value}' },
                        axisLine: { lineStyle: { color: '#333' } },
                        min: Math.min(overallTorqueMin, 0), // 確保包括最小值
                        max: overallTorqueMax // 確保足夠的最大值範圍
                    },
                    {
                        type: 'value',
                        name: 'Angle',
                        position: 'right',
                        alignTicks: true,
                        axisLabel: {
                            formatter: function (value) {
                                return Math.floor(value); // 移除小數點
                            }
                        },
                        axisLine: { lineStyle: { color: '#333' } },
                        min: 0, // 確保包括最小值
                        max: overallAngleMax + 1500 
                    }
                ],
                dataZoom: generateDataZoom(),
                color: colorPalette,
                series: seriesData
            };

            // 添加標記線
            console.log(overallTorqueMax);
            if (check_limit_val == "Y" && limit_val == 1) {
                option.series.push({
                    name: 'Torque Limits',
                    type: 'line',
                    markLine: {
                        data: [
                            { yAxis: overallTorqueMin, name: 'Low Torque', label: { position: 'middle', formatter: 'Low Torque' }, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                            { yAxis: overallTorqueMax, name: 'High Torque', label: { position: 'middle', formatter: 'High Torque' }, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }
                        ],
                        symbol: 'none'
                    },
                    lineStyle: { width: 0 },
                    yAxisIndex: 0
                });

                /*option.series.push({
                    name: 'Angle Limits',
                    type: 'line',
                    markLine: {
                        data: [
                            { yAxis: overallAngleMin, name: 'Low Angle', label: { position: 'middle', formatter: 'Low Angle' }, lineStyle: { type: 'dashed', color: 'rgb(0, 0, 255)' } },
                            { yAxis: overallAngleMax, name: 'High Angle', label: { position: 'middle', formatter: 'High Angle' }, lineStyle: { type: 'dashed', color: 'rgb(0, 0, 255)' } }
                        ],
                        symbol: 'none'
                    },
                    lineStyle: { width: 0 },
                    yAxisIndex: 1
                });*/
            }

            myChart_combine.setOption(option);
            window.addEventListener('resize', function() {
                myChart_combine.resize();
            });
        </script>


<?php }?>
<!----combine ed----->


<script>
function chat_mode_change(selectOS){
    var selectElement = document.getElementById('chartseting');
    var selectedOptions = [];
    for (var i = 0; i < selectElement.options.length; i++) {
        var option = selectElement.options[i];
        if (option.selected) {
            selectedOptions.push(option.value);
        }
    }   
     
    document.cookie = "chat_mode_change=" + selectedOptions + "; expires=" + new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toUTCString();
    history.go(0);
}
</script>
<?php if($path == "nextinfo" ){?>
<script>
document.getElementById('downloadchartbtn').addEventListener('click', function() {
    var menuChartDiv = document.getElementById('menu-chart');
    menuChartDiv.style.display = 'none';
    document.getElementById('chart-setting').style.display = 'none';
    document.getElementById('DiagramDisplay').style.display = 'none';

    //下拉式選單disable 做反灰的動作
    document.getElementById('chartseting').disabled = true;
    document.getElementById('Torque-Unit').disabled = true;
    document.getElementById('myCheckbox').disabled = true;

    var disabledSelects = document.querySelectorAll('select[disabled]');
    disabledSelects.forEach(function(select) {
        select.style.color = '#808080'; 
        select.style.backgroundColor = '#f0f0f0';
    });



    //取得圖表的base64編碼
    var chartDataURL = myChart.getDataURL({
        pixelRatio: 2,
        backgroundColor: '#fff' // 背景為白色
    });

    var divContent = document.getElementById('jobinfo').outerHTML;
    var stylesheets = document.getElementsByTagName('link');
    var cssString = Array.from(stylesheets)
        .map(stylesheet => `<link rel="stylesheet" href="${stylesheet.href}">`)
        .join('\n');

    //取得圖表的base64編碼插入到HTML
    var fullHTML = `<head>${cssString}</head>\n<body>${divContent}<img src="${chartDataURL}" alt="ECharts Chart" style="max-width: 100%; height: auto;"></body>`;
    var blob = new Blob([fullHTML], { type: 'text/html' });

    menuChartDiv.style.display = '';

    var link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.download = 'job_info.html';
    link.click();
    history.go(0);
});
</script>
<?php } ?>

<script>
//combine download html
document.getElementById('downland_combine').addEventListener('click', function() {
    var divToRemove = document.getElementById('empty1');
    var divToRemove2 = document.getElementById('chart-title');

    var job1 = '<?php if(isset($data['info_final'][0]['system_sn'])) echo $data['info_final'][0]['system_sn'];?>';
    var job2 = '<?php if(isset($data['info_final'][1]['system_sn'])) echo $data['info_final'][1]['system_sn'];?>';
    
    if(divToRemove) {
        divToRemove.parentNode.removeChild(divToRemove);
    }

    if(divToRemove2) {
        divToRemove2.parentNode.removeChild(divToRemove2);
    }

    document.getElementById('unit').disabled = true;
    var disabledSelects = document.querySelectorAll('select[disabled]');
    disabledSelects.forEach(function(select) {
        select.style.color = '#808080'; 
        select.style.backgroundColor = '#f0f0f0';
    });

    var chartDataURL = myChart_combine.getDataURL({
        pixelRatio: 2,
        backgroundColor: '#fff' 
    });

    var divContent = document.getElementById('combinedata').outerHTML;
    divContent = divContent.replace('force-overflow-Combine', 'photo');

    var additionalInfo = '\
     <div id="additional-info"> \
                            <span style="color: rgb(255, 0, 0);">第一組曲線圖:' + job1 + '的完整紀錄。</span><br> \
                            <br> \
                            <span style="color: rgb(44,55,82);">第二組曲線圖:' + job2 + '的完整紀錄。</span><br> \
                            <br> \
                      </div>';


    
    var stylesheets = document.getElementsByTagName('link');
    var cssString = Array.from(stylesheets)
        .map(stylesheet => `<link rel="stylesheet" href="${stylesheet.href}">`)
        .join('\n');
    
    divContent += additionalInfo;
    
    var fullHTML = `<head>${cssString}</head>\n<body>${divContent}<img src="${chartDataURL}" alt="ECharts Chart" style="max-width: 100%; height: auto;"></body>`;
    var blob = new Blob([fullHTML], { type: 'text/html' });

    var link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.download = 'job_combine.html';
    link.click();
    history.go(0);

});

</script>


<script type="text/javascript">
    
function reportWindowSize() {

  if (document.getElementById('chartinfo') != null) {
    var myChart = echarts.init(document.getElementById('chartinfo'));
    myChart.resize({
      width: window.innerWidth*0.8,
      height: 400,
    });    
  }
  if (document.getElementById('chart_combine') != null) {
    var myChart_combine = echarts.init(document.getElementById('chart_combine'));
    myChart_combine.resize({
      width: window.innerWidth*0.8,
      height: 400,
    });
  }
}

window.onresize = reportWindowSize;


function check_limit11(x_title,y_title){


    // 這裡檢查 x_title 和 y_title 的值
    if (x_title == "Time(MS)" && y_title == "Power") {
        limit_val = '0'; // 強制設置 limit_val 為 '0'
    }


}

</script>