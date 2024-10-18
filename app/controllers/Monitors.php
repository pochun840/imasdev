<?php

class Monitors extends Controller
{
    private $DashboardModel;
    private $MonitorModel;
    private $OperationModel;
    private $NavsController;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->MonitorModel = $this->model('Monitor');
        $this->OperationModel = $this->model('Operation');
        $this->NavsController = $this->controller_new('Navs');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $div_monitor = 'monitor/div_monitor';
        $div_station = 'monitor/div_station';
        $div_rule = 'monitor/div_rule';

        $monitor_server_ip = $this->OperationModel->GetConfigValue('monitor_server_ip');

        $monitor_result = $this->MonitorModel->GetMonitorRow();
        $monitor_rows = [];//預處理monitor row
        foreach ($monitor_result as $key => $value) {
            $monitor_rows[$value['row']][] = $value;
        }

        // var_dump($monitor_rows);

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'div_monitor' => $div_monitor,
            'div_station' => $div_station,
            'div_rule' => $div_rule,
            'monitor_rows' => $monitor_rows,
            'monitor_server_ip' => $monitor_server_ip['value'],
        ];
        $this->view('monitor/index', $data);

    }

    public function EditMonitorElement($value='')
    {
        $input_check = true;
        $error_message = '';
        $data_array = array();
        if( !empty($_POST['mode']) && isset($_POST['mode']) ){
            $data_array['mode'] = $_POST['mode'];
        }else{ 
            $input_check = false;
            $error_message .= "mode,";
        }
        if( !empty($_POST['station_name']) && isset($_POST['station_name']) ){
            $data_array['station_name'] = $_POST['station_name'];
        }else{ 
            $input_check = false;
            $error_message .= "station_name,";
        }
        if( !empty($_POST['station_ip']) && isset($_POST['station_ip']) ){
            $data_array['station_ip'] = $_POST['station_ip'];
        }else{ 
            $input_check = false;
            $error_message .= "station_ip,";
        }
        if( !empty($_POST['station_operators']) && isset($_POST['station_operators']) ){
            $data_array['station_operators'] = $_POST['station_operators'];
        }else{ 
            $data_array['station_operators'] = '';
        }
        if( !empty($_POST['station_jobs']) && isset($_POST['station_jobs']) ){
            $data_array['station_jobs'] = $_POST['station_jobs'];
        }else{ 
            $data_array['station_jobs'] = '';
        }
        if( !empty($_POST['station_row']) && isset($_POST['station_row']) ){
            $data_array['station_row'] = $_POST['station_row'];
        }else{ 
            $input_check = false;
            $error_message .= "station_row,";
        }
        if( !empty($_POST['station_position']) && isset($_POST['station_position']) ){
            $data_array['station_position'] = $_POST['station_position'];
        }else{ 
            $input_check = false;
            $error_message .= "station_position,";
        }
        if( !empty($_POST['station_id']) && isset($_POST['station_id']) ){
            $data_array['station_id'] = $_POST['station_id'];
        }else{ 
            $data_array['station_id'] = '';
        }


        if ($input_check) {
            $jobs = $this->MonitorModel->editMonitor($data_array);
        }

        echo json_encode(array('error' => $error_message));
        exit();


    }

    public function DeleteMonitorElement($value='')
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['station_id']) && isset($_POST['station_id']) ){
            $station_id = $_POST['station_id'];
        }else{ 
            $input_check = false;
            $error_message .= "station_id,";
        }

        if ($input_check) {
            $jobs = $this->MonitorModel->deleteMonitor($station_id);
        }

        echo json_encode(array('error' => $error_message));
        exit();
    }

    public function GetMonitorInfo($value='')
    {
        header('Access-Control-Allow-Origin: *');//避免CROS
        $input_check = true;
        $error_message = '';
        // if( !empty($_POST['station_id']) && isset($_POST['station_id']) ){
        //     $station_id = $_POST['station_id'];
        // }else{ 
        //     // $input_check = false;
        //     $error_message .= "station_id,";
        // }

        if ($input_check) {
            $users = $this->MonitorModel->getUsersList();
            $jobs = $this->MonitorModel->getJobList();

            $result = array();
            $result['users'] = $users;
            $result['jobs'] = $jobs;
            $result['error'] = '';

            echo json_encode($result);
            exit();
        }else{
            echo json_encode(array('result' => '', 'error' => $error_message));
            exit();
        }

    }

    public function MonitorService()
    {
        if (isset($_POST['action'])) {
            $action = $_POST['action'];
        }else{
            echo json_encode(array('result' =>''));
            exit();
        }

        $message = '';
        $port = 3000;// monitor server websocket port

        if($action == 'start'){

            //開啟server
            $pidFile = '..\node_pid_server.txt';
            if (file_exists($pidFile)) { //先kill再開啟，避免重複開啟
                $pid = file_get_contents($pidFile);
                exec("taskkill /F /PID $pid", $output, $result);
                sleep(1);
            }

            $nodeScript = dirname(dirname(dirname(__FILE__))).'/monitor_server.js';
            // 构建命令行
            $cmd = "node $nodeScript";
            // 打开一个管道以非阻塞模式执行命令
            pclose(popen("start /B $cmd", "w"));
            
            sleep(1);

            $pidFile = '..\node_pid_client.txt';
            if (file_exists($pidFile)) { //先kill再開啟，避免重複開啟
                $pid = file_get_contents($pidFile);
                exec("taskkill /F /PID $pid", $output, $result);
                sleep(1);
            }
            $nodeScript = dirname(dirname(dirname(__FILE__))).'\monitor_client.js';
            // 构建命令行
            $cmd = "node $nodeScript";
            // 打开一个管道以非阻塞模式执行命令
            pclose(popen("start /B $cmd", "w"));

            sleep(1);

            $message = "嘗試開啟服務";
            echo json_encode(array('result' => $message, 'service_status' => 'no'));
            exit();
        }

        if($action == 'stop'){
            // $pid = $this->getPidByPort($port);
            $message = '';
            $service_status = '';
            $pidFile = '..\node_pid_server.txt';
            if (file_exists($pidFile)) {
                $pid = file_get_contents($pidFile);
                // echo "Node process PID: $pid";
                exec("taskkill /F /PID $pid", $output, $result);
                $message .= $result;
                exec("tasklist | findstr $pid", $output, $result);
                if(empty($output)){
                    $message = '服務已關閉';
                }
            } else {
                echo "PID file not found.";
            }

            $pidFile = '..\node_pid_client.txt';
            if (file_exists($pidFile)) {
                $pid = file_get_contents($pidFile);
                // echo "Node client process PID: $pid";
                exec("taskkill /F /PID $pid", $output, $result);
                $message .= $result;
                exec("tasklist | findstr $pid", $output, $result);
                if(empty($output)){
                    var_dump(empty($output));
                    $message = '服務已關閉';
                }
            } else {
                echo "PID file not found.";
            }
            sleep(2);

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

            // $pidFile = '..\node_pid_client.txt';
            // if (file_exists($pidFile)) {
            //     $pid = file_get_contents($pidFile);
            //     // echo "Node client process PID: $pid";
            //     exec("tasklist | findstr $pid", $output, $result);
            //     var_dump($output);
            //     var_dump($result);
            //     $message .= $result;
            // }

            echo json_encode(array('result' => $message, 'service_status' => $service_status));
            exit();
        }


        echo json_encode(array('result' =>''));
        exit();
    }

    public function getPidByPort($port) 
    {
        $port = 3000;
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

    public function SaveMonitorServerIp($value='')
    {
        $input_check = true;
        $error_message = '';
        $data_array = array();
        if( !empty($_POST['server_ip']) && isset($_POST['server_ip']) ){
            $data_array['server_ip'] = $_POST['server_ip'];
        }else{ 
            $input_check = false;
            $error_message .= "server_ip,";
        }

        if ($input_check) {
            $this->OperationModel->SetConfigValue('monitor_server_ip',$data_array['server_ip']);
        }

        echo json_encode(array('error' => $error_message));
        exit();
    }
    
}