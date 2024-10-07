<?php

if (!empty($_SERVER["HTTP_CLIENT_IP"])){
    $ip = $_SERVER["HTTP_CLIENT_IP"];
}elseif(!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
    $ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
}else{
    $ip = $_SERVER["REMOTE_ADDR"];
}

// if($ip != '::1'){ //只限本機呼叫
//     return 0;
// }

//--------------------------------------

$json = file_get_contents('php://input');

if($json){
    // file_put_contents("./test.txt", $json, FILE_APPEND);
    $data = json_decode($json,true);
}

if( isset($data['light_signal']) ){
    $light_signal = $data['light_signal'];
}

if( isset($_GET['light_signal']) ){
    $light_signal = $_GET['light_signal'];
    $data['hole_id'] = 4;
    // file_put_contents("./test.txt", '123', FILE_APPEND);
}

if( isset($data['IO']) ){
    $IO = $data['IO'];
}

if( isset($data['TowerLightSetting']) ){
    $TowerLightSetting = $data['TowerLightSetting'];
}

// $light_signal = $data['light_signal'];
// $IO = $data['IO'];
// $TowerLightSetting = $data['TowerLightSetting'];

if( isset($_POST['t']) && $_POST['t'] == 1){
    $light_signal = 'stop';
    // file_put_contents("./test.txt", '123', FILE_APPEND);
}

if( isset($_GET['t']) && $_GET['t'] == 1){
    $light_signal = 'stop';
    // file_put_contents("./test.txt", '123', FILE_APPEND);
}

if( isset($_GET['t']) && $_GET['t'] == 2){
    $light_signal = 'test';
    // file_put_contents("./test.txt", '123', FILE_APPEND);
}

require_once '../modules/phpmodbus-master/Phpmodbus/ModbusMaster.php';
$modbus = new ModbusMaster('192.168.1.75', "TCP");

$data_true_single = array(true);
$data_false_single = array(false);

try {
    $modbus->port = 502;
    $modbus->timeout_sec = 10;

    $pins = array();
    $pins[0] = false;
    $pins[1] = false;
    $pins[2] = false;
    $pins[3] = false;
    $pins[4] = false;
    $pins[5] = false;
    $pins[6] = false;
    $pins[7] = false;
    $pins[8] = false;
    $pins[9] = false;
    $pins[10] = false;
    $pins[11] = false;

    if ($light_signal == 'ng') { // buzzer 3短音

        foreach($IO as $key => $value) {
            if (in_array('red_light', $value)) {
                $red_light = $value['pin_number'];
                $red_light_signal = array(boolval($TowerLightSetting[0]['red_light']));
            }
            if (in_array('green_light', $value)) {
                $green_light = $value['pin_number'];
                $green_light_signal = array(boolval($TowerLightSetting[0]['green_light']));
            }
            if (in_array('yellow_light', $value)) {
                $yellow_light = $value['pin_number'];
                $yellow_light_signal = array(boolval($TowerLightSetting[0]['yellow_light']));
            }
            if (in_array('buzzer', $value)) {
                $buzzer = $value['pin_number'];
                $buzzer_signal = array(boolval($TowerLightSetting[0]['buzzer']));
            }
        }

        $delay_time = intval($TowerLightSetting[0]['pulse_time']) * 1000;

        $modbus->writeMultipleCoils(0, $red_light, $red_light_signal); //red
        $modbus->writeMultipleCoils(0, $green_light, $green_light_signal); //yellow
        $modbus->writeMultipleCoils(0, $yellow_light, $yellow_light_signal); //green
        $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer

        usleep(80000); // 0.05s
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true2);//只停buzzer 以達到促音的效果
        $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
        usleep(80000); // 0.05s
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true);
        $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer start
        usleep(80000); // 0.05s
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true2);//只停buzzer 以達到促音的效果
        $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
        usleep(80000); // 0.05s
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true);
        $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer start
        usleep(80000); // 0.05s
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true2);//只停buzzer 以達到促音的效果
        $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
        usleep(80000); // 0.05s

        if (($delay_time - 80000 * 6) > 0) {
            usleep($delay_time - 80000 * 6);
        } else {

        }

        $modbus->writeMultipleCoils(0, $red_light, $data_false_single); //red close
        $modbus->writeMultipleCoils(0, $green_light, $data_false_single); //yellow close
        $modbus->writeMultipleCoils(0, $yellow_light, $data_false_single); //green close

        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_false);
    }

    if ($light_signal == 'ok') { // buzzer 1秒

        foreach($IO as $key => $value) {
            if (in_array('red_light', $value)) {
                $red_light = $value['pin_number'];
                $red_light_signal = array(boolval($TowerLightSetting[1]['red_light']));
            }
            if (in_array('green_light', $value)) {
                $green_light = $value['pin_number'];
                $green_light_signal = array(boolval($TowerLightSetting[1]['green_light']));
            }
            if (in_array('yellow_light', $value)) {
                $yellow_light = $value['pin_number'];
                $yellow_light_signal = array(boolval($TowerLightSetting[1]['yellow_light']));
            }
            if (in_array('buzzer', $value)) {
                $buzzer = $value['pin_number'];
                $buzzer_signal = array(boolval($TowerLightSetting[1]['buzzer']));
            }
        }

        $delay_time = intval($TowerLightSetting[1]['pulse_time']) * 1000;

        if ($delay_time > 1000000) {
            $modbus->writeMultipleCoils(0, $red_light, $red_light_signal); //red
            $modbus->writeMultipleCoils(0, $green_light, $green_light_signal); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $yellow_light_signal); //green
            $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer
            usleep(1000000); // 1 sec
            $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
            usleep($delay_time - 1000000);
            $modbus->writeMultipleCoils(0, $red_light, $data_false_single); //red
            $modbus->writeMultipleCoils(0, $green_light, $data_false_single); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $data_false_single); //green
        } else {
            $modbus->writeMultipleCoils(0, $red_light, $red_light_signal); //red
            $modbus->writeMultipleCoils(0, $green_light, $green_light_signal); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $yellow_light_signal); //green
            $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer
            usleep($delay_time);
            $modbus->writeMultipleCoils(0, $red_light, $data_false_single); //red // light stop
            $modbus->writeMultipleCoils(0, $green_light, $data_false_single); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $data_false_single); //green 
            usleep(1000000 - $delay_time); // 1 sec
            $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer //buzzer stop
        }
    }

    if ($light_signal == 'okall') { // buzzer 3秒

        foreach($IO as $key => $value) {
            if (in_array('red_light', $value)) {
                $red_light = $value['pin_number'];
                $red_light_signal = array(boolval($TowerLightSetting[2]['red_light']));
            }
            if (in_array('green_light', $value)) {
                $green_light = $value['pin_number'];
                $green_light_signal = array(boolval($TowerLightSetting[2]['green_light']));
            }
            if (in_array('yellow_light', $value)) {
                $yellow_light = $value['pin_number'];
                $yellow_light_signal = array(boolval($TowerLightSetting[2]['yellow_light']));
            }
            if (in_array('buzzer', $value)) {
                $buzzer = $value['pin_number'];
                $buzzer_signal = array(boolval($TowerLightSetting[2]['buzzer']));
            }
        }

        $delay_time = intval($TowerLightSetting[2]['pulse_time']) * 1000;

        $data_true = array($pins[0], $pins[1], $pins[2], $pins[3], $pins[4], $pins[5], $pins[6], $pins[7], $pins[8], $pins[9], $pins[10], $pins[11]);
        $data_false = array(false, false, false, false, false, false, false, false, false, false, false, false);
        $buzzer_true = array($pins[0]);
        $buzzer_false = array(false);

        if ($delay_time > 3000000) {
            $modbus->writeMultipleCoils(0, $red_light, $red_light_signal); //red
            $modbus->writeMultipleCoils(0, $green_light, $green_light_signal); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $yellow_light_signal); //green
            $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer
            usleep(3000000); // 1 sec
            $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
            usleep($delay_time - 3000000);
            $modbus->writeMultipleCoils(0, $red_light, $data_false_single); //red // light stop
            $modbus->writeMultipleCoils(0, $green_light, $data_false_single); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $data_false_single); //green // light stop
        } else {
            $modbus->writeMultipleCoils(0, $red_light, $red_light_signal); //red
            $modbus->writeMultipleCoils(0, $green_light, $green_light_signal); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $yellow_light_signal); //green
            $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer
            usleep($delay_time);
            $modbus->writeMultipleCoils(0, $red_light, $data_false_single); //red // light stop
            $modbus->writeMultipleCoils(0, $green_light, $data_false_single); //yellow
            $modbus->writeMultipleCoils(0, $yellow_light, $data_false_single); //green 
            usleep(3000000 - $delay_time); // 1 sec
            $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
        }
    }

    if ($light_signal == 'stop') {
        $data_true = array(false, true, true, true, true, true, true, true, true, true, true, true);
        $data_false = array(false, false, false, false, false, false, false, false, false, false, false, false);
        $recDate = $modbus->writeMultipleCoils(0, 0, $data_false); //buzzer start
        usleep(3000);
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true); //buzzer start
    }

    if ($light_signal == 'sockect_hole') {
        // $data['hole_id'];
	echo 123;

        if($data['hole_id'] == 1){
            $pins[0] = true;
        }

        if($data['hole_id'] == 2){
            $pins[1] = true;
        }

        if($data['hole_id'] == 3){
            $pins[0] = true;
            $pins[1] = true;
        }

        if($data['hole_id'] == 4){
            $pins[2] = true;
        }

        //先判斷目前狀態，如果相同就不重複送指令
        $current_status = $modbus->readCoils(0, 0, 16);
        if( $pins[0] == $current_status[0] && $pins[1] == $current_status[1] && $pins[2] == $current_status[2] ){
            return 0;
            exit();
        }

        // $data_true = array($pins[0], $pins[1], $pins[2], $pins[3], $pins[4], $pins[5], $pins[6], $pins[7], $pins[8], $pins[9], $pins[10], $pins[11]);
        // $data_false = array(false, false, false, false, false, false, false, false, false, false, false, false);
        // $recDate = $modbus->writeMultipleCoils(0, 0, $data_true); //buzzer start

        //clear 
        $modbus->writeMultipleCoils(0, 0, $data_false_single); //先寫死 之後再調
        $modbus->writeMultipleCoils(0, 1, $data_false_single); //
        $modbus->writeMultipleCoils(0, 2, $data_false_single); //
        
        $trueValues = array_filter($pins);
        // 使用 array_keys 找出值為 true 的元素的索引
        $trueIndices = array_keys($trueValues);

        //var_dump($trueIndices);
        foreach ($trueIndices as $key => $value) {
            $modbus->writeMultipleCoils(0, $value, $data_true_single); //buzzer start
        }

    }

    if ($light_signal == 'io_test') { //io test

        foreach($IO as $key => $value) {
            if (in_array('red_light', $value)) {
                $red_light = $value['pin_number'];
                $red_light_signal = array($data['red_light']);
            }
            if (in_array('green_light', $value)) {
                $green_light = $value['pin_number'];
                $green_light_signal = array($data['green_light']);
            }
            if (in_array('yellow_light', $value)) {
                $yellow_light = $value['pin_number'];
                $yellow_light_signal = array($data['yellow_light']);
            }
            if (in_array('buzzer', $value)) {
                $buzzer = $value['pin_number'];
                $buzzer_signal = array($data['buzzer']);
            }
        }

        $modbus->writeMultipleCoils(0, $red_light, $red_light_signal); //red
        $modbus->writeMultipleCoils(0, $green_light, $green_light_signal); //yellow
        $modbus->writeMultipleCoils(0, $yellow_light, $yellow_light_signal); //green
        $modbus->writeMultipleCoils(0, $buzzer, $buzzer_signal); //buzzer
        usleep(1000000);// 1s
        $modbus->writeMultipleCoils(0, $red_light, $data_false_single); //red // light stop
        $modbus->writeMultipleCoils(0, $green_light, $data_false_single); //yellow
        $modbus->writeMultipleCoils(0, $yellow_light, $data_false_single); //green 
        $modbus->writeMultipleCoils(0, $buzzer, $data_false_single); //buzzer stop
    }

    if ($light_signal == 'clear') {// clear io
        $data_false = array(false, false, false, false, false, false, false, false, false, false, false, false);
        $recDate = $modbus->writeMultipleCoils(0, 0, $data_false); //
    }

    if ($light_signal == 'test') {
        $current_status = $modbus->readCoils(0, 0, 16);
    }


} catch (Exception $e) {
    echo $modbus->status;
    exit();
}


function seperate_execute($pins)
{
    $data_true_single = array(true);
    $data_false_single = array(false);

    $trueValues = array_filter($pins);

    // 使用 array_keys 找出值為 true 的元素的索引
    $trueIndices = array_keys($trueValues);

    // var_dump($trueIndices);
    foreach ($trueIndices as $key => $value) {
        $modbus->writeMultipleCoils(0, $value, $data_true_single); //buzzer start
    }
    usleep(300000);
    foreach ($trueIndices as $key => $value) {
        $modbus->writeMultipleCoils(0, $value, $data_false_single); //buzzer start
    }
}
