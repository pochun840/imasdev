<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/program_advance.css" type="text/css">

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
        <label type="text" style="font-size: 22px; margin: 4px;"><?php echo $text['Program_Advanced_text']; ?></label>
        <div class="topnav-right">
            <button class="btn" id="back-btn" type="button" onclick="location.href = '?url=Templates/';">
                <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
            </button>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="row" style="margin-bottom: 5px;">
                <div for="controller-type" class="col-1 t1"><?php echo $text['Controller_text']; ?> :</div>
                <div class="col-1 t2" style="margin-right: 3%">
                    <input type="text" class="form-control input-ms" id="controller-type" value="GTCS" maxlength="" disabled="disabled">
                </div>

                <div for="tool-type" class="col-1 t1"><?php echo $text['Screw_Tool_text'];?> :</div>
                <div class="col-2 t2" style="margin-right: 2%">
                    <input type="text" class="form-control input-ms" id="tool-type" value="3-01007-7L-H" maxlength="" disabled="disabled">
                </div>

                <div class="col t1">
                    <button id="add-program" type="button" onclick="new_program()">
                        <img id="img-add" src="./img/add-program.svg" alt=""><?php echo $text['Add_Program_text']; ?>
                    </button>

                    <button id="add-program" type="button" onclick="edit_program()">
                        <img id="img-add" src="./img/program_edit.png" alt=""><?php echo $text['Edit_text']; ?>
                    </button>

                    <button id="copy-program" type="button" onclick="copy_program_div()">
                        <img id="img-copy" src="./img/program-copy.svg" alt=""><?php echo $text['Copy_text']; ?>
                    </button>

                    <button id="delete-program" type="button" onclick="delete_program()">
                        <img id="img-delete" src="./img/program-delete.svg" alt=""><?php echo $text['Delete_text']; ?>
                    </button>

                    <button id="test" type="button">
                        <img id="img-test" src="./img/check-all.png"> <?php echo $text['Test_text']; ?>
                    </button>
                </div>
            </div>

            <div class="scrollbar" id="style-program">
                <div class="force-overflow">
                    <table class="table table-bordered" id="table">
                        <thead id="header-table" style="background-color: #A3A3A3; font-size: 2vmin">
                            <tr style="text-align: center; vertical-align: middle;">
                                <th width="5%"></th>
                                <th width="10%"><?php echo $text['Program_ID_text']; ?></th>
                                <th width="20%"><?php echo $text['Program_Name_text']; ?></th>
                                <th width="10%"><?php echo $text['Target_Q_text']; ?> (N.m)</th>
                                <th width="10%"><?php echo $text['Target_A_text']; ?> (&#186;)</th>
                                <th width="35%"><?php echo $text['Edit_text']; ?></th>
                                <th width="15%"><?php echo $text['Add_Step_text']; ?></th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                            <?php 
                            foreach ($data['AdvancedSteps'] as $key => $step) {
                                echo '<tr>';
                                echo '<td><input class="form-check-input" type="checkbox" name="" value="0" style="zoom:1.0; vertical-align: middle"></td>';
                                echo '<td>'.$step['template_program_id'].'</td>';
                                echo '<td>'.$step['template_program_name'].'</td>';
                                echo '<td>'.$step['step_targettorque'].'</td>';
                                echo '<td>'.$step['step_targetangle'].'</td>';
                                echo '<td style="text-align: left">';
                                foreach ($step['targettype_list'] as $key2 => $target) {
                                    if($target == 2){
                                        echo    '<img src="./img/torque.png" width="40" height="40" alt="">';
                                    }else{
                                        echo    '<img src="./img/angle.png" width="40" height="40" alt="">';        
                                    }
                                }
                                echo '</td>';
                                echo '<td>';
                                echo '<a href="index.php?url=Templates/advancedstep_step/'.$step['template_program_id'].'"><i id="" class="fa fa-plus-square-o" style="color: #444E66;font-size: 35px; height: 35px; display: inline-block; vertical-align: middle;">
                                </i></a>';
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

    <!-- New Program -->
    <div id="ProgramNew" class="modal">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content w3-animate-zoom" style="width:100%;">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('ProgramNew').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id="modal_head"><?php echo $text['New_Program_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="new_program_form">
                        <div id="Torque_Parameter" style="display: block">
                            <div class="scrollbar-modal" id="style-y">
                                <div class="modal-force-overflow">
                                    <div style="padding-left: 5%; height: 300px">
                                        <div class="row t1">
                                            <div class="col-5 t1" for=""><?php echo $text['Program_ID_text']; ?> :</div>
                                            <div class="col-5 t2">
                                                <input type="text" id="program-id" class="form-control input-ms" value="1" maxlength="" disabled="disabled">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-5 t1" for=""><?php echo $text['Program_Name_text']; ?> :</div>
                                            <div class="col-5 t2">
                                                <input type="text" id="program-name" class="form-control input-ms" value="Program-1" maxlength="">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-5 t1" for=""><?php echo $text['Target_Type_text']; ?> :</div>
                                            <div class="col-5 t2">
                              					<select id="target-type" class="form-control" style="appearance:auto;" >
                               					    <option value="2"><?php echo $text['Torque_text']; ?></option>
                               					    <option value="1"><?php echo $text['Angle_text']; ?></option>
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
                    <button id="button1" class="button button3" onclick="create_advance_template()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('ProgramNew').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>

    <!-- edit Program -->
     <div id="ProgramEdit" class="modal">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content w3-animate-zoom" style="width:100%;">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('ProgramEdit').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id="modal_head"><?php echo $text['Edit_Program_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="new_program_form">
                        <div id="Torque_Parameter" style="display: block">
                            <div class="scrollbar-modal" id="style-y">
                                <div class="modal-force-overflow">
                                    <div style="padding-left: 5%; height: 300px">
                                        <div class="row t1">
                                            <div class="col-5 t1" for=""><?php echo $text['Program_ID_text']; ?> :</div>
                                            <div class="col-5 t2">
                                                <input type="text" id="edit_program-id" class="form-control input-ms" value="1" maxlength="" disabled="disabled">
                                            </div>
                                        </div>
                                        <div class="row t1">
                                            <div class="col-5 t1" for=""><?php echo $text['Program_Name_text']; ?> :</div>
                                            <div class="col-5 t2">
                                                <input type="text" id="edit_program-name" class="form-control input-ms" value="Program-1" maxlength="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="edit_advance_template()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('ProgramEdit').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>
    

    <!-- Program Copy Modal -->
    <div id="CopyProgram" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 430px">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('CopyProgram').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3><?php echo $text['Copy_text'].' '.$text['Program_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="copy_Pro_form">
                        <div class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_from_text']; ?></b></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_pro_id" class="col-5 t1"><?php echo $text['Program_ID_text']; ?> :</div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_pro_id" disabled>
        				        </div>
        				    </div>
                            <div class="row">
                                <div for="from_pro_name" class="col-5 t1"><?php echo $text['Program_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="from_pro_name" disabled>
                                </div>
                            </div>
                        </div>

                        <div class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_to_text']; ?></b></div>
                        <div style="padding-left: 20px;">
                            <div class="row">
                                <div for="to_pro_id" class="col-5 t1"><?php echo $text['Program_ID_text']; ?> :</div>
                				<div class="col-5 t2">
                				    <input type="text" class="form-control" id="to_pro_id">
                				</div>
            				</div>
                            <div class="row">
                                <div for="to_pro_name" class="col-5 t1"><?php echo $text['Program_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="to_Program_name">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="copy_program()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('CopyProgram').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>


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

<script type="text/javascript">
    //get job_id
    function get_program_id() {

        $.ajax({
            type: "POST",
            url: "?url=Templates/get_head_program_id",
            data: {},
            dataType: "json",
            encode: true,
            async: false, //等待ajax完成
        }).done(function(data) { //成功且有回傳值才會執行
            program_id = data['missing_id'];
        });

        return program_id;
    }

    //new program 按下new seq button
    function new_program() {

        //get new program_id
        let program_id = get_program_id();
        if (program_id > 50) { //避免新增超過50個program
            return 0;
        }

        document.getElementById('modal_head').innerHTML = '<?php echo $text['New_Program_text']; ?>'; //'New Program'
        // //帶入預設值
        document.getElementById("program-id").value = program_id;

        //torque element
        document.getElementById("program-name").value = '';

        //show modal
        document.getElementById('ProgramNew').style.display = 'block';

    }


    function edit_program(){

        let rowSelected = document.getElementsByClassName('selected');
        if (rowSelected.length != 0) {

            let pro_id = rowSelected[0].childNodes[1].innerHTML;
            let pro_name = rowSelected[0].childNodes[2].innerHTML;

            document.getElementById("edit_program-id").value = pro_id;

            document.getElementById("edit_program-name").value = pro_name;

            document.getElementById('modal_head').innerHTML = '<?php echo $text['Edit_Program_text']; ?>'; //'Edit Program'
            document.getElementById('ProgramEdit').style.display = 'block';
        }

        

        document.getElementById('ProgramEdit').style.display = 'block';
    }

    function create_advance_template(argument) {
        let program_id = document.getElementById("program-id").value;
        let program_name = document.getElementById("program-name").value;
        let program_target = document.getElementById("target-type").value;

        $.ajax({
            type: "POST",
            url: "?url=Templates/create_gtcs_adv_program",
            data: {'program_id':program_id, 'program_name':program_name, 'program_target':program_target},
            dataType: "json",
        }).done(function(data) { //成功且有回傳值才會執行
            // program_id = data['missing_id'];
            console.log(data);
            history.go(0)
        });
    }


    
    function edit_advance_template() {

        let program_id = document.getElementById("edit_program-id").value;
        let program_name = document.getElementById("edit_program-name").value;

        $.ajax({
            type: "POST",
            url: "?url=Templates/edit_gtcs_adv_program",
            data: {'program_id':program_id, 'program_name':program_name},
            // dataType: "json",
        }).done(function(data) { //成功且有回傳值才會執行
            // program_id = data['missing_id'];
            //console.log(data);
            history.go(0);
             document.getElementById('ProgramEdit').style.display = 'none';
        });
        // document.getElementById('ProgramEdit').style.display = 'none';
        // history.go(0);
    }

    function copy_program_div() {
        let rowSelected = document.getElementsByClassName('selected');
        if (rowSelected.length != 0) {
            let pro_id = rowSelected[0].childNodes[1].innerHTML;
            let pro_name = rowSelected[0].childNodes[2].innerHTML;

            document.getElementById('from_pro_id').value=pro_id;
            document.getElementById('from_pro_name').value=pro_name;
            document.getElementById('CopyProgram').style.display='block'
        }
    }

    function copy_program() {
        let rowSelected = document.getElementsByClassName('selected');
        let pro_id = rowSelected[0].childNodes[1].innerHTML;
        let to_pro_id = document.getElementById('to_pro_id').value;
        let to_pro_name = document.getElementById('to_Program_name').value;

        let url = '?url=Templates/copy_program';
        $.ajax({
            type: "POST",
            data: {
                'from_pro_id': pro_id,
                'to_pro_id': to_pro_id,
                'to_pro_name': to_pro_name,
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

    function delete_program() {
        let rowSelected = document.getElementsByClassName('selected');
        let program_id = rowSelected[0].childNodes[1].innerHTML;

        var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>' +'<?php echo $text['Program_ID_text']; ?> : '+ program_id);

        if (yes) {
            let url = '?url=Templates/delete_program_by_id';
            $.ajax({
                type: "POST",
                data: { 'program_id': program_id},
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