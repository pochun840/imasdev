<?php

class Settings extends Controller
{
    private $ProductModel;
    private $SequenceModel;
    private $SettingModel;
    private $NavsController;
    private $UserModel;
    private $OperationModel;
    private $EquipmentModel;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->ProductModel = $this->model('Product');
        $this->SequenceModel = $this->model('Sequence');
        $this->SettingModel = $this->model('Setting');
        $this->NavsController = $this->controller_new('Navs');
        $this->UserModel = $this->model('User');
        $this->OperationModel = $this->model('Operation');
        $this->EquipmentModel = $this->model('Equipment');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $all_roles = $this->UserModel->GetAllRole();

        $button_auth = array();
        $button_auth['switch_next_seq'] = $this->OperationModel->GetConfigValue('auth_skip')['value'];
        $button_auth['switch_previous_seq'] = $this->OperationModel->GetConfigValue('auth_back')['value'];
        $button_auth['task_reset'] = $this->OperationModel->GetConfigValue('auth_task_reset')['value'];
        $button_auth['switch_job'] = $this->OperationModel->GetConfigValue('auth_job_change')['value'];
        $button_auth['stop_on_ng'] = $this->OperationModel->GetConfigValue('stop_on_ng')['value'];
        $button_auth['switch_seq'] = $this->OperationModel->GetConfigValue('auth_seq_change')['value'];
        $button_auth['role_checked'] = $this->OperationModel->GetConfigValue('manger_verify')['value'];
        $button_auth['auto_switch'] = $this->OperationModel->GetConfigValue('auto_switch')['value'];
        $button_auth['tower_light_switch'] = $this->OperationModel->GetConfigValue('tower_light_switch')['value'];
        $button_auth['buzzer_switch'] = $this->OperationModel->GetConfigValue('buzzer_switch')['value'];
        $button_auth['language_setting'] = $this->OperationModel->GetConfigValue('language_setting')['value'];
        $button_auth['count_method_setting'] = $this->OperationModel->GetConfigValue('count_method_setting')['value'];
        $button_auth['gender_switch'] = $this->OperationModel->GetConfigValue('gender_switch')['value'];
        $button_auth['role_checked'] = explode(",",$button_auth['role_checked']);//轉換成array 方便用in_array判斷


        //語言切換 
        $language = array('zh-cn' => '简中', 'zh-tw' => '繁中', 'en-us' => 'English', 'vi-vn' => 'Tiếng Việt');

        //計數模式
        $count_method = array('0' => 'Inc', '1' => 'Dec');

        //人聲選擇
        $count_gender = array('0' => 'Male', '1' => 'Female');


        //利用 當前語系 && 人聲 取出相符的語音檔 
        $directory = '../public/voice'; 

        $gender_switch = $button_auth['gender_switch'] == "0" ? "Male" : "Female";
        $language_setting = $button_auth['language_setting'];
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
        $filtered_files = $filtered_files_updated;


        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'all_roles' => $all_roles,
            'button_auth' => $button_auth,
            'language_setting' => $language,
            'count_method' => $count_method,
            'count_gender' => $count_gender,
            'filtered_files' => $filtered_files,
        ];

        $this->view('setting/index', $data);

    }

    public function GTCS_DB_SYNC($value='')
    {
        $device_id = '';
        $device_name = '';
        if (isset($_POST['device_id'])) {
            $device_id = $_POST['device_id'];
        }
        if (isset($_POST['device_name'])) {
            $device_name = $_POST['device_name'];
        }

        // code...
        //1.撈出GTCS目前的設定DB tcscon.db
        //2.備份tcscon.db
        //3.清空tcscon.db中job、seq、advancedstep、normalstep、input、output table
        //4.將中控設定寫入db，同時更新對應的資料task id與job id
        //5.將設定完成的db透過ftp的方式匯入GTCS的FTP資料夾
        //6.使用modbus指令 讓GTCS更新DB
        $this->FTP_download();//下載並備份GTCS的db
        $this->clearSQLiteTables();//清空GTCS的db
        $this->CCToGTCS($device_id,$device_name);//將中控的設定寫入GTCS db
        $this->FTP_upload();//上傳寫入完成的GTCS db
        $this->ImportDB();//下modbus讓GTCS匯入db
    }

    public function FTP_download($value='')
    {
        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        $remote_file = '/mnt/ramdisk/tcscon.db';   ### 遠端檔案
        $local_file = '../localfile.db';   ### 本機儲存檔案名稱

        $handle = fopen($local_file, 'w');

        ### 連接的 FTP 伺服器是 localhost
        $conn_id = ftp_connect($controller_ip);

        ### 登入 FTP, 帳號是 USERNAME, 密碼是 PASSWORD
        $USERNAME = 'kls';
        $PASSWORD = '12345678rd';
        $login_result = ftp_login($conn_id, $USERNAME, $PASSWORD);

        // 用ssh2連接
        // $connection = ssh2_connect($controller_ip, 22);
        // ssh2_auth_password($connection, $USERNAME, $PASSWORD);

        // $sftp = ssh2_sftp($connection);
        // $res2 = ssh2_scp_recv($connection, $remote_file, $local_file);
        // end 用ssh2連接


        if (ftp_fget($conn_id, $handle, $remote_file, FTP_ASCII, 0)) {
            echo "下載成功, 並儲存到 $local_file\n";
            if ( copy($local_file,$local_file.'666') ) {
                echo "複製成功, 並儲存到 $local_file SS \n";
            }
        } else {
            echo "下載 $remote_file 到 $local_file 失敗\n";
        }

        ftp_close($conn_id);
        fclose($handle);
    }

    public function FTP_upload($value='')
    {
        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        $ftp_server = $controller_ip;
        $ftp_username = "kls";
        $ftp_password = "12345678rd";

        $local_file = '../localfile.db'; // 本地文件路径
        $remote_file = '/mnt/ramdisk/FTP/cc.cfg'; // 远程文件路径

        // 建立 FTP 连接
        $conn = ftp_connect($ftp_server);
        if (!$conn) {
            die('Could not connect to FTP server');
        }

        // 登录 FTP
        $login = ftp_login($conn, $ftp_username, $ftp_password);
        if (!$login) {
            die('FTP login failed');
        }

        // 打开本地文件
        $handle = fopen($local_file, 'r');
        if (!$handle) {
            die('Could not open local file');
        }

        // 上传文件到 FTP
        $upload = ftp_fput($conn, $remote_file, $handle, FTP_BINARY); // FTP_ASCII 或 FTP_BINARY
        if (!$upload) {
            echo 'Could not upload file';
        } else {
            echo 'File uploaded successfully';
        }

        // 关闭连接和文件句柄
        ftp_close($conn);
        fclose($handle);

    }

    public function clearSQLiteTables() {
        $dbPath = '../localfile.db';
            try {
            // 创建 PDO 连接
            $pdo = new PDO("sqlite:$dbPath");

            // 设置 PDO 错误模式为异常
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // 清空表格
            $tables = ['job', 'sequence', 'advancedstep', 'normalstep', 'input', 'output'];

            foreach ($tables as $table) {
                $query = "DELETE FROM $table";
                $pdo->exec($query);
                echo "Table $table cleared successfully<br>";
            }

            // 关闭连接
            $pdo = null;
        } catch(PDOException $e) {
            echo "Error: " . $e->getMessage();
        }

    }

    public function CCToGTCS($device_id,$device_name)
    {
        //將中控設定寫入db，同時更新對應的資料task id與job id

        //select 中控 task 再帶出job與sequence的設定值， 最後寫入tcscon
        //select from ccs_normalstep (應該要再加advancedstep)
        $tasks = $this->SettingModel->get_all_tasks(); //gtcs的step

        $gtcs_job_id_count = 1;
        
        foreach ($tasks as $key => $task) {
            //get CC job data
            $job_data = $this->ProductModel->getJobById($task['job_id']);
            //get CC seq data
            $seq_data = $this->SequenceModel->GetSeqById($task['job_id'],$task['seq_id']);

            if($seq_data != false){
                //建立job
                $this->SettingModel->JobIdCheck($gtcs_job_id_count,$job_data);
                //建立sequence
                $this->SettingModel->SeqIdCheck($gtcs_job_id_count,$task['seq_id'],$seq_data);
                //建立step
                $this->SettingModel->TaskIdCheck($task,$gtcs_job_id_count,$seq_data['seq_name']);

                //將gtcs對應的job_id寫回task的gtcs_job_id 
                $this->SettingModel->TaskUpdate($task,$gtcs_job_id_count);

                $gtcs_job_id_count++;
            }

        }

        //advanced job
        $advanced_tasks = $this->SettingModel->get_all_tasks_advanced(); //gtcs的step

        $gtcs_adv_job_id_count = 100;
        $last_job_id = 0;
        $last_seq_id = 0;
        $last_task_id = 0;

        foreach ($advanced_tasks as $key => $task) {

            if($last_job_id != $task['job_id'] || $last_seq_id != $task['seq_id'] || $last_task_id != $task['task_id'] ){//與前一筆task不同 job_id++
                $gtcs_adv_job_id_count++;

                $last_job_id = $task['job_id'];
                $last_seq_id = $task['seq_id'];
                $last_task_id = $task['task_id'];

                //get CC job data
                $job_data = $this->ProductModel->getJobById($task['job_id']);
                //get CC seq data
                $seq_data = $this->SequenceModel->GetSeqById($task['job_id'],$task['seq_id']);

                if($seq_data != false){

                    //建立job
                    $this->SettingModel->JobIdCheck($gtcs_adv_job_id_count,$job_data);
                    //建立sequence
                    $this->SettingModel->SeqIdCheck($gtcs_adv_job_id_count,$task['seq_id'],$seq_data);
                    //建立step
                    $this->SettingModel->TaskIdCheck_Advanced($task,$gtcs_adv_job_id_count,$seq_data['seq_name']);

                    //將gtcs對應的job_id寫回task的gtcs_job_id 
                    $this->SettingModel->TaskUpdate_Advanced($task,$gtcs_adv_job_id_count);
                    
                }

            }else{//與前一筆task相同 job_id不用++
                //get CC job data
                $job_data = $this->ProductModel->getJobById($task['job_id']);
                //get CC seq data
                $seq_data = $this->SequenceModel->GetSeqById($task['job_id'],$task['seq_id']);

                if($seq_data != false){
                    //建立job job_id相同不用再建立
                    // $this->SettingModel->JobIdCheck($gtcs_adv_job_id_count,$job_data);
                    //建立sequence
                    $this->SettingModel->SeqIdCheck($gtcs_adv_job_id_count,$task['seq_id'],$seq_data);
                    //建立step
                    $this->SettingModel->TaskIdCheck_Advanced($task,$gtcs_adv_job_id_count,$seq_data['seq_name']);

                    //將gtcs對應的job_id寫回task的gtcs_job_id 
                    $this->SettingModel->TaskUpdate_Advanced($task,$gtcs_adv_job_id_count);
                }
            }
        }

        //修改device_id、device_name
        if($device_id != '' && $device_name != ''){
            $this->SettingModel->SetDeviceSetting($device_id,$device_name);
        }
        
    }

    //下modbus讓GTCS匯入FTP的cfg
    public function ImportDB($value='')
    {
        //get controller ip
        $controller_ip = $this->EquipmentModel->GetControllerIP(1);

        require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
        $modbus = new ModbusMaster($controller_ip, "TCP");
        try {
            $modbus->port = 502;
            $modbus->timeout_sec = 30;
            $data = array(1, 25443);
            $dataTypes = array("INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT", "INT");

            // FC 16
            $modbus->writeMultipleRegister(0, 506, $data, $dataTypes);
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
            // echo $modbus->status;
            exit();
        }
    }

    public function Operation_Setting()
    {
        $error_message = '';

        $this->OperationModel->SetConfigValue('auth_skip',$_POST['switch_next_seq']);
        $this->OperationModel->SetConfigValue('auth_back',$_POST['switch_previous_seq']);
        $this->OperationModel->SetConfigValue('auth_task_reset',$_POST['task_reset']);
        $this->OperationModel->SetConfigValue('auth_job_change',$_POST['switch_job']);
        $this->OperationModel->SetConfigValue('auth_seq_change',$_POST['switch_seq']);
        $this->OperationModel->SetConfigValue('manger_verify',$_POST['role_checked']);
        $this->OperationModel->SetConfigValue('stop_on_ng',$_POST['stop_on_ng']);
        $this->OperationModel->SetConfigValue('auto_switch',$_POST['auto_switch']);
        $this->OperationModel->SetConfigValue('tower_light_switch',$_POST['tower_light_switch']);
        $this->OperationModel->SetConfigValue('buzzer_switch',$_POST['buzzer_switch']);

        echo json_encode(array('error' => $error_message));

        exit();


    }


    public function System_Setting()
    {
        $error_message = '';

        $this->OperationModel->SetConfigValue('language_setting',$_POST['language_setting']);
        $this->OperationModel->SetConfigValue('count_method_setting',$_POST['count_method_setting']);
        //count_method_setting
        $_SESSION['language'] = $_POST['language_setting'];
        echo json_encode(array('error' => $error_message));

        exit();

    }



    public function Voice_Playback_Sound(){
        $error_message = '';
        $this->OperationModel->SetConfigValue('gender_switch',$_POST['gender']);
        //$this->OperationModel->SetConfigValue('auto_switch',$_POST['auto_switch']);
        echo json_encode(array('error' => $error_message));
        exit();
    }


    
}