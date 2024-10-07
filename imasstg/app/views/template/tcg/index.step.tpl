<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/tcg_step.css" type="text/css">

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
        <label type="text" style="font-size: 22px; margin: 8px;">Step-TCG</label>
        <div class="topnav-right">
            <button class="btn" id="back-btn" type="button" onclick="location.href = '?url=Templates/';">
                <img id="img-back" src="./img/back.svg" alt="">back
            </button>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="row" style="margin-bottom: 5px;padding-left: 3%">
                <div class="col-1 t1">Program ID:</div>
                <div class="col-1 t2" style="margin-right: 3%">
                    <input type="text" class="form-control input-ms" id="Program_ID" value="1" maxlength="" disabled="disabled">
                </div>

                <div class="col-2 t1">Program Name:</div>
                <div class="col-2 t2" style="margin-right: 3%">
                    <input type="text" class="form-control input-ms" id="Program_Name" value="Program-1" maxlength="" disabled="disabled" style="margin-left: -40%">
                </div>

                <div class="col">
                    <button id="add-step" type="button" onclick="document.getElementById('StepNew').style.display='block'">
                        <img id="img-add" src="./img/add-step.svg" alt="">Add Step
                    </button>

                    <button id="copy-step" type="button" onclick="document.getElementById('Copystep').style.display='block'">
                        <img id="img-copy" src="./img/step-copy.svg" alt="">Copy
                    </button>

                    <button id="delete-step" type="button" >
                        <img id="img-delete" src="./img/step-delete.svg" alt="">Delete
                    </button>
                </div>
            </div>

            <div class="scrollbar" id="style-steptable">
                <div class="force-overflow">
                    <table class="table table-bordered" id="table">
                        <thead id="header-table" style="background-color: #A3A3A3; font-size: 2vmin">
                            <tr style="text-align: center; vertical-align: middle;">
                                <th width="5%"></th>
                                <th width="8%">Step No</th>
                                <th width="10%">Target Torque</th>
                                <th width="10%">Target Angle</th>
                                <th width="10%">Hi Torque</th>
                                <th width="10%">Lo Torque</th>
                                <th width="10%">Hi Angle</th>
                                <th width="10%">Lo Angle</th>
                                <th width="10%">Edit</th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                            <tr>
                                <td>
                                    <input class="form-check-input" type="checkbox" name="" id="02" value="0" style="zoom:1.0; vertical-align: middle">
                                </td>
                                <td>1</td>
                                <td>10.2 kgf.cm</td>
                                <td>1800&#186;</td>
                                <td>12.2 kgf.cm</td>
                                <td>3 kgf.cm</td>
                                <td>1800&#186;</td>
                                <td>400&#186;</td>
                                <td style="text-align: center">
                                    <img src="./img/angle.png" width="40" height="40" alt="" onclick="document.getElementById('StepEdit').style.display='block'">
                                </td>
                            </tr>
                            <tr>
                                <td><input class="form-check-input" type="checkbox" name="" id="02" value="0" style="zoom:1.0; vertical-align: middle">
                            </td>
                                <td>2</td>
                                <td>12.2/kgf.cm</td>
                                <td>1800&#186;</td>
                                <td>13.2 kgf.cm</td>
                                <td>3 kgf.cm</td>
                                <td>1800&#186;</td>
                                <td>600&#186;</td>
                                <td style="text-align: center">
                                    <img src="./img/torque.png" width="40" height="40" alt="">
                                </td>
                             </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

     <!-- New Step -->
    <div id="StepNew" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width:90%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('StepNew').style.display='none'"
                    class="w3-button w3-red w3-display-topright" style="width: 60px; height: 58px; font-size: 30px">&times;</span>
                    <h3>New Step</h3>
                </header>

                <div class="modal-body">
                    <form id="new_step_form">
                        <div style="padding-left: 2%">
                            <div class="row t1">
                                <div class="col-2 t1" for="">Program ID :</div>
                                <div class="col-2 t2">
                                    <input type="text" id="program-id" class="form-control input-ms" value="1" maxlength="" disabled="disabled">
                                </div>
                                <div class="col-3 t1" for="">Program Name :</div>
                                <div class="col-3 t2">
                                    <input type="text" id="program-name" class="form-control input-ms" value="Program-1" maxlength="" disabled="disabled">
                                </div>
                            </div>
                        </div>

                        <div style="padding-left: 5%; background-color: #D9D9D9">
                            <div class="row t1">
                                <div class="col-3 t1" for="">Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="program-id" class="form-control input-ms" value="1" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">Step Name :</div>
                                <div class="col-4 t2">
                                    <input type="text" id="program-name" class="form-control input-ms" value="Step-1" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">RPM :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="rpm" class="form-control input-ms" value="100" maxlength="">
                                </div>
                                <div class="col t2">max rpm 1100</div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Direction :</div>
                                <div class="col-4 t2">
                   					<select id="Direction">
                  					    <option value="0">CW</option>
                   					    <option value="1">CCW</option>
                       				</select>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Target :</div>
                                <div class="col-4 t2">
                   					<select id="Target1">
                  					    <option value="0">Thread</option>
                   					    <option value="1">Torque</option>
                       				</select>
                                </div>
                            </div>
                            <div class="row t1" id="thread-row1">
                                <div class="col-3 t1" for="">Thread Condition :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="thread-condition" class="form-control input-ms" value="10.0" maxlength="">
                                </div>
                            </div>
                            <div class="row t1" id="torque-row1">
                                <div class="col-3 t1" for="">Torque Condition :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="torque-condition" class="form-control input-ms" value="10.00" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">Delay Time :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="delay-time" class="form-control input-ms" value="0.0" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Hi Thread :</div>
                                <div class="col-4 t2">
                                    <input id="hi-thread" type="number" value="0.0" class="form-control input-ms" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Lo Thread :</div>
                                <div class="col-4 t2">
                                    <input id="lo-thread" type="number" value="0.0" class="form-control input-ms" maxlength="">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-3 t1" for="">Hi Torque :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="hi-torque" class="form-control input-ms" value="0.0" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">Lo Torque :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="Lo-torque" class="form-control input-ms" value="0.0" maxlength="">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button-modal" onclick="myFunction(true)">Save</button>
                    <button id="button2" class="button-modal" onclick="document.getElementById('StepNew').style.display='none'" class="cancelbtn">Cancel</button>
                </div>
            </div>
        </div>
    </div>

     <!-- Edit Step -->
    <div id="StepEdit" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width:90%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('StepEdit').style.display='none'"
                    class="w3-button w3-red w3-display-topright" style="width: 60px; height: 58px; font-size: 30px">&times;</span>
                    <h3>Edit Step</h3>
                </header>

                <div class="modal-body">
                    <form id="new_step_form">
                        <div style="padding-left: 2%">
                            <div class="row t1">
                                <div class="col-2 t1" for="">Program ID :</div>
                                <div class="col-2 t2">
                                    <input type="text" id="program-id" class="form-control input-ms" value="1" maxlength="" disabled="disabled">
                                </div>
                                <div class="col-3 t1" for="">Program Name :</div>
                                <div class="col-4 t2">
                                    <input type="text" id="program-name" class="form-control input-ms" value="Program-1" maxlength="" disabled="disabled">
                                </div>
                            </div>
                        </div>

                        <div style="padding-left: 5%; background-color: #D9D9D9">
                            <div class="row t1">
                                <div class="col-3 t1" for="">Step :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="program-id" class="form-control input-ms" value="1" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">Step Name :</div>
                                <div class="col-4 t2">
                                    <input type="text" id="program-name" class="form-control input-ms" value="Step-1" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">RPM :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="rpm" class="form-control input-ms" value="100" maxlength="">
                                </div>
                                <div class="col t2">max rpm 1100</div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Direction :</div>
                                <div class="col-4 t2">
                   					<select id="Direction">
                  					    <option value="0">CW</option>
                   					    <option value="1">CCW</option>
                       				</select>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Target :</div>
                                <div class="col-4 t2">
                   					<select id="Target2">
                  					    <option value="0">Thread</option>
                   					    <option value="1">Torque</option>
                       				</select>
                                </div>
                            </div>
                            <div class="row t1" id="thread-row2">
                                <div class="col-3 t1" for="">Thread Condition :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="thread-condition" class="form-control input-ms" value="10.0" maxlength="">
                                </div>
                            </div>
                            <div class="row t1" id="torque-row2">
                                <div class="col-3 t1" for="">Torque Condition :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="torque-condition" class="form-control input-ms" value="10.00" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">Delay Time :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="delay-time" class="form-control input-ms" value="0.0" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Hi Thread :</div>
                                <div class="col-4 t2">
                                    <input id="hi-thread" type="number" value="0.0" class="form-control input-ms" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1">Lo Thread :</div>
                                <div class="col-4 t2">
                                    <input id="lo-thread" type="number" value="0.0" class="form-control input-ms" maxlength="">
                                </div>
                            </div>

                            <div class="row t1">
                                <div class="col-3 t1" for="">Hi Torque :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="hi-torque" class="form-control input-ms" value="0.0" maxlength="">
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col-3 t1" for="">Lo Torque :</div>
                                <div class="col-4 t2">
                                    <input type="number" id="Lo-torque" class="form-control input-ms" value="0.0" maxlength="">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button-modal" onclick="myFunction(true)">Save</button>
                    <button id="button2" class="button-modal" onclick="document.getElementById('StepEdit').style.display='none'" class="cancelbtn">Cancel</button>
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
                    class="w3-button w3-red w3-display-topright" style="width: 60px; height: 58px; font-size: 30px">&times;</span>
                    <h3>Copy Step</h3>
                </header>

                <div class="modal-body">
                    <form id="copy_step_form" style="padding-left: 3%">
                        <div class="col" style="font-size: 20px; margin: 5px 0px 5px"><?php echo $text['Copy_from_text'];?></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_step_id" class="col-5 t1">Step ID :</div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_step_id" disabled>
        				        </div>
        				    </div>
                            <div class="row">
                                <div for="from_step_name" class="col-5 t1">Step Name :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="from_step_name" disabled>
                                </div>
                            </div>
                        </div>

                        <div for="from_step_id" class="col" style="font-size: 20px; margin: 5px 0px 5px"><b>Copy To</b></div>
                        <div style="padding-left: 20px;">
                            <div class="row">
                                <div for="to_step_id" class="col-5 t1">Step ID :</div>
                				<div class="col-5 t2">
                				    <input type="text" class="form-control" id="to_step_id">
                				</div>
            				</div>
                            <div class="row">
                                <div for="to_step_name" class="col-5 t1">Step Name :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="to_step_name">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button-modal" onclick="myFunction(true)">Save</button>
                    <button id="button2" class="button-modal" onclick="document.getElementById('Copystep').style.display='none'" class="cancelbtn">Cancel</button>
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

///*** change event select target
function handleTargetChange(targetId, threadRowId, torqueRowId) {
    document.getElementById(targetId).addEventListener('change', function() {
        var targetValue = this.value;
        var threadRow = document.getElementById(threadRowId);
        var torqueRow = document.getElementById(torqueRowId);

        if (targetValue == '0') {
            threadRow.style.display = 'flex';
            torqueRow.style.display = 'none';
        } else {
            threadRow.style.display = 'none';
            torqueRow.style.display = 'flex';
        }
    });

    // Trigger the change event on page load to set the initial state
    document.getElementById(targetId).dispatchEvent(new Event('change'));
}

// Attach event listeners for each set of elements
handleTargetChange('Target1', 'thread-row1', 'torque-row1');
handleTargetChange('Target2', 'thread-row2', 'torque-row2');


</script>

</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>