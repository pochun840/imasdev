<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/historical.css" type="text/css">

<script src="<?php echo URLROOT; ?>js/flatpickr.js"></script>


<?php echo $data['nav']; ?>

<style>
.t1{font-size: 17px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 17px; margin: 3px 0px;}
.t3{font-size: 17px; margin: 3px 0px; height: 29px;border-radius: 5px;}
.t4{font-size: 17px; margin-right: 5px; border-radius: 5px}
.t5{margin-left: 10px; text-align: center;}
.t6{width: 116px;margin-right:10%}

</style>

<div class="container-ms">
    <header>
        <div class="historical">
            <img id="header-img " src="./img/historical-head.svg"> historical Record
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
                <div class="navbutton active" onclick="handleButtonClick(this, 'fastening')">
                    <span data-content="Fastening Record" onclick="showContent('fastening')"></span>Fastening Record
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'workflowlog')">
                    <span data-content="Work Flow Log" onclick="showContent('workflowlog')"></span>Work Flow Log
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'useraccess')">
                    <span data-content="User Access Logging" onclick="showContent('useraccess')"></span>User Access Logging
                </div>
            </div>

            <!-- Fastening Setting -->
            <div id="fasteningContent" class="content">
                <div id="FasteningDisplay" style="margin-top: 40px">
                    <div style="padding-left: 2%">
                        <div class="row">
                            <div for="SN" class="col-1 t1">SN</div>
                            <div class="col-2 t2">
                                <input type="text" class="t3 form-control input-ms" id="SN" maxlength="" style="width: 190px;">
                            </div>

                            <div for="Operator" class="col-1 t1">Operator</div>
                            <div class="col-2 t2">
                                <input type="text" class="t3 form-control input-ms" id="Operator" maxlength="" value="" style="width: 190px;">
                            </div>

                            <div for="SelectJob" class="col-1 t1">Select Job</div>
                            <div class="col-2 t3">
                                <input type="text" class="t3 form-control input-ms" id="JobSelect" style="width: 190px;" placeholder="Click here.." onfocus="openModal('JobSelect')" onclick="this.blur()">
                            </div>
                        </div>

                        <div class="row">
                            <div for="Barcode" class="col-1 t1">BarcodeSN</div>
                            <div class="col-2 t2">
                                <input type="text" class="t3 form-control input-ms" id="barcode-sn" maxlength="" value="" style="width: 190px;">
                            </div>
                            <div class="col-1 t1" for="FromDate">From</div>
                            <div class="col-2 t1">
                                <input type="datetime-local" class="t3" id="FromDate" name="FromDate" style="width: 190px;border-radius: 5px;border: 1px solid #CCCCCC; ">
                            </div>

                            <div class="col-1 t1" for="ToDate">To</div>
                            <div class="col-2 t1">
                                <input type="datetime-local" class="t3" id="ToDate" name="ToDate" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;">
                            </div>
                        </div>

                        <div class="row">
                            <div for="result-status" class="col-1 t1">Result Status</div>
                            <div class="col-2 t2">
                                <select id="result-status" style="width: 190px">
                                    <option value="1">ALL</option>
                                    <option value="2">OK</option>
                                    <option value="3">OKALL</option>
                                    <option value="4">NG</option>
                                </select>
                            </div>

                            <div for="Controller" class="col-1 t1">Equipment</div>
                            <div class="col-2 t3">
                                <select id="Controller" style="width: 190px;">
                                    <option value="1">GTCS</option>
                                    <option value="2">TCG</option>
                                </select>
                            </div>

                            <div for="Program" class="col-1 t1">Program</div>
                            <div class="col-2 t3">
                                <select id="Program" style="width: 190px;">
                                    <option value="1">P1</option>
                                    <option value="2">P2</option>
                                    <option value="2">P3</option>
                                    <option value="2">P4</option>
                                    <option value="2">P5</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="topnav-menu">
                        <div class="search-container">
                            <form>
                                <input type="text" placeholder="Search.." name="search" size="40" style="height: 35px">&nbsp;
                                <button id="Search" type="submit" class="Search-button">Search</button>
                            </form>
                        </div>
                        <div class="topnav-right">
                            <button id="Export-CSV" type="button" class="ExportButton">Export CSV</button>
                            <button id="Export-Report" type="button" class="ExportButton">Export Report</button>
                            <button id="Combine-btn" type="button" onclick="NextToCombineData()">Combine Data</button>
                            <button id="Clear" type="button">Clear</button>
                        </div>
                    </div>

                    <div class="scrollbar-fastening" id="style-fastening">
                        <div class="force-overflow-fastening">
                            <table class="table table-bordered table-hover" id="fastening-table">
                                <thead id="header-table" style="text-align: center; vertical-align: middle">
                                    <tr>
                                        <th><i class="fa fa-trash-o" style="font-size:20px;color:black"></i></th>
                                        <th>Index</th>
                                        <th>Time</th>
                                        <th>Station</th>
                                        <th>BarcodeSN</th>
                                        <th>Job Name</th>
                                        <th>Seq Name</th>
                                        <th>Task</th>
                                        <th>Equipment</th>
                                        <th>Torque range</th>
                                        <th>Angle range</th>
                                        <th>Final Torque</th>
                                        <th>Final Angle</th>
                                        <th>Status</th>
                                        <th>Error</th>
                                        <th>Program</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>

                                <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.5vmin;text-align: center; vertical-align: middle;">
                                    <tr>
                                        <td style="text-align: center;">
                                            <input class="form-check-input" type="checkbox" name="" id="" value="0" style="zoom:1.2;vertical-align: middle;">
                                        </td>
                                        <td>1</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station1</td>
                                        <td>123456</td>
                                        <td>job-1</td>
                                        <td>seq-1</td>
                                        <td>task-1</td>
                                        <td>GTCS</td>
                                        <td>9.5~10.9</td>
                                        <td>100000~1100000</td>
                                        <td>10.3 kgf.cm</td>
                                        <td>223 deg</td>
                                        <td style="background-color: #99CC66; font-size: 20px">OK</td>
                                        <td>--</td>
                                        <td>p1</td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="NextToInfo()">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;">
                                            <input class="form-check-input" type="checkbox" name="" id="" value="0" style="zoom:1.2;vertical-align: middle;">
                                        </td>
                                        <td>2</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station2</td>
                                        <td>12344678</td>
                                        <td>job-1</td>
                                        <td>seq-2</td>
                                        <td>task-2</td>
                                        <td>GTCS</td>
                                        <td>9.5~10.9</td>
                                        <td>100000~1100000</td>
                                        <td>5.3 kgf.cm</td>
                                        <td>500000 deg</td>
                                        <td style="background-color: red; font-size: 20px">NG</td>
                                        <td>error</td>
                                        <td>p1</td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="NextToInfo()">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;">
                                            <input class="form-check-input" type="checkbox" name="" id="" value="0" style="zoom:1.2;vertical-align: middle;">
                                        </td>
                                        <td>3</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station3</td>
                                        <td>12344678</td>
                                        <td>job-1</td>
                                        <td>seq-3</td>
                                        <td>task-2</td>
                                        <td>GTCS</td>
                                        <td>9.5~10.9</td>
                                        <td>100000~1100000</td>
                                        <td>10.3 kgf.cm</td>
                                        <td>1000 deg</td>
                                        <td style="background-color: #FFCC00; font-size: 20px">OKALL</td>
                                        <td>--</td>
                                        <td>p1</td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="NextToInfo()">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;">
                                            <input class="form-check-input" type="checkbox" name="" id="" value="0" style="zoom:1.2;vertical-align: middle;">
                                        </td>
                                        <td>4</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station4</td>
                                        <td>12344678</td>
                                        <td>job-1</td>
                                        <td>seq-4</td>
                                        <td>task-2</td>
                                        <td>GTCS</td>
                                        <td>9.5~10.9</td>
                                        <td>100000~1100000</td>
                                        <td>10.3 kgf.cm</td>
                                        <td>1000 deg</td>
                                        <td style="background-color: #007AB8; font-size: 20px">Reverse</td>
                                        <td>--</td>
                                        <td>p1</td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="NextToInfo()">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Click Detail Fastening Record Info -->
                <div id="DetailInfoDisplay" style="display: none">
                    <div class="topnav">
                        <label type="text" style="font-size: 18px; padding-left: 1%; margin: 4px">Fastenig record &#62; Info</label>
                        <button id="back-setting" type="button" onclick="cancelSetting()">
                            <img id="img-back" src="./img/back.svg" alt="">Back
                        </button>
                    </div>

                    <table class="table" style="font-size: 15px; border-collapse: collapse;">
                        <tr>
                            <td>Index : 1</td>
                            <td>BarcodeSN : 123456</td>
                            <td>Time : 08/03/2024 13:50:00</td>
                            <td>Operator : Esther</td>
                            <td>Equipment : GTCS</td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>Final Torque : 10.3 kgf.cm</td>
                            <td>Torque range : 9.5 ~ 10.9</td>
                            <td>Final Angle : 10000</td>
                            <td>Angle range : 1000000 ~ 1100000</td>
                            <td>Direction : CCW</td>
                            <td>Error code : error</td>
                        </tr>
                        <tr style="vertical-align: middle;">
                            <td>Job : job-1</td>
                            <td>Seq/task : seq-1/task-1</td>
                            <td>Program : p2</td>
                            <td>Note : arm(559,583)[200]</td>
                            <td>Status : <a style="background-color: #99CC66; padding: 0 10px">OK</a></td>
                            <td>
                                <input class="form-check-input" type="checkbox" name="" id="" value="0" style="zoom:1.2; float: left">&nbsp; display the high/low auxiliary lines.
                            </td>
                        </tr>

                        <tr style="vertical-align: middle">
                            <td>
                                Chart :  <select id="Chart-seting" class="t6 Select-All" style="float: none">
                                                    <option value="1">Torque/Time</option>
                                                    <option value="2">Angle/Time</option>
                                                    <option value="3">RPM/Time</option>
                                                    <option value="4">Power/Time</option>
                                                    <option value="5">Torque/Angle</option>
                                                </select>
                            </td>
                            <td>
                                Torque Unit:    <select id="Torque-Unit" class="Select-All" style="float: none; width: 100px">
                                                    <option value="2">N.m</option>
                                                    <option value="1">Kgf.m</option>
                                                    <option value="2">Kgf.cm</option>
                                                    <option value="2">In.lbs</option>
                                                </select>
                            </td>
                            <td>
                                Angle:  <select id="Angle" class="t6 Select-All" style="float: none; width: 100px">
                                            <option value="1">Total angle</option>
                                            <option value="2">Task angle</option>
                                        </select>
                            </td>
                            <td>
                                Sampling:  <select id="SelectOutputSampling" class="t6 Select-All" style="float: none; width: 100px">
                                            <option value="1">1(ms)</option>
                                            <option value="2">0.5(ms)</option>
                                        </select>
                            </td>
                            <td>
                                <button id="Export-Excel" type="button" class="ExportButton" style="margin-top: 0">Export Excel</button>
                                <button id="Save-info" type="button" style="margin-top: 0">Save</button>
                            </td>
                            <td></td>
                        </tr>
                    </table>

                    <div>
                        <div style="text-align: center">
                            <label style="float: left"><b>Diagram Display</b></label>
                            <label>Torque / Time</label>
                        </div>
                        <div id="chart-setting">
                            <div class="chart-container">
                                <div class="menu-chart" onclick="toggleMenu()">
                                    <i class="fa fa-bars" style="font-size: 26px"></i>
                                    <div class="menu-content" id="myMenu">
                                        <a href="#" onclick="viewFullScreen()" class="view-fullscreen">View in full screen</a>
                                        <a href="#" onclick="closeFullScreen()" style="display: none">Close full screen</a>
                                        <a href="#" onclick="printChart()">Print chart</a>
                                        <a href="#" onclick="downloadPng()">Download PNG</a>
                                        <a href="#" onclick="downloadJpeg()">Download JPEG</a>
                                    </div>
                                </div>

                                <svg viewBox="0 0 500 300">
                                    <!-- Draw X and Y axes -->
                                    <line class="axis-x" x1="50" y1="215" x2="550" y2="215" />
                                    <line class="axis-y" x1="50" y1="215" x2="50" y2="40" />

                                    <!-- Draw grid lines on Y-axis -->
                                    <line class="grid-line" x1="50" y1="190" x2="500" y2="190" />
                                    <line class="grid-line" x1="50" y1="160" x2="500" y2="160" />
                                    <line class="grid-line" x1="50" y1="130" x2="500" y2="130" />
                                    <line class="grid-line" x1="50" y1="100" x2="500" y2="100" />
                                    <line class="grid-line" x1="50" y1="70" x2="500" y2="70" />
                                    <line class="grid-line" x1="50" y1="40" x2="500" y2="40" />

                                    <!-- Draw Torque values -->
                                    <text x="30" y="15" text-anchor="end">Torques</text>

                                    <text x="40" y="40" text-anchor="end">0.7 N.m</text>
                                    <text x="40" y="70" text-anchor="end">0.6 N.m</text>
                                    <text x="40" y="100" text-anchor="end">0.5 N.m</text>
                                    <text x="40" y="130" text-anchor="end">0.3 N.m</text>
                                    <text x="40" y="160" text-anchor="end">0.3 N.m</text>
                                    <text x="40" y="190" text-anchor="end">0.3 N.m</text>

                                    <!-- Draw Count values -->
                                    <text x="50" y="233" text-anchor="middle">0</text>
                                    <text x="115" y="233" text-anchor="middle">100</text>
                                    <text x="185" y="233" text-anchor="middle">200</text>
                                    <text x="245" y="233" text-anchor="middle">300</text>
                                    <text x="305" y="233" text-anchor="middle">400</text>
                                    <text x="365" y="233" text-anchor="middle">500</text>
                                    <text x="435" y="233" text-anchor="middle">600</text>
                                    <text x="495" y="233" text-anchor="middle">700</text>

                                    <text x="540" y="245" text-anchor="middle">Time</text>
                                    <!-- Draw the line chart -->
                                    <path class="line" d="M50 190 L150 180 L240 130 L350 158 L420 100 L530 60"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Click Combine Data -->
                <div id="CombineDataDisplay" style="display: none">
                    <div class="topnav">
                        <label type="text" style="font-size: 20px; padding-left: 1%; margin: 6px">Fastenig record &#62; Combine data</label>
                        <button id="back-setting" type="button" onclick="cancelSetting()">
                            <img id="img-back" src="./img/back.svg" alt="">Back
                        </button>
                    </div>
                    <div class="topnav-menu" style="background-color: #FFF; margin-top: 3px">
                        <div class="row t1">
                            <div class="col t2 form-check form-check-inline" style="margin-left: 10px">
                                <input class="form-check-input" type="checkbox" checked="checked" name="optioncheck" id="optioncheck" value="0"style="zoom:1.2; vertical-align: middle">
                                <label class="form-check-label" for="optioncheck">display the high/low auxiliary lines.</label>

                                <label style="padding-left: 5%">
                                    Angle : &nbsp;<select id="angle" style="width: 120px">
                                                    <option value="1">total angle</option>
                                                    <option value="2">task angle</option>
                                                  </select>
                                </label>
                                <label style="padding-left: 5%">
                                    Unit :  &nbsp;<select id="unit" style="width: 100px">
                                                    <option value="1">Kgf.m</option>
                                                    <option value="2">N.m</option>
                                                    <option value="2">Kgf.cm</option>
                                                    <option value="2">In.lbs</option>
                                                  </select>
                                </label>
                            </div>
                            <div class="col t2">
                                <button id="Save-combine" type="button">Save</button>
                                <button id="Export-Excel-data" type="button" class="ExportButton">Export Excel</button>
                                <button id="Export-chart" type="button" class="ExportButton">Export PNG</button>
                            </div>
                        </div>
                    </div>

                    <hr class="w3-clear" style="width: 100%">

                    <div class="w3-col">
                        <div class="w3-round" style="margin: 5px 0">
                            <div class="w3-row-padding">
                                <div class="scrollbar-Combine" id="style-Combine">
                                    <div class="force-overflow-Combine">
                                        <div class="w3-half">
                                            <div class="row t1">
                                                <div class="col"> Index : 1</div>
                                                <div class="col"> Time : 13:00</div>
                                                <div class="col"> BarcodeSN : 123456</div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col"> Job : job-1</div>
                                                <div class="col"> Seq/task : seq1/task1</div>
                                                <div class="col"> Program : p1</div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col"> Station : station1</div>
                                                <div class="col"> Equipment : GTCS</div>
                                                <div class="col"> Status : OK</div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col"> Final Torque : 10.3kgf.cm</div>
                                                <div class="col"> Final Angle : 223deg</div>
                                                <div class="col"></div>
                                            </div>
                                            <img src="./img/chart-img.svg" style="width:90%" alt="Northern Lights" class="w3-margin-bottom">
                                        </div>

                                        <div class="w3-half">
                                            <div class="row t1">
                                                <div class="col"> Index : 2</div>
                                                <div class="col"> Time : 14:00</div>
                                                <div class="col"> BarcodeSN : 12344678</div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col"> Job : job-1</div>
                                                <div class="col"> Seq/task : seq2/task2</div>
                                                <div class="col"> Program : p1</div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col"> Station : station2</div>
                                                <div class="col"> Equipment : GTCS</div>
                                                <div class="col"> Status : NG</div>
                                            </div>
                                            <div class="row t1">
                                                <div class="col"> Final Torque : 5.3kgf.cm</div>
                                                <div class="col"> Final Angle : 500000deg</div>
                                                <div class="col"> Error Code : Error</div>
                                            </div>
                                            <img src="./img/chart-img.svg" style="width:90%" alt="Northern Lights" class="w3-margin-bottom">
                                        </div>
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
                                <td>Barcode SN : <input type="text" class="t3" id="superAdmin" maxlength="" style="float: none;width: 190px"></td>
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
                                        <th>Station</th>
                                        <th>BarcodeSN</th>
                                        <th>Job Name</th>
                                        <th>Seq Name</th>
                                        <th>task</th>
                                        <th>Equipment</th>
                                        <th>Event</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody1" style="background-color: #F2F1F1;text-align: center; font-size: 1.8vmin; vertical-align: middle;">
                                    <tr>
                                        <td>1</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station1</td>
                                        <td>567678</td>
                                        <td>job-1</td>
                                        <td>seq-1</td>
                                        <td>task-1</td>
                                        <td>GTCS</td>
                                        <td style="text-align: left">
                                            <a class="biliboard no-underline">9.5~10.9</a>
                                            <a class="biliboard no-underline">1000000~1100000</a>
                                            <a class="biliboard no-underline">10.3 kgf.cm</a>
                                            <a class="biliboard no-underline">10000 Deg</a>
                                            <a class="biliboard no-underline" style=" padding: 5px 10px">p1</a>
                                            <a class="biliboard no-underline" style=" padding: 5px 10px; background-color: #99CC66">OK</a>
                                        </td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="WorkFlowLogInfo()">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station1</td>
                                        <td>567678</td>
                                        <td>job-1</td>
                                        <td>seq-2</td>
                                        <td>task-2</td>
                                        <td>GTCS</td>
                                        <td style="text-align: left">
                                            <a class="biliboard no-underline">9.5~10.9</a>
                                            <a class="biliboard no-underline">1000000~1100000</a>
                                            <a class="biliboard no-underline">10.3 kgf.cm</a>
                                            <a class="biliboard no-underline">50000 Deg</a>
                                            <a class="biliboard no-underline">error: Hi Angle</a>
                                            <a class="biliboard no-underline" style=" padding: 5px 10px">p1</a>
                                            <a class="biliboard no-underline" style=" padding: 5px 10px; background-color: red">NG</a>
                                        </td>
                                        <td>
                                            <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" onclick="WorkFlowLogInfo()">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>2024/02/01 13:30:20</td>
                                        <td>Station1</td>
                                        <td>123456</td>
                                        <td>job-1</td>
                                        <td>seq-3</td>
                                        <td>task-3</td>
                                        <td>Button</td>
                                        <td style="text-align: left">
                                            <a class="biliboard no-underline">230</a>
                                            <a class="biliboard no-underline">800</a>
                                            <a class="biliboard radialp1 no-underline" style="padding: 5px 10px; background-color: #99CC66">OK</a>
                                        </td>
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
                    <table style="font-size: 15px; padding: 5px; margin-top: 5px; margin-left: 2%; width: 80%">
                        <tr>
                            <td>Index : 1</td>
                            <td>BarcodeSN : 123456</td>
                            <td>Time : 08/03/2024 13:50:00</td>
                            <td>Operator : Esther</td>
                            <td>Equipment : Button</td>
                            <td>Note : hahahaha</td>
                        </tr>
                        <tr>
                            <td>Job : job-1</td>
                            <td>Seq/task : seq-1/task-1</td>
                            <td>Program : p1</td>
                            <td>Curren Count : 230</td>
                            <td>Total Count : 800</td>
                            <td>Status : <a style="background-color: #99CC66; padding: 0 10px">OK</a></td>
                        </tr>
                    </table>
                    <hr style="width: 100%; height: 4px;">
                    <b style="font-size: 20px">Diagram Display</b>
                    <div class="w3-center">
                        <img src="./img/pick-A-screw.svg" style=" height: 40vh; width: 70vw" alt="Nature" class="w3-margin-bottom">
                    </div>

                    <button class="Save-button" id="saveButton">Save</button>
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
                                    <th>Member Name</th>
                                    <th>Page</th>
                                    <th>Type</th>
                                    <th>Event</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="tbody1" style="background-color: #F2F1F1;text-align: center; font-size: 1.8vmin; vertical-align: middle;">
                                <tr>
                                    <td>1</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Jimmy</td>
                                    <td style="text-align: left">Home</td>
                                    <td style="text-align: left">Admin login</td>
                                    <td style="text-align: left">
                                        <a class="biliboard no-underline">admin login</a>
                                        <a class="biliboard no-underline">Jimmy</a>
                                        <a class="biliboard no-underline">*****</a>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Jimmy</td>
                                    <td style="text-align: left">Operation</td>
                                    <td style="text-align: left">Workflow</td>
                                    <td style="text-align: left">
                                        <a class="biliboard no-underline">fastening record</a>
                                        <a class="biliboard no-underline">9.5~10.9</a>
                                        <a class="biliboard no-underline">1000000~1100000</a>
                                        <a class="biliboard no-underline">10.3 kgf.cm</a>
                                        <a class="biliboard no-underline">10000 Deg</a>
                                        <a class="biliboard no-underline" style=" padding: 5px 10px">p1</a>
                                        <a class="biliboard no-underline" style=" padding: 5px 10px; background-color: #99CC66">OK</a>
                                    </td>
                                    <td>
                                        <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;">
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Jimmy</td>
                                    <td style="text-align: left">Operation</td>
                                    <td style="text-align: left">Reset Workflow</td>
                                    <td style="text-align: left">
                                        <a class="biliboard no-underline">select job</a>
                                        <a class="biliboard no-underline">job-1</a>
                                        <a class="biliboard no-underline">operation</a>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Esther</td>
                                    <td style="text-align: left">Identification</td>
                                    <td style="text-align: left">Authority change</td>
                                    <td style="text-align: left">
                                        <a class="biliboard no-underline">admin</a>
                                        <a class="biliboard no-underline">job</a>
                                        <a class="biliboard no-underline">read</a>
                                        <a class="biliboard no-underline">write</a>
                                        <a class="biliboard no-underline">load</a>
                                        <a class="biliboard no-underline">save</a>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>5</td>
                                    <td>2024/02/19 13:30:20</td>
                                    <td>Esther</td>
                                    <td style="text-align: left">Home</td>
                                    <td style="text-align: left">Op login</td>
                                    <td style="text-align: left">
                                        <a class="biliboard repeating no-underline">operation login</a>
                                        <a class="biliboard no-underline">admin</a>
                                    </td>
                                    <td></td>
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
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-1" id="Job-1" value="" onclick="JobCheckbox()" style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-1">Job 1</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-2" id="Job-2" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-2">Job 2</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-3" id="Job-3" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-3">Job 3</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-4" id="Job-4" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-4">Job 4</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-5" id="Job-5" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-5">Job 5</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-6" id="Job-6" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-6">Job 6</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-7" id="Job-7" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-7">Job 7</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-8" id="Job-8" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-8">Job 8</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-9" id="Job-9" value=""  style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-9">Job 9</label>
                                </div>
                            </div>
                            <div class="row t1">
                                <div class="col t5 form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="Job-10" id="Job-10" value="" style="zoom:1.0; vertical-align: middle;">&nbsp;
                                    <label class="form-check-label" for="Job-10">Job 10</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-column modalselect">
                    <h4>Sequence</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <div id="Seq-list" style="display: none">
                                <div class="row t1">
                                    <div class="col t5 form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="Seq-1" id="Seq-1" value="" onclick="JobCheckbox()" style="zoom:1.0; vertical-align: middle;">&nbsp;
                                        <label class="form-check-label" for="Seq-1">Seq 1</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-column modalselect">
                    <h4>Task</h4>
                    <div class="scrollbar-jobselect" id="style-jobselect">
                        <div class="force-overflow-jobselect">
                            <div id="Task-list" style="display: none">
                                <div class="row t1">
                                    <div class="col t5">
                                        <label class="form-check-label" for="Task-1">Task 1</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <span class="Save-button" >Save</span>
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

    function JobCheckbox()
    {
        var checkBox1 = document.getElementById("Job-1");
        var text1 = document.getElementById("Seq-list");

        var checkBox2 = document.getElementById("Seq-1");
        var text2 = document.getElementById("Task-list");

        if (checkBox1.checked == true) {
            text1.style.display = "block";
        } else {
            text1.style.display = "none";
        }

        if (checkBox2.checked == true) {
            text2.style.display = "block";
        } else {
            text2.style.display = "none";
        }
    }

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
    document.getElementById('DetailInfoDisplay').style.display = 'block';

    // Hide FasteningDisplay
    document.getElementById('FasteningDisplay').style.display = 'none';
}

// Next To Combine data
function NextToCombineData()
{
    // Show Combine data
    document.getElementById('CombineDataDisplay').style.display = 'block';

    // Hide FasteningDisplay
    document.getElementById('FasteningDisplay').style.display = 'none';
}

function WorkFlowLogInfo()
{
    // Show Work Flow Log Info
    document.getElementById('WorkFlowLogInfoDisplay').style.display = 'block';

    // Hide Work Flow Log
    document.getElementById('WorkFlowLogDisplay').style.display = 'none';
}

function cancelSetting()
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
}


/// Chart menu button setting
window.onload = function()
{
    var fullScreenButton = document.querySelector('.menu-content a[href="#"][onclick="viewFullScreen()"]');
    fullScreenButton.style.display = "block"; // ?n nut Close full screen khi trang ???c t?i l?n ??u
};

function toggleMenu()
{
    var menuContent = document.getElementById("myMenu");
    menuContent.style.display = (menuContent.style.display === "block") ? "none" : "block";

    var fullScreenButton = document.querySelector('.menu-content a[href="#"][onclick="viewFullScreen()"]');
    var closeButton = document.querySelector('.menu-content a[href="#"][onclick="closeFullScreen()"]');

    if (fullScreenButton.style.display === "block")
    {
        fullScreenButton.style.display = "block";
        closeButton.style.display = "none";
    }
    else
    {
        fullScreenButton.style.display = "none";
        closeButton.style.display = "block";
    }
}

function viewFullScreen()
{
    var chartContainer = document.querySelector('.chart-container');
    chartContainer.classList.add('full-screen');

    var fullScreenButton = document.querySelector('.menu-content a[href="#"][onclick="viewFullScreen()"]');
    var closeButton = document.querySelector('.menu-content a[href="#"][onclick="closeFullScreen()"]');

    fullScreenButton.style.display = "none";
    closeButton.style.display = "block";
}

function closeFullScreen()
{
    var chartContainer = document.querySelector('.chart-container');
    chartContainer.classList.remove('full-screen');

    var fullScreenButton = document.querySelector('.menu-content a[href="#"][onclick="viewFullScreen()"]');
    var closeButton = document.querySelector('.menu-content a[href="#"][onclick="closeFullScreen()"]');

    fullScreenButton.style.display = "block";
    closeButton.style.display = "none";
}

function printChart()
{
    // Logic for printing the chart goes here
}

function downloadPng()
{
    // Logic for downloading the chart as PNG goes here
}

function downloadJpeg()
{
    // Logic for downloading the chart as JPEG goes here
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

./*selected :hover{
    background-color: #9AC0CD;
}*/

</style>
<?php require APPROOT . 'views/inc/footer.tpl'; ?>