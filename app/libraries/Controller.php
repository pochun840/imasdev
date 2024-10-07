<?php

class Controller
{
    // 載入 model
    public function model($model)
    {
        require_once '../app/models/' . $model . '.php';
        return new $model();
    }

    // 載入 controller
    public function controller_new($controller)
    {
        require_once '../app/controllers/' . $controller . '.php';
        return new $controller();
    }

    // 載入 view
    // 其中 view 可能有需要從 Controller 帶過去的資料，故多了 $data 陣列作為第二個參數
    public function view($view, array $data = [])
    {
        $this->language_auto(); //從瀏覽器帶入語系
        //multi language
        $language = array("language"=>$_SESSION['language']);
        $data = array_merge($data,$language);
        
        //權限
        // $privilege = array("privilege"=>$_SESSION['privilege']);
        // $data = array_merge($data,$privilege);
        // var_dump($data);
        // 如果檔案存在就引入它
        if(file_exists('../app/language/' . $data['language'] . '.php')){
            require '../app/language/' . $data['language'] . '.php';
        } else { //預設採用簡體中文
            require '../app/language/zh-cn.php';
        }

        // 如果檔案存在就引入它
        if(file_exists('../app/views/' . $view . '.tpl')){
            require_once '../app/views/' . $view . '.tpl';
        } else {
            die('View does not exist');
        }
    }

    public function language_auto($value='')
    {
        // 如果$_SESSION['language'] 未設定 或為空 就從瀏覽器訊息帶入
        if( !isset($_SESSION['language']) || $_SESSION['language'] == '' ){
            $lang = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'], 0, 4);
            if (preg_match("/zh-cn/i", $lang)){
                $_SESSION['language'] = 'zh-cn';
            }else if(preg_match("/zh-tw/i", $lang)){
                $_SESSION['language'] = 'zh-tw';
            }else if(preg_match("/en/i", $lang)){
                $_SESSION['language'] = 'en-us';
            }else{//預設
                $_SESSION['language'] = 'zh-tw';
            }
        }

    }

    public function logMessage($action,$detail) {
        date_default_timezone_set('UTC');
        if( PHP_OS_FAMILY == 'Linux'){
            $cc_db = new PDO('sqlite:/var/www/html/database/tcscon.db'); //local
        }else{
            $cc_db = new PDO('sqlite:../cc.db'); //local
        }

        if (!empty($_SERVER["HTTP_CLIENT_IP"])){
            $ip = $_SERVER["HTTP_CLIENT_IP"];
        }elseif(!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
            $ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
        }else{
            $ip = $_SERVER["REMOTE_ADDR"];
        }

        if(!empty($_SESSION["user"])){
            $account = $_SESSION['user'];
        }else{
            $account = '';
        }     
        
        $cc_db->exec('set names utf-8'); 
        $stmt = $cc_db->prepare('INSERT INTO system_log (account, action, detail, ip, timestamp ) VALUES ( :account, :action, :detail, :ip, :timestamp )');
        $stmt->bindValue(':account', $account);
        $stmt->bindValue(':action', $action);
        $stmt->bindValue(':detail', $detail);
        $stmt->bindValue(':ip', $ip);
        $stmt->bindValue(':timestamp', date("Y-m-d H:i:s"));
        $result = $stmt->execute();

        return $result;       
    }

    public function isMobileCheck($value='')
    {
        //Detect special conditions devices
        $iPod = stripos($_SERVER['HTTP_USER_AGENT'],"iPod");
        $iPhone = stripos($_SERVER['HTTP_USER_AGENT'],"iPhone");
        $iPad = stripos($_SERVER['HTTP_USER_AGENT'],"iPad");
        if(stripos($_SERVER['HTTP_USER_AGENT'],"Android") && stripos($_SERVER['HTTP_USER_AGENT'],"mobile")){
            $Android = true;
        }else if(stripos($_SERVER['HTTP_USER_AGENT'],"Android")){
            $Android = false;
            $AndroidTablet = true;
        }else{
            $Android = false;
            $AndroidTablet = false;
        }
        $webOS = stripos($_SERVER['HTTP_USER_AGENT'],"webOS");
        $BlackBerry = stripos($_SERVER['HTTP_USER_AGENT'],"BlackBerry");
        $RimTablet= stripos($_SERVER['HTTP_USER_AGENT'],"RIM Tablet");
        //do something with this information
        if( $iPod || $iPhone || $iPad || $Android || $AndroidTablet || $webOS || $BlackBerry || $RimTablet){
            return true;
        }else{
            return false;
        }
    }

    //權限驗證function
    public function LoginCheck($value='')
    {
        if( PHP_OS_FAMILY == 'Linux'){
            $con_db = new PDO('sqlite:/var/www/html/database/tcscon.db'); //local
        }else{
            $con_db = new PDO('sqlite:../tcscon.db'); //local
        }

        $con_db->exec('set names utf-8'); 
        $sql = 'SELECT * FROM operator';
        $statement = $con_db->prepare($sql);
        $results = $statement->execute();
        $row = $statement->fetch(PDO::FETCH_ASSOC);

        return $row['operator_loginflag'];        
    }


}
