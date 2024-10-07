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
                <div class="navbutton active" onclick="handleButtonClick(this, 'member')">
                    <span data-content="<?php echo $text['Member_List_text']; ?>" onclick="showContent('member')"></span><?php echo $text['Member_List_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'role')">
                    <span data-content="<?php echo $text['Role_Setting_text']; ?>" onclick="showContent('role')"></span><?php echo $text['Role_Setting_text']; ?>
                </div>
                <div class="navbutton" onclick="handleButtonClick(this, 'station')">
                    <span data-content="<?php echo $text['Station_Setting_text']; ?>" onclick="showContent('station')"></span><?php echo $text['Station_Setting_text']; ?>
                </div>
            </div>

            <!-- Member List -->
            <div id="memberContent" class="content">
                <div class="w3-panel alert-light">
                    <label type="text" style="font-size: 22px; margin: 10px; color: #000"><b><?php echo $text['Member_List_text']; ?></b></label>

                    <button id="button-menulist" type="button"><img id="img-menulist" src="./img/dots-30.png" alt=""></button>

                    <button id="delete-member" type="button" onclick="delete_user();">
                        <img id="img-delete-member" src="./img/delete.svg" alt=""> <?php echo $text['Delete_text']; ?>
                    </button>

                    <button id="add-memberlist" type="button" onclick="add_user_div();">
                        <img id="img-add-member" src="./img/add-member.svg" alt=""> <?php echo $text['Add_member_text']; ?>
                    </button>

                    <button id="Filter" type="button">
                        <img id="img-filter" src="./img/filter.svg" alt=""> <?php echo $text['Filter_text']; ?>
                    </button>
                </div>

                <div class="table-container">
                    <div class="scrollbar" id="style-member">
                        <div class="scrollbar-force-overflow">
                            <table class="table table-bordered table-hover" id="member-table">
                                <thead id="header-table">
                                    <tr>
                                        <th style="width: 5%; text-align: center; vertical-align: middle;">
                                            <input type="checkbox" id="selectAll1" class="form-check-input" value="0" style="zoom:1.3">
                                        </th>
                                        <th style="width:10%;display: none;">ID</th>
                                        <th style="width:15%;"><?php echo $text['account_text']; ?></th>
                                        <th style="width:20%;"><?php echo $text['User_Name_text']; ?></th>
                                        <th style="width:10%;"><?php echo $text['Role_text']; ?></th>
                                        <!-- <th style="width:10%;">Group</th> -->
                                        <th style="width:25%;"><?php echo $text['Created_Date_text']; ?> (UTC)</th>
                                        <th style="width:5%;"><?php echo $text['Edit_text']; ?></th>
                                    </tr>
                                </thead>

                                <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.8vmin;">
                                    <?php foreach ($data['all_users'] as $key => $value): ?>
                                        <tr style="text-align: center; vertical-align: middle;">
                                            <td style="text-align: center; vertical-align: middle;">
                                            <input class="form-check-input" type="checkbox" name="user_check" id="" value="<?php echo $value['id']; ?>" style="zoom:1.2">
                                            </td>
                                            <td style="display: none;"><?php echo $value['id']; ?></td>
                                            <td><?php echo $value['account']; ?></td>
                                            <td><?php echo $value['name']; ?></td>
                                            <td><?php echo $value['Title']; ?></td>
                                            <!-- <td>-</td> -->
                                            <td><?php echo $value['date_created']; ?></td>
                                            <td><img src="./img/user-edit.svg" style=" width: 35px; height: 35px" onclick="load_user('<?php echo $value['id']; ?>')"></td>
                                        </tr>
                                    <?php endforeach ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

           
        </div>
    </div>

    <!-- Add New Member -->
    <div id="AddMember" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 80%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('AddMember').style.display='none'"
                        class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id='modal_title'><?php echo $text['Add_member_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="new_member_form" style="padding-left: 10%">
                        <div class="row" id="user-id" style="display:none;">
                            <div for="Number-ID" class="col-4 t1">ID :</div>
                            <div class="col-4 t2">
                                <input type="text" class="form-control input-ms" id="Number-ID" maxlength="" disabled >
                            </div>
                        </div>
                        <div class="row">
                            <div for="user-name" class="col-4 t1"><?php echo $text['Name_text']; ?> :</div>
                            <div class="col-4 t2">
                                <input type="text" class="form-control input-ms" id="user-name" maxlength="" >
                            </div>
                        </div>
                        <div class="row">
                            <div for="account" class="col-4 t1"><p class="red-text">**</p><?php echo $text['account_text']; ?> :</div>
                            <div class="col-4 t2" >
                                <input type="text" class="form-control input-ms" id="user-account" maxlength="12" required>
                            </div>
                        </div>
                        <div class="row">
                            <div for="user-password" class="col-4 t1"><p class="red-text">**</p><?php echo $text['password_text']; ?> :</div>
                            <div class="col-4 t2">
                                <input type="text" class="form-control input-ms" id="user-password" maxlength="12" required>
                            </div>
                        </div>
                        <div class="row">
                            <div for="employee-number" class="col-4 t1"><?php echo $text['Employee_Number_text']; ?> :</div>
                            <div class="col-4 t2">
                                <input type="text" class="form-control input-ms" id="employee-number" maxlength="">
                            </div>
                        </div>
                        <div class="row">
                            <div for="employee-number" class="col-4 t1"><?php echo $text['Card_text']; ?> :</div>
                            <div class="col-4 t2">
                                <input type="text" class="form-control input-ms" id="user-card" maxlength="100">
                            </div>
                        </div>
                        <div class="row">
                            <div for="authority" class="col-4 t1"><p class="red-text">**</p><?php echo $text['Authority_text']; ?> :</div>
                            <div class="col t2">
                                <select id="user-role" style="width: 169px">
               					    <option value="-1" disabled selected><?php echo $text['Choose_text']; ?></option>
                                    <?php foreach ($data['all_roles'] as $key => $value) {
                                        echo '<option value="'.$value['ID'].'">'.$value['Title'].'</option>';
                                    } ?>
                 				</select>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="add_member_user()" ><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('AddMember').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
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
        var listItem = document.createElement('li');

        var rowIndex = roleList.getElementsByTagName('li').length + 1;
        var roleName = roleNameInput.value;
        var listItemText = rowIndex + '. ' + roleName;

        listItem.textContent = listItemText;

        roleList.appendChild(listItem);

        roleNameInput.value = '';
    }
}

/// Onclick event for row background color
$(document).ready(function () {
    // Call highlight_row function with table id
    highlight_row('member-table');
    // highlight_row('RoleEdit-table');
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

    function add_user_div(argument) {
        document.getElementById('Number-ID').value = '';
        document.getElementById('user-name').value = '';
        document.getElementById('user-account').value = '';
        document.getElementById('user-password').value = '';
        document.getElementById('employee-number').value = '';
        document.getElementById('user-role').value = -1;

        document.getElementById('user-account').disabled = false;
        document.getElementById('modal_title').innerText = '<?php echo $text['Add_member_text']; ?>';
        document.getElementById('user-id').style.display='none';
        document.getElementById('AddMember').style.display='block';
    }
    
    function add_member_user(argument) {
        let user_id = document.getElementById('Number-ID').value;
        let user_name = document.getElementById('user-name').value;
        let user_account = document.getElementById('user-account').value;
        let user_password = document.getElementById('user-password').value;
        let user_employee_number = document.getElementById('employee-number').value;
        let user_role = document.getElementById('user-role').value;
        let user_card = document.getElementById('user-card').value;

        let result = validate_adduser(user_id);

        if(result){

            if(user_id == ''){
                $.ajax({ // 提醒
                    type: "POST",
                    data: { 
                        'user_name': user_name,
                        'user_account': user_account,
                        'user_password': user_password,
                        'user_employee_number': user_employee_number,
                        'user_role': user_role,
                        'user_card': user_card,
                        'add_user': true,
                         },
                    dataType: "json",
                    url: "?url=Users/add_user",
                }).done(function(notice) { //成功且有回傳值才會執行
                    if (notice.error != '') {
                        Swal.fire({ // DB sync notice
                            title: 'Error',
                            text: notice.error,
                        })
                    } else {
                        Swal.fire('Saved!', '', 'success');
                        window.location = window.location.href;
                    }
                }).fail(function () {
                    // history.go(0);//失敗就重新整理
                });
            }else{
                    $.ajax({ // 提醒
                        type: "POST",
                        data: { 
                            'user_id': user_id,
                            'user_name': user_name,
                            'user_account': user_account,
                            'user_password': user_password,
                            'user_employee_number': user_employee_number,
                            'user_role': user_role,
                            'user_card': user_card,
                            },
                        dataType: "json",
                        url: "?url=Users/edit_user",
                    }).done(function(notice) { //成功且有回傳值才會執行
                        if (notice.error != '') {
                        } else {
                            Swal.fire('Saved!', '', 'success');
                            window.location = window.location.href;
                        }
                    }).fail(function () {
                        // history.go(0);//失敗就重新整理
                    });
            }



        }else{
            Swal.fire({ // DB sync notice
                title: 'Error',
                text: 'input Error',
            })
        }
    }

    function validate_adduser(user_id) {

        if(user_id == ''){
            let user_name = document.getElementById('user-name').value;
            let user_account = document.getElementById('user-account').value;
            let user_password = document.getElementById('user-password').value;
            let user_employee_number = document.getElementById('employee-number').value;
            let user_role = document.getElementById('user-role').value;

            if ( user_account == '' || user_password == '' ||  user_role == '-1' ) {
                return false;
            }else{
                return true;
            }    
        }else{
            let user_name = document.getElementById('user-name').value;
            let user_account = document.getElementById('user-account').value;
            let user_password = document.getElementById('user-password').value;
            let user_employee_number = document.getElementById('employee-number').value;
            let user_role = document.getElementById('user-role').value;

            if (user_name == '' || user_account == '' || user_role == '-1' ) {
                return false;
            }else{
                return true;
            }    
        }
        
    }

    function load_user(user_id){

        $.ajax({ // 提醒
            type: "POST",
            data: { 
                'user_id': user_id
                 },
            dataType: "json",
            url: "?url=Users/get_user_by_id",
        }).done(function(data) { //成功且有回傳值才會執行
            if (data.error != '') {             
                Swal.fire({ // DB sync notice
                    title: 'Error',
                    text: notice.error,
                })
            } else {
                document.getElementById('Number-ID').value = data.id;
                document.getElementById('user-name').value = data.name;
                document.getElementById('user-account').value = data.account;
                document.getElementById('employee-number').value = data.employee_number;
                document.getElementById('user-role').value = data.RoleID;
                document.getElementById('user-card').value = data.card;

                document.getElementById('user-account').disabled = true;
                document.getElementById('modal_title').innerText = '<?php echo $text['Edit_member_text']; ?>';
                document.getElementById('user-id').style.display='flex'
                document.getElementById('AddMember').style.display='block'
            }
            console.log(data);
        }).fail(function () {
            // history.go(0);//失敗就重新整理
        });

    }

    function delete_user() {
        let checked_user = document.querySelectorAll('input[name=user_check]:checked');
        // let document.getElementsByClassName('selected')[0].cells[1].innerText;
        console.log(checked_user.length);

        for (var i = checked_user.length - 1; i >= 0; i--) {
            // checked_user[i].value;
            // console.log(checked_user[i].value);
            $.ajax({ // 提醒
                type: "POST",
                data: { 
                    'user_id': checked_user[i].value
                     },
                dataType: "json",
                url: "?url=Users/del_user",
            }).done(function(data) { //成功且有回傳值才會執行
                if (data.error != '') {             
                    Swal.fire({ // DB sync notice
                        title: 'Error',
                        text: '',
                    })
                } else {
                    window.location = window.location.href;
                }
                // console.log(data);
            }).fail(function () {
                // history.go(0);//失敗就重新整理
            });
        }

    }

</script>


<?php require APPROOT . 'views/inc/footer.tpl'; ?>
<style>
    .red-text {
        color: red;
    }
</style>