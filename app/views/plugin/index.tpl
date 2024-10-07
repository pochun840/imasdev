<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/plugin.css" type="text/css">

<?php echo $data['nav']; ?>

<div class="container-ms">

    <header>
        <div class="plugin">
            <img id="header-img" src="./img/plugin-head.svg"><?php echo $text['main_plugins_text']; ?>
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
        <div class="topnav-right">
            <button id="button_AddPlugin" type="button" onclick="document.getElementById('AddPlugin').style.display='block'">
                <img id="img-plugins" src="./img/add-plugins.svg"><?php echo $text['Add_Plugins_text']; ?>
            </button>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="row plugin-row">
                <div class="col-1">
                    <img src="./img/GTCS.png" alt="">
                </div>
                <div class="col-3" style="line-height: 32px; font-size:18px; ; padding-left: 5%">
                    <div style="font-size: 20px"><b>Device</b></div>
                    <div>V.1.1.0</div>
                    <div>Nov 11.23 10:55</div>
                </div>
                <!-- Message  -->
                <div class="col-4" style="line-height: 98px; font-size:18px">
                    <form action="" id="Tool_Status">
                        <div class="mt-3" style="text-align: center;line-height: 55px">
                            ---
                        </div>
                    </form>
                </div>
                <div class="col">
                    <div class="simple-toggle">
                        <label class="tgl" style="font-size:28px; float: right;">
                            <input type="checkbox" checked>
                            <span data-on="&#10003;" data-off="&#10005;"></span>
                        </label>
                    </div>
                </div>

                <div class="col">
                    <a><i id="remove" class="fa fa-minus-square-o"></i></a>
                </div>
            </div>

            <div class="row plugin-row">
                <div class="col-1">
                    <img src="./img/ep_picture.png" alt="">
                </div>
                <div class="col-3" style="line-height: 32px; padding-left: 5%">
                    <div style="font-size: 20px"><b><?php echo $text['Arm_text']; ?></b></div>
                    <div>V.1.1.0</div>
                    <div>Nov 11.23 10:55</div>
                </div>
                <!-- Message  -->
                <div class="col-4" style="line-height: 98px; font-size:18px">
                    <form action="" id="Tool_Status">
                        <div class="mt-3" style="text-align: center;line-height: 55px">
                            ---
                        </div>
                    </form>
                </div>
                <div class="col">
                    <div class="simple-toggle">
                        <label class="tgl" style="font-size:28px; float: right;">
                            <input type="checkbox">
                            <span data-on="&#10003;" data-off="&#10005;"></span>
                        </label>
                    </div>
                </div>

                <div class="col">
                    <label style="float: right"><i id="remove" class="fa fa-minus-square-o"></i></label>
                </div>
            </div>

            <div class="row plugin-row">
                <div class="col-1">
                    <img src="./img/ep_picture.png" alt="">
                </div>
                <div class="col-3" style="line-height: 32px; padding-left: 5%">
                    <div style="font-size: 20px"><b>pick-to-light sensors</b></div>
                    <div>V.1.1.0</div>
                    <div>Nov 11.23 10:55</div>
                </div>
                <!-- Message -->
                <div class="col-4" style="line-height: 98px; font-size:18px">
                    <form action="" id="Tool_Status">
                        <div class="mt-3" style="text-align: center;line-height: 55px">
                            ---
                        </div>
                    </form>
                </div>
                <div class="col">
                    <div class="simple-toggle">
                        <label class="tgl" style="font-size:28px; float: right;">
                            <input type="checkbox" checked>
                            <span data-on="&#10003;" data-off="&#10005;"></span>
                        </label>
                    </div>
                </div>

                <div class="col">
                    <label style="float: right"><i id="remove" class="fa fa-minus-square-o"></i></label>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Plugins Modal -->
    <div id="AddPlugin" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 100%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('AddPlugin').style.display='none'"
                        class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h2><?php echo $text['Add_Plugins_text']; ?></h2>
                </header>

                <div class="modal-body">
                    <form id="add_plugins_form">
                        <div style="font-size: 20px; margin: 5px 0px 5px;"><b><?php echo $text['Upload_new_software_text']; ?></b></div>
                        <div class="add-plugin">
           		            <div class="row" style="width: 230px; height: 210px; background-color: #EEEED1;box-shadow: none; margin-bottom: 10px">
          				        <div class="col" style="display: flex; flex-direction: column; align-items: center">
          				            <img src="./img/upload.svg" alt="" style="width: 80px; height: 75px; margin-top: 50px">
                                    <label><?php echo $text['Upload_plugins_text']; ?></label>
           				        </div>
           				    </div>
                        </div>
       		            <div class="row" style="box-shadow: none; border: none">
                            <div class="col-3" style="margin: 5px; font-size: 18px; padding-top: 5px"><?php echo $text['Upload_progress_text']; ?>: 1/5</div>
       				        <div class="col" style="margin: 5px 0 5px">
       				            <img id="img-progress" src="./img/progress.svg" alt="" style="font-size:40px; width: 40px; height: 40px">
       				        </div>
      				    </div>
                    </form>
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
    let closeBtn = document.getElementsByClassName("close-message")[0];
    messageBox.style.display = (messageBox.style.display === 'block') ? 'none' : 'block';
}

addMessage();



// Get the modal
var modal = document.getElementById('AddPlugin');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

</div>
<?php require APPROOT . 'views/inc/footer.tpl'; ?>