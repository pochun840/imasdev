<?php require APPROOT . 'views/inc/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/setting.css" type="text/css">
<?php echo $data['nav']; ?>
<div class="container-ms">

    <header>
        <div class="setting">
            <img id="header-img" src="./img/setting-head.svg"> <?php echo $text['main_setting_text']; ?>
        </div>

        <div class="notification">
            <i style="width:auto; height:40px" class="fa fa-bell" onclick="ClickNotification()"></i>
            <span id="messageCount" class="badge"></span>
        </div>
        <div class="personnel"><i style="width:auto; height: 40px; font-size: 26px" class="fa fa-user"></i> <?php echo $_SESSION['user']; ?></div>
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
                        <a>Controller:GTCS has...........</a>
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
                <div class="navbutton active" onclick="handleButtonClick(this, 'operation')">
                    <span data-content="<?php echo $text['Operation_Setting_text']; ?>" onclick="showContent('operation')"></span><?php echo $text['Operation_Setting_text']; ?>
                </div>

                <div class="navbutton" onclick="handleButtonClick(this, 'system_setting')">
                    <span data-content="<?php echo $text['System_Setting_text']; ?>" onclick="showContent('system_setting')"></span><?php echo $text['Import/Export_Setting_text']; ?>
                </div>

                <div class="navbutton" onclick="handleButtonClick(this, 'import_export_setting')">
                    <span data-content="<?php echo $text['Import/Export_Setting_text']; ?>" onclick="showContent('import_export_setting')"></span><?php echo $text['Import/Export_Setting_text']; ?>
                </div>
            </div>

            <!-- Operation Setting -->
            <div id="operationContent" class="content">
                <div id="Operation_Setting" style="margin-top: 40px">
                    <div class="t1">
                        <div class="col-4 t2" style="font-weight: bold;margin-top: 15px"><?php echo $text['Manager_Verify_text']; ?>:</div>

                        <?php foreach ($data['all_roles'] as $key => $value) {
                            echo '<div class="t2 form-check form-check-inline">';
                            if (in_array($value['ID'], $data['button_auth']['role_checked'])) {
                                echo '<input class="form-check-input" type="checkbox" name="manager_role" id="Leader'.$key.'" value="'.$value['ID'].'" style="zoom:1.1; vertical-align: middle;" checked>';
                            }else{
                                echo '<input class="form-check-input" type="checkbox" name="manager_role" id="Leader'.$key.'" value="'.$value['ID'].'" style="zoom:1.1; vertical-align: middle">';
                            }

                            echo '<label class="form-check-label" for="Leader'.$key.'">'.$value['Title'].'</label>';
                            echo '</div>';
                        }?>
                    </div>
                    <div class="row t1">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Skip_Button_Access_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="switch_next_seq" type="checkbox" <?php if($data['button_auth']['switch_next_seq']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>
                    <div class="row t1">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Back_Button_Access_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="switch_previous_seq" type="checkbox" <?php if($data['button_auth']['switch_previous_seq']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>
                    <div class="row t1">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Task_Reset_Button_Access_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="task_reset" type="checkbox" <?php if($data['button_auth']['task_reset']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>

                    <div class="row t1" style="">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Job_Selection_Access_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="switch_job" type="checkbox" <?php if($data['button_auth']['switch_job']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>
                    <div class="row t1" style="padding-bottom: 2%">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Seq_Selection_Access_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="switch_seq" type="checkbox" <?php if($data['button_auth']['switch_seq']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>
                    <div class="row t1">
                        <div class="col-4 t3" style="padding-left: 0%; font-weight: bold"><?php echo $text['Stop_On_NG_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="stop_on_ng" type="checkbox" <?php if($data['button_auth']['stop_on_ng']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>

                    <div class="t1">
                        <div class="col-3 t2" style="font-weight: bold;margin-top: 15px"><?php echo $text['Sensor_Enable_Step_text']; ?>:</div>
                    </div>
                    <div class="row t1">
                        <div class="col-4 t2" style="padding-left: 5%;font-weight: bold"><?php echo  $text['Automatic Speech_Setting_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="auto_switch" type="checkbox" <?php if($data['button_auth']['auto_switch']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>

                    <div class="t1">
                        
                        <div class="col-4 t2" style="padding-left: 6%">
                            <img id="img-audio" src="./img/audio.png" href="#"onclick="showModal(); return false;" style="height: 40px; width: 40px">
                            <a style="text-decoration: none; color: inherit;" ><?php echo $text['Voice_Playback_Sound_text']; ?>:</a>
                        </div>

                        <?php foreach ($data['count_gender'] as $key => $value) {
                            echo '<div class="t2 form-check form-check-inline">';
                            if($key == $data['button_auth']['gender_switch']) {
                                echo '<input class="form-check-input" type="radio" name="gender_switch" id="gender'.$key.'" value="'.$key.'" style="zoom:1.1; vertical-align: middle;" checked>';
                            } else {
                                echo '<input class="form-check-input" type="radio" name="gender_switch" id="gender'.$key.'" value="'.$key.'" style="zoom:1.1; vertical-align: middle">';
                            }
                            echo '<label class="form-check-label" for="gender'.$key.'">'.$text[$value].'</label>';
                            echo '</div>';
                        }?>
                       
                    </div>


                    <div class="row t1">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Tower_Light_Setting_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="tower_light_switch" type="checkbox" <?php if($data['button_auth']['tower_light_switch']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                    </div>
                    <div class="row t1">
                        <div class="col-4 t2" style="padding-left: 5%"><?php echo $text['Buzzer_Setting_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="buzzer_switch" type="checkbox" <?php if($data['button_auth']['buzzer_switch']){ echo 'checked';} ?>>
                            <label><i></i></label>
                        </div>
                        
                    </div>
                </div>
                <button class="saveButton" onclick="save_manager_verify()"><?php echo $text['Save_text']; ?></button>
            </div>
            
            <!-- System Setting -->
            <div id="system_settingContent" class="content" style="display: none">
                <div id="System_Setting" style="margin-top: 40px">

                    <div class="t1">
                        <div class="col-3 t2" style="font-weight: bold;margin-top: 15px"><?php echo $text['select_language_text']; ?>:</div>

                        <?php foreach ($data['language_setting'] as $key => $value) {
                            echo '<div class="t2 form-check form-check-inline">';
                
                            if($key == $data['button_auth']['language_setting']){
                                echo '<input class="form-check-input" type="radio" name="language_setting" id="Leader'.$key.'" value="'.$key.'" style="zoom:1.1; vertical-align: middle;" checked>';
                            }else{
                                echo '<input class="form-check-input" type="radio" name="language_setting" id="Leader'.$key.'" value="'.$key.'" style="zoom:1.1; vertical-align: middle">';
                            }

                            echo '<label class="form-check-label" for="Leader'.$key.'">'.$value.'</label>';
                            echo '</div>';
                        }?>
                    </div>

                    <div class="t1">
                        <div class="col-3 t2" style="font-weight: bold;margin-top: 15px"><?php echo $text['Counting_Method_text']; ?>:</div>

                        <?php foreach ($data['count_method'] as $key => $value) {
                            echo '<div class="t2 form-check form-check-inline">';
                            
                            if($key == $data['button_auth']['count_method_setting']){
                                echo '<input class="form-check-input" type="radio" name="count_method_setting" id="Leader'.$key.'" value="'.$key.'" style="zoom:1.1; vertical-align: middle;" checked>';
                            }else{
                                echo '<input class="form-check-input" type="radio" name="count_method_setting" id="Leader'.$key.'" value="'.$key.'" style="zoom:1.1; vertical-align: middle">';
                            }
                            echo '<label class="form-check-label" for="Leader'.$key.'">'.$text[$value].'</label>';
                            echo '</div>';
                        }?>
                    </div>

                    <div class="t1">
                        <div class="col-2 t2" style="font-weight: bold">Recovery:</div>
                    </div>                    
                    <div class="t1">
                        <div class="col-3 t2" style="margin-left: 1%"> iAMS default setting reset:</div>
                        <div class="switch menu t4" style="width: 60px">
                            <input id="iAMSReset_switch" type="checkbox"} ?>
                            <label><i></i></label>
                        </div>
                    </div>

                    <div class="t1">
                        <div class="col-2 t2" style="font-weight: bold">Plugin:</div>
                    </div>   
                    <div class="scrollbar-plugin" id="style-plugin">
                        <div class="force-overflow-plugin">
                            <div style="padding: 0px 40px">                 
                                <table class="table table-bordered table-hover" id="plugin-table">
                                    <thead id="header-table" style="text-align: center; vertical-align: middle">
                                        <tr>
                                            <th><img id="add_plugin" src="./img/add-plugin.png" onclick="document.getElementById('AddPlugin').style.display='block'"></th>
                                            <th>Device Name</th>
                                            <th>Version</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.8vmin;text-align: center; vertical-align: middle;">
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                        <tr>
                                            <td></td>
                                            <td>GTCS</td>
                                            <td>V.1.1.0</td>
                                            <td>Nov 10.24 10:33</td>
                                        </tr>     
                                    </tbody>
                                </table>
                            </div>
                        </div> 
                    </div>  
            </div>           
                <button class="saveButton" onclick="save_manager_verify_system()"><?php echo $text['Save_text']; ?></button>
            </div>

            <!-- import_export Setting -->
            <div id="import_export_settingContent" class="content" style="display: none">
                <div id="import_export_setting" style="margin-top: 40px">
                <div style="width: 95%">
                    <div class="row t1">
                        <div class="col-3 t1" style="padding-left: 3%;margin-top: 15px"><?php echo $text['Current_iAMS_version_text']; ?>:</div>
                        <div class=" col-1 t2 custom-file">
                            <label>1.00.1</label>
                        </div>
                    </div>
                    <form action="" method="post" enctype="multipart/form-data">
                        <div class="row t1">
                            <div class="col-3 t1" style="padding-left: 3%"><?php echo $text['Export_specific_JOB_data_text']; ?>:</div>
                            <div class="col-4 t2 custom-file">
                                <select id="Export-Job" style="width: 190px">
                                    <option value="1">Job123</option>
                                    <option value="2">Job2</option>
                                    <option value="3">Job6768</option>
                                    <option value="4">Job324</option>
                                </select>
                            </div>
                            <div class="col-1 t2">
                                <button class="ExportButton" id="Export-job-btn"><?php echo $text['Export_text']; ?></button>
                            </div>
                        </div>
                    </form>
    
                    <div class="row t1">
                        <div class="col-7 t1" style="padding-left: 3%"><?php echo $text['Export_iAMS_data_text']; ?>:</div>
                        <div class="col-1 t2">
                            <button class="ExportButton" id="Export-iams-data"><?php echo $text['Export_text']; ?></button>
                        </div>
                    </div>

                    <form action="" method="post" enctype="multipart/form-data">
                        <div class="row t1">
                            <div class="col-3 t1" style="padding-left: 3%"><?php echo $text['Import_specific_JOB_data_text']; ?>:</div>
                            <div class="col-4 t2">
                                <input type="file" name="image" id="Import-Job-Data" class="input-file">
                            </div>
                            <div class="col-1 t2">
                                <button class="ExportButton" id="Import-job-btn"><?php echo $text['Import_text']; ?></button>
                            </div>
                        </div>
                    </form>

                    <form action="" method="post" enctype="multipart/form-data">
                        <div class="row t1">
                            <div class="col-3 t1" style="padding-left: 3%"><?php echo $text['Import_data_text']; ?>:</div>
                            <div class="col-4 t2">
                                <input type="file" name="image" id="Import-Data" class="input-file">
                            </div>
                            <div class="col-1 t2">
                                <button class="ExportButton" id="Import-data-btn"><?php echo $text['Import_text']; ?></button>
                            </div>
                        </div>
                    </form>

                    <form action="" method="post" enctype="multipart/form-data">
                        <div class="row t1">
                            <div class="col-3 t1" style="padding-left: 3%"><?php echo $text['iAMS_Update_text']; ?>:</div>
                            <div class="col-4 t2">
                                <input type="file" name="image" id="iAMS-Update" class="input-file">
                            </div>
                            <div class="col-1 t2">
                                <button class="ExportButton" id="iAMS-Update-btn"><?php echo $text['Update_text']; ?></button>
                            </div>
                        </div>
                    </form>
                    <div class="row t1">
                        <div class="col-3 t2" style="padding-left: 3%;"><?php echo $text['Blackout_Recovery_text']; ?>:</div>
                        <div class="switch menu col-3 t4">
                            <input id="Blackout-Recovery" type="checkbox" checked="checked">
                            <label><i></i></label>
                        </div>
                    </div>
                </div>
                    <button class="saveButton" id="saveButton"><?php echo $text['Save_text']; ?></button>
                </div>
            </div>

            <!-- Add Plugins Modal -->
            <div id="AddPlugin" class="modal" style="top: 20%">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content w3-animate-zoom" style="width: 70%;">
                        <header class="w3-container modal-header">
                            <span onclick="document.getElementById('AddPlugin').style.display='none'"
                                class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                            <h2>Add Plugins</h2>
                        </header>

                        <div class="modal-body">
                            <form id="add_plugins_form">
                                <div style="font-size: 20px; margin: 5px 0px 5px;"><b>Upload new software</b></div>
                                <div class="add-plugin">
                   		            <div class="row" style="width: 230px; height: 210px; background-color: #EEEED1;box-shadow: none; margin-bottom: 10px">
                  				        <div class="col" style="display: flex; flex-direction: column; align-items: center">
                  				            <img src="./img/upload.svg" alt="" style="width: 80px; height: 75px; margin-top: 50px">
                                            <label>upload plugins</label>
                   				        </div>
                   				    </div>
                                </div>
               		            <div class="row" style="box-shadow: none; border: none">
                                    <div class="col-5" style="font-size: 18px; padding-top: 5px">Upload progress: 1/5</div>
               				        <div class="col">
               				            <img id="img-progress" src="./img/progress.svg" alt="" style="font-size:40px; width: 40px; height: 40px">
               				        </div>
              				    </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!----auto 語言包------>
            <div id="auto_language" class="modal" style="display: none;">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content w3-animate-zoom" style="width:100%;">
                        <header class="w3-container modal-header">
                            <span onclick="document.getElementById('auto_language').style.display='none'"
                            class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                            <h3 id="modal_head"></h3>
                        </header>
                        
                        <div class="modal-body">
                                <div id="Torque_Parameter">
                                    <div class="scrollbar-modal" id="style-y">
                                        <div class="modal-force-overflow">
                                               <div class="force-overflow-Audio">
                                               
                                                <?php if(!empty($data['filtered_files'])){?>
                                                    <?php foreach($data['filtered_files'] as $key =>$value){?>
                                                            <div class="toggle-container" style="display: inline-block">
                                                                <span class="toggle-btn gravity-ui--play-fill" onclick="toggleIcon(this, 'audio<?php echo $key; ?>', '<?php echo htmlspecialchars($value, ENT_QUOTES, 'UTF-8'); ?>')"></span>
                                                                <audio id="audio<?php echo $key; ?>">
                                                                    <source src="../public/voice/<?php echo htmlspecialchars($value, ENT_QUOTES, 'UTF-8'); ?>" media="all">
                                                                </audio>
                                                            </div>
                                                            <span class="file-name" style="font-size: 20px; margin-left: 5px;"><?php echo $value;?></span>
                                                             <br>
                                                    <?php } ?>                
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

// END Notification ....................

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
</script>

<script type="text/javascript">
    function save_manager_verify(argument) {

    

        const selectedGender = document.querySelector('input[name="gender_switch"]:checked');
        let gender_switch = selectedGender.value;

        let switch_next_seq = document.getElementById('switch_next_seq').checked;
        let switch_previous_seq = document.getElementById('switch_previous_seq').checked;
        let task_reset = document.getElementById('task_reset').checked;
        let switch_job = document.getElementById('switch_job').checked;
        let switch_seq = document.getElementById('switch_seq').checked;
        let stop_on_ng = document.getElementById('stop_on_ng').checked;
        let auto_switch = document.getElementById('auto_switch').checked;
        

        let tower_light_switch = document.getElementById('tower_light_switch').checked;
        let buzzer_switch = document.getElementById('buzzer_switch').checked;

        let list = document.querySelectorAll("input[name='manager_role']:checked");
        let role_checked = '';
        for (var i = 0; i < list.length; i++) {
            role_checked += list[i].value + ','
        }
        role_checked = role_checked.slice(0, -1);

        $.ajax({
            type: "POST",
            data: {
                'switch_next_seq': +switch_next_seq,
                'switch_previous_seq': +switch_previous_seq,
                'task_reset': +task_reset,
                'switch_job': +switch_job,
                'switch_seq': +switch_seq,
                'stop_on_ng': +stop_on_ng,
                'auto_switch': +auto_switch,
                'gender_switch': +gender_switch,
                'tower_light_switch': +tower_light_switch,
                'buzzer_switch': +buzzer_switch,
                'role_checked': role_checked,
            },
            dataType: "json",
            url: "?url=Settings/Operation_Setting",
        }).done(function(notice) { 
            if (notice.error != '') {} else {
                Swal.fire('Saved!', '', 'success');
                // window.location = window.location.href;
            }
        }).fail(function() {
            // history.go(0);
        });


    }

    function save_manager_verify_system(argument) {

        let list_language = document.querySelectorAll("input[name='language_setting']:checked");
        let language_checked = '';
        for (var i = 0; i < list_language.length; i++) {
            language_checked += list_language[i].value + ','
        }
        language_checked = language_checked.slice(0, -1);

        let list_count_method = document.querySelectorAll("input[name='count_method_setting']:checked");
        let count_method_checked = '';
        for (var i = 0; i < list_count_method.length; i++) {
            count_method_checked += list_count_method[i].value + ','
        }
        countmethod_checked = count_method_checked.slice(0, -1);

         $.ajax({
            type: "POST",
            data: {
                'language_setting': language_checked,
                'count_method_setting': countmethod_checked
            },
            dataType: "json",
            url: "?url=Settings/System_Setting",
        }).done(function(notice) { 
            if (notice.error != '') {} else {
                Swal.fire('Saved!', '', 'success');
                // window.location = window.location.href;
                history.go(0);
            }
        }).fail(function() {
            // history.go(0);
        });

    }

</script>
</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>
<style>
.t1{font-size: 18px; margin: 5px 0px; display: flex; align-items: center; padding-left: 3%}
.t2{font-size: 18px; margin: 5px 0px;}

.t3{font-size: 18px; margin: 5px 0px; display: flex; align-items: center; padding-left: 3%}
.t4{font-size: 15px; margin: 5px 0px;}

.form-check-inline
{
    display: inline-block;
    margin-right: 20px;
}

.toggle-container
{
    border-radius: 50%;
    width: 2.7em;
    height: 2.8em;
    border: 2px solid #ccc;
    padding: 6px;
    margin-bottom: 20px;
    vertical-align: middle;
}
.toggle-container
{
    border-radius: 50%;
    width: 2.7em;
    height: 2.8em;
    border: 2px solid #ccc;
    padding: 6px;
    margin-bottom: 20px;
    vertical-align: middle;
}

.toggle-btn
{
    width: 1.5em;
    height: 1.5em;
    cursor: pointer;
    border-radius: 50%;
    transition: background-color 0.3s ease;
    position: relative;
}

.toggle-btn::before
{
    content: '';
    display: inline-block;
    width: 1.5em;
    height: 1.5em;
    --svg: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%23000' d='M9.5 15.584V8.416a.5.5 0 0 1 .77-.42l5.576 3.583a.5.5 0 0 1 0 .842l-5.576 3.584a.5.5 0 0 1-.77-.42Z'/%3E%3Cpath fill='currentColor' d='M1 12C1 5.925 5.925 1 12 1s11 4.925 11 11s-4.925 11-11 11S1 18.075 1 12m11-9.5A9.5 9.5 0 0 0 2.5 12a9.5 9.5 0 0 0 9.5 9.5a9.5 9.5 0 0 0 9.5-9.5A9.5 9.5 0 0 0 12 2.5'/%3E%3C/svg%3E");
    background-color: currentColor;
    -webkit-mask-image: var(--svg);
    mask-image: var(--svg);
    -webkit-mask-repeat: no-repeat;
    mask-repeat: no-repeat;
    -webkit-mask-size: 100% 100%;
    mask-size: 100% 100%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

.gravity-ui--play-fill
{
    display: inline-block;
    width: 1.6em;
    height: 1.7em;
    --svg: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cg fill='none'%3E%3Cg clip-path='url(%23gravityUiPlayFill0)'%3E%3Cpath fill='%23000' fill-rule='evenodd' d='M14.756 10.164c1.665-.962 1.665-3.366 0-4.329L6.251.918C4.585-.045 2.5 1.158 2.5 3.083v9.834c0 1.925 2.085 3.128 3.751 2.164z' clip-rule='evenodd'/%3E%3C/g%3E%3Cdefs%3E%3CclipPath id='gravityUiPlayFill0'%3E%3Cpath fill='%23000' d='M0 0h16v16H0z'/%3E%3C/clipPath%3E%3C/defs%3E%3C/g%3E%3C/svg%3E");
    background-color: currentColor;
    -webkit-mask-image: var(--svg);
    mask-image: var(--svg);
    -webkit-mask-repeat: no-repeat;
    mask-repeat: no-repeat;
    -webkit-mask-size: 100% 100%;
    mask-size: 100% 100%;
    vertical-align: middle;
}

.line-md--play-filled-to-pause-transition
{
    display: inline-block;
    width: 1.6em;
    height: 1.7em;
    --svg: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cg fill='%23000' stroke='%23000' stroke-linecap='round' stroke-linejoin='round' stroke-width='2'%3E%3Cpath d='M13 15L8 18L8 6L13 9L13 15'%3E%3Canimate fill='freeze' attributeName='d' dur='0.4s' values='M13 15L8 18L8 6L13 9L13 15;M9 18L7 18L7 6L9 6L9 18'/%3E%3C/path%3E%3Cpath d='M13 9L18 12L18 12L13 15L13 9'%3E%3Canimate fill='freeze' attributeName='d' dur='0.4s' values='M13 9L18 12L18 12L13 15L13 9;M15 6L17 6L17 18L15 18L15 6'/%3E%3C/path%3E%3C/g%3E%3C/svg%3E");
    background-color: currentColor;
    -webkit-mask-image: var(--svg);
    mask-image: var(--svg);
    -webkit-mask-repeat: no-repeat;
    mask-repeat: no-repeat;
    -webkit-mask-size: 100% 100%;
    mask-size: 100% 100%;
    vertical-align: middle;
}

.toggle-btn.active
{
    transform: scale(1.2);
}

.toggle-btn
{
    color: #F24E1E;
}

.menubutton
{
    margin-right: 10px;
    border-radius: 5px;
    border: 0px solid #999999;
    font-size: 26px;
    background: none;
    font-weight: bold;
}

</style>

<script>
$(document).ready(function() {
    $('input[name="gender_switch"]').change(function() {
        var selectedValue = $(this).val();
        $.ajax({
            url: '?url=Settings/Voice_Playback_Sound', 
            type: 'POST',
            data: {
                gender: selectedValue
            },
            success: function(response) {
                console.log('Database updated successfully.');
                history.go(0);
            },
            error: function(xhr, status, error) {
                console.error('Failed to update database:', error);
            }
        });
    });
    
});

function toggleIcon(element, audioId, fileName) {
    var audio = document.getElementById(audioId);
    if (element.classList.contains('gravity-ui--play-fill')) {
        element.classList.remove('gravity-ui--play-fill');
        element.classList.add('line-md--play-filled-to-pause-transition', 'active');
        element.style.color = '#3CBA8D';
        audio.play();
    } else 
    {
        element.classList.remove('line-md--play-filled-to-pause-transition', 'active');
        element.classList.add('gravity-ui--play-fill');
        element.style.color = '#F24E1E';
        audio.pause();
    }


    //var fileNameElement = document.querySelector('.file-name');
    //fileNameElement.textContent = fileName;

    audio.addEventListener('ended', function() 
    {
        element.classList.remove('line-md--play-filled-to-pause-transition', 'active');
        element.classList.add('gravity-ui--play-fill');
        element.style.color = '#F24E1E'; 
    });

}

function showModal() 
    {
        document.getElementById('auto_language').style.display = 'block';
    }
</script>