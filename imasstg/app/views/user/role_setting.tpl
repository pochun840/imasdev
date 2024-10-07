<?php require APPROOT . 'views/inc/header.tpl'; ?>
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
                <div class="navbutton active" onclick="handleButtonClick(this, 'role')">
                    <span data-content="<?php echo $text['Role_Setting_text']; ?>" onclick="showContent('role')"></span><?php echo $text['Role_Setting_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'station')">
                    <span data-content="<?php echo $text['Station_Setting_text']; ?>" onclick="showContent('station')"></span><?php echo $text['Station_Setting_text']; ?>
                </div>
            </div>

            <!-- Role Setting -->
            <div id="roleContent" class="content"  style="display: ;">
                <div id="AddRoleSetting" class="role-setting" >
                    <div class="w3-panel alert-light">
                        <label type="text" style="font-size: 22px; margin: 10px; color: #000"><b><?php echo $text['Role_text']; ?></b></label>

                        <button id="role-permission-setting" type="button" onclick="NextToRolePermissionsSetting()">
                            <img id="img-user-setting" src="./img/user-setting.svg" alt="">
                        </button>

                        <button id="delete-button" type="button" onclick="del_role();">
                            <img id="img-delete-role" src="./img/delete.svg" alt="">
                        </button>
                    </div>
                    <form id="form_add_role" onsubmit="addNewRole();return false;" method="post">
                        <div class="row t1" style=" padding-left: 5%">
                            <label for="role_name" class="col-2 t1"><?php echo $text['Add_text'].' '.$text['Role_Name_text']; ?> :</label>
                            <div class="col-2 t2" style="margin-left: -15px">
                                <input type="text" id="role_name" name="role_name" class="t3 form-control input-ms" maxlength="">
                            </div>
                            <div class="col t2">
                                <input id="add-roleName" class="t3" type="submit" name="add_role" value="<?php echo $text['Add_text']; ?>">
                            </div>
                        </div>
                    </form>
                    <div class="row t1" style="padding-left: 5%">
                        <div for="role_name" class="col t1"><?php echo $text['Role_Name_text']; ?> :</div>
                    </div>

                    <div class="scrollbar-addRole" id="style-addRole">
                        <div class="AddRole-force-overflow">
                            <div class="row t1">
                                <div class="col-6 t2" style="padding-left: 20%">
                                    <ul class="rolelist t2" id="roleList">
                                        <?php foreach ($data['all_roles'] as $key => $value): ?>
                                            <li onclick="list_select(this);" value="<?php echo $value['ID']; ?>" ondblclick="NextToRoleSetting(<?php echo $value['ID'].",'".$value['Title']."'"; ?>)"><?php echo $value['ID'].'. '.$value['Title']; ?></li>
                                        <?php endforeach ?>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--Role Edit Setting  -->
                <div class="role-edit" id="RoleEditSetting" style="display: none;">
                    <div class="w3-panel alert-light" style="line-height: 30px">
                        <label type="text" style="font-size: 24px; margin: 10px; color: #000"><b> <?php echo $text['role'];?> <b style="font-size: 25px"> &gt;</b> Super admin setting</b></label>
                        <label type="text" style="font-size: 22px; margin: 10px; padding-left: 5%">
                            Role Name :
                            <input id="RoleName" class="t3" type="submit" name="RoleName" value="super admin" disabled="disabled" style="color: #000">
                        </label>

                        <button id="back-setting" type="button" onclick="cancelSetting()">
                            <img id="img-back" src="./img/back.svg" alt=""> <?php echo $text['Back_text']; ?>
                        </button>
                        <button id="Bulk-Change" type="button" onclick="bulk_change()"><?php echo $text['Bulk_Change_text']; ?></button>
                    </div>
                    <div class="table-container">
                        <div class="scrollbar" id="style-RoleEdit">
                            <div class="force-overflow">
                                <table class="table table-bordered table-hover" id="RoleEdit-table">
                                    <thead id="header-table">
                                        <tr>
                                            <th style="width: 5%; text-align: center; vertical-align: middle;">
                                                <input type="checkbox" id="selectAll2" class="form-check-input" value="0" style="zoom:1.3">
                                            </th>
                                            <th style="width: 20%;"><?php echo $text['Member_text']; ?></th>
                                            <th style="width: 20%;"><?php echo $text['Serial_Number_text']; ?></th>
                                            <th style="width: 20%;"><?php echo $text['Role_text']; ?></th>
                                        </tr>
                                    </thead>

                                    <tbody id="tbody2" style="background-color: #F2F1F1; font-size: 1.8vmin;">
                                        <!-- <tr style="text-align: center; vertical-align: middle;">
                                            <td style="text-align: center; vertical-align: middle;">
                                                <input class="select-checkbox form-check-input" type="checkbox" name="" id="" value="0" style="zoom:1.2">
                                            </td>
                                            <td style="text-align: center">Jimmy Lee</td>
                                            <td>123456789</td>
                                            <td>Super Admin</td>
                                        </tr> -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="RolePermissionSetting" class="role-setting" style="display: none">
                    <div class="w3-panel alert-light" style="line-height: 30px">
                        <label type="text" style="font-size: 24px; margin: 10px; color: #000"><b><?php echo $text['role'];?> <b style="font-size: 25px"> &gt;</b> <?php echo $text['Role_permissions_setting_text']; ?></b></label>

                        <button id="back-setting" type="button" onclick="cancelSetting()">
                            <img id="img-back" src="./img/back.svg" alt=""> <?php echo $text['Back_text']; ?>
                        </button>
                    </div>

                    <div class="row" style=" padding-left: 5%">
                        <div for="Role-Permissions" class="col t3" style="font-size: 20px">
                            <?php echo $text['Role_Name_text']; ?> : &nbsp;
                            <select id="roles_select" style="width: 200px; border: 1px solid #AAAAAA" onchange="load_role_permissions()">
                                <option value="-1" selected disabled><?php echo $text['Choose_text']; ?></option>
                                <?php foreach ($data['all_roles'] as $key => $value): ?>
                                    <option value="<?php echo $value['ID']; ?>"><?php echo $value['Title']; ?></option>
                                <?php endforeach ?>
                            </select>
                        </div>
                    </div>

                    <div class="Permissions_setting">
                        <div class="scrollbar-Permissions" id="style-Permissions">
                            <div class="Permissions-force-overflow">
                                <table class="w3-table w3-large table-station">
                                    <thead id="header-table" class="w3-large">
                                        <tr>
                                            <th width="25%"><?php echo $text['page'];?></th>
                                            <!-- <th>Owner</th> -->
                                            <th><?php echo $text['access'];?></th>
                                            <th><?php echo $text['read'];?></th>
                                            <th><?php echo $text['write'];?></th>
                                            <!-- <th>Load</th> -->
                                            <!-- <th>Save</th> -->
                                            <!-- <th>Notification</th> -->
                                        </tr>
                                    </thead>
                                    <tbody class="tbody" id="permissions_tbody">
                                        <!-- <tr>
                                            <td>Job</td>
                                            <td></td>
                                            <td>
                                                <div class="checkboxFive">
                                                    <input id="07" type="checkbox" value="" name="" checked="checked">
                                                    <label for="07" style="background-color: #DDDDDD"></label>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="checkboxFive">
                                                    <input id="08" type="checkbox" value="" name="" checked="checked">
                                                    <label for="08" style="background-color: #D1E3FF"></label>
                                                </div>
                                            </td>
                                        </tr> -->
                                        
                                        <?php foreach ($data['permission_list'] as $key => $value): ?>
                                             <?php if ($value['Route'] == '三色燈') continue; ?>
                                            <tr>
                                                <td><?php echo $text[$value['Route']]; ?></td>
                                                <td>
                                                    <div class="checkboxFive">
                                                        <input id="<?php echo $value['ID']; ?>" type="checkbox" value="<?php echo $value['ID']; ?>" name="permissions">
                                                        <label for="<?php echo $value['ID']; ?>" style="background-color: #DDDDDD"></label>
                                                    </div>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                        <?php endforeach ?>


                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <button class="saveButton" id="saveButton" onclick="save_role_permissions()"><?php echo $text['Save_text']; ?></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bulk Change Modal -->
    <div id="BulkChange" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 90%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('BulkChange').style.display='none'"
                        class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3>Bulk Change</h3>
                </header>

                <div class="modal-body">
                    <form id="bulk_chage_form">
                        <div class="row">
                            <div for="selected_name" class="col-3 t1">Selected people :</div>
                            <div class="col t2">
                                <label>Jimmy Lee</label> ,
                                <label>Esther</label>
                            </div>
                        </div>

                        <div for="role_name" class="col-3 t1">Role Name :</div>
                        <div style="padding-left: 16%;">
                            <div class="row t1">
                   	            <div class="col-3 t3 form-check form-check-inline">
                                    <input class="t3 form-check-input" type="checkbox" checked="checked" name="Superadmin" id="Superadmin" value="0" style="zoom:1.2; vertical-align: middle">
                                    <label class="t3 form-check-label" for="Superadmin">Super admin</label>
                                </div>
                                <div class="col-3 t3 form-check form-check-inline">
                                    <input class="t3 form-check-input" type="checkbox" name="Administrator" id="Administrator" value="1" style="zoom:1.2; vertical-align: middle">
                                    <label class="t3 form-check-label" for="Administrator">Administrator</label>
                                </div>
                                <div class="col-3 t3 form-check form-check-inline">
                                    <input class="t3 form-check-input" type="checkbox" name="Operation" id="Operation" value="1" style="zoom:1.2; vertical-align: middle">
                                    <label class="t3 form-check-label" for="Operation">Operation</label>
                                </div>
                            </div>
                        </div>
                        <div style="padding-left: 16%;">
                            <div class="row t1">
                                <div class="col-3 t3 form-check form-check-inline">
                                    <input class="t3 form-check-input" type="checkbox" name="foreman" id="foreman" value="1" style="zoom:1.2; vertical-align: middle">
                                    <label class="t3 form-check-label" for="foreman">foreman</label>
                                </div>
                                <div class="col t3 form-check form-check-inline">
                                    <input class="t3 form-check-input" type="checkbox" name="QualityAssurance" id="QualityAssurance" value="0" style="zoom:1.2; vertical-align: middle">
                                    <label class="t3 form-check-label" for="QualityAssurance">Quality Assurance</label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" >Save</button>
                    <button id="button2" class="button button3" onclick="document.getElementById('BulkChange').style.display='none'" class="cancelbtn">Cancel</button>
                </div>
            </div>
        </div>
    </div>

<script>
    // Select All
$(document).ready(function () {
        // Table 1
        $("#selectAll1").change(function () {
            $("#tbody1 input:checkbox").prop('checked', $(this).prop("checked"));
        });

        // Table 2
        $("#selectAll2").change(function () {
            $("#tbody2 input:checkbox").prop('checked', $(this).prop("checked"));
        });
    });

</script>

<script>

// menu nav button
function showContent(contentType)
{
    // var contents = document.getElementsByClassName("content");
    // for (var i = 0; i < contents.length; i++) {
    //     contents[i].style.display = "none";
    // }

    // var contentId = contentType + "Content";
    // document.getElementById(contentId).style.display = "block";

    if(contentType == 'role'){
        window.location.href = "index.php?url=Users/role_setting";
    }

    if(contentType == 'member'){
        window.location.href = "index.php?url=Users";
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


function addNewRole()
{
    var roleNameInput = document.getElementById('role_name');
    var roleList = document.getElementById('roleList');

    if (roleNameInput.value.trim() !== '')
    {
        // var listItem = document.createElement('li');

        // var rowIndex = roleList.getElementsByTagName('li').length + 1;
        // var roleName = roleNameInput.value;
        // var listItemText = rowIndex + '. ' + roleName;

        // listItem.textContent = listItemText;

        // roleList.appendChild(listItem);

        // roleNameInput.value = '';

        let role_name = document.getElementById('role_name').value;
        $.ajax({ // 提醒
            type: "POST",
            data: { 
                'role_name': role_name
                 },
            dataType: "json",
            url: "?url=Users/add_new_role",
        }).done(function(data) { //成功且有回傳值才會執行
            if (data.error != '') {             
                Swal.fire({ // DB sync notice
                    title: 'Error',
                    text: notice.error,
                })
            } else {
                document.getElementById('role_name').value = '';
                history.go(0);
            }
            console.log(data);
        }).fail(function () {
            history.go(0);//失敗就重新整理
        });

    }
}


// Next Role Permissions Setting
function NextToRolePermissionsSetting()
{
    // Show RoleEditSetting
    document.getElementById('RolePermissionSetting').style.display = 'block';

    // Hide AddRoleSetting
    document.getElementById('AddRoleSetting').style.display = 'none';
}

function cancelSetting() {
    var addRoleSetting = document.getElementById('AddRoleSetting');
    var roleEditSetting = document.getElementById('RoleEditSetting');
    var rolePermissionSetting = document.getElementById('RolePermissionSetting');

    // Check the current state and toggle accordingly
    if (roleEditSetting.style.display === 'block') {
        // If RoleEditSetting is currently displayed, switch to AddRoleSetting
        addRoleSetting.style.display = 'block';
        roleEditSetting.style.display = 'none';
    } else if (rolePermissionSetting.style.display === 'block') {
        // If RolePermissionSetting is currently displayed, switch to AddRoleSetting
        addRoleSetting.style.display = 'block';
        rolePermissionSetting.style.display = 'none';
    } else {
        // If AddRoleSetting is currently displayed or both are hidden, do nothing or handle it as needed
    }
}

/// Onclick event for row background color
$(document).ready(function () {
    // Call highlight_row function with table id
    // highlight_row('member-table');
    highlight_row('RoleEdit-table');
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
</div>


<script type="text/javascript">
    
// Next Role Edit Setting
function NextToRoleSetting(roleIndex,title_name)
{
    $.ajax({ // 提醒
        type: "POST",
        data: {
            'role_id': roleIndex,
        },
        dataType: "json",
        url: "?url=Users/get_users_by_role",
    }).done(function(data) { //成功且有回傳值才會執行
        console.log(data);
            // 获取数据表格的tbody元素
            var tbody = document.getElementById('tbody2');
            tbody.innerHTML = '';//清空

            // 遍历JSON数据并创建行
            for (var key in data) {
                if (data.hasOwnProperty(key) && data[key].id != undefined) {
                    console.log(data[key].id)
                    var row = document.createElement('tr');
                    // 创建列元素并设置文本内容
                    var cell0 = document.createElement("td");
                    var checkbox = document.createElement('input');
                        checkbox.className = 'select-checkbox form-check-input';
                        checkbox.type = 'checkbox';
                        checkbox.name = 'member_select';
                        checkbox.id = '';
                        checkbox.value = data[key].id;
                        checkbox.style.zoom = '1.2';
                    cell0.appendChild(checkbox);

                    var cell1 = document.createElement("td");
                    cell1.textContent = data[key].name;
                    var cell2 = document.createElement("td");
                    cell2.textContent = data[key].accout;
                    var cell3 = document.createElement("td");
                    cell3.textContent = data[key].Title;

                    // 将列元素添加到行元素中
                    row.appendChild(cell0);
                    row.appendChild(cell1);
                    row.appendChild(cell2);
                    row.appendChild(cell3);
                    tbody.appendChild(row);
                }
            }

        highlight_row('RoleEdit-table');
        // Show RoleEditSetting
        document.getElementById('RoleEditSetting').style.display = 'block';

        // Hide AddRoleSetting
        document.getElementById('AddRoleSetting').style.display = 'none';

        // You can use the roleIndex to customize the behavior based on the clicked role
        console.log('Double-clicked role:', roleIndex);

        document.getElementById('RoleName').value = title_name;

    }).fail(function() {
        // history.go(0);//失敗就重新整理
    });
}

function bulk_change() {
    let checked_member = document.querySelectorAll('input[name=member_select]:checked');

    // document.querySelectorAll('input[name=member_select]:checked')[0].parentNode.nextSibling.innerHTML

    for (var i = 0; i < checked_member.length; i++) {
        console.log(checked_member[i].parentNode.nextSibling.innerHTML)
    }

    console.log(checked_member);
    document.getElementById('BulkChange').style.display='block';
}

function load_role_permissions() {
    //初始化
    $("#permissions_tbody input:checkbox").prop('checked', false);

    let role_id = document.getElementById('roles_select').value;    

    if(role_id > 0){
        $.ajax({ // 提醒
            type: "POST",
            data: {
                'role_id': role_id,
            },
            dataType: "json",
            url: "?url=Users/get_role_permission_by_id",
        }).done(function(data) { //成功且有回傳值才會執行

            // console.log(data);

            if (data.error != '') {
                // Swal.fire({ // DB sync notice
                //     title: 'Error',
                //     // text: notice.error,
                // })
            } else {
                for (var key in data) {
                    if(data[key].PermissionID != undefined){
                        document.getElementById(data[key].PermissionID).checked = true;
                    }
                }
                // Swal.fire('Saved!', '', 'success');
                // window.location = window.location.href;
            }
        }).fail(function() {
            // history.go(0);//失敗就重新整理
        });
    }
}

function save_role_permissions(argument) {
    let role_id = document.getElementById('roles_select').value;
    let role_permissions = [];
    $("input:checkbox[name=permissions]:checked").each(function() {
        role_permissions.push($(this).val());
    });

    if(role_id < 0){
        alert('請先選擇Role');
        return 0;
    }

    $.ajax({ // 提醒
        type: "POST",
        data: {
            'role_id': role_id,
            'role_permissions': role_permissions
        },
        dataType: "json",
        url: "?url=Users/edit_role_permission_by_id",
    }).done(function(data) { //成功且有回傳值才會執行
        if (data.error != '') {
            Swal.fire({ // DB sync notice
                title: 'Error',
                text: data.error,
            })
        } else {
            Swal.fire({ // DB sync notice
                title: 'Success'
            })
        }
    }).fail(function() {
        // history.go(0);//失敗就重新整理
    });
}

function list_select(element) {
    
    if (element.classList.contains('selected')) {
        element.classList.remove('selected');
    }else{
        element.className += "selected";
    }

    let list = document.getElementById('roleList');

    // for (var i = 0; i < list.length; i++) {
    //     // list[i]
    //     console.log(list[i]);
    // }

}

function del_role() {
    let selected_role = document.getElementsByClassName('selected');
    for (var row = 0; row < selected_role.length; row++) {

        if(selected_role[row].value > 0){
            $.ajax({ // 提醒
                type: "POST",
                data: {
                    'role_id': selected_role[row].value
                },
                dataType: "json",
                url: "?url=Users/delete_role",
            }).done(function(data) { //成功且有回傳值才會執行
                if (data.error != '') {
                    Swal.fire({ // DB sync notice
                        title: 'Error',
                        text: data.error,
                    })
                } else {
                    history.go(0);
                }
                console.log(data);
            }).fail(function() {
                history.go(0); //失敗就重新整理
            });
        }

    }


}

</script>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>