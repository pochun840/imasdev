<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/program_tcg.css" type="text/css">

<?php echo $data['nav']; ?>

<style>

.t1{font-size: 17px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 17px; margin: 3px 0px;}
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
        <label type="text" style="font-size: 22px; margin: 8px;">Program - TCG</label>
        <div class="topnav-right">
            <button class="btn" id="back-btn" type="button" onclick="location.href = '?url=Templates/';">
                <img id="img-back" src="./img/back.svg" alt="">back
            </button>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
                <div class="row" style="margin-bottom: 3px;padding-left: 3%;">
                    <div for="controller-type" class="col-1 t1" style="font-size: 18px">Controller :</div>
                    <div class="col-1 t2" style="margin-right: 3%">
                        <input type="text" class="form-control input-ms" id="controller-type" value="TCG" maxlength="" disabled="disabled">
                    </div>

                    <div for="controller-type" class="col-1 t1" style="font-size: 18px">Screw Tool :</div>
                    <div class="col-2 t2" style="margin-right: 2%">
                        <input type="text" class="form-control input-ms" id="screw-type" value="SKT-CG70" maxlength="" disabled="disabled">
                    </div>

                    <div class="col">
                        <button class="add-copy-delete" type="button" onclick="document.getElementById('ProgramNew').style.display='block'">
                            <img class="img-setting" src="./img/add-program.svg" alt="">Add Program
                        </button>

                        <button class="add-copy-delete" type="button" onclick="document.getElementById('CopyProgram').style.display='block'">
                            <img class="img-setting" src="./img/program-copy.svg" alt="">Copy
                        </button>

                        <button class="add-copy-delete" type="button" onclick="delete_program()">
                            <img class="img-setting" src="./img/program-delete.svg" alt="">Delete
                        </button>
                    </div>
                </div>

                <div class="scrollbar" id="style-table">
                    <div class="force-overflow">
                        <table class="table table-bordered" id="table-program">
                            <thead id="header-table" style="background-color: #A3A3A3; font-size: 2vmin">
                                <tr style="text-align: center">
                                    <th width="5%"></th>
                                    <th width="10%">Program ID</th>
                                    <th width="20%">Program Name</th>
                                    <th width="15%">Target Torque</th>
                                    <th width="15%">Target Angle</th>
                                    <th width="25%">Target type</th>
                                    <th width="10%">Add Step</th>
                                </tr>
                            </thead>
                            <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                                <tr>
                                    <td><input class="form-check-input" type="checkbox" name="" id="02" value="0" style="zoom:1.0; vertical-align: middle"></td>
                                    <td>1</td>
                                    <td>program-1</td>
                                    <td>0.6 Nm</td>
                                    <td>00</td>
                                    <td style="text-align: left">
                                        <img src="./img/torque.png" width="40" height="40" alt="">
                                    </td>
                                    <td style="text-align: center">
                                        <a><i id="" class="fa fa-plus-square-o" style="color: #444E66;font-size: 35px; height: 35px; display: inline-block; vertical-align: middle;"></i></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td><input class="form-check-input" type="checkbox" name="" id="02" value="0" style="zoom:1.0; vertical-align: middle"></td>
                                    <td>2</td>
                                    <td>program-2</td>
                                    <td>00</td>
                                    <td>1800 &#186;</td>
                                    <td style="text-align: left">
                                        <img src="./img/torque.png" width="40" height="40" alt="">
                                        <img src="./img/angle.png" width="40" height="40" alt="">
                                        <img src="./img/torque.png" width="40" height="40" alt="">
                                    </td>
                                    <td style="text-align: center">
                                        <a><i id="" class="fa fa-plus-square-o" style="color: #444E66;font-size: 35px; height: 35px; display: inline-block; vertical-align: middle;"></i></a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
        </div>
    </div>

    <!-- New Program -->
    <div id="ProgramNew" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 70%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('ProgramNew').style.display='none'"
                    class="w3-button w3-red w3-display-topright" style="width: 60px; height: 58px; font-size: 30px">&times;</span>
                    <h3>New Program</h3>
                </header>

                <div class="modal-body">
                    <form id="new_task_form">
                        <div style="padding-left: 5%; background-color: #D9D9D9">
                            <div class="row t1">
                                <div class="col-4 t1" for="">Program ID :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="program-id" class="form-control input-ms" value="1" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1" for="">Program Name :</div>
                                <div class="col-4 t2">
                                    <input type="text" id="program-name" class="form-control input-ms" value="Program-1" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1">The First Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="the-first-step" class="form-control input-ms" value="1" min="0" max="5" step="1">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1">The Second Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="the-second-step" class="form-control input-ms" value="0" min="0" max="5">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1">The Third Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="the-third-step" class="form-control input-ms" value="0" min="0" max="5">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1">The Fourth Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="the-fourth-step" class="form-control input-ms" value="0" min="0" max="5">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1">The Fifth Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="the-fifth-step" class="form-control input-ms" value="0" min="0" max="5">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-4 t1" style="font-size: 20px">REC Laps(1-5) :</div>
                                <div class="col t2">
                                    <div class="col form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="" id="" value="0"style="zoom:1.2; vertical-align: middle">
                                    </div>
                                    <div class="col form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="" id="" value="0"style="zoom:1.2; vertical-align: middle">
                                    </div>
                                    <div class="col form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="" id="" value="0"style="zoom:1.2; vertical-align: middle">
                                    </div>
                                    <div class="col form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="" id="" value="0"style="zoom:1.2; vertical-align: middle">
                                    </div>
                                    <div class="col form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="" id="" value="1" style="zoom:1.2; vertical-align: middle">
                                    </div>
                                </div>
                            </div>                        
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button-modal" onclick="myFunction(true)">Save</button>
                    <button id="button2" class="button-modal" onclick="document.getElementById('ProgramNew').style.display='none'" class="cancelbtn">Cancel</button>
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
                    class="w3-button w3-red w3-display-topright" style="width: 60px; height: 58px; font-size: 30px">&times;</span>
                    <h3>Copy Program</h3>
                </header>

                <div class="modal-body">
                    <form id="copy_Pro_form" style="padding-left: 3%">
                        <div class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_from_text'];?></b></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_pro_id" class="col-5 t1">Program ID :</div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_pro_id" disabled>
        				        </div>
        				    </div>
                            <div class="row">
                                <div for="from_pro_name" class="col-5 t1">Program Name :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="from_pro_name" disabled>
                                </div>
                            </div>
                        </div>

                        <div for="from_pro_id" class="col" style="font-size: 20px; margin: 5px 0px 5px"><b>Copy To</b></div>
                        <div style="padding-left: 20px;">
                            <div class="row">
                                <div for="to_pro_id" class="col-5 t1">Program ID :</div>
                				<div class="col-5 t2">
                				    <input type="text" class="form-control" id="to_pro_id">
                				</div>
            				</div>
                            <div class="row">
                                <div for="to_pro_name" class="col-5 t1">Program Name :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="to_Program_name">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button-modal" onclick="myFunction(true)">Save</button>
                    <button id="button2" class="button-modal" onclick="document.getElementById('CopyProgram').style.display='none'" class="cancelbtn">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    

<script>
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


// Get the modal
var modal = document.getElementById('ProgramNew');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}

// Change rows backgroud color
document.addEventListener("DOMContentLoaded", function() {
    var tbody = document.getElementById("tbody");
    var rows = tbody.getElementsByTagName("tr");

    for (var i = 0; i < rows.length; i++) {
        rows[i].addEventListener("click", function() {
            // Reset color for all rows
            for (var j = 0; j < rows.length; j++) {
                rows[j].style.backgroundColor = "";
            }

            // Set color for the clicked row
            this.style.backgroundColor = "#9AC0CD";
        });
    }
});
</script>

</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>