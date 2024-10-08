<?php

class Calibrations extends Controller
{
    private $DashboardModel;
    private $NavsController;
    private $mean;

    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->NavsController = $this->controller_new('Navs');
        $this->UserModel = $this->model('User');
        $this->CalibrationModel = $this->model('Calibration');
        $this->EquipmentModel = $this->model('Equipment');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();

        #select
        $info = $this->CalibrationModel->datainfo();

        $job_arr = $this->CalibrationModel->getjobid();
        $torque_type = $this->CalibrationModel->details('torque');
        $tools_sn = $this->CalibrationModel->get_tools_sn();

        
        $ktm = $this->CalibrationModel->details('torquemeter');
       
      
        $job_id = 221;

        $echart_data = $this->CalibrationModel->datainfo_search($job_id);
        $meter = $this->val_traffic();
        if(!empty($echart_data)){
            #整理圖表所需要的資料
            $tmp['x_val'] = json_encode(array_column($echart_data, 'id'));
            $tmp['y_val'] = json_encode(array_column($echart_data, 'torque'));

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
        
        $data = array(
            'isMobile' => $isMobile,
            'nav' => $this->NavsController->get_nav(),
            'res_controller_arr' => $this->CalibrationModel->details('controller'),
            'res_Torquemeter_arr' => $this->CalibrationModel->details('torquemeter'),
            'res_Torquetype' => $this->CalibrationModel->details('torque'),
            'info' => $info,
            'echart'=> $tmp,
            'job_arr' => $job_arr,
            'meter' =>$meter,
            'count' =>$count,
            'torque_type ' => $torque_type,
            'tools_sn' => $tools_sn['device_sn'],
            'current_torquemeter' => $ktm[$_SESSION['torqueMeter']]
            
        );

        $this->view('calibration/index', $data);


    }

    public function get_latest_info() {
        $info = $this->CalibrationModel->datainfo();        
        $job_id = 221;
        $echart_data = $this->CalibrationModel->datainfo_search($job_id);

        $temp = $info;
      

        $temp = array_map(function($item) {
            return ['torque' => $item['torque']];
        }, $temp);


        $max_torque = !empty($temp) ? max($temp) : null;
        $min_torque = !empty($temp) ? min($temp) : null;

        
        $tmp = [
            'x_val' => [],
            'y_val' => []
        ];
    
        if (!empty($echart_data)) {
            $tmp['x_val'] = array_column($echart_data, 'id');
            $tmp['y_val'] = array_column($echart_data, 'torque');
        }
    
      
        $combinedData = array(
            'info' => $info,
            'echart_data' => $tmp,
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
    
        // 計算當前 table-calibrations 有幾筆資料 
        $meter = $this->val_traffic();
        if (!empty($meter['res_total'])) {
            $count = count($meter['res_total']);
        } else {
            $count = 0;
        }
    
        // 獲取 cookie 中的 implement_count 的值
        $implement_count = isset($_COOKIE['implement_count']) ? intval($_COOKIE['implement_count']) : 0;
    
        // 計算總數
        $total_count = intval($count) + intval($implement_count);
    
        // 檢查總數是否超過或等於當前計數
       /* if ($total_count >= $count) {
            // 如果未顯示過消息，則顯示並設置標誌
            if (!isset($_SESSION['count_limit_reached'])) {
                echo json_encode(array('success' => false, 'message' => '總計數超過或等於當前計數。操作無法繼續。'));
                $_SESSION['count_limit_reached'] = true; // 設置標誌
                return;
            }
        }*/

        
    
        // 文件路徑
        $file_path = "C:/web/mywebsite.com/imasstg/api/final_val.txt";
    
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
            if (is_numeric($cleanedData)) { 
                $cleanedDataArray[] = $cleanedData;
            }
        }
    
        // 獲取工具序列號
        $tools_sn = $this->CalibrationModel->get_tools_sn();
        
        // 如果清理後的數據數組不為空
        if (!empty($cleanedDataArray)) {
            $lastValue = end($cleanedDataArray); 
            $final = (float)$lastValue; 
            
            // 整理數據
            $res = $this->CalibrationModel->tidy_data($final, $tools_sn);
    
            // 返回整理結果
            if ($res == true) {
                $response = array(
                    'success' => true,
                    'message' => '數據整理成功'
                );
            } else {
                $response = array(
                    'success' => false,
                    'message' => '未找到數據'
                );
            }
            // 刪除文件
            unlink($file_path);
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
                    'message' => 'Data delete success'
                );
            }else{
                $response = array(
                    'success' => false,
                    'message' => 'Data delete fail'
                );
            }
            echo json_encode($response);

        }


    }

    public function del_all(){
        $result = $this->CalibrationModel->del_all();
    }
 
    #產生XML的API
    public function get_xml(){

            $info = $this->CalibrationModel->datainfo();
            $torque_type = $this->CalibrationModel->details('torque');
            $controller_type = $this->CalibrationModel->details('controller');
            $ktm_type = $this->CalibrationModel->details('torquemeter');
    
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
                        $value = $torque_type[$value];
                    }
    
                    if ($key == 'high_percent' ||  $key == 'low_percent') {
                        $value = $value ." % ";
                    }
                    if($key == 'controller_type'){
                        $value = $controller_type[$value];
                    }   
                    if($key == 'ktm_type'){
                        $value = $ktm_type[$value];
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

        $job_arr = $this->CalibrationModel->getjobid();

        #echarts
        $echart_data = $this->CalibrationModel->echarts_data();


        $tools_sn = $this->CalibrationModel->get_tools_sn();

        $meter = $this->val_traffic();

        if(!empty($echart_data)){
            #整理圖表所需要的資料
            $tmp['x_val'] = json_encode(array_column($echart_data, 'id'));
            $tmp['y_val'] = json_encode(array_column($echart_data, 'torque'));

        }

        
        $data = array(
            'isMobile' => $isMobile,
            'nav' => $this->NavsController->get_nav(),
            'res_controller_arr' => $this->CalibrationModel->details('controller'),
            'res_Torquemeter_arr' => $this->CalibrationModel->details('torquemeter'),
            'res_Torquetype' => $this->CalibrationModel->details('torque'),
            'info' => $info,
            'echart'=> $tmp,
            'job_arr' => $job_arr,
            'meter' =>$meter,
            'count' =>count($meter['res_total']),
            'tools_sn' => $tools_sn['device_sn'],
            
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
        
        $input_check = true;
        if (!empty($_POST['job_id']) && isset($_POST['job_id'])) {
            $job_id = $_POST['job_id'];
        } else {
            $input_check = false;
        }
        $job_id = 221;
        
        if($input_check){
            $dataset = $this->CalibrationModel->datainfo_search($job_id);
            if(!empty($dataset)){

                $torque_type = $this->CalibrationModel->details('torque');
                $controller = $this->CalibrationModel->details('controller');
                $ktm = $this->CalibrationModel->details('torquemeter');

                #資料整理 
                foreach($dataset as $key =>$val){
                    $dataset[$key]['unit'] = $torque_type[$val['unit']];
                    $dataset[$key]['high_percent'] = $val['high_percent']."%";
                    $dataset[$key]['low_percent'] = $val['low_percent']."%";
                    $dataset[$key]['controller_type'] = $controller[$val['controller_type']];
                    $dataset[$key]['ktm_type'] = $ktm[$val['ktm_type']];
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


        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        if (isset($data['target_q'], $data['rpm'], $data['joint_offset'])) {

            $controller_ip = $this->EquipmentModel->GetControllerIP(1);
            require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster($controller_ip, "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;

                $data['target_q'] = (int)((float)$data['target_q'] * 100);
      

                $data_targqt_q = array(0,$data['target_q']);
                $data_rpm = array($data['rpm']);
                $data_offset = array($data['joint_offset']);
                $data_job = array(221);

                

                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

                $modbus->writeMultipleRegister(0, 1147, $data_targqt_q, $dataTypes);
                $modbus->writeMultipleRegister(0, 1152, $data_offset, $dataTypes);
                $modbus->writeMultipleRegister(0, 1151, $data_rpm, $dataTypes);
                $modbus->writeMultipleRegister(0, 463, $data_job, $dataTypes);


                echo $modbus->status;
                exit();

            } catch (Exception $e) {
                echo $modbus->status;
                exit();
            }
            

        } else {
          
        }




    }

    public function saveAdapterType() {

        if (session_status() == PHP_SESSION_NONE) {
            session_start(); 
        }
    
        if (isset($_POST['adapter_type'])) {
            $_SESSION['adapter_type'] = $_POST['adapter_type'];
    
            echo json_encode(['success' => true, 'message' => 'Adapter type saved.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid data.']);
        }
    }


    public function saveSessionData() {

        if (session_status() == PHP_SESSION_NONE) {
            session_start(); 
        }
    
        if (isset($_POST['torqueMeter']) && isset($_POST['controller'])) {
            $_SESSION['torqueMeter'] = $_POST['torqueMeter'];
            $_SESSION['controller'] = $_POST['controller'];

            echo json_encode(['success' => true, 'message' => 'Session data saved.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid data.']);
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



    
}