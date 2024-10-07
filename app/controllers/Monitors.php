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
    
}