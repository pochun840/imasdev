<!-- Monitor -->
<div id="monitorContent" class="content" style="height: calc(100vh - 60px);">
    <div id="MonitorDisplay" style="margin-top: 40px">
        <div class="container-ms" style="padding-left: 0%;vertical-align: middle;">
            <div class="scrollbar-station-all" id="style-station-all">
                <div class="force-overflow-station-all">

                    <?php
                        foreach ($data['monitor_rows'] as $key => $row) {
                            echo '<div class="scrollbar-monitor-station" id="style-monitor-station">
                                    <div class="force-overflow-monitor-station">
                                    <div class="gallery" style="margin-bottom: 5px;">';

                            $position_count = 1;

                            foreach ($row as $key => $value) {

                                if($value['position'] > $position_count){

                                    for ($i=$position_count; $i < $value['position']; $i++) { 
                                        echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                        echo     '<label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">';
                                        echo         '<div>'.$i.','.$value['position'].'</div>';
                                        echo         '<div></div>';
                                        echo         '<div></div>';
                                        echo         '<div></div>';
                                        echo         '<div></div>';
                                        echo         '<div></div>';
                                        echo     '</label>';
                                        echo     '<div class="overlay">';
                                        echo     '</div>';
                                        echo '</div>';
                                        $position_count++;
                                    }

                                    echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                    echo     '<label id="station_'.$value['ip'].'" data-ip="'.$value['ip'].'" style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">';
                                    echo         '<div id="station_'.$value['id'].'_name">'.$value['name'].'</div>';
                                    echo         '<div id="station_'.$value['id'].'_barcode">12345***</div>';
                                    echo         '<div id="station_'.$value['id'].'_jobname">aa-cc-0001</div>';
                                    echo         '<div id="station_'.$value['id'].'_xxx">01/20</div>';
                                    echo         '<div id="station_'.$value['id'].'_finaltorque">1.N.m</div>';
                                    echo         '<div id="station_'.$value['id'].'_operator">Esther</div>';
                                    echo     '</label>';
                                    echo     '<div id="station_'.$value['ip'].'_status" class="overlay">';
                                    echo        $text['station_offline_text'];
                                    echo     '</div>';
                                    echo '<div id="'.$value['ip'].'" data-name="'.$value['name'].'" style="display:none;"></div>';
                                    echo '</div>';
                                    $position_count++;

                                }elseif ($value['position'] == $position_count) {
                                    // code...
                                    echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                    echo     '<label id="station_'.$value['ip'].'" style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">';
                                    echo         '<div id="station_'.$value['id'].'_name">'.$value['name'].'</div>';
                                    echo         '<div id="station_'.$value['id'].'_barcode">12345***</div>';
                                    echo         '<div id="station_'.$value['id'].'_jobname">aa-cc-0001</div>';
                                    echo         '<div id="station_'.$value['id'].'_xxx">01/20</div>';
                                    echo         '<div id="station_'.$value['id'].'_finaltorque">1.N.m</div>';
                                    echo         '<div id="station_'.$value['id'].'_operator">Esther</div>';
                                    echo     '</label>';
                                    echo     '<div id="station_'.$value['ip'].'_status" class="overlay">';
                                    echo        $text['station_offline_text'];
                                    echo     '</div>';
                                    echo '<div id="'.$value['ip'].'" data-name="'.$value['name'].'" style="display:none;"></div>';
                                    echo '</div>';

                                    $position_count++;

                                }
                            }

                            //補齊一排10個
                            for ($i=$position_count; $i <= 10; $i++) { 
                                echo '<div class="station" tabindex="1" style="margin-right: 9px; margin-bottom: 7px;">';
                                echo     '<label style="background: #BDBABA; color: #fff; text-align: left; padding-left: 3%;">';
                                echo         '<div></div>';
                                echo         '<div></div>';
                                echo         '<div></div>';
                                echo         '<div></div>';
                                echo         '<div></div>';
                                echo         '<div></div>';
                                echo     '</label>';
                                echo     '<div class="overlay">';
                                echo     '</div>';
                                echo '</div>';
                                $position_count++;
                            }

                            echo '</div></div></div>';

                        }


                    ?>

                </div>
            </div>
        </div>
        <div style="float: right"><button id="open-station" class="SettingButton" type="button" onclick="open_station()">
                <?php echo $text['open_station_text'];?></button></div>
        <div id="Monitor_table_setting" style="margin-top: 5px">
            <div class="scrollbar-monitor" id="style-monitor">
                <div class="force-overflow-monitor">
                    <table class="table table-bordered table-hover" id="table-monitor">
                        <thead id="header-table">
                            <tr style="text-align: center">
                                <th width="10%">
                                    <?php echo $text['station_name_text'];?>
                                </th>
                                <th width="10%">
                                    <?php echo $text['Torque_text'];?>
                                </th>
                                <th width="10%">
                                    <?php echo $text['Angle_text'];?>
                                </th>
                                <th width="10%">
                                    <?php echo $text['Status_text'];?>
                                </th>
                                <th width="10%">
                                    <?php echo $text['Operator_text'];?>
                                </th>
                                <th width="10%">
                                    <?php echo $text['Job_Name_text'];?>
                                </th>
                                <th width="10%">
                                    <?php echo $text['job_barcode_text'];?>
                                </th>
                                <th width="10%">Assembly</th>
                                <th width="10%">Sub</th>
                                <th width="10%">Controller</th>
                            </tr>
                        </thead>
                        <tbody id="tbody" style="background-color: #F2F1F1; font-size: 2vmin; text-align: center">
                            <!-- <tr>
                                <td>test</td>
                                <td>1.0</td>
                                <td>42375</td>
                                <td>OK-job</td>
                                <td>Esther</td>
                                <td>aa-cc-0001</td>
                                <td>12345***</td>
                                <td>assy-00-5</td>
                                <td>20235252</td>
                                <td>---</td>
                            </tr> -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- monitor server ws link -->
<script type="text/javascript">
    // const wsServer = 'ws://192.168.0.115:9527';
    const wsServer = 'ws://192.168.0.115:3000';
    const websocket = new WebSocket(wsServer);

    websocket.onopen = function (evt) {
        console.log("Connected to WebSocket server.");
        let random = Math.floor(Math.random() * 100) + 1;
        // document.getElementById('arm_div').classList.remove('gray-out');
        // send(random);
    };

    websocket.onclose = function (evt) {
        console.log("Disconnected");
        //把arm div反灰 gray-out
        document.getElementById('arm_div').classList.add('gray-out');
    };

    websocket.onmessage = function (evt) {
        // console.log('Retrieved data from server: ' + evt.data);
        display_ws_data(evt.data)
        // let obj = JSON.parse(evt.data);
        // console.log(obj.clientIp)
        // console.log(obj.data[0])
    };

    websocket.onerror = function (evt, e) {
        console.log('Error occured: ' + evt.data);
    };

    // 用于跟踪IP到表格行的映射
    const ipToTableRow = new Map();
    
    function display_ws_data(data2) {
        try {
              const data = JSON.parse(data2);
              console.log(data.data[0].data_time)
              let result_time_diff = time_diff(data.data[0].data_time)
              // 检查IP是否在映射中
              if (ipToTableRow.has(data.clientIp)) {

                  // 如果IP已存在，更新现有行
                  const row = ipToTableRow.get(data.clientIp);
                  // row.cells[0].textContent = 1;
                  row.cells[1].textContent = data.data[0].fasten_torque;
                  row.cells[2].textContent = data.data[0].fasten_angle;
                  row.cells[3].textContent = data.data[0].fasten_status;
                  row.cells[4].textContent = 'operator';
                  row.cells[5].textContent = data.data[0].job_name;
                  row.cells[6].textContent = data.data[0].cc_barcodesn;
                  row.cells[7].textContent = '';
                  row.cells[8].textContent = '';
                  row.cells[9].textContent = '';
                  // row.classList.add("breathing-row");// 閃的css
                  
                  //依據鎖附結果時間修改背景顏色
                  if(+result_time_diff < 10){
                    document.getElementById('station_'+data.clientIp).style.backgroundColor = '#14A800';
                    document.getElementById('station_'+data.clientIp+'_status').innerText = '<?php echo $text['station_fastening_text']; ?>';
                  }else if(+result_time_diff < 20){
                    document.getElementById('station_'+data.clientIp).style.backgroundColor = '#E9A759';
                    document.getElementById('station_'+data.clientIp+'_status').innerText = '<?php echo $text['station_standby_text']; ?>';
                  }else{
                    document.getElementById('station_'+data.clientIp).style.backgroundColor = '#E9A759';
                    document.getElementById('station_'+data.clientIp+'_status').innerText = '<?php echo $text['station_standby_text']; ?>';
                  }

                  setTimeout(() => {
                      // row.className = "";
                      row.classList.remove("breathing-row");
                  }, "1000");

                  // 更新其他单元格
                  // document.getElementById('station_'+data.clientIp).childNodes[0].innerHTML = ''; //station_2_name
                  document.getElementById('station_'+data.clientIp).childNodes[1].innerHTML = data.data[0].cc_barcodesn+'&nbsp;'; //station_2_barcode
                  document.getElementById('station_'+data.clientIp).childNodes[2].innerHTML = data.data[0].job_name+'&nbsp;'; //station_2_jobname
                  document.getElementById('station_'+data.clientIp).childNodes[3].innerHTML = ''+'&nbsp;'; //station_2_xxx
                  document.getElementById('station_'+data.clientIp).childNodes[4].innerHTML = data.data[0].fasten_torque; //station_2_finaltorque
                  document.getElementById('station_'+data.clientIp).childNodes[5].innerHTML = 'operator'; //station_2_operator

              } else {
                  if(data.clientIp != null){

                  //get station name
                  let station_name = document.getElementById(data.clientIp).getAttribute('data-name')

                  // 如果IP不存在，创建一行
                  const table = document.getElementById("table-monitor").getElementsByTagName('tbody')[0];
                  const row = table.insertRow();
                  row.insertCell(0).textContent = station_name;
                  row.insertCell(1).textContent = data.data[0].fasten_torque;
                  row.insertCell(2).textContent = data.data[0].fasten_angle;
                  row.insertCell(3).textContent = data.data[0].fasten_status;
                  row.insertCell(4).textContent = 'operator';
                  row.insertCell(5).textContent = data.data[0].job_name;
                  row.insertCell(6).textContent = data.data[0].cc_barcodesn;
                  row.insertCell(7).textContent = '';
                  row.insertCell(8).textContent = '';
                  row.insertCell(9).textContent = '';
                  row.insertCell(10).textContent = data.clientIp;
                  row.cells[10].style.display = 'none'//ip
                  // // row.className = "breathing-row";// 閃的css

                  //依據鎖附結果時間修改背景顏色
                  if(+result_time_diff < 10){
                    document.getElementById('station_'+data.clientIp).style.backgroundColor = '#14A800';
                    document.getElementById('station_'+data.clientIp+'_status').innerText = '<?php echo $text['station_fastening_text']; ?>';
                  }else if(+result_time_diff < 20){
                    document.getElementById('station_'+data.clientIp).style.backgroundColor = '#E9A759';
                    document.getElementById('station_'+data.clientIp+'_status').innerText = '<?php echo $text['station_standby_text']; ?>';
                  }else{
                    document.getElementById('station_'+data.clientIp).style.backgroundColor = '#E9A759';
                    document.getElementById('station_'+data.clientIp+'_status').innerText = '<?php echo $text['station_standby_text']; ?>';
                  }

                  // 将IP与表格行关联
                  ipToTableRow.set(data.clientIp, row);
                  // console.log(ipToTableRow);

                  // table.row.add( row ).draw();

                  // 更新其他单元格
                  // document.getElementById('station_'+data.clientIp).childNodes[0].innerHTML = ''; //station_2_name
                  document.getElementById('station_'+data.clientIp).childNodes[1].innerHTML = data.data[0].cc_barcodesn+'&nbsp;'; //station_2_barcode
                  document.getElementById('station_'+data.clientIp).childNodes[2].innerHTML = data.data[0].job_name+'&nbsp;'; //station_2_jobname
                  document.getElementById('station_'+data.clientIp).childNodes[3].innerHTML = ''+'&nbsp;'; //station_2_xxx
                  document.getElementById('station_'+data.clientIp).childNodes[4].innerHTML = data.data[0].fasten_torque+'&nbsp;'; //station_2_finaltorque
                  document.getElementById('station_'+data.clientIp).childNodes[5].innerHTML = 'operator'; //station_2_operator

                }

              }
              highlight_row('table-monitor');
          } catch (error) {
              console.error("Error parsing JSON message: " + error);
          }
    }

    function open_station(argument) {
        let ip;
        try { 
            ip = document.getElementsByClassName('selected')[0].cells[10].innerText;
        } catch (error) {
            ip = null; /* 任意默认值都可以被使用 */
        };

        document.getElementsByClassName('selected')[0].c
        console.log(ip)
        if (ip != null) {
            window.open("http://"+ip+"/CC2/public/", "_blank");
        }
    }

    function time_diff(dateime) {

        // 假設資料時間為這個格式（UTC）
        // const dataTimeString = '20240920 01:49:27'; // YYYYMMDD HH:mm:ss
        const dataTimeString = dateime; // YYYYMMDD HH:mm:ss

        // 將資料時間轉換為 Date 對象（UTC）
        const year = parseInt(dataTimeString.substring(0, 4), 10);
        const month = parseInt(dataTimeString.substring(4, 6), 10) - 1; // 月份從0開始
        const day = parseInt(dataTimeString.substring(6, 8), 10);
        const hours = parseInt(dataTimeString.substring(9, 11), 10);
        const minutes = parseInt(dataTimeString.substring(12, 14), 10);
        const seconds = parseInt(dataTimeString.substring(15, 17), 10);

        // 創建 UTC Date 對象
        const dataDateUTC = new Date(Date.UTC(year, month, day, hours, minutes, seconds));
        const dataDate = new Date(year, month, day, hours, minutes, seconds);


        // 獲取當前時間（本地時間）
        const currentDate = new Date();

        // 計算時間差（毫秒）
        const timeDifferenceMS = currentDate - dataDateUTC;
        // const timeDifferenceMS = currentDate - dataDate;

        // 計算差異的各種單位
        const timeDifferenceSecs = Math.floor(timeDifferenceMS / 1000);
        const timeDifferenceMins = Math.floor(timeDifferenceMS / (1000 * 60));
        const timeDifferenceHours = Math.floor(timeDifferenceMS / (1000 * 60 * 60));
        const timeDifferenceDays = Math.floor(timeDifferenceMS / (1000 * 60 * 60 * 24));

        // 輸出結果
        // console.log(`UTC 資料時間: ${dataDateUTC.toISOString()}`);
        // console.log(`當前本地時間: ${currentDate.toISOString()}`);
        // console.log(`時間差（毫秒）: ${timeDifferenceMS}`);
        // console.log(`時間差（秒）: ${timeDifferenceSecs}`);
        // console.log(`時間差（分鐘）: ${timeDifferenceMins}`);
        // console.log(`時間差（小時）: ${timeDifferenceHours}`);
        // console.log(`時間差（天）: ${timeDifferenceDays}`);

        return timeDifferenceMins;
    }
</script>