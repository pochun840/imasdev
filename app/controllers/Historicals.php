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

        $torque_arr = $this->Historicals_newModel->details('torque');

        $res_program = $this->Historicals_newModel->details('program');


        #取得該帳號的權限
        $account = $_SESSION['user'];
        $user_permissions =  $this->UserModel->GetUserByName($account);
        

        #取得所有的job_id
        $job_arr = $this->Historicals_newModel->get_job_id();
        $status_arr = $this->Historicals_newModel->status_code_change();

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'all_roles' => $all_roles,
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
            'user_role_title' => $user_permissions['Title']
        ];

        $this->view('historicals/index', $data);
    }

    #隱藏鎖附資料
    public function del_info(){

        $del_info_sn_arr = array();
        $del_info_sn = $_POST['values'];
        $res = $this->Historicals_newModel->del_info($del_info_sn);
        return $res;
    }


    #搜尋資料
    public function search_info_list(){

        $info_arr = array();
        $info_arr = $_POST;


        //die();
    
        $offset = 0;
        $limit  = 10000;
        #按照POST的資訊 取得資料庫搜尋的結果
        $info = $this->Historicals_newModel->monitors_info($info_arr,$offset,$limit);

        #扭力轉換
        $torque_arr = $this->Historicals_newModel->details('torque');

        #STATUS轉換
        $status_arr = $this->Historicals_newModel->status_code_change();


        $res_controller_arr = array(1 => 'GTCS', 2 =>'TCG'); 


        if(!empty($info)){
            $info_data ="";
            foreach($info as $k =>$v){
                $color = $status_arr['status_color'][$v['fasten_status']];
                $style = 'background-color:'.$color.';font-size: 20px';

                $info_data  = "<tr>";
                $info_data .= '<td style="text-align: center;"><input class="form-check-input" type="checkbox" name="test1" id="test1"  value="'.$v['system_sn'].'" style="zoom:1.2;vertical-align: middle;"></td>';
                $info_data .= "<td id='system_sn'>".$v['system_sn']."</td>";
                $info_data .= "<td>".$v['data_time']."</td>";
                $info_data .= "<td></td>";
                $info_data .= "<td>".$v['cc_barcodesn']."</td>";
                $info_data .= "<td>".$v['job_name']."</td>";
                $info_data .= "<td>".$v['sequence_name']."</td>";
                $info_data .= "<td>".$v['cc_task_id']."</td>";
                $info_data .= "<td>".$res_controller_arr[$v['cc_equipment']]."</td>";
                $info_data .= "<td>".$v['step_lowtorque']." ~ ".$v['step_hightorque']."</td>";
                $info_data .= "<td>".$v['step_lowangle']." ~ ".$v['step_highangle']."</td>";
                $info_data .= "<td>".$v['fasten_torque'] .$torque_arr[$v['torque_unit']]."</td>";
                $info_data .= "<td>".$v['fasten_angle']." deg </td>";
                $info_data .= "<td style='".$style."'>". $status_arr['status_type'][$v['fasten_status']]."</td>";
                $info_data .= "<td>".$status_arr['error_msg'][$v['error_message']]."</td>";
                $info_data .= "<td>".$v['cc_program_id']."</td>";
                $info_data .= "<td><a href=\" ?url=Historicals/nextinfo/".$v['system_sn']." \"><img src=\"./img/info-30.png\" style=\"height: 28px; vertical-align: middle;\" ></a></td>";
        
                $info_data .="</tr>";
                echo $info_data;
            }  
        }else{  
            # 查無資料
            $response = '';
            echo $response;
            
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
            $info_final = $this->Historicals_newModel->csv_info($system_sn_in);
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
            fputcsv($file,  array('cc_barcodesn','cc_station','cc_job_id','cc_seq_id','cc_task_id','cc_program_id','cc_equipment','cc_operator','system_sn','data_time','device_type','device_id','device_sn','tool_type','tool_sn','tool_status','job_id','job_name','sequence_id','sequence_name','step_id','fasten_torque','torque_unit','fasten_time','fasten_angle','count_direction','last_screw_count','max_screw_count','fasten_status','error_message','step_targettype','step_tooldirection','step_rpm','step_targettorque','step_hightorque','step_lowtorque','step_targetangle','step_highangle','step_lowangle','step_delayttime','threshold_torque','step_threshold_angle','downshift_torque','downshift_speed','step_prr_rpm','step_prr_angle','barcode','total_angle','on_flag','cc_task_name'));
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
        $mode_arr = array('ng_reason','fastening_status','job_info','statistics','bk');

        #NG REASON 
        foreach($mode_arr as $key =>$val){
            
            if($val =="ng_reason"){
                $ng_reason_temp = $this->Historicals_newModel->for_history($val);
                if(!empty($ng_reason_temp)){
                    $ng_reason = $this->processNgReasonData($ng_reason_temp, $status_arr);
                    $data['ng_reason_json'] = json_encode($ng_reason);
                }
            }

            if($val =="fastening_status"){
                $fastening_status_temp = $this->Historicals_newModel->for_history($val); 
                if(!empty($fastening_status_temp)){
                    foreach($fastening_status_temp as $key2 =>$val2){
                        $fastening_status_temp[$key2]['status_type'] = $status_arr['status_type'][$val2['fasten_status']];
                    }

                    $fastening_status = array();
                    foreach ($fastening_status_temp as $item1) {
                        $fastening_status[] = array('value' => $item1['total'], 'name' => $item1['status_type']);
                    }
                

                    $data['fastening_status'] = json_encode($fastening_status);
                }
                
            }

            if($val=="job_info"){
                $job_info_temp = $this->Historicals_newModel->for_history($val); 
                $val_temp = "job_info_new";
                $job_info_tmp = $this->Historicals_newModel->for_history($val_temp);
              
                if(!empty($job_info_temp)){
                    $job_info = array();
                    $job_info = $job_info_tmp;
                    
                    #柱狀圖
                    $job_names = array();
                    $fasten_time = array();
                    foreach ( $job_info  as $item) {
                        $job_names[] = $item['job_name'];
                        $fasten_time[] = $item['total_fasten_time'];
                    }

              

                    $job_name_json = json_encode($job_names);
                    $fasten_time_json = json_encode($fasten_time);
                    $data['job_info']['job_name'] = $job_name_json;
                    $data['job_info']['fasten_time'] =$fasten_time_json;




                    #圓餅圖
                    $job_time = array();
                    $job_time_temp = $this->Historicals_newModel->for_history('job_time'); 
                    foreach ($job_time_temp as $v_time) {
                        $job_name = $v_time['job_name'];
                    
                        if (isset($job_name_counts[$job_name])) {
                            $job_name_counts[$job_name]['duplicate_count'] += $v_time['duplicate_count'];
                            $job_name_counts[$job_name]['fasten_time'] += $v_time['fasten_time'];
                            $job_name_counts[$job_name]['total_fasten_time'] += $v_time['total_fasten_time'];
                            $job_name_counts[$job_name]['average_fasten_time'] += $v_time['average_fasten_time'];
                        } else {
                            $job_name_counts[$job_name] = $v_time;
                        }
                    }
                    foreach ($job_name_counts as &$item) {
                        $item['average_fasten_time'] = $item['total_fasten_time'] / $item['duplicate_count'];
                    }
                    
                    foreach($job_name_counts as $k_time1 =>$v_time1){
                        $job_time[] = array('value' => $v_time1['duplicate_count'], 'name' => "JOB-".$v_time1['job_name']); 
                    } 
                    $data['job_time_json'] = json_encode($job_time);
                }
            }

            if ($val == "statistics") {
                $start_date = date('Y-m-d', strtotime('-7 days'));
                $end_date = date('Y-m-d');
                $date_format = 'Ymd';

                $all_dates = array();
                $current_date = strtotime($start_date);
                while ($current_date <= strtotime($end_date)) {
                    $all_dates[] = date($date_format, $current_date);
                    $current_date = strtotime("+1 day", $current_date);
                }

            
                // 初始化日期数组
                $date_array = [];
                for ($date = strtotime($start_date); $date <= strtotime($end_date); $date = strtotime('+1 day', $date)) {
                    $formatted_date = date('Ymd', $date);
                    $date_array[$formatted_date] = [
                        'ng_count' => 0,
                        'ok_count' => 0,
                        'ok_all_count' => 0
                    ];
                }

                    
                // NG 数据处理
                $complete_data = array();
                $res = $this->Historicals_newModel->for_history('statistics_ng'); 
                foreach ($res as $record) {
                    $date = $record['date'];
                    $category = $record['status_category'];
                    $count = $record['status_count'];
                    
                    $complete_data[$date][$category] = $count;
                }

                foreach ($complete_data as $date => $categories) {
                    if (isset($date_array[$date])) {
                        // 更新 ng_count
                        if (isset($categories['NG'])) {
                            $date_array[$date]['ng_count'] = $categories['NG'];
                        }
                        
                        // 更新 ok_count
                        if (isset($categories['OK'])) {
                            $date_array[$date]['ok_count'] = $categories['OK'];
                        }
                        
                        // 更新 ok_all_count
                        if (isset($categories['OK_ALL'])) {
                            $date_array[$date]['ok_all_count'] = $categories['OK_ALL'];
                        }
                    }
                }                
                $ng_count_values = array_values(array_map(function($item) {
                    return (int)$item['ng_count'];
                }, $date_array));


                $ng_count_json = json_encode($ng_count_values, JSON_PRETTY_PRINT);

                $ok_count_values = array_values(array_map(function($item) {
                    return (int)$item['ok_count'];
                }, $date_array));
                $ok_count_json = json_encode($ok_count_values, JSON_PRETTY_PRINT);

                $ok_all_count_values = array_values(array_map(function($item) {
                    return (int)$item['ok_all_count'];
                }, $date_array));
                $ok_all_count_json = json_encode($ok_all_count_values , JSON_PRETTY_PRINT);

            
                $data['statistics']['date'] = json_encode(array_keys($date_array));
                $data['statistics']['ng'] = $ng_count_json;
                $data['statistics']['ok'] = $ok_count_json;
                $data['statistics']['ok_all'] = $ok_all_count_json;
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
    
            #取得詳細資料
            $data['job_info'] = $this->Historicals_newModel->get_info_data($index);

            if(empty($data['job_info'])){
                $redirectUrl = '?url=Historicals';
                header('Location: ' . $redirectUrl);
                exit();
            }


    
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
         

            $csvdata_arr = $this->Historicals_newModel->get_info($no, $chat_mode);


            if(!empty($csvdata_arr)){
                $data['chart_info'] = $this->ChartData($chat_mode, $csvdata_arr, $unitvalue, $chat_mode_arr);
                
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
        if (!empty($_COOKIE['checkedsn'])) {
            $checkedsn = $_COOKIE['checkedsn'];
            $checkedsn_array = strpos($checkedsn, ',') !== false ? explode(",", $checkedsn) : [$checkedsn];
            $checked_sn_in = implode("','", $checkedsn_array);

            // 取得所有的資料
            $info_final = $this->Historicals_newModel->csv_info($checked_sn_in);  
            $data['chat_mode_arr_combine'] = $this->Historicals_newModel->details('chart_type');
            $data['info_final'] = $info_final;

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
            $final_label = $this->Historicals_newModel->get_result($checked_sn_in, $id, $data['chat_mode']);
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
                            $xValues = array_column($dataSet, 2); // angle
                            $xCoordinates[$i] = json_encode($xValues); // 將 X 軸數據轉換為 JSON 格式
                            $chartData[$i]['y'] = array_column($dataSet, 1); // 將 value[1] 作為 Y 軸數據
                            
                            // 設置預設的 max 和 min 值
                            $chartData[$i]['max'] = floatval(max($chartData[$i]['y']));
                            $chartData[$i]['min'] = floatval(min($chartData[$i]['y']));
        
                        } else if ($data['chat_mode'] == 6) {
                            $xCoordinates[$i] = json_encode(array_keys($dataSet)); //處理X軸

                           
                        
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
                        } else {
                            $xCoordinates[$i] = json_encode(array_keys($dataSet));
                            $chartData[$i]['y'] = $this->prepareChartData($dataSet, $TransType, $data['unit']);
                            $chartData[$i]['max'] = floatval(max($chartData[$i]['y']));
                            $chartData[$i]['min'] = floatval(min($chartData[$i]['y']));
                        }
                    }
                }

                // 設置圖表數據和座標
                $data['chart_xcoordinates'] = $xCoordinates;
                foreach ($chartData as $key => $chart) {
                    $data["chart{$key}_ycoordinate"] = json_encode($chart['y']);
                    $yValues = json_decode($data["chart{$key}_ycoordinate"], true);
                    $data["chart{$key}_ycoordinate_max"] = max($yValues);
                    $data["chart{$key}_ycoordinate_min"] = min($yValues);
                
                    if (isset($chart['y_angle'])) {
                        $data["chart{$key}_ycoordinate_angle"] = json_encode($chart['y_angle']);
                        
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
    private function ChartData($chat_mode, $csvdata_arr, $unitvalue, $chat_mode_arr){
        $data = array();
        
        if($chat_mode == "5"){
    
            if(!empty($csvdata_arr['angle'])){

                $data['x_val'] = json_encode($csvdata_arr['angle']);
                $data['y_val'] = json_encode($csvdata_arr['torque']);
                $data['max'] = max($csvdata_arr['torque']);
                $data['min'] = min($csvdata_arr['torque']);
            }

        }else if($chat_mode == "6"){
     
      
            $data['x_val'] = json_encode(array_keys($csvdata_arr['torque']));
            $data['y_val'] = json_encode($csvdata_arr['torque']);
            $data['y_val_1'] = json_encode($csvdata_arr['angle']);
            $data['max'] = max($csvdata_arr['torque']);
            $data['min'] = min($csvdata_arr['torque']);
            $data['max1'] = max($csvdata_arr['angle']);
            $data['min1'] = min($csvdata_arr['angle']);

        }else{

            if(($chat_mode == "1" || $chat_mode == "3" || $chat_mode == "4") && $unitvalue != "1"){
            
                $TransType = $unitvalue;
                $torValues = $csvdata_arr;
                $temp_val = $this->Historicals_newModel->unitarr_change($torValues, 1, $TransType);
                $data['y_val'] = json_encode($temp_val);
                $data['max'] = max($temp_val);
                $data['min'] = min($temp_val);

            }else{

                $data['y_val'] = json_encode($csvdata_arr);
                $data['max'] = max($csvdata_arr);
                $data['min'] = min($csvdata_arr);
            }
            $data['x_val'] = json_encode(array_keys($csvdata_arr));
        }
    
        $data['chat_title'] = $chat_mode_arr[(int)$chat_mode] ?? '';
        return $data;
    }


 
    

}