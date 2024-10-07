<?php

class Operations extends Controller
{
    private $OperationModel;
    private $ProductModel;
    private $SequenceModel;
    private $TaskModel;
    private $NavsController;
    private $EquipmentModel;
    private $NavModel;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->OperationModel = $this->model('Operation');
        $this->ProductModel = $this->model('Product');
        $this->SequenceModel = $this->model('Sequence');
        $this->TaskModel = $this->model('Task');
        $this->NavsController = $this->controller_new('Navs');
        $this->EquipmentModel = $this->model('Equipment');
        $this->NavModel = $this->model('Nav');
    }

    // 取得所有Jobs
    public function index(){


        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        $current_job_id = $this->OperationModel->GetConfigValue('current_job_id');
        $job_data = $this->ProductModel->getJobById($current_job_id['value']);

        
        if($current_job_id['value'] == "0"  || $job_data == false ){

            //echo "eewwere";die();

            $job_list = $this->ProductModel->getJobs();
            $data = array('nav' => $nav,'job_list' => $job_list);
            $this->view('operation/index_empty',$data);
            exit();
        }

        $current_seq_id = $this->OperationModel->GetConfigValue('current_seq_id');
        $current_task_id = $this->OperationModel->GetConfigValue('current_task_id');
        //透過上述3個參數 顯示進入Operation畫面所帶入的資料
        //每完成一個就會更新


        $job_data = $this->ProductModel->getJobById($current_job_id['value']);
        $seq_data = $this->SequenceModel->GetSeqById($current_job_id['value'],$current_seq_id['value']);
        $seq_list = $this->OperationModel->getSequencesEnable($current_job_id['value']);
        $task_program = $this->TaskModel->GetTaskProgram($current_job_id['value'],$current_seq_id['value'],$current_task_id['value']);//調整
        $task_list = $this->TaskModel->getTasks($current_job_id['value'],$current_seq_id['value']);
        //task_message
        $task_message_list = $this->OperationModel->Get_task_message($current_job_id,$current_seq_id);
        if(!empty($task_message_list)){
            $temp =array();
            foreach($task_message_list  as $jj => $vv){
                $temp[$vv['task_id']]= $task_message_list[$jj];
            }

        }else{
            $task_message_list = '';
        }
        
        //get total seq
      
        $total_seq = $this->SequenceModel->getSequences_enable($current_job_id['value']);
        if(!empty($total_seq)){
            $total_seq_count = count($total_seq);
        }else{
            $total_seq_count = 0;
        }
        
        $job_list = $this->ProductModel->getJobs();
        //預處理task_list


        foreach ($task_list as $key => $value) {
            if( isset($value['program'][0]) ){
                $task_list[$key]['last_job_type'] = 'advanced';
                $task_list[$key]['last_targettype'] = $value['program'][array_key_last($value['program'])]['step_targettype'];
                $task_list[$key]['last_step_targetangle'] = $value['program'][array_key_last($value['program'])]['step_targetangle'];
                $task_list[$key]['last_step_highangle'] = $value['program'][array_key_last($value['program'])]['step_highangle'];
                $task_list[$key]['last_step_lowangle'] = $value['program'][array_key_last($value['program'])]['step_lowangle'];
                $task_list[$key]['last_step_targettorque'] = $value['program'][array_key_last($value['program'])]['step_targettorque'];
                $task_list[$key]['last_step_hightorque'] = $value['program'][array_key_last($value['program'])]['step_hightorque'];
                $task_list[$key]['last_step_lowtorque'] = $value['program'][array_key_last($value['program'])]['step_lowtorque'];
                $task_list[$key]['last_step_name'] = $value['program'][array_key_last($value['program'])]['step_name'];
                $task_list[$key]['last_step_count'] = count($value['program']);
                $task_list[$key]['gtcs_job_id'] = $value['program'][array_key_last($value['program'])]['gtcs_job_id'];

                //hi lo 直接改 0:window 1:hi-lo
                if($value['program'][array_key_last($value['program'])]['step_monitoringmode'] == 0){
                    $task_list[$key]['last_step_hightorque'] = $value['program'][array_key_last($value['program'])]['step_torwin_target'] + $value['program'][array_key_last($value['program'])]['step_torquewindow'];
                    $task_list[$key]['last_step_lowtorque'] = $value['program'][array_key_last($value['program'])]['step_torwin_target'] - $value['program'][array_key_last($value['program'])]['step_torquewindow'];
                    $task_list[$key]['last_step_highangle'] = $value['program'][array_key_last($value['program'])]['step_angwin_target'] + $value['program'][array_key_last($value['program'])]['step_anglewindow'];
                    $task_list[$key]['last_step_lowangle'] = $value['program'][array_key_last($value['program'])]['step_angwin_target'] + $value['program'][array_key_last($value['program'])]['step_anglewindow'];
                }
            }else{
                $task_list[$key]['last_job_type'] = 'normal';
                $last_targettype = $value['program']['step_targettype'] ?? 'default_value';
                $task_list[$key]['last_targettype'] = $last_targettype;

                $last_step_targetangle = $value['program']['step_targetangle'] ?? 'default_value';
                $task_list[$key]['last_step_targetangle'] = $last_step_targetangle;

                $task_list[$key]['last_step_targetangle'] = $value['program']['step_targetangle'] ?? null;
                $task_list[$key]['last_step_highangle'] = $value['program']['step_highangle'] ?? null;
                $task_list[$key]['last_step_lowangle'] = $value['program']['step_lowangle'] ?? null;
                $task_list[$key]['last_step_targettorque'] = $value['program']['step_targettorque'] ?? null;
                $task_list[$key]['last_step_hightorque'] = $value['program']['step_hightorque'] ?? null;
                $task_list[$key]['last_step_lowtorque'] = $value['program']['step_lowtorque'] ?? null;
                $task_list[$key]['last_step_name'] = $value['program']['step_name'] ?? null;
                $task_list[$key]['last_step_count'] = 1;
                $task_list[$key]['gtcs_job_id'] = $value['program']['gtcs_job_id'] ?? null;
            }     
        }

        $task_count = count($task_list);

        //建立button權限
        $button_auth = array();
        $button_auth['switch_next_seq'] = $this->OperationModel->GetConfigValue('auth_skip')['value'];
        $button_auth['switch_previous_seq'] = $this->OperationModel->GetConfigValue('auth_back')['value'];
        $button_auth['task_reset'] = $this->OperationModel->GetConfigValue('auth_task_reset')['value'];
        $button_auth['switch_job'] = $this->OperationModel->GetConfigValue('auth_job_change')['value'];
        $button_auth['switch_seq'] = $this->OperationModel->GetConfigValue('auth_seq_change')['value'];
        $button_auth['stop_on_ng'] = $this->OperationModel->GetConfigValue('stop_on_ng')['value'];
        $button_auth['auto_switch'] = $this->OperationModel->GetConfigValue('auto_switch')['value'];
        $button_auth['tower_light_switch'] = $this->OperationModel->GetConfigValue('tower_light_switch')['value'];
        $button_auth['buzzer_switch'] = $this->OperationModel->GetConfigValue('buzzer_switch')['value'];
        $button_auth['role_checked'] = $this->OperationModel->GetConfigValue('manger_verify')['value'];
        $button_auth['gender_switch'] = $this->OperationModel->GetConfigValue('gender_switch')['value'];
        $button_auth['role_checked'] = explode(",",$button_auth['role_checked']);//轉換成array 方便用in_array判斷


        //整理出 auto 播放語音檔案
     
        if( $_SESSION['language'] != '' && $button_auth['gender_switch'] != ''){
            
     
            //利用 當前語系 && 人聲 取出相符的語音檔 
            $directory = '../public/voice'; 

            $gender_switch = $button_auth['gender_switch'] == "0" ? "Male" : "Female";
            $language_setting = $_SESSION['language'];

            if (!empty($language_setting) && !empty($gender_switch)) {

                    $folder_path = $directory;
                    // 检查目錄是否存在
                    if (is_dir($folder_path)) {
                        $filtered_files = array();
                        $files = scandir($folder_path);
                        $files = array_diff($files, array('.', '..'));
                        //找出檔名的正規劃
                        $pattern = '/.*' . preg_quote($language_setting, '/') . '.*' . preg_quote($gender_switch, '/') . '.*/i';
                        $filtered_files = array_filter($files, function($file) use ($pattern) {
                            return preg_match($pattern, $file);
                        });

                        
                    } else {
                        $filtered_files = '';
                    }
                }
       

                if(!empty($filtered_files)){
                    $filtered_files_updated = array();
                    foreach ($filtered_files as $key => $value) {
                        if (strpos($value, $gender_switch) !== false) {
                            $filtered_files_updated[$key] = $value;
                        }
                    }

                }
               
              
        }

        // GetRoleIdByAccount
        $account = $_SESSION['user'];

        $role_id = $this->NavModel->GetRoleIdByAccount($account);
        if( !in_array($role_id,$button_auth['role_checked']) ){
            foreach ($button_auth as $key => $value) {
                $button_auth[$key] = 0;
            }
        }

        if ($role_id == 1) {
            foreach ($button_auth as $key => $value) {
                $button_auth[$key] = 1;
            }
        }


        if(!empty($seq_list)){
            $temp_seq = array();
            $key = 1;
            foreach( $seq_list as $kv =>$va){
                $temp_seq[$key] = $va; 
                $key++;
            }
        }else{
            $temp_seq = '';
        }
      

        // $barcode = @$_SESSION['barcode'];
        $barcode = @$_COOKIE['barcode'];
        // unset($_SESSION['barcode']);
        setcookie('barcode', '', time() - 3600, '/');

        $last_sn = $this->GetControllerLastSn();
   
        if (!empty($temp)) {
            //$data['task_message_list'] = $temp;
            $jsonTaskMessageList = json_encode($temp);

        }else{
            $temp = '';
            $jsonTaskMessageList = '';
        }

        #利用正規劃 處理語音檔
        $filtered_files = $filtered_files_updated;
        if(!empty($filtered_files)){
          
           
            $ng_auto = 'ng-'.$language_setting."-".$gender_switch;
            $ok_auto = 'ok-'.$language_setting."-".$gender_switch;
            $ok_job_auto = 'ok-job-'.$language_setting."-".$gender_switch;
            $ok_seq_auto = 'ok-seq-'.$language_setting."-".$gender_switch;

            $ok_auto_path = $directory . '/' . $ok_auto.".mp3";
            $ng_auto_path = $directory . '/' . $ng_auto.".mp3";
            $ok_seq_auto_path = $directory . '/' . $ok_seq_auto.".mp3";
            $ok_job_auto_path = $directory . '/' . $ok_job_auto.".mp3";
            
       
            if (file_exists($ok_auto_path)) {
                $ok_auto_new = $ok_auto.".mp3";
            }else{
                $ok_auto_new = '';
            }

            if (file_exists($ng_auto_path)) {
                $ng_auto_new = $ng_auto.".mp3";
            }else{
                $ng_auto_new = '';
            }

            if (file_exists($ok_seq_auto_path)) {
                $ok_seq_auto_new = $ok_seq_auto.".mp3";
            }else{
                $ok_seq_auto_new  = '';
            }
            if (file_exists($ok_job_auto_path)) {
                $ok_job_auto_new =$ok_job_auto.".mp3";
            }else{
                $ok_job_auto_new  = '';
            }


        }


        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'job_id' => $current_job_id['value'],
            'seq_id' => $current_seq_id['value'],
            'task_id' => $current_task_id['value'],
            'job_data' => $job_data,
            'job_list' => $job_list,
            'seq_data' => $seq_data,
            'seq_list' => $seq_list,
            'total_seq' => $total_seq_count,
            'seq_img' => @$seq_data['img'],
            'task_program' => $task_program,
            'task_list' => $task_list,
            'task_count' => $task_count,
            'button_auth' => $button_auth,
            'barcode' => $barcode,
            'controller_ip' => $controller_ip,
            'max_seq_id' => @$total_seq[array_key_last($total_seq)]['seq_id'],
            'seq_count' => $total_seq_count,
            'new_seq_list' => $temp_seq,
            'last_sn' => $last_sn,
            'task_message_list' => $temp,
            'jsonTaskMessageList' => $jsonTaskMessageList,
            'ng_auto' => $ng_auto_new,
            'ok_auto' => $ok_auto_new,
            'ok_job_auto' =>$ok_job_auto_new,
            'ok_seq_auto' => $ok_seq_auto_new,
            
            
        ];
    
        $this->view('operation/index', $data);

    }

    public function Call_Controller_Job()
    {
        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        $input_check = true;
        $error_message = '';
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "job_id,";
        }

        if ($input_check) {
            require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster($controller_ip, "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;
                $data = array($job_id);
                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");
                
                // FC 16
                $test = array(0);
                $test1 = array(1);
                $modbus->writeMultipleRegister(0, 461, $test, $dataTypes);//起子禁用
                $modbus->writeMultipleRegister(0, 463, $data, $dataTypes);//切換job
                $modbus->writeMultipleRegister(0, 461, $test1, $dataTypes);//起子啟用
                // $this->logMessage('modbus write 506 ,array = '.implode("','", $data));
                // $this->logMessage('modbus status:'.$modbus->status);
                // $this->logMessage('Import config end');
                // echo json_encode(array('error' => ''));
                echo $modbus->status;
                exit();

            } catch (Exception $e) {
                // Print error information if any
                // echo $modbus;
                // echo '<br>123';
                // echo $e;
                // echo '<br>456';
                // $this->logMessage('modbus write 506 fail');
                // $this->logMessage('modbus status:'.$modbus->status);
                // $this->logMessage('Import config end');
                // echo json_encode(array('error' => 'modbus error'));
                echo $modbus->status;
                exit();
            }
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

        echo json_encode($job_detail);
        exit();
        
    }

    public function Change_Job()
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "job_id,";
        }
        if( !empty($_POST['seq_id']) && isset($_POST['seq_id'])  ){
            $seq_id = $_POST['seq_id'];
        }else{ 
            $input_check = false;
            $error_message .= "seq_id,";
        }
        if( !empty($_POST['task_id']) && isset($_POST['task_id'])  ){
            $task_id = $_POST['task_id'];
        }else{ 
            $task_id = 1;
        }
        if( !empty($_POST['direction']) && isset($_POST['direction'])  ){
            $direction = $_POST['direction'];
        }else{ 
            $direction = '';
        }

        if ($input_check) {
            $enable_seq_list = $this->OperationModel->GetSeqEnable($job_id);
            if($enable_seq_list[$seq_id-1]['sequence_enable'] == 1 ){
                $current_job_id = $this->OperationModel->SetConfigValue('current_job_id',$job_id);
                $current_job_id = $this->OperationModel->SetConfigValue('current_seq_id',$seq_id);
                $current_job_id = $this->OperationModel->SetConfigValue('current_task_id',$task_id);
                echo json_encode(array('error' => $error_message));
                exit();
            }else{

                if($direction == 'next'){
                    for ($i=$seq_id; $i < count($enable_seq_list); $i++) { 
                        if($enable_seq_list[$i]['sequence_enable'] == 1){
                            $seq_id = $enable_seq_list[$i]['seq_id'];
                            break;
                        }
                    }
                }
  

                if($direction == 'previous'){
                    for ($i=$seq_id-1; $i >= 0; $i--) { 
                        if($enable_seq_list[$i]['sequence_enable'] == 1){
                            $seq_id = $enable_seq_list[$i]['seq_id'];
                            break;
                        }
                    }
                }

    
                $current_job_id = $this->OperationModel->SetConfigValue('current_job_id',$job_id);
                $current_job_id = $this->OperationModel->SetConfigValue('current_seq_id',$seq_id);
                $current_job_id = $this->OperationModel->SetConfigValue('current_task_id',$task_id);
                echo json_encode(array('error' => $error_message));
                exit();

            }

    
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }
        
    }

    public function ToolStatusCheck()
    {
        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        $error_message = '';
        if (true) {
            require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster($controller_ip, "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;
                // $data = array($job_id);
                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

                // FC 16
                $data = $modbus->readMultipleRegisters(0, 4345, 1);
               
                echo json_encode(array('result' => $data[1],'error' => $error_message));
                exit();

            } catch (Exception $e) {
                
                echo json_encode(array('error' => $modbus->status));
                exit();
            }
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

        // echo json_encode($job_detail);
        echo json_encode(array('error' => $error_message));
        exit();
    }

    public function Switch_Tool_Status()
    {
        $input_check = true;
        $error_message = '';
        if( isset($_POST['tool_status']) ){
            $tool_status = $_POST['tool_status'];
        }else{ 
            $input_check = false;
            $error_message .= "tool_status,";
        }

        // var_dump($tool_status);

        // $tool_status = 1;

        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        if ($input_check) {
            require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster($controller_ip, "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;
                $data = array($tool_status);
                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

                // FC 16
                $data = $modbus->writeMultipleRegister(0, 461, $data, $dataTypes);
                // $this->logMessage('modbus write 506 ,array = '.implode("','", $data));
                // $this->logMessage('modbus status:'.$modbus->status);
                // $this->logMessage('Import config end');
                // echo json_encode(array('error' => ''));
                // echo $modbus->status;
                // var_dump($data);
                echo json_encode(array('result' => $data,'error' => $error_message));
                exit();

            } catch (Exception $e) {
                echo $modbus->status;
                exit();
            }
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }
        
    }

    public function Get_IO_Signal($value='')
    {   
        $error_message = '';
        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
            $modbus = new ModbusMaster('192.168.1.75', "TCP");
            try {
                $modbus->port = 502;
                $modbus->timeout_sec = 10;
                // $data = array($tool_status);
                $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

                // FC 2
                $data = $modbus->readInputDiscretes(0, 0, 16);
                // var_dump($data);
                echo json_encode(array('result' => $data,'error' => $error_message));
                exit();
            } catch (Exception $e) {
                echo $modbus->status;
                exit();
            }
    }

    public function Set_IO_Signal($value='')
    {   
        $data_true = array(true,true);
        $data_false = array(false,false);
        $regiest = 0x04;
        $ledMax = 12;
        $TowerLightSetting = $this->EquipmentModel->GetTowerLightSetting();
        $IO = $this->EquipmentModel->GetIOPinSetting();


        if(isset($_GET['light_signal']) ){
            $light_signal = $_GET['light_signal'];
        }else{
            $light_signal = false;
        }

        if($light_signal){

            $post['light_signal'] = $light_signal;
            $post['IO'] = $IO;
            $post['TowerLightSetting'] = $TowerLightSetting;

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
            curl_setopt($curl, CURLOPT_TIMEOUT_MS, 50);

            curl_setopt($curl, CURLOPT_FRESH_CONNECT, true);

            curl_exec($curl);

            curl_close($curl);

        }

    }

    public function Save_Result()
    {
      
        $data = $_GET['data'];
    
        if (!is_array($data)) {
            echo json_encode(['error' => 'Invalid data format']);
            return;
        }
    
        // 尝试将数据保存到 fasten_data 表中
        try {
            $system_no = $this->OperationModel->SaveFastenData($data);
            //setcookie('system_no', $system_no, time() + 3600, '/');

            echo json_encode(['system_no' => $system_no]);
            $this->SaveFastenDataLog($data['system_sn']);
        } catch (Exception $e) {
          
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function update_status(){
        if(!empty($_GET['sysem_no'])){
            $system_no = $_GET['sysem_no'];
        }else{
            $input_check = false;
        }

        
        if(!empty($_GET['new_status'])){
            $new_status = $_GET['new_status'];
        }else{
            $input_check = false;
        }
        
        //var_dump($_GET);die();
        if($input_check){
            $system_no = $this->OperationModel->update_type($system_no,$new_status);
        }
    }



    public function SaveFastenDataLog($system_sn)
    {
        $file_arr = array('_0p5','_1p0','_2p0');#檔案格式

        $filename = 'DATALOG_'.str_pad($system_sn,10,"0",STR_PAD_LEFT);

        $remote_Dir = '/mnt/ramdisk/';   ### 遠端檔案
        $local_Dir = '../public/data/';   ### 本機儲存檔案名稱

        // $handle = fopen($local_file, 'w');

        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        ### 連接的 FTP 伺服器是 localhost
        $conn_id = ftp_connect($controller_ip);

        ### 登入 FTP, 帳號是 USERNAME, 密碼是 PASSWORD
        $USERNAME = 'kls';
        $PASSWORD = '12345678rd';
        $login_result = ftp_login($conn_id, $USERNAME, $PASSWORD);

        $remoteFilePaths = ftp_nlist($conn_id, $remote_Dir);

        foreach ($file_arr as $key => $value) {
            if(in_array( '/mnt/ramdisk/'.$filename.$value.'.csv'  ,$remoteFilePaths)){
                $remote_file = '/mnt/ramdisk/'.$filename.$value.'.csv';
                $local_file = $local_Dir.$filename.$value.'.csv';
                if (ftp_get($conn_id, $local_file, $remote_file, FTP_BINARY)) {
                    echo "下載成功\n";
                } else {
                    echo "下載 $remote_file 到 $local_file 失敗\n";
                }
            }
        }

        ftp_close($conn_id);
        // fclose($handle);
    }

    public function button_auth_check()
    {
        if(isset($_POST['card']) ){
            $card = $_POST['card'];
        }else{
            $card = '';
        }

        if(isset($_POST['action']) ){
            $action = $_POST['action'];
        }else{
            $action = '';
        }

        $result = false;
        $user_data = $this->OperationModel->ButtonAuthCheck($card);
        if($user_data){
            if($user_data['RoleID'] == 1){
                $result = true;
            }
        }else{
            echo json_encode(array('result' => $result));
            exit();
        }
        
        $role_checked = $this->OperationModel->GetConfigValue('manger_verify')['value'];
        $role_checked = explode(",",$role_checked);//轉換成array 方便用in_array判斷



        //action: change_job skip_seq back_seq reset_task
        //auth_skip auth_back auth_task_reset auth_job_change
        switch ($action) {
            case 'change_job':
                $check = $this->OperationModel->GetConfigValue('auth_job_change')['value'];
                break;
            case 'skip_seq':
                $check = $this->OperationModel->GetConfigValue('auth_skip')['value'];
                break;
            case 'back_seq':
                $check = $this->OperationModel->GetConfigValue('auth_back')['value'];
                break;
            case 'reset_task':
                $check = $this->OperationModel->GetConfigValue('auth_task_reset')['value'];
                break;
            case 'stop_on_ng':
                $check = $this->OperationModel->GetConfigValue('stop_on_ng')['value'];
                break;
            case 'change_seq':
                $check = $this->OperationModel->GetConfigValue('auth_seq_change')['value'];
                break;
            default:
                $check = 0;
                break;
        }

        if($check == 1 && in_array($user_data['RoleID'],$role_checked) ){
            $result = true;
        }

        echo json_encode(array('result' => $result));
        exit();
    }

    public function Set_Socket_Hole()
    {
        if( isset($_POST['Socket_Hole']) ){
            $post['light_signal'] = 'sockect_hole';
            $post['hole_id'] = $_POST['hole_id'];
            $url_split = explode('/',$_SERVER['PHP_SELF']);

            $url = $_SERVER['REQUEST_SCHEME'].'://'.$_SERVER['SERVER_NAME'].'/'.$url_split[1].'/api/set_io_signal.php';

            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $url);
            curl_setopt($curl, CURLOPT_POST, TRUE);
            curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post));
            curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));

            curl_setopt($curl, CURLOPT_USERAGENT, 'api');

            // curl_setopt($curl, CURLOPT_TIMEOUT, 1); //if your connect is longer than 1s it lose data in POST better is finish script in recevie
            curl_setopt($curl, CURLOPT_HEADER, 0);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, false);
            curl_setopt($curl, CURLOPT_FORBID_REUSE, true);
            curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 1);
            curl_setopt($curl, CURLOPT_DNS_CACHE_TIMEOUT, 100);
            curl_setopt($curl, CURLOPT_NOSIGNAL, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT_MS, 50);

            curl_setopt($curl, CURLOPT_FRESH_CONNECT, true);

            curl_exec($curl);

            curl_close($curl);
            return json_encode( array('result' => '1') );
        }else{
            return json_encode( array('result' => '0') );    
        }

    }

    public function Get_Socket_Hole()
    {
        if (isset($_GET['hole_id'])) {
            $hole_id = $_GET['hole_id'];
        }else{
            $hole_id = -1;
        }

        /*$check = $this->pingDomain('192.168.1.75',502);
        if($check > 0){

        }else{
            // 可以避免io沒開的時候 會卡很久，但某些機器判斷會有問題 暫時先移除
            echo json_encode(array('result' => 'no con'));
            exit();
        }*/

        //要加先判斷連線是否通，不然會等太久

        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster('192.168.1.75', "TCP");
        try {
            $modbus->port = 502;
            $modbus->timeout_sec = 3;
            // $data = array($tool_status);
            $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

            // FC 2
            $data = $modbus->readInputDiscretes(0, 0, 16);

            $power0 = (int)$data[0]*1;
            $power1 = (int)$data[1]*2;
            $power2 = (int)$data[2]*4;

            $sum = $power0 + $power1 + $power2;

            if($hole_id == $sum){
                echo json_encode(array('result' => 'yes'));
                exit();
            }
            
            echo json_encode(array('result' => 'no'));
            exit();
        } catch (Exception $e) {
            echo json_encode(array('result' => '$modbus->status;'));
            exit();
        }

    }

    public function pingDomain($domain,$port)
    {
        error_reporting(0);
        $starttime = microtime(true);

        try {
          $file = fsockopen ($domain, $port, $errno, $errstr, 0.1);
        } catch (Exception $e) {
          
        }
        $stoptime  = microtime(true);
        $status    = 0;
     
        if (!$file) $status = -1;  // Site is down
        else {
            fclose($file);
            $status = ($stoptime - $starttime) * 1000;
            $status = floor($status);
        }
        return $status;
    }

    // public function pingDomain($domain, $port, $timeout = 1, $retries = 3)
    // {
    //     $starttime = microtime(true);
    //     $status = -1; // 初始化为失败状态

    //     for ($i = 0; $i < $retries; $i++) {
    //         $errno = 0;
    //         $errstr = '';
    //         $connectionString = "tcp://$domain:$port";
            
    //         // 使用 @ 以防止错误信息输出到标准输出
    //         $file = @stream_socket_client($connectionString, $errno, $errstr, $timeout);

    //         if ($file) {
    //             $stoptime = microtime(true);
    //             fclose($file);
    //             $status = ($stoptime - $starttime) * 1000; // 计算响应时间
    //             $status = floor($status);
    //             break; // 成功连接后退出循环
    //         } else {
    //             // 记录错误日志以便调试
    //             echo "Attempt $i: Error $errno - $errstr";
    //             // error_log("Attempt $i: Error $errno - $errstr");
    //         }
    //     }

    //     return $status;
    // }

    public function Barcode_ChangeJob()
    {
        if (isset($_POST['barcode'])) {
            $barcode = $_POST['barcode'];
        }else{
            $barcode = -1;
        }

        $data = $this->OperationModel->BarcodeMatchCheck($barcode);

        if($data){
            // $_SESSION['barcode'] = $barcode;
            setcookie('barcode', $barcode, time() + 60, '/');
            $this->OperationModel->SetConfigValue('current_job_id',$data['barcode_selected_job']);
            $this->OperationModel->SetConfigValue('current_seq_id',$data['barcode_selected_seq']);
            $this->OperationModel->SetConfigValue('current_task_id',1);
            echo json_encode(array('result' => 'yes'));
            exit();
        }else{
            echo json_encode(array('result' => 'no'));
            exit();
        }

    }

    public function GetControllerLastSn($value='')
    {
        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster($controller_ip, "TCP");
        try {
            $modbus->port = 502;
            $modbus->timeout_sec = 3;
            // $data = array($tool_status);
            $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

            // FC 2
            $data = $modbus->readMultipleRegisters(0, 4165, 2);

            $sn = $data[0]*pow(2, 24) + $data[1]*pow(2, 16) + $data[2]*pow(2, 8) + $data[3]*pow(2, 0);

            return $sn;
            // echo json_encode(array('result' => 'no'));
            // exit();
        } catch (Exception $e) {
            // echo json_encode(array('result' => '$modbus->status;'));
            // exit();
            return false;
        }
    }


    private function getFilteredVoiceFiles($button_auth){

        $directory = '../public/voice';
        if (empty($_SESSION['language']) || empty($button_auth['gender_switch'])) {
            return array(); 
        }

        $gender_switch = $button_auth['gender_switch'] == "0" ? "Male" : "Female";
        $language_setting = $_SESSION['language'];
        $filtered_files = array();

        //檢查語言和性別開關否都有值
        if (!empty($language_setting) && !empty($gender_switch)) {
            $folder_path = $directory;

            //检查目錄是否存在
            if (is_dir($folder_path)) {
                $files = scandir($folder_path);
                $files = array_diff($files, array('.', '..'));

                //找出符合語言和性别的檔案
                $pattern = '/.*' . preg_quote($language_setting, '/') . '.*' . preg_quote($gender_switch, '/') . '.*/i';
                $filtered_files = array_filter($files, function($file) use ($pattern) {
                    return preg_match($pattern, $file);
                });

                
                $filtered_files_updated = array();
                foreach ($filtered_files as $key => $value) {
                    if (strpos($value, $gender_switch) !== false) {
                        $filtered_files_updated[$key] = $value;
                    }
                }

                $filtered_files = $filtered_files_updated;
            }
        }


    }



}