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


        $skipTurnRev = isset($_COOKIE['skipTurnRev']) ? intval($_COOKIE['skipTurnRev']) : 1;
        

        $avg = $this->CalibrationModel->get_last_record();

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
            'job_arr' => $job_arr,
            'meter' =>$meter,
            'count' =>$count,
            'torque_type ' => $torque_type,
            'tools_sn' => $tools_sn['device_sn'],
            'avg_torque' => $avg_torque,
            'current_torquemeter' => $ktm[$_SESSION['torqueMeter']],
            'user' => $_SESSION['user'],
            'skipTurnRev' => $skipTurnRev
            
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
            'y_val' => []
        ];
    
        if (!empty($echart_data)) {
            $tmp['x_val'] = array_column($echart_data, 'id');
            $tmp['y_val'] = array_column($echart_data, 'torque');
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
        $skipTurnRev = isset($_COOKIE['skipTurnRev']) ? intval($_COOKIE['skipTurnRev']) : 0;


        
    
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
        $tools_sn = $this->CalibrationModel->get_tools_sn();
    
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


            // 删除文件的计数器
            //$unlinkCount = 0;

            if($skipTurnRev == 1){

                // $final  小於 0 
                if ($final < 0) {
                    unlink($file_path);
                    //$unlinkCount++;

                    echo json_encode(array('success123' => false, 'message' => '檔案已刪除，因為 final 值為負'));
                    return; // 終止後續程式動作
                }
            }
            

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


        $input = file_get_contents('php://input');
        $data = json_decode($input, true);
        if (isset($data['target_q'], $data['rpm'], $data['joint_offset'],$data['tolerance'])) {

            $controller_ip = $this->EquipmentModel->GetControllerIP(1);
            require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster($controller_ip, "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;

                $data['target_q'] = (int)((float)$data['target_q'] * 100);

                $percentage = $data['tolerance'] / 100; 

                $lower_limit = $data['target_q']  - ($data['target_q']  * $percentage); //下限
                $upper_limit = $data['target_q']  + ($data['target_q']  * $percentage); // 上限


                //如果 $data['joint_offset'] = +0.02 or -0.06  
                if (preg_match('/([+-]?)(\d*\.?\d+)/', $data['joint_offset'], $matches)) {

                    $sign = $matches[1];   // 取正負號
                    $number = $matches[2]; // 取數字 

                    if( $sign == '+'){
                        $data_sign = array(0);
                    }else{
                        $data_sign = array(1);
                    }

                   
                }

                $number_val = (int)((float) $number * 100);
      

                $data_targqt_q = array(0,$data['target_q']);
                $data_rpm = array($data['rpm']);
                $data_offset = array($number_val);

                $lower_limit_arr = array(0,$lower_limit);
                $upper_limit_arr = array(0,$upper_limit);
                $data_job = array(221);
                $data_open = array(1);
                

                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

                $modbus->writeMultipleRegister(0, 1135, $data_open, $dataTypes); // 進階開啟
                $modbus->writeMultipleRegister(0, 1147, $data_targqt_q, $dataTypes); //目標扭力
                $modbus->writeMultipleRegister(0, 1151, $data_rpm, $dataTypes); //轉速
                $modbus->writeMultipleRegister(0, 1152, $data_sign, $dataTypes); //補償值
                $modbus->writeMultipleRegister(0, 1153, $data_offset, $dataTypes); //補償值(只有數值)
                $modbus->writeMultipleRegister(0, 1155, $upper_limit_arr, $dataTypes); //上限
                $modbus->writeMultipleRegister(0, 1157, $lower_limit_arr, $dataTypes); //下限
                $modbus->writeMultipleRegister(0, 463, $data_job, $dataTypes); //切換job


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
            
            // 清理不必要的 Session 資料，避免 Session 資料過多
            /*if (isset($_SESSION['torqueMeter'])) {
                unset($_SESSION['torqueMeter']);
            }
            if (isset($_SESSION['controller'])) {
                unset($_SESSION['controller']);
            }*/
            
            echo "ewewwe";

            $_SESSION['torqueMeter'] = $_POST['torqueMeter'];
            $_SESSION['controller'] = $_POST['controller'];
    
            //$this->cleanupSessionData();
    
            echo json_encode(['success' => true, 'message' => 'Session data saved and cleaned up.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'empty data.']);
        }
    }
    
    // 自動清理 Session 資料的函數
    private function cleanupSessionData() {
        // 如果 Session 中的資料超過某個條件，可以進行清理
        // 這裡舉例為清理存儲時間過長的資料
        if (isset($_SESSION['lastActivity']) && (time() - $_SESSION['lastActivity']) > 1800) {  // 超過 30 分鐘
            // 若資料超過 30 分鐘未更新，則清除 Session 資料
            session_unset();
            session_destroy();
            echo json_encode(['success' => false, 'message' => 'Session expired and cleaned up.']);
            exit();
        }
    
        // 更新最後活動時間
        $_SESSION['lastActivity'] = time();
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
            echo "eewe";
        }
        
        // 输出 session 值
        if (isset($_SESSION['skipTurnRev'])) {
            echo "Current session value: " . $_SESSION['skipTurnRev'];
        }
    }



    
}