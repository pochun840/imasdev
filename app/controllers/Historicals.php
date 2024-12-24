<?php

class Historicals extends Controller
{
    private $DashboardModel;
    private $NavsController;


    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->NavsController = $this->controller_new('Navs');
        $this->UserModel = $this->model('User');
        $this->Historicals_newModel = $this->model('Historical');
    }

    public function index($page)
    {


        $nopage = isset($_COOKIE["nopage"]) ? $_COOKIE["nopage"] : "0";
        $limit = 30;
        $offset = 0;
        $totalPages = 0;


        if($nopage == "1") {
            $page = isset($_GET['p']) ? $_GET['p'] : 1;
            $offset = ($page - 1) * $limit;
            $totalItems = $this->Historicals_newModel->getTotalItemCount();

            if (!empty($totalItems)) {
                $totalPages = ceil($totalItems / $limit);
            }
        }


        #資料取得
        $info = $this->getMonitorsInfo($nopage, $offset, $limit);
        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $all_roles = array_slice($this->UserModel->GetAllRole(), 0, 3);
        $res_status_arr = ['ALL', 'OK', 'OKALL', 'NG'];
        $res_controller_arr = array(1 => 'GTCS', 2 =>'TCG'); 
        $all_users = $this->UserModel->GetAllUser(); //取得還活著USER
        $torque_arr = $this->Historicals_newModel->details('torque');
        $res_program = $this->Historicals_newModel->details('program');


        #取得該帳號的權限
        $account = $_SESSION['user'];
        $user_permissions =  $this->UserModel->GetUserByName($account);
        
        #取得所有的job_id
        $job_arr = $this->Historicals_newModel->get_job_id();
        $status_arr = $this->Historicals_newModel->status_code_change();

        #判斷瀏覽器
        $browser = $this->Historicals_newModel->getBrowserType();

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'all_roles' => $all_roles,
            'all_users' => $all_users,
            'res_status_arr' =>  $res_status_arr,
            'res_controller_arr' => $res_controller_arr,
            'res_program' => $res_program,
            'info' => $info,
            'totalPages' => $totalPages,
            'nopage' => $nopage,
            'page' => $page,
            'torque_arr' => $torque_arr,
            'status_arr' => $status_arr,
            'job_arr' => $job_arr,
            'path' => __FUNCTION__,
            'user_role_title' => $user_permissions['Title'],
            'browser' => $browser
        ];


        $this->view('historicals/index', $data);
    }

    #隱藏鎖附資料
    public function del_info(){

        $del_info_sn_arr = array();
        $del_info_sn = $_POST['values'];
        
        $res = $this->Historicals_newModel->del_info($del_info_sn);

        #紀錄log 
        $temp_value = implode(", ", $del_info_sn); 
        $detail = 'success: system_sn:'.$temp_value;
        $this->logMessage('del_historicals', $res,$detail);
        return $res;
    }


    #搜尋資料
    public function search_info_list() {

        $info_arr = array();
        $info_arr = $_POST;
    
        $_SESSION['info_arr'] = $info_arr; 

        if (!empty($info_arr)) {
        
            $offset = 0;
            $limit  = 10000;

            #按照POST的資訊 取得資料庫搜尋的結果
            $info_tmp  = $this->Historicals_newModel->get_data($info_arr);
          
        }
    
        $torque_arr = $this->Historicals_newModel->details('torque');
        $status_arr = $this->Historicals_newModel->status_code_change();
        $res_controller_arr = array(1 => 'GTCS', 2 => 'TCG'); 
    
        $system_sns = [];


        #按照POST的資訊 取得資料庫搜尋的結果
        //$info_tmp = $this->Historicals_newModel->monitors_info($info_arr,$offset,$limit);

        if (!empty($info_tmp)) {
            $info_data = "";
            
            foreach ($info_tmp as $k => $v) {
                
                $color = $status_arr['status_color'][$v['fasten_status']];
                $style = 'background-color:' . $color . ';font-size: 20px';
    
                // 收集 system_sn
                $system_sns[] = $v['system_sn'];  
    
                $info_data = "<tr>";
                $info_data .= '<td style="text-align: center;"><input class="form-check-input" type="checkbox" name="test1" id="test1"  value="' . $v['system_sn'] . '" style="zoom:1.2;vertical-align: middle;"></td>';
                $info_data .= "<td id='system_sn'>" . $v['system_sn'] . "</td>";
                $info_data .= "<td>" . $v['data_time'] . "</td>";
                $info_data .= "<td></td>";
                $info_data .= "<td>" . $v['cc_barcodesn'] . "</td>";
                $info_data .= "<td>" . $v['job_name'] . "</td>";
                $info_data .= "<td>" . $v['sequence_name'] . "</td>";
                $info_data .= "<td>" . $v['cc_task_id'] . "</td>";
                $info_data .= "<td>" . $res_controller_arr[$v['cc_equipment']] . "</td>";
                $info_data .= "<td>" . $v['step_lowtorque'] . " ~ " . $v['step_hightorque'] . "</td>";
                $info_data .= "<td>" . $v['step_lowangle'] . " ~ " . $v['step_highangle'] . "</td>";
                $info_data .= "<td>" . $v['fasten_torque'] . $torque_arr[$v['torque_unit']] . "</td>";
                $info_data .= "<td>" . $v['fasten_angle'] . " deg </td>";
                $info_data .= "<td style='" . $style . "'>" . $status_arr['status_type'][$v['fasten_status']] . "</td>";
                $info_data .= "<td>" . $status_arr['error_msg'][$v['error_message']] . "</td>";
                $info_data .= "<td>" . $v['cc_program_id'] . "</td>";
                $info_data .= "<td><a href=\"?url=Historicals/nextinfo/" . $v['id'] . "\"><img src=\"./img/info-30.png\" style=\"height: 28px; vertical-align: middle;\" ></a></td>";
                $info_data .= "</tr>";
    
                echo $info_data;
    
                // system_sn 数据传给前端
                echo '<script>window.systemSnList = ' . json_encode($system_sns) . ';</script>';
            }
        } else {
      
            echo '';
        }
    }
    

    #產生CSV的文件 
    #利用system_sn 取得完整的鎖附資料
    public function csv_downland(){
        if(!empty($_COOKIE['systemSnval'])){
            $system_sn = $_COOKIE['systemSnval'];
            if($system_sn != 'total'){
                $pos = strpos($system_sn, ',');

                if ($pos !== false) {
                    $system_sn_array = explode(",", $system_sn);
                    $system_sn_in = implode("','", $system_sn_array);
                
                }else{
                    $system_sn_in = $system_sn;
                }
            }else{
                $system_sn_in = 'total';
            }
           
            #取得該筆的所有完整詳細資料
            $info_arr = $_SESSION['info_arr'];
            $info_final = $this->Historicals_newModel->get_data($info_arr);
            //$info_final = $this->Historicals_newModel->csv_info($system_sn_in);
            $newKeys = range(0, 48); 

            #扭力轉換 
            $torque_change = $this->Historicals_newModel->details('torque');

            #狀態轉換 
            $status_arr = $this->Historicals_newModel->status_code_change();


            #控制器轉換
            $res_controller_arr = array(0 => '', 1 => 'GTCS', 2 =>'TCG'); 

            //整理陣列 
            foreach($info_final as $kk =>$vv){
                $info_final[$kk]['torque_unit']    = $torque_change[$vv['torque_unit']];
                $info_final[$kk]['fasten_status']  = $status_arr['status_type'][$vv['fasten_status']];
                $info_final[$kk]['cc_equipment']   = $res_controller_arr[$vv['cc_equipment']];
            }

            #CSV檔名
            $filename = 'data.csv';
            $file = fopen($filename, 'w');
            fputcsv($file,  array('id','cc_barcodesn','cc_station','cc_job_id','cc_seq_id','cc_task_id','cc_program_id','cc_equipment','cc_operator','system_sn','data_time','device_type','device_id','device_sn','tool_type','tool_sn','tool_status','job_id','job_name','sequence_id','sequence_name','step_id','fasten_torque','torque_unit','fasten_time','fasten_angle','count_direction','last_screw_count','max_screw_count','fasten_status','error_message','step_targettype','step_tooldirection','step_rpm','step_targettorque','step_hightorque','step_lowtorque','step_targetangle','step_highangle','step_lowangle','step_delayttime','threshold_torque','step_threshold_angle','downshift_torque','downshift_speed','step_prr_rpm','step_prr_angle','barcode','total_angle','on_flag','cc_task_name'));
            foreach ($info_final as $row) {
                fputcsv($file, $row);
            }
            fclose($file);
            header('Content-Type: text/csv');
            header('Content-Disposition: attachment; filename="' . $filename . '"');
            readfile($filename);

            unlink($filename);

        }     
    }

  
    #鎖附資料 圖表 
    public function history_result(){
        
        $data = array();
        $status_arr = $this->Historicals_newModel->status_code_change();

        if (isset($_SESSION['info_arr'])) {
            $info_arr = $_SESSION['info_arr'];
          
        } else {
            $info_arr = [];
        }

        $offset = 0;
        $limit  = 10000;
        $info = $this->Historicals_newModel->get_data($info_arr, $offset, $limit);
        $mode_arr = array('ng_reason','fastening_status','job_info_new','job_info','statistics');


        #NG REASON 
        foreach($mode_arr as $key =>$val){
            
            if($val =="ng_reason"){
                if(!empty($info_arr)){
                    if($info_arr['status_val']  != "1" && $info_arr['status_val'] !="2"){
                        $ng_reason_temp = $this->Historicals_newModel->for_history_temp($val,$info);
                        if(!empty($ng_reason_temp)){
                            $ng_reason = $this->processNgReasonData($ng_reason_temp, $status_arr);
                            
                            $data['ng_reason_json'] = json_encode($ng_reason);
                        }else{
                            $data['ng_reason_json'] = '';
                            
                        }
                    }
                }
                
               
            }

            if ($val == "fastening_status") {
                $fastening_status_temp = $this->Historicals_newModel->for_history_temp($val, $info);
                if (!empty($fastening_status_temp)) {
                    foreach ($fastening_status_temp as $key2 => $val2) {
                        if (isset($status_arr['status_type'][$val2['fasten_status']])) {
                            $fastening_status_temp[$key2]['status_type'] = $status_arr['status_type'][$val2['fasten_status']];
                        } else {
                            $fastening_status_temp[$key2]['status_type'] = 'Unknown';
                        }
                    }
            
                    $fastening_status = array();
                    foreach ($fastening_status_temp as $item1) {
                        $fastening_status[] = array(
                            'value' => $item1['total'],   
                            'name'  => $item1['status_type'] 
                        );
                    }
                    $data['fastening_status'] = json_encode($fastening_status);
                }
            }
            

        
            if ($val == "job_info_new") {

                $job_info_temp = $this->Historicals_newModel->for_history_temp($val, $info);

                if (!empty($job_info_temp)) {
      
                    $job_names = array();
                    $fasten_time = array();
 
                    foreach ($job_info_temp  as $job_name => $fasten_time_value) {
                        $job_names[] = $job_name;         
                        $fasten_time[] = $fasten_time_value;  
                    }
    
                    $job_name_json = json_encode($job_names);
                    $fasten_time_json = json_encode($fasten_time);

                    $data['job_info']['job_name'] = $job_name_json;
                    $data['job_info']['fasten_time'] = $fasten_time_json;
                }

              
            }

            if($val == "job_info"){
                $job_info = $this->Historicals_newModel->for_history_temp($val, $info);
                $data['job_time_json'] = json_encode($job_info);
            }


            if($val == "statistics"){
                $statistics_temp = array();
                $statistics_temp = $this->Historicals_newModel->for_history_temp($val, $info); 
                if (!empty($statistics_temp)) {
                    $line_title = [];
                    $line_ng = [];
                    $line_ok = [];
                    $line_okall = [];
                    
                    foreach ($statistics_temp as $date => $val) {
                        $line_title[] = $date; 
                        $line_ng[] = $val['NG']; 
                        $line_ok[] = $val['OK']; 
                        $line_okall[] = $val['OK_ALL']; 
                    }

                    $data['statistics']['date'] = json_encode($line_title);
                    $data['statistics']['ng'] = json_encode($line_ng);
                    $data['statistics']['ok'] = json_encode($line_ok);
                    $data['statistics']['ok_all'] = json_encode($line_okall);
            
        
                }
            }
        }

       

        if(!empty($_GET['type'])){
            if($_GET['type'] =="download"){
                $data['type'] = "download";
            }

        }else{
            $data['type'] = '';
        }


        $this->view('historicals/index_report_history',$data);
    }


    public function nextinfo($index) {

        if(!empty($index)) {
            $data = array();

            $data['job_info'] = $this->Historicals_newModel->get_info_data_by_id($index);
                
            if(empty($data['job_info'])){
                $redirectUrl = '?url=Historicals';
                header('Location: ' . $redirectUrl);
                exit();
            }

            $data['chat_y_max_val'] = $data['job_info'][0]['step_hightorque'];
            $data['chat_y_min_val'] = $data['job_info'][0]['step_lowtorque'];
 

            #檢查chat_mode cookie
            $chat_mode = isset($_COOKIE['chat_mode_change']) ? $_COOKIE['chat_mode_change'] : "1";
    
            #取得unitvalue
            $unitvalue = isset($_GET['unitvalue']) ? $_GET['unitvalue'] : $data['job_info'][0]['torque_unit'];
    
            $data['unitvalue'] = $unitvalue;
    
            #曲線圖模式
            $chat_mode_arr = $this->Historicals_newModel->details('chart_type');
            $data['chat_mode_arr'] = $chat_mode_arr;
    
            #取得圖表模式
            $chat_arr = $this->Historicals_newModel->chat_change($chat_mode);
            $data['chat'] = $chat_arr;
    
            #取得完整的資料
            $length = strlen($data['job_info'][0]['id']);
            if ($length < 4) {
     
                $no = sprintf("%04d", $data['job_info'][0]['system_sn']);
            } else {
                $no = $data['job_info'][0]['system_sn'];
            }
         
            $temp_x_val = $this->Historicals_newModel->get_column_values_by_index($no,1);
         
            $csvdata_arr = $this->Historicals_newModel->get_info($no, $chat_mode);

            #依照 job_id 判斷  advancedstep or  normalstep
            $data['job_type'] = intval($data['job_info'][0]['job_id']) > 100 ? "advancedstep" : "normalstep";

            
            if(!empty($csvdata_arr)){

                #尋牙轉速
                $step_prr_rpm   = $data['job_info'][0]['step_prr_rpm'];
                #尋牙角度
                $step_prr_angle = $data['job_info'][0]['step_prr_angle'];
                $data['chart_info'] = $this->ChartData($chat_mode, $csvdata_arr, $unitvalue, $chat_mode_arr,$temp_x_val,$no,$step_prr_rpm,$step_prr_angle );
                
                #設定曲線圖的座標名稱
                $titles = $this->Historicals_newModel->extractXYTitles($data['chart_info']['chat_title']);
                $data['chart_info']['x_title'] = $titles['x_title'];
                $data['chart_info']['y_title'] = $titles['y_title'];
                $data['chart_info']['chat_mode'] = $chat_mode;



                
            }
            #狀態列表
            $status_arr = $this->Historicals_newModel->status_code_change();
            $data['status_arr'] = $status_arr;

            $torque_mode_arr = $this->Historicals_newModel->details('torque');
            $data['torque_mode_arr'] = $torque_mode_arr;
        
            $data['nav'] = $this->NavsController->get_nav();
            $data['nopage'] = 0;
            $data['path'] = __FUNCTION__;

            $data['res_controller_arr'] = array(1 => 'GTCS', 2 =>'TCG'); 

            $this->view('historicals/index', $data);
    
        }
    }

    #利用job_id 找到對應的seq_id && task_id 
    #並組成 html的checkbox 格式
    public function get_correspond_val(){
        $val  = array();
        
        #檢查 $_POST['job_id'] 和 $_POST['seq_id'] 是否存在且不為空
        if(isset($_POST['job_id'][0]) && !empty($_POST['job_id'][0])) {
            $job_id = $_POST['job_id'][0];
    
            #取得對應的seq_id
            if(empty($_POST['seq_id'][0])) {
                $info_seq = $this->Historicals_newModel->get_seq_id($job_id);
    
                #組checkbox的seq的html
                if(!empty($info_seq)){
                    foreach($info_seq as $k_seq => $v_seq){
                        echo $this->generatecheckboxhtml($v_seq['seq_id'], $v_seq['seq_name'], 'seqid', 'JobCheckbox_seq');
                    }
                }
            }
    
            #透過job_id 及 seq_id 取得對應的task_id
            if(isset($_POST['seq_id'][0]) && !empty($_POST['seq_id'][0])) {
                $seq_id = $_POST['seq_id'][0];
                $info_task = $this->Historicals_newModel->get_task_id($job_id, $seq_id);
    
                #組checkbox的task的html
                if(!empty($info_task)){
                    foreach($info_task as $k_task => $v_task){
                        echo $this->generatecheckboxhtml($v_task['task_id'], $v_task['task_id'], 'taskid', 'JobCheckbox_task');
                    }
                }
            }
        }
    }

    
    private function generatecheckboxhtml($value, $label, $name, $onClickFunction) {
        $checkbox_html = '<div class="row t1">';
        $checkbox_html .= '<div class="col t5 form-check form-check-inline">';
        $checkbox_html .= '<input class="form-check-input" type="checkbox" name="' .$name. '" id="' .$name. '" value="' .$value. '" onclick="' .$onClickFunction.'()" style="zoom:1.0; vertical-align: middle;">&nbsp;';
        $checkbox_html .= '<label class="form-check-label" id="'.$name.'-name-'.$label.'">'.$label.'</label>';
        $checkbox_html .= '</div>';
        $checkbox_html .= '</div>';
        return $checkbox_html;
    }


    public function combinedata() {
        // 取得 chart 模式
        $data['chat_mode'] = !empty($_GET['chart']) ? $_GET['chart'] : 1;
        // 取得 unit
        $data['unit'] = !empty($_GET['unit']) ? $_GET['unit'] : 1;
        $TransType = $data['unit'];


        $torque_arr = $this->Historicals_newModel->details('torque');

        // 用 cookie 取得已勾選的 id

        
        if (!empty($_COOKIE['checked_system_sn'])) {

            $checkedsn = $_COOKIE['checked_system_sn'];

            if (strpos($checkedsn, "?url=Historicals/nextinfo/") !== false) {
                // 如果包含，移除 "?url=Historicals/nextinfo/"
                $checkedsn = str_replace("?url=Historicals/nextinfo/", "", $checkedsn);
                $tmp = $this->Historicals_newModel->get_system_sn($checkedsn);
                if(!empty($tmp)){
                    $checkedsn  = '';
                    foreach($tmp as $kv =>$vv){
                        $checkedsn .= $vv['system_sn'].","; 
                    }
                }
                $checkedsn = rtrim($checkedsn, ',');
            } else {
                //$checkedsn = explode(",",$checkedsn);
            }


            $info_arr = array();
            $info_arr['system_sn'] =  $checkedsn;

            // 取得所有的資料
            //$info_final = $this->Historicals_newModel->get_data($info_arr);
            $info_final = $this->Historicals_newModel->csv_info($checkedsn);  
            $data['chat_mode_arr_combine'] = $this->Historicals_newModel->details('chart_type');
            $data['info_final'] = $info_final;
            $checked_sn_in = array();
            if(!empty($info_final)){
                foreach($info_final as $kk =>$vv){
                    $checked_sn_in[] = $vv['system_sn'];
                }
            }

            // 取得曲線圖 ID
            $id = '';
            foreach ($info_final as $item) {
                $id .= sprintf("%04d", $item['system_sn']) . ",";
            }
            $id = rtrim($id, ',');
            $new_id = $id;
            $id_array = explode(',', $new_id);
            $data['id_total'] = $id_array;


            // 取得曲線圖的資料
            $final_label = $this->Historicals_newModel->get_result($checkedsn, $data['chat_mode']);

            
            
            if (empty($final_label)) {
                $final_label = null;
            } else {

                // 處理曲線圖的數據
                $chartData = [];
                $xCoordinates = [];
                $data_count = 25;

                for ($i = 0; $i < $data_count; $i++) {
                    $dataKey = "data$i";
                    if (isset($final_label[$dataKey])) {
                        $dataSet = $final_label[$dataKey];

                        
                        
                        if ($data['chat_mode'] == 5) {

                            $xValues = array_slice(array_column($dataSet, 2), 1);


                            $xCoordinates[$i] = json_encode($xValues); // 將 X 軸數據轉換為 JSON 格式
                            $chartData[$i]['y'] = array_column($dataSet, 1); // 將 value[1] 作為 Y 軸數據
                            
                            // 設置預設的 max 和 min 值
                            $chartData[$i]['max'] = floatval(max($chartData[$i]['y']));
                            $chartData[$i]['min'] = floatval(min($chartData[$i]['y']));
        
                        } else if ($data['chat_mode'] == 6) {


                            $tmp_x_val = $this->Historicals_newModel->get_column_values_by_index($id,1);
                          
                            $time_position = array_search("Time", $tmp_x_val);
                            $angle_position = array_search("Angle", $tmp_x_val);
                            
                            // 判断是否找到了 "Time" 或 "Angle"
                            if ($time_position !== false && $angle_position !== false) {
                                // 比较 "Time" 和 "Angle" 的位置
                                if ($time_position < $angle_position) {
                                    // "Time" 在 "Angle" 前面
                                    $new_array = array_slice($tmp_x_val, $time_position + 1);
                                    $tmp_x_val = array_slice($tmp_x_val, 0, $time_position);
                                } else {
                                    // "Angle" 在 "Time" 前面
                                    $new_array = array_slice($tmp_x_val, $angle_position + 1);
                                    $tmp_x_val = array_slice($tmp_x_val, 0, $angle_position);
                                }
                            } elseif ($time_position !== false) {
                                // 只有 "Time" 存在
                                $new_array = array_slice($tmp_x_val, $time_position + 1);
                                $tmp_x_val = array_slice($tmp_x_val, 0, $time_position);
                            } elseif ($angle_position !== false) {
                                // 只有 "Angle" 存在
                                $new_array = array_slice($tmp_x_val, $angle_position + 1);
                                $tmp_x_val = array_slice($tmp_x_val, 0, $angle_position);
                            } else {
                                // 如果都没有找到
                                $new_array = [];
                            }

                           
                            $xCoordinates[$i] = json_encode($tmp_x_val); 

                            //處理Y軸的torque 
                            $data_torque = array_column($dataSet, 1);
                            $length = count($data_torque);
                            //處理Y軸的angle
                            $data_angle = array_column($dataSet, 2);
                            $length = count($data_angle);

                            // 進行數據轉換
                            $chartData[$i]['y'] = $this->prepareChartData($data_torque, $TransType, $data['unit']);
                            $chartData[$i]['y_angle'] = $data_angle;
                         
                            // 計算 max 和 min 值
                            $chartData[$i]['max'] = floatval(max($chartData[$i]['y']));
                            $chartData[$i]['min'] = floatval(min($chartData[$i]['y']));
                            $chartData[$i]['max_angle'] = floatval(max($chartData[$i]['y_angle']));
                            $chartData[$i]['min_angle'] = floatval(min($chartData[$i]['y_angle']));

                            $max_angle_values[] = $chartData[$i]['max_angle'];
                            $overallMaxAngle = max($max_angle_values);
                            $data['overall_max_angle'] = $overallMaxAngle; 
                        } else {
                            
                            $tmp_x_val = $this->Historicals_newModel->get_column_values_by_index($id,1);
                    
                            $time_position = array_search("Time", $tmp_x_val);
                            $angle_position = array_search("Angle", $tmp_x_val);
                            
                            // 判断是否找到了 "Time" 或 "Angle"
                            if ($time_position !== false && $angle_position !== false) {
                                // 比较 "Time" 和 "Angle" 的位置
                                if ($time_position < $angle_position) {
                                    // "Time" 在 "Angle" 前面
                                    $new_array = array_slice($tmp_x_val, $time_position + 1);
                                    $tmp_x_val = array_slice($tmp_x_val, 0, $time_position);
                                } else {
                                    // "Angle" 在 "Time" 前面
                                    $new_array = array_slice($tmp_x_val, $angle_position + 1);
                                    $tmp_x_val = array_slice($tmp_x_val, 0, $angle_position);
                                }
                            } elseif ($time_position !== false) {
                                // 只有 "Time" 存在
                                $new_array = array_slice($tmp_x_val, $time_position + 1);
                                $tmp_x_val = array_slice($tmp_x_val, 0, $time_position);
                            } elseif ($angle_position !== false) {
                                // 只有 "Angle" 存在
                                $new_array = array_slice($tmp_x_val, $angle_position + 1);
                                $tmp_x_val = array_slice($tmp_x_val, 0, $angle_position);
                            } else {
                                // 如果都没有找到
                                $new_array = [];
                            }

                            
                            $xCoordinates[$i] = json_encode($tmp_x_val); 
                            $chartData[$i]['y'] = $this->prepareChartData($dataSet, $TransType, $data['unit']);
                            $chartData[$i]['max'] = floatval(max($chartData[$i]['y']));
                            $chartData[$i]['min'] = floatval(min($chartData[$i]['y']));

                            if($data['chat_mode'] == 3 || $data['chat_mode'] == 4 ){
                                if (isset($dataSet[0])) {
                                    unset($dataSet[0]); 
                                }
                                $values = array_column($dataSet, 'value');
                                
                                $data["chart{$i}_ycoordinate_torque_rpm"] = json_encode(array_values($dataSet));
                                
                            }

                        }
                    }

                }

                // 設置圖表數據和座標
                $data['chart_xcoordinates'] = $xCoordinates;
                foreach ($chartData as $key => $chart) {

                    
                    $data["chart{$key}_ycoordinate"] = json_encode($chart['y']);

                    $yValues = json_decode($data["chart{$key}_ycoordinate"], true);
                    $data["chart{$key}_ycoordinate_max"] = max($chart['y']);
                    $data["chart{$key}_ycoordinate_min"] = min($chart['y']);

                    $data["chart{$key}_ycoordinate_max_correct"] = $data['info_final'][$key]['step_hightorque'];
                    $data["chart{$key}_ycoordinate_min_correct"] = $data['info_final'][$key]['step_lowtorque'];
                    $data["chart{$key}_ycoordinate_threshold_torque"] =  $data['info_final'][$key]['threshold_torque'];
                    $data["chart{$key}_ycoordinate_downshift_torque"] =  $data['info_final'][$key]['downshift_torque'];
                    //$data["chart{$key}_ycoordinate_step_threshold_angle"] =  $data['info_final'][$key]['step_threshold_angle'];

                
                    if (isset($chart['y_angle'])) {
                        $data["chart{$key}_ycoordinate_angle"] = json_encode(array_slice($chart['y_angle'], 1));
                        
                        $angleValues = json_decode($data["chart{$key}_ycoordinate_angle"], true);
                        $data["chart{$key}_ycoordinate_max_angle"] = max($angleValues);
                        $data["chart{$key}_ycoordinate_min_angle"] = min($angleValues);
                    }


                }

               

                // 設置曲線圖座標名稱
                $chartTypeDetails = $this->Historicals_newModel->details('chart_type');
                $data['chat_mode'] = (int)$data['chat_mode'];
                $lineTitle = isset($chartTypeDetails[$data['chat_mode']]) ? $chartTypeDetails[$data['chat_mode']] : '';
                $titles = $this->Historicals_newModel->extractXYTitles($lineTitle);

                $data['chart_combine']['x_title'] = $titles['x_title'];
                $data['chart_combine']['y_title'] = $titles['y_title'];

            }

            // 單位換算
            $torque_mode_arr = $this->Historicals_newModel->details('torque');
            $status_arr = $this->Historicals_newModel->status_code_change();

            //檢查  $data['info_final'] 的 cc_program_id 是否一致
            if(!empty($data['info_final'])){
                $ans = 'N'; 
                //以第一個 cc_program_id 為基準
                $first_ccprogramid = $data['info_final'][0]['cc_program_id'] ?? null;

                //假設所有cc_program_id都一樣
                $allsame = true;
                foreach($data['info_final'] as $kke =>$vve){
                    if ($vve['cc_program_id'] !== $first_ccprogramid) {
                        $allsame = false;
                        break; // 如果不相同，就退出
                    }
                }
                if ($allsame) {
                    $ans = 'Y';
                }
                
                $data['check_limit_val'] = $ans;
            }

            $data['status_arr'] = $status_arr;
            $data['torque_mode_arr'] = $torque_mode_arr;
            $data['nav'] = $this->NavsController->get_nav();
            $data['nopage'] = 0;
            $data['path'] = __FUNCTION__;
            $data['final_label'] = $final_label;
            $data['id_count'] = count($info_final) - 1;
            $data['torque_arr'] = $torque_arr;

            $threshold_torque = '';
            $downshift_torque = '';


            $last_keys_1_temp = array(); 
            $last_keys_2_temp = array(); 
            
            foreach ($info_final as $item) {
                if (isset($item['threshold_torque'])) {
                    $threshold_torque .= $item['threshold_torque'] . ',';
                }
                if (isset($item['downshift_torque'])) {
                    $downshift_torque .= $item['downshift_torque'] . ',';
                }
            
                if (!empty($item['system_sn'])) {
                    $threshold_torque_temp  = floatval($item['threshold_torque']);
                    $downshift_torque_temp  = floatval($item['downshift_torque']);
            
                    if (!empty($threshold_torque_temp) && $threshold_torque_temp > 0.1) {
                        $y_val_angle = $this->Historicals_newModel->get_column_values_by_index($item['system_sn'], 3); // angle
                        $y_val_speed = $this->Historicals_newModel->get_column_values_by_index($item['system_sn'], 4); // speed
            
                        $last_key_1 = $this->getLastZeroKey($y_val_angle);
                        $last_key_2 = $this->find_last_key($y_val_angle, $y_val_speed);
        
                        $last_keys_1_temp[] = $last_key_1;
                        $last_keys_2_temp[] = $last_key_2;
            
    
                    }
                }
            }
            
            $threshold_torque = rtrim($threshold_torque, ',');
            $data['threshold_torque'] = $threshold_torque;

            $downshift_torque = rtrim($downshift_torque, ',');
            $data['downshift_torque'] = $downshift_torque;


            if(!empty($last_keys_1_temp)){
                $data['last_key_threshold_torque'] = $last_keys_1_temp;
  
            }


            //echo  "<pre>";
            //print_r($data);
            //echo  "</pre>";
            // die();

            $this->view('historicals/index', $data);
        
        }
    }
    
    
    function prepareChartData($final_label_data, $TransType, $unit) {
        if (!empty($TransType)) {
            return $this->Historicals_newModel->unitarr_change($final_label_data, 1, $unit);
        } else {
            return $final_label_data;
        }
    }

    private function processNgReasonData($ng_reason_temp, $status_arr) {
        $ng_reason = [];
        foreach ($ng_reason_temp as $item) {
            $error_msg_name = $status_arr['error_msg'][$item['error_message']];
            $ng_reason[] = ['value' => $item['total'], 'name' => $error_msg_name];
        }
        return $ng_reason;
    }


    #search 資料處理
    private function getMonitorsInfo($nopage, $offset, $limit){
        
        if($nopage == '0'){
            $offset = 0;
            $limit = 100000000;
        }

        return $this->Historicals_newModel->monitors_info("", $offset, $limit);
    }

    #nextinfo 整理曲線圖
    private function ChartData($chat_mode, $csvdata_arr, $unitvalue, $chat_mode_arr,$temp_x_val,$no,$step_prr_rpm,$step_prr_angle){

        //

        $temp_info = $this->Historicals_newModel->get_info_data_by_sid($no);
        $threshold_torque_temp  = floatval($temp_info[0]['threshold_torque']);
        $downshift_torque_temp  = floatval($temp_info[0]['downshift_torque']);
        $threshold_angle_temp   = intval($temp_info[0]['step_threshold_angle']);
        
        $data = array();
        
        if($chat_mode == "5"){
    
            if(!empty($csvdata_arr['angle'])){

                //$data['x_val'] = json_encode($this->filterArray($csvdata_arr['angle'], "0", 'string'));
                //$data['y_val'] = json_encode($this->filterArray($csvdata_arr['torque'], '0.0', 'float'));

                $y_val_angle = $this->Historicals_newModel->get_column_values_by_index($no, 3); //angle
                $y_val_speed = $this->Historicals_newModel->get_column_values_by_index($no, 4); //speed

                $last_key_1 = $this->getLastZeroKey($y_val_angle);
                $last_key_2 = $this->find_last_key($y_val_angle, $y_val_speed);

                if(!empty($last_key_1)){
                    $data['last_key_1'] = $last_key_1; 
                }else{
                    $data['last_key_1'] = '';
                }

                if(!empty($last_key_2)){
                    $data['last_key_2'] = $last_key_2; 
                }else{
                    $data['last_key_2'] = '';
                }
                

                //
                $data['x_val'] = json_encode($csvdata_arr['angle']);
                $data['y_val'] = json_encode($csvdata_arr['torque']);

                $data['max'] = max($csvdata_arr['torque']);
                $data['min'] = min($csvdata_arr['torque']);
            }

        }else if($chat_mode == "6"){
     
            $csvdata_arr['torque'] = array_map(function($value) {
                return ($value == 0.0) ? 0 : $value;  
            }, $csvdata_arr['torque']);

            $temp = $this->Historicals_newModel->get_column_values_by_index($no, 1);
            $temp = array_map(function($value) {
                //如果匹配到類似 "1.0" 或 "2.0" 等格式，替換成整数
                if (preg_match('/^(\d+)\.0$/', (string)$value, $matches)) {
                    return (int)$matches[1]; 
                }
                return $value;  
            }, $temp);

            $data['x_val'] = json_encode($temp);
            $data['y_val'] = json_encode($csvdata_arr['torque']);
            $data['y_val_1'] = json_encode($csvdata_arr['angle']);
            $data['max'] = max($csvdata_arr['torque']);
            $data['min'] = min($csvdata_arr['torque']);
            $data['max1'] = max($csvdata_arr['angle']);
            $data['min1'] = min($csvdata_arr['angle']);

            $y_val_angle = $this->Historicals_newModel->get_column_values_by_index($no, 3); //angle
            $y_val_speed = $this->Historicals_newModel->get_column_values_by_index($no, 4); //speed
            $last_key = $this->find_last_key($y_val_angle, $y_val_speed);
            if ($last_key !== null) {
                $data['x_val']   = json_encode(array_slice($temp_x_val, $last_key));
                $data['y_val']   = json_encode(array_slice($csvdata_arr['torque'], $last_key));
                $data['y_val_1'] = json_encode(array_slice($csvdata_arr['angle'], $last_key));
            }

        }else{

            if (($chat_mode == "1" || $chat_mode == "3" || $chat_mode == "4") && $unitvalue != "1") {
                $TransType = $unitvalue;
                $torValues = $csvdata_arr;
                $temp_val = $this->Historicals_newModel->unitarr_change($torValues, 1, $TransType);

                
                $data['y_val'] = json_encode($temp_val);
                $data['max'] = max($temp_val);
                $data['min'] = min($temp_val);


            }else{  
              

                $data['y_val'] = $this->Historicals_newModel->get_column_values_by_index($no, 3);
                $data['max'] = max($csvdata_arr);
                $data['min'] = min($csvdata_arr);
            }



           

            //$data['y_val'] = json_encode($temp_val);

            //var_dump($data['y_val']);die();
            $y_val_angle = $this->Historicals_newModel->get_column_values_by_index($no, 3); //angle
            $y_val_speed = $this->Historicals_newModel->get_column_values_by_index($no, 4); //speed


            $temp_x_val = array_map(function($value) {
                //如果匹配到類似 "1.0" 或 "2.0" 等格式，替換成整數
                if (preg_match('/^(\d+)\.0$/', (string)$value, $matches)) {
                    return (int)$matches[1]; 
                }
                return $value;  
            }, $temp_x_val);


            $data['x_val'] = json_encode($temp_x_val);
            
            if (!empty($step_prr_rpm) && !empty($step_prr_angle) && $step_prr_rpm > 0 && $step_prr_angle > 0 && $chat_mode != "2")  {
                $last_key = $this->find_last_key($y_val_angle, $y_val_speed);
                if ($last_key !== null) {
                    
                    $data['y_val'] = json_encode(array_slice($csvdata_arr, $last_key));
                    
                    if($chat_mode != "3" && $chat_mode != "4"){
                        $data['x_val'] = json_encode(array_slice($temp_x_val, $last_key));
                    }
                   
                } 

            }else if (!empty($step_prr_rpm) && !empty($step_prr_angle) && $step_prr_rpm > 0 && $step_prr_angle > 0 && $chat_mode == "2") {

                $last_key = $this->find_last_key($y_val_angle, $y_val_speed);
                if ($last_key !== null) {
                    $data['x_val'] = json_encode(array_slice($temp_x_val, $last_key));
                }
                $data['y_val'] = json_encode(array_slice($data['y_val'], $last_key));
              
            }else if(empty($step_prr_rpm) && empty($step_prr_angle) && $chat_mode =="1"){
                $y_val_torque = $this->Historicals_newModel->get_column_values_by_index($no, 2); //torque
                $data['y_val'] = json_encode($y_val_torque);

            }else if(empty($step_prr_rpm) && empty($step_prr_angle) && $chat_mode =="3"){
                $y_val_rpm = $this->Historicals_newModel->get_column_values_by_index($no, 4); //rpm
                $data['y_val'] = json_encode($y_val_rpm);

            }else if(empty($step_prr_rpm) && empty($step_prr_angle) && $chat_mode =="4"){
                $y_val_power = $this->Historicals_newModel->get_column_values_by_index($no, 5); //power
                $data['y_val'] = json_encode($y_val_power);

            }
            
        } 



        if ($chat_mode == "3" || $chat_mode == "4") {
            $y_val_torque = $this->Historicals_newModel->get_column_values_by_index($no, 2); 
            $data['y_val_torque'] = json_encode($y_val_torque);
        } elseif ($chat_mode == "2" || $chat_mode == "5") {
            $y_val_torque = [];
            $data['y_val_torque'] = json_encode($y_val_torque);
        }
        
        if (is_array($data['y_val'])) {
            $data['y_val'] = json_encode($data['y_val']);
        }

        if(!empty($data['y_val_1'])){
            if (is_array($data['y_val_1'])) {
                $data['y_val_1'] = json_encode($data['y_val_1']);
            }
        }
        
        //這是要取得 threshold_torque
        if($threshold_torque_temp > 0.1 ){
            if(!empty($y_val_angle)){
                #用 $y_val_angle 取得 value = 0 的 最後一筆的key值
                $last_key = $this->getLastZeroKey($y_val_angle);
                $y_val_torque = $this->Historicals_newModel->get_column_values_by_index($no, 2); //torque
                $data['control_torque'] = $y_val_torque[$last_key];
                $data['last_key'] = $last_key;
            }else{
                $data['control_torque'] = '';
                $data['last_key'] = '';
            }
        }else{
            $data['control_torque'] = '';
            $data['last_key'] = '';
        }


        if ($downshift_torque_temp > 0.1) {
            // 取得與 torque 相關的數據
            $y_val_torque = $this->Historicals_newModel->get_column_values_by_index($no, 2);
        
            // 計算範圍
            $min_value = round($downshift_torque_temp, 3);  // 取小數點後3位
            $max_value = $min_value + 0.099;
        
            // 使用 array_filter() 來獲取符合條件的項目
            $matching_keys = array_filter(array_keys($y_val_torque), function($key) use ($y_val_torque, $min_value, $max_value) {
                return $y_val_torque[$key] >= $min_value && $y_val_torque[$key] <= $max_value;
            });
        
            // 檢查是否有匹配的項目，並設置最後的鍵值
            if (!empty($matching_keys)) {
                $data['last_key_downshift_torque'] = reset($matching_keys);  // 使用匹配的第一個鍵
            } else {
                $data['last_key_downshift_torque'] = '';  // 沒有匹配項目則設為空
            }
        } else {
            $data['last_key_downshift_torque'] = '';  // 當 downshift_torque_temp <= 0.1 時，設為空
        }
        

        $data['y_val'] = json_encode(array_values(array_diff_key(json_decode($data['y_val'], true) ?: [], [0 => null])));
        $data['chat_title'] = $chat_mode_arr[(int)$chat_mode] ?? '';


        return $data;
    }

    private function find_last_key($y_val_angle, $y_val_speed) {
        $last_key = null;

        // 假設 y_val_angle 和 y_val_speed 的長度是相同的
        for ($key = 0; $key < count($y_val_angle); $key++) {
            // 檢查對應位置的數值是否都為 0
            if ($y_val_angle[$key] == 0 && $y_val_speed[$key] == 0) {
                $last_key = $key; // 更新最後符合條件的 key
            }
        }

        return $last_key;
    }


    
    private function getLastZeroKey($array) {
        $last_key = -1;
        foreach (array_reverse($array, true) as $key => $value) {
            if ($value == 0) {
                $last_key = $key;
                break;
            }
        }
        return $last_key;
    }


    private function filterArray($array, $valueToMatch, $valueType = 'float') {
        $filteredArray = [];
        $found = false;

        foreach ($array as $value) {
            if (($valueType == 'float' && $value == $valueToMatch) || ($valueType == 'string' && $value == $valueToMatch)) {
                if (!$found) {
                    $filteredArray[] = $value;  
                    $found = true;
                }
            } elseif ($value !== $valueToMatch) {
                $filteredArray[] = $value;  
            }
        }
        return $filteredArray;
    }

}