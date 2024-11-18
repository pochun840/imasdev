<?php
#==================================
#   中控搜尋API
#   get_data_api.php
#==================================

require_once('../app/libraries/Database.php'); 

$db = new Database();
$db_cc = $db->getDb_cc();  



header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Methods: OPTIONS, GET, POST");
header("Access-Control-Allow-Headers: Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control");

// 輸出API說明
$ps_text = '
<!--
奇力速 中控搜尋API

介接位址：/api/get_data_api.php
　　　　　/api/get_data_api.php?operator=test&status=0&limit=100&type=xml
參數說明：barcodesn        => 條碼
　　　　　controller_val   => 控制器(目前只有GTCS)
         job              => 工作(job_id,數字)
         seq              => 工序(seq_id,數字)
         task             => 任務(task_id,數字)
         start_date       => 起始日期(格式為：YYYYMMDDHH (西元年月日小時)，共 10 碼數字)
         end_date         => 結束日期(格式為：YYYYMMDDHH (西元年月日小時)，共 10 碼數字)
         status           => 鎖附結果(0 => ALL, 1 => OK, 2 =>OKALL, 3 =>NG)
         program          => 組別(利用program_id查詢,數字)
         s_name           => 模糊搜尋(可以輸入job_name,sequence_name,task_name,barcodesn)
         limit            => 筆數 (數字)
        

補通說明: 
1.job_id 及 seq_id 輸入數字後,會取得對應的名稱,會用名稱去搜尋
2.輸出格式為:xml && json && array
-->

';
//echo $ps_text;

#條碼
$barcodesn = isset($_GET['barcodesn']) ? $_GET['barcodesn'] : '';
if(!preg_match('/^[\w\s]+$/', $barcodesn)) $barcodesn = '';

#job_id
$job_id =  isset($_GET['job_id']) ? $_GET['job_id'] : '';
if(!preg_match('/^\d+$/', $job_id)) $job_id = '';
if(!empty($job_id)){
    //用job_id 取得 job_name 
    $seql_select_jobname = "SELECT * FROM job WHERE job_id = :job_id"; 
    $statement = $db_cc->prepare($seql_select_jobname); 
    $statement->bindValue(':job_id', $job_id, PDO::PARAM_INT); 
    $statement->execute(); 
    $results = $statement->fetchAll(PDO::FETCH_ASSOC);
    if(!empty($results)){
        $job_name = $results[0]['job_name'];
    }
}




#seq_id
$seq_id = isset($_GET['seq_id']) ? $_GET['seq_id'] : '';
if(!preg_match('/^\d+$/', $seq_id)) $seq_id = '';
if(!empty($seq_id) && !empty($job_id)){
    //用job_id  及 seq_id 取得 seq_name 
    $seql_select_seqname = "SELECT * FROM sequence  WHERE job_id = :job_id AND seq_id = :seq_id "; 
    $statement = $db_cc->prepare($seql_select_seqname); 
    $statement->bindValue(':job_id', $job_id, PDO::PARAM_INT); 
    $statement->bindValue(':seq_id', $seq_id, PDO::PARAM_INT); 
    $statement->execute(); 
    $results = $statement->fetchAll(PDO::FETCH_ASSOC);
    if(!empty($results)){
        $seq_name = $results[0]['seq_name'];
    }
}



#task_id
$task_id = isset($_GET['task_id']) ? $_GET['task_id'] : '';
if(!preg_match('/^\d+$/', $task_id)) $task_id = '';

#起始日期
$start_date = isset($_GET['start_date']) ? $_GET['start_date'] : null;
if ($start_date) {
    $start_date = validateAndFormatDate($start_date);
}


#結束日期
$end_date = isset($_GET['end_date']) ? $_GET['end_date'] : null;
if ($end_date) {
    $end_date = validateAndFormatDate($end_date);
}


#人員
$operator = isset($_GET['operator']) ? $_GET['operator'] : null;
if(!preg_match('/^[\w\s]+$/', $operator)) $operator = '';


#組別
$program = isset($_GET['program']) ? $_GET['program'] : null;
if(!preg_match('/^\d+$/', $program)) $program = '';


#鎖附狀態
$status  =isset($_GET['status']) ? $_GET['status'] : null;
if(!preg_match('/^\d+$/', $status)) $status = 0;


#模糊搜尋
$sname = isset($_GET['sname']) ? $_GET['sname'] : null;
if(!preg_match('/^[\w\s]+$/', $sname)) $sname = '';

# 筆數
$limit =isset($_GET['limit']) ? $_GET['limit'] : null;
if(!preg_match('/^\d+$/', $limit)) $limit = 100;

# 輸出類型
$type = $_GET['type'];
if(!empty($type)) $type = 'xml';

function validateAndFormatDate($date){
    if (preg_match("/^20[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])(0[0-9]|1[0-9]|2[0-4])$/", $date)) {
        return date('Ymd H:i:s', strtotime($date . '00'));
    }
    return null; // 如果格式不符合，返回 null
}


$sql = "SELECT * FROM `fasten_data` ";
$sql.= "WHERE 1 ";

if($barcodesn) {
    $sql .= " AND cc_barcodesn  LIKE %" . $barcodesn . "% " ;
}

if($operator) {
    $sql .= " AND cc_operator = '".$operator."'  " ;
}

if($program){
    $sql .="AND cc_program_id = '".$program."'";
}
if($sname){
    $sql .= " AND (job_name LIKE '%" . $sname . "%' OR sequence_name LIKE '%" . $sname . "%' OR cc_task_name LIKE '%" . $sname . "%' OR cc_barcodesn LIKE '%" . $sname . "%')";
}

if($start_date){
    $sql .= " AND	data_time between = '".$start_date."'  AND '".$end_date."' " ;
}



if($status){
    if($status == 0){//ALL 
        $sql .="AND fasten_status !='' ";

    }else if($status  == 1){ //OK
        $sql .="AND fasten_status  in('4')";
    }else if($status == 2){ //OKALL
        $sql .="AND fasten_status in('5','6') ";
    }else{//NG
        $sql .=" AND fasten_status  in('7','8') ";

    }
}

$sql .= " ORDER BY data_time DESC LIMIT ".$limit." ";

$statement = $db_cc->prepare($sql); 
$statement->execute(); 

$results = $statement->fetchAll(PDO::FETCH_ASSOC); 
if(!empty($results)){
    $newsItem = $results;
}


# 輸出結果
switch($type)
{
    
    # 陣列
    case 'array':
        header('Content-type: text/html; charset=utf-8');
        echo "<pre>";
        print_r($newsItem);
        echo "</pre>";
    break;
    # JSON
    case 'json':
        header('Content-type: application/json; charset=utf-8');
        echo json_encode($newsItem);
        //pre($newsItem['data']);
    break;
    default:
    # XML
    case 'xml':

        $xml = '<?xml version="1.0" encoding="UTF-8"?>'."\n";
        $xml.= $ps_text."\n";
        $xml.= '<kiss>'."\n";
        foreach($newsItem as $k => $v){
            $xml.= '<item>'."\n";
            $xml .= '<id><![CDATA['.$v['id'].']]></id>'."\n";
            $xml .= '<cc_barcodesn><![CDATA['.$v['cc_barcodesn'].']]></cc_barcodesn>'."\n";
            $xml .= '<cc_station><![CDATA['.$v['cc_station'].']]></cc_station>'."\n";
            $xml .= '<cc_job_id><![CDATA['.$v['cc_job_id'].']]></cc_job_id>'."\n";
            $xml .= '<cc_seq_id><![CDATA['.$v['cc_seq_id'].']]></cc_seq_id>'."\n";
            $xml .= '<cc_task_id><![CDATA['.$v['cc_task_id'].']]></cc_task_id>'."\n";
            $xml .= '<cc_program_id><![CDATA['.$v['cc_program_id'].']]></cc_program_id>'."\n";
            $xml .= '<cc_equipment><![CDATA['.$v['cc_equipment'].']]></cc_equipment>'."\n";
            $xml .= '<cc_operator><![CDATA['.$v['cc_operator'].']]></cc_operator>'."\n";
            $xml .= '<system_sn><![CDATA['.$v['system_sn'].']]></system_sn>'."\n";
            $xml .= '<data_time><![CDATA['.$v['data_time'].']]></data_time>'."\n";
            $xml .= '<device_type><![CDATA['.$v['device_type'].']]></device_type>'."\n";
            $xml .= '<device_id><![CDATA['.$v['device_id'].']]></device_id>'."\n";
            $xml .= '<device_sn><![CDATA['.$v['device_sn'].']]></device_sn>'."\n";
            $xml .= '<tool_type><![CDATA['.trim($v['tool_type']).']]></tool_type>'."\n";
            $xml .= '<tool_sn><![CDATA['.trim($v['tool_sn']).']]></tool_sn>'."\n";
            $xml .= '<tool_status><![CDATA['.$v['tool_status'].']]></tool_status>'."\n";
            $xml .= '<job_id><![CDATA['.$v['job_id'].']]></job_id>'."\n";
            $xml .= '<job_name><![CDATA['.$v['job_name'].']]></job_name>'."\n";
            $xml .= '<sequence_id><![CDATA['.$v['sequence_id'].']]></sequence_id>'."\n";
            $xml .= '<sequence_name><![CDATA['.$v['sequence_name'].']]></sequence_name>'."\n";
            $xml .= '<step_id><![CDATA['.$v['step_id'].']]></step_id>'."\n";
            $xml .= '<fasten_torque><![CDATA['.$v['fasten_torque'].']]></fasten_torque>'."\n";
            $xml .= '<torque_unit><![CDATA['.$v['torque_unit'].']]></torque_unit>'."\n";
            $xml .= '<fasten_time><![CDATA['.$v['fasten_time'].']]></fasten_time>'."\n";
            $xml .= '<fasten_angle><![CDATA['.$v['fasten_angle'].']]></fasten_angle>'."\n";
            $xml .= '<count_direction><![CDATA['.$v['count_direction'].']]></count_direction>'."\n";
            $xml .= '<last_screw_count><![CDATA['.$v['last_screw_count'].']]></last_screw_count>'."\n";
            $xml .= '<max_screw_count><![CDATA['.$v['max_screw_count'].']]></max_screw_count>'."\n";
            $xml .= '<fasten_status><![CDATA['.$v['fasten_status'].']]></fasten_status>'."\n";
            $xml .= '<error_message><![CDATA['.$v['error_message'].']]></error_message>'."\n";
            $xml .= '<step_targettype><![CDATA['.$v['step_targettype'].']]></step_targettype>'."\n";
            $xml .= '<step_tooldirection><![CDATA['.$v['step_tooldirection'].']]></step_tooldirection>'."\n";
            $xml .= '<step_rpm><![CDATA['.$v['step_rpm'].']]></step_rpm>'."\n";
            $xml .= '<step_targettorque><![CDATA['.$v['step_targettorque'].']]></step_targettorque>'."\n";
            $xml .= '<step_hightorque><![CDATA['.$v['step_hightorque'].']]></step_hightorque>'."\n";
            $xml .= '<step_lowtorque><![CDATA['.$v['step_lowtorque'].']]></step_lowtorque>'."\n";
            $xml .= '<step_targetangle><![CDATA['.$v['step_targetangle'].']]></step_targetangle>'."\n";
            $xml .= '<step_highangle><![CDATA['.$v['step_highangle'].']]></step_highangle>'."\n";
            $xml .= '<step_lowangle><![CDATA['.$v['step_lowangle'].']]></step_lowangle>'."\n";
            $xml .= '<step_delayttime><![CDATA['.$v['step_delayttime'].']]></step_delayttime>'."\n";
            $xml .= '<threshold_torque><![CDATA['.$v['threshold_torque'].']]></threshold_torque>'."\n";
            $xml .= '<step_threshold_angle><![CDATA['.$v['step_threshold_angle'].']]></step_threshold_angle>'."\n";
            $xml .= '<downshift_torque><![CDATA['.$v['downshift_torque'].']]></downshift_torque>'."\n";
            $xml .= '<downshift_speed><![CDATA['.$v['downshift_speed'].']]></downshift_speed>'."\n";
            $xml .= '<step_prr_rpm><![CDATA['.$v['step_prr_rpm'].']]></step_prr_rpm>'."\n";
            $xml .= '<step_prr_angle><![CDATA['.$v['step_prr_angle'].']]></step_prr_angle>'."\n";
            $xml .= '<barcode><![CDATA['.$v['barcode'].']]></barcode>'."\n";
            $xml .= '<total_angle><![CDATA['.$v['total_angle'].']]></total_angle>'."\n";
            $xml .= '<on_flag><![CDATA['.$v['on_flag'].']]></on_flag>'."\n";
            $xml .= '<cc_task_name><![CDATA['.$v['cc_task_name'].']]></cc_task_name>'."\n";
           
            $xml.= '  </item>'."\n";
        }
        $xml.= '</kiss>'."\n";

        header('Content-type: text/xml; charset=utf-8');
        echo $xml;

    break;
}

?>
