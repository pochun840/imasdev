<?php

class Equipments extends Controller
{
    private $DashboardModel;
    private $NavsController;
    private $EquipmentModel;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->NavsController = $this->controller_new('Navs');
        $this->EquipmentModel = $this->model('Equipment');
        $this->OperationModel = $this->model('Operation');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();

        //有設定的device，讀取目前的設定值來顯示
        $TowerLightSetting = $this->EquipmentModel->GetTowerLightSetting();

        //get com port list
        $comPorts = $this->GetComportList();

        //equipment div view
        $div_add_device_modal = 'equipment/div_add_device_modal';
        $div_arm = 'equipment/div_arm';
        $div_device = 'equipment/div_device';
        $div_picktolight = 'equipment/div_picktolight';
        $div_plc_io = 'equipment/div_plc_io';
        $div_recycle_box = 'equipment/div_recycle_box';
        $div_tower_light = 'equipment/div_tower_light';
        $div_socket_tray = 'equipment/div_socket_tray';
        $div_ktm =  'equipment/div_ktm';
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);
        $tower_light_switch = $this->OperationModel->GetConfigValue('tower_light_switch')['value'];
        $buzzer_switch = $this->OperationModel->GetConfigValue('buzzer_switch')['value'];



        

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'TowerLightSetting' => $TowerLightSetting,
            'div_add_device_modal' => $div_add_device_modal,
            'div_arm' => $div_arm,
            'div_device' => $div_device,
            'div_picktolight' => $div_picktolight,
            'div_plc_io' => $div_plc_io,
            'div_recycle_box' => $div_recycle_box,
            'div_tower_light' => $div_tower_light,
            'div_socket_tray' => $div_socket_tray,
            'div_ktm' => $div_ktm,
            'comPorts' => $comPorts,
            'controller_ip' => $controller_ip,
            'tower_light_switch' => $tower_light_switch,
            'buzzer_switch' => $buzzer_switch
        ];
        
        $this->view('equipment/index', $data);

    }

    public function IO_tes()
    {   
        $data_true = array(true,true);
        $data_false = array(false,false);
        $regiest = 0x04;
        $ledMax = 12;

        if(isset($_GET['pin0']) ){
            $pin0 = boolval($_GET['pin0']);
        }else{
            $pin0 = false;
        }
        if(isset($_GET['pin1']) ){
            $pin1 = boolval($_GET['pin1']);
        }else{
            $pin1 = false;
        }
        if(isset($_GET['pin2']) ){
            $pin2 = boolval($_GET['pin2']);
        }else{
            $pin2 = false;
        }
        if(isset($_GET['pin3']) ){
            $pin3 = boolval($_GET['pin3']);
        }else{
            $pin3 = false;
        }
        if(isset($_GET['pin4']) ){
            $pin4 = boolval($_GET['pin4']);
        }else{
            $pin4 = false;
        }
        if(isset($_GET['pin5']) ){
            $pin5 = boolval($_GET['pin5']);
        }else{
            $pin5 = false;
        }
        if(isset($_GET['pin6']) ){
            $pin6 = boolval($_GET['pin6']);
        }else{
            $pin6 = false;
        }
        if(isset($_GET['pin7']) ){
            $pin7 = boolval($_GET['pin7']);
        }else{
            $pin7 = false;
        }
        if(isset($_GET['pin8']) ){
            $pin8 = boolval($_GET['pin8']);
        }else{
            $pin8 = false;
        }
        if(isset($_GET['pin9']) ){
            $pin9 = boolval($_GET['pin9']);
        }else{
            $pin9 = false;
        }
        if(isset($_GET['pin10']) ){
            $pin10 = boolval($_GET['pin10']);
        }else{
            $pin10 = false;
        }
        if(isset($_GET['pin11']) ){
            $pin11 = boolval($_GET['pin11']);
        }else{
            $pin11 = false;
        }

        $data_true = array($pin0,$pin1,$pin2,$pin3,$pin4,$pin5,$pin6,$pin7,$pin8,$pin9,$pin10,$pin11);
        $data_tt = array(false,false,false,false,false,true,false,false,false,false,false,false);
        $data_false = array(false,false,false,false,false,false,false,false,false,false,false,false);

        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster('192.168.1.75', "TCP");
        try {

            $modbus->port = 502;
            $modbus->timeout_sec = 10;

            $recDate = $modbus->writeMultipleCoils(0,0,$data_true);
            usleep(1000000);// 0.05s
            $recDate = $modbus->writeMultipleCoils(0,0,$data_false);

            echo json_encode($recDate);
            exit();

        } catch (Exception $e) {
            // echo $modbus->status;
            echo json_encode($modbus->status);
            exit();
        }        

    }

    public function TowerLightSetting($value='')
    {
        //看要不要加驗證
        $result = $this->EquipmentModel->SetTowerLight($_POST);

        echo json_encode($result);
        exit();
    }

    public function TowerLightTest($value='')
    {   
        $TowerLightSetting = $this->EquipmentModel->GetTowerLightSetting();
        $IO = $this->EquipmentModel->GetIOPinSetting();
        //var_dump($IO);

        if(isset($_GET['light_signal']) ){
            $light_signal = $_GET['light_signal'];
        }else{
            $light_signal = false;
        }
        if(isset($_GET['red_light']) ){
            $red_light = $_GET['red_light'];
        }else{
            $red_light = false;
        }
        if(isset($_GET['green_light']) ){
            $green_light = $_GET['green_light'];
        }else{
            $green_light = false;
        }
        if(isset($_GET['yellow_light']) ){
            $yellow_light = $_GET['yellow_light'];
        }else{
            $yellow_light = false;
        }
        if(isset($_GET['buzzer']) ){
            $buzzer = $_GET['buzzer'];
        }else{
            $buzzer = false;
        }

        if($light_signal){

            $post['light_signal'] = $light_signal;
            $post['IO'] = $IO;
            $post['TowerLightSetting'] = $TowerLightSetting;
            $post['red_light'] = $red_light;
            $post['green_light'] = $green_light;
            $post['yellow_light'] = $yellow_light;
            $post['buzzer'] = $buzzer;

            $url_split = explode('/',$_SERVER['PHP_SELF']);
            
            $url = $_SERVER['REQUEST_SCHEME'].'://'. $_SERVER['SERVER_NAME'].'/'.$url_split[1].'/api/set_io_signal.php';
         

            $curl = curl_init();
            // $post['test'] = 'examples daata'; // our data todo in received
            // $post['IO'] = $IO;
            curl_setopt($curl, CURLOPT_URL, $url);
            curl_setopt ($curl, CURLOPT_POST, TRUE);
            curl_setopt ($curl, CURLOPT_POSTFIELDS, json_encode($post));
            curl_setopt( $curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));

            curl_setopt($curl, CURLOPT_USERAGENT, 'api');

            // curl_setopt($curl, CURLOPT_TIMEOUT, 1); //if your connect is longer than 1s it lose data in POST better is finish script in recevie
            curl_setopt($curl, CURLOPT_HEADER, 0);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_FORBID_REUSE, true);
            curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 1);
            curl_setopt($curl, CURLOPT_DNS_CACHE_TIMEOUT, 100);
            curl_setopt($curl, CURLOPT_NOSIGNAL, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT_MS, 50000);

            curl_setopt($curl, CURLOPT_FRESH_CONNECT, true);

            $ee = curl_exec($curl);
            //curl_exec($curl);
            curl_close($curl);

            if($ee){
                echo json_encode(array('result' => true));
                exit();
            }else{
                echo json_encode(array('result' => false));
                exit();
            }

            // echo json_encode(array('result' => true));
            // exit();

        }

        echo json_encode(array('result' =>''));
        exit();

    }


    public function GetComportList($value='')
    {
        $output = shell_exec('mode | findstr COM');
        $lines = explode("\n", $output);
        $comPorts = [];
        foreach ($lines as $line) {
            // print_r( mb_detect_encoding($line) );
            $line = mb_convert_encoding($line,"UTF-8","BIG5");
            $comPort = preg_replace('/[^A-Za-z0-9]/', '', $line); // 移除所有非字母、非數字及非冒號(:)的字符
            if (!empty($comPort)) {
                $comPort = str_replace('Statusfordevice','',$comPort);
                $comPorts[] = $comPort;
            }
        }
        return $comPorts;
    }

    public function ArmService()
    {
        if (isset($_POST['action'])) {
            $action = $_POST['action'];
        }else{
            echo json_encode(array('result' =>''));
            exit();
        }

        $port = 9527;// arm websocket port

        if($action == 'start'){

            $comPort = escapeshellarg($_POST['comport']);
            // $nodeScript = 'C:/Users/User/Desktop/nodejs/project/tt.js';
            $nodeScript = dirname(dirname(dirname(__FILE__))).'/relink.js';

            // 构建命令行
            $cmd = "node $nodeScript $comPort";


            // 打开一个管道以非阻塞模式执行命令
            $process = popen("start /B $cmd", "r");

            // 关闭管道
            pclose($process);

            sleep(3);

            $message = "嘗試開啟服務";
            echo json_encode(array('result' => $message, 'service_status' => 'no'));
            exit();
        }

        if($action == 'stop'){
            $pid = $this->getPidByPort($port);
            if ($pid) {
                exec("taskkill /F /PID $pid", $output, $result);
                // echo "Node.js 服務已關閉\n";
                $message = "服務已關閉";
                $service_status = 'no';
            } else {
                // echo "未能找到 Node.js 服務\n";
                $message = "未能找到服務";
                $service_status = 'no';
            }

            echo json_encode(array('result' => $message, 'service_status' => $service_status));
            exit();
        }

        if($action == 'check'){
            $connection = @fsockopen('localhost', $port);
            if (is_resource($connection)) {
                fclose($connection);
                $message = "服務執行中";
                $service_status = 'yes';
            } else {
                $message = "未能找到服務";
                $service_status = 'no';
            }

            echo json_encode(array('result' => $message, 'service_status' => $service_status));
            exit();
        }


        echo json_encode(array('result' =>''));
        exit();
    }

    public function getPidByPort($port) 
    {
        $command = "netstat -ano | findstr :$port";
        exec($command, $output, $result);
        
        foreach ($output as $line) {
            // 查找包含進程 ID 的行
            if (preg_match('/\s+(\d+)$/', $line, $matches)) {
                return $matches[1];
            }
        }
        return null;
    }

    public function SaveControllerIP($value='')
    {
        if (isset($_POST['ip'])) {
            $ip = $_POST['ip'];
        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }

        $result = $this->EquipmentModel->Save_Controller_IP($ip);

        if($result){
            echo json_encode(array('result' =>'', 'service_status' => 'yes'));
            exit();
        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }

    }

    public function DeviceConnectTest($value='')
    {

        if (isset($_POST['ip'])) {
            $ip = $_POST['ip'];
        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }

        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster(trim($ip), "TCP");
        try {

            $modbus->port = 502;
            $modbus->timeout_sec = 2;

            $recDate = $modbus->readMultipleRegisters(0, 4096, 1);

            // echo json_encode($recDate);
            echo json_encode(array('result' => $recDate, 'service_status' => 'yes'));
            exit();

        } catch (Exception $e) {
            // echo $modbus->status;
            // echo json_encode($modbus->status);
            echo json_encode(array('result' => $modbus->status, 'service_status' => 'no'));
            exit();
        }   
    }

    public function SokectTrayTest($value='')
    {
        if (isset($_POST['hole_id'])) {
            $hole_id = $_POST['hole_id'];
        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }

        if (isset($_POST['action'])) {
            $action = $_POST['action'];
        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }



        if($hole_id){

            $post['light_signal'] = 'sockect_hole';
            $post['hole_id'] = $hole_id;
            $post['action'] = $action;
            if ($action == 'clear') {
                $post['light_signal'] = 'clear';
            }
            
            $url_split = explode('/',$_SERVER['PHP_SELF']);
            
            $url = $_SERVER['REQUEST_SCHEME'].'://'. $_SERVER['SERVER_NAME'].'/'.$url_split[1].'/api/set_io_signal.php';

            $curl = curl_init();
            // $post['test'] = 'examples daata'; // our data todo in received
            // $post['IO'] = $IO;
            curl_setopt($curl, CURLOPT_URL, $url);
            curl_setopt ($curl, CURLOPT_POST, TRUE);
            curl_setopt ($curl, CURLOPT_POSTFIELDS, json_encode($post));
            curl_setopt( $curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));

            curl_setopt($curl, CURLOPT_USERAGENT, 'api');

            // curl_setopt($curl, CURLOPT_TIMEOUT, 1); //if your connect is longer than 1s it lose data in POST better is finish script in recevie
            curl_setopt($curl, CURLOPT_HEADER, 0);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, false);
            curl_setopt($curl, CURLOPT_FORBID_REUSE, true);
            curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 1);
            curl_setopt($curl, CURLOPT_DNS_CACHE_TIMEOUT, 100);
            curl_setopt($curl, CURLOPT_NOSIGNAL, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT_MS, 5000);

            curl_setopt($curl, CURLOPT_FRESH_CONNECT, true);

            curl_exec($curl);

            curl_close($curl);

            echo json_encode(array('result' => true, 'service_status' => 'yes'));
            exit();

        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }

    }

    public function LoadControllerSetting($value='')
    {
        if (isset($_POST['ip'])) {
            $ip = $_POST['ip'];
        }else{
            echo json_encode(array('result' =>'', 'service_status' => 'no'));
            exit();
        }

        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster(trim($ip), "TCP");
        try {

            $modbus->port = 502;
            $modbus->timeout_sec = 2;

            $recDate = $modbus->readMultipleRegisters(0, 256, 10);

            $data['device_id'] = $recDate[0] + $recDate[1];
            $data['device_name'] = $recDate[1];
            $letter[1] = chr($recDate[2]*256 + $recDate[3] +65);

            $device_name = '';
            for ($i=0; $i < 7; $i++) { 
                if ( ($recDate[2+$i*2]*256 + $recDate[3+$i*2]) > 0 ) {
                    $device_name = $device_name.dechex($recDate[2+$i*2]*256 + $recDate[3+$i*2]);
                }
            }
            // var_dump($device_name);
            // var_dump(hex2bin($device_name));
            $data['device_name'] = hex2bin($device_name);

            // echo json_encode($recDate);
            echo json_encode(array('result' => $data, 'service_status' => 'yes'));
            exit();

        } catch (Exception $e) {
            // echo $modbus->status;
            // echo json_encode($modbus->status);
            echo json_encode(array('result' => $modbus->status, 'service_status' => 'no'));
            exit();
        }   
    }

    public function ktm_connect() {
        header('Content-Type: application/json'); 
        error_reporting(E_ALL);
        ini_set('display_errors', 1); 
    
        $comPort = escapeshellarg($_POST['comport']);
        $nodeScript = dirname(dirname(dirname(__FILE__))).'/app.js';
    
        // 构建命令行
        $cmd = "node $nodeScript $comPort"; 

        //echo $cmd;die();

        // 打开一个管道以非阻塞模式执行命令
        $process = popen("start /B $cmd", "w");

        // 关闭管道
        pclose($process);

        sleep(3);
    
        $message = "嘗試開啟服務";
        echo json_encode(array('result' => $message, 'service_status' => 'yes'));
        exit();
    }
    

    
}