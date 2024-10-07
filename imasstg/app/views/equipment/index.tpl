<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/equipment.css" type="text/css">

<?php echo $data['nav']; ?>

<style>
.t1{font-size: 18px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 18px; margin: 3px 0px; width: 15vw;}

/* Modal add equipment */
.t3{font-size: 17px; margin: 3px 0px; display: flex; align-items: center; padding-left: 3%}
.t4{font-size: 15px; margin: 3px 0px;}
.t5{font-size: 15px; margin: 3px 0px; height: 30px;}

</style>

<div class="container-ms">
    <header>
        <div class="epuipment">
            <img id="header-img" src="./img/equipment-head.svg"><?php echo $text['Equipment_text']; ?>
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

    <div id="Equipment_Setting">
        <div id="add-menu-setting">
            <ul class="menu-add">
                <li style="float: right">
                    <button id="button_AddDevice" type="button">
                        <img id="img-device" src="./img/add-device.svg" alt=""><?php echo $text['Add_Device_text']; ?>
                    </button>

                    <ul class="submenu" style="display:none;">
                        <li><a href="#" class="submenu-item">Kilews GTCS</a></li>
                        <li><a href="#" class="submenu-item">Kilews TCG</a></li>
                        <li><a href="#" class="submenu-item">ARM</a></li>
                        <li><a href="#" class="submenu-item">Recycle box</a></li>
                        <li><a href="#" class="submenu-item">Pick to light</a></li>
                        <li><a href="#" class="submenu-item">Tower light</a></li>
                        <li><a href="#" class="submenu-item">PLC</a></li>
                        <li><a href="#" class="submenu-item">Button</a></li>
                        <li><a href="#" class="submenu-item">Socket selector</a></li>
                        <li><a href="#" class="submenu-item">Socket tray</a></li>
                    </ul>
                </li>
            </ul>
        </div>

        <div class="main-content">
            <div class="scrollbar-epuipment" id="style-epuipment">
                <div class="force-overflow-epuipment">
                    <div class="center-content">
                        <!-- Device GTCS  -->
                        <div class="row epuipment-row">
                            <div class="col-1">
                                <img class="images" src="./img/GTCS.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; font-size:18px; padding-left: 5%">
                                <div style="font-size: 20px"><b>GTCS</b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>
                            <!-- Message  -->
                            <div class="col-4" style="font-size:17px">
                                <form action="" id="device_Status">
                                    <div class="mt-1" style="text-align:left;line-height: 55px; color: #FF6633">
                                    </div>
                                </form>
                            </div>
                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox" checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowDeviceEditSetting()"></i></a>
                            </div>
                        </div>

                        <!-- ARM  -->
                        <div class="row epuipment-row">
                            <div class="col-1">
                                <img class="images" src="./img/ARM.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b><?php echo $text['Arm_text']; ?></b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>
                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="arm_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>
                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox" checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowARMSettingMode()"></i></a>
                            </div>
                        </div>

                        <!-- pick-to-light sensors  -->
                        <div class="row epuipment-row" style="display:none">
                            <div class="col-1">
                                <img class="images" src="./img/ep_picture.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b>pick-to-light sensors</b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Tool_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox" checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowPickToLightSettingMode()"></i></a>
                            </div>
                        </div>

                        <!-- Tower light sensors  -->
                        <div class="row epuipment-row">
                            <div class="col-1">
                                <img class="images" src="./img/light.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b><?php echo $text['Tower_Light_sensors_text']; ?></b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Tool_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox" checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowTowerLightSettingMode()"></i></a>
                            </div>
                        </div>

                        <!-- PLC Input Output  -->
                        <div class="row epuipment-row" style="display:none">
                            <div class="col-1">
                                <img class="images" src="./img/ep_picture.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b>PLC</b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Tool_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox" checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowPLCSettingMode()"></i></a>
                            </div>
                        </div>

                        <!-- KL-TCG  -->
                        <div class="row epuipment-row" style="display:none">
                            <div class="col-1">
                                <img class="images" src="./img/ep_picture.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b>KL-TCG</b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="KL-TCG_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox" checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit"></i></a>
                            </div>
                        </div>


                        <!-- Recycle box  -->
                        <div class="row epuipment-row" style="display:none">
                            <div class="col-1">
                                <img class="images" src="./img/ep_picture.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b>Recycle box</b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Recycle-box_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox"  checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowRecycleboxSettingMode()"></i></a>
                            </div>
                        </div>

                        <!-- Socket tray  -->
                        <div class="row epuipment-row">
                            <div class="col-1">
                                <img class="images" src="./img/socket tray.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b><?php echo $text['Socket_Tray_text']; ?></b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Recycle-box_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox"  checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowSockettraySettingMode()"></i></a>
                            </div>
                        </div>


                        <!-- id card  -->
                        <div class="row epuipment-row">
                            <div class="col-1">
                                <img class="images" src="./img/id_card.png" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b><?php echo $text['id_card_text']; ?></b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Recycle-box_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox"  checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick=""></i></a>
                            </div>
                        </div>

                        <!-- KTM   -->
                        <div class="row epuipment-row">
                            <div class="col-1">
                                <img class="images" src="" alt="">
                            </div>
                            <div class="col-3" style="line-height: 32px; padding-left: 5%">
                                <div style="font-size: 20px"><b><?php echo "KTM"; ?></b></div>
                                <div>V.1.1.0</div>
                                <!-- <div>Nov 11.23 10:55</div> -->
                            </div>

                            <!-- Message  -->
                            <div class="col-4" style="font-size:18px">
                                <form action="" id="Recycle-box_Status">
                                    <div class="mt-1" style="text-align: center;line-height: 55px">
                                        ---
                                    </div>
                                </form>
                            </div>

                            <div class="col">
                                <div class="simple-toggle">
                                    <label class="tgl" style="font-size:28px; float: right;">
                                        <input type="checkbox"  checked />
                                        <span data-on="&#10003;" data-off="&#10005;"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="col">
                                <a><i id="Remove" class="fa fa-minus-square-o"></i></a>
                                <a><i id="Edit" class="fa fa-edit" onclick="ShowKtmSettingMode()"></i></a>
                            </div>
                        </div>


                    </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php
        if(file_exists('../app/views/'.$data['div_device'].'.tpl')){
            require_once '../app/views/'.$data['div_device'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_arm'].'.tpl')){
            require_once '../app/views/'.$data['div_arm'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_picktolight'].'.tpl')){
            require_once '../app/views/'.$data['div_picktolight'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_tower_light'].'.tpl')){
            require_once '../app/views/'.$data['div_tower_light'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_plc_io'].'.tpl')){
            require_once '../app/views/'.$data['div_plc_io'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_recycle_box'].'.tpl')){
            require_once '../app/views/'.$data['div_recycle_box'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_socket_tray'].'.tpl')){
            require_once '../app/views/'.$data['div_socket_tray'].'.tpl';
        }
        if(file_exists('../app/views/'.$data['div_add_device_modal'].'.tpl')){
            require_once '../app/views/'.$data['div_add_device_modal'].'.tpl';
        }

        if(file_exists('../app/views/'.$data['div_ktm'].'.tpl')){
            require_once '../app/views/'.$data['div_ktm'].'.tpl';
        }
    ?>

<script>
/// Modal Add Equipment
    var modal = document.getElementById("myModal");

    var closeBtn = document.getElementsByClassName("close")[0];

    var submenuItems = document.getElementsByClassName("submenu-item");

    Array.from(submenuItems).forEach(function (item) {
        item.addEventListener("click", function (event) {
            modal.classList.add("active");
        });
    });

    closeBtn.onclick = function () {
        modal.classList.remove("active");
    }

    window.onclick = function (event) {
        if (event.target == modal) {
            modal.classList.remove("active");
        }
    }
</script>

<script>
// Show Navbutton
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


//  Equipment Setting Mode
function ShowDeviceEditSetting()
{
    // Show Device Setting
    document.getElementById('Device_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}

function ShowARMSettingMode()
{
    // Show ARM Setting
    document.getElementById('ARM_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}

function ShowRecycleboxSettingMode()
{
    // Show Recyclebox Setting
    document.getElementById('RecycleBox_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}

function ShowPickToLightSettingMode()
{
    // Show Pick To Light Setting
    document.getElementById('PickToLight_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}

function ShowTowerLightSettingMode()
{
    // Show Tower Light Setting
    document.getElementById('TowerLight_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}


function ShowPLCSettingMode()
{
    // Show PLC Input Output Setting
    document.getElementById('PLC_In_Out_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}

function ShowSockettraySettingMode()
{
    // Show Socket tray Setting
    document.getElementById('SocketTray_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}

function ShowKtmSettingMode()
{
    // Show Socket tray Setting
    document.getElementById('Ktm_Edit_Setting').style.display = 'block';

    // Hide Equipment Setting
    document.getElementById('Equipment_Setting').style.display = 'none';
}


function cancelSetting()
{
    var EquipmentSetting = document.getElementById('Equipment_Setting');
    var DeviceSetting = document.getElementById('Device_Edit_Setting');
    var ARMSetting = document.getElementById('ARM_Edit_Setting');
    var RecycleBoxSetting = document.getElementById('RecycleBox_Edit_Setting');
    var PickToLightSetting = document.getElementById('PickToLight_Edit_Setting');
    var TowerLightSetting = document.getElementById('TowerLight_Edit_Setting');
    var PLCSetting = document.getElementById('PLC_In_Out_Setting');
    var SockettraySetting = document.getElementById('SocketTray_Edit_Setting');
    var KtmSetting = document.getElementById('Ktm_Edit_Setting');

    // Check the current state and toggle accordingly
    if (DeviceSetting.style.display === 'block')
    {
        // If DeviceSetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        DeviceSetting.style.display = 'none';
    }
    else if (ARMSetting.style.display === 'block')
    {
        // If ARMSetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        ARMSetting.style.display = 'none';
    }
    else if (RecycleBoxSetting.style.display === 'block')
    {
        // If RecycleBoxSetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        RecycleBoxSetting.style.display = 'none';
    }
    else if (PickToLightSetting.style.display === 'block')
    {
        // If PickToLightSetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        PickToLightSetting.style.display = 'none';
    }
    else if (TowerLightSetting.style.display === 'block')
    {
        // If TowerLightSetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        TowerLightSetting.style.display = 'none';
    }
    else if (PLCSetting.style.display === 'block')
    {
        // If PLCSetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        PLCSetting.style.display = 'none';
    }
    else if (SockettraySetting.style.display === 'block')
    {
        // If SockettraySetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        SockettraySetting.style.display = 'none';
    }

     else if (KtmSetting.style.display === 'block')
    {
        // If SockettraySetting is currently displayed, switch to EquipmentSetting
        EquipmentSetting.style.display = 'block';
        KtmSetting.style.display = 'none';
    }

    else
    {
        // If EquipmentSetting is currently displayed or both are hidden, do nothing or handle it as needed
    }
}

// Warning alert
document.addEventListener("DOMContentLoaded", function()
{
    document.getElementById('alert').style.display = 'block';
    setTimeout(function()
    {
        document.getElementById('alert').style.display = 'none';
    }, 5000);
});


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

</script>

</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>