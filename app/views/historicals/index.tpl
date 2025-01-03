<?php require APPROOT . 'views/inc/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/historical.css" type="text/css">

<script src="<?php echo URLROOT; ?>js/flatpickr.js"></script>
<script src="js/historical.js?v=<?php echo date('YmdHi'); ?>"></script>

<script src="<?php echo URLROOT; ?>js/echarts_min.js?v=<?php echo date('YmdHi'); ?>"></script>
<script src="<?php echo URLROOT; ?>js/html2canvas_min.js?v=<?php echo date('YmdHi'); ?>"></script>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/flatpickr_min.css?v=<?php echo date('YmdHi'); ?>">
<script src="<?php echo URLROOT; ?>js/flatpickr_date.js?v=<?php echo date('YmdHi'); ?>"></script>


<?php if(isset($data['nav'])){
    echo $data['nav'];
}

//

// 取得 URL 
$path = $_SERVER['REQUEST_URI'];
$path = str_replace('/public/index.php?url=Historicals/', '', $path);
$path = $data['path'];

// 优化的函数来显示元素并加载脚本
function displayElementAndLoadScript($elementId, $otherElementId, $scriptSrc) {
    echo "
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var element = document.getElementById('$elementId');
            if (element) {
                element.style.display = 'block';
            }
        
            var otherElement = document.getElementById('$otherElementId');
            if (otherElement) {
                otherElement.style.display = 'none';
            }
        });
    </script>
    ";
    echo "<script src='" . URLROOT . "js/$scriptSrc?v=202405151200'></script>";
}

if ($path == "combinedata") {
    displayElementAndLoadScript('CombineDataDisplay', 'FasteningDisplay', 'chart_share.js');
}

if ($path == "nextinfo") {
    displayElementAndLoadScript('DetailInfoDisplay', 'FasteningDisplay', 'chart_share.js');
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
                <!--<div class="navbutton" onclick="handleButtonClick(this, 'workflowlog')">
                    <span data-content="<?php echo $text['Work_Flow_Log_text']; ?>" onclick="showContent('workflowlog')"></span><?php echo $text['Work_Flow_Log_text']; ?>
                </div>-->
                <!--<div class="navbutton" onclick="handleButtonClick(this, 'useraccess')">
                    <span data-content="<?php echo $text['User_Access_Logging_text']; ?>" onclick="showContent('useraccess')"></span><?php echo $text['User_Access_Logging_text']; ?>
                </div>-->
            </div>

            <!-- Fastening Setting -->
            <div id="fasteningContent" class="content">
                <div id="FasteningDisplay" style="margin-top: 40px">
                 
                    <!---search bar op ----->
                    <div class="mt-2" style="margin-right: 20%; margin-left: 3%">
                        <div class="input-group mb-2">
                            <span class="input-group-text"><?php echo $text['BarcodeSN_text']; ?>:</span>
                            <input type="text" id="barcodesn" name="barcodesn" class="form-control input-ms" style="margin-right: 7px">

                            <span class="input-group-text"><?php echo $text['Operator_text']; ?>:</span>
                            <select id="operator" name="operator" class="form-control input-ms" style="margin-right: 7px">
                                 <option value="-1"><?php echo $text['Choose_text'];?></option>
                                <?php foreach($data['all_users'] as $k_user =>$v_user){?>
                                    <option value="<?php echo $v_user['account'];?>"><?php echo $v_user['account'];?></option>
                                <?php }?>
                            </select>
                  

                            <span class="input-group-text"><?php echo $text['Select_Job_text']; ?>:</span>
                            <input type="text" class="form-control input-ms" id="JobSelect" placeholder="<?php echo $text['Click_here_text']; ?>.." onfocus="openModal('JobSelect')" onclick="this.blur()">    
                        </div>

                        <div class="input-group mb-2">
                            <span class="input-group-text"><?php echo $text['From_text']; ?>:</span>
                            <input type="datetime" id="FromDate" name="FromDate" class="form-control input-ms" style="margin-right: 7px;background-color: white;" placeholder="<?php echo $text['Click_here_text'];?>">

                            <span class="input-group-text"><?php echo $text['To_text']; ?>:</span>
                            <input type="datetime" id="ToDate" name="ToDate" class="form-control input-ms" style="margin-right: 7px; background-color: white;" placeholder="<?php echo $text['Click_here_text'];?>">
                        </div>

                        <div class="input-group mb-2">
                            <span class="input-group-text"><?php echo $text['Result_Status_text']; ?>:</span>
                            <select id="status" class="form-select" name="" style="margin-right: 7px">
                                <option value="-1"><?php echo $text['Choose_text'];?></option>
                                <?php foreach($data['res_status_arr'] as $key_res =>$val_res){?>
                                    <option value="<?php echo $key_res;?>"><?php echo $val_res;?></option>
                                <?php }?>
                            </select>

                            <span class="input-group-text"><?php echo $text['Controller_text']; ?>:</span>
                            <select id="controller" class="form-select" name="" style="margin-right: 7px">
                                <option value="-1"><?php echo $text['Choose_text'];?></option>
                                <?php foreach($data['res_controller_arr'] as $key_res_1 =>$val_res_1){?>
                                    <option value="<?php echo $key_res_1;?>"><?php echo $val_res_1;?></option>
                                <?php }?>
                            </select>

                            <span class="input-group-text"><?php echo $text['Program_text']; ?>:</span>
                            <select id="Program" class="form-select" name="">
                                <option value="-1"><?php echo $text['Choose_text'];?></option>
                                <?php foreach($data['res_program'] as $key_res_2 => $val_res_2){?>
                                    <option value="<?php echo $val_res_2['template_program_id'];?>"><?php echo $val_res_2['template_program_id'];?></option>
                                <?php }?>
                            </select>
                        </div>
                        
                    </div>                


                    <div class="topnav-menu">
                        <div class="search-container">
                            <input type="text" placeholder="<?php echo $text['Search_text']; ?>.." name="sname" id="search_name" size="40" style="height: 35px">&nbsp;
                            <button id="Search" type="button" class="Search-button" onclick="search_info()"><?php echo $text['Search_text']; ?></button>
                        </div>
                        <!---search bar ed ----->

                        <div class="topnav-right">

                            <?php echo (!empty($data['user_role_title']) && $data['user_role_title'] == "Super admin") ? '<button onclick="deleteinfo()" class="ExportButton"><i class="fa fa-trash-o" style="font-size:26px;color:white"></i></button>' : ''; ?>
                            <button id="Export-CSV" type="button" class="ExportButton" onclick="csv_download()"><?php echo $text['Export_text']; ?> CSV</button>
                            <button id="Export-Report" type="button" class="ExportButton" onclick="window.open('?url=Historicals/history_result', '_blank');" ><?php echo $text['Export_Report_text']; ?></button>
                            <button id="Combine-btn" type="button" onclick="NextToCombineData()"><?php echo $text['Combine_Data_text']; ?></button>
                            <button id="Clear" type="button" onclick="clear_button() "><?php echo $text['Clear_text']; ?></button>
                            <button id="nopage" type="button" onclick="nopage('nopage')"><?php echo $text['Nopage_text']; ?></button>
                        </div>

                    </div>

                    <div class="scrollbar-fastening" id="style-fastening">
                         
                         <?php $this->view('historicals/search_index', $data); ?>
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
                                <td><?php echo $text['Job_info_text']; ?>: <?php echo $data['job_info'][0]['job_name'];?> / <?php echo $data['job_info'][0]['sequence_name']. "/". $data['job_info'][0]['cc_task_id'];?></td>
                                <td><?php echo $text['Controller_text']; ?>: <?php echo $data['res_controller_arr'][$data['job_info'][0]['cc_equipment']];?></td>
                                <td><?php echo $text['Error_code_text']; ?>: <?php echo  $data['status_arr']['error_msg'][$data['job_info'][0]['error_message']];?></td>
                                <td><?php echo $text['Status_text']; ?> : <a style="background-color: <?php echo $data['status_arr']['status_color'][$data['job_info'][0]['fasten_status']];?>; padding: 0 10px"><?php echo $data['status_arr']['status_type'][$data['job_info'][0]['fasten_status']];?></a></td>
                            </tr>
                            <tr>
                                <td><?php echo $text['Actual_Torque_text']; ?>: <?php echo $data['job_info'][0]['fasten_torque'];?> <?php echo $text[$data['torque_unit']];?></td>
                                <td><?php echo $text['BarcodeSN_text']; ?>: <?php echo $data['job_info'][0]['cc_barcodesn'];?></td>
                                <td><?php echo $text['Direction_text']; ?>: <?php echo  $data['status_arr']['direction'][$data['job_info'][0]['count_direction']];?></td>
                                <td><?php echo $text['Program_text']; ?>: <?php echo $data['job_info'][0]['cc_program_id'];?></td>
                                <td><?php echo $text['Time_text']; ?>: <?php echo $data['job_info'][0]['data_time'];?></td>
                            </tr>
                            <tr  style="vertical-align: middle;">
                                <td><?php echo $text['Member_text']; ?>:<?php echo $data['job_info'][0]['cc_operator'];?></td>
                                <td><?php echo $text['Note_text']; ?>: 
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
                                       <select id="unit" style="width: 100px" onchange="unit_change_combine(this)">
                                            <?php foreach ($data['torque_mode_arr'] as $k_torque => $v_torque) { ?>
                                                <option value="<?php echo $k_torque; ?>" 
                                                    <?php 
                                                        echo (isset($data['unit']) && $data['unit'] == $k_torque) ? "selected" : ""; 
                                                    ?>>
                                                    <?php echo $text[$v_torque]; ?>
                                                </option>
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
                                <td>From : <input type="datetime" class="t3" id="FromDate" name="FromDate" style="width: 190px;border-radius: 5px;border: 1px solid #CCCCCC;float: none"> </td>
                                <td>To : <input type="datetime" class="t3" id="ToDate" name="ToDate" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;float: none"></td>
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
                              
                            </table>
                        </div>
                    </div>
                </div>

             
            </div>

        </div>
    </div>

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
    var step_prr_rpm   = '<?php echo $data['job_info'][0]['step_prr_rpm'];?>';
    var step_prr_angle = '<?php echo $data['job_info'][0]['step_prr_angle'];?>';
    var step_threshold_angle = parseFloat('<?php echo $data['job_info'][0]['step_threshold_angle']; ?>');

    var downshift_torque = '<?php echo $data['job_info'][0]['downshift_torque'];?>';
    var threshold_torque = '<?php echo $data['job_info'][0]['threshold_torque'];?>';



    var job_type = '<?php echo $data['job_type'];?>';
    var control_torque = (typeof <?php echo isset($data['chart_info']['control_torque']) ? 'true' : 'false'; ?> !== 'undefined' && <?php echo isset($data['chart_info']['control_torque']) ? 'true' : 'false'; ?>) 
        ? parseFloat('<?php echo htmlspecialchars($data['chart_info']['control_torque'], ENT_QUOTES, 'UTF-8'); ?>') 
        : 0; 

    var last_key = (typeof <?php echo isset($data['chart_info']['last_key']) ? 'true' : 'false'; ?> !== 'undefined' && <?php echo isset($data['chart_info']['last_key']) ? 'true' : 'false'; ?>) 
        ? parseInt('<?php echo $data['chart_info']['last_key']; ?>', 10) 
        : 0; 

    var last_key_downshift_torque = (typeof <?php echo isset($data['chart_info']['last_key_downshift_torque']) ? 'true' : 'false'; ?> !== 'undefined' && <?php echo isset($data['chart_info']['last_key_downshift_torque']) ? 'true' : 'false'; ?>) 
        ? parseInt('<?php echo $data['chart_info']['last_key_downshift_torque']; ?>', 10) 
        : 0; 

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

    
    //type = normalstep && chat_mode = 2  || chat_mode = 5 處理 step_threshold_angle
    if (step_prr_rpm != '' && step_prr_angle != '' && step_prr_rpm > 0 && step_prr_angle > 0 && job_type == 'normalstep' && y_data_val.length > 0 && step_threshold_angle > 0 && (chat_mode == '2' || chat_mode == '5')) {
        var x_value = x_data_val[0];
        var y_value = y_data_val[0];

        option.series[0].markPoint = option.series[0].markPoint || { data: [] };

        // 根據 chat_mode 決定 label 的 formatter 格式
        var labelFormatter = 'threshold_angle:' + step_threshold_angle;

        // 將 markPoint 資料加入到數據中
        option.series[0].markPoint.data.push({
            xAxis: x_value,  
            yAxis: y_value,  
            symbol: 'circle',
            symbolSize: 6,   
            itemStyle: {
                color: 'blue'  
            },
            label: {
                position: 'top',
                formatter: labelFormatter
            }
        });
    }


    //type = normalstep && chat_mode = 1   &&  threshold_torque != '0' 處理  threshold_torque
    if (chat_mode == '1'  && threshold_torque != '0' && job_type == 'normalstep' && !isNaN(control_torque)) {
     
        option.series[0].markPoint = option.series[0].markPoint || { data: [] };
        // 精確尋找 threshold_torque
        var exactMatchIndex = -1;
            for (var i = y_data_val.length - 1; i >= 0; i--) {  // 從後往前遍歷
            if (y_data_val[i] == control_torque) {
                exactMatchIndex = i;
                console.log(exactMatchIndex);
                //break;  // 找到最後一筆符合條件的點後停止搜尋
            }
        }

        // 如果找到精確匹配的點，則將其標註
        if (exactMatchIndex !== -1) {
            var exactXValue = x_data_val[exactMatchIndex];
            var exactYValue = y_data_val[exactMatchIndex];

            //已找到點標註圓點
            addMarkPoint(exactMatchIndex, exactYValue, threshold_torque,'blue','threshold_torque:');
        }
    }

    //type = normalstep && chat_mode = 1   &&  downshift_torque != '0' 處理  downshift_torque
    if (chat_mode == '1' && downshift_torque != '0' && job_type == 'normalstep' && !isNaN(downshift_torque)) {
        option.series[0].markPoint = option.series[0].markPoint || { data: [] };

        // 將 downshift_torque 轉換為浮動數
        var downshiftTorqueFloat = parseFloat(downshift_torque);

        // 嘗試精確匹配
        var exactMatchIndex = findExactMatch(y_data_val, downshiftTorqueFloat);

        if (exactMatchIndex !== -1) {
            // 找到精確匹配
            var exactXValue = x_data_val[exactMatchIndex];
            var exactYValue = y_data_val[exactMatchIndex];

            //已找到點標註圓點
            addMarkPoint(exactMatchIndex, rangeYValue, downshift_torque,'green','downshift_torque:'); 
        } else {
            // 如果沒有精確匹配，則進行範圍匹配
            var rangeMatchIndex = findRangeMatch(y_data_val, downshiftTorqueFloat);

            if (rangeMatchIndex !== -1) {
                // 找到範圍匹配
                var rangeXValue = x_data_val[rangeMatchIndex];
                var rangeYValue = y_data_val[rangeMatchIndex];

                //已找到點標註圓點
                addMarkPoint(rangeMatchIndex, rangeYValue, downshift_torque,'green','downshift_torque:');

            }
        }
    }

    if ((chat_mode == '3'  || chat_mode == '4' ) && threshold_torque != '0' && job_type == 'normalstep' && !isNaN(control_torque)) {
        option.series[0].markPoint = option.series[0].markPoint || { data: [] };

        var y_val_torque = <?php echo isset($data['chart_info']['y_val_torque']) ? $data['chart_info']['y_val_torque'] : '[]'; ?>;

        //精確尋找threshold_torque
        var exactMatchIndex = -1;
        for (var i = y_val_torque.length - 1; i >= 0; i--) {  
            if (y_val_torque[i] == control_torque) {
                exactMatchIndex = i;
                console.log("找到匹配点，索引:", exactMatchIndex);
                break;
            }
        }

        // 需要用圓點標註
        if (exactMatchIndex !== -1) {
            var exactXValue = x_data_val[exactMatchIndex]; 
            var exactYValue = y_data_val[exactMatchIndex];
            addMarkPoint(last_key, exactYValue, threshold_torque, 'blue', 'threshold_torque:');
        } 
    }

    if ((chat_mode == '3'  ||  chat_mode == '4')  && downshift_torque != '0' && job_type == 'normalstep' && !isNaN(control_torque)) {
        option.series[0].markPoint = option.series[0].markPoint || { data: [] };

        var y_val_torque = <?php echo isset($data['chart_info']['y_val_torque']) ? $data['chart_info']['y_val_torque'] : '[]'; ?>;

        // 將 downshift_torque 轉換為浮動數字
        var downshiftTorqueFloat = parseFloat(downshift_torque);

        // 嘗試精確匹配
        var exactMatchIndex = findExactMatch(y_val_torque, downshiftTorqueFloat);

        if (exactMatchIndex !== -1) {
            // 找到精確匹配
            var exactXValue = x_data_val[exactMatchIndex];
            var exactYValue = y_data_val[exactMatchIndex];  // 使用 y_data_val 來標註 Y 軸

            // 已找到點，標註圓點
            addMarkPoint(last_key_downshift_torque, exactYValue, downshift_torque, 'green', 'downshift_torque:'); 
        } else {
            // 如果沒有精確匹配，則進行範圍匹配
            var rangeMatchIndex = findRangeMatch(y_val_torque, downshiftTorqueFloat);

            if (rangeMatchIndex !== -1) {
                // 找到範圍匹配
                var rangeXValue = x_data_val[rangeMatchIndex];
                var rangeYValue = y_data_val[rangeMatchIndex];  // 使用 y_data_val 來標註 Y 軸

                // 已找到點，標註圓點
                addMarkPoint(last_key_downshift_torque, rangeYValue, downshift_torque, 'green', 'downshift_torque:');
            }
        }
    }

    

    // chart_mode == 5
    if (chat_mode == '5' && threshold_torque != '0' && job_type == 'normalstep' && !isNaN(control_torque)) {
         option.series[0].markPoint = option.series[0].markPoint || { data: [] };
        // 精確尋找 threshold_torque
        var exactMatchIndex = -1;
            for (var i = y_data_val.length - 1; i >= 0; i--) {  // 從後往前遍歷
            if (y_data_val[i] == control_torque) {
                exactMatchIndex = i;
                console.log(exactMatchIndex);
                //break;  // 找到最後一筆符合條件的點後停止搜尋
            }
        }

        // 如果找到精確匹配的點，則將其標註
        if (exactMatchIndex !== -1) {
            var exactXValue = x_data_val[exactMatchIndex];
            var exactYValue = y_data_val[exactMatchIndex];

            //已找到點標註圓點
            addMarkPoint(exactMatchIndex, exactYValue, threshold_torque,'blue','threshold_torque:');
        }
    }


    if (chat_mode == '5' && downshift_torque != '0' && job_type == 'normalstep' && !isNaN(downshift_torque)) {
        option.series[0].markPoint = option.series[0].markPoint || { data: [] };

        // 將 downshift_torque 轉換為浮動數
        var downshiftTorqueFloat = parseFloat(downshift_torque);

        // 嘗試精確匹配
        var exactMatchIndex = findExactMatch(y_data_val, downshiftTorqueFloat);

        if (exactMatchIndex !== -1) {
            // 找到精確匹配
            var exactXValue = x_data_val[exactMatchIndex];
            var exactYValue = y_data_val[exactMatchIndex];

            //已找到點標註圓點
            addMarkPoint(exactMatchIndex, rangeYValue, downshift_torque,'green','downshift_torque:'); 
        } else {
            // 如果沒有精確匹配，則進行範圍匹配
            var rangeMatchIndex = findRangeMatch(y_data_val, downshiftTorqueFloat);

            if (rangeMatchIndex !== -1) {
                // 找到範圍匹配
                var rangeXValue = x_data_val[rangeMatchIndex];
                var rangeYValue = y_data_val[rangeMatchIndex];

                //已找到點標註圓點
                addMarkPoint(rangeMatchIndex, rangeYValue, downshift_torque,'green','downshift_torque:');

            }
        }
    }

        
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

    function findExactMatch(data, targetValue) {
        for (let i = 0; i < data.length; i++) {
            if (data[i] === targetValue) {
                return i; // 找到精確匹配的索引
            }
        }
        return -1; // 如果沒有找到，返回 -1
    }

    function findRangeMatch(data, targetValue) {
        let rangeStart = targetValue;
        let rangeEnd = targetValue + 0.099; // 設定範圍上限

        for (let i = 0; i < data.length; i++) {
            if (data[i] >= rangeStart && data[i] <= rangeEnd) {
                return i; // 找到範圍內匹配的索引
            }
        }
        return -1; // 如果沒有找到，返回 -1
    }

    function addMarkPoint(last_key_downshift_torque, yValue, torqueValue, color , labelText) {
        option.series[0].markPoint.data.push({
            xAxis: last_key_downshift_torque,
            yAxis: yValue,
            symbol: 'circle',
            symbolSize: 6,
            itemStyle: { color: color },  // 動態設定顏色
            label: { 
                position: 'top', 
                formatter: labelText + torqueValue // 動態設定標籤文本
            }
        });
    }



</script>
<?php } ?>

<?php if ($path == "nextinfo" && isset($data['chart_info']['chat_mode']) && $data['chart_info']['chat_mode'] == "6") { ?>
    <script>
      
        var myChart = echarts.init(document.getElementById('chartinfo'));
        var chat_mode = '<?php echo $data['chart_info']['chat_mode']?>';

        var x_data_val = <?php echo $data['chart_info']['x_val']; ?>; // X軸
        var y_data_val = <?php echo $data['chart_info']['y_val']; ?>; // Y軸1(torque)
        var y_data_val_1 = <?php echo $data['chart_info']['y_val_1']; ?>; // Y軸2(angle)

        var max_val = <?php echo $data['chat_y_max_val']; ?>; // Y軸1的上限
        var min_val = <?php echo $data['chat_y_min_val']; ?>; // Y軸1的下限

        var max_val_1 = <?php echo $data['chart_info']['max1']; ?>; // Y軸2的上限
        var min_val_1 = <?php echo $data['chart_info']['min1']; ?>; // Y軸2的上限

        var step_prr_rpm   = '<?php echo $data['job_info'][0]['step_prr_rpm'];?>';
        var step_prr_angle = '<?php echo $data['job_info'][0]['step_prr_angle'];?>';
        var step_threshold_angle = parseFloat('<?php echo $data['job_info'][0]['step_threshold_angle']; ?>');
    
        var downshift_torque = '<?php echo $data['job_info'][0]['downshift_torque'];?>';
        var threshold_torque = '<?php echo $data['job_info'][0]['threshold_torque'];?>';
        var job_type = '<?php echo $data['job_type'];?>';
        var control_torque = (typeof <?php echo isset($data['chart_info']['control_torque']) ? 'true' : 'false'; ?> !== 'undefined' && <?php echo isset($data['chart_info']['control_torque']) ? 'true' : 'false'; ?>) 
            ? parseFloat('<?php echo htmlspecialchars($data['chart_info']['control_torque'], ENT_QUOTES, 'UTF-8'); ?>') 
            : 0; 

        var last_key = (typeof <?php echo isset($data['chart_info']['last_key']) ? 'true' : 'false'; ?> !== 'undefined' && <?php echo isset($data['chart_info']['last_key']) ? 'true' : 'false'; ?>) 
            ? parseInt('<?php echo $data['chart_info']['last_key']; ?>', 10) 
            : 0; 

        var last_key_downshift_torque = (typeof <?php echo isset($data['chart_info']['last_key_downshift_torque']) ? 'true' : 'false'; ?> !== 'undefined' && <?php echo isset($data['chart_info']['last_key_downshift_torque']) ? 'true' : 'false'; ?>) 
            ? parseInt('<?php echo $data['chart_info']['last_key_downshift_torque']; ?>', 10) 
            : 0; 


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



          if (chat_mode == '6' && threshold_torque != '0' && job_type == 'normalstep' && !isNaN(control_torque)) {    
            option.series[0].markPoint = option.series[0].markPoint || { data: [] };
            // 精確尋找 threshold_torque
            var exactMatchIndex = -1;
                for (var i = y_data_val.length - 1; i >= 0; i--) {  // 從後往前遍歷
                if (y_data_val[i] == control_torque) {
                    exactMatchIndex = i;
                    console.log(exactMatchIndex);
                    //break;  // 找到最後一筆符合條件的點後停止搜尋
                }
            }

            // 如果找到精確匹配的點，則將其標註
            if (exactMatchIndex !== -1) {
              
                var exactXValue = x_data_val[exactMatchIndex];
                var exactYValue = y_data_val[exactMatchIndex];

                //已找到點標註圓點
                addMarkPoint(exactMatchIndex, exactYValue, threshold_torque,'blue','threshold_torque:');
            }
        }



        if (chat_mode == '6' && downshift_torque != '0' && job_type == 'normalstep' && !isNaN(downshift_torque)) {
            option.series[0].markPoint = option.series[0].markPoint || { data: [] };

            // 將 downshift_torque 轉換為浮動數
            var downshiftTorqueFloat = parseFloat(downshift_torque);

            // 嘗試精確匹配
            console.log(y_data_val);
            var exactMatchIndex = findExactMatch(y_data_val, downshiftTorqueFloat);
            if (exactMatchIndex !== -1) {
                // 找到精確匹配
                var exactXValue = x_data_val[exactMatchIndex];
                var exactYValue = y_data_val[exactMatchIndex];

                // 已找到點標註圓點
                addMarkPoint(exactMatchIndex, exactYValue, downshift_torque, 'green', 'downshift_torque:');
            } else {
                // 如果沒有精確匹配，則進行範圍匹配
                var rangeMatchIndex = findRangeMatch(y_data_val, downshiftTorqueFloat);

                if (rangeMatchIndex !== -1) {
                    var rangeXValue = x_data_val[rangeMatchIndex];
                    var rangeYValue = y_data_val[rangeMatchIndex];

                    // 已找到點標註圓點
                    addMarkPoint(rangeMatchIndex, rangeYValue, downshift_torque, 'green', 'downshift_torque:');
                }
            }

        }
        

        if(chat_mode == '6' && job_type == 'normalstep' && step_threshold_angle > 0 ){
            option.series[0].markPoint = option.series[0].markPoint || { data: [] };

            var x_value = x_data_val[0];
            var y_value = y_data_val_1[0];

            // 根據 chat_mode 決定 label 的 formatter 格式
            option.series[0].markPoint = option.series[0].markPoint || { data: [] };

            var labelFormatter = 'threshold_angle:' + step_threshold_angle;

            // 新增 markPoint 資料
            option.series[0].markPoint.data.push({
                xAxis: x_value, 
                yAxis: y_value,  
                symbol: 'circle', 
                symbolSize: 6,   
                itemStyle: {
                    color: 'blue'  
                },
                label: {
                    position: 'top', 
                    formatter: labelFormatter
                }
            });

        }

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


    function addMarkPoint(last_key_downshift_torque, yValue, torqueValue, color , labelText) {
        option.series[0].markPoint.data.push({
            xAxis: last_key_downshift_torque,
            yAxis: yValue,
            symbol: 'circle',
            symbolSize: 6,
            itemStyle: { color: color },  // 動態設定顏色
            label: { 
                position: 'top', 
                formatter: labelText + torqueValue // 動態設定標籤文本
            }
        });
    }

    function findExactMatch(data, targetValue) {
        for (let i = 0; i < data.length; i++) {
            if (data[i] === targetValue) {
                return i; // 找到精確匹配的索引
            }
        }
        return -1; // 如果沒有找到，返回 -1
    }

    function findRangeMatch(data, targetValue) {
        let rangeStart = targetValue;
        let rangeEnd = targetValue + 0.099; // 設定範圍上限

        for (let i = 0; i < data.length; i++) {
            if (data[i] >= rangeStart && data[i] <= rangeEnd) {
                return i; // 找到範圍內匹配的索引
            }
        }
        return -1; // 如果沒有找到，返回 -1
    }
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

        var threshold_torque_total  = <?php echo isset($data['threshold_torque']) ? json_encode($data['threshold_torque']) : '[]'; ?>;
        var downshift_torque_total  = <?php echo isset($data['downshift_torque']) ? json_encode($data['downshift_torque']) : '[]'; ?>;
        var threshold_angle_total   = <?php echo isset($data['threshold_angle_total'])  ? json_encode($data['threshold_angle_total']) : '[]'; ?>;

        var last_key_threshold_torque = <?php echo isset($data['last_key_threshold_torque']) ? json_encode($data['last_key_threshold_torque']) : '[]'; ?>;
        var last_key_threshold_angle  = <?php echo isset($data['last_key_threshold_angle']) ? json_encode($data['last_key_threshold_angle']) : '[]'; ?>;
        var last_key_downshift_torque = <?php echo isset($data['last_key_downshift_torque']) ? json_encode($data['last_key_downshift_torque']) : '[]'; ?>;


        //顏色選擇
        var colorPalette = getColorPalette();
          

        // 解析 X 軸數值
        var xCoordinatesArray = chartData.chart_xcoordinates.map(x => JSON.parse(x));
        var xData = xCoordinatesArray.reduce((longest, current) => current.length > longest.length ? current : longest, []);
        var seriesData = Array.from({ length: 25 }, (_, i) => {
            var yData = chartData[`chart${i}_ycoordinate`] ? JSON.parse(chartData[`chart${i}_ycoordinate`]) : [];
            // 填充或截斷 yData
            if (yData.length !== xData.length) {
                yData = yData.slice(0, xData.length);
                while (yData.length < xData.length) {
                    yData.push(null);
                }
            }
            return yData;
        }).filter(data => data.length > 0);

        // 計算最大值和最小值
        var maxValues = [], minValues = [];
        for (var i = 0; i <= max_count; i++) {
            var maxVal = parseFloat(chartData[`chart${i}_ycoordinate_max`]) || 0;
            var minVal = parseFloat(chartData[`chart${i}_ycoordinate_min`]) || 0;
            maxValues.push(maxVal);
            minValues.push(minVal);
        }
        var overallMax = Math.max(...maxValues);
        var overallMin = Math.min(...minValues);

        // 處理標記點數據
        function processMarkPointData(chat_mode) {
            var markPointData = [];

            if ((chat_mode == 1 || chat_mode == 5 || chat_mode == 3  || chat_mode ==4 )  && threshold_torque_total && threshold_torque_total.length > 0 && downshift_torque_total && downshift_torque_total.length > 0) {
                var thresholdArray = threshold_torque_total.split(',').map(Number);
                var downshiftArray = downshift_torque_total.split(',').map(Number);
                //console.log(downshiftArray);

                // 標註 threshold_torque 點
                last_key_threshold_torque.forEach((threshold, index) => {
                    var yData = JSON.parse(chartData[`chart${index}_ycoordinate`]);

                    //查找 yData 中是否包含 threshold_torque
                    var yValue = yData[threshold];
                    
                    if (yValue !== undefined) {
                        markPointData.push({
                            type: 'max',
                            name: `threshold_torque ${index + 1}`,
                            coord: [threshold, yValue], 
                            symbol: 'circle',
                            symbolSize: 6,
                            itemStyle: { color: 'blue' },
                            label: {
                                show: true,
                                formatter: `threshold_torque: ${thresholdArray[index]}`,
                                position: 'top' 
                            }
                        });
                    }
                });

                // 標註 downshift_torque 點
                last_key_downshift_torque.forEach((downshift, index) => {
                    var yData = JSON.parse(chartData[`chart${index}_ycoordinate`]);

                    //查找 yData 中是否包含 downshift_torque
                    var yValue = yData[downshift];
                    
                    if (yValue !== undefined) {
                        markPointData.push({
                            type: 'max',
                            name: `downshift_torque ${index + 1}`,
                            coord: [downshift, yValue], 
                            symbol: 'circle',
                            symbolSize: 6,
                            itemStyle: { color: 'green' },
                            label: {
                                show: true,
                                formatter: `downshift_torque: ${downshiftArray[index]}`,
                                position: 'top' 
                            }
                        });
                    }
                });
            }


            if(chat_mode == 2 && last_key_threshold_angle ) {
                var threshold_angle_array = threshold_angle_total.split(',').map(Number);
                console.log(last_key_threshold_angle);

                last_key_threshold_angle.forEach((threshold, index) => {
                    var yData = JSON.parse(chartData[`chart${index}_ycoordinate`]);

                    //查找 yData 中是否包含 threshold_angle
                    var yValue = yData[threshold];
                    
                    if (yValue !== undefined) {
                        markPointData.push({
                            type: 'max',
                            name: `threshold_angle ${index + 1}`,
                            coord: [threshold, yValue], 
                            symbol: 'circle',
                            symbolSize: 6,
                            itemStyle: { color: 'blue' },
                            label: {
                                show: true,
                                formatter: `threshold_angle:${threshold_angle_array[index]}`,
                                position: 'top' 
                            }
                        });
                    }
                });
            }

            if(chat_mode == 5 && last_key_threshold_angle ) {
                var threshold_angle_array = threshold_angle_total.split(',').map(Number);
                console.log(last_key_threshold_angle);

                last_key_threshold_angle.forEach((threshold, index) => {
                    var yData = JSON.parse(chartData[`chart${index}_ycoordinate`]);

                    //查找 yData 中是否包含 threshold_angle
                    var yValue = yData[threshold];
                    
                    if (yValue !== undefined) {
                        markPointData.push({
                            type: 'max',
                            name: `threshold_angle ${index + 1}`,
                            coord: [threshold, yValue], 
                            symbol: 'circle',
                            symbolSize: 6,
                            itemStyle: { color: 'blue' },
                            label: {
                                show: true,
                                formatter: `threshold_angle:${threshold_angle_array[index]}`,
                                position: 'top' 
                            }
                        });
                    }
                });
            }
        
            return markPointData;
        }

        var markPointData = processMarkPointData(chat_mode);

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
                position: function (pt) { return [pt[0], '10%']; },
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
                min: overallMin,
                max: overallMax,
            },
            dataZoom: generateDataZoom(),
            color: colorPalette,
            series: Array.from({ length: 25 }, (_, i) => {
                if (chartData[`chart${i}_ycoordinate`]) {

                    var yData = JSON.parse(chartData[`chart${i}_ycoordinate`]);

                     // chat_mode == 2 時隱藏值為 0 的曲線
                    if (chat_mode == 2 && yData.every(val => val === 0)) {
                        return null; // 若值全為 0，返回 null，將該系列隱藏
                    }
                    
                    //console.log(`Curve ${i + 1} (${idTotal[i] || ''}):`, yData);
                    return {
                        name: idTotal[i] ? `${i + 1} (${idTotal[i]})` : `${i + 1}`,
                        type: 'line',
                        symbol: 'none',
                        sampling: 'max',
                        alignTicks: true,
                        lineStyle: { width: 1.25 },
                        data: yData,
                        markPoint: { data: markPointData }
                    };
                }
                return null;
            }).filter(item => item !== null)
        };

        myChart_combine.setOption(option);
        myChart_combine.resize({ width: window.innerWidth * 0.8, height: 400 });
    </script>
<?php }else if($path == "combinedata" && $data['chat_mode'] == "6"){?>
        <script>
            var chartData_s = <?php echo json_encode($data); ?>;
            var chat_mode = '<?php echo $data['chat_mode'];?>';
            var idTotal = <?php echo json_encode($data['id_total']); ?>;
            var check_limit_val = '<?php echo $data['check_limit_val'];?>';
            var myChart_combine = echarts.init(document.getElementById('chart_combine'));   
            var threshold_angle_total   = <?php echo isset($data['threshold_angle_total'])  ? json_encode($data['threshold_angle_total']) : '[]'; ?>;
            var threshold_torque_total  = <?php echo isset($data['threshold_torque']) ? json_encode($data['threshold_torque']) : '[]'; ?>;
            var downshift_torque_total  = <?php echo isset($data['downshift_torque']) ? json_encode($data['downshift_torque']) : '[]'; ?>;

            var last_key_threshold_torque = <?php echo isset($data['last_key_threshold_torque']) ? json_encode($data['last_key_threshold_torque']) : '[]'; ?>;
            var last_key_threshold_angle  = <?php echo isset($data['last_key_threshold_angle']) ? json_encode($data['last_key_threshold_angle']) : '[]'; ?>;
            var last_key_downshift_torque = <?php echo isset($data['last_key_downshift_torque']) ? json_encode($data['last_key_downshift_torque']) : '[]'; ?>;


            //顏色選擇
            var colorPalette = getColorPalette();
          

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

            if (last_key_threshold_torque.length > 0) {
                console.log(last_key_threshold_torque); 
                var threshold_torque_array = threshold_torque_total.split(',').map(Number); 
                last_key_threshold_torque.forEach((threshold, index) => {
                    // 確保對應的曲線數據存在
                    if (seriesData[index * 2]) { 
                        var torqueSeries = seriesData[index * 2]; 
                        var torqueData = torqueSeries.data; 
                        var yValue = torqueData[threshold];

                        if (yValue !== undefined) {
                            torqueSeries.markPoint = torqueSeries.markPoint || { data: [] }; 
                            torqueSeries.markPoint.data.push({
                                type: 'max',
                                name: `threshold_torque ${index + 1}`,
                                coord: [threshold, yValue],
                                symbol: 'circle',
                                symbolSize: 6,
                                itemStyle: { color: 'blue' },
                                label: {
                                    show: true,
                                    formatter: `threshold_torque: ${threshold_torque_array[index]}`,
                                    position: 'top'
                                }
                            });
                        }
                    }
                });
            }

            if (last_key_downshift_torque.length > 0) {
                console.log(last_key_downshift_torque); 
                var downshift_torque_array = downshift_torque_total.split(',').map(Number); 
                last_key_downshift_torque.forEach((threshold, index) => {
                    if (seriesData[index * 2]) { 
                        var torqueSeries = seriesData[index * 2]; 
                        var torqueData = torqueSeries.data; 

                        var yValue = torqueData[threshold];

                        if (yValue !== undefined) {
                            torqueSeries.markPoint = torqueSeries.markPoint || { data: [] }; 

                            // 添加標註點
                            torqueSeries.markPoint.data.push({
                                type: 'max',
                                name: `downshift_torque ${index + 1}`,
                                coord: [threshold, yValue],
                                symbol: 'circle',
                                symbolSize: 6,
                                itemStyle: { color: 'green' },
                                label: {
                                    show: true,
                                    formatter: `downshift_torque: ${downshift_torque_array[index]}`,
                                    position: 'top'
                                }
                            });
                        }
                    }
                });
            }




            if (last_key_threshold_angle.length > 0) {
                var threshold_angle_array = threshold_angle_total.split(',').map(Number); 
                console.log(last_key_threshold_angle);

                last_key_threshold_angle.forEach((threshold, index) => {
                    if (seriesData[index * 2 + 1]) { 
                        var angleSeries = seriesData[index * 2 + 1];
                        var angleData = angleSeries.data; 

                        // 查找 yData 中是否包含 threshold 對應的值
                        var yValue = angleData[threshold];

                        if (yValue !== undefined) {
                            angleSeries.markPoint = angleSeries.markPoint || { data: [] }; 
                            angleSeries.markPoint.data.push({
                                type: 'max',
                                name: `threshold_angle ${index + 1}`,
                                coord: [threshold, yValue],
                                symbol: 'circle',
                                symbolSize: 6,
                                itemStyle: { color: 'blue' },
                                label: {
                                    show: true,
                                    formatter: `threshold_angle:${threshold_angle_array[index]}`,
                                    position: 'top'
                                }
                            });
                        }
                    }
                });
            }


                        

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
                    //name: chat_mode == 6 ? 'Angle' : 'Time',
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
                        min: 0,
                        max: overallAngleMax
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

//獲取所有的複選框
const checkboxes = document.querySelectorAll('input[type="checkbox"][name="test1"]');

// 獲取全選按鈕
const toggleButton = document.getElementById('toggle-select-all');

// 獲取 language 
const language = '<?php echo $data['language'];?>';
    
// 根據 language 設定按鈕文字
    function updateButtonText(allChecked) {
        let buttonText = 'Select All';

        // 預設為英文
        if (language == 'zh-cn') {
            buttonText = allChecked ? '取消全选' : '全选';
            // 簡體中文
        } else if (language == 'zh-tw') {
            buttonText = allChecked ? '取消全選' : '全選';
            // 繁體中文
        } else if (language == 'en-us') {
            buttonText = allChecked ? 'Deselect' : 'Select';
            // 英文
        }

        // 確保 toggleButton 是有效的 DOM 元素
        if (toggleButton) {
            toggleButton.innerHTML = buttonText;
        } else {
            //console.error('toggleButton is null or not defined');
        }
    }

// 假設在某處你獲取 toggleButton
//const toggleButton = document.getElementById('your-button-id')

// 點擊按鈕觸發的函數：全選或取消全選
function selectAllCheckboxes() {
    // 獲取所有複選框
    const checkboxes = document.querySelectorAll('input[type="checkbox"][name="test1"]');
    
    // 判斷是否所有複選框都已選中
    const allChecked = Array.from(checkboxes).every(checkbox => checkbox.checked); 
    
    // 強制當所有複選框都沒有被選中時，將所有的複選框設定為選中
    if (!allChecked) {
        checkboxes.forEach(function(checkbox) {
            checkbox.checked = true;  // 強制設置為選中
        });
    } else {
        // 根據當前選中狀態切換全選/取消全選
        checkboxes.forEach(function(checkbox) {
            checkbox.checked = false;  // 如果全部已選中，則取消選中
        });
    }

    // 更新按鈕文字
    updateButtonText(!allChecked);
}

function initButtonText() {
    updateButtonText(false); // 當頁面載入時，默認顯示 'Select All'
}


// 初始化按鈕文字
initButtonText();




</script>