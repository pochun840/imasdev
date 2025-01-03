<?php

class Historical{
    private $db;//condb control box
    private $db_dev;//devdb tool
    private $db_data;//devdb tool
    private $dbh;

    #在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();

    }

    public function get_system_sn($system_sn){

        if($system_sn != 'total'){
            $system_sn_array = explode(", ", $system_sn);
            $system_sn_array = array_map('intval', $system_sn_array);
            $sql = "SELECT * FROM `fasten_data` WHERE on_flag ='0' AND id IN (" . implode(",", $system_sn_array) . ") ORDER BY data_time DESC";
        }
       
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);
        return $rows;
  
    }

    public function get_temp_id($system_sn){
        $system_sn_array = explode(",", $system_sn);
        $system_sn_array = array_map('intval', $system_sn_array);
        $sql = "SELECT system_sn FROM `fasten_data` WHERE on_flag ='0'  AND id IN (" . implode(",", $system_sn_array) . ") ORDER BY data_time DESC ";
        //echo $sql;die();
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);
        return $rows;
    }


    #取得CSV
    public function csv_info($system_sn){

        if($system_sn != 'total'){
            $system_sn_array = explode(",", $system_sn);
            $system_sn_array = array_map('intval', $system_sn_array);
            $sql = "SELECT * FROM `fasten_data` WHERE on_flag ='0'  AND id IN (" . implode(",", $system_sn_array) . ") ORDER BY data_time DESC";

        }else{
            $sql = "SELECT * FROM `fasten_data` WHERE on_flag ='0'  ORDER BY data_time desc";
        }

        //echo $sql;die();

       
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);
        return $rows;
  
    }

    #取得鎖附的資料
    public function monitors_info($info_arr,$offset=0, $limit){

        $params = array();
        $sql = "SELECT * FROM `fasten_data` WHERE    on_flag ='0' ";
        #barcodesn 
        if (!empty($info_arr['barcodesn'])) {
            $sql .= " AND cc_barcodesn  LIKE :barcodesn  " ;
            $params['barcodesn'] = '%' .$info_arr['barcodesn']. '%';
        }

        #日期
        if(!empty($info_arr['fromdate']) && !empty($info_arr['todate'])){
            $info_arr['fromdate'] = str_replace("-","",$info_arr['fromdate'])." 00:00:00";
            $info_arr['todate']   = str_replace("-","",$info_arr['todate'])." 23:59:59";

            $sql .= " AND data_time BETWEEN :fromdate AND :todate "; 
            $params['fromdate'] = $info_arr['fromdate'];
            $params['todate'] = $info_arr['todate'];
        }

        #鎖附狀態(ALL & OK & OKALL & NG)
        if(!empty($info_arr['status_val'])){

            if($info_arr['status_val'] == "0"){//ALL 

                $sql .="AND fasten_status !='' ";

            }else if($info_arr['status_val'] =="1"){
                $sql .="AND fasten_status  in('4')";
            }else if($info_arr['status_val'] =="2"){
               // $sql .="AND fasten_status = '4' ";

                $sql .="AND fasten_status in('5','6') ";
                // $sql .=" AND fasten_status = '5' or fasten_status = '6' ";
            }else{
                $sql .=" AND fasten_status  in('7','8') ";

            }
        }

        #控制器搜尋
        if(!empty($info_arr['controller_val'])  && $info_arr['controller_val'] != "0" ){
            $info_arr['controller_val'] = (int)$info_arr['controller_val'];
            $sql .="AND  cc_equipment = :cc_equipment";
            $params['cc_equipment'] = $info_arr['controller_val'];
    
        }
        
        #program 搜尋
        if(!empty($info_arr['program_val']) && $info_arr['program_val'] != "0" && $info_arr['program_val'] != "-1"){
           
            $info_arr['program_val'] = (int)$info_arr['program_val'];
            $sql .="AND cc_program_id = :cc_program_id";
            $params['cc_program_id'] = $info_arr['program_val'];
        } 


        #search_name(模糊搜尋)
        if (!empty($info_arr['sname'])) {
            $sql .= " AND (job_name LIKE :sname OR sequence_name LIKE :sname OR cc_task_name LIKE :sname OR cc_barcodesn LIKE :sname)";
            $params[':sname'] = '%' . $info_arr['sname'] . '%';
        }
      

        #job_id && seq_id && task_id 
        if(!empty($info_arr['checkedjobidarr'][0]) && empty($info_arr['checkedseqidarr'][0]) && empty($info_arr['checkedtaskidarr'][0])) {
     
            $sql .= " AND cc_job_id = :job_id AND job_name = :job_name ";
            $params[':job_id'] = $info_arr['checkedjobidarr'][0];
            $params[':job_name'] = $info_arr['job_name'];
        }

       
        if(!empty($info_arr['checkedjobidarr'][0]) && !empty($info_arr['checkedseqidarr'][0]) && empty($info_arr['checkedtaskidarr'][0])) {

            $sql .= " AND cc_job_id = :job_id AND cc_seq_id = :sequence_id AND job_name = :job_name AND sequence_name =:sequence_name";
            $params[':job_id'] = $info_arr['checkedjobidarr'][0];
            $params[':sequence_id'] = $info_arr['checkedseqidarr'][0];
            $params[':job_name'] = $info_arr['job_name'][0];
            $params[':sequence_name'] = $info_arr['seq_name'][0];
        }
        

        if(!empty($info_arr['checkedjobidarr'][0]) && !empty($info_arr['checkedseqidarr'][0]) && !empty($info_arr['checkedtaskidarr'][0])) {
            $sql .= " AND cc_job_id = :job_id AND cc_seq_id = :sequence_id AND cc_task_id =:cc_task_id";
            $params[':job_id'] = $info_arr['checkedjobidarr'][0];
            $params[':sequence_id'] = $info_arr['checkedseqidarr'][0];
            $params[':cc_task_id'] = $info_arr['checkedtaskidarr'][0];
        
        }


        $sql .= " ORDER BY data_time DESC LIMIT :offset, :limit";
        
        $params[':offset'] = $offset;
        $params[':limit'] = $limit;
       
        $statement = $this->db->prepare($sql);
        $statement->execute($params);

        $rows = $statement->fetchall(PDO::FETCH_ASSOC);

        return $rows;

    }


    #刪除鎖附資料 20240401 修改成 update on_flag的資料(0:顯示 1:隱藏)
    public function del_info($del_info_sn) {
        // SQL 更新語句，將 on_flag 設為 '1'
        $sql = "UPDATE fasten_data SET on_flag = '1' WHERE id = ?"; 
        $statement = $this->db->prepare($sql);
        $this->db->beginTransaction();
        
        try {
            foreach ($del_info_sn as $vv) {
                // 執行每一筆更新操作
                $result = $statement->execute([$vv]);
    
                // 如果執行失敗，標記為失敗並立即退出循環
                if (!$result) {
                    $this->db->rollBack();
                    return 'fail'; 
                }
            }
    
            // 所有操作成功，提交事務
            $this->db->commit();

            return 'success'; 
        } catch (Exception $e) {
            $this->db->rollBack();
            return 'fail'; 
        }
    }
    
    
    public function getTotalItemCount() {

        $sql = "SELECT COUNT(*) as total_count FROM fasten_data where  on_flag = 0 order by data_time desc  ";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetchall(PDO::FETCH_ASSOC);

        $total_count = $result[0]['total_count'];

        return $total_count;
    }

    
    #status 轉換
    public function status_code_change(){

        //multi language
        $data['language'] = $_SESSION['language'];
        //權限
        // 如果檔案存在就引入它
        if(file_exists('../app/language/' . $data['language'] . '.php')){
            require '../app/language/' . $data['language'] . '.php';
        } else { //預設採用簡體中文
            require '../app/language/zh-cn.php';
        }

        $status_arr = array(
            0 => 'INIT', 
            1 => 'READY',
            2 => 'RUNNING',
            3 => 'REVERSE',
            4 => 'OK',
            5 => 'OK-SEQ',
            6 => 'OK-JOB',
            7 => 'NG',
            8 => 'NS',
            9 => 'SETTING',
            10 => 'EOC',
            11 => 'C1',
            12 => 'C1_ERR',
            13 => 'C2',
            14 => 'C2_ERR',
            15 => 'C4',
            16 => 'C4_ERR',
            17 => 'C5',
            18 => 'C5_ERR',
            19 => 'BS'
        );

        $status_arr_color = array(
            0 => '',
            1 => '',
            2 => '',
            3 => '#007AB8;',
            4 => '#99CC66;',
            5 => '#FFCC00;',//'#FFCC00;'
            6 => '#FFCC00;',//'#FFCC00;'
            7 => 'red;',
            8 => 'red;',
            9 => '',
            10 => '',
            11 => '',
            12 => '',
            13 => '',
            14 => '',
            15 => '',
            16 => '',
            17 => '',
            18 => '',
            19 => ''
        );

        $error_msg = array(
            0 => '',
            1 => $error_message['ERR_CONT_TEMP'],
            2 => $error_message['ERR_MOT_TEMP'],
            3 => $error_message['ERR_MOT_CURR'],
            4 => $error_message['ERR_MOT_PEAK_CURR'],
            5 => $error_message['ERR_HIGH_TORQUE'],
            6 => $error_message['ERR_DEADLOCK'],
            7 => $error_message['ERR_PROC_MINTIME'],
            8 => $error_message['ERR_PROC_MAXTIME'],
            9 => $error_message['ERR_ENCODER'],
            10 =>$error_message['ERR_HALL'],
            11 =>$error_message['ERR_BUSVOLT_HIGH'],
            12 =>$error_message['ERR_BUSVOLT_LOW'],
            13 =>$error_message['ERR_PROC_NA'],
            14 =>$error_message['ERR_STEP_NA'],
            15 =>$error_message['ERR_DMS_COMM'],
            16 =>$error_message['ERR_FLASH'],
            17 =>$error_message['ERR_FRAM'],
            18 =>$error_message['ERR_HIGH_ANGLE'],
            19 =>$error_message['ERR_PROTECT_CIRCUIT'],
            20 =>$error_message['ERR_SWITCH_CONFIG'],
            21 =>$error_message['ERR_STEP_NOT_REC'],
            22 =>$error_message['ERR_TMD_FRAM'],
            23 =>$error_message['ERR_LOW_TORQUE'],
            24 =>$error_message['ERR_LOW_ANGLE'],
            25 =>$error_message['ERR_PROC_NOT_FINISH'],
            26 =>'',
            27 =>'',
            28 =>'',
            29 =>'',
            30 =>'',
            31 =>$error_message['ERR_LOW_ANGLE'],
            32 =>$error_message['ERR_PROC_NOT_FINISH'],
            33 =>$error_message['SEQ_COMPLETED'],
            34 => $error_message['JOB_COMPLETED']
        );

   
        $direction_arr = array(
            0 => "CW",
            1 => "CCW"
        );
          
        $status_final = array();
        $status_final['status_type'] = $status_arr;
        $status_final['status_color'] = $status_arr_color;
        $status_final['error_msg'] = $error_msg;
        $status_final['direction'] = $direction_arr;
        
        return $status_final;

    }

    public function get_info_data($index){
        
        $sql = "SELECT * FROM `fasten_data` WHERE system_sn = ?  ";
        $statement = $this->db->prepare($sql);
        $statement->execute([$index]);
        $res = $statement->fetchAll(PDO::FETCH_ASSOC);

        return  $res;
    }

    public function get_info_data_by_id($index){

        $sql = "SELECT * FROM `fasten_data` WHERE   id = ? ";
        $statement = $this->db->prepare($sql);
        $statement->execute([$index]);
        $res = $statement->fetchAll(PDO::FETCH_ASSOC);

        return  $res;
    }

    
    public function get_info_data_by_sid($index){

        $sql = "SELECT * FROM `fasten_data` WHERE   id = ? ";
        $statement = $this->db->prepare($sql);
        $statement->execute([$index]);
        $res = $statement->fetchAll(PDO::FETCH_ASSOC);

        return  $res;
    }


    public function get_job_id(){
        
        $sql = "SELECT * FROM `job` WHERE job_id != '' ";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }
    
    public function details($mode){

        if($mode =="chart_type"){

            $details = array(
                1=>'Torque/Time(MS)',
                2=>'Angle/Time(MS)',
                3=>'RPM/Time(MS)',
                4=>'Power/Time(MS)',
                5=>'Torque/Angle',
                6=>'Torque&Angle/Time(MS)',
            );
        }

        if($mode =="torque"){
            $details  = array(
                1 => 'N.m',
                //0 => 'Kgf.m',
                //2 => 'Kgf.cm',
                //3 => 'In.lbs',
                //4 => 'cN.m'
            );
        }


        if($mode =="angle"){
            $angle_mode_arr = array(
                1 =>'total angle',
                2 =>'task angle'
            );

        }

        if($mode =="program"){

            //normal
            $sql = "SELECT template_program_id FROM `gtcs_normalstep_template` ORDER BY template_program_id ";
            $statement = $this->db->prepare($sql);
            $statement->execute();
            $result = $statement->fetchall(PDO::FETCH_ASSOC);
        
            
            //advancedstep
            $sql1 = "SELECT template_program_id FROM `gtcs_advancedstep_template` 
                GROUP BY template_program_id  
                ORDER BY template_program_id,MAX(template_step_id ) DESC ";
            $statement1 = $this->db->prepare($sql1);
            $statement1->execute();
            $result1 = $statement1->fetchall(PDO::FETCH_ASSOC);

         

            
            $details = array_merge($result, $result1);
           

    
        }
        return $details;

    }

    #用job_id 找出對應的sequence_id
    public function get_seq_id($job_id){

        $sql = "SELECT * FROM `sequence` WHERE sequence_enable = '1' AND job_id = :job_id ";
        $params[':job_id'] = $job_id;
        $statement = $this->db->prepare($sql);
        $statement->execute($params);
        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }

    #用job_id及sequence_id 找出對應的task_id
    public function get_task_id($job_id, $seq_id) {

        $sql = "SELECT * FROM `task` WHERE job_id = :job_id AND seq_id = :seq_id ";
        $params[':job_id'] = $job_id;
        $params[':seq_id'] = $seq_id;
        $statement = $this->db->prepare($sql);
        $statement->execute($params);

        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }


    
    public function chat_change($chat_mode)
    {
        $chat_arr = array();
        switch ($chat_mode){
            case "1":
                $chat_name = "Torque/Time(MS)";
                $position = 1;
                $yaxis_title = "Torque";
                $xaxis_title = "Time(MS)";
                break;
            case "2":
                $chat_name = "Angle/Time(MS)";
                $position = 2;
                $yaxis_title = "Angle";
                $xaxis_title = "Time(MS)";
                break;
            case "3":
                $chat_name = "RPM/Time(MS)";
                $position = 3;
                $yaxis_title = "RPM";
                $xaxis_title = "Time(MS)";
                break;
            case "4":
                $chat_name = "Power/Time(MS)";
                $position = 4;
                $yaxis_title = "Power";
                $xaxis_title = "Time(MS)";
                break;
            case "5":
                $chat_name = "Torque/Angle";
                $position = '5';
                $yaxis_title = "Torque";
                $xaxis_title = "Angle";
                break;
            default:
                $chat_name = "Torque&Angle/Time(MS)";
                $position = '6';
                $yaxis_title = "Torque/Angle";
                $xaxis_title = "Time(MS)";
                break;
        }

        if (!empty($chat_name)) {
            $chat_arr['chat_name'] = $chat_name;
            $chat_arr['position']  = $position;
            $chat_arr['yaxis_title']  = $yaxis_title;
            $chat_arr['xaxis_title'] = $xaxis_title;
        }

        return $chat_arr;
    }


    public function get_result($cleaned_str, $chat_mode) {
        $file_arr = array('_0p5', '_1p0', '_2p0');
        $no_arr = explode(',', $cleaned_str);
        $csv_array = array();
        $found_count = 0; 
        $missing_files = []; 
    
        foreach ($no_arr as $key => $val) {
            if (!empty(trim($val))) {
                $file_found = false; 
                foreach ($file_arr as $file_suffix) {
                    $infile = '../public/data/DATALOG_' . str_pad(trim($val), 10, "0", STR_PAD_LEFT) . $file_suffix . ".csv";
                   // echo "Checking file: $infile\n";
    
                    if (file_exists($infile)) {
                        $csvdata = file_get_contents($infile);
                        if (!empty($csvdata)) {
                            $rows = explode("\n", $csvdata);
                            $csv_array['data' . $key] = array_map('str_getcsv', $rows);
                            $found_count++; 
                            $file_found = true; 
                            break; 
                        } else {
                            //echo "File is empty: $infile\n";
                        }
                    } else {
                        //echo "File does not exist: $infile\n";
                    }
                }
                if (!$file_found) {
                    $missing_files[] = trim($val); 
                }
            }
        }
    
        if ($found_count < count($no_arr)) {
            $missing_ids = implode(', ', $missing_files);
            //echo "Missing files for IDs: $missing_ids\n";
        }
    
        if (empty($csv_array)) {
            return null;
        }
    
        if (!empty($chat_mode)) {
            $position = (int)$chat_mode;
        } else {
            $position = null;
        }
    
        foreach ($csv_array as &$innerarray) {
            foreach ($innerarray as $key1 => $va) {
                if (!isset($va[1]) || empty($va[1])) {
                    if (empty($va[2])) {
                        unset($innerarray[$key1]);
                    }
                } elseif ($position === 5 || $position === 6) {
                    $innerarray['torque'][$key1] = $va[1];
                    $innerarray['angle'][$key1] = $va[2];
                } else {
                    $innerarray[$key1] = $va[$position] ?? null;
                }
            }
        }
    
        return $csv_array;
    }
    


    public function get_column_values_by_index($no, $column_index) {
        $file_arr = array('_0p5', '_1p0', '_2p0');
        $no_arr = explode(',', $no);
        $values_array = array(); 
    
        foreach ($no_arr as $key => $val) {
            if (!empty($val)) {
                $file_found = false; 
                foreach ($file_arr as $file_suffix) {
                    $infile = '../public/data/DATALOG_' . str_pad($val, 10, "0", STR_PAD_LEFT) . $file_suffix . ".csv";
                    if (file_exists($infile)) {
                        $csvdata = file_get_contents($infile);
                        $rows = explode("\n", $csvdata);
                        foreach ($rows as $row) {
                            $columns = str_getcsv($row); 
                            if (!empty($columns) && isset($columns[$column_index - 1])) {
                                $values_array[] = $columns[$column_index - 1];
                            }
                        }
                        
                        $file_found = true; 
                        break; 
                    }
                }
            }
        }
    

        if (empty($values_array)) {
            echo "<script>alert('没有找到相關資料');</script>";
            return [];
        }

        if (isset($values_array[0]) && preg_match('/^[a-zA-Z]+$/', $values_array[0])) {
            array_shift($values_array); 
        }
    
    
        return $values_array;
    }
    

    public function get_info($no, $chat_mode){
        $resultarr = array();
    
        if(!empty($no)){
            #檔案類型
            $file_arr  = array('_0p5','_1p0','_2p0');
            $csv_array = array();
            $resultarr = array();
            foreach ($file_arr as $v_f) {
                $infile = '../public/data/DATALOG_'.str_pad($no,10,"0",STR_PAD_LEFT).$v_f.".csv";
                if (file_exists($infile)) {
                    $csvdata_tmp = file_get_contents($infile);
                    if (!empty($csvdata_tmp)) {
                        $csvdata = $csvdata_tmp;
                        $lines = explode("\n", $csvdata); 
                        $csv_array = array_map('str_getcsv', $lines); 
                        break; 
                    }
                }
            }
    
            if(empty($csv_array)){
                $resultarr = null;
            } else {
                $position = (int)$chat_mode;
    
                foreach ($csv_array as $key => $subarray) {
                    if (0 === ($key)) { // skip members with even key
                        continue;
                    }
                    if(isset($subarray[1])){
                        if($chat_mode =="5" || $chat_mode =="6"){
                            if($position === 5 || $position === 6) {
                                $resultarr['torque'][] = $subarray[1];
                                $resultarr['angle'][] = $subarray[2];
                            } else {
                                $resultarr['torque'][] = $subarray[$position];
                            }
                        } else {
                            $resultarr[] = $subarray[$position];
                        }
                    }
                }
            }
        }
        return $resultarr;
    }
    
    public function for_history_temp($mode,$info){

        switch ($mode) {
            case "ng_reason":
                if(!empty($info)){
                    $ng_reason_arr = [];  
                    $ng_count = 0;  
                    
                    // 遍历 $info 数组
                    foreach ($info as $key => $val) {
                        if ($val['fasten_status'] == 7 || $val['fasten_status'] == 8) {
                            $ng_count++;
                    
                            $key = $val['error_message'] . '-' . $val['fasten_status'];
                    
                            if (isset($ng_reason_arr[$key])) {
                                $ng_reason_arr[$key]['total']++;
                            } else {
                                // 否则，初始化该组合
                                $ng_reason_arr[$key] = [
                                    'error_message' => $val['error_message'],
                                    'fasten_status' => $val['fasten_status'],
                                    'total' => 1 
                                ];
                            }
                        }
                    }
                    
                }
          

                return $ng_reason_arr;
            break;

            case 'fastening_status':
                $fasten_status_count = []; 
                if(!empty($info)){
                    foreach ($info as $key => $val) {
                        if ($val['on_flag'] == 0 && !empty($val['fasten_status'])) {
                            $status = $val['fasten_status'];
                    
                            if (isset($fasten_status_count[$status])) {
                                $fasten_status_count[$status]['total']++;
                            } else {
                                $fasten_status_count[$status] = [
                                    'fasten_status' => $status,
                                    'total' => 1
                                ];
                            }
                        }
                    }
                }
                return $fasten_status_count;
            break;

            case 'job_info_new':
                $aggregated_data  = array(); 
                foreach ($info as $item) {
                    if ($item['on_flag'] == 0) { 
                        $job_name = $item['job_name'];
                        $fasten_time = $item['fasten_time'];
                
                        if (isset($aggregated_data[$job_name])) {
                            $aggregated_data[$job_name] += $fasten_time;
                        } else {
                            $aggregated_data[$job_name] = $fasten_time;
                        }
                    }
                }
                return $aggregated_data;
            break;

            case 'job_info':
                $job_info = [];
                if (!empty($info)) {
                    foreach ($info as $key => $val) {
                        if ($val['on_flag'] == 0 && isset($val['fasten_time'])) {
                            $job_name = $val['job_name'];
                            
                            if (isset($job_info[$job_name])) {
                                $job_info[$job_name]['total']++;
                            } else {
                                $job_info[$job_name] = [
                                    'job_name' => $job_name,
                                    'total' => 1
                                ];
                            }
                        }
                    }
                }
        
                return $job_info;    
            break;
            
            case 'statistics':
                $statistics_arr = array(); 
                if (!empty($info)) {
                    foreach ($info as $key => $val) {
                        
                        if ($val['on_flag'] == 0 && in_array($val['fasten_status'], [4, 5, 6, 7, 8])) {
                            
                            $date = substr($val['data_time'], 0, 8);
                            $status_category = '';
                            if (in_array($val['fasten_status'], [7, 8])) {
                                $status_category = 'NG';
                            } elseif ($val['fasten_status'] == 4) {
                                $status_category = 'OK';
                            } elseif (in_array($val['fasten_status'], [5, 6])) {
                                $status_category = 'OK_ALL';
                            }
                        
                            if (!isset($statistics_arr[$date])) {
                                $statistics_arr[$date] = [
                                    'NG' => 0,
                                    'OK' => 0,
                                    'OK_ALL' => 0
                                ];
                            }
                            $statistics_arr[$date][$status_category]++;
                        }
                    }
            
                    #按照日期排序 從小排到大
                    ksort($statistics_arr);
                }
              
            return $statistics_arr;    
            break;
            
        }

    }
    public function for_history($mode){
        
        $sql = '';
        $after_date = date('Ymd 23:59:59');
        $before_date = date('Ymd', strtotime('-7 days')) . ' 00:00:00';

        switch ($mode) {

            case "ng_reason":
                $sql = "SELECT error_message,fasten_status,count(fasten_status) AS total FROM `fasten_data` WHERE on_flag = '0' AND fasten_status IN ('7','8') GROUP BY error_message, fasten_status ORDER BY data_time DESC";
            break;

            case "fastening_status":
                $sql = "SELECT fasten_status,count(fasten_status) AS total FROM `fasten_data` WHERE on_flag = '0' AND fasten_status != '' GROUP BY fasten_status ORDER BY data_time DESC";
            break;

            case "job_info":
                $sql = "SELECT fasten_time, job_name FROM `fasten_data` WHERE on_flag = '0' ORDER BY data_time DESC";
            break;

            case "job_info_new": //柱狀圖
                $sql = "SELECT job_name, SUM(fasten_time) AS fasten_time 
                        FROM `fasten_data` 
                        WHERE on_flag = '0' 
                        GROUP BY job_name 
                        ORDER BY data_time DESC";
            break;
            

            case "statistics_ng":
                                $sql = "SELECT 
                    substr(data_time, 1, 8) AS date, 
                    CASE 
                        WHEN fasten_status IN ('7', '8') THEN 'NG'
                        WHEN fasten_status IN ('4') THEN 'OK'
                        WHEN fasten_status IN ('5', '6') THEN 'OK_ALL'
                    END AS status_category,
                    COUNT(*) AS status_count
                FROM 
                    fasten_data 
                WHERE 
                    data_time BETWEEN '".$before_date."' AND '".$after_date."' 
                    AND on_flag = '0' 
                    AND fasten_status IN ('4', '5', '6', '7', '8') 
                GROUP BY 
                    substr(data_time, 1, 10), 
                    status_category";
                //echo $sql;die();
            break;

          

            case "job_time":
                $sql = "SELECT 
                    COUNT(fasten_data.job_name) AS duplicate_count, 
                    fasten_data.job_name, 
                    SUM(fasten_data.fasten_time) AS total_fasten_time, 
                    AVG(fasten_data.fasten_time) AS average_fasten_time 
                FROM fasten_data 
                WHERE fasten_data.on_flag = 0 
                AND fasten_data.step_targettype IN ('1', '2') 
                AND fasten_data.job_name != '' 
                GROUP BY fasten_data.job_name
                HAVING COUNT(fasten_data.job_name) > 1 
                ORDER BY fasten_data.data_time DESC ";
            break;
            default:
                
            break;
        }

        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);

        return $result; 
    }


    //扭力單位的轉換
    public function unitarr_change($torValue, $inputType, $TransType){
        
        #輸入扭力單位
        $inputType = (int)$inputType;
        
        #輸出扭力單位
        $TransType = (int)$TransType;

        $new_TorqueUnit = array(
            "kgf.cm" => 2,
            "N.m"    => 1,
            "lbf.in" => 3,
            "kgf.m"  => 0,
            "cN.m"   => 4
        );

        $convertedValues = array();
        if (!is_array($torValue)) {
            $torValue = [$torValue];
        }
   
        foreach($torValue as $torValue){
            $torValue = floatval($torValue);

            #當輸入的單位是N.m
            if($inputType == $new_TorqueUnit["N.m"]){
          
                if($TransType == $new_TorqueUnit["kgf.m"]){
                    $convertedValues[] = round($torValue * 0.102, 4); // N.m 轉換成 kgf.m
                }elseif($TransType == $new_TorqueUnit["kgf.cm"]){
                    $convertedValues[] = round($torValue * 10.2, 3); // N.m 轉換成 Kgf·cm
                }elseif($TransType == $new_TorqueUnit["lbf.in"]){
                    $convertedValues[] = round($torValue * 10.2 * 0.86805, 2); // N.m 轉換成 lbf.in
                }elseif($TransType == $new_TorqueUnit["N.m"]){
                    $convertedValues[] = round($torValue, 3); // N.m 轉換成 N.m（保持不變）
                }elseif($TransType == $new_TorqueUnit["cN.m"]){
         
                    $convertedValues[] = round(round($torValue * 10.2, 2) * 9.80392156, 1); //N.m 轉換成 cN.m
                }
            } 

            #當輸入的單位是kgf.m
            elseif($inputType == $new_TorqueUnit["kgf.m"]){
       
                if($TransType == $new_TorqueUnit["kgf.m"]){
                    $convertedValues[] = round($torValue, 4); // kgf.m 轉換成 kgf.m（保持不變）
                }elseif($TransType == $new_TorqueUnit["kgf.cm"]){
      
                    $convertedValues[] = round($torValue * 100, 2); // kgf.m 轉換成 Kgf·cm
                }elseif($TransType == $new_TorqueUnit["lbf.in"]){
                    $convertedValues[] = round($torValue * 100 * 0.86805, 2); // kgf.m 轉換成 lbf.in
                }else if($TransType == $new_TorqueUnit["N.m"]){
                    $convertedValues[] = round($torValue * 9.80392156, 3); // kgf.m 轉換成 N·m
                }elseif($TransType == $new_TorqueUnit["cN.m"]){
                    $convertedValues[] = round(round($torValue * 100, 2) * 9.80392156, 1);  // kgf.m 轉換成 cN·m
                }   
            }

            #當輸入的單位是Kgf·cm
            elseif ($inputType == $new_TorqueUnit["kgf.cm"]){
                
                if($TransType == $new_TorqueUnit["kgf.m"]){
                    $convertedValues[] = round($torValue * 0.01, 4); // Kgf·cm 轉換成 kgf.m
                }elseif($TransType == $new_TorqueUnit["kgf.cm"]){
                    $convertedValues[] = round($torValue, 2); // Kgf·cm 轉換成 Kgf·cm（保持不變）
                }elseif($TransType == $new_TorqueUnit["lbf.in"]){
                    $convertedValues[] = round($torValue * 0.86805, 2); // Kgf·cm 轉換成 lbf.in
                }elseif($TransType == $new_TorqueUnit["N.m"]){
                    $convertedValues[] = round($torValue * 0.0980392156, 3); // Kgf·cm 轉換成 N·m
                }elseif($TransType == $new_TorqueUnit["cN.m"]){
                    $convertedValues[]  =  round($torValue * 9.80392156, 1);  // kgf.cm 轉換成 cN·m
                }

            }   

            #當輸入的單位是lbf.in
            elseif ($inputType == $new_TorqueUnit["lbf.in"]){
           
                if($TransType == $new_TorqueUnit["kgf.m"]){
                    $convertedValues[] = round($torValue * 1.152 * 0.01, 4); // lbf.in 轉換成 kgf.m
                }elseif($TransType == $new_TorqueUnit["kgf.cm"]){
                    $convertedValues[] = round($torValue * 1.152, 2); // lbf.in轉換成 Kgf·cm
                }elseif($TransType == $new_TorqueUnit["lbf.in"]){
                    $convertedValues[] = round($torValue, 2); // lbf.in 轉換成 lbf.in（保持不變）
                }elseif($TransType == $new_TorqueUnit["N.m"]){
                    $convertedValues[] = round($torValue * 0.11294117637119998, 3); // lbf.in 轉換成 N·m
                }elseif($TransType == $new_TorqueUnit["cN.m"]){
                    $convertedValues[] = round(round($torValue * 1.152, 2) * 9.80392156, 1); // lbf.in 轉換成 cN·m
                }
            }

            #當輸入的單位是cN·m
            elseif($inputType == $new_TorqueUnit["cN.m"]){
                if($TransType == $new_TorqueUnit["kgf.m"]){
                    $convertedValues[] =  round(round($torValue * 0.102, 2) * 0.01, 4); // cN·m 轉換成 kgf.m
                }elseif($TransType == $new_TorqueUnit["kgf.cm"]){
                    $convertedValues[] =  round( $torValue * 0.102,2); // cN·m 轉換成 kgf.m
                }elseif($TransType == $new_TorqueUnit["lbf.in"]){
                    $convertedValues[] =  round(round($torValue * 0.102, 2) * 0.86805, 2); // cN·m 轉換成 lbf.in
                }else if($TransType == $new_TorqueUnit["N.m"]){
                    $convertedValues[] =  round(round($torValue * 0.102, 2) * 0.0980392156, 3); // cN·m 轉換成 N·m
                }elseif($TransType == $new_TorqueUnit["cN.m"]){
                    $convertedValues[] = round($torValue, 1);  // cN·m 轉換成 cN·m（保持不變）
                }

            }
        }
        return $convertedValues;
    }

    

    #處理chart的X軸&Y軸的座標
    public function extractXYTitles($titleString){
        $titles = explode("/", $titleString);
        return [
            'x_title' => isset($titles[1]) ? $titles[1] : '',
            'y_title' => isset($titles[0]) ? $titles[0] : ''
        ];
    }

    #判斷瀏覽器的種類
    /*public function getBrowserType() {
        
        $userAgent = $_SERVER['HTTP_USER_AGENT'];
        // 判斷瀏覽器
        if (strpos($userAgent, 'Chrome') !== false) {
            return 'Chrome';
        } elseif (strpos($userAgent, 'Firefox') !== false) {
            return 'Firefox';
        } elseif (strpos($userAgent, 'Safari') !== false) {
            return 'Safari';
        } elseif (strpos($userAgent, 'MSIE') !== false || strpos($userAgent, 'Trident') !== false) {
            return 'Internet Explorer';
        } elseif (strpos($userAgent, 'Edge') !== false) {
            return 'Edge';
        } elseif (strpos($userAgent, 'Opera') !== false || strpos($userAgent, 'OPR') !== false) {
            return 'Opera';
        } elseif (strpos($userAgent, 'SamsungBrowser') !== false) {
            return 'Samsung Browser';
        } else {
            return 'Unknown Browser';
        }
    }*/


    #呼叫 get_data_api.php 
    public function get_data($info_arr) {

        #移除值為空的參數
        $filtered_info_arr = array_filter($info_arr, function($value) {
            return is_array($value) ? !empty(array_filter($value)) : !empty($value);
        });

        #移除不使用的參數
        $unused_keys = ['seq_name', 'checkedjobidarr', 'checkedseqidarr', 'checkedtaskidarr'];
        foreach ($unused_keys as $key) {
            unset($filtered_info_arr[$key]);
        }

        #處理查詢參數
        $query_params = http_build_query($filtered_info_arr);
        parse_str($query_params, $params);

        foreach ($params as $key => $value) {
            if (is_array($value)) {
                $params[$key] = implode(',', $value);
            }
        }

        if (!empty($params['system_sn'])) {
            $params['system_sn'] = trim($params['system_sn']);
        }

        foreach (['fromdate', 'todate'] as $date_key) {
            if (!empty($params[$date_key])) {
                $params[$date_key] = str_replace('-', '', substr($params[$date_key], 0, 10));
            }
        }

        $new_query_string = http_build_query($params);

        #處理 URL
        $file_url = preg_replace([
            '/public\/index\.php\?url=Historicals\/(search_info_list|history_result|combinedata)/', 
            '/public\/index\.php\?url=Historicals\/csv_downland/'
        ], '', $_SERVER['REQUEST_URI']);


        $url = "http://" . $_SERVER['HTTP_HOST'] . $file_url . "/api/get_data_api.php?type=json";
        if (!empty($new_query_string)) {
            $url .= "&" . $new_query_string;
        }

        $url = str_replace('%2C+', ',', $url);

        #使用 CURL 發送請求
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
        ]);

        $response = curl_exec($ch);
        $curl_error = curl_error($ch);
        curl_close($ch);

        #檢查 CURL 請求結果
        if ($response === false) {
            throw new Exception("CURL Error: $curl_error");
        }

        if (empty($response)) {
            echo '<script type="text/javascript">alert("NO Data");</script>';
            exit;
        }


        $info_tmp = json_decode($response, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception("JSON Decode Error: " . json_last_error_msg());
        }

        return $info_tmp;
    }

}
