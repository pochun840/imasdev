<!-- Station Setting -->
<div id="station_settingContent" class="content" style="display: none; height: calc(100vh - 60px); ">
    <div id="StationSettingDisplay" style="margin-top: 40px">
        <div class="topnav-menu">
            <div class="topnav-right">
                <button id="Add_Rows" type="button" class="SettingButton" onclick="addGallery()">
                    <?php echo $text['add_rows_text'];?></button>
                <button id="Delete_Station" type="button" class="SettingButton">
                    <?php echo $text['delete_station_text'];?></button>
            </div>
        </div>
        <div class="container-ms" style="padding-left: 0%;vertical-align: middle;">
            <div class="scrollbar-station-all" id="style-station-all">
                <div class="force-overflow-station-all">
                    <div class="scrollbar-monitor-station" id="style-monitor-station">
                        <div id="addrows" class="force-overflow-monitor-station">
                            <?php
                                foreach ($data['monitor_rows'] as $key => $row) {
                                    echo '<div class="gallery" style="margin-bottom: 5px;">';

                                    $position_count = 1;

                                    foreach ($row as $key2 => $value) {

                                        if($value['position'] > $position_count){
                                            for ($i=$position_count; $i < $value['position']; $i++) { 
                                                echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                                echo     '<label style="background: #BDBABA; color: #fff; text-align: left;">';
                                                echo         '<div style="display: flex; justify-content: center;">';
                                                echo '<img id="Add-Station" src="./img/add-station.png" onclick="add_element_div('.$key.','.$i.')">';
                                                echo         '</div>';
                                                echo     '</label>';
                                                echo '</div>';
                                                $position_count++;

                                            }
                                            echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                            echo     '<label id="station_'.$value['id'].'_label" style="background: #00DCFA; color: #fff; text-align: left;" onclick="edit_element_div('.$value['id'].','.$key.','.$value['position'].')">';
                                            echo         '<div id="station_'.$value['id'].'_name">'.$value['name'].'</div>';
                                            echo         '<div id="station_'.$value['id'].'_ip" style="">'.$value['ip'].'</div>';
                                            // echo         '<div id="station_'.$value['id'].'_barcode">12345***</div>';
                                            echo         '<div id="station_'.$value['id'].'_jobname">aa-cc-0001</div>';
                                            echo         '<div id="station_'.$value['id'].'_screw_count">01/20</div>';
                                            echo         '<div id="station_'.$value['id'].'_finaltorque">1.N.m</div>';
                                            echo         '<div id="station_'.$value['id'].'_operator">Esther</div>';
                                            
                                            echo     '</label>';
                                            echo '</div>';
                                            $position_count++;

                                        }elseif ($value['position'] == $position_count) {
                                            // code...
                                            echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                            echo     '<label id="station_'.$value['id'].'_label" style="background: #00DCFA; color: #fff; text-align: left;" onclick="edit_element_div('.$value['id'].','.$key.','.$value['position'].')">';
                                            echo         '<div id="station_'.$value['id'].'_name">'.$value['name'].'</div>';
                                            echo         '<div id="station_'.$value['id'].'_ip" style="">'.$value['ip'].'</div>';
                                            // echo         '<div id="station_'.$value['id'].'_barcode">12345***</div>';
                                            echo         '<div id="station_'.$value['id'].'_jobname">aa-cc-0001</div>';
                                            echo         '<div id="station_'.$value['id'].'_xxx">01/20</div>';
                                            echo         '<div id="station_'.$value['id'].'_finaltorque">1.N.m</div>';
                                            echo         '<div id="station_'.$value['id'].'_operator">Esther</div>';
                                            
                                            echo     '</label>';
                                            echo '</div>';

                                            $position_count++;

                                        }
                                    }

                                    //補齊一排10個
                                    for ($i=$position_count; $i <= 10; $i++) { 
                                        echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                        echo     '<label style="background: #BDBABA; color: #fff; text-align: left;">';
                                        echo         '<div style="display: flex; justify-content: center;">';
                                        echo         '<img id="Add-Station" src="./img/add-station.png" onclick="add_element_div('.$key.','.$i.')">';
                                        echo         '</div>';
                                        echo     '</label>';
                                        echo '</div>';
                                        $position_count++;
                                    }

                                    echo '</div>';

                                }


                            ?>



                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Station_setting-Table" style="margin-top: 5px">
            <div class="scrollbar-Station" id="style-Station">
                <div class="force-overflow-Station">
                    <table class="table table-bordered table-hover" id="table-Station">
                        <thead id="header-table">
                            <tr style="text-align: center">
                                <th width="5%">ID</th>
                                <th width="15%">
                                    <?php echo $text['station_name_text'];?>
                                </th>
                                <th width="15%">IP</th>
                                <th width="10%">
                                    <?php echo $text['Operator_text'];?>
                                </th>
                                <th width="8%">
                                    <?php echo $text['Job_Name_text'];?>
                                </th>
                                <th width="15%">
                                    <?php echo $text['job_barcode_text'];?>
                                </th>
                                <th width="20%">Assembly</th>
                                <th width="8%">Sub</th>
                                <th width="5%" style="font-size: 24px" onclick="document.getElementById('Add_Field').style.display='block'">&#43;</th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                            <!-- <tr>
                                <td>1</td>
                                <td>A3</td>
                                <td>192.168.0.111</td>
                                <td>Luke</td>
                                <td>aa-cc-0001</td>
                                <td>12345***</td>
                                <td>--</td>
                                <td>--</td>
                                <td></td>
                            </tr> -->
                            <?php
                                foreach ($data['monitor_rows'] as $key => $row) {
                                    foreach ($row as $key2 => $value) {
                                        echo '<tr>';
                                        echo    '<td>'.$value['id'].'</td>';
                                        echo    '<td>'.$value['name'].'</td>';
                                        echo    '<td>'.$value['ip'].'</td>';
                                        echo    '<td>--</td>';
                                        echo    '<td>--</td>';
                                        echo    '<td>--</td>';
                                        echo    '<td>--</td>';
                                        echo    '<td>--</td>';
                                        echo    '<td></td>';
                                        echo '</tr>';
                                    }
                                }
                            ?>

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
                    <span onclick="document.getElementById('Add_Station').style.display='none'" class="w3-button w3-red w3-display-topright" style="padding: 7px; width: 60px; font-size: 23px">&times;</span>
                    <h3 id="add_modal_title">
                        <?php echo $text['add_station_text'];?>
                    </h3>
                </header>
                <div class="modal-body" style="padding-left: 10%">
                    <div class="row">
                        <div class="col-4 t1">
                            <?php echo $text['station_id_text'];?> :</div>
                        <div class="col-3 t2">
                            <!-- <label class="form-check-label" style="padding-left: 12%">1</label> -->
                            <input type="text" class="t3 form-control input-ms" id="station-id" value="1" disabled>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 t1">
                            <?php echo $text['station_name_text'];?> :</div>
                        <div class="col-5 t2">
                            <input type="text" class="t3 form-control input-ms" id="station-name" maxlength="">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 t1">
                            <?php echo $text['station_ip_text'];?> :</div>
                        <div class="col-5 t2">
                            <input type="text" class="t3 form-control input-ms" id="station-ip" maxlength="">
                        </div>
                        <div class="col-3 t2">
                            <button onclick="get_monitor_info()">get</button>
                        </div>
                    </div>
                    <div class="row">
                        <div for="Operator" class="col-4 t1">
                            <?php echo $text['Operator_text'];?> :</div>
                        <div class="option-custom col-7 t2">
                            <!-- <div class="select-input select-input-multiple form-control input-ms">
                                <div class="selected-list" id="selectedNamesOperator"></div>
                                <div class="select-click" id="selectClickOperator"></div>
                            </div>
                            <div class="select-list" id="selectListOperator">
                                <div class="select-item" data-value="1">Esther</div>
                                <div class="select-item" data-value="2">Peter</div>
                                <div class="select-item" data-value="3">Mary</div>
                                <div class="select-item" data-value="4">Luke</div>
                            </div> -->
                            <select class="js-example-basic-multiple" id="selectListOperator" name="operators[]" multiple="multiple" style="width: 100%">
                              <!-- <option value="AL">Alabama</option>
                              <option value="WY">Wyoming</option> -->
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div for="Job" class="col-4 t1">
                            <?php echo $text['job_select_text'];?> :</div>
                        <div class="option-custom col-7 t2">
                            <!-- <div class="select-input select-input-multiple form-control input-ms">
                                <div class="selected-list" id="selectedNamesJob"></div>
                                <div class="select-click" id="selectClickJob"></div>
                            </div>
                            <div class="select-list" id="selectListJob">
                                <div class="select-item" data-value="1">aa-cc - 123***</div>
                                <div class="select-item" data-value="2">Job-2 - 234**</div>
                                <div class="select-item" data-value="3">Job-3</div>
                                <div class="select-item" data-value="4">Job-abc</div>
                            </div> -->
                            <select class="js-example-basic-multiple" id="selectedJobs" name="jobs[]" multiple="multiple" style="width: 100%">
                              <!-- <option value="AL">Alabama</option>
                              <option value="WY">Wyoming</option> -->
                            </select>
                        </div>
                    </div>
                    <div style="display:none;">
                        <input id="mode" value="">
                        <input id="station_row" value="">
                        <input id="station_position" value="">
                    </div>
                </div>
                <div class="w3-center" style="background-color: #F2F1F1">
                    <button class="saveButton" onclick="save_element()">
                        <?php echo $text['Save_text'];?></button>
                    <button class="saveButton" onclick="delete_element()">
                        <?php echo $text['Delete_text'];?></button>
                </div>
            </div>
        </div>
    </div>
    <!-- Add Field Modal -->
    <div id="Add_Field" class="modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content w3-animate-zoom" style="width: 80%">
                <header class="w3-container modal-header">
                    <span onclick="document.getElementById('Add_Field').style.display='none'" class="w3-button w3-red w3-display-topright" style="padding: 7px; width: 60px; font-size: 23px">&times;</span>
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

<script type="text/javascript">
    $(document).ready(function() {
        // $('.js-example-basic-multiple').select2();
    });


    function add_element_div(row = 0,position = 0) {
        console.log(row,position)
        document.getElementById('station-id').value = '';
        document.getElementById('station_row').value = row
        document.getElementById('station_position').value = position
        document.getElementById('mode').value = 'add';
        document.getElementById('add_modal_title').innerHTML = 'Add Station';
        document.getElementById('station-name').value = ''
        document.getElementById('station-ip').value = ''

        //initial multiselect
        // $('#selectListOperator').select2('destroy');
        // $('#selectedJobs').select2('destroy');
        $("#selectListOperator").empty()
        $("#selectedJobs").empty()


        document.getElementById('Add_Station').style.display='block';
    }

    function edit_element_div(id,row = 0,position = 0) {
        console.log(row,position)
        document.getElementById('station-id').value = id;
        document.getElementById('station_row').value = row
        document.getElementById('station_position').value = position

        document.getElementById('station-name').value = document.getElementById('station_'+id+'_name').innerText
        document.getElementById('station-ip').value = document.getElementById('station_'+id+'_ip').innerText

        document.getElementById('mode').value = 'edit';
        document.getElementById('add_modal_title').innerHTML = 'Edit Station';

        //initial multiselect
        // $('#selectListOperator').select2('destroy');
        // $('#selectedJobs').select2('destroy');
        $("#selectListOperator").empty()
        $("#selectedJobs").empty()
        
        document.getElementById('Add_Station').style.display='block';
    }

    // Add Element 
    function save_element(argument) {

        let mode = document.getElementById('mode').value
        let station_name = document.getElementById('station-name').value
        let station_ip = document.getElementById('station-ip').value
        let station_operators = '';
        let station_jobs = '';
        let station_row = document.getElementById('station_row').value
        let station_position = document.getElementById('station_position').value
        let station_id = document.getElementById('station-id').value


        if(document.getElementById('selectListOperator').value != ''){
            let operators = $('#selectListOperator').select2('data');
            $.each(operators, function (i, item) {
                console.log(item.id)
                station_operators += item.id + ','
            });
        }
        
        if(document.getElementById('selectedJobs').value != ''){
            let jobs = $('#selectedJobs').select2('data');
            $.each(jobs, function (i, item) {
                console.log(item.id)
                station_jobs += item.id + ','
            });
        }


        var formData = new FormData();
        // 添加表单数据
        formData.append('mode', mode); // formData.append('mode', 'new');
        formData.append('station_name', station_name);
        formData.append('station_ip', station_ip);
        formData.append('station_operators', station_operators);
        formData.append('station_jobs', station_jobs);
        formData.append('station_row', station_row);
        formData.append('station_position', station_position);
        formData.append('station_id', station_id);

        let url = '?url=Monitors/EditMonitorElement';
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

    }

    // Add Rows
    function addGallery()
    {
        var newGallery = document.createElement('div');
        newGallery.className = 'gallery';
        newGallery.style.marginBottom = '5px';

        let current_row = document.querySelectorAll('#addrows .gallery').length;
        let row_index = current_row + 1

        for (var i = 1; i <= 10; i++) {
            var newStation = document.createElement('div');
            newStation.className = 'station';
            newStation.tabIndex = '1';
            newStation.style.marginRight = '9px';
            newStation.style.marginBottom = '7px';
            newStation.innerHTML = `
                <div class="station" tabindex="1">
                    <label style="background: #BDBABA; color: #fff; text-align: left;">
                        <div style="display: flex; justify-content: center;">
                            <img id="Add-Station" src="./img/add-station.png" onclick="add_element_div(`+row_index+','+i+`)">
                        </div>
                    </label>
                </div>
                `;
            newGallery.appendChild(newStation);
        }

        var addrows = document.getElementById('addrows');
        addrows.appendChild(newGallery);
    }

    function delete_element(argument) {

        let station_id = document.getElementById('station-id').value
        var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>');

        if (yes) {
            let url = '?url=Monitors/DeleteMonitorElement';
            $.ajax({
                type: "POST",
                data: {'station_id' : station_id},
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

    function get_monitor_info(argument) {
        // let url = '?url=Monitors/GetMonitorInfo';
        let ip = document.getElementById('station-ip').value

        if (ip != '') {
            let url = 'http://'+ip+'/CC2/public/index.php?url=Monitors/GetMonitorInfo';
            $.ajax({
                type: "POST",
                timeout: 3000, // 設定逾時時間為3000毫秒（3秒）
                // data: {'station_id' : station_id},
                dataType: "json",
                url: url,
                success: function(response) {
                    // 成功回調函數，處理伺服器的回應
                    console.log(response); // 在控制台輸出伺服器的回應
                    console.log(response.jobs);
                    $.each(response.users, function (i, item) {
                        $('#selectListOperator').append($('<option>', { 
                            value: item.id,
                            text : item.account 
                        }));
                    });
                    $.each(response.jobs, function (i, item) {
                        $('#selectedJobs').append($('<option>', { 
                            value: item.job_id,
                            text : item.job_name 
                        }));
                    });
                    $('.js-example-basic-multiple').select2({ closeOnSelect: false });

                    // history.go(0);
                },
                error: function(error) {
                    // 失敗回調函數，處理錯誤情況
                    // console.error('Error:', error); // 在控制台輸出錯誤訊息
                }
            }).fail(function () {
                // history.go(0);//失敗就重新整理
            });
        }else{
            alert('請輸入ip')
        }

    }


</script>