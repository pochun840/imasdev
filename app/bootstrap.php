<?php

require_once 'config/config.php';

spl_autoload_register(function($className){
    // require_once 'libraries/' . $className . '.php';
    $filePath = APPROOT.'libraries/' . $className . '.php';
    // 如果檔案存在，則引入它
    if (file_exists($filePath)) {
        require_once $filePath;
    }
});