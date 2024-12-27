<?php require APPROOT . 'views/inc/header.tpl'; ?>
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/flatpickr_min.css?v=<?php echo date('YmdHi'); ?>">
<script src="<?php echo URLROOT; ?>js/flatpickr_date.js?v=<?php echo date('YmdHi'); ?>"></script>


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/dataTables.dataTables.css?v=<?php echo date('YmdHi'); ?>">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/select.dataTables.css?v=<?php echo date('YmdHi'); ?>">

<script src="<?php echo URLROOT; ?>js/datatables.min.js?v=<?php echo date('YmdHi'); ?>"></script>

<?php echo $data['nav']; ?>


<div class="container-ms">

    <header>
        <div class="identification">
            <img id="header-img " src="./img/user-head.svg"> <?php echo $text['main_user_text']; ?>
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
        <div class="center-content">
            <div class="wrapper">
                <div class="navbutton" onclick="handleButtonClick(this, 'member')">
                    <span data-content="<?php echo $text['Member_List_text']; ?>" onclick="showContent('member')"></span><?php echo $text['Member_List_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'role')">
                    <span data-content="<?php echo $text['Role_Setting_text']; ?>" onclick="showContent('role')"></span><?php echo $text['Role_Setting_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'station')">
                    <span data-content="<?php echo $text['Station_Setting_text']; ?>" onclick="showContent('station')"></span><?php echo $text['Station_Setting_text']; ?>
                </div>
                <div class="navbutton active" onclick="handleButtonClick(this, 'user_log')">
                    <span data-content="<?php echo 'user log'; ?>" onclick="showContent('user_log')"></span><?php echo 'user log'; ?>
                </div>
            </div>

            <!-- Member List -->
            <div id="" class="content" style=" margin-top: 16px;padding-bottom: 0px; ">
                <div class="input-group mb-2" >
                    <span class="input-group-text">account:</span>
                    <select id="operator" name="operator" class="form-control input-ms" style="margin-right: 7px">
                        <option value="-1"><?php echo $text['Select_text']; ?></option>
                        <?php foreach ($data['all_users'] as $key => $value) {
                            echo '<option value="'.$value['account'].'">'.$value['account'].'</option>';
                        } ?>
                    </select>
                    <span class="input-group-text">action:</span>
                    <select id="action" name="action" class="form-control input-ms" style="margin-right: 7px">
                        <option value="-1"><?php echo $text['Select_text']; ?></option>
                        <option value="job"><?php echo $text['products']; ?></option>
                        <option value="barcode"><?php echo $text['Barcode_text']; ?></option>
                        <option value="seq"><?php echo $text['Seq_text']; ?></option>
                        <option value="task"><?php echo $text['Task_text']; ?></option>
                        <option value="log"><?php echo $text['logins'].'/'.$text['logout_text']; ?></option>
                        <option value="program"><?php echo $text['Program_Template_text']; ?></option>
                        <option value="operation"><?php echo $text['operations']; ?></option>
                        <option value="user"><?php echo $text['users']; ?></option>
                        <option value="setting"><?php echo $text['settings']; ?></option>
                        <option value="monitor"><?php echo $text['monitors']; ?></option>
                        <option value="equipment"><?php echo $text['equipments']; ?></option>
                    </select>
                    <span class="input-group-text">result:</span>
                    <select id="result_type" name="result_type" class="form-control input-ms" style="margin-right: 7px">
                        <option value="-1"><?php echo $text['Select_text']; ?></option>
                        <option value="result-1">success</option>
                        <option value="result-2">fail</option>
                    </select>
                    <span class="input-group-text">ip:</span>
                    <input type="text" class="form-control input-ms" id="ip_filter">
                </div>
                <div class="input-group mb-2" >
                    <span class="input-group-text">From:</span>
                    <input type="text" class="form-control input-ms flatpickr" id="from_date" style="margin-right: 7px;background-color: white">
                    <span class="input-group-text">To:</span>
                    <input type="text" class="form-control input-ms flatpickr" id="to_date" style="margin-right: 7px;background-color: white">
                    <button onclick="search_table()" style="margin-right: 7px;">search</button>
                    <button onclick="clear_condition()">clear</button>
                </div>
            </div>
            <table id="log_item_table" >
                <thead>
                    <tr>
                        <th  style="text-align:center;">id</th>
                        <th >account</th>
                        <th >action</th>
                        <th >result</th>
                        <th >detail</th>
                        <th >ip</th>
                        <th  style="text-align:center;">date</th>
                    </tr>
                </thead>
                <tbody>
                    
                </tbody>
            </table>
           
        </div>
    </div>


<script>
    // Select All
    let selected_row_data;
    $(document).ready(function () {
        flatpickr('.flatpickr', {
            enableTime: true,
            // mode: 'range'
        });

        let table = $('#log_item_table').DataTable( {
            autoWidth: false, // 关闭自动宽度调整
            // fixedHeader: true,
            select: true,
            sort: false,
            // scrollCollapse: true,
            scrollY: 'calc(100vh - 350px)',
            "pageLength": 100,
            language: {
                // info: 'Showing page _PAGE_ of _PAGES_',
                infoEmpty: 'No records available',
                infoFiltered: '(filtered from _MAX_ total records)',
                lengthMenu: 'Display _MENU_ records per page',
                zeroRecords: 'Nothing found - sorry',
                search: "Search:",
            },
            columnDefs: [
                { targets: '_all', className: 'dt-center'}
            ],
            "ajax": {
                url: "?url=Users/GetAllLogAPI",
                type: 'POST',
                data: function(d){
                    d.operator    = sessionStorage.getItem("operator");
                    d.action      = sessionStorage.getItem("action");
                    d.result_type = sessionStorage.getItem("result_type");
                    d.ip          = sessionStorage.getItem("ip");
                    d.date_from   = sessionStorage.getItem("date_from");
                    d.date_to     = sessionStorage.getItem("date_to");
                }
            }, // 指向後端 PHP 文件
            "columns": [
                { "data": "id", "width": "5%" }, // 设置第一列宽度为10%
                { "data": "account", "width": "10%" }, // 设置第二列宽度为20%
                { "data": "action", "width": "15%" },
                { "data": "result", "width": "10%" },
                { "data": "detail", "width": "40%" },
                { "data": "ip", "width": "10%" },
                { "data": "utc_8_time", "width": "10%" }
            ],
            // 其他选项
            "scrollX": true // 启用横向滚动条
        } );

        $('#log_item_table tbody').on('click', 'tr', function () {
            if ($(this).hasClass('selected')) {
                $(this).removeClass('selected');
            } else {
                table.$('tr.selected').removeClass('selected');
                $(this).addClass('selected');
                // console.log( table.row(this).data() )
                selected_row_data = table.row(this).data()
                console.log(selected_row_data)
            }
        });
    });

    function search_table(argument) {
        let operator = document.getElementById('operator').value
        let action = document.getElementById('action').value
        let result_type = document.getElementById('result_type').value
        let ip_filter = document.getElementById('ip_filter').value
        let from_date = document.getElementById('from_date').value
        let to_date = document.getElementById('to_date').value

        sessionStorage.setItem("operator"   , operator);
        sessionStorage.setItem("action"     , action);
        sessionStorage.setItem("result_type", result_type);
        sessionStorage.setItem("ip"         , ip_filter);
        sessionStorage.setItem("date_from"  , from_date);
        sessionStorage.setItem("date_to"    , to_date);

        $('#log_item_table').DataTable().ajax.reload();
        selected_row_data = null
        sessionStorage.clear();
    }

    function clear_condition(argument) {
        history.go(0)
    }

</script>

<script>

// menu nav button
function showContent(contentType)
{
    if(contentType == 'role'){
        window.location.href = "index.php?url=Users/role_setting";
    }

    if(contentType == 'member'){
        window.location.href = "index.php?url=Users";
    }

    if(contentType == 'user_log'){
        window.location.href = "index.php?url=Users/user_log";
    }
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

// Get the modal
var modal = document.getElementById('AddMember');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
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
</div>


<?php require APPROOT . 'views/inc/footer.tpl'; ?>
<style>
    .red-text {
        color: red;
    }
    /*table{
      margin: 0 auto;
      width: 100%;
      clear: both;
      border-collapse: collapse;
      table-layout: fixed; // ***********add this
      word-wrap:break-word; // ***********and this
    }*/
    table {
        table-layout: fixed; /* 固定表格布局 */
        width: 100%; /* 表格宽度100% */
        min-width: 1200px;
        padding: 0 10px;
    }

    th, td {
        overflow: hidden; /* 隐藏溢出内容 */
        text-overflow: ellipsis; /* 溢出时显示省略号 */
        white-space: nowrap; /* 不换行 */
    }
 

</style>