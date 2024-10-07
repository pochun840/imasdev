<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/monitor.css" type="text/css">

<link href="<?php echo URLROOT; ?>css/select2.min.css" rel="stylesheet" />
<script src="<?php echo URLROOT; ?>js/select2.min.js"></script>

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

            <?php
                // <!-- Monitor -->
                if(file_exists('../app/views/'.$data['div_monitor'].'.tpl')){
                    require_once '../app/views/'.$data['div_monitor'].'.tpl';
                }
                // <!-- Station Setting -->
                if(file_exists('../app/views/'.$data['div_station'].'.tpl')){
                    require_once '../app/views/'.$data['div_station'].'.tpl';
                }
                // <!-- Station Rule -->
                if(file_exists('../app/views/'.$data['div_rule'].'.tpl')){
                    require_once '../app/views/'.$data['div_rule'].'.tpl';
                }
                
            ?>
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

</script>
</div>
<?php require APPROOT . 'views/inc/footer.tpl'; ?>