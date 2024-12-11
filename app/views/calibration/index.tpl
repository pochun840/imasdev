<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="/img/cc_icon.png" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="60x60" href="../public/img/cc_icon.png">
    <link rel="icon" sizes="192x192" href="../public/img/cc_icon.png">

    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="theme-color" content="#000000">



    <script src="js/jquery-3.7.1.min.js"></script>
    <script src="js/sweetalert2.js"></script>
    <script src="js/moment.min.js"></script>

    <link rel="stylesheet" href="css/w3.css" type="text/css">
    <link rel="stylesheet" href="css/nav.css" type="text/css">
    <link rel="stylesheet" href="css/datatables.min.css">
    
    <script src="js/echarts.min.js"></script>
    <script src="js/jszip.min.js"></script>
    <script src="js/FileSaver.min.js"></script>
    <link rel="stylesheet" type="text/css" href="css/calibration.css">
    <script src="js/calibrations.js?v=202412031500"></script>
    <script src="js/html2canvas_min.js?v=202412031700"></script>
    
    <title><?php echo SITENAME; ?></title>

    
</head>
<body>

<?php echo $data['nav']; ?>

<div class="container-ms">

    <header>
        <div class="calibration">
            <img id="header-img" src="./img/calibration-head.svg"><?php echo $text['main_calibration_text'];?>
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

    <div id="Torque-Collection">
        <div class="topnav">
            <label type="text" style="font-size: 24px; margin-bottom: 4px; padding-left: 10px"><?php echo $text['Calibrations_title_text'];?></label>
        </div>

        <div class="main-content">
            <div class="center-content">
                <div class="container-main">
                    <div class="row t1">
                        <div class="col-4 t1" style="padding-left: 7%; font-size: 18px"><?php echo $text['Choose_ktm_text'];?> :</div>
                        <div class="custom-select">
                            <select id="TorqueMeter">
                                <?php foreach($data['res_Torquemeter_arr'] as $k_t => $v_t){?>
                                    <option value="<?php echo $k_t;?>"><?php echo $v_t;?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>

                    <div class="row t1">
                        <div class="col-4 t1" style="padding-left: 7%; font-size: 18px"><?php echo $text['Choose_Controller_text'];?> :</div>
                        <div class="custom-select">
                            <select id="controller_info">
                                 <?php foreach($data['res_controller_arr'] as $k_c =>$v_c){?>
                                    <option value="<?php echo $k_c;?>"><?php echo $v_c;?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>

                    <button class="nextButton" id="nextButton" onclick="NextToAnalysisSystemKTM()"><?php echo $text['Next_text'];?></button>
                </div>
            </div>
        </div>
    </div>

    <div id="analysis-system-KTM" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 24px; margin-bottom: 0px; padding-left: 10px"><?php echo $text['Calibrations_title_text'];?></label>
            <div class="topnav-right">
                <button class="btn" id="back-btn" type="button" onclick="backSetting()">
                    <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
                </button>
                
                <button class="btn" id="export-report" type="button" onclick="openModal('Export_Report')"><?php echo $text['Export_text'];?></button>
                <button class="btn" id="export-excel" type="button" onclick="window.open('?url=Calibrations/export_excel', '_blank');"><?php echo $text['Export_Report_text'];?></button>
                <button class="btn" id="export-report" type="button" onclick="undo()"><?php echo $text['Undo_text'];?></button>
       
            </div>
        </div>

        <div class="container-fluid" id="container-fluid" >
            <!-- Left -->
            <div class="column column-left">
                <!--<div class="row t1" style=" padding-left: 45%">
                    <button id="call-job" type="button" class="btn-calljob" style="font-size: 18px; color: #000;"  onclick="calljoball()" ><?php echo $text['Call_Job_text'];?></button>
                </div>-->
                <div class="border-bottom">
                   
                    <div class="row t1">
                        <div class="col-5 t1" style="padding-left: 2%; color: #000"><?php echo $text['Tool_SN_text'];?>:</div>
                        <div class="col-4 t1">
                            <input id="tool-sn" type="text" class="t2 form-control" value="<?php echo $data['tools_sn'];?>">
                        </div>
                    </div>
                    <div class="row t1">
                       <div class="col-5 t1" style="padding-left: 2%; color: #000"><?php echo $text['Adapter_type_text'];?>:</div>
                        <div class="col-4 t1">
                            <input id="adapter_type" type="text" class="t2 form-control" value="">
                        </div>
                    </div>
                </div>

                <div class="w3-center" style="font-size: 18px; color: #000"><?php echo $text['Instant_data_setting_text'];?></div>
                <div class="border-bottom">
                    
                    <div class="row t1" style="padding-left: 3%">
                        <div class="col t1 form-check form-check-inline">
                        
                            <input class="t1 form-check-input" type="checkbox" name="skip_turn_rev" id="skip_turn_rev"  style="zoom:1.0; vertical-align: middle;"> 
                            
                            <label class="t1 form-check-label" for="skip_turn_rev"><?php echo $text['Skip_Turn_Rev_text'];?></label>
                        </div>
                    </div>
                    <div class="row t1" style="padding-left: 1%">
                       <div class="col-5 t1"><?php echo $text['Count_text'];?>:</div>
                        <div class="col-4 t1">
                            <input id="implement_count" type="text" class="t2 form-control" value=""  >
                        </div>
                    </div>
                </div>

                <div class="w3-center" style="font-size: 18px; color: #000">CM/CMK Bar</div>
             

                <div class="row t1">
                    <div class="col-7 t1"><b><?php echo $text['Target_Torque_text'];?></b></div>
                    <div class="col-4 t1">
                        <input id="current_tarque" type="text" class="t2 form-control">
                    </div>
                </div>

                <div class="row t1">
                    <div class="col-7 t1"><b><?php echo $text['Tolerance_text'];?>(+/- %)</b></div>
                    <div class="col-4 t1">
                        <input id="tolerance" type="text" class="t2 form-control" value="">
                    </div>
                </div>

                <div class="row t1">
                    <div class="col-7 t1"><b><?php echo $text['Joint_Offset_text'];?></b></div>
                    <div class="col-4 t1">
                        <input id="current_offset" type="text" class="t2 form-control" value="">
                    </div>
                </div>

                <div class="row t1">
                    <div class="col-7 t1"><b><?php echo $text['RPM_text'];?></b></div>
                    <div class="col-4 t1">
                        <input id="current_rpm" type="text" class="t2 form-control" value="">
                    </div>
                </div>

                <div class="row t1" style="display: flex; justify-content: flex-end; margin-top: 15px;">
                    <button class="btn" id="export-report" type="button" onclick="current_save()"><?php echo $text['Save_text'];?></button>
                </div>




              
            
            </div>


            <!-- Right -->
            <div class="column column-right">
                
                <div id="table-setting">
                    <div class="scrollbar-table" id="style-table">
                        <div class="force-overflow-table">
                            <table class="table table-bordered table-hover" id="table">
                                <thead id="header-table" style="text-align: center; vertical-align: middle">
                                    <tr>
                                        <th><?php echo $text['Index_text'];?></th>
                                        <th><?php echo $text['Time_text'];?></th>
                                        <th><?php echo $text['Operator_text'];?></th>
                                        <th><?php echo $text['Tool_SN_text'];?></th>
                                        <th><?php echo $text['Torque_text'];?></th>
                                        <th><?php echo $text['Final_Torque_text']."Controller";?></th>
                                        <th><?php echo $text['Unit_text'];?></th>
                                        <th><?php echo $text['Max_Torque_text'];?></th>
                                        <th><?php echo $text['Min_Torque_text'];?></th>
                                        <th><?php echo $text['Avg_Torque_text'];?></th>
                                        <th>+ %</th>
                                        <th>- %</th>
                                        <th><?php echo $text['Customize_text'];?></th>
                                    </tr>
                                </thead>

                                <tbody style="background-color:#F5F5F5;" id="info_toal">
                                    <?php if (!empty($data['info'])){?>
                                        <?php foreach($data['info'] as $key => $val){?>
                                            <tr data-id="<?php echo $val['id']; ?>" >
                                                <td><?php echo $val['id']; ?></td>
                                                <td><?php echo $val['datatime']; ?></td>
                                                <td><?php echo $val['operator']; ?></td>
                                                <td><?php echo $val['toolsn']; ?></td>
                                                <td><?php echo $val['torque']; ?></td>
                                                <td><?php echo $val['fasten_torque']; ?></td>
                                                <td><?php echo "N.m"; ?></td>
                                                <td><?php echo $val['max_torque']; ?></td>
                                                <td><?php echo $val['min_torque']; ?></td>
                                                <td><?php echo $val['avg_torque']; ?></td>
                                                <td><?php echo $val['high_percent'] . " % "; ?></td>
                                                <td><?php echo $val['low_percent'] . " % "; ?></td>
                                                <td><?php echo $val['customize']; ?></td>
                                            </tr>
                                        <?php } ?>
                                   <?php } ?> 
                                </tbody>

                            </table>
                        </div>
                    </div>
                </div>

                <div id="chart-setting">
                    <div class="column column-chart">
                        <div class="chart-container" id='chart_block' style="display:block;">
                            <!---曲線圖---->
                            <div  id="mychart" width="800px" height="600px"></div>
                        </div>
                    </div>

                    <div class="column column-meter-model">
                        <div class="meter-model" id='item_data' style="display:block;">
                            <div class="row t1 border-bottom">
                                <div class="col-5" style=" padding-left: 5%; color: #000"><b><?php echo $text['Item_text'];?></b></div>
                                <div class="col-5" style=" padding-left: 5%; color: #000"><b><?php echo $text['Meter_text'];?></b></div>
                            </div>

                            <div class="scrollbar-meter" id="style-meter">
                                <div class="force-overflow-meter">
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Item_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="item" type="text" class="t2 form-control" value="<?php echo $data['current_torquemeter'].'(N.m)';?>">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Target_Torque_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="target-torque" type="text" class="t2 form-control" value="">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Bias_text'];?> (+/-%):</div>
                                        <div class="col-5 t1">
                                            <input id="bias" type="text" class="t2 form-control" value="">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Hi_Q_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="high-limit-torque" type="text" class="t2 form-control" value="">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Lo_Q_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="low-limit-torque" type="text" class="t2 form-control" value=" ">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Max_Torque_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="max-torque" type="text" class="t2 form-control" value="<?php echo !empty($data['meter']['max-torque']) ? $data['meter']['max-torque'] : ''; ?>">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Min_Torque_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="min-torque" type="text" class="t2 form-control" value="<?php echo !empty($data['meter']['min-torque']) ? $data['meter']['min-torque'] : ''; ?>">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Avg_Torque_text'];?></div>
                                        <div class="col-5 t1">
                                            <input id="avg-torque" type="text" class="t2 form-control" value="<?php echo $data['avg_torque']; ?> ">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $text['Standard_Deviation_text'];?>:</div>
                                        <div class="col-5 t1">
                                            <input id="standard-deviation" type="text" class="t2 form-control" value="<?php echo !empty($data['meter']['stddev1']) ? $data['meter']['stddev1'] : ''; ?>">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000">CM:</div>
                                        <div class="col-5 t1">
                                             <input id="cm" type="text" class="t2 form-control" value="<?php echo !empty($data['meter']['cm']) ? $data['meter']['cm'] : ''; ?>">
                                        </div>
                                    </div>
                                    <div class="row t1">
                                        <div class="col-5 t1" style=" padding-left: 5%; color: #000">CMK:</div>
                                        <div class="col-5 t1">
                                            <input id="cmk" type="text" class="t2 form-control" value="<?php echo isset($data['meter']['cmk']) ? $data['meter']['cmk'] : ''; ?>">

                                        </div>
                                    </div>
                                    <div id="input-container">
                                    <?php for($i=1; $i<= $data['count']; $i++){?>
                                        <div class="row t1">
                                            <div class="col-5 t1" style=" padding-left: 5%; color: #000"><?php echo $i;?>:</div>
                                            <div class="col-5 t1">
                                                <input data-id="<?php echo $i;?>" type="text" class="t2 form-control" value="<?php echo $data['meter']['res_total'][$i-1]['torque'];?>">
                                            </div>
                                        </div>
                                    <?php } ?>
                                    </div>
                                   
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Export Modal -->

   

    <!-- Modal Export Chart -->
    <div id="Export_Chart" class="modal" style="top: 10%" >
        <div class="modal-dialog modal-lg">
            <div class="modal-content w3-animate-zoom">
                <h4>Export Chart</h4>
                <div class="row t1">
                    <div class="col-3 t1" for="fileName2">file name:</div>
                    <div class="col-6 t1">
                        <input id="fileName2" type="text" class="t1 form-control" value="">
                    </div>
                </div>
                <div class="row t1">
                    <div class="col-3 t1" for="Save-as2">Save as type:</div>
                    <div class="col t1">
                        <select id="Save-as2" style="width: 184px; height: 30px">
                            <option value="png">png</option>
                            <option value="jpg">jpg</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer justify-content-center">
                    <button id="ExportChart" class="style-button" onclick="pic_download()"><?php echo $text['Export_text'];?></button>
                    <button class="style-button" onclick="closeModal('Export_Chart')">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Export Report -->
    <div id="Export_Report" class="modal" style="top: 10%;">
        <div class="modal-dialog modal-lg">
            <div class="modal-content w3-animate-zoom">
                <h4><?php echo $text['Export_Report_text'];?></h4>
                <div class="row t1">
                    <div class="col-3 t1" for="fileName3"><?php echo $text['file_name_text'];?>:</div>
                    <div class="col-6 t1">
                        <input id="fileName3" type="text" class="t1 form-control" value="">
                    </div>
                </div>
                <div class="row t1">
                    <div class="col-3 t1" for="Save-as3"><?php echo $text['Type_text'];?>:</div>
                    <div class="col t1">
                        <select id="Save-as3" style="width: 184px; height: 30px">
                            <option value="xml">xml</option>
                            <option value="csv">excel</option>
                            <option value="jpg">jpg</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer justify-content-center">
                    <button id="Exportreport" class="style-button" onclick="html_download()"><?php echo $text['Export_text'];?></button>
                    <button class="style-button" onclick="closeModal('Export_Report')"><?php echo $text['Cancel_text'];?></button>
                </div>
            </div>
        </div>
    </div>

       
  

<script>
let lastData = null; 
var myChart; 
$(document).ready(function() {
    fetchLatestInfo();
    setInterval(fetchLatestInfo, 1000); // 每 1 秒更新
   
});

// Open modal
function openModal(modalId)
{
    document.getElementById(modalId).style.display = "flex";
}

// Close modal
function closeModal(modalId)
{
    document.getElementById(modalId).style.display = "none";
}

function exportCSV(modalId)
{

    var fileName = document.getElementById("fileName" + modalId[5]).value;
    var pageSize = document.getElementById("pageSize" + modalId[5]).value;


    closeModal(modalId);
}


function NextToAnalysisSystemKTM() {

    // 紀錄ktm及controller型號
    const torqueMeter = document.getElementById('TorqueMeter').value;
    const controller = document.getElementById('controller_info').value;

    
    $.ajax({
        url: '?url=Calibrations/saveSessionData', 
        method: 'POST',
        data: {
            torqueMeter: torqueMeter,
            controller: controller
        },
        dataType: 'json',
        success: function(data) {
            if (data.success) {
               
                window.location.reload();
                document.getElementById('analysis-system-KTM').style.display = 'block';
                document.getElementById('Torque-Collection').style.display = 'none';
            } else {
                console.error(data.message);
                // 处理错误情况
                //alert(data.message);
            }
        },
        error: function(xhr, status, error) {
            //console.error('Error saving session data:', error);
            //alert('请求失败，请稍后重试。');
        }
    });


    const details = [
        'KTM-6',
        'KTM-150',
        'KTM-250',
    ];

    // 显示分析系统KTM
    document.getElementById('analysis-system-KTM').style.display = 'block';
    // 隐藏Torque-Collection
    document.getElementById('Torque-Collection').style.display = 'none';
    document.getElementById('item').value = details[torqueMeter] + '(N.m)';

    //移除localstorage
    clearlocalstorage_keys();

    

}

function backSetting()
{
    var TorqueCollection = document.getElementById('Torque-Collection');
    var analysisSystemKTM = document.getElementById('analysis-system-KTM');

    // Check the current state and toggle accordingly
    if (analysisSystemKTM.style.display === 'block') {
        // If RoleEditSetting is currently displayed, switch to AddRoleSetting
        TorqueCollection.style.display = 'block';
        analysisSystemKTM.style.display = 'none';
    } else {
        // If AddRoleSetting is currently displayed or both are hidden, do nothing or handle it as needed
    }
}


function toggleMenu()
{
    var menuContent = document.getElementById("myMenu");
    menuContent.style.display = (menuContent.style.display === "block") ? "none" : "block";
}


$(document).ready(function () {
        highlight_row('info_toal');
});


function highlight_row(tableId) {
    var table = document.getElementById(tableId);
    
    //定義語言訊息
    var messages = {
        'zh-tw': '您確定要刪除 ID 為: ',
        'zh-cn': '您确定要删除 ID 为: ',
        'en-us': 'Are you sure you want to delete the item with ID: '
    };

    var userLanguage = '<?php echo $_SESSION["language"]; ?>'; 
    var confirmMessagePrefix = messages[userLanguage] || messages['en-us']; 

    table.onclick = function (event) {
        var target = event.target.closest('tr'); 

        if (target) {
            // 清除所有tr的狀態
            var rows = table.getElementsByTagName('tr');
            Array.from(rows).forEach(function(row) {
                row.classList.remove('selected');
            });

            //當前被選取 tr 增加狀態
            target.classList.add('selected');

            //當前被選取的data-id
            var selectedId = target.getAttribute('data-id');

            console.log('Selected ID:', selectedId);

            //出現彈跳視窗
            if (confirm(confirmMessagePrefix + selectedId + '?')) {
                console.log('Deleting item with ID:', selectedId);

                deleteRow(selectedId); 
            } else {
                console.log('Deletion canceled.');
            }
        }
    }
}


function deleteRow(selectedId) {
    $.ajax({
        url: '?url=Calibrations/del_info', 
        method: 'POST',
        data: { chicked_id: selectedId }, 
        success: function(response) {
            // 处理成功响应
            console.log('Row with ID ' + selectedId + ' has been deleted.');
            console.log('Server response:', response);
            if (response.success) {
                //alert(response.message); 
                window.location.reload();

            } else {
                //alert(response.message); 
            }
        },
        error: function(xhr, status, error) {
            console.error('Error deleting row:', error);
        }
    });
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

function closeModal_job() {
    document.getElementById("get_joball").style.display = "none";

}

function selectSingle(checkbox) {
    const checkboxes = document.querySelectorAll('input[name="jobid"]');

    checkboxes.forEach((item) => {
        if (item !== checkbox) {
            item.checked = false; // 取消其他复选框的选中状态
        }
    });
}

function updateCookie(name, value, days) {
    let expires = "";
    if (days) {
        const date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
}

function current_save() {
    
    let targetQ = document.getElementById('current_tarque').value;
    const rpm = document.getElementById('current_rpm').value;
    const offset = document.getElementById('current_offset').value;
    const tolerance = document.getElementById('tolerance').value;
    const implement_count = document.getElementById('implement_count').value;
    const skip_turn_rev = document.getElementById('skip_turn_rev').checked;

    const adapter_type = document.getElementById('adapter_type').value;
    let new_skip;

    if (skip_turn_rev) {
        new_skip = 1; // 如果被選中，顯示 1
    } else {
        new_skip = 'no';  // 如果沒有被選中，顯示 0
    }


    localStorage.setItem('rpm', rpm);
    localStorage.setItem('offset', offset);
    localStorage.setItem('implement_count', implement_count);
    localStorage.setItem('new_skip', new_skip);
    localStorage.setItem('adapter_type',adapter_type);
    setCookie('implement_count', implement_count, 7);
    setCookie('new_skip', new_skip, 7);


    let percentage = tolerance / 100; 
    let temp = targetQ  * percentage ;
    let upper_limit = (Number(targetQ) + Number(temp)).toFixed(2);
    let lower_limit = (Number(targetQ) - Number(temp)).toFixed(2); 

    const data = {
        target_q: targetQ,  //目標扭力
        rpm: rpm,           // 轉速
        joint_offset: offset, //扭力補償值
        tolerance: tolerance  //誤差範圍
    };

   $.ajax({
        url: "?url=Calibrations/current_save", 
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(response) {
          
            document.getElementById('target-torque').value = targetQ;
            document.getElementById('high-limit-torque').value = upper_limit;
            document.getElementById('low-limit-torque').value = lower_limit;
            document.getElementById('bias').value = tolerance;

            // 存入 localStorage
            localStorage.setItem('targetTorque', targetQ);
            localStorage.setItem('highLimitTorque', upper_limit);
            localStorage.setItem('lowLimitTorque', lower_limit);
            localStorage.setItem('bias', tolerance);
            localStorage.setItem('implement_count',implement_count);
            localStorage.setItem('adapter_type',adapter_type);
            alert('saved');

        },
        error: function(xhr, status, error) {
            //alert('保存失敗：' + error);
            console.error('Error:', error);
        }
    });
}

function undo() {
    var language = '<?php echo $data['language']?>';

    var confirmMessage = '';
    if (language === 'zh-tw') {
        confirmMessage = "確定要刪除全部的資料?";
    } else if (language === 'zh-cn') {
        confirmMessage = "确定要删除全部的资料?";
    } else if (language === 'en-us') {
        confirmMessage = "Are you sure you want to delete all the data?";
    } else {
        confirmMessage = "Are you sure you want to delete all the data?"; // 默認為英文
    }

    // 問題用戶是否確認執行
    var userConfirmed = confirm(confirmMessage);
    
    // 如果用戶點選「確定」，則執行撤銷邏輯
    if (userConfirmed) {
        var status_val = '0';
        
        $.ajax({
            type: "POST",
            data: {
                status_val: status_val
            },
            url: '?url=Calibrations/del_all',
            success: function(response) {
                // 顯示 'analysis-system-KTM' 並隱藏 'Torque-Collection'
                document.getElementById('analysis-system-KTM').style.display = 'block';
                document.getElementById('Torque-Collection').style.display = 'none';

                // 1. 將 final_count 設定為 0
                var final_count = 0;
                
                // 2. 移除 localStorage 中的 implement_count
                localStorage.removeItem('implement_count');
            },
            error: function(error) {
                // 處理錯誤（如果需要）
            }
        }).fail(function () {
            // 處理 AJAX 請求失敗（如果需要）
        });
    } else {
        // 如果用戶點選「取消」，則什麼也不做，或可紀錄取消操作
        console.log("error");
    }
}


let final_count = 0; // 新增 final_count 計數器
let intervalId; 
let implementCount = localStorage.getItem('implement_count');
implementCount = Number(implementCount); 

async function fetchData() {
    const url1 = '?url=Calibrations/get_val';
    
    try {
        const response1 = await fetch(url1, {
            method: 'GET', 
        });

        if (response1.ok) {
            const textResponse = await response1.text(); 
            
            if (textResponse.trim()) {
                try {
                    const data = JSON.parse(textResponse);
                    console.log('API 回應:', data);
                    
                    // 檢查回應的 message 是否是 '數據整理成功'
                    if (data.success && data.message === '數據整理成功') {
                        final_count += 1; // 如果匹配，則 final_count 自增 1
                        console.log('final_count 更新為:', final_count);
                        console.log('localStorage 為:', implementCount);

                        
                    }

                } catch (jsonError) {
                    // 處理 JSON 解析錯誤
                    console.error('無法解析回應為 JSON:', jsonError);
                }
            }
        } else {
            console.error('請求失敗，狀態碼:', response1.status);
        }
    } catch (error) {
        console.error('發生錯誤:', error);
    }
}

// 每 0.3 秒調用一次 fetchData
intervalId = setInterval(function() {
    fetchData();
    // 判斷 implementCount 是否有值且不為空，並檢查是否達到次數上限
    
    /*console.log("final_count:", final_count, "Type:", typeof final_count);
    console.log("implementCount:", implementCount, "Type:", typeof implementCount);
    if( final_count == implementCount){
        alert('已達到次數的上限');
        clearInterval(intervalId); 
        return;
    }*/


}, 300);


function fetchLatestInfo() {
    $.ajax({
        url: '?url=Calibrations/get_latest_info', 
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            // 更新表格
            updateTable(data.info);
            
            // 更新曲線圖
            if (data.echart_data && data.echart_data.x_val && data.echart_data.y_val_torque_1 && data.echart_data.y_val_torque_2) {

                var x_val = convertToNumberArray(data.echart_data.x_val);
                var y_val_torque_1 = convertToNumberArray(data.echart_data.y_val_torque_1);
                var y_val_torque_2 = convertToNumberArray(data.echart_data.y_val_torque_2);

                renderChart(x_val,y_val_torque_1,y_val_torque_2);
            } else {
                console.log('No echart data available.');
            }

            //更新右邊的扭力值(total)
            updateInputs(data.meter); 
            console.log(data.meter);

            //更新最大和最小扭力值
             if (data.meter['max-torque'] && data.meter['max-torque'].torque) {
                $('#max-torque').val(data.meter['max-torque'].torque); // 取得 max-torque 的值
            }

            if (data.meter['min-torque'] && data.meter['min-torque'].torque) {
                $('#min-torque').val(data.meter['min-torque'].torque); // 取得 min-torque 的值
            }


            //更新扭力平均值//avg_torque
            document.getElementById('avg-torque').value = data.avg_torque;

        },
        error: function() {
            console.log('Error loading data');
        }
    });
}


function updateTable(data) {
    let tbody = $('#info_toal'); 
    tbody.empty(); 

    if (data.length > 0) {
        data.forEach(function(val) {
            tbody.append(`<tr data-id="${val.id}">
                <td>${val.id}</td>
                <td>${val.datatime}</td>
                <td>${val.operator}</td>
                <td>${val.toolsn}</td>
                <td>${val.torque}</td>
                 <td>${val.fasten_torque}</td>
                <td>N.m</td>
                <td>${val.max_torque}</td>
                <td>${val.min_torque}</td>
                <td>${val.avg_torque}</td>
                <td>${val.high_percent} %</td>
                <td>${val.low_percent} %</td>
                <td>${val.customize}</td>
            </tr>`);
        });
    } else {
        tbody.append('<tr><td colspan="12" style="text-align: center;">No data available.</td></tr>');
    }
}


function updateInputs(meterData) {
    const container = document.getElementById('input-container'); 
    container.innerHTML = ''; 

    for (let i = 0; i < meterData.torque.length; i++) {
        const torqueValue = meterData.torque[i].torque; 
        const inputHTML = `
            <div class="row t1">
                <div class="col-5 t1" style="padding-left: 5%; color: #000">${i + 1}:</div>
                <div class="col-5 t1">
                    <input data-id="${i + 1}" type="text" class="t2 form-control" value="${torqueValue}">
                </div>
            </div>`;
        container.insertAdjacentHTML('beforeend', inputHTML); 
    }
}
</script>


<?php require APPROOT . 'views/inc/footer.tpl'; ?>

<script>

var x_val = <?php echo isset($data['echart']['x_val']) ? json_encode($data['echart']['x_val']) : '[]'; ?>; 
var y_val_torque_1 = <?php echo isset($data['echart']['y_val_torque_1']) ? json_encode($data['echart']['y_val_torque_1']) : '[]'; ?>; 
var y_val_torque_2 = <?php echo isset($data['echart']['y_val_torque_2']) ? json_encode($data['echart']['y_val_torque_2']) : '[]'; ?>; 

function safeParse(jsonStr) {
    try {
        var parsed = JSON.parse(jsonStr);
        return Array.isArray(parsed) ? parsed : [];
    } catch (e) {
        //console.error('JSON解析錯誤:', e);
        return [];
    }
}


x_val = safeParse(x_val).map(Number); 
y_val_torque_1 = safeParse(y_val_torque_1).map(Number); 
y_val_torque_2 = safeParse(y_val_torque_2).map(Number); 


renderChart(x_val, y_val_torque_1,y_val_torque_2);

 function renderChart(x_val, y_val_torque_1, y_val_torque_2) {
    
    var chartContainer = document.getElementById('mychart');
    if (!chartContainer) {
        console.error('Chart container not found!');
        return;  
    }

    var myChart = echarts.init(chartContainer);

    var upper_limit = parseFloat(localStorage.getItem('highLimitTorque'));
    var lower_limit = parseFloat(localStorage.getItem('lowLimitTorque'));

    if (isNaN(upper_limit)) upper_limit = null;
    if (isNaN(lower_limit)) lower_limit = null;

    var option = {
        title: {
            text: ''
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                crossStyle: {
                    color: '#999'
                }
            },
            formatter: function (params) {
                var tooltipContent = params[0].name + '<br>';
                params.forEach(function (param) {
                    tooltipContent += param.seriesName + ': ' + param.value + '<br>';
                });
                return tooltipContent;
            }
        },
        legend: {
            data: ['ktm_Torque', 'controller_Torque'],
            top: 'top'
        },
        xAxis: {
            type: 'category',
            name: 'Count',
            data: x_val,
            boundaryGap: false,
        },
        yAxis: {
            type: 'value',
            name: 'Torque',
            min: Math.min(
                lower_limit !== null ? lower_limit - 0.05 : Math.min(...y_val_torque_1, ...y_val_torque_2),
                Math.min(...y_val_torque_1, ...y_val_torque_2)  
            ),
            max: Math.max(
                upper_limit !== null ? upper_limit + 0.05 : Math.max(...y_val_torque_1, ...y_val_torque_2),  
                Math.max(...y_val_torque_1, ...y_val_torque_2) 
            ),
            axisLine: {
                onZero: false
            }
        },
        series: [{
                name: 'ktm_Torque',
                type: 'line',
                symbol: 'none',
                sampling: 'average',
                lineStyle: {
                    width: 0.75,
                    color: 'rgb(255,0,0)'
                },
                itemStyle: {
                    normal: {
                        color: 'rgb(255,0,0)'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgb(255,255,255)' },
                            { offset: 1, color: 'rgb(255,255,255)' }
                        ])
                    }
                },
                data: y_val_torque_1,
            },
            {
                name: 'controller_Torque',
                type: 'line',
                symbol: 'none',
                sampling: 'average',
                lineStyle: {
                    width: 0.75,
                    color: 'rgb(0,0,255)'
                },
                itemStyle: {
                    normal: {
                        color: 'rgb(0,0,255)'
                    }
                },
                areaStyle: {
                    normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: 'rgb(255,255,255)' },
                            { offset: 1, color: 'rgb(255,255,255)' }
                        ])
                    }
                },
                data: y_val_torque_2,
            }
        ]
    };

    //加上曲線圖的上下限
    if (upper_limit !== null && lower_limit !== null) {
        option.series.push({
            name: 'Upper Limit',
            type: 'line',
            symbol: 'none',
            lineStyle: {
                type: 'dashed',
                color: 'green',
                width: 0.75
            },
            data: new Array(x_val.length).fill(upper_limit),
            markPoint: {
                data: [{
                    name: 'Upper Limit Value',
                    label: {
                        show: true,
                        position: 'top',
                        formatter: `Upper Limit: ${upper_limit}`
                    }
                }]
            }
        });

        option.series.push({
            name: 'Lower Limit',
            type: 'line',
            symbol: 'none',
            lineStyle: {
                type: 'dashed',
                color: 'orange',
                width: 0.75
            },
            data: new Array(x_val.length).fill(lower_limit),
            markPoint: {
                data: [{
                    name: 'Lower Limit Value',
                    label: {
                        show: true,
                        position: 'bottom',
                        formatter: `Lower Limit: ${lower_limit}`
                    }
                }]
            }
        });
    }

    myChart.setOption(option);
}




function convertToNumberArray(data) {
    // 檢查是否已經是數組，如果是則直接返回，如果不是則解析並轉換
    if (Array.isArray(data)) {
        return data.map(Number);  // 已經是數組，直接轉換每個元素為數字
    }
    
    try {
        // 如果 data 不是數組，則嘗試將其作為 JSON 字符串解析
        return JSON.parse(data).map(Number);
    } catch (e) {
        console.error('Invalid JSON format:', e);
        return [];
    }
}

window.onload = function() {
    document.getElementById('tolerance').value = 10;
    document.getElementById('bias').value = 10;
    document.getElementById('current_offset').value = 0;
    document.getElementById('current_rpm').value = 100;
    document.getElementById('current_tarque').value = 0.5;
    document.getElementById('skip_turn_rev').checked = true;
    document.getElementById('target-torque').value = 0.5;
    document.getElementById('high-limit-torque').value = 0.55;
    document.getElementById('low-limit-torque').value = 0.45;

    document.cookie = "new_skip=1; path=/;";  

};



// 刪除 localstorage
function clearlocalstorage_keys() {
    localStorage.removeItem('highLimitTorque');
    localStorage.removeItem('lowLimitTorque');
    localStorage.removeItem('implement_count');
    localStorage.removeItem('bias');
    localStorage.removeItem('offset');
    localStorage.removeItem('rpm');
    localStorage.removeItem('targetTorque');

}

function setCookie(name, value, days) {
    const expiresDate = new Date();
    expiresDate.setTime(expiresDate.getTime() + (days * 24 * 60 * 60 * 1000));
    document.cookie = `${name}=${value}; path=/; expires=${expiresDate.toUTCString()}`;
}





</script>


<style>
.selected {
    background-color: #FFCCCB; /* 高亮的背景色 */
}
</style>