<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/cropper.min.css" />
<script src="<?php echo URLROOT; ?>js/cropper.min.js"></script>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/job.css" type="text/css">

<?php echo $data['nav']; ?>

<style>

.t1{font-size: 17px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 17px; margin: 3px 0px;}
.t3{font-size: 17px; margin: 3px 0px; height: 30px;width: 133px;}

</style>

<div class="container-ms">

    <header>
        <div class="job">
            <img id="header-img" src="./img/job-head.svg"><?php echo $text['main_product_text']; ?>
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
        <a style="font-size: 18px; padding-left: 2%"><?php echo $text['Barcode_text']; ?> :</a>&nbsp;
        <input class="t2" type="text" id="search-bar" size="50" placeholder="">
        <button id="barcode-btn" type="button" onclick="get_all_barcode()">
            <?php echo $text['Setting_text']; ?>
        </button>
        <div class="topnav-right">
            <button id="add-job" type="button" onclick="new_job()">
                <img id="img-job" src="./img/add-new-job.svg" alt=""><?php echo $text['Add_Job_text']; ?>
            </button>

            <button id="copy-btn" type="button" onclick="copy_job_div()">
                <img id="img-copy" src="./img/copy.svg" alt=""><?php echo $text['Copy_text']; ?>
            </button>

            <button id="edit-btn" type="button" onclick="edit_job()">
                <img id="img-edit" src="./img/edit.svg" alt=""><?php echo $text['Edit_text']; ?>
            </button>

            <button id="delete-btn" type="button" onclick="delete_job()">
                <img id="img-delete" src="./img/delete.svg" alt=""><?php echo $text['Delete_text']; ?>
            </button>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="scrollbar" id="style-job">
                <div class="force-overflow">
                    <table class="table table-bordered" id="table-job" >
                        <thead id="header-table">
                            <tr style="text-align: center">
                                <th width="10%"><?php echo $text['Job_ID_text']; ?></th>
                                <th width="20%"><?php echo $text['Job_Name_text']; ?></th>
                                <th width="30%"><?php echo $text['Picture_text']; ?></th>
                                <th width="25%"><?php echo $text['More_Info_text']; ?></th>
                                <th width="15%"><?php echo $text['Action_text']; ?></th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                            <?php
                                foreach ($data['jobs'] as $key => $job) {
                                    echo '<tr>';
                                    echo '<td>'.$job['job_id'].'</td>';
                                    echo '<td>'.$job['job_name'].'</td>';
                                    echo '<td><img src="'.$job['img'].'" style="max-height: 100px;display: inline-block;"></td>';
                                    echo '<td>'.$job['seq_count'].' '.$text['Seq_text'].' / '.$job['task_count'].' '.$text['Task_text'].' <br> '.$text['Arm_text'].' '.'</td>';
                                    echo '<td style="text-align: left">';
                                    echo '<div class="dropdown">';
                                    echo '<label><img src="./img/info-30.png" alt="" style="height: 30px; float: left; margin-right: 5px; margin-bottom: 10px" onclick="PictureDetailFunction('.$job['job_id'].')"> '.$text['Detail_text'].' </label>';
                                    echo '<div id="Detail-Dropdown-'.$job['job_id'].'" class=" dropdown dropdown-content">';
                                    echo   '<a style="margin-top: 10%">'.$text['Controller_Type_text'].' :<i style="float: right">GTCS</i></a>';
                                    echo   '<a>'.$text['Job_ID_text'].' :<i style="float: right">'.$job['job_id'].'</i></a>';
                                    echo   '<a>'.$text['OK_Job_text'].' :<i style="float: right">'.$job['ok_job'].'</i></a>';
                                    echo   '<a>'.$text['Job_Repeat_text'].' :<i style="float: right">'.$job['ok_job_stop'].'</i></a>';
                                    echo   '<a>'.$text['Reverse_Button_text'].' :<i style="float: right">'.$job['reverse_direction'].'</i></a>';
                                    echo   '<a>'.$text['Reverse_RPM_text'].' :<i style="float: right">'.$job['reverse_rpm'].'</i></a>';
                                    echo   '<a>'.$text['Reverse_Force_text'].' :<i style="float: right">'.$job['reverse_force'].'</i></a>';
                                    echo   '<a>'.$text['Reverse_Count_text'].' :<i style="float: right">'.$job['reverse_cnt_mode'].'</i></a>';
                                    echo   '<a>'.$text['Rev_Threshold_Tor_text'].':<i style="float: right">'.$job['reverse_threshold_torque'].'</i></a>';
                                    echo '</div>
                                    <br>
                                    <label><img src="./img/add-seq.png" style="height: 30px; float: left; margin-right: 5px" onclick="location.href = \'?url=Sequences/index/'.$job['job_id'].'\';"> '.$text['Add_Seq_text'].' </label>
                                    </div>';
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


    <!-- Job New Modal -->
    <div id="JobNew" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 80%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('JobNew').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id="modal_head" >New Job</h3>
                </header>

                <div class="scrollbar-modal" id="style-NewJob">
                    <div class="force-overflow-modal">
                        <div class="modal-body">
                            <form id="new_job_form">
                                <div class="row">
                                    <div for="controller_type" class="col-5 t1"><?php echo $text['Controller_Type_text']; ?> :</div>
                                    <div class="col t2">
                      					<select id="controller_type" style="width: 183px">
                       					    <option value="0"><?php echo $text['NO_text']; ?> </option>
                       					    <option value="1">GTCS</option>
                     					    <option value="2">TCG</option>
                         				</select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="job_id" class="col-5 t1"><?php echo $text['Job_ID_text']; ?> :</div>
                                    <div class="col-4 t2">
                                        <input type="text" min=1 max=99 class="form-control input-ms" id="job_id" maxlength="5" disabled>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="job_name" class="col-5 t1"><?php echo $text['Job_Name_text']; ?> :</div>
                                    <div class="col-4 t2" >
                                        <input type="text" class="form-control input-ms" id="job_name" maxlength="12" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="barcode_start" class="col-5 t1"><?php echo $text['Barcode_Start_text']; ?> :</div>
                                    <div class="switch menu col-5 t2">
                                        <input id="barcode_start" type="checkbox">
                                        <label><i></i></label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="job_repeat" class="col-5 t1"><?php echo $text['Job_Repeat_text']; ?> :</div>
                                    <div class="switch menu col-5 t2">
                                        <input id="job_repeat" type="checkbox">
                                        <label><i></i></label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="ok_job" class="col-5 t1"> <?php echo $text['OK_Job_text']; ?> :</div>
                                    <div class="switch menu col-5 t2">
                                        <input id="ok_job" type="checkbox">
                                        <label><i></i></label>
                                    </div>
                                </div>
                                <div class="row" style="display:none;">
                                    <div for="Tower-Light" class="col-5 t1"><?php echo $text['Tower_Light_text']; ?> :</div>
                                    <div class="switch menu col-5 t2">
                                        <input id="Tower-Light" type="checkbox">
                                        <label><i></i></label>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div for="reverse_button" class="col-5 t1"><?php echo $text['Reverse_Button_text']; ?> :</div>
                                    <div class="col t2">
                      					<select id="reverse_button" style="width: 183px">
                       					    <option value="1"><?php echo $text['CCW_text']; ?></option>
                     					    <option value="0" selected><?php echo $text['CW_text']; ?></option>
                         				</select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="reverse_rpm" class="col-5 t1"><?php echo $text['Reverse_RPM_text']; ?> :</div>
                                    <div class="col-4 t2">
                                        <input id="reverse_rpm" type="text" class="form-control input-ms" maxlength="" >
                                    </div>
                                    <div class="col t1">
                                        <label><?php echo $text['MAX_text']; ?> 1000</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="reverse_Force" class="col-5 t1"><?php echo $text['Reverse_Force_text']; ?> (&#37;) :</div>
                                    <div class="col-4 t2">
                                        <input id="reverse_Force" type="text" class="form-control input-ms" maxlength="" >
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="reverse_count" class="col-5 t1"><?php echo $text['Reverse_Count_text']; ?> :</div>
                                    <div class="col-4 t2">
                                        <!-- <input id="reverse_count" type="text" class="form-control input-ms" maxlength="" > -->
                                        <select id="reverse_count" style="width: 183px">
                                            <option value="1"><?php echo $text['ON_text']; ?></option>
                                            <option value="0"><?php echo $text['OFF_text']; ?></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="threshold_torque" class="col-5 t1"><?php echo $text['Rev_Threshold_Tor_text']; ?> :</div>
                                    <div class="col-4 t2">
                                        <input id="threshold_torque" type="text"  class="form-control input-ms" maxlength="" >
                                    </div>
                                    <div class="col t1">
                                        <label>N.m</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class=" col-5 t1"><?php echo $text['Size_text']; ?> :</div>
                                    <div class="circle" id="circle" style="margin: 20px 0"></div>
                                    <div class="col t2" style="margin: 20px 0">
                                        <input class="perspective-range" type="range" min="1" max="100" value="50" class="slider"  oninput="updateCircleSize(this.value)" data-units="px">
                                    </div>
                                    <input id="size" type="text" value="0" style="display:none;" disabled >
                                </div>
                            </form>

                            <input id="upload_img" type="file" onchange="openFile(event)" accept="image/gif, image/jpeg, image/png">
                            <div class="box tailoring-box">
                                <img id="output" height="300" style="display:none">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="save_job()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('JobNew').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Copy Job Modal -->
    <div id="copyjob" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 80%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('copyjob').style.display='none'"
                        class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3><?php echo $text['Copy_job_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="new_job_form">
                        <div for="from_job_id" class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_from_text']; ?></b></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_job_id" class="col-4 t1"><?php echo $text['Job_ID_text']; ?> :</div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_job_id" disabled>
        				        </div>
        				    </div>
                            <div class="row">
                                <div for="from_job_name" class="col-4 t1"><?php echo $text['Job_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="from_job_name" disabled>
                                </div>
                            </div>
                        </div>

                        <div for="from_job_id" class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_to_text']; ?></b></div>
                        <div style="padding-left: 20px;">
                            <div class="row">
                                <div for="to_job_id" class="col-4 t1"><?php echo $text['Job_ID_text']; ?> :</div>
                				<div class="col-5 t2">
                				    <input type="text" class="form-control" id="to_job_id" >
                				</div>
            				</div>
                            <div class="row">
                                <div for="to_job_name" class="col-4 t1"><?php echo $text['Job_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="to_job_name" >
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button class="button button3" onclick="copy_job()"><?php echo $text['Save_text']; ?></button>
                    <button class="button button3" onclick="document.getElementById('copyjob').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Table Barcode Setting -->
    <div id="barcode-setting" class="modal" style="transform: scale(1.0); transform-origin: top left;">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content w3-animate-zoom" style="width: 80%">
            <header class="w3-container modal-header">
                <span onclick="document.getElementById('barcode-setting').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                <h3>Barcode Setting</h3>
            </header>

            <div class="modal-body">
                <form id="barcode_form" onsubmit="return false;">
                    <div class="row">
                        <div class="col-3 t1"><?php echo $text['Barcode_text']; ?> :</div>
                        <div class="col-9 t2">
                            <input type="text" class="form-control input-ms" id="barcode-number" maxlength="99" onblur="autofill(this)">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 t1"><?php echo $text['Match_From_text']; ?> :</div>
                        <div class="col-3 t2">
                            <input type="text" class="t3 form-control input-ms" id="match-from">
                        </div>

                        <div class="col-3 t1"><?php echo $text['Match_To_text']; ?> :</div>
                        <div class="col-3 t2">
                            <input type="text" class="t3 form-control input-ms" id="match-to">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-3 t1"><?php echo $text['Select_Job_ID_text']; ?> :</div>
                        <div class="col t2">
                            <select id="Job-ID" onchange="GetSeqList()" style="width: 133px; height: 30px; border: 1px solid #B8B8B8; border-radius: 3px; padding-left: .375rem;">
                                <?php foreach ($data['jobs'] as $key => $value) {
                                    echo '<option value="'.$value['job_id'].'">'.$value['job_id'].'</option>';
                                } ?>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 t1"><?php echo $text['Select_Seq_ID_text']; ?> :</div>
                        <div class="col t2">
                            <select id="Seq-ID" style="width: 133px; height: 30px; border: 1px solid #B8B8B8; border-radius: 3px; padding-left: .375rem;">
                            </select>
                        </div>
                        <button class="button button3" style="margin-right: 15px" onclick="save_barcode()"><?php echo $text['Save_text']; ?></button>
                    </div>
                </form>
                <hr>
                <div class="scrollbar-barcode-table" id="style-barcode-table">
                    <div class="force-overflow-barcode-table">
                        <table class="table table-bordered table-hover" id="barcode-table">
                            <thead id="header-table" style="text-align: center; vertical-align: middle">
                                <tr>
                                    <th><i class="fa fa-trash-o" style="font-size:26px;color:black"></i></th>
                                    <th><?php echo $text['Job_ID_text']; ?></th>
                                    <th><?php echo $text['Job_Name_text']; ?></th>
                                    <th><?php echo $text['Seq_ID_text']; ?></th>
                                    <th><?php echo $text['Seq_Name_text']; ?></th>
                                    <th><?php echo $text['Barcode_text']; ?></th>
                                    <th style="display:none;">Match From</th>
                                    <th style="display:none;">Match To</th>
                                </tr>
                            </thead>

                            <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.8vmin; text-align: center; vertical-align: middle;">
                                <tr>
                                    <td><i class="fa fa-times" style="font-size:22px"></i></td>
                                    <td>1</td>
                                    <td>nor-ac-12</td>
                                    <td>-</td>
                                    <td>2</td>
                                    <td>12345678</td>
                                    <td style="display:none;">666</td>
                                    <td style="display:none;">666</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>

<script>

document.addEventListener("DOMContentLoaded", function() {
    var table = document.getElementById("barcode-table");
    var rows = table.getElementsByTagName("tr");

    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        row.addEventListener("click", function() {
            var cells = this.getElementsByTagName("td");
            var barcodeInput = document.getElementById("barcode-number");
            var matchFromInput = document.getElementById("match-from");
            var matchToInput = document.getElementById("match-to");
            var jobIDSelect = document.getElementById("Job-ID");
            var seqIDSelect = document.getElementById("Seq-ID");

            barcodeInput.value = cells[4].innerText; // Thay đổi chỉ số để lấy giá trị Barcode
            matchFromInput.value = cells[0].innerText;
            matchToInput.value = cells[2].innerText;

            // Lấy giá trị Job ID và Seq ID từ dòng được click và đặt lại cho các select tương ứng
            var jobID = cells[0].innerText;
            var seqID = cells[2].innerText;

            // Tìm option có giá trị bằng Job ID và Seq ID và đặt làm selected
            for (var j = 0; j < jobIDSelect.options.length; j++) {
                if (jobIDSelect.options[j].value === jobID) {
                    jobIDSelect.selectedIndex = j;
                    break;
                }
            }

            for (var k = 0; k < seqIDSelect.options.length; k++) {
                if (seqIDSelect.options[k].value === seqID) {
                    seqIDSelect.selectedIndex = k;
                    break;
                }
            }
        });
    }
});

/* dropdown content */
function PictureDetailFunction(item)
{
    var Divs = document.querySelectorAll("div[id^='Detail-Dropdown']");
    // 迭代所有符合條件的 div 元素，移除 class
    Divs.forEach(function(div) {
        // if(!div.hasClass('show'))
        if( $(div)[0].id != "Detail-Dropdown-"+item){
            div.classList.remove("show"); // 將 "yourClassNameToRemove" 替換為你想要移除的 class 名稱
        }
    });

    document.getElementById("Detail-Dropdown-"+item).classList.toggle("show");

}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
    if (!event.target.matches('.dropdown img')) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        var i;
        for (i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
}

// Get the modal
var modal = document.getElementById('JobNew');
var modal = document.getElementById('barcode-setting');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}

/* ==================== RangeDisplay ==================== */

// displays the value of a range input
function RangeDisplay( input )
{
    this.input = input;
    this.output = document.createElement('span');
    this.output.className = 'range-display';
    // this.units = this.input.getAttribute('data-units') || '';
    this.units = ' x';
    // events
    var onChange = this.update.bind( this );
    this.input.addEventListener( 'change', onChange );
    this.input.addEventListener( 'input', onChange );
    // set initial output
    this.update();
    this.input.parentNode.appendChild( this.output );
}

RangeDisplay.prototype.update = function () {
  var roundedValue = Math.round(this.input.value / 25) * 25; // Round to the nearest multiple of 25
  // this.output.textContent = '1.'+roundedValue + this.units;
  this.output.textContent = 1 + 1*(roundedValue/100) + this.units
  document.getElementById('size').value = roundedValue;
};

/* ==================== init ==================== */


// init RangeDisplays
var ranges = document.querySelectorAll('input[type="range"]');
for ( var i=0; i < ranges.length; i++ )
{
    new RangeDisplay( ranges[i] );
}

function updateCircleSize(value)
{
    var roundedValue = Math.round(value / 25) * 25; // Round to the nearest multiple of 25
    var circle = document.getElementById("circle");
    circle.style.transform = "scale(" + (1 + (roundedValue / 100)) + ")";

}

</script>

<script>
// Change the color of a row in a table
    $(document).ready(function () {
        highlight_row('table-job');
        highlight_row('barcode-table');
        GetSeqList();//先取得目前的seq list
    });

    function highlight_row(tableId){
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
    } //end of function

    function openFile(event){

        //顯示預覽圖
        var input = event.target; //取得上傳檔案
        var reader = new FileReader(); //建立FileReader物件

        reader.readAsDataURL(input.files[0]); //以.readAsDataURL將上傳檔案轉換為base64字串
        if(file.size / 1024 / 1024 > 5) {
            alert('Image size cannot exceed 500kb')
            document.getElementById('upload_img').value = '';
        }else{
            reader.onload = function(){ //FileReader取得上傳檔案後執行以下內容
            var dataURL = reader.result; //設定變數dataURL為上傳圖檔的base64字串
            $('#output').attr('src', dataURL).show(); //將img的src設定為dataURL並顯示
            };            
        }

    }
       

    function save_job() {

        let controller_type = document.getElementById("controller_type").value;
        let job_id = document.getElementById("job_id").value;
        let job_name = document.getElementById("job_name").value;
        let ok_job = document.getElementById('ok_job').checked; //$('input[id=ok_job]:checked').val();
        let reverse_button = document.getElementById("reverse_button").value;
        let reverse_rpm = document.getElementById("reverse_rpm").value;
        let reverse_Force = document.getElementById("reverse_Force").value;
        let reverse_count = document.getElementById('reverse_count').value;
        let threshold_torque = document.getElementById("threshold_torque").value;
        let size = document.getElementById('size').value;
        let barcode_start = document.getElementById('barcode_start').checked; // $('input[name=Downshift_Enable]:checked').val();
        let job_repeat = document.getElementById('job_repeat').checked; // $('input[name=Downshift_Enable]:checked').val();
        let tower_light = document.getElementById('Tower-Light').checked; // $('input[name=Downshift_Enable]:checked').val();
    
        var formData = new FormData();
        // 添加表单数据
        var form = $('new_job_form');
        formData.append('controller_type', controller_type);
        formData.append('job_id', job_id);
        formData.append('job_name', job_name);
        formData.append('ok_job', ok_job);
        formData.append('reverse_button', reverse_button);
        formData.append('reverse_rpm', reverse_rpm);
        formData.append('reverse_Force', reverse_Force);
        formData.append('reverse_count', reverse_count);
        formData.append('threshold_torque', threshold_torque);
        formData.append('size', size);
        formData.append('barcode_start', barcode_start);
        formData.append('ok_job_stop', job_repeat);
        formData.append('tower_light', tower_light);

        // 添加图片数据
        var fileInput = $('#upload_img')[0].files[0];
        formData.append('image', fileInput);
        const MAX_FILE_SIZE = 5 * 1024 * 1024; 
        if (fileInput) {
            var fileSize = fileInput.size;
            if (fileSize > MAX_FILE_SIZE) {
                alert('文件大小超過5MB限制。');
                return false;
            }else {
                //var formData = new FormData();
                formData.append('image', fileInput);
            }
        } 


        //cropper
        if($t[0].cropper === undefined){//未上傳圖片
            formData.append('croppedImage', false);
            let url = '?url=Products/edit_job';
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
                // history.go(0);//失敗就重新整理
            });
        }else{
            // 使用 Cropper.js 的 getCroppedCanvas 方法獲取裁剪後的 Canvas 元素
            var croppedCanvas = $t.cropper('getCroppedCanvas');

            // 設置壓縮後的最大寬度和高度
            var maxWidth = 800;
            var maxHeight = 600;

            // 創建一個新的 Canvas 元素
            var canvas = document.createElement('canvas');
            var ctx = canvas.getContext('2d');

            // 設置 Canvas 的寬度和高度
            var width = croppedCanvas.width;
            var height = croppedCanvas.height;

            // 如果圖片的寬度或高度超過了指定的最大寬度或最大高度，則進行壓縮
            if (width > maxWidth || height > maxHeight) {
                if (width / height > maxWidth / maxHeight) {
                    height *= maxWidth / width;
                    width = maxWidth;
                } else {
                    width *= maxHeight / height;
                    height = maxHeight;
                }
            }

            // 設置 Canvas 的寬度和高度
            canvas.width = width;
            canvas.height = height;

            // 在 Canvas 上繪製裁剪後的圖片
            ctx.drawImage(croppedCanvas, 0, 0, width, height);

            // 將 Canvas 轉換為 Blob 物件
            canvas.toBlob(function(blobs) {
                // 上傳壓縮後的圖片 Blob 到服務器
                formData.append('croppedImage', blobs /*, 'example.png' */ );
                let url = '?url=Products/edit_job';
                $.ajax({
                    type: "POST",
                    data: formData,
                    dataType: "json",
                    url: url,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        // 成功回調函數，處理伺服器的回應
                        // console.log(response); // 在控制台輸出伺服器的回應
                        if (response.error == '') {
                            history.go(0);
                        }
                    },
                    error: function(error) {
                        // 失敗回調函數，處理錯誤情況
                        // console.error('Error:', error); // 在控制台輸出錯誤訊息
                    }
                }).fail(function() {
                    // history.go(0); //失敗就重新整理
                });
            }, 'image/jpeg', 0.8); // 圖片品質為 0.8（範圍從 0 到 1）
        }
        //end cropper


    }

    function new_job(argument) {
        document.getElementById('modal_head').innerHTML = '<?php echo $text['New_Job_text']; ?>'; //'New Job'
        //帶入預設值
        document.getElementById("controller_type").value = 0;
        document.getElementById("job_id").value = '';
        document.getElementById("job_name").value = '';
        document.getElementById('ok_job').checked = 1;
        document.getElementById("reverse_button").value = 1;
        document.getElementById("reverse_rpm").value = 100;
        document.getElementById("reverse_Force").value = 70;
        document.getElementById('reverse_count').value = '';
        document.getElementById("threshold_torque").value = 0.0;
        document.getElementById('barcode_start').checked = 1;
        document.getElementById('job_repeat').checked = 0;
        document.getElementById('Tower-Light').checked = 0;

        // document.getElementById('size').value = response['point_size'];//另外處理
        document.getElementsByClassName('perspective-range')[0].value = 50;
        updateCircleSize(50);
        document.getElementsByClassName('range-display')[0].innerHTML = '1.5 x';

        //image
        document.getElementById('upload_img').value = '';
        $('#output').attr('src', '').hide(); //將img的src設定為dataURL並顯示

        //get job id
        let job_id = get_job_id_normal();
        if(job_id > 99){ //避免新增超過99個seq
            return 0;
        }else{
            document.getElementById("job_id").value = job_id;
            document.getElementById('JobNew').style.display='block';
        }

        // document.getElementById('JobNew').style.display='block';
    }

    //get job_id
    function get_job_id_normal() {

        $.ajax({
          type: "POST",
          url: "?url=Products/get_head_job_id",
          data: {},
          dataType: "json",
          encode: true,
          async: false,//等待ajax完成
        }).done(function (data) {//成功且有回傳值才會執行
            job_id = data['missing_id'];
        });

        return job_id;
    }

    function edit_job(argument) {

        let rowSelected = document.getElementsByClassName('selected');
        let job_id = rowSelected[0].childNodes[0].innerHTML;

        let url = '?url=Products/get_job_by_id';
        $.ajax({
            type: "POST",
            data: {'job_id' : job_id},
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                console.log(response); // 在控制台輸出伺服器的回應

                document.getElementById("controller_type").value = response['controller_id'];
                document.getElementById("job_id").value = job_id;
                document.getElementById("job_name").value = response['job_name'];
                document.getElementById('ok_job').checked = parseInt(response['ok_job']);
                document.getElementById("reverse_button").value = response['reverse_direction'];
                document.getElementById("reverse_rpm").value = response['reverse_rpm'];
                document.getElementById("reverse_Force").value = response['reverse_force'];
                document.getElementById('reverse_count').value = parseInt(response['reverse_cnt_mode']);
                document.getElementById("threshold_torque").value = response['reverse_threshold_torque'];
                document.getElementById('barcode_start').checked = parseInt(response['barcode_start']);
                document.getElementById('job_repeat').checked = parseInt(response['ok_job_stop']);
                document.getElementById('Tower-Light').checked = parseInt(response['tower_light']);

                // document.getElementById('size').value = response['point_size'];//另外處理
                document.getElementsByClassName('perspective-range')[0].value = response['point_size'];
                updateCircleSize(response['point_size']);

                let tt = (1 + (response['point_size'] / 100)) + ' x'
                document.getElementsByClassName('range-display')[0].innerHTML = tt;

                //初始化 移除croppper與img
               
                document.getElementById('upload_img').value = ''
                $t.cropper('destroy');
                // $t.cropper({});

                //image
                $('#output').attr('src', response['img']).show(); //將img的src設定為dataURL並顯示

                document.getElementById('modal_head').innerHTML = '<?php echo $text['Edit_Job_text']; ?>'; //'New Job'
                document.getElementById('JobNew').style.display='block'
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function () {
            // history.go(0);//失敗就重新整理
        });
        
    }

    function copy_job_div() {
        let rowSelected = document.getElementsByClassName('selected');
        if (rowSelected.length != 0) {
            let job_id = rowSelected[0].childNodes[0].innerHTML;
            let job_id_name = rowSelected[0].childNodes[1].innerHTML;

            document.getElementById('from_job_id').value=job_id;
            document.getElementById('from_job_name').value=job_id_name;
            document.getElementById('copyjob').style.display='block'
        }
    }

    function copy_job() {
        let rowSelected = document.getElementsByClassName('selected');
        let job_id = rowSelected[0].childNodes[0].innerHTML;
        let to_job_id = document.getElementById('to_job_id').value;
        let to_job_name = document.getElementById('to_job_name').value;

        let url = '?url=Products/copy_job';
        $.ajax({
            type: "POST",
            data: { 'from_job_id': job_id, 
                    'to_job_id': to_job_id,
                    'to_job_name': to_job_name },
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                console.log(response); // 在控制台輸出伺服器的回應
                history.go(0);
                document.getElementById('copyjob').style.display = 'none';
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function() {
             history.go(0);//失敗就重新整理
        });

        //
        history.go(0);
        document.getElementById('copyjob').style.display = 'none';
    }

    function delete_job() {
        let rowSelected = document.getElementsByClassName('selected');
        let job_id = rowSelected[0].childNodes[0].innerHTML;

        var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>');

        if (yes) {
            let url = '?url=Products/delete_job';
            $.ajax({
                type: "POST",
                data: {'job_id' : job_id},
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
            }).fail(function () {
                // history.go(0);//失敗就重新整理
            });
        } else {
            
        }
    }

    function save_barcode(argument) {
        let barcode = document.getElementById('barcode-number').value
        let match_from = document.getElementById('match-from').value
        let match_to = document.getElementById('match-to').value
        let job_id = document.getElementById('Job-ID').value
        let seq_id = document.getElementById('Seq-ID').value

        let url = '?url=Products/Edit_Barcode';
        $.ajax({
            type: "POST",
            data: { 'barcode': barcode,
                    'match_from': match_from,
                    'match_to': match_to,
                    'job_id': job_id,
                    'seq_id': seq_id
                },
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                get_all_barcode()
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function() {
            // history.go(0);//失敗就重新整理
        });

    }

    function GetSeqList(seq_id) {

        // let url = '?url=Products/get_seq_list_by_job_id';
        var Seq_Select = document.getElementById("Seq-ID");
        // 清空<select>元素的现有选项
        Seq_Select.innerHTML = "";
        
        var jobIDSelect = document.getElementById("Job-ID").value;
        // console.log(jobIDSelect);
        let url = '?url=Products/get_seq_list_by_job_id';
        $.ajax({
            type: "POST",
            data: { 'job_id': jobIDSelect },
            dataType: "json",
            url: url,
            success: function(response) {
            if (Array.isArray(response)) {
                var optionsData = response;

                // 添加新选项
                optionsData.forEach(function(option, index) {
                    var optionElement = document.createElement("option");
                    optionElement.value = option.seq_id;
                    optionElement.textContent = (index + 1);
                    Seq_Select.appendChild(optionElement);
                });

                if (seq_id != undefined) {
                    document.getElementById('Seq-ID').value = seq_id;
                } else {
                    document.getElementById('Seq-ID').value = 1;
                }
            } else {
                console.error('Response is not an array:', response);
                alertify.error("Server response is not in the expected format.");
            }
        },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function() {
            // history.go(0);//失敗就重新整理
        });
    }

    function autofill(element) {
        let start = element.selectionStart;
        let end = element.selectionEnd;

        if (start == end) {
            document.getElementById('match-from').value = '1';
            document.getElementById('match-to').value = end;
        }else{
            document.getElementById('match-from').value = +start + 1;
            document.getElementById('match-to').value = end;
        }
    }

    function get_all_barcode() {

        var tbody1 = document.getElementById("tbody1");
        // 清空<select>元素的现有选项
        tbody1.innerHTML = "";

        let url = '?url=Products/Get_All_Barcode';
        $.ajax({
            type: "POST",
            data: {},
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                // console.log(response); // 在控制台輸出伺服器的回應
                // history.go(0);

                // var optionsData = JSON.parse(response);
                var tableData = response;
                // console.log(typeof tableData)


                // 添加新选项
                tableData.forEach(function(option, index) {
                    let trElement = document.createElement("tr");
                    let delete_td = document.createElement("td");
                    delete_td.innerHTML = '<i class="fa fa-times" style="font-size:22px" onclick="delete_barcode('+option.id+')"></i>';

                    trElement.appendChild(delete_td)                    
                    trElement.appendChild(create_td(option.barcode_selected_job))
                    trElement.appendChild(create_td(option.job_name))
                    trElement.appendChild(create_td(option.barcode_selected_seq))
                    trElement.appendChild(create_td(option.seq_name))
                    trElement.appendChild(create_td(option.barcode))
                    // trElement.appendChild(create_td(option.action))//
                    trElement.appendChild(create_td(option.barcode_mask_from,'none'))
                    trElement.appendChild(create_td(option.barcode_mask_count,'none'))
                    trElement.appendChild(create_td(option.barcode,'none'))

                    let start = option.barcode_mask_from
                    let end = option.barcode_mask_count
                    let sub = option.barcode.substring(start-1, end);

                    //加上*號
                    trElement.childNodes[5].textContent = replaceWithAsterisks(option.barcode.toString(),start-1,end-start+1)

                    tbody1.appendChild(trElement)
                });


                highlight_row('barcode-table');
                autofill2();
                document.getElementById('barcode-setting').style.display='block'

            },
            error: function(error) {
            }
        });
    }

    function create_td(value,display='') {
        let tdElement = document.createElement("td");
        tdElement.textContent = value;
        tdElement.style.display = display;
        return tdElement
    }

    function delete_barcode(id) {

        var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>');

        if(yes){
            let url = '?url=Products/Delete_Barcode';
            $.ajax({
                type: "POST",
                data: { 'id': id },
                dataType: "json",
                url: url,
                success: function(response) {
                    // 成功回調函數，處理伺服器的回應
                    // console.log(response); // 在控制台輸出伺服器的回應
                    // history.go(0);
                    get_all_barcode()
                },
                error: function(error) {
                    // 失敗回調函數，處理錯誤情況
                    // console.error('Error:', error); // 在控制台輸出錯誤訊息
                }
            }).fail(function() {
                // history.go(0);//失敗就重新整理
            });
        }
    }

    //click row will fill input
    function autofill2(argument) {
        var table = document.getElementById("barcode-table");
        var rows = table.getElementsByTagName("tr");

        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            row.addEventListener("click", function() {
                var cells = this.getElementsByTagName("td");
                var barcodeInput = document.getElementById("barcode-number");
                var matchFromInput = document.getElementById("match-from");
                var matchToInput = document.getElementById("match-to");
                var jobIDSelect = document.getElementById("Job-ID");
                var seqIDSelect = document.getElementById("Seq-ID");

                barcodeInput.value = cells[8].innerText; // Thay đổi chỉ số để lấy giá trị Barcode
                matchFromInput.value = cells[6].innerText;
                matchToInput.value = cells[7].innerText;

                // Lấy giá trị Job ID và Seq ID từ dòng được click và đặt lại cho các select tương ứng
                var jobID = cells[0].innerText;
                var seqID = cells[2].innerText;

                // Tìm option có giá trị bằng Job ID và Seq ID và đặt làm selected
                for (var j = 0; j < jobIDSelect.options.length; j++) {
                    if (jobIDSelect.options[j].value === jobID) {
                        jobIDSelect.selectedIndex = j;
                        break;
                    }
                }
                GetSeqList(seqID);

            });
        }
    }

    function replaceWithAsterisks(str, from, count) {

        // 使用 parseInt() 将 from、count 和 str.length 转换为整数
        from = parseInt(from, 10);
        count = parseInt(count, 10);
        
        if (typeof str !== 'string' || isNaN(from) || isNaN(count) || from < 0 || count <= 0 || parseInt(from) + parseInt(count) > str.length) {
            return 'Invalid input';
        }

        let prefixLength = from; // 从字符串开头到 from 的字符数
        let preservedLength = count; // 保留的字符数
        let suffixLength = str.length - from - count; // 从 from + count 到字符串末尾的字符数

        let prefix = '*'.repeat(prefixLength); // 生成前缀的 *
        let preserved = str.substring(from, from + preservedLength); // 保留的部分
        let suffix = '*'.repeat(suffixLength); // 生成后缀的 *

        return prefix + preserved + suffix;

    }



</script>

<style type="text/css">
    .selected{
        background-color: #9AC0CD !important;
    }

    ./*selected :hover{
        background-color: #9AC0CD;
    }*/
</style>

<script type="text/javascript">
  var $t = $('#output');

  $('#upload_img').change(function(){
    let file = this.files[0];
    if (file) {
      let reader = new FileReader();
      reader.onload = function(evt) {
        let imgSrc = evt.target.result;
        // cropper圖片裁剪
        $t.cropper({
            aspectRatio: NaN, // 預設比例
            // preview : '#previewImg',  // 預覽檢視
            autoCrop: true,
            guides: false, // 裁剪框的虛線(九宮格)
            autoCropArea: 0.5, // 0-1之間的數值，定義自動剪裁區域的大小，預設0.8
            dragMode: 'crop', // 拖曳模式 crop(Default,新增裁剪框) / move(移動裁剪框&圖片) / none(無動作)
            cropBoxResizable: true, // 是否有裁剪框調整四邊八點
            movable: true, // 是否允許移動圖片
            zoomable: true, // 是否允許縮放圖片大小
            rotatable: false, // 是否允許旋轉圖片
            zoomOnWheel: true, // 是否允許通過滑鼠滾輪來縮放圖片
            zoomOnTouch: true, // 是否允許通過觸控移動來縮放圖片
            ready: function(e) {
                console.log('ready!');
            }
        });
        $t.cropper('replace', imgSrc, false);
      }
      reader.readAsDataURL(file);
    }
  });


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