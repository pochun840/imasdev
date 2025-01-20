<?php

class Calibrations extends Controller
{
    private $DashboardModel;
    private $NavsController;
    private $mean;
    private $SettingsController; 

    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->NavsController = $this->controller_new('Navs');
        $this->UserModel = $this->model('User');
        $this->CalibrationModel = $this->model('Calibration');
        $this->EquipmentModel = $this->model('Equipment');
        $this->SettingsController = $this->controller_new('Settings'); 
        $this->TemplatesController = $this->controller_new('Templates'); 

    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();

        #select
        $info = $this->CalibrationModel->datainfo();

        #彈簧測試座
        $screw_joint_list = $this->CalibrationModel->screw_joint_list();

        #取得起子的型號
        $tools_model = $this->TemplatesController->CFG_reader(); 

        $torque_type = $this->CalibrationModel->details('torque');


        $data_json = $this->SettingsController->Get_Device_Name(); 
        if(!empty($data_json)){
            $dataArray = json_decode($data_json, true);  
            $tools_sn=trim($dataArray['tool_sn']);
        }else{
            $tools_sn = '';
        }

        

        $device_version_json = $this->Get_Device_version();
        $device_array = json_decode($device_version_json, true);
        if(!empty($device_array)){
            $device_version = $device_array['device_version'];
            $res_unit  = $this->unit_no();
            $last_unit = end($res_unit);
            $torque_name = $this->CalibrationModel->torque_unit_code($last_unit);
        }else{
            $torque_name = '';
            $last_unit   = '';
        }
        
        $ktm = $this->CalibrationModel->details('torquemeter');
        $job_id = 221;

        $skipTurnRev = isset($_COOKIE['skipTurnRev']) ? intval($_COOKIE['skipTurnRev']) : 1;
        
        $avg = $this->CalibrationModel->get_last_record();

        $meter = $this->val_traffic();

        #曲線圖的資料
        $echart_data = $this->CalibrationModel->datainfo_search($job_id);
        if(!empty($echart_data)){
            #整理圖表所需要的資料
            $tmp['x_val'] = json_encode(array_column($echart_data, 'id'));
            $tmp['y_val_torque_1'] = json_encode(array_column($echart_data, 'torque'));
            $tmp['y_val_torque_2'] = json_encode(array_column($echart_data, 'fasten_torque'));


        }
        if(empty($info)){
            $info = '';
        }
        if(empty($meter)){
            $meter = '';
        }
        if(empty($tmp)){
            $tmp = '';
        }
        if(empty($info_res)){
            $info_res = '';
        }

        if(!empty($meter['res_total'])){
            $count = count($meter['res_total']);
        }else{
            $count = 0;
        }

        if(empty($_SESSION['torqueMeter'])){
            $_SESSION['torqueMeter'] = 0;
        }

        if(!empty($info)){
            $last_item = end($info);
        }else{
            $last_item = '';
        }

        if (is_array($last_item) && isset($last_item['avg_torque'])) {
            $avg_torque = $last_item['avg_torque'];
        } else {
            $avg_torque = null; 
        }


        $data = array(
            'isMobile' => $isMobile,
            'nav' => $this->NavsController->get_nav(),
            'res_controller_arr' => $this->CalibrationModel->details('controller'),
            'res_Torquemeter_arr' => $this->CalibrationModel->details('torquemeter'),
            'res_Torquetype' => $this->CalibrationModel->details('torque'),
            'avg_torque' => $avg,
            'info' => $info,
            'echart'=> $tmp,
            //'job_arr' => $job_arr,
            'meter' =>$meter,
            'count' =>$count,
            'torque_type ' => $torque_type,
            'tools_sn' => $tools_sn,
            'avg_torque' => $avg_torque,
            'current_torquemeter' => $ktm[$_SESSION['torqueMeter']],
            'user' => $_SESSION['user'],
            'skipTurnRev' => $skipTurnRev,
            'language' => $_SESSION['language'],
            'torque_name' => $torque_name,
            'last_unit' => $last_unit,
            'screw_joint_list' => $screw_joint_list,
            'tools_model' => $tools_model
            
        );
        $this->view('calibration/index', $data);


    }

    public function get_latest_info() {
        $info = $this->CalibrationModel->datainfo();        
        $job_id = 221;
        $echart_data = $this->CalibrationModel->datainfo_search($job_id);

        $temp = $info;
        $avg_torque = $this->CalibrationModel->get_last_record();

        $temp = array_map(function($item) {
            return ['torque' => $item['torque']];
        }, $temp);


        $max_torque = !empty($temp) ? max($temp) : null;
        $min_torque = !empty($temp) ? min($temp) : null;

        
        $tmp = [
            'x_val' => [],
            'y_val_torque_1' => [],
            'y_val_torque_2' => [],
        ];
    
        if (!empty($echart_data)) {
            $tmp['x_val'] = array_column($echart_data, 'id');
            $tmp['y_val_torque_1'] = json_encode(array_column($echart_data, 'torque'));
            $tmp['y_val_torque_2'] = json_encode(array_column($echart_data, 'fasten_torque'));

        }
    
      
        $combinedData = array(
            'info' => $info,
            'echart_data' => $tmp,
            'avg_torque' =>$avg_torque,
            'meter' => [
                'torque' => $temp,
                'max-torque' => $max_torque,
                'min-torque' => $min_torque
            ]
        );
    
        echo json_encode($combinedData);
    }

    public function get_val() {

 
        // 檢查會話是否已經啟動，若未啟動則啟動會話
        if (session_status() == PHP_SESSION_NONE) {
            session_start(); 
        }
    
        // 獲取 cookie 中的 skipTurnRev 的值
        $skipTurnRev = isset($_COOKIE['new_skip']) ? $_COOKIE['new_skip'] : 'no';
        
        // 獲取 cookie 中的 implement_count 的值
        $implementCount = isset($_COOKIE['implement_count']) ? intval($_COOKIE['implement_count']) : '';
    
        // 文件路徑
        $file_tmp = __DIR__; 
        $file_tmp = dirname($file_tmp); 
        $file_tmp = dirname($file_tmp); //再往上一層
        $file_path = $file_tmp . "/api/final_val.txt";

        // 檢查文件是否存在
        if (!file_exists($file_path)) {
            // 如果未顯示過文件未找到的消息，則顯示並設置標誌
            if (!isset($_SESSION['file_not_found'])) {
                echo json_encode(array('success' => false, 'message' => '文件未找到'));
                $_SESSION['file_not_found'] = true; // 設置標誌
            }
            return;
        }
    
        // 讀取文件內容
        $fileContent = file($file_path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES); 
        $cleanedDataArray = [];
    
        // 清理文件內容
        foreach ($fileContent as $data) {
            $cleanedData = trim($data); 

            if (preg_match('/^[+-]?(\s*\d+(\.\d+)?|\s+\d+(\.\d+)?)$/', $cleanedData)) {
                $cleanedDataArray[] = trim(str_replace(' ', '', $cleanedData)); 
            }
        }

        // 獲取工具序列號
        $data_json = $this->SettingsController->Get_Device_Name(); 
        if(!empty($data_json)){
            $dataArray = json_decode($data_json, true);  
            $tools_sn=trim($dataArray['tool_sn']);
        }else{
            $tools_sn = '';
        }

        //取得控制器的system_sn 及 fasten_torque
        $controller_data_json = $this->get_controller_data();
        if(!empty($controller_data_json)){
            $dataArray_temp = json_decode($controller_data_json, true);  
            $system_sn = trim($dataArray_temp['system_sn']);
            $fasten_torque = trim($dataArray_temp['fasten_torque']);
        }

    
        // 如果清理後的數據數組不為空
        if (!empty($cleanedDataArray)) {
            $lastValue = end($cleanedDataArray); 
            $final_val = $lastValue;    

            $trimmedFinal = trim($final_val);
            //使用正規化 移除 "+"
            if (preg_match('/\+/', $trimmedFinal)) {
                $finalNumber = preg_replace('/\+/', '', $trimmedFinal);
            } else {
                $finalNumber = $trimmedFinal;
            }

            //轉換浮點數

            $final = floatval($finalNumber);

            if($skipTurnRev  == "1"){
                //$final 是負的 則不要進行這段
                //$final 是正的 則要進行這段

                if ($final > 0){
                    $res = $this->CalibrationModel->tidy_data($final, $tools_sn,$system_sn,$fasten_torque);
                }else{
                    unlink($file_path);
                    echo json_encode(array('success' => false, 'message' => '檔案已刪除，因為 final 值為負'));
                    return; 
                }
       
            }else{
                $res = $this->CalibrationModel->tidy_data($final, $tools_sn,$system_sn,$fasten_torque);
            }

            #取得最新的筆數
            $temp_count = $this->CalibrationModel->getTotalRecords();

        
            // 返回整理結果
            if ($res == true) {
                $response = array(
                    'success' => true,
                    'type'    => 'success',
                    'message' => '數據整理成功',
                    'count'   => $temp_count
                );
            } else {
                $response = array(
                    'success' => false,
                    'type'    => 'fail',
                    'message' => '未找到數據',
                    'count'   => $temp_count
                );
            }

    
            // 刪除文件
            unlink($file_path);

            $this->logMessage('calibrations-1','result-1',json_encode($response, JSON_UNESCAPED_UNICODE));

            echo json_encode($response);
        } else {
            echo json_encode(array('success' => false, 'message' => '未找到有效數據'));
        }
    }

    
    public function get_data() {
        $job_id = 221;
        if ($job_id) {
            $dataset = $this->CalibrationModel->datainfo_search($job_id);
            $torque_type = $this->CalibrationModel->details('torque');
            
            $datalist = [];
            foreach ($dataset as $val) {
                $row = '<tr style="text-align: center; vertical-align: middle;" data-id="' . $val['id'] . '">';
                $row .= "<td>" . $val['id'] . "</td>";
                $row .= "<td>" . $val['datatime'] . "</td>";
                $row .= "<td>" . $val['operator'] . "</td>";
                $row .= "<td>" . $val['toolsn'] . "</td>";
                $row .= "<td>" . $val['torque'] . "</td>";
                $row .= "<td>" . $val['fasten_torque'] . "</td>";
                $row .= "<td>" . $torque_type[$val['unit']] . "</td>";
                $row .= "<td>" . $val['max_torque'] . "</td>";
                $row .= "<td>" . $val['min_torque'] . "</td>";
                $row .= "<td>" . $val['avg_torque'] . "</td>";
                $row .= "<td>" . $val['high_percent'] . " % " . "</td>";
                $row .= "<td>" . $val['low_percent'] . " % " . "</td>";
                $row .= "<td>" . $val['customize'] . "</td>";
                $row .= "</tr>";
                $datalist[] = $row;
            }
            echo json_encode($datalist); 
        }
    }

    public function del_info(){
        $input_check = true;
        if(isset($_POST['chicked_id']) && !empty($_POST['chicked_id'])) {
            $click_id = $_POST['chicked_id'];
        }else{
            $input_check = false;
        }

        if($input_check){
            $res = $this->CalibrationModel->del_info($click_id);
            if($res == true){
                $response = array(
                    'success' => true,
                    'type'    => 'success',
                    'message' => 'Data delete success'
                );
            }else{
                $response = array(
                    'success' => false,
                    'type'    => 'fail',
                    'message' => 'Data delete fail'
                );
            }

            #紀錄log
            $response = array(
                'success' => true,
                'type'    => 'success',
                'message' => '刪除單筆紀錄:'.$click_id
            );
        
            if($res == true){
                //成功
                $this->logMessage('calibrations-3','result-1',json_encode($response, JSON_UNESCAPED_UNICODE));
            }else{
                //失敗
                $this->logMessage('calibrations-3','result-2',json_encode($response, JSON_UNESCAPED_UNICODE));
            }
            echo json_encode($response);

           
        }


    }

    public function del_all(){
        
        $result = $this->CalibrationModel->del_all();
        $this->logMessage('calibrations-2', 'result-1','success: del total');
        

        //移除檔案 
        $file_tmp = __DIR__; 
        $file_tmp = dirname($file_tmp); 
        $file_tmp = dirname($file_tmp); //再往上一層
        $file_path = $file_tmp . "/api/final_val.txt";

        // 檢查文件是否存在
        if (!file_exists($file_path)) {
            // 如果未顯示過文件未找到的消息，則顯示並設置標誌
            if (!isset($_SESSION['file_not_found'])) {
                echo json_encode(array('success' => false, 'message' => '文件未找到'));
                $_SESSION['file_not_found'] = true; // 設置標誌
            }
            return;
        } else {
            // 如果文件存在，則刪除文件
            if (unlink($file_path)) {
                echo json_encode(array('success' => true, 'message' => '文件已成功刪除'));
            } else {
                echo json_encode(array('success' => false, 'message' => '文件刪除失敗'));
            }
        }

        if(isset($_COOKIE['implement_count'])) {
            setcookie('implement_count', '', time() - 3600, '/');
        }

       

    }
 
    #產生XML的API
    public function get_xml(){

            $info = $this->CalibrationModel->datainfo();
            $torque_type = $this->CalibrationModel->details('torque');
            $controller_type = $this->CalibrationModel->details('controller');
            $ktm_total = $this->CalibrationModel->details('torquemeter');
    
            $xml = new XMLWriter();
            $xml->openMemory();
            $xml->setIndent(true);
            $xml->startDocument('1.0', 'UTF-8');
            $xml->startElement('calibrations');
    
            foreach ($info as $row) {
                $xml->startElement('item');
                foreach ($row as $key => $value) {
                    $xml->startElement($key);
                    if ($key == 'unit') {
                        $value = "N.m";
                    }
    
                    if ($key == 'high_percent' ||  $key == 'low_percent') {
                        $value = $value ." % ";
                    }
                    if($key == 'controller_type'){
                        $value = isset($controller_type[$value]) ? $controller_type[$value] : ''; 
                    }   
                    if($key == 'ktm_type'){
                        $value = isset($ktm_total[$value]) ? $ktm_total[$value] : ''; 
                    }  
    
                    $xml->writeCData($value);
                    $xml->endElement();
                }
                $xml->endElement(); 
            }
        
            $xml->endElement(); 
            $xml->endDocument();
            header('Content-type: text/xml; charset=utf-8');
            echo $xml->outputMemory();

    
    
    }
    
    
    public function val_traffic() {
        $a = 0.6;
        $b = 0.06;
    
        $temp = array();
        $info = $this->CalibrationModel->meter_info();
    
        // 检查 info 是否有数据
        if (!empty($info)) {
            foreach ($info as $sub_array) {
                if (array_key_exists('torque', $sub_array)) {
                    $torque_array[] = $sub_array['torque'];
                }
            }
        
            // 依照KTM 文件裡的算式 
            $temp['hi_limit_torque'] = $a + $b;
            $temp['low_limit_torque'] = $a - $b;
            $temp['max_torque'] = $info[0]['max_torque'];
            $temp['min_torque'] = $info[0]['min_torque'];
            $temp['avg_torque'] = $info[0]['avg_torque'];
            $temp['stddev1'] = number_format($this->standard_deviation($torque_array), 2);
            $temp['stddev2'] = number_format($temp['stddev1'] / $temp['avg_torque'], 2);
            $temp['stddev3'] = $temp['stddev2'] * 3;
           
            $temp['cm'] = isset($temp['stddev1']) && $temp['stddev1'] != 0 
            ? number_format(($temp['hi_limit_torque'] - $temp['low_limit_torque']) / (6 * $temp['stddev1']), 2) 
            : 0; 


            $temp['cmk'] = number_format($this->calculatezscore($temp['hi_limit_torque'], $temp['low_limit_torque'], $temp['stddev1']), 2);
    
            $temp['res_total'] = $info;
        } else {
            // 如果没有数据，可以选择返回一个特定的消息或空数组
            return array('error' => 'No data available.');
        }
    
        return $temp;
    }
    

    public function export_excel(){
        $isMobile = $this->isMobileCheck();

        #select
        $info = $this->CalibrationModel->datainfo();

        #echarts
        $echart_data = $this->CalibrationModel->echarts_data();


        $sum_torque = 0;
        $sum_fasten_torque = 0;
        $count = count($info); 
        
        // 遍歷陣列，累加每個項目的 torque 和 fasten_torque 值
        foreach ($info as $item) {
            $sum_torque += $item['torque'];
            $sum_fasten_torque += $item['fasten_torque'];
        }
        
        // 計算平均值
        $average_torque = $sum_torque / $count;
        $average_fasten_torque = $sum_fasten_torque / $count;
        

        $data_json = $this->SettingsController->Get_Device_Name(); 
        if(!empty($data_json)){
            $dataArray = json_decode($data_json, true);  
            $tools_sn=trim($dataArray['tool_sn']);
        }else{
            $tools_sn = '';
        }

        $meter = $this->val_traffic();

        if(!empty($echart_data)){
            #整理圖表所需要的資料
            $tmp['x_val'] = json_encode(array_column($echart_data, 'id'));
            $tmp['y_val_torque_1'] = json_encode(array_column($echart_data, 'torque'));
            $tmp['y_val_torque_2'] = json_encode(array_column($echart_data, 'fasten_torque'));
        }else{
            $tmp = '';
        }

        if(!empty($meter['res_total'])){
             $res_total = count($meter['res_total']);
        }else{
            $res_total = '';
        }
        $data = array(
            'isMobile' => $isMobile,
            'nav' => $this->NavsController->get_nav(),
            'res_controller_arr' => $this->CalibrationModel->details('controller'),
            'res_Torquemeter_arr' => $this->CalibrationModel->details('torquemeter'),
            'res_Torquetype' => $this->CalibrationModel->details('torque'),
            'info' => $info,
            'echart'=> $tmp,
            'meter' =>$meter,
            'count' =>$res_total,
            'tools_sn' => $tools_sn,
            'torque' => $average_torque,
            'fasten_torque' =>  $average_fasten_torque
            
        );

        if(!empty($_GET['type'])){
            if($_GET['type'] =="download"){
                $data['type'] = "download";
            }

        }else{
            $data['type'] = '';
        }
        
        $this->view('calibration/excel',$data);


    }

    public function csv_download(){
        
        $job_id = 221;
        
        if($job_id){
            $dataset = $this->CalibrationModel->datainfo_search($job_id);
            if(!empty($dataset)){

                $torque_type = $this->CalibrationModel->details('torque');
                $controller = $this->CalibrationModel->details('controller');
                $ktm_total = $this->CalibrationModel->details('torquemeter');

                #資料整理 
                foreach($dataset as $key =>$val){
                    $dataset[$key]['unit'] = $torque_type[$val['unit']];
                    $dataset[$key]['high_percent'] = $val['high_percent']."%";
                    $dataset[$key]['low_percent'] = $val['low_percent']."%";
                    $dataset[$key]['controller_type'] = $controller[$val['controller_type']];
                    if (isset($ktm_total[$val['ktm_type']])) {
                        $dataset[$key]['ktm_type'] = $ktm_total[$val['ktm_type']];
                    } else {
                        $dataset[$key]['ktm_type'] = '';
                    }

                    
                }
          
                $csv_headers = array_keys($dataset[0]);
                header('Content-Type: text/csv; charset=utf-8');
                header('Content-Disposition: attachment; filename=data.csv');
    
                $output = fopen('php://output', 'w');
                fputcsv($output, $csv_headers);
    
                foreach ($dataset as $row) {
                    fputcsv($output, $row);
                }
    
                fclose($output);
                exit();
            }
        }
    }


    private function standard_deviation($torque_array) {
        $n = count($torque_array);
        $mean = array_sum($torque_array) / $n;
        $variance = 0.0;
        foreach ($torque_array as $x) {
            $variance += pow($x - $mean, 2);
        }
        $std_dev = sqrt($variance / $n);
        return $std_dev;
    }


    private function calculatezscore($hi_limit_torque, $low_limit_torque, $stddev1) {
        if ($stddev1 != 0) {
            $part1 = (($this->mean - $hi_limit_torque) / (3 * $stddev1));
            $part2 = (($low_limit_torque - $this->mean) / (3 * $stddev1));
        } else {
         
            $part1 = 0; 
            $part2 = 0; 
        }
        
        return min($part1, $part2);
    }

    public function current_save(){

        // 取得 device_version 的版本
        $device_version_json = $this->Get_Device_version();
        $device_array = json_decode($device_version_json, true);

        $device_version = $device_array['device_version'] ?? null;
        $device_version = (float)$device_version; 
        if ($device_version >=1.27) {

            $res_unit = $this->unit_no();
            $last_unit = end($res_unit);

            // 使用 switch 處理 multiple 的對應邏輯
            switch ($last_unit) {
                case 0:
                    $multiple = 10000;
                    break;
                case 1:
                    $multiple = 1000;
                    break;
                case 2:
                case 3: // 合併相同結果的條件
                    $multiple = 100;
                    break;
                case 4:
                    $multiple = 10;
                    break;
                default:
                    $multiple = 10000; // 預設值，防止未定義的情況
            }
        }else{
            $multiple = 100;
        }



        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
      
        if (isset($data['target_q'], $data['rpm'], $data['joint_offset'],$data['tolerance'])) {

            $controller_ip = $this->EquipmentModel->GetControllerIP(1);
            require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster($controller_ip, "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;

                $data['target_q'] = (int)((float)$data['target_q'] * $multiple);

                $percentage = $data['tolerance'] / 100; 

                $lower_limit = $data['target_q']  - ($data['target_q']  * $percentage); //下限
                $upper_limit = $data['target_q']  + ($data['target_q']  * $percentage); // 上限


                //如果 $data['joint_offset'] = +0.02 or -0.06  
                if (preg_match('/([+-]?)(\d*\.?\d+)/', $data['joint_offset'], $matches)) {

                    $sign = $matches[1];   // 取正負號
                    $number = $matches[2]; // 取數字 
                    

                    if( $sign == '+'  || $sign == ''){
                        $data_sign = array(0);
                    }else{
                        $data_sign = array(1);
                    }

                   
                }


                $number_val = (int)((float) $number * $multiple);
                $data_targqt_q = array(0,$data['target_q'],$last_unit);

                $data_rpm = array($data['rpm']);
                //$data_offset = array($number_val);
                $data_offset = array(0);
                $data_offset_sec = array($number_val);


                $lower_limit_arr = array(0,$lower_limit);
                $upper_limit_arr = array(0,$upper_limit);
                $data_job = array(221);
                $data_open = array(1);
                $tools_start = array(1);
                

                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

                $modbus->writeMultipleRegister(0, 1135, $data_open, $dataTypes); // 進階開啟
                $modbus->writeMultipleRegister(0, 1147, $data_targqt_q, $dataTypes); //目標扭力
                $modbus->writeMultipleRegister(0, 1151, $data_rpm, $dataTypes); //轉速
                $modbus->writeMultipleRegister(0, 1152, $data_sign, $dataTypes); //補償值
                $modbus->writeMultipleRegister(0, 1153, $data_offset, $dataTypes); //補償值(只有數值)
                $modbus->writeMultipleRegister(0, 1154, $data_offset_sec, $dataTypes); //補償值(只有數值)
                $modbus->writeMultipleRegister(0, 1155, $upper_limit_arr, $dataTypes); //上限
                $modbus->writeMultipleRegister(0, 1157, $lower_limit_arr, $dataTypes); //下限
                $modbus->writeMultipleRegister(0, 463,  $data_job, $dataTypes); //切換job
                $modbus->writeMultipleRegister(0, 461, $tools_start, $dataTypes);//起子啟用

                echo $modbus->status;
                exit();

            } catch (Exception $e) {
                echo $modbus->status;
                exit();
            }
            

        } else {
          
        }

    }
    
    public function stopNodeApp() {
        $output = shell_exec("pkill -f 'node app.js'");
    
        if ($output === null) {
            echo json_encode(['success' => true, 'message' => 'Node.js application stopped successfully.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to stop Node.js application.']);
        }
    }


    public function get_session_now() {

        if (session_status() == PHP_SESSION_NONE) {
            session_start(); 
        }
    
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            if (isset($_POST['skipTurnRev'])) {
                $_SESSION['skipTurnRev'] = $_POST['skipTurnRev']; // 将值存入 session
                echo "Session set to: " . $_SESSION['skipTurnRev']; // 返回消息
            }
        }else{
            //echo "eewe";
        }
        
        // 输出 session 值
        if (isset($_SESSION['skipTurnRev'])) {
            echo "Current session value: " . $_SESSION['skipTurnRev'];
        }
    }


    public function get_controller_data() {

        $controller_ip = $this->EquipmentModel->GetControllerIP(1);
        $db_name = 'data' . date("Y") . '.db';
        $remote_file = '/var/www/html/database/' . $db_name;
        $local_file = '../' . $db_name;
    
        $system_sn = '';
        $fasten_torque = '';
        $error_message = '';
    
        $ftp_timeout = 10; // 設定 FTP 逾時 (秒)
    
        $conn_id = @ftp_connect($controller_ip, 21, $ftp_timeout); // 使用 @ 抑制警告
    
        if ($conn_id) {
            $USERNAME = FTP_USER;
            $PASSWORD = FTP_PASSWORD;
    
            ftp_set_option($conn_id, FTP_TIMEOUT_SEC, $ftp_timeout);
            $login_result = @ftp_login($conn_id, $USERNAME, $PASSWORD);
    
            if (!$login_result) {
                $error_message = "FTP Login Failed.";
            } else {
                ftp_pasv($conn_id, true);
    
                $remote_filesize = ftp_size($conn_id, $remote_file);
                if ($remote_filesize === -1) {
                    $error_message = "Could not get remote file size.";
                } else {
                    $handle = fopen($local_file, 'wb'); // 使用 wb (二進位模式)
    
                    if ($handle) {
                        ftp_set_option($conn_id, FTP_TIMEOUT_SEC, $ftp_timeout);
                        if (ftp_fget($conn_id, $handle, $remote_file, FTP_BINARY, 0)) { // 使用 FTP_BINARY
                            $local_filesize = filesize($local_file);
                            if ($local_filesize != $remote_filesize) {
                                $error_message = "File download incomplete. Remote size: " . $remote_filesize . ", Local size: " . $local_filesize;
                                unlink($local_file);
                            }
                        } else {
                            $error_message = "Download $remote_file failed: " . error_get_last()['message'];
                            unlink($local_file);
                        }
                        fclose($handle);
                    } else {
                        $error_message = "Failed to open local file for writing.";
                    }
                }
            }
            ftp_close($conn_id);
        } else {
            $error_message = "FTP Connect Failed to " . $controller_ip;
        }
    
        if (empty($error_message)) { // 只有在 FTP 操作成功後才嘗試讀取資料庫
            $dbPath = '../' . $db_name;
            try {
                $pdo = new PDO("sqlite:$dbPath");
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
                $sql = 'SELECT system_sn, fasten_torque FROM data ORDER BY system_sn DESC LIMIT 1'; // 優化 SQL 查詢
                $statement = $pdo->prepare($sql);
                $statement->execute();
                $results = $statement->fetch(PDO::FETCH_ASSOC);
    
                if ($results) {
                    $system_sn = $results['system_sn'];
                    $fasten_torque = $results['fasten_torque'];
                } else {
                    $error_message = "No data found in data table.";
                }
    
                $pdo = null;
            } catch (PDOException $e) {
                $error_message = "Database error: " . $e->getMessage();
            }
        }
    
        return json_encode(array(
            'system_sn' => $system_sn,
            'fasten_torque' => $fasten_torque,
            'error_message' => $error_message
        ));
    }


    private function unit_no(){
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);
        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster($controller_ip, "TCP");
        try {
            $modbus->port = 502;
            $modbus->timeout_sec = 2;

            $unit_no = $modbus->readMultipleRegisters(0, 264, 1);
            return $unit_no;
    
        } catch (Exception $e) {
            return array('error' => $modbus->status);
        }


    }

    #取得控制器的版本
    public function Get_Device_version() {

        $controller_ip = $this->EquipmentModel->GetControllerIP(1);
        $remote_file = '/mnt/ramdisk/tcsdev.db';
        $local_file = '../tcsdev.db';
    
        $tool_sn = '';
        $error_message = '';
    
        // 設定 FTP 連線逾時 (秒)
        $ftp_timeout = 10;
    
        $conn_id = ftp_connect($controller_ip, 21, $ftp_timeout);
    
        if ($conn_id) {
            $USERNAME = FTP_USER;
            $PASSWORD = FTP_PASSWORD;
    
            // 設定登入逾時
            ftp_set_option($conn_id, FTP_TIMEOUT_SEC, $ftp_timeout);
    
            $login_result = @ftp_login($conn_id, $USERNAME, $PASSWORD); // 使用 @ 抑制警告訊息
    
            if (!$login_result) {
                $error_message = "FTP Login Failed.";
            } else {
                ftp_pasv($conn_id, true);
    
                // 取得遠端檔案大小
                $remote_filesize = ftp_size($conn_id, $remote_file);
                if ($remote_filesize === -1) {
                    $error_message = "Could not get remote file size.";
                } else {
    
                    $handle = fopen($local_file, 'wb'); // 使用 wb 以二進位模式寫入
    
                    if ($handle) {
                        // 設定檔案傳輸逾時
                        ftp_set_option($conn_id, FTP_TIMEOUT_SEC, $ftp_timeout);
                        if (ftp_fget($conn_id, $handle, $remote_file, FTP_BINARY, 0)) { // 使用 FTP_BINARY 確保檔案完整性
                            $local_filesize = filesize($local_file);
                            if ($local_filesize != $remote_filesize) {
                                $error_message = "File download incomplete. Remote size: " . $remote_filesize . ", Local size: " . $local_filesize;
                                unlink($local_file); // 刪除不完整的檔案
                            }
                        } else {
                            $error_message = "Download $remote_file to $local_file failed: " . error_get_last()['message'];
                            unlink($local_file); // 刪除下載失敗的檔案
                        }
                        fclose($handle);
                    } else {
                        $error_message = "Failed to open local file for writing.";
                    }
                }
            }
            ftp_close($conn_id);
        } else {
            $error_message = "FTP Connect Failed to " . $controller_ip;
        }
    
        if (empty($error_message)) { // 只有在 FTP 操作成功後才嘗試讀取資料庫
            $dbPath = '../tcsdev.db';
            try {
                $pdo = new PDO("sqlite:$dbPath");
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
                $sql = 'SELECT device_version FROM device_info LIMIT 1'; // 只取一筆資料，提升效率
                $statement = $pdo->prepare($sql);
                $statement->execute();
                $results = $statement->fetch(PDO::FETCH_ASSOC);
    
                if ($results) {
                    $tool_sn = $results['device_version'];
                } else {
                    $error_message = "No data found in device_info table.";
                }
    
                $pdo = null;
    
            } catch (PDOException $e) {
                $error_message = "Database error: " . $e->getMessage();
            }
        }
    
        return json_encode(array('device_version' => $tool_sn, 'error_message' => $error_message));
    }

}