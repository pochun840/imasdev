<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/program.css" type="text/css">

<?php echo $data['nav']; ?>

<style>
.t1{font-size: 20px; margin: 5px 0px; display: flex; align-items: center;}
.t2{font-size: 18px; margin: 5px 0px;}
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

    <div class="main-content">
        <div class="center-content" style="padding: 20px 100px; padding-left: 18%">
            <div class="Controller-setting">
                <div class="row t1">
                    <div class="col-4 t1"><?php echo $text['Choose_Controller_text']; ?> :</div>
                    <div class="custom-select">
                        <select id="ControllerSelect">
                            <option value="" disabled selected><?php echo $text['Select_text']; ?></option>
                            <option value="<?php echo CONTROLLER_GTCS; ?>"><?php echo CONTROLLER_GTCS; ?></option>
                            <option value="<?php echo CONTROLLER_TCG; ?>"><?php echo CONTROLLER_TCG; ?></option>
                        </select>
                    </div>
                </div>

                <div class="row t1">
                    <div class="col-4 t1"><?php echo $text['Screw_Tool_text']; ?> :</div>
                    <div class="custom-select">
                        <select id="tool_selected" class="selectem">
                            <option value="" disabled selected><?php echo $text['Select_text']; ?></option>
                            <!-- <option value="tool1">SGT-CS303</option> -->
                            <?php 

                                foreach ($data['tools'] as $key => $value) {
                                    if($value['controller'] == "GTCS"){
                                        echo '<option value="'.$value['tool_name'].'">'.$value['tool_name'].'</option>';
                                    }
                                   
                                }
                            ?>
                            <!-- <option value="tool2">3-01007-7L-H</option> -->
                        </select>
                    </div>
                </div>

                <hr>

                <div id="jobTypeContainer">
                    <div class="t1"><?php echo $text['Choose_Mode_combo_text']; ?></div>
                    <div class="row t1">
                        <div class="col-12 t2 radio">
                            <div class="col-12 form-check form-check-inline t1">
                                <label class="form-check-label" for="normal-job">
                                    <input class="form-check-input" id="normal-job" type="radio" name="jobType" value="normal" style="zoom:1; vertical-align: middle">
                                    <?php echo $text['Normal_text']; ?>
                                </label>
                            </div>
                            <div class="col-12 form-check form-check-inline t1">
                                <label class="form-check-label" for="advance-job">
                                    <input class="form-check-input" id="advance-job" type="radio" name="jobType" value="advance" style="zoom:1; vertical-align: middle">
                                    <?php echo $text['Advanced_text']; ?>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="nextButton" id="nextButton" onclick="go_to()"><?php echo $text['Next_text']; ?> &#10144;</button>
            </div>
        </div>
    </div>
<script>
    var tools_info = <?php echo json_encode($data['tools']); ?>;
    $(document).ready(function () {
        //預設帶入GTCS與第一支起子，智能模式
        document.getElementById('ControllerSelect').value = '<?php echo CONTROLLER_GTCS; ?>'
        document.getElementById('tool_selected').selectedIndex = 1
        document.getElementById('normal-job').checked = true
        const event_change = new Event("change"); // 創建一個該元素綁定的事件
        document.getElementById('ControllerSelect').dispatchEvent(event_change);
    });


    document.getElementById('ControllerSelect').addEventListener('change', function () {
        var selectedValue = this.value;
        var jobTypeContainer = document.getElementById('jobTypeContainer');


        // Check if the selected value is "GTCS"
        if (selectedValue === '<?php echo CONTROLLER_GTCS; ?>') {
            // Display the job type container
            jobTypeContainer.style.display = 'block';

            //把 select id="tool_selected" 的option 都空
            var tool_selected = document.getElementById('tool_selected');
            tool_selected.innerHTML = '';

            //tools total(包含了所有的controller)
            var filteredToolsGTCS = removeToolIfController(tools_info, "GTCS");
            //console.log(filteredToolsGTCS);

            for (var tool in filteredToolsGTCS) {
                if (filteredToolsGTCS.hasOwnProperty(tool)) {
                    var option = document.createElement('option'); 
                    option.value = tool; 
                    option.textContent = filteredToolsGTCS[tool].tool_name; 
                    tool_selected.appendChild(option); 
                }
            }


        } else {
            // Hide the job type container if the selected value is different
            jobTypeContainer.style.display = 'none';
            
            //把 select id="tool_selected" 的option 都空
            var tool_selected = document.getElementById('tool_selected');
            tool_selected.innerHTML = '';

            //tools total(包含了所有的controller)
            var filteredToolsTCG = removeToolIfController(tools_info, "TCG");

            for (var tool in filteredToolsTCG) {
                if (filteredToolsTCG.hasOwnProperty(tool)) {
                    var option = document.createElement('option'); 
                    option.value = tool; 
                    option.textContent = filteredToolsTCG[tool].tool_name; 
                    tool_selected.appendChild(option); 
                }
            }

        }

        // Rest of your code (radio buttons creation, etc.)
        // ...
    });

    document.getElementById('nextButton').addEventListener('click', function () {
        // var selectedRadioButton = document.querySelector('input[name="jobType"]:checked');
        // if (selectedRadioButton) {
        //     alert('You selected: ' + selectedRadioButton.value);
        //     // Add code to navigate to the next page or perform other actions
        // } else {
        //     alert('Please select a job type before proceeding.');
        // }
    });
</script>

<script type="text/javascript">
    function go_to(argument) {
        let selectedRadioButton = document.querySelector('input[name="jobType"]:checked');
        let tool_name = document.getElementById('tool_selected').value

        if(tool_name != ''){
            $.ajax({
                url: '?url=Templates/set_tool_cookie', // 
                // async: false,
                method: 'POST',
                data: { 'tool_name':tool_name },
                dataType: "json",
            }).done(function(response) { //成功且有回傳值才會執行

                if(selectedRadioButton.value == 'normal'){
                    location.href = '?url=Templates/normalstep_index/';
                }else if(selectedRadioButton.value == 'advance'){
                    location.href = '?url=Templates/advancedstep_index/';
                }
            }).fail(function() {
                history.go(0);//失敗就重新整理
            });

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


function removeToolIfController(tools,controller_name) {
    var filteredTools = {};  
    for (var tool in tools) {
        //依據  controller_name 的值 檢查 controller 是否匹配
        if (tools[tool].controller === controller_name) {
            filteredTools[tool] = tools[tool];  
        }
    }

    return filteredTools;  
}

</script>

</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>