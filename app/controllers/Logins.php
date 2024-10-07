<?php

class Logins extends Controller
{
    private $LoginModel;
    private $NavModel;
    private $timeout_seconds = 3600;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->LoginModel = $this->model('Login');
        $this->NavModel = $this->model('Nav');
        $this->MainsController = $this->controller_new('Mains');
        $this->OperationModel = $this->model('Operation');
    }

    // 取得所有Jobs
    public function index($url){
        session_start();
        $_SESSION['sessionid'] = session_id();
        $error_message = '';
        $authToken = '';
        $data = [
            'error_message' => $error_message
        ];

        //例外狀況，切換語系
        $exception = false;
        if(isset($url[1])){
            if($url[0] == 'Mains' && $url[1] == 'change_language' ){
                $exception = true;
            }
            if($url[0] == 'Monitors' && $url[1] == 'GetMonitorInfo' ){// monitor get info
                $exception = true;
            }

        }

        //判斷有沒有post password
        //有post就驗證password
        //沒有就單純檢查cookies
        if( !empty($_POST['password']) && isset($_POST['password'])  ){

            $username = $_POST['username'];
            $password = $_POST['password'];


            $job_id  = 0;
            //$seq_id  = '';
            //$task_id = '';
            $current_job_id = $this->OperationModel->SetConfigValue('current_job_id',$job_id);
            //$current_job_id = $this->OperationModel->SetConfigValue('current_seq_id',$seq_id);
            //$current_job_id = $this->OperationModel->SetConfigValue('current_task_id',$task_id);

            
            if($this->verifyCredentials($username,$password)){
                // $part1 = hash('sha256', $password);
                // $authToken = hash('sha256', $part1.'kilews');//
                // setcookie('auth_token', $authToken, time() + $this->timeout_seconds, '/');

                // setcookie('user', $username, time() + $this->timeout_seconds, '/');
                // $_SESSION['user'] = $username;
                
                //加入權限控管
                $this->PermissionCheck($url);

                return true;
            }else{
                // 用戶未登錄或身份驗證超時，跳轉到登錄頁面
                $this->logout();
                $this->view('login/index', $data);
                exit();
            }

        }else{
            if ($this->isAuthenticated() || $exception ) { //切換語系例外
                //用戶已登錄，繼續處理其他操作
                //加入權限控管
                if(!$exception){
                    $this->PermissionCheck($url);
                }

                return true;
            } else {
                // 用戶未登錄或身份驗證超時，跳轉到登錄頁面
                $this->logout();
                $this->view('login/index', $data);
                exit();
            }
        }

    }

    public function isAuthenticated() {
        if (isset($_COOKIE['auth_token']) && isset($_COOKIE['user']) ) {
            $user = $_COOKIE['user'];
            $authToken = $_COOKIE['auth_token'];
            
            // 解密和驗證令牌的有效性，根據需要進行自定義驗證
            $username = $this->verifyCredentials_token($user,$authToken);

            if ($username !== false) {
                // 令牌有效，可以根據需要刷新 Cookie 的過期時間
                setcookie('user', $user, time() + $this->timeout_seconds, '/');
                setcookie('auth_token', $authToken, time() + $this->timeout_seconds, '/');
                return true;
            }
        }

        return false;
    }

    // 退出登錄並清除身份驗證令牌
    public function logout() {
        setcookie('user', '', time() - 3600, '/');
        setcookie('auth_token', '', time() - 3600, '/');
    }

    // 验证用户提交的用户名和密码
    public function verifyCredentials($username,$password) {
        // 自定義的身份驗證邏輯，根據實際情況進行驗證
        // 返回 true 表示驗證成功，false 表示驗證失敗
        // 可以與數據庫或其他存儲進行比對驗證

        $id_login = false;
        
        if($_POST['action'] == 'idlogin'){

            //用id查詢登入 get username
            //seletc user by id
            //get password
            $id_login = false;
            $user = $this->LoginModel->get_user_by_idcard($password);

            if($user){
                $id_login = true;
            }
            $input = 123;
            $output = 546;
        }else{
            $pwd = $this->LoginModel->getpwd($username); //控制器密碼
            if($pwd == false){//找不到帳號
                return false;
            }
            $input = hash('sha256', $password);
            $output = $pwd['password'];
        }
        
        if($input == $output){
            //登入成功寫入 active_sessions 資料庫
            // $reslut = $this->active_sessions('admin');
            $reslut = true;
            $this->logMessage('login','success');

            if($reslut){

                $part1 = hash('sha256', $password);
                $authToken = hash('sha256', $part1.'kilews');//
                setcookie('auth_token', $authToken, time() + $this->timeout_seconds, '/');
                setcookie('user', $username, time() + $this->timeout_seconds, '/');
                $_SESSION['user'] = $username;

                return true;
            }else{
                return false;
            }
        }else if($id_login == true){
            $username = $user['account'];
            $authToken = hash('sha256', $user['password'].'kilews');//
            setcookie('auth_token', $authToken, time() + $this->timeout_seconds, '/');
            setcookie('user', $username, time() + $this->timeout_seconds, '/');
            $_SESSION['user'] = $username;

            return true;
        }else{
            $this->logMessage('login','account:'.$username.' login fail');
            // exit();
            return false;
        }
    }

    // 验证用户提交的用户名和密码
    public function verifyCredentials_token($username,$authToken) {
        // 自定義的身份驗證邏輯，根據實際情況進行驗證
        // 返回 true 表示驗證成功，false 表示驗證失敗
        // 可以與數據庫或其他存儲進行比對驗證
        $pwd = $this->LoginModel->getpwd($username); //控制器密碼
        $input = $authToken;
        $output = hash('sha256', $pwd['password'].'kilews');//

        if($input == $output){
            //登入成功寫入 active_sessions 資料庫
            // $reslut = $this->active_sessions('admin');
            $reslut = true;
            
            if($reslut){
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }

    //user 權限判斷
    public function PermissionCheck($url)
    {   
        $error_message = '';
        $authToken = '';
        $data = [
            'error_message' => $error_message
        ];

        $account = '';
        if (isset($_SESSION['user']) ) {
            $account = $_SESSION['user'];
        }else{
            $this->MainsController->logout();
        }

        $uid = $this->NavModel->GetUserIdByAccount($account);
        $user_permissions =  $this->NavModel->GetPermissionsByUserId($uid);
        $rows = $this->NavModel->GetNav();

        $permissions = array();
        foreach ($user_permissions as $key => $value) {
            $permissions[] = $value['Route'];
        }
        $permissions[] = 'mains';


        if( in_array(strtolower($url[0]), $permissions) ){
            
        }else{
            //轉回主畫面
            header("Location:".$_SERVER['PHP_SELF']."?url=Mains");
            exit();
        }

    }

}
