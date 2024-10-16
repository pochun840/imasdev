<?php

class Calibration{
    private $db;//condb control box
    private $db_dev;//devdb tool
    private $db_iDas;//iDas db
    private $db_cc;//iDas db

    // 在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();
    }


    public function details($mode){

        $details = array();
        if($mode =="controller"){
            $details = array(
                0 => 'GTCS',
                1 => 'TCG',
                2 => '其他'
            );
        }

        if($mode =="torquemeter"){
            $details = array(
                0 => 'KTM-6',
                1 => 'KTM-150',
                2 => 'KTM-250'

            );


        }

        if($mode =="torque"){
            $details  = array(
                1 => 'N.m',
                0 => 'Kgf.m',
                2 => 'Kgf.cm',
                3 => 'In.lbs',
            );
    
        }

        return $details;
    }


    public function datainfo(){

        # 需要job_id 
        $sql =" SELECT * FROM calibrations ORDER BY id ASC ";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);

        return $result;

    }

    public function datainfo_search($job_id){

    
        $sql = "SELECT * FROM `calibrations` WHERE  job_id = :job_id  ORDER BY id ASC  ";
        $params[':job_id'] = $job_id;
        $statement = $this->db->prepare($sql);
        $statement->execute($params);
        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }

    public function echarts_data(){

        $sql =" SELECT * FROM calibrations ORDER BY id ASC ";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        
        $result_charts = $statement->fetchAll(PDO::FETCH_ASSOC);
        return $result_charts;        
    }

    public function getjobid(){
   
        $sql = "SELECT * FROM `job` WHERE job_id != '' ";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;      
    }

    public function get_job_name($job_id){

        $sql = "SELECT * FROM `job` WHERE  job_id = :job_id ";
        $params[':job_id'] = $job_id;
        $statement = $this->db->prepare($sql);
        $statement->execute($params);
        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }

    public function get_seq_id($job_id){

        $sql = "SELECT * FROM `sequence` WHERE  sequence_enable = '1' AND job_id = :job_id ";
        $params[':job_id'] = $job_id;
        $statement = $this->db->prepare($sql);
        $statement->execute($params);
        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }

     #用job_id及sequence_id 找出對應的task_id
     public function get_task_id($job_id, $seq_id) {

        $sql = "SELECT * FROM `task` WHERE job_id = :job_id AND seq_id = :seq_id ";
        $params[':job_id'] = $job_id;
        $params[':seq_id'] = $seq_id;
        $statement = $this->db->prepare($sql);
        $statement->execute($params);

        $result = $statement->fetchall(PDO::FETCH_ASSOC);
        return $result;
    }


    public function meter_info(){

        $temp = array();

        $a = 0.6;
        $b = 0.06;

        $sql ="SELECT 
                (SELECT MAX(torque) FROM calibrations) AS max_torque,
                (SELECT MIN(torque) FROM calibrations) AS min_torque,
                (SELECT SUM(torque) FROM calibrations) AS total_torque,
                *
            FROM
                calibrations 
            ORDER BY
                id ASC;
            ";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);

        #依照KTM 文件裡的算式 
        $hi_limit_torque =  $a+$b;

        $temp['hi_limit_torque'] = $a + $b;
        $temp['low_limit_torque'] = $a - $b;
        $temp['max_torque'] = $result[0]['max_torque'] ?? null; 
        $temp['min_torque'] = $result[0]['min_torque'] ?? null; 
        $temp['avg_torque'] = $result[0]['avg_torque'] ?? null; 

        return  $result;

    } 

    public function get_tools_sn(){
        $sql = "SELECT * FROM `fasten_data`   ORDER BY system_sn   DESC LIMIT 1"; // 假设 `created_at` 是时间戳列
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $latestData = $statement->fetch(PDO::FETCH_ASSOC); // 获取最新的一笔数据

        if ($latestData) {
            // 成功获取数据
            return $latestData;
        } else {
            // 没有找到数据
            return null;
        }          
    }

    
    public function tidy_data($final, $tools_sn) {
        $job_id = 221;
    
        // 獲取當前的最大、最小、總扭矩以及最新記錄ID
        $sql = "SELECT MAX(torque) AS max_torque, MIN(torque) AS min_torque, SUM(torque) AS total_torque,
                (SELECT id FROM calibrations ORDER BY id DESC LIMIT 1) AS latest_id
                FROM calibrations";
        $statement = $this->db->prepare($sql);
        $statement->execute();
        $result = $statement->fetch(PDO::FETCH_ASSOC);
    
        // 獲取記錄總數
        $sql_total = "SELECT COUNT(*) AS total_records FROM calibrations";
        $statement = $this->db->prepare($sql_total);
        $statement->execute();
        $result_total = $statement->fetch(PDO::FETCH_ASSOC);
    
        // 計算新的 ID
        $count = (int)$result['latest_id'] + 1;
    
        if ($result) {
            // 處理扭力值
            $max_torque = max(floatval($result['max_torque']), floatval($final));
            $min_torque = min(floatval($result['min_torque']), floatval($final));
            $total_torque = floatval($result['total_torque']);
    
            // 計算平均扭力和百分比
            $average_torque = round(($total_torque + $final) / $count, 2);
            $high_percent = round((($max_torque - $average_torque) / $average_torque) * 100, 2);
            $low_percent = round((($min_torque - $average_torque) / $average_torque) * 100, 2);

            $datatime = date("Ymd H:i:s");
    
            // 插入新記錄
            $sql_in = "INSERT INTO `calibrations` (`id`, `job_id`, `controller_type`, `ktm_type`, `adapter_type`, 
                         `operator`, `toolsn`, `torque`, `unit`, `max_torque`, `min_torque`, `avg_torque`, 
                         `high_percent`, `low_percent`, `customize`, `datatime`)
                       VALUES (:id, :job_id, :controller_type, :ktm_type, :adapter_type, :operator, 
                       :toolsn, :torque, :unit, :max_torque, :min_torque, :avg_torque, 
                       :high_percent, :low_percent, :customize, :datatime)";
    
            $statement = $this->db->prepare($sql_in);
            if (!$statement) {
                echo "Prepare 失敗: " . implode(":", $this->db->errorInfo());
                return false; 
            }
    
            // 绑定參數
            $this->bindInsertParameters($statement, $count, $job_id, $tools_sn, $final, $max_torque, $min_torque, $average_torque, $high_percent, $low_percent, $datatime);
            
            // 執行插入
            if (!$statement->execute()) {
                echo "執行失敗: " . implode(":", $statement->errorInfo());
                return false; // 處理錯誤
            }
    
            // 更新最小和最大扭矩
            $this->updateMinMaxTorque($min_torque, $max_torque);
    
            return true; // 插入成功
        }
    
        return false; // 無結果
    }
    
    // 绑定插入參數
    private function bindInsertParameters($statement, $count, $job_id, $tools_sn, $final, $max_torque, $min_torque, $average_torque, $high_percent, $low_percent, $datatime) {
        $statement->bindValue(':id', $count);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':controller_type', $_SESSION['torqueMeter']);
        $statement->bindValue(':ktm_type', $_SESSION['controller']);
        $statement->bindValue(':adapter_type', $_SESSION['adapter_type']);
        $statement->bindValue(':operator', $_SESSION['user']);
        $statement->bindValue(':toolsn', $tools_sn['device_sn']);
        $statement->bindValue(':torque', $final);
        $statement->bindValue(':unit', '1');
        $statement->bindValue(':max_torque', $max_torque);
        $statement->bindValue(':min_torque', $min_torque);
        $statement->bindValue(':avg_torque', $average_torque);
        $statement->bindValue(':high_percent', $high_percent);
        $statement->bindValue(':low_percent', $low_percent);
        $statement->bindValue(':customize', '');
        $statement->bindValue(':datatime', $datatime);
    }
    
    // 更新最小和最大扭力
    private function updateMinMaxTorque($min_torque, $max_torque) {
        // 更新第一筆的 min_torque
        $sql_update_min = "UPDATE calibrations SET min_torque = :new_min_torque WHERE id = 1";
        $stmt_update_min = $this->db->prepare($sql_update_min);
        $stmt_update_min->bindValue(':new_min_torque', $min_torque);
        $stmt_update_min->execute();
    
        // 更新所有記錄的 max_torque
        $sql_update_max = "UPDATE calibrations SET max_torque = (SELECT MAX(torque) FROM calibrations)";
        $stmt_update_max = $this->db->prepare($sql_update_max);
        $stmt_update_max->execute();


        // 更新所有記錄的 min_torque
        $sql_update_min = "UPDATE calibrations SET min_torque = (SELECT MIN(torque) FROM calibrations)";
        $stmt_update_min = $this->db->prepare($sql_update_min);
        $stmt_update_min->execute();

        


    }
    
    
    public function del_all() {
        try {
            $sql_delete = "DELETE FROM `calibrations`"; 
            $statement_delete = $this->db->prepare($sql_delete);
            
            if ($statement_delete->execute()) {
                return true; 
            } else {
                return false; 
            }
        } catch (Exception $e) {
          
            return false; 
        }
    }
    
    

    public function del_info($lastid) {

        # STEP1：使用指定的 id 刪除 calibrations 表中的記錄
        $sql_delete = "DELETE FROM `calibrations` WHERE id = :id";
        $statement_delete = $this->db->prepare($sql_delete);
        $statement_delete->bindValue(':id', $lastid);
        $statement_delete->execute();
    
        # STEP2：更新所有大於被刪除 id 的記錄的 id
        $sql_update_ids = "UPDATE `calibrations` SET id = id - 1 WHERE id > :lastid";
        $statement_update_ids = $this->db->prepare($sql_update_ids);
        $statement_update_ids->bindValue(':lastid', $lastid);
        $statement_update_ids->execute();
    
        # STEP3：計算 max_torque、min_torque、average_torque、high_percent 和 low_percent
        $sql_select = "SELECT MAX(torque) AS max_torque, MIN(torque) AS min_torque, AVG(torque) AS average_torque, COUNT(*) AS count FROM calibrations";
        $stmt_select = $this->db->query($sql_select);
        $result = $stmt_select->fetch(PDO::FETCH_ASSOC);
    
        $max_torque = $result['max_torque'];
        $min_torque = $result['min_torque'];
        $total_torque = $result['average_torque'] * $result['count']; // 計算總扭力
        $count = $result['count'];
    
        # STEP4：計算新的 average_torque、high_percent 和 low_percent
        if ($count > 0) {
            $average_torque = round(($total_torque + $max_torque) / ($count + 1), 2);
            $high_percent = round((($max_torque - $average_torque) / $average_torque) * 100, 2);
            $low_percent = round((($min_torque - $average_torque) / $average_torque) * 100, 2);
        } else {
            $average_torque = 0;
            $high_percent = 0;
            $low_percent = 0;
        }
    
        # STEP5：更新 max_torque、min_torque、average_torque、high_percent 和 low_percent
        $sql_update = "UPDATE calibrations SET max_torque = :new_max_torque, min_torque = :new_min_torque, avg_torque = :new_avg_torque, high_percent = :new_high_percent, low_percent = :new_low_percent";
        $stmt_update = $this->db->prepare($sql_update);
        $stmt_update->bindParam(':new_max_torque', $max_torque, PDO::PARAM_STR);
        $stmt_update->bindParam(':new_min_torque', $min_torque, PDO::PARAM_STR);
        
        // 如果當前表中沒有數據，則將 min_torque 設置為 0
        if ($count === 0) {
            $min_torque = 0;
        }



        # high_percent 的計算方式 : round((($max_torque - $average_torque) / $average_torque) * 100, 2);
        # low_percent  的計算方式 : round((($min_torque - $average_torque) / $average_torque) * 100, 2);


        # STEP6：逐一更新每一筆的 high_percent 和 low_percent
        $sql_select_all = "SELECT id, max_torque, min_torque, avg_torque FROM calibrations";
        $stmt_select_all = $this->db->query($sql_select_all);
        $records = $stmt_select_all->fetchAll(PDO::FETCH_ASSOC);

        foreach ($records as $record) {
            $high_percent = round(($record['max_torque'] - $record['avg_torque']) / $record['avg_torque'] * 100, 2);
            $low_percent  = round(($record['min_torque'] - $record['avg_torque']) / $record['avg_torque'] * 100, 2);
            
            $sql_update_single = "UPDATE calibrations SET high_percent = :high_percent, low_percent = :low_percent WHERE id = :id";
            $stmt_update_single = $this->db->prepare($sql_update_single);
            $stmt_update_single->bindParam(':high_percent', $high_percent);
            $stmt_update_single->bindParam(':low_percent', $low_percent);
            $stmt_update_single->bindParam(':id', $record['id']);
            $stmt_update_single->execute();
        }

    
      
        return $result;
    }


    public function get_last_record() {
        $sql = "SELECT *  FROM calibrations ORDER BY id DESC LIMIT 1 "; 
        $statement = $this->db->prepare($sql);
        $statement->execute();
        
        $result = $statement->fetch(PDO::FETCH_ASSOC); 

        if(!empty($result)){
            $avg = $result['avg_torque'];
        }
        return $avg;        
    }

    /*public function get_count(){

        $sql_count     = "SELECT COUNT(*) AS total_records FROM calibrations";
        $stmt_count    = $this->db->query($sql_count);
        $result_count  = $stmt_count->fetch(PDO::FETCH_ASSOC);
        $total_records = $result_count['total_records'];    

        $implement_count = isset($_COOKIE['implement_count']) ? intval($_COOKIE['implement_count']) : 0;

        return [
            'total_records' => $total_records,
            'implement_count' => $implement_count,
        ];
    }*/
    
    
    
    
}
