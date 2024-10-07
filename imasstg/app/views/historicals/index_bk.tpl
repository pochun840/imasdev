<?php require APPROOT . 'views/inc/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/historical.css?v=202404111200" type="text/css">

<script src="<?php echo URLROOT; ?>js/flatpickr.js"></script>
<script src="<?php echo URLROOT; ?>js/historical.js?v=202407181100"></script>

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


<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/0.4.18/c3.min.js"></script>


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/c3.min.css?v=202404251500" type="text/css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>




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
                    <span data-content="<?php echo $text['Work_Flow_Log_text']; ?>" onclick="showContent('workflowlog')"></span></span><?php echo $text['Work_Flow_Log_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'useraccess')">
                    <span data-content="<?php echo $text['User_Access_Logging_text']; ?>" onclick="showContent('useraccess')"></span><?php echo $text['User_Access_Logging_text']; ?>
                </div>
            </div>

            <!-- Fastening Setting -->
            <div id="fasteningContent" class="content">
                <div id="FasteningDisplay" style="margin-top: 40px">
                    <div style="padding-left: 2%">
                        <div class="input-group">
                            <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['BarcodeSN_text']; ?>:</span>
                            <input type="text" class="form-control input-ms" id="barcodesn" name="barcodesn" maxlength="">
                            <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['Operator_text']; ?>:</span>
                            <input type="text" class="form-control input-ms" id="barcodesn" name="barcodesn" maxlength="">
                            <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['Select_Job_text']; ?>:</span>
                            <input type="text" class="form-control input-ms"  id="JobSelect" placeholder="Click here.." onfocus="openModal('JobSelect')" onclick="this.blur()">
                            <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['Result_Status_text']; ?>:</span>
                            <select id="status">
                                    <?php foreach($data['res_status_arr'] as $key_res =>$val_res){?>
                                            <option value="<?php echo $key_res;?>"><?php echo $val_res;?></option>
                                    <?php }?>
                            </select>
                        </div>

                        <div class="input-group">
                              <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['From_text']; ?>:</span>
                              <input type="datetime-local" class="t3" id="FromDate" name="FromDate" style="width: 190px;border-radius: 5px;border: 1px solid #CCCCCC; ">
                              <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['To_text']; ?>:</span>
                              <input type="datetime-local" class="t3" id="ToDate" name="ToDate" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;">
                              <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['Controller_text']; ?>:</span>
                              <select id="controller" style="width: 190px;">
                                    <option value = '0'>select</option>
                                    <?php foreach($data['res_controller_arr'] as $key_res_1 =>$val_res_1){?>
                                            <option value="<?php echo $key_res_1;?>"><?php echo $val_res_1;?></option>
                                    <?php }?>
                              </select>
                              <span class="input-group-text" style="margin-right: 5px; border: none; background: none"><?php echo $text['program_text']; ?>:</span>
                               <select id="program" style="width: 190px;">
                                    <option value = '0'>select</option>
                                     <?php foreach($data['res_program'] as $key_res_2 => $val_res_2){?>
                                            <option   value="<?php echo $val_res_2['template_program_id'];?>"><?php echo $val_res_2['template_program_id'];?></option>
                                    <?php }?>
                                </select>
                        </div>
                    </div>

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
                                        <th><i class="fa fa-trash-o" style="font-size:26px;color:black" onclick="deleteinfo()"></i></th>
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
                                        <th><?php echo $text['Pset_text']; ?></th>
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
                                            <td><?php echo $data['res_controller_arr'][$v_info['cc_equipment']];?></td>
                                            <td><?php echo $v_info['step_lowtorque']." ~ ".$v_info['step_hightorque'];?></td>
                                            <td><?php echo $v_info['step_lowangle']." ~ ".$v_info['step_highangle'];?></td>
                                            <td><?php echo $v_info['fasten_torque'].$data['torque_arr'][$v_info['torque_unit']] ;?></td>
                                            <td><?php echo $v_info['fasten_angle'] . " deg";?></td>
                                            <td style="background-color:<?php echo $data['status_arr']['status_color'][$v_info['fasten_status']];?> font-size: 20px"><?php echo $data['status_arr']['status_type'][$v_info['fasten_status']];?></td>
                                            <td><?php echo $data['status_arr']['error_msg'][$v_info['error_message']];?></td>
                                            <td></td>
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
                            <td><?php echo $text['Pset_text']; ?>: </td>
                            <td><?php echo $text['Time_text']; ?>: <?php echo $data['job_info'][0]['data_time'];?></td>
                        </tr>
                        <tr  style="vertical-align: middle;">
                            <td><?php echo $text['Member_text']; ?>: <!--<input class="t6" type="text" size="10" value="Esther" disabled="disabled" style="background-color: #F5F5F5">--></td>
                            <td><?php echo $text['Note_text']; ?>: <!--<input class="t6" type="text" value="arm (444,215)[200]" disabled="disabled" style="background-color: #F5F5F5; width: 15vw"></td>-->
                            <td>
                                <input class="form-check-input" type="checkbox" id="myCheckbox" onchange="check_limit(this)"  <?php if($limit_val=="1"){ echo "checked"; }else{}?>  style="zoom:1.2; float: left">&nbsp; <?php echo $text['Display_lilo_text']; ?>
                            </td>
                            </td>
                        </tr>
                        <tr style="vertical-align: middle">
                            <td>
                                <?php echo $text['Chart_Setting_text']; ?>:  
                                <select id="chartseting" class="t6 Select-All" style="float: none"  onchange="chat_mode_change(this)">
                                    <?php foreach($data['chat_mode_arr'] as $k_chat => $v_chat){?>
                                        <option  value="<?php echo $k_chat;?>"  <?php if($chat_mode_change == $k_chat){echo "selected";}else{echo "";}?>  > <?php echo $v_chat;?> </option>
                                    <?php } ?>                             
                                </select>
                            </td>
                            <td>
                                <?php echo $text['Torque_Unit_text']; ?>:  
                                <select id="Torque-Unit" class="Select-All" style="float: none; width: 100px" onchange="unit_change(this)">
                                    <?php foreach($data['torque_mode_arr'] as $k_torque =>$v_torque){?>
                                            <option  value="<?php echo $k_torque;?>" <?php if($data['unitvalue'] == $k_torque){echo "selected";}else{echo "";}?> > <?php echo $v_torque; ?> </option>
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
                        </tr>
                    </table>

                    <?php if(!empty($data['chart_info'])){?>
                        <div>
                            <div style="text-align: center">
                                <label style="float: left" id='DiagramDisplay'><b><?php echo $text['Diagram_Display_text']; ?></b></label>
                                <label><?php echo $data['chat']['chat_name'];?></label>
                            </div>
                        

                            <div id="chart-setting">
                                <div class="chart-container">
                                    <div class="menu-chart"  id="menu-chart" onclick="toggleMenu()">
                                        <i class="fa fa-bars" style="font-size: 26px"></i>
                                        <div class="menu-content" id="myMenu">
                                            <a  id="downloadchartbtn"><?php echo $text['Download_text']; ?> HTML</a>
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
                                            <option value="<?php echo $k_mode; ?>" <?php if($data['chat_mode'] == $k_mode){ echo "selected";}?>><?php echo $v_mode; ?></option>
                                        <?php } ?>
                                    </select>
                                </label>
                                <label style="padding-left: 5%">
                                    <?php echo $text['Torque_Unit_text']; ?> :
                                        <select id="unit" style="width: 100px" onchange="unit_change_combine(this)" >
                                          <?php foreach($data['torque_mode_arr'] as $k_torque => $v_torque){?>
                                                <option  value="<?php echo $k_torque;?>"  <?php if( $data['unit'] == $k_torque){echo "selected";}else{echo "";}?>  > <?php echo $v_torque;?> </option>
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
                                    <?php foreach( $data['info_final'] as $key =>$val){?>
                                            <div class="w3-half" style="border: 1px solid #A0C0C0; font-size: 16px">
                                                <div class="row t1">
                                                    <div class="col"> <?php echo $text['Index_text']; ?> : <?php echo $val['system_sn'];?></div>
                                                    <div class="col"> <?php echo $text['Job_info_text']; ?> : <?php echo $val['job_name'];?></div>
                                                    <div class="col"> <?php echo $text['Pset_text']; ?> : </div>
                                                </div>
                                                <div class="row t1">
                                                    <div class="col"> <?php echo $text['Time_text']; ?> : <?php echo $val['data_time'];?></div>
                                                    <div class="col"> <?php echo $text['Task_text'].' '.$text['Time_text']; ?> : <?php echo $val['fasten_time'];?> ms </div>
                                                    <div class="col"> <?php echo $text['Status_text']; ?> : <a style="background-color:<?php echo $data['status_arr']['status_color'][$val['fasten_status']];?>"><?php echo $data['status_arr']['status_type'][$val['fasten_status']];?></a></div>
                                                </div>
                                                <div class="row t1">
                                                    <div class="col"> <?php echo $text['BarcodeSN_text']; ?> : <?php echo $val['cc_barcodesn'];?></div>
                                                    <div class="col"> <?php echo $text['Equipment_text']; ?> : </div>
                                                    <div class="col"> <?php echo $text['Actual_Torque_text']; ?> : <?php echo $val['fasten_torque'] ." ".$data['torque_mode_arr'][$val['torque_unit']];?> </div>
                                                </div>
                                                <div class="row t1">
                                                    <div class="col"> <?php echo $text['Error_code_text']; ?> : <?php echo  $data['status_arr']['error_msg'][$val['error_message']];?></div>
                                                </div>
                                             </div>
                                    <?php }?>
                                        <!---圖表1--->
                                        <div id="empty1" style="width: 800px; height:150px;">
                                        <div id="chart-title" style="visibility: hidden;" >曲線圖資料</div>
                                        <div id="chart_combine" style="width: 1500px; height: 400px;"></div>

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
    <div id="modalJobSelect" class="modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" style="top: 150px; width: 710px">
                <span class="close-btn" onclick="closeModal('JobSelect')">&times;</span>
                <div class="modal-column modalselect">
                    <h4>Job</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">

                            <?php foreach($data['job_arr'] as $k_job =>$v_job){?>
                                    <div class="row t1">
                                        <div class="col t5 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="jobid" id="jobid" value="<?php echo $v_job['job_id'];?>" onclick="JobCheckbox()" style="zoom:1.0; vertical-align: middle;">&nbsp;
                                            <label class="form-check-label" for="Job-1"><?php echo $v_job['job_name'];?></label>
                                        </div>
                                    </div>

                            <?php }?>
                        </div>
                    </div>
                </div>
                <div class="modal-column modalselect">
                    <h4>Sequence</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <div id="Seq-list" style="display: none">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-column modalselect">
                    <h4>Task</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <div id="Task-list" style="display: none">
                              
                            </div>
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

    var min_val = <?php echo  $data['chart_info']['min'];?>;
    var max_val = <?php echo  $data['chart_info']['max'];?>;

    var x_title = '<?php echo $data['chart_info']['x_title'];?>';
    var y_title = '<?php echo $data['chart_info']['y_title'];?>';
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
                boundaryGap: false,
                name: x_title,
                data: x_data_val
            },
            yAxis: {
                type: 'value',
                name: y_title,
                boundaryGap: [0, '100%']
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
    if (limit_val == 1) {
        option.series[0].markLine = {
            data: [
                {yAxis: min_val, name: '',label: {position: 'middle',formatter: 'low torque'}}, 
                {yAxis: max_val, name: '',label: {position: 'middle',formatter: 'high torque'}}  
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

    var max_val = <?php echo $data['chart_info']['max']; ?>; // Y軸1的上限
    var min_val = <?php echo $data['chart_info']['min']; ?>; // Y軸1的下限

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
                max: max_val
            },
            {
                type: 'value',
                name: 'Angle',
                min: min_val_1,
                max: max_val_1
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
                    { yAxis: max_val,name: '',label: {position: 'middle',formatter: 'high torque'}, lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                    { yAxis: min_val_1, name: '',label: {position: 'middle',formatter: 'low angle'}, lineStyle: { type: 'dashed', color: 'rgb(44,55,82)'  } },
                    { yAxis: max_val_1, name: '',label: {position: 'middle',formatter: 'high angle'}, lineStyle: { type: 'dashed', color: 'rgb(44,55,82)'  } }       
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
        var myChart_combine = echarts.init(document.getElementById('chart_combine'));

        //圖表1的資訊
        var x_data_val   = <?php echo  $data['chart1_xcoordinate']; ?>;
        var y_data_val  = <?php echo  $data['chart1_ycoordinate']; ?>;
        var min_val = <?php echo $data['chart1_ycoordinate_min'];?>;
        var max_val = <?php echo $data['chart1_ycoordinate_max'];?>;

        var job_info ='<?php echo $data['info_final'][0]['system_sn'];?>';

        //圖表2的資訊
        var x_data_val_1 = <?php echo  $data['chart2_xcoordinate']; ?>;
        var y_data_val_1 = <?php echo  $data['chart2_ycoordinate']; ?>;
        var min_val_1 = <?php echo $data['chart2_ycoordinate_min'];?>;
        var max_val_1 = <?php echo $data['chart2_ycoordinate_max'];?>;


        var xtitle = '<?php echo $data['chart_combine']['x_title'];?>';
        var ytitle = '<?php echo $data['chart_combine']['y_title'];?>';


        var job_info_1 ='<?php echo $data['info_final'][1]['system_sn'];?>';
        
        var option = {
              tooltip: {
                trigger: 'axis',
                position: function (pt) {
                    return [pt[0], '10%'];
                },
                formatter: generateTooltipContent 

            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                name: xtitle,
                data: x_data_val
            },

            yAxis: {
                type: 'value',
                name: ytitle,
                boundaryGap: [0, '100%']
            },
            dataZoom: generateDataZoom(),//曲線圖的縮放設置
            series: [
                {
                    name: job_info, 
                    type: 'line',
                    symbol: 'none',
                    sampling: 'average',
                    itemStyle: {
                        normal: {
                            color: 'rgb(255, 0, 0)' 
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 0, [{
                                offset: 0,
                                color: 'rgb(255,255,255)'
                            }, {
                                offset: 1,
                                color: 'rgb(255,255,255)'
                            }])
                        }
                    },
                    lineStyle: {width: 0.75},
                    data: y_data_val 
                },
                {
                    name: job_info_1, 
                    type: 'line',
                    symbol: 'none',
                    sampling: 'average',
                    itemStyle: {
                        normal: {
                            color: 'rgb(44,55,82)' 
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 0, [{
                                offset: 0,
                                color: 'rgb(255,255,255)'
                            }, {
                                offset: 1,
                                color: 'rgb(255,255,255)'
                            }])
                        }
                    },
                    lineStyle: {width: 0.75},
                    data: y_data_val_1 
                }
            ]
        };


    if (limit_val == 1) {
        option.series.push({
            type: 'line',
            markLine: {
                symbol: 'none',
                data: [
                    { yAxis: min_val, name: '',label: {position: 'middle',formatter: 'low torque'},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }, 
                    { yAxis: max_val, name: '',label: {position: 'middle',formatter: 'high torque'},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                    { yAxis: min_val_1, name: '',label: {position: 'middle',formatter: 'low torque'},lineStyle: { type: 'dashed', color: 'rgb(44,55,82)'  } },
                    { yAxis: max_val_1, name: '',label: {position: 'middle',formatter: 'high torque'},lineStyle: { type: 'dashed', color: 'rgb(44,55,82)'  } }    
                    
                ]   
                
            }
        });
    }

    myChart_combine.setOption(option);
    myChart_combine.resize({
      width: window.innerWidth*0.8,
      height: 400,
    });


</script>
<?php }else if($path == "combinedata" && $data['chat_mode'] == "6"){?>
<script>

    //圖表1的資訊
    var x_data_val         = <?php echo  $data['chart1_xcoordinate']; ?>;
    var y_data_val         = <?php echo  $data['chart1_ycoordinate']; ?>;
    var y_data_val_angle   = <?php echo  $data['chart1_ycoordinate_angle']; ?>;
    var min_val = <?php echo $data['chart1_ycoordinate_min'];?>;
    var max_val = <?php echo $data['chart1_ycoordinate_max'];?>;
    var min_val_angle = <?php echo $data['chart1_ycoordinate_min_angle'];?>;
    var max_val_angle = <?php echo $data['chart1_ycoordinate_max_angle'];?>;

    //圖表2的資訊
    var x_data_val_1 = <?php echo  $data['chart2_xcoordinate']; ?>;
    var y_data_val_1 = <?php echo  $data['chart2_ycoordinate']; ?>;
    var y_data_val_1_angle = <?php echo  $data['chart2_ycoordinate_angle']; ?>;
    var min_val_1 = <?php echo $data['chart2_ycoordinate_min'];?>;
    var max_val_1 = <?php echo $data['chart2_ycoordinate_max'];?>;

    var min_val_1_angle = <?php echo $data['chart2_ycoordinate_min_angle'];?>;
    var max_val_1_angle = <?php echo $data['chart2_ycoordinate_max_angle'];?>;


    var job1 = '<?php echo $data['info_final'][0]['system_sn'];?>';
    var job2 = '<?php echo $data['info_final'][1]['system_sn'];?>';

    var myChart_combine = echarts.init(document.getElementById('chart_combine'));
    var option = {
    tooltip: {
        trigger: 'axis',
        position: function (pt) {
            return [pt[0], '10%'];
        },
        formatter: generateTooltipContent 
    },
    xAxis: {
        type: 'category',
        boundaryGap: false,
        name: 'Time(Ms)', 
        nameLocation: 'end', 
        nameGap: 30, 
        data: <?php echo $data['chart1_xcoordinate']; ?>
    },
    yAxis: [
        {
            type: 'value',
            name: 'Torque',
            position: 'left',
            boundaryGap: [0, '100%']
        },
        {
            type: 'value',
            name: 'Angle',
            position: 'right',
            boundaryGap: [0, '100%']
        }
    ],
    dataZoom: generateDataZoom(),//曲線圖的縮放設置
    series: [
        {
            name: job1 + '_torque',
            type: 'line',
            yAxisIndex: 0, 
            symbol: 'none',
            sampling: 'average',
            itemStyle: {
                normal: {
                    color: 'rgb(255, 0, 0)' 
                }
            },
            data: <?php echo $data['chart1_ycoordinate']; ?>
        },
        {
            name: job2 + '_torque',
            type: 'line',
            yAxisIndex: 0, 
            symbol: 'none',
            sampling: 'average',
            itemStyle: {
                normal: {
                    color: 'rgb(44,55,82)'
                }
            },
            data: <?php echo $data['chart2_ycoordinate']; ?>
        },
        {
            name: job1 + '_angle',
            type: 'line',
            yAxisIndex: 1, 
            symbol: 'none',
            sampling: 'average',
            itemStyle: {
                normal: {
                    color: 'rgb(255, 0, 0)' 
                }
            },
            data: <?php echo $data['chart1_ycoordinate_angle']; ?>
        },
        {
            name: job2 + '_angle',
            type: 'line',
            yAxisIndex: 1, 
            symbol: 'none',
            sampling: 'average',
             itemStyle: {
                normal: {
                    color: 'rgb(44,55,82)' 
                }
            },
            data: <?php echo $data['chart2_ycoordinate_angle']; ?>
        }
    ]
};

if (limit_val == 1) {
    option.series.push({
        type: 'line',
        markLine: {
            symbol: 'none',
            data: [
                { yAxis: min_val, name: '',label: {position: 'middle',formatter: 'low torque'},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }, 
                { yAxis: max_val, name: '',label: {position: 'middle',formatter: 'high torque'},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                { yAxis: min_val_1, name: '',label: {position: 'middle',formatter: 'low torque'},lineStyle: { type: 'dashed', color: 'rgb(44,55,82)'  } },
                { yAxis: max_val_1, name: '',label: {position: 'middle',formatter: 'high torque'},lineStyle: { type: 'dashed', color: 'rgb(44,55,82)'  } },
                { yAxis: min_val_angle, name: '',label: {position: 'middle',formatter: ''},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } }, 
                { yAxis: max_val_angle, name: '',label: {position: 'middle',formatter: ''},lineStyle: { type: 'dashed', color: 'rgb(255, 0, 0)' } },
                { yAxis: min_val_1_angle, name: '',label: {position: 'middle',formatter: ''},lineStyle: { type: 'dashed', color: 'rgb(44,55,82)' } }, 
                { yAxis: max_val_1_angle, name: '',label: {position: 'middle',formatter: ''},lineStyle: { type: 'dashed', color: 'rgb(44,55,82)' } }        
                
            ]   
            
        }
    });
}
myChart_combine.setOption(option);
myChart_combine.resize({
      width: window.innerWidth*0.8,
      height: 400,
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

</script>