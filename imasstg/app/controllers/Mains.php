<?php

class Mains extends Controller
{
    private $DashboardModel;
    private $NavsController;
    private $NavModel;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->NavsController = $this->controller_new('Navs');
        $this->NavModel = $this->model('Nav');
        $this->NavModel = $this->model('Nav');
        $this->OperationModel = $this->model('Operation');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();

        $account = $_SESSION['user'];
        $uid = $this->NavModel->GetUserIdByAccount($account);
        $user_permissions =  $this->NavModel->GetPermissionsByUserId($uid);
        $rows = $this->NavModel->GetNav();

        //把當前的語系 寫入db
        if(!empty($_SESSION['language'])){
            $language = $_SESSION['language'];
            $this->OperationModel->SetConfigValue('language_setting',$language);
        }



        $permissions = array();
        foreach ($user_permissions as $key => $value) {
            $permissions[] = $value['Route'];
        }

        $data = [
            'isMobile' => $isMobile,
            'rows' => $rows,
            'permissions' => $permissions,
            'nav' => $nav,
        ];
        
        $this->view('main/index', $data);

    }

    public function change_language()
    {
        if( !empty($_POST['language']) && isset($_POST['language'])  ){
            $language = $_POST['language'];
        }else{ 
            $input_check = false; 
            $error_message .= "language,";
        }

        // session_start();
        $_SESSION['language'] = $language;


        //$this->OperationModel->GetConfigValue($_SESSION['language']);


        $response = array(
            'language' => $language,
            'result' => true,
        );
        echo json_encode($response);

    }

    // 退出登錄並清除身份驗證令牌
    public function logout() {
        $data = array();
        setcookie('user', '', time() - 3600, '/');
        setcookie('auth_token', '', time() - 3600, '/');

        $job_id  = 0;
        //$seq_id  = '';
        //$task_id = '';
        $current_job_id = $this->OperationModel->SetConfigValue('current_job_id',$job_id);
        //$current_job_id = $this->OperationModel->SetConfigValue('current_seq_id',$seq_id);
        //$current_job_id = $this->OperationModel->SetConfigValue('current_task_id',$task_id);

        $this->view('login/index', $data);
        // header("Location:".$_SERVER['REQUEST_URI']."  ");
        exit();
    }

    
}