<?php

class Users extends Controller
{
    private $UserModel;
    private $NavsController;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->UserModel = $this->model('User');
        $this->NavsController = $this->controller_new('Navs');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $all_users = $this->UserModel->GetAllUser();
        $permission_list = $this->UserModel->GetAllPermissions();
        $all_roles = $this->UserModel->GetAllRole();

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'all_users' => $all_users,
            'permission_list' => $permission_list,
            'all_roles' => $all_roles,
        ];

        // var_dump($all_roles);
        
        $this->view('user/index', $data);

    }

    // 取得所有Jobs
    // public function index2(){

    //     $isMobile = $this->isMobileCheck();
    //     $nav = $this->NavsController->get_nav();
    //     $all_users = $this->UserModel->GetAllUser();
    //     $permission_list = $this->UserModel->GetAllPermissions();
    //     $all_roles = $this->UserModel->GetAllRole();

    //     $data = [
    //         'isMobile' => $isMobile,
    //         'nav' => $nav,
    //         'all_users' => $all_users,
    //         'permission_list' => $permission_list,
    //         'all_roles' => $all_roles,
    //     ];
        
    //     $this->view('user/index2', $data);

    // }

    //role setting page
    public function role_setting(){

        $this->PermissionsTableUpdate();//更新controller list

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $all_users = $this->UserModel->GetAllUser();
        $permission_list = $this->UserModel->GetAllPermissions();
        $all_roles = $this->UserModel->GetAllRole();

        $exculisve = array('navs','mains','logins');//不顯示在permissions設定
        foreach ($permission_list as $key => $value) {
            if(in_array($value['Route'], $exculisve)){
                $permission_list[$key] = null;
            }
        }

        $permission_list = array_filter($permission_list);

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'all_users' => $all_users,
            'permission_list' => $permission_list,
            'all_roles' => $all_roles,
        ];
        
        $this->view('user/role_setting', $data);
    }

    //user log page
    public function user_log(){


        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $all_users = $this->UserModel->GetAllUser();
        $permission_list = $this->UserModel->GetAllPermissions();
        $all_roles = $this->UserModel->GetAllRole();

        $permission_list = array_filter($permission_list);
        
        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'all_users' => $all_users,
            'permission_list' => $permission_list,
            'all_roles' => $all_roles,
        ];
        
        $this->view('user/user_log', $data);
    }

    public function GetAllLogAPI()
    {
        $data['operator'] = '';
        $data['action'] = '';
        $data['result_type'] = '';
        $data['ip'] = '';
        $data['date_from'] = '';
        $data['date_to'] = '';

        $data_array = $_POST;
        $input_check = true;
        $error_message = '';

        if( !empty($_POST['operator']) && isset($_POST['operator']) ){
            $data_array['operator'] = $_POST['operator'];
        }else{ 
            $data_array['operator'] = '-1';
        }
        if( !empty($_POST['action']) && isset($_POST['action']) ){
            $data_array['action'] = $_POST['action'];
        }else{ 
            $data_array['action'] = '-1';
        }
        if( !empty($_POST['result_type']) && isset($_POST['result_type']) ){
            $data_array['result_type'] = $_POST['result_type'];
        }else{ 
            $data_array['result_type'] = '-1';
        }
        if( !empty($_POST['ip']) && isset($_POST['ip']) ){
            $data_array['ip'] = $_POST['ip'];
        }else{ 
            $data_array['ip'] = '';
        }
        if( !empty($_POST['date_from']) && isset($_POST['date_from']) ){
            $data_array['date_from'] = $_POST['date_from'];
        }else{ 
            $data_array['date_from'] = '';
        }
        if( !empty($_POST['date_to']) && isset($_POST['date_to']) ){
            $data_array['date_to'] = $_POST['date_to'];
        }else{ 
            $data_array['date_to'] = '';
        }

        // var_dump($data_array);



        // //get all items
        $item_list = $this->UserModel->GetAllItem($data_array);

        //multi language
        $language = @$_SESSION['language'];
        
        //權限
        // 如果檔案存在就引入它
        if(file_exists('../app/language/' . $language . '.php')){
            require_once '../app/language/' . $language . '.php';
        } else { //預設採用簡體中文
            require_once '../app/language/zh-cn.php';
        }

        //處理user log config mapping
        foreach ($item_list as $key => $value) {
            $item_list[$key]['action'] = @$log_status[$item_list[$key]['action']];
            $item_list[$key]['result'] = @$log_status[$item_list[$key]['result']];
            // $item_list[$key]['detail'] = '';
        }


        echo json_encode(["data" => $item_list]);

        exit();
    }


    public function add_user(){
        // 處理新增使用者請求
        $result = false;
        $error_message = '';

        if (isset($_POST['add_user'])) {

            // var_dump($_POST);
            //驗證帳號不可重複
            $duplicate = false;
            $duplicate = $this->UserModel->DuplicateCheck($_POST['user_account']);;
            if($duplicate){
                echo json_encode(array('error' => 'account repeat'));
                exit();
            }

            $user_name = $_POST['user_name'];
            $user_account = $_POST['user_account'];
            $user_password = $_POST['user_password'];
            $user_employee_number = $_POST['user_employee_number'];
            $role = $_POST['user_role'];

            if( !empty($_POST['user_card']) && isset($_POST['user_card'])  ){
                $user_card = $_POST['user_card'];
            }else{ 
                $user_card = '';
            }
            

            $user_id = $this->UserModel->AddUser($user_account,$user_password,$user_name,$user_employee_number,$user_card);
            if (isset($user_id)) {
                $this->UserModel->AddUserRole($user_id,$role);
                // $this->logMessage('add user','','success: user:'.$user_account);
                $result = true;

                $this->logMessage('user-1','result-1',json_encode( array('user_account'=> $user_account, 'user_name'=> $user_name) ));
            }else{
                $result = false;
                $this->logMessage('user-1','result-2',json_encode( array('user_account'=> $user_account, 'user_name'=> $user_name) ));
            }

            if(!$result){
                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }

    public function get_user_by_id(){
        // 處理新增使用者請求
        $result = false;
        $error_message = '';
        
        if (isset($_POST['user_id'])) {

            $user_data = $this->UserModel->GetUserById($_POST['user_id']);;

            if(!$user_data){
                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                $user_data['error'] = '';
                echo json_encode($user_data);
                exit();
            }
            
        }
    }

    public function edit_user()
    {
        // 處理新增使用者請求
        $result = false;
        $error_message = '';

        if (isset($_POST['user_id'])) {

            $user_id = $_POST['user_id'];
            $user_name = $_POST['user_name'];
            $user_password = $_POST['user_password'];
            $user_employee_number = $_POST['user_employee_number'];
            $role = $_POST['user_role'];

            if( !empty($_POST['user_card']) && isset($_POST['user_card'])  ){
                $user_card = $_POST['user_card'];
            }else{ 
                $user_card = '';
            }

            $results = $this->UserModel->EditUser($user_id,$user_password,$user_name,$user_employee_number,$user_card);
            if ($results) {
                $this->UserModel->EditUserRole($user_id,$role);
                // $this->logMessage('edit user','','success: user_id:'.$user_id);
                $result = true;
                $this->logMessage('user-2','result-1',json_encode( array('user_id'=> $user_id, 'user_name'=> $user_name, 'user_employee_number'=> $user_employee_number, 'user_card'=> $user_card) ));
            }else{
                $result = false;
                $this->logMessage('user-2','result-2',json_encode( array('user_id'=> $user_id, 'user_name'=> $user_name, 'user_employee_number'=> $user_employee_number, 'user_card'=> $user_card) ));
            }

            if(!$result){
                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }

    public function delete_user()
    {
        // 處理新增使用者請求
        $result = false;
        $error_message = '';

        if (isset($_POST['user_id'])) {

            $user_id = $_POST['user_id'];

            $results = $this->UserModel->DeleteUser($user_id);
            if ($results) {
                $this->UserModel->DeleteUserRole($user_id);
                $this->logMessage('delete user','','success: user_id:'.$user_id);
                $result = true;
            }else{
                $result = false;
            }

            if(!$result){
                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }

    //add new role
    public function add_new_role()
    {
        // 處理新增使用者請求
        $result = false;
        $error_message = '';

        if (isset($_POST['role_name'])) {

            // var_dump($_POST);
            //驗證帳號不可重複
            $role_name = $_POST['role_name'];

            $role_id = $this->UserModel->AddNewRole($role_name);
            if ($role_id > 0) {
                $this->logMessage('add role','','success: rolename:'.$role_name);
                $result = true;
            }else{
                $result = false;
            }

            if(!$result){
                $this->logMessage('user-4','result-2',json_encode( array('role_name'=> $role_name) ));

                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                $this->logMessage('user-4','result-1',json_encode( array('role_name'=> $role_name) ));

                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }
    //delete role
    public function delete_role()
    {
        // 處理新增使用者請求
        $result = false;
        $error_message = '';

        if (isset($_POST['role_id'])) {

            // var_dump($_POST);
            //驗證帳號不可重複
            $role_id = $_POST['role_id'];
            if ($role_id == 1) {
                echo json_encode(array('error' => 'Can Not Delete Super admin'));
                exit();
            }


            $result = $this->UserModel->DeleteRole($role_id);

            if(!$result){
                $this->logMessage('user-6','result-2',json_encode( array('role_id'=> $role_id) ));

                echo json_encode(array('error' => 'Already Assign'));
                exit();
            }else{
                $this->logMessage('user-6','result-1',json_encode( array('role_id'=> $role_id) ));

                // $this->logMessage('delete role','','success: role_id:'.$role_id);
                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }
    //edit role
    public function edit_role_permission_by_id()
    {
        if(isset($_POST['role_id'])) {

            //驗證帳號不可重複
            $role_id = $_POST['role_id'];
            $role_permissions = $_POST['role_permissions'];

            $user_data = $this->UserModel->AssiginPermissionByRoleId($role_id,$role_permissions);

            if(!$user_data){
                $this->logMessage('user-5','result-2',json_encode( array('role_id'=> $role_id,'role_permissions'=> $role_permissions ) ));

                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                $this->logMessage('user-5','result-1',json_encode( array('role_id'=> $role_id,'role_permissions'=> $role_permissions ) ));

                // $this->logMessage('edit role','','success: role_id:'.$role_id.', permissions:'.json_encode($role_permissions));
                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }
    //get singel roel
    public function get_role_permission_by_id()
    {

        if (isset($_POST['role_id'])) {

            //驗證帳號不可重複
            $role_id = $_POST['role_id'];

            $role_data = $this->UserModel->GetRolePermissions($role_id);

            if(!$role_data){
                echo json_encode(array('error' => 'no permissions'));
                exit();
            }else{
                $role_data['error'] = '';
                echo json_encode($role_data);
                exit();
            }
            
        }
    }

    public function del_user()
    {
        // 處理新增使用者請求
        $result = false;
        $error_message = '';

        if (isset($_POST['user_id'])) {

            $user_id = $_POST['user_id'];

            $result = $this->UserModel->DelUser($user_id);

            if(!$result){
                $this->logMessage('user-3','result-2',json_encode( array('user_id'=> $user_id) ));
                echo json_encode(array('error' => 'fail'));
                exit();
            }else{
                $this->logMessage('user-3','result-1',json_encode( array('user_id'=> $user_id) ));
                echo json_encode(array('error' => ''));
                exit();
            }
            
        }
    }

    //get all user by role
    public function get_users_by_role()
    {
        if (isset($_POST['role_id'])) {

            //驗證帳號不可重複
            $role_id = $_POST['role_id'];

            $user_data = $this->UserModel->GetUsersByRole($role_id);

            if(!$user_data){
                echo json_encode(array('error' => 'no permissions'));
                exit();
            }else{
                $user_data['error'] = '';
                echo json_encode($user_data);
                exit();
            }
            
        }
    }

    //抓app/controller中的檔案，並自動加入cc_permissions table中
    public function PermissionsTableUpdate()
    {
        $path = '../app/controllers/';

        $list = scandir($path);

        $scanned_directory = array_diff($list, array('..', '.'));

        foreach ($scanned_directory as $key => $value) {
            $temp = explode(".",$value);
            $scanned_directory[$key] = strtolower($temp[0]);
        }

        $scanned_directory = array_values($scanned_directory);

        foreach ($scanned_directory as $key => $value) {
            $this->UserModel->UpdatePermissionRoute($value);
        }
        
    }
    
}