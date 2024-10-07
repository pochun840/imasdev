<?php require APPROOT . 'views/inc/header.tpl'; ?>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/nav.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css">

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/cropper.min.css" />
<script src="<?php echo URLROOT; ?>js/cropper.min.js"></script>

<link rel="stylesheet" href="<?php echo URLROOT; ?>css/sequence.css" type="text/css">

<?php echo $data['nav']; ?>
    
<style>

.t1{font-size: 17px; margin: 3px 0px; display: flex; align-items: center;}
.t2{font-size: 17px; margin: 3px 0px;}
.t3{font-size: 17px; margin: 3px 0px; align-items: center;}

</style>


<div class="container-ms">

    <header>
        <div class="seq">
            <img id="header-img" src="./img/job-head.svg"><?php echo $text['Squence_text']; ?>
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
            <span class="close w3-display-topright" onclick="ClickNotification()">&times;</span>
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
                        <label class="t4">Recycle box</label>
                        <label class="t5">workstation 3</label>
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
                        <label class="t4">Recycle box</label>
                        <label class="t5">workstation 3</label>
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
                        <label class="t4">Recycle box</label>
                        <label class="t5">workstation 3</label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="topnav">
        <div class="row t3">
            <div class="col-1" style="font-size: 1.8vmin; padding-left: 2%;"><?php echo $text['Job_ID_text']; ?></div>
            <div class="col-1 t3" style="padding-left: 1%">
                <input id="job_id" type="text" class="form-control" value="<?php echo $data['job_id']; ?>" disabled="disabled" style="font-size: 1.8vmin;background-color: #E3E3E3; height: 30px">
            </div>

            <div class="col-1" style="font-size: 1.8vmin; padding-left: 2%"><?php echo $text['Job_Name_text']; ?></div>
            <div class="col-2 t3">
                <input id="job_name" type="text" class="form-control" value="<?php echo $data['job_name']; ?>" disabled="disabled" style="font-size: 1.8vmin;background-color: #E3E3E3; height: 30px">
            </div>

            <div class="col-1" style="font-size: 1.8vmin; padding-left: 2%"><?php echo $text['Seq_count_text']; ?></div>
            <div class="col-1 t3">
                <input id="seq_count" type="text" class="form-control" value="<?php echo count($data['sequences']); ?>" disabled="disabled" style="font-size: 1.8vmin;background-color: #E3E3E3; height: 30px">
            </div>

            <div class="col t3">
                <button class="btn" id="back-btn" type="button" onclick="history.go(-1);">
                    <img id="img-back" src="./img/back.svg" alt=""><?php echo $text['Back_text']; ?>
                </button>
                <button class="btn" id="delete-btn" type="button" onclick="delete_seq()">
                    <img id="img-delete" src="./img/delete.svg" alt=""><?php echo $text['Delete_text']; ?>
                </button>
                <button class="btn" id="edit-btn" type="button" onclick="edit_seq_normal();">
                    <img id="img-edit" src="./img/edit.svg" alt=""><?php echo $text['Edit_text']; ?>
                </button>
                <button class="btn" id="copy-btn" type="button" onclick="copy_seq_div()">
                    <img id="img-copy" src="./img/copy.svg" alt=""><?php echo $text['Copy_text']; ?>
                </button>
                <button class="btn" id="add_seq" type="button" onclick="new_seq(<?php echo $data['job_id']; ?>)">
                    <img id="img-seq" src="./img/add-new-seq.svg" alt=""><?php echo $text['Add_Seq_text']; ?>
                </button>
            </div>
        </div>
    </div>

    <div class="main-content">
        <div class="center-content">
            <div class="scrollbar" id="style-seq">
                <div class="force-overflow">
                    <table class="table table-bordered" id="table_seq">
                        <thead id="header-table">
                            <tr style="text-align: center">
                                <th width="10%"><?php echo $text['Seq_ID_text']; ?></th>
                                <th width="25%"><?php echo $text['Seq_Name_text']; ?></th>
                                <th width="35%"><?php echo $text['Picture_text']; ?></th>
                                <th width="10%"><?php echo $text['Enalbe_text']; ?></th>
                                <th width="20%"><?php echo $text['Action_text']; ?></th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin">
                            <?php
                                foreach ($data['sequences'] as $key => $seq) {
                                    echo '<tr style="text-align: center">';
                                    echo '<td>'.$seq['seq_id'].'</td>';
                                    echo '<td>'.$seq['seq_name'].'</td>';
                                    echo '<td><img src="'.$seq['img'].'" style="max-height: 100px;display: inline-block;"></td>';
                                    if($seq['sequence_enable'] == 0){
                                        echo '<td> <input class="form-check-input" type="checkbox"  name="" id="" value="0" style="zoom:2.0; vertical-align: middle" onclick="enable_disable_seq('.$seq['seq_id'].',this)"> </td>';
                                    }else{
                                        echo '<td> <input class="form-check-input" type="checkbox" checked="checked" name="" id="" value="1" style="zoom:2.0; vertical-align: middle" onclick="enable_disable_seq('.$seq['seq_id'].',this)"> </td>';
                                    }
                                    echo '<td style="text-align: left">';
                                    echo '<div class="dropdown">';
                                    echo '<label><img src="./img/info-30.png" alt="" style="height: 30px; float: left; margin-right: 5px; margin-bottom: 10px" onclick="PictureDetailFunction('.$seq['seq_id'].')"> '.$text['Detail_text'].'</label>';
                                    echo '<div id="Detail-Dropdown-'.$seq['seq_id'].'" class=" dropdown dropdown-content">';
                                    echo   '<a style="margin-top: 10%">'.$text['Seq_ID_text'].' :<i style="float: right">GTCS</i></a>';
                                    echo   '<a>'.$text['NG_Stop_text'].' :<i style="float: right">'.$seq['ng_stop'].'</i></a>';
                                    echo   '<a>'.$text['Enalbe_text'].' :<i style="float: right">'.$seq['sequence_enable'].'</i></a>';
                                    echo   '<a>'.$text['Sequence_OK_text'].' :<i style="float: right">'.$seq['ok_sequence'].'</i></a>';
                                    //echo   '<a>'.$text['Sequence_OK_text'].' :<i style="float: right">'.$seq['ok_sequence_stop'].'</i></a>';
                                    echo   '<a>'.$text['Timeout_text'].' :<i style="float: right">'.$seq['sequence_maxtime'].'</i></a>';
                                    echo '</div>
                                    <br>
                                    <label><img src="./img/add-task.png" style="height: 30px; float: left; margin-right: 5px" onclick="location.href = \'?url=Tasks/index/'.$data['job_id'].'/'.$seq['seq_id'].'\';"> '.$text['Add_Task_text'].'</label>
                                    </div>';
                                    echo '</td>';
                                    echo '</tr>';
                                }
                            ?>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- New Seq -->
    <div id="SeqNew" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 80%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('SeqNew').style.display='none'"
                        class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3 id="modal_head">New Seq</h3>
                </header>

                <div class="modal-body">
                    <form id="new_seq_form">
                        <div class="row">
                            <div for="seq_id" class="col-4 t1"><?php echo $text['Seq_ID_text']; ?> :</div>
                            <div class="col-4 t2">
                                <input type="text" min=1 max=99 class="form-control input-ms" id="seq_id" maxlength="2" disabled >
                            </div>
                        </div>
                        <div class="row">
                            <div for="seq_name" class="col-4 t1"><?php echo $text['Seq_Name_text']; ?> :</div>
                            <div class="col-4 t2" >
                                <input type="text" class="form-control input-ms" id="seq_name" maxlength="12" required>
                            </div>
                        </div>
                        <div class="row">
                            <div for="barcode_enable" class="col-4 t1"><?php echo $text['Barcode_Enable_text']; ?> :</div>
                            <div class="switch menu col-4 t2">
                                <input id="barcode_enable" type="checkbox">
                                <label><i></i></label>
                            </div>
                        </div>
                        <hr>
                        <form class="upload-file" action="" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div for="add_picture" class="col-4 t1"><?php echo $text['Add_Picture_text']; ?> :</div>
                                <div class=" col-1 t2 custom-file">
                                    <input type="file" name="image" id="custom-file" class="input-file" onchange="displayImage()" accept="image/gif, image/jpeg, image/png">
                                    <label for="custom-file" class="file-label" style="height: 30px; width: 30px; ">&#10010;</label>
                                </div>

                                <div for="add_picture" class="col-2 t1"><?php echo $text['Picture_text']; ?> :</div>
                                <div class="col t2 file-name box tailoring-box" id="preview-container" style="display:none;">
                                    <img id="image-preview" alt="Preview" style="max-width: 150px; max-height: 150px;">
                                </div>
                            </div>
                        </form>
                        <hr>
                        <div class="row">
                            <div for="stop_on_NG" class="col-4 t1"><?php echo $text['NG_Stop_text']; ?> :</div>
                            <div class="col t2">
              					<select id="stop_on_NG" style="width: 150px; height: 30px">
               					    <option value="0">No</option>
               					    <option value="1">1</option>
              					    <option value="2">2</option>
               					    <option value="3">3</option>
               					    <option value="4">4</option>
               					    <option value="5">5</option>
               					    <option value="6">6</option>
               					    <option value="7">7</option>
               					    <option value="8">8</option>
               					    <option value="9">9</option>
                  				</select>
                            </div>
                        </div>

                       <!--  <div class="row">
                            <div for="seq_enable" class="col-4 t1">Seq Enable :</div>
                            <div class="switch menu col-4 t2">
                                <input id="seq_enable" type="checkbox" checked>
                                <label><i></i></label>
                            </div>
                        </div> -->
                        <div class="row">
                            <div for="ok_seq" class="col-4 t1"><?php echo $text['Sequence_OK_text']; ?> :</div>
                            <div class="switch menu col-4 t2">
                                <input id="ok_seq" type="checkbox" checked>
                                <label><i></i></label>
                            </div>
                        </div>
                       <div class="row">
                            <div for="timeout" class="col-4 t1"><?php echo $text['Timeout_text']; ?> :</div>
                            <div class="col-4 t2">
                                <input id="timeout" type="number" min=1 max=99 class="form-control input-ms" maxlength="2" >
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="new_seq_save()"><?php echo $text['Save_text']; ?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('SeqNew').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text']; ?></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Seq Copy Modal -->
    <div id="CopySeq" class="modal">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content w3-animate-zoom" style="width:80%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('CopySeq').style.display='none'"
                    class="w3-button w3-red w3-xxlarge w3-display-topright" style="padding: 7px; width: 60px">&times;</span>
                    <h3><?php echo $text['Copy_seq_text']; ?></h3>
                </header>

                <div class="modal-body">
                    <form id="copy_seq_form">
                        <div for="from_seq_id" class="col" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_from_text']; ?></b></div>
                        <div style="padding-left: 20px;">
        		            <div class="row">
        				        <div for="from_seq_id" class="col-4 t1"><?php echo $text['Seq_ID_text']; ?> :</div>
        				        <div class="col-5 t2">
        				            <input type="text" class="form-control" id="from_seq_id" disabled>
        				        </div>
        				    </div>
                            <div class="row">
                                <div for="from_seq_name" class="col-4 t1"><?php echo $text['Seq_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="from_seq_name" disabled>
                                </div>
                            </div>
                        </div>

                        <div for="from_seq_id" class="cola" style="font-size: 20px; margin: 5px 0px 5px"><b><?php echo $text['Copy_to_text']; ?></b></div>
                        <div style="padding-left: 20px;">
                            <div class="row">
                                <div for="to_seq_id" class="col-4 t1"><?php echo $text['Seq_ID_text']; ?> :</div>
                				<div class="col-5 t2">
                				    <input type="text" class="form-control" id="to_seq_id">
                				</div>
            				</div>
                            <div class="row">
                                <div for="to_seq_name" class="col-4 t1"><?php echo $text['Seq_Name_text']; ?> :</div>
                                <div class="col-5 t2">
                                    <input type="text" class="form-control" id="to_seq_name">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer justify-content-center">
                    <button id="button1" class="button button3" onclick="copy_seq()"><?php echo $text['Save_text'];?></button>
                    <button id="button2" class="button button3" onclick="document.getElementById('CopySeq').style.display='none'" class="cancelbtn"><?php echo $text['Cancel_text'];?></button>
                </div>
            </div>
        </div>
    </div>

<script>
// Get the modal
var modal = document.getElementById('SeqNew');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}


/* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
function PictureDetailFunction(item)
{
    var Divs = document.querySelectorAll("div[id^='Detail-Dropdown']");
    // 迭代所有符合條件的 div 元素，移除 class
    Divs.forEach(function(div) {
        // if(!div.hasClass('show'))
        if( $(div)[0].id != "Detail-Dropdown-"+item){
            div.classList.remove("show"); // 將 "yourClassNameToRemove" 替換為你想要移除的 class 名稱
        }
    });

    document.getElementById("Detail-Dropdown-"+item).classList.toggle("show");

}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
    if (!event.target.matches('.dropdown img')) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        var i;
        for (i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
}

// Upload img  //
function displayImage()
{
    var input = document.getElementById('custom-file');
    var previewContainer = document.getElementById('preview-container');
    var previewImage = document.getElementById('image-preview');
    var file = input.files[0];

    if (file)
    {
        var reader = new FileReader();
        reader.onload = function (e) {
        previewImage.src = e.target.result;
        };

        reader.readAsDataURL(file);

        // Show the preview container
        previewContainer.style.display = 'block';
        previewImage.style.display = 'block';
    }
}

</script>

<script>
    $(document).ready(function () {
        highlight_row('table_seq');
        //highlight_row('barcode-table');
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
} //end of function

    //new seq 按下new seq button
    function new_seq(job_id) {

        //get new seq_id
        let seq_id = get_seq_id_normal(job_id);
        if(seq_id > 50){ //避免新增超過99個seq
            return 0;
        }
        
        
        document.getElementById('modal_head').innerHTML = '<?php echo $text['New_Seq_text']; ?>'; //'New Seq'
        //帶入預設值
        document.getElementById("seq_id").value = seq_id;
        document.getElementById("seq_name").value = '';
        //document.getElementById("barcode_enable").checked = 0;
        document.getElementById("stop_on_NG").value = 0;
        // document.getElementById('seq_enable').checked = 1;
        document.getElementById('ok_seq').checked = 1;
        document.getElementById("timeout").value = 20;

        //image
        document.getElementById('custom-file').value = '';
        document.getElementById('image-preview').src = '';
        document.getElementById('image-preview').style.display = 'none';
        // $('#image-preview').attr('src', '').hide(); //將img的src設定為dataURL並顯示

        document.getElementById('SeqNew').style.display='block'

    }

    //new seq 按下save鍵
    function new_seq_save(){
        let job_id = document.getElementById("job_id").value;
        let seq_id = document.getElementById("seq_id").value;
        let seq_name = document.getElementById("seq_name").value;
        let barcode_enable = document.getElementById("barcode_enable").checked;
        let stop_on_NG = document.getElementById("stop_on_NG").value;
        //let seq_enable = document.getElementById('seq_enable').checked; //$('input[id=ok_job]:checked').val();
        let ok_seq = document.getElementById('ok_seq').checked; // $('input[name=Downshift_Enable]:checked').val();
        let timeout = document.getElementById("timeout").value;
        let ok_seq_stop = 1;

        var formData = new FormData();
        // 添加表单数据
        var form = $('new_job_form');
        formData.append('job_id', job_id);
        formData.append('seq_id', seq_id);
        formData.append('seq_name', seq_name);
        formData.append('barcode_enable', barcode_enable);
        formData.append('stop_on_NG', stop_on_NG);
        // formData.append('seq_enable', seq_enable);
        formData.append('ok_seq', ok_seq);
        formData.append('timeout', timeout);
        formData.append('ok_seq_stop', ok_seq_stop);
        // 添加图片数据
        var fileInput = $('#custom-file')[0].files[0];
        formData.append('image', fileInput);

        const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB in bytes
        if (fileInput) {
            var fileSize = fileInput.size;
            var seq_url = '?url=Sequences/index/' + job_id;

            if (fileSize > MAX_FILE_SIZE) {
                alert('文件大小超過5MB限制。');
                return false;
            } else {
                //var formData = new FormData();
                formData.append('image', fileInput);
            }
        }

        
        //cropper
        if($t[0].cropper === undefined){//未上傳圖片
            formData.append('croppedImage', false);
            let url = '?url=Sequences/edit_seq';
            $.ajax({
                type: "POST",
                data: formData,
                dataType: "json",
                url: url,
                processData: false,
                contentType: false,
                success: function(response) {
                    // 成功回調函數，處理伺服器的回應
                    console.log(response); // 在控制台輸出伺服器的回應
                    // history.go(0);
                    if (response.error == '') {
                        history.go(0);
                    } else {

                    }
                },
                error: function(error) {
                    // 失敗回調函數，處理錯誤情況
                    // console.error('Error:', error); // 在控制台輸出錯誤訊息
                }
            }).fail(function() {
                // history.go(0);//失敗就重新整理
            });
        }else{
            // 使用 Cropper.js 的 getCroppedCanvas 方法獲取裁剪後的 Canvas 元素
            var croppedCanvas = $t.cropper('getCroppedCanvas');

            // 設置壓縮後的最大寬度和高度
            var maxWidth = 800;
            var maxHeight = 600;

            // 創建一個新的 Canvas 元素
            var canvas = document.createElement('canvas');
            var ctx = canvas.getContext('2d');

            // 設置 Canvas 的寬度和高度
            var width = croppedCanvas.width;
            var height = croppedCanvas.height;

            // 如果圖片的寬度或高度超過了指定的最大寬度或最大高度，則進行壓縮
            if (width > maxWidth || height > maxHeight) {
                if (width / height > maxWidth / maxHeight) {
                    height *= maxWidth / width;
                    width = maxWidth;
                } else {
                    width *= maxHeight / height;
                    height = maxHeight;
                }
            }

            // 設置 Canvas 的寬度和高度
            canvas.width = width;
            canvas.height = height;

            // 在 Canvas 上繪製裁剪後的圖片
            ctx.drawImage(croppedCanvas, 0, 0, width, height);

            // 將 Canvas 轉換為 Blob 物件
            canvas.toBlob(function(blobs) {
                // 上傳壓縮後的圖片 Blob 到服務器
                formData.append('croppedImage', blobs /*, 'example.png' */ );
                let url = '?url=Sequences/edit_seq';
                $.ajax({
                    type: "POST",
                    data: formData,
                    dataType: "json",
                    url: url,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        // 成功回調函數，處理伺服器的回應
                        // console.log(response); // 在控制台輸出伺服器的回應
                        if (response.error == '') {
                            history.go(0);
                        } else {

                        }
                    },
                    error: function(error) {
                        // 失敗回調函數，處理錯誤情況
                        // console.error('Error:', error); // 在控制台輸出錯誤訊息
                    }
                }).fail(function() {
                    history.go(0); //失敗就重新整理
                });
            }, 'image/jpeg', 0.8); // 圖片品質為 0.8（範圍從 0 到 1）
        }
        //end cropper
    }

    //get job_id
    function get_seq_id_normal(job_id) {

        $.ajax({
          type: "POST",
          url: "?url=Sequences/get_head_seq_id_normal",
          data: {'job_id':job_id},
          dataType: "json",
          encode: true,
          async: false,//等待ajax完成
        }).done(function (data) {//成功且有回傳值才會執行
            seq_id = data['missing_id'];
        });

        return seq_id;
    }

    function edit_seq_normal(){
        document.getElementById('modal_head').innerHTML = '<?php echo $text['Edit_Seq_text']; ?>'; //'edit seq'

        let job_id = document.getElementById("job_id").value;
        let rowSelected = document.getElementsByClassName('selected');
        let seq_id = rowSelected[0].childNodes[0].innerHTML;

        let url = '?url=Sequences/get_seq_by_id';
        $.ajax({
            type: "POST",
            data: {'job_id' : job_id, 'seq_id' : seq_id},
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                // console.log(response); // 在控制台輸出伺服器的回應

                document.getElementById("job_id").value = response['job_id'];
                document.getElementById("seq_id").value = response['seq_id'];
                document.getElementById("seq_name").value = response['seq_name'];
                document.getElementById('barcode_enable').checked = parseInt(response['barcode_start']);
                document.getElementById("stop_on_NG").value = response['ng_stop'];
                // document.getElementById("seq_enable").checked = parseInt(response['sequence_enable']);
                document.getElementById('ok_seq').checked = parseInt(response['ok_sequence']);
                document.getElementById("timeout").value = response['sequence_maxtime'];

                //初始化 移除croppper與img
                $t.cropper('destroy');

                //image
                document.getElementById('custom-file').value = '';
                if(response['img'] != '' || response['img'] == null){
                    document.getElementById('image-preview').src = response['img'];    
                    document.getElementById('image-preview').style.display = 'block';
                    document.getElementById('preview-container').style.display = 'block';
                }

                document.getElementById('modal_head').innerHTML = '<?php echo $text['Edit_Seq_text']; ?>'; //'Edit Seq'
                document.getElementById('SeqNew').style.display='block'
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function () {
            // history.go(0);//失敗就重新整理
        });

    }

    function copy_seq_div() {
        let rowSelected = document.getElementsByClassName('selected');
        if (rowSelected.length != 0) {
            let seq_id = rowSelected[0].childNodes[0].innerHTML;
            let seq_name = rowSelected[0].childNodes[1].innerHTML;

            document.getElementById('from_seq_id').value=seq_id;
            document.getElementById('from_seq_name').value=seq_name;
            document.getElementById('CopySeq').style.display='block'
        }
    }

    function copy_seq() {
        let job_id = document.getElementById("job_id").value;
        let rowSelected = document.getElementsByClassName('selected');
        let seq_id = rowSelected[0].childNodes[0].innerHTML;
        let to_seq_id = document.getElementById('to_seq_id').value;
        let to_seq_name = document.getElementById('to_seq_name').value;

        let url = '?url=Sequences/copy_seq';
        $.ajax({
            type: "POST",
            data: { 'from_job_id': job_id,
                    'from_seq_id': seq_id, 
                    'to_seq_id': to_seq_id,
                    'to_seq_name': to_seq_name },
            dataType: "json",
            url: url,
            success: function(response) {
                // 成功回調函數，處理伺服器的回應
                //console.log(response); // 在控制台輸出伺服器的回應
                history.go(0);
            },
            error: function(error) {
                // 失敗回調函數，處理錯誤情況
                // console.error('Error:', error); // 在控制台輸出錯誤訊息
            }
        }).fail(function() {
            // history.go(0);//失敗就重新整理
        });
    }

    function delete_seq() {
        let job_id = document.getElementById("job_id").value;
        let rowSelected = document.getElementsByClassName('selected');
        let seq_id = rowSelected[0].childNodes[0].innerHTML;

        var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>');

        if (yes) {
            let url = '?url=Sequences/delete_seq_by_id';
            $.ajax({
                type: "POST",
                data: {'job_id' : job_id, 'seq_id' : seq_id},
                dataType: "json",
                url: url,
                success: function(response) {
                    // 成功回調函數，處理伺服器的回應
                    // console.log(response); // 在控制台輸出伺服器的回應
                    history.go(0);
                },
                error: function(error) {
                    // 失敗回調函數，處理錯誤情況
                    // console.error('Error:', error); // 在控制台輸出錯誤訊息
                }
            }).fail(function () {
                // history.go(0);//失敗就重新整理
            });
        } else {
            
        }
    }


    //enable or disable seq
    function enable_disable_seq(seq_id,element) {
        let job_id = document.getElementById("job_id").value;
        let status = element.checked;

        // body...
        var formData = {
          job_id: job_id,
          seq_id: seq_id,
          status: status,
        };

        $.ajax({
          type: "POST",
          url: "?url=Sequences/Enable_Disable_Seq",
          data: formData,
          dataType: "json",
          encode: true,
          beforeSend: function() {
            // $('#overlay').removeClass('hidden');
          },
        }).done(function (data) {//成功且有回傳值才會執行
          // console.log(data);
          // $('#overlay').addClass('hidden');
          if(data['error_message'] != ''){
            alert(data['error_message']);   
          }else{
            history.go(0);
          }
        });
    }


</script>

<style type="text/css">
    .selected{
        background-color: #9AC0CD !important;
    }

    ./*selected :hover{
        background-color: #9AC0CD;
    }*/
</style>

<script type="text/javascript">
  var $t = $('#image-preview');//image

  $('#custom-file').change(function(){ //input
    let file = this.files[0];
    if (file) {
      let reader = new FileReader();
      reader.onload = function(evt) {
        let imgSrc = evt.target.result;
        let box_width = document.getElementById('preview-container').parentElement.offsetWidth - 20;
        $t.cropper('destroy');
        // cropper圖片裁剪
        $t.cropper({
            aspectRatio: NaN, // 預設比例
            // preview : '#previewImg',  // 預覽檢視
            autoCrop: true,
            guides: false, // 裁剪框的虛線(九宮格)
            autoCropArea: 0.5, // 0-1之間的數值，定義自動剪裁區域的大小，預設0.8
            dragMode: 'crop', // 拖曳模式 crop(Default,新增裁剪框) / move(移動裁剪框&圖片) / none(無動作)
            cropBoxResizable: true, // 是否有裁剪框調整四邊八點
            movable: true, // 是否允許移動圖片
            zoomable: true, // 是否允許縮放圖片大小
            rotatable: false, // 是否允許旋轉圖片
            zoomOnWheel: true, // 是否允許通過滑鼠滾輪來縮放圖片
            zoomOnTouch: true, // 是否允許通過觸控移動來縮放圖片
            minContainerWidth: box_width,
            minContainerHeight: 200,
            ready: function(e) {
                console.log('ready!2');
            }
        });
        $t.cropper('replace', imgSrc, false);
      }
      reader.readAsDataURL(file);
    }
  });


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

</div>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>