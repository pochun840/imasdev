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

    #取得CSV
    public function csv_info($system_sn){

        if($system_sn != 'total'){
            $sql = "SELECT * FROM `fasten_data` WHERE on_flag ='0' AND system_sn IN('".$system_sn."') order by data_time desc";
        }else{
            $sql = "SELECT * FROM `fasten_data` WHERE on_flag ='0' ORDER BY data_time desc";
        }
       
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


    #刪除鎖附資料
    public function del_info($del_info_sn){
        #20240401 修改成 update on_flag的資料(0:顯示 1:隱藏)
        $sql = "UPDATE fasten_data SET on_flag = '1' WHERE system_sn = ?";
        $statement = $this->db->prepare($sql);
        
        foreach ($del_info_sn as $vv) {
            $statement->execute([$vv]);
        }
        
        return $del_info_sn;
    }

    
    public function getTotalItemCount() {

        $sql = "SELECT COUNT(*) as total_count FROM fasten_data order by data_time desc  ";
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
        
        $sql = "SELECT * FROM `fasten_data` WHERE system_sn = ?";
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
                0 => 'Kgf.m',
                2 => 'Kgf.cm',
                3 => 'In.lbs',
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


    /*public function connected_ftp($no){

        #FTP連線相關資訊
        $ftp_server = "192.168.0.135";
        $ftp_user = "kls";
        $ftp_pass = "12345678rd";
        $ftp_dir = "/mnt/ramdisk/FTP/";

        #FTP曲線圖路徑

        if(!empty($no)){
            $csv_file = "DATALOG_000000".$no."_1p0.csv";
        }else{
            //$csv_file = '';
        }

        #連接到FTP
        $conn_id = ftp_connect($ftp_server);

        #登錄FTP
        $login_result = ftp_login($conn_id, $ftp_user, $ftp_pass);;

        if ($conn_id && $login_result){
            #切換到存放曲線圖路徑
            if (ftp_chdir($conn_id, $ftp_dir)){
                #取得.CSV 文件列表
                $files = ftp_nlist($conn_id, ".");
                if(empty($csv_file)){
                    usort($files, function($a, $b) use ($conn_id) {
                        $mtime_a = ftp_mdtm($conn_id, $a);
                        $mtime_b = ftp_mdtm($conn_id, $b);
                        return $mtime_b - $mtime_a; // 从大到小排序
                    });
        
                }else{
                    #combinedata的頁面過來
                    $files[0] =  $csv_file;
                }
                if($files[0]!= ""){

                    $csv_file = $files[0];
                    $filename =  $ftp_dir.$csv_file;
                    if (in_array($csv_file, $files)){

                        #csv 如果存在 並且轉換成陣列
                        $tempFile = tempnam(sys_get_temp_dir(), 'ftp_');
                        $ftp_get = ftp_get($conn_id, $tempFile, $filename, FTP_BINARY);
                        if ($ftp_get) {
                            $csvdata = array_map('str_getcsv', file($tempFile));
                            unlink($tempFile);
                        }else{
                            #
                        }

                    } else {
                        echo "File".$ftp_file."does not exist";
                    }
                }else{


                }
            }else{
                echo "Failed to change directory to".$ftp_dir; 
            }

            #關閉FTP連線
            ftp_close($conn_id);
        }else{
     
        }

        return $csvdata;

    }*/


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


    public function get_result($checked_sn_in, $id, $chat_mode) {
        $file_arr = array('_0p5', '_1p0', '_2p0');
        $no_arr = explode(',', $id);
        $csv_array = array();
        $found_count = 0; 
        $missing_files = []; 
    
        foreach ($no_arr as $key => $val) {
            if (!empty($val)) {
                $file_found = false; 
                foreach ($file_arr as $file_suffix) {
                    $infile = '../public/data/DATALOG_' . str_pad($val, 10, "0", STR_PAD_LEFT) . $file_suffix . ".csv";
                    if (file_exists($infile)) {
                        $csvdata = file_get_contents($infile);
                        $rows = explode("\n", $csvdata);
                        $csv_array['data' . $key] = array_map('str_getcsv', $rows);
                        $found_count++; 
                        $file_found = true; 
                    }
                }
                if (!$file_found) {
                    $missing_files[] = $val; 
                }
            }
        }
    
        if ($found_count < count($no_arr)) {

            $missing_ids = implode(', ', $missing_files);
            echo "<script>alert('找不到檔案編號: $missing_ids');</script>";
            //echo "<script>alert('找不到檔案編號: $missing_ids'); window.location.href='?url=Historicals';</script>";
            //exit; 
        }
    
        if (is_null($csv_array)) {
            $csv_array = null;
        } else {
            if (!empty($chat_mode)) {
                $position = (int)$chat_mode;
            } else {
                $position = null;
            }
    
            foreach ($csv_array as &$innerarray) {
                foreach ($innerarray as $key1 => $va) {
                    if (!isset($va[1]) || empty($va[1])) {
                        unset($innerarray[$key1]);
                    } elseif ($position === 5 || $position === 6) {
                        $innerarray['torque'][$key1] = $va[1];
                        $innerarray['angle'][$key1] = $va[2];
                    } else {
                        $innerarray[$key1] = $va[$position];
                    }
                }
            }
        }
    
        return $csv_array;  
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
    
                foreach ($csv_array as $subarray) {
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

            case "job_info_new":
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
    public function unitarr_change($torValues, $inputType, $TransType){
        
        $inputType = (int)$inputType;
        $TransType = (int)$TransType;

        
        $TorqueUnit = [
            "N_M" => 1,
            "KGF_M" => 0,
            "KGF_CM" => 2,
            "LBF_IN" => 3
        ];

        $convertedValues = array();
        foreach($torValues as $torValue) {
           
            $torValue = floatval($torValue);
           
            if ($inputType == $TorqueUnit["N_M"]) {
                if ($TransType == $TorqueUnit["KGF_M"]) {
                
                    $convertedValues[] = round($torValue * 0.102, 4);
                } elseif ($TransType == $TorqueUnit["KGF_CM"]) {
                
                    $convertedValues[] = round($torValue * 10.2, 2);
                } elseif ($TransType == $TorqueUnit["LBF_IN"]) {
                  
                    $convertedValues[] = round($torValue * 10.2 * 0.86805, 2);
                } elseif ($TransType == $TorqueUnit["N_M"]) {
                  
                    $convertedValues[] = round($torValue, 3);
                }
            } 
            
            elseif ($inputType == $TorqueUnit["KGF_M"]) {
                if ($TransType == $TorqueUnit["KGF_M"]) {
                    $convertedValues[] = round($torValue, 4);
                } elseif ($TransType == $TorqueUnit["KGF_CM"]) {
                    $convertedValues[] = round($torValue * 100, 2);
                } elseif ($TransType == $TorqueUnit["LBF_IN"]) {
                    
                    $convertedValues[] = round($torValue * 100 * 0.86805, 2);
                } elseif ($TransType == $TorqueUnit["N_M"]) {
                    $convertedValues[] = round($torValue * 9.80392156, 3);
                }
            }

            elseif ($inputType == $TorqueUnit["KGF_CM"]) {
                if ($TransType == $TorqueUnit["KGF_M"]) {
                    $convertedValues[] = round($torValue * 0.01, 4);
                } elseif ($TransType == $TorqueUnit["KGF_CM"]) {
                    $convertedValues[] = round($torValue, 2);
                } elseif ($TransType == $TorqueUnit["LBF_IN"]) {
                    $convertedValues[] = round($torValue * 0.86805, 2);
                } elseif ($TransType == $TorqueUnit["N_M"]) {
                    $convertedValues[] = round($torValue * 0.0980392156, 3);
                }
            }

            elseif ($inputType == $TorqueUnit["LBF_IN"]) {
                
                if ($TransType == $TorqueUnit["KGF_M"]) {
                    $convertedValues[] = round($torValue * 1.152 * 0.01, 4);
                } elseif ($TransType == $TorqueUnit["KGF_CM"]) {
                    $convertedValues[] = round($torValue * 1.152, 2);
                } elseif ($TransType == $TorqueUnit["LBF_IN"]) {
                    $convertedValues[] = round($torValue, 2);
                } elseif ($TransType == $TorqueUnit["N_M"]) {
                    $convertedValues[] = round($torValue * 0.11294117637119998, 3);
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
}
