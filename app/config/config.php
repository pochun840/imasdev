<?php


// App 根目錄，這是引入 app 資料夾裡的資源用的
define('APPROOT', dirname(dirname(__FILE__)) . '/');

// URL 根目錄，這是引入 public 資料夾裡的資源，或是頁面跳轉時用的
define('URLROOT', '../public/'); //local用

// 網站名稱
define('SITENAME', 'KISS');

// GTCS控制器FTP帳密
define('FTP_USER', 'iams');
define('FTP_PASSWORD', 'Kilewsiams');

// IO盒IP
define('IOBOX_IP', '192.168.1.75'); // 192.168.1.75

// 控制器名稱
define('CONTROLLER_GTCS', 'GTCS'); // 台灣GTCS 上海EPIC
define('CONTROLLER_TCG', 'TCG'); // 台灣TCG 上海EPTC
