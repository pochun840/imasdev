<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/monitor.css" type="text/css">

<?php echo $data['nav']; ?>

<style>
.t1{font-size: 17px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 17px; margin: 3px 0px;}
.t3{font-size: 17px; margin: 3px 0px; height: 29px;border-radius: 5px;}
</style>

<div class="container-ms">
    <header>
        <div class="monitor">
            <img id="header-img" src="./img/monitor-head.svg">&nbsp; Monitor
        </div>
        <div class="notification">
            <i style="width:auto; height:40px" class="fa fa-bell" onclick="ClickNotification()"></i>
            <span id="messageCount" class="badge"></span>
        </div>
        <div class="personnel"><i style="width:auto; height: 40px;font-size: 26px" class="fa fa-user"></i> Esther</div>
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
                <div class="navbutton active" onclick="handleButtonClick(this, 'monitor')">
                    <span data-content="<?php echo $text['main_monitor_text'];?>" onclick="showContent('monitor')"></span>
                    <?php echo $text['main_monitor_text'];?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'station_setting')">
                    <span data-content="<?php echo $text['station_setting_text'];?>" onclick="showContent('station_setting')"></span>
                    <?php echo $text['station_setting_text'];?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'station_rule')">
                    <span data-content="<?php echo $text['station_rule_text'];?>" onclick="showContent('station_rule')"></span>Station Rule
                    <?php echo $text['station_rule_text'];?>
                </div>
            </div>

            <!-- Monitor -->
            <div id="monitorContent" class="content" style="height: calc(100vh - 60px);">
                <div id="MonitorDisplay" style="margin-top: 40px">
                    <div class="container-ms" style="padding-left: 0%;vertical-align: middle;">
                        <div class="scrollbar-station-all" id="style-station-all">
                            <div class="force-overflow-station-all">
                                <div class="scrollbar-monitor-station" id="style-monitor-station">
                                    <div class="force-overflow-monitor-station">
                                        <div class="gallery" style="margin-bottom: 5px;">
                                            <div class="station" tabindex="1">
                                                <label style="background: #14A800; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A1</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                                <div class="overlay"><?php echo $text['station_fastening_text'];?></div>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #14A800; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A2</div>
                                                    <div>123***</div>
                                                    <div>aa-bb-01</div>
                                                    <div>05/30</div>
                                                    <div>1.5.N.m</div>
                                                    <div>Peter</div>
                                                </label>
                                                <div class="overlay"><?php echo $text['station_fastening_text'];?></div>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #E9A759;color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A3</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>04/24</div>
                                                    <div>1.N.m</div>
                                                    <div>Mary</div>
                                                </label>
                                                <div class="overlay"><?php echo $text['station_standby_text'];?></div>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA;color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A4</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/36</div>
                                                    <div>1.5.N.m</div>
                                                    <div>Peter</div>
                                                </label>
                                                <div class="overlay"><?php echo $text['station_offline_text'];?></div>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #A1E959;color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A5</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/40</div>
                                                    <div>1.5.N.m</div>
                                                    <div>Luke</div>
                                                </label>
                                                <div class="overlay"><?php echo $text['station_connect_text'];?></div>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A6</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A7</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A8</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A9</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A10</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>00/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="scrollbar-monitor-station" id="style-monitor-station">
                                    <div class="force-overflow-monitor-station">
                                        <div class="gallery" style="margin-bottom: 5px;">
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A1</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A2</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Peter</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A3</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Mary</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A4</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.5.N.m</div>
                                                    <div>Peter</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A5</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.5.N.m</div>
                                                    <div>Luke</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A6</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A7</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A8</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A9</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">
                                                    <div>station A10</div>
                                                    <div>12345***</div>
                                                    <div>aa-cc-0001</div>
                                                    <div>01/20</div>
                                                    <div>1.N.m</div>
                                                    <div>Esther</div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div style="float: right"><button id="open-station" class="SettingButton" type="button"><?php echo $text['open_station_text'];?></button></div>

                    <div id="Monitor_table_setting" style="margin-top: 5px">
                        <div class="scrollbar-monitor" id="style-monitor">
                            <div class="force-overflow-monitor">
                                <table class="table table-bordered table-hover" id="table-monitor" >
                                    <thead id="header-table">
                                        <tr style="text-align: center">
                                            <th width="10%"><?php echo $text['station_name_text'];?></th>
                                            <th width="10%"><?php echo $text['Torque_text'];?></th>
                                            <th width="10%"><?php echo $text['Angle_text'];?></th>
                                            <th width="10%"><?php echo $text['Status_text'];?></th>
                                            <th width="10%"><?php echo $text['Operator_text'];?></th>
                                            <th width="10%"><?php echo $text['Job_Name_text'];?></th>
                                            <th width="10%"><?php echo $text['job_barcode_text'];?></th>
                                            <th width="10%">Assembly</th>
                                            <th width="10%">Sub</th>
                                            <th width="10%">Controller</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                                        <tr>
                                            <td>A1</td>
                                            <td>1.0</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Esther</td>
                                            <td>aa-cc-0001</td>
                                            <td>12345***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A2</td>
                                            <td>1.5</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Peter</td>
                                            <td>aa-bb-01</td>
                                            <td>123***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A1</td>
                                            <td>1.0</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Esther</td>
                                            <td>aa-cc-0001</td>
                                            <td>12345***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A2</td>
                                            <td>1.5</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Peter</td>
                                            <td>aa-bb-01</td>
                                            <td>123***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A1</td>
                                            <td>1.0</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Esther</td>
                                            <td>aa-cc-0001</td>
                                            <td>12345***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A2</td>
                                            <td>1.5</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Peter</td>
                                            <td>aa-bb-01</td>
                                            <td>123***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A1</td>
                                            <td>1.0</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Esther</td>
                                            <td>aa-cc-0001</td>
                                            <td>12345***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A2</td>
                                            <td>1.5</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Peter</td>
                                            <td>aa-bb-01</td>
                                            <td>123***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A1</td>
                                            <td>1.0</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Esther</td>
                                            <td>aa-cc-0001</td>
                                            <td>12345***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                        <tr>
                                            <td>A2</td>
                                            <td>1.5</td>
                                            <td>42375</td>
                                            <td>OK-job</td>
                                            <td>Peter</td>
                                            <td>aa-bb-01</td>
                                            <td>123***</td>
                                            <td>assy-00-5</td>
                                            <td>20235252</td>
                                            <td>---</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Station Setting -->
            <div id="station_settingContent" class="content" style="display: none; height: calc(100vh - 60px); ">
                <div id="StationSettingDisplay" style="margin-top: 40px">
                    <div class="topnav-menu">
                        <div class="topnav-right">
                            <button id="Add_Rows" type="button" class="SettingButton" onclick="addGallery()"><?php echo $text['add_rows_text'];?></button>
                            <button id="Delete_Station" type="button" class="SettingButton"><?php echo $text['delete_station_text'];?></button>
                        </div>
                    </div>

                    <div class="container-ms" style="padding-left: 0%;vertical-align: middle;">
                        <div class="scrollbar-station-all" id="style-station-all">
                            <div class="force-overflow-station-all">

                                <div class="scrollbar-monitor-station" id="style-monitor-station">
                                    <div id="addrows" class="force-overflow-monitor-station">
                                        <div class="gallery" style="margin-bottom: 5px;">
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #00DCFA;color: #fff; text-align: left;">
                                                    <div>station A3</div>
                                                    <div>192.168.0.0</div>
                                                    <div>---</div>
                                                    <div>---</div>
                                                    <div>---</div>
                                                    <div>----</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #00DCFA;color: #fff; text-align: left;">
                                                    <div>station A4</div>
                                                    <div>192.168.0.1.</div>
                                                    <div>---</div>
                                                    <div>---</div>
                                                    <div>---</div>
                                                    <div>---</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #00DCFA;color: #fff; text-align: left;">
                                                    <div>station A5</div>
                                                    <div>192.168.0.2</div>
                                                    <div>---</div>
                                                    <div>----</div>
                                                    <div>---</div>
                                                    <div>---</div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                       <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="station" tabindex="1">
                                                <label style="background: #BDBABA; color: #fff; text-align: left;">
                                                    <div style="display: flex; justify-content: center;">
                                                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="Station_setting-Table" style="margin-top: 5px">
                        <div class="scrollbar-Station" id="style-Station">
                            <div class="force-overflow-Station">
                                <table class="table table-bordered table-hover" id="table-Station" >
                                    <thead id="header-table">
                                        <tr style="text-align: center">
                                            <th width="5%">ID</th>
                                            <th width="15%"><?php echo $text['station_name_text'];?></th>
                                            <th width="15%">IP</th>
                                            <th width="10%"><?php echo $text['Operator_text'];?></th>
                                            <th width="8%"><?php echo $text['Job_Name_text'];?></th>
                                            <th width="15%"><?php echo $text['job_barcode_text'];?></th>
                                            <th width="20%">Assembly</th>
                                            <th width="8%">Sub</th>
                                            <th width="5%" style="font-size: 24px" onclick="document.getElementById('Add_Field').style.display='block'">&#43;</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                                        <tr>
                                            <td>1</td>
                                            <td>A3</td>
                                            <td>192.168.0.111</td>
                                            <td>Luke</td>
                                            <td>aa-cc-0001</td>
                                            <td>12345***</td>
                                            <td>--</td>
                                            <td>--</td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Station Modal -->
                <div id="Add_Station" class="modal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content w3-animate-zoom" style="width: 60%">
                            <header class="w3-container modal-header">
                                <span onclick="document.getElementById('Add_Station').style.display='none'"
                                    class="w3-button w3-red w3-display-topright" style="padding: 7px; width: 60px; font-size: 23px">&times;</span>
                                <h3><?php echo $text['add_station_text'];?></h3>
                            </header>
                            <div class="modal-body" style="padding-left: 10%">
                                <div class="row">
                                    <div class="col-4 t1"><?php echo $text['station_id_text'];?> :</div>
                                    <div class="col-3 t2">
                                        <label class="form-check-label" style="padding-left: 12%">1</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 t1"><?php echo $text['station_name_text'];?> :</div>
                                    <div class="col-5 t2">
                                        <input type="text" class="t3 form-control input-ms" id="station-name" maxlength="">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 t1"><?php echo $text['station_name_text'];?> :</div>
                                    <div class="col-5 t2">
                                        <input type="text" class="t3 form-control input-ms" id="station-ip" maxlength="">
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="Operator" class="col-4 t1"><?php echo $text['Operator_text'];?> :</div>
                                    <div class="option-custom col-2 t2">
                                        <div class="select-input select-input-multiple form-control input-ms">
                                            <div class="selected-list" id="selectedNamesOperator"></div>
                                            <div class="select-click" id="selectClickOperator"></div>
                                        </div>
                                        <div class="select-list" id="selectListOperator">
                                            <div class="select-item" data-value="1">Esther</div>
                                            <div class="select-item" data-value="2">Peter</div>
                                            <div class="select-item" data-value="3">Mary</div>
                                            <div class="select-item" data-value="4">Luke</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div for="Job" class="col-4 t1"><?php echo $text['job_select_text'];?> :</div>
                                    <div class="option-custom col-2 t2">
                                        <div class="select-input select-input-multiple form-control input-ms">
                                            <div class="selected-list" id="selectedNamesJob"></div>
                                            <div class="select-click" id="selectClickJob"></div>
                                        </div>
                                        <div class="select-list" id="selectListJob">
                                            <div class="select-item" data-value="1">aa-cc - 123***</div>
                                            <div class="select-item" data-value="2">Job-2 - 234**</div>
                                            <div class="select-item" data-value="3">Job-3</div>
                                            <div class="select-item" data-value="4">Job-abc</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="w3-center" style="background-color: #F2F1F1">
                                <button id="btn-save" class="saveButton"><?php echo $text['Save_text'];?></button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Field Modal -->
                <div id="Add_Field" class="modal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content w3-animate-zoom" style="width: 80%">
                            <header class="w3-container modal-header">
                                <span onclick="document.getElementById('Add_Field').style.display='none'"
                                    class="w3-button w3-red w3-display-topright" style="padding: 7px; width: 60px; font-size: 23px">&times;</span>
                                <h3>Add Field</h3>
                            </header>
                            <div class="modal-body" style="padding-left: 10%">
                                <div class="row">
                                    <div class="col-4 t1">Field Name :</div>
                                    <div class="col-5 t2">
                                        <input type="text" class="t3 form-control input-ms" id="field-name" maxlength="">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 t1">Number of unit :</div>
                                    <div class="col input-group">
                                        <input type="number" id="unitNumber" class="t3 form-control" min="0" max="10" value="0">
                                        <button class="t3 btn" id="addFieldsBtn">Add Fields</button>
                                    </div>

                                    <div id="fieldContainer"></div>
                                </div>
                            </div>
                            <div class="w3-center" style="background-color: #F2F1F1">
                                <button id="btn-save" class="saveButton">Save</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Station Rule -->
            <div id="station_ruleContent" class="content" style="display: none">
                <div id="StationRuleDisplay" style="margin-top: 40px">

                </div>
            </div>
        </div>
    </div>

<style type="text/css">
.selected
{
    background-color: #9AC0CD !important;
}

./*selected :hover{
    background-color: #9AC0CD;
}*/
</style>

<script>
/// Onclick event for row background color
$(document).ready(function () {
    // Call highlight_row function with table id
    highlight_row('table-monitor');
    highlight_row('table-Station');
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
var modal = document.getElementById('Add_Station');
var modal = document.getElementById('Add_Field');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}



// Add Field
document.getElementById('addFieldsBtn').addEventListener('click', function() {
    var unitNumber = parseInt(document.getElementById('unitNumber').value);
    var fieldContainer = document.getElementById('fieldContainer');

    // Clear existing fields
    fieldContainer.innerHTML = '';

    // Add fields based on selected number of units
    for (var i = 0; i < unitNumber; i++) {
        var inputField = document.createElement('input');
        inputField.type = 'text'; // Change type to text
        inputField.value = '';
        inputField.setAttribute('name', 'unit_' + (i + 1)); // Set unique name for each field
        fieldContainer.appendChild(inputField);
    }
});

// Input Select
document.addEventListener('DOMContentLoaded', function()
{
    var selectedNamesOperator = document.getElementById('selectedNamesOperator');
    var selectedNamesJob = document.getElementById('selectedNamesJob');
    var selectClickOperator = document.getElementById('selectClickOperator');
    var selectClickJob = document.getElementById('selectClickJob');
    var selectListOperator = document.getElementById('selectListOperator');
    var selectListJob = document.getElementById('selectListJob');

    selectClickOperator.addEventListener('click', function() {
        if (selectListOperator.style.display === 'none' || selectListOperator.style.display === '') {
            selectListOperator.style.display = 'block';
        } else {
            selectListOperator.style.display = 'none';
        }
});

    selectListOperator.addEventListener('click', function(event) {
        var target = event.target;
        if (target.classList.contains('select-item')) {
            var name = target.textContent;
            var value = target.getAttribute('data-value');
            var selectedName = document.createElement('div');
            selectedName.classList.add('selected-item');
            selectedName.setAttribute('data-value', value);
            selectedName.innerHTML = '<span>' + name + '</span><span class="removeBtn"><i class="fa fa-times" style="font-size:16px;"></i></span>';
            selectedNamesOperator.appendChild(selectedName);
            selectListOperator.style.display = 'none';

            var removeBtn = selectedName.querySelector('.removeBtn');
            removeBtn.addEventListener('click', function() {
                selectedName.parentNode.removeChild(selectedName);
            });
        }
    });

    selectClickJob.addEventListener('click', function() {
        if (selectListJob.style.display === 'none' || selectListJob.style.display === '') {
            selectListJob.style.display = 'block';
        } else {
            selectListJob.style.display = 'none';
        }
    });

    selectListJob.addEventListener('click', function(event) {
        var target = event.target;
        if (target.classList.contains('select-item')) {
            var name = target.textContent;
            var value = target.getAttribute('data-value');
            var selectedName = document.createElement('div');
            selectedName.classList.add('selected-item');
            selectedName.setAttribute('data-value', value);
            selectedName.innerHTML = '<span>' + name + '</span><span class="removeBtn"><i class="fa fa-times" style="font-size:16px;"></i></span>';
            selectedNamesJob.appendChild(selectedName);
            selectListJob.style.display = 'none';

            var removeBtn = selectedName.querySelector('.removeBtn');
            removeBtn.addEventListener('click', function() {
                selectedName.parentNode.removeChild(selectedName);
            });
        }
    });

});


// Add Rows
function addGallery()
{
    var newGallery = document.createElement('div');
    newGallery.className = 'gallery';
    newGallery.style.marginBottom = '5px';


    for (var i = 0; i < 10; i++) {
        var newStation = document.createElement('div');
        newStation.className = 'station';
        newStation.tabIndex = '1';
        newStation.style.marginRight = '9px';
        newStation.style.marginBottom = '7px';
        newStation.innerHTML = `
            <div class="station" tabindex="1">
                <label style="background: #BDBABA; color: #fff; text-align: left;">
                    <div style="display: flex; justify-content: center;">
                        <img id="Add-Station" src="./img/add-station.png" onclick="document.getElementById('Add_Station').style.display='block'">
                    </div>
                </label>
            </div>
            `;
        newGallery.appendChild(newStation);
    }

    var addrows = document.getElementById('addrows');
    addrows.appendChild(newGallery);
}
</script>
</div>
<?php require APPROOT . 'views/inc/footer.tpl'; ?>