<?php

class Product{
    private $db;//condb control box

    // 在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();
    }

    // 取得所有Job
    public function getJobs()
    {
        $sql = "SELECT
                  job.*,
                  COUNT(DISTINCT seq.seq_id) AS seq_count,
                  COUNT(DISTINCT task.task_id) AS task_count
                FROM
                  job
                LEFT JOIN
                  sequence as seq ON job.job_id = seq.job_id
                LEFT JOIN
                  task ON seq.seq_id = task.seq_id AND seq.job_id = task.job_id
                GROUP BY
                  job.job_id;
                ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchall();
    }

    // 取得Job by job id
    public function getJobById($job_id)
    {
        $sql = "SELECT *  FROM `job` WHERE job_id = :job_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->execute();

        return $statement->fetch(PDO::FETCH_ASSOC);
    }

    //編輯or新增job
    public function EditJob($data)
    {
        if( $this->CheckJobExist($data['job_id']) ){ //已存在，用update

            $sql = "UPDATE `job` 
                    SET job_name = :job_name,
                        controller_id = :controller_id,
                        ok_job = :ok_job,
                        ok_job_stop = :ok_job_stop,
                        reverse_direction = :reverse_direction,
                        reverse_rpm = :reverse_rpm,
                        reverse_force = :reverse_force,
                        reverse_cnt_mode = :reverse_cnt_mode,
                        reverse_threshold_torque = :reverse_threshold_torque,
                        point_size = :point_size,
                        barcode_start = :barcode_start,
                        tower_light = :tower_light
                    WHERE job_id = :job_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_name', $data['job_name']);
            $statement->bindValue(':controller_id', $data['controller_type']);
            $statement->bindValue(':ok_job', $data['ok_job']);
            $statement->bindValue(':ok_job_stop', $data['ok_job_stop']);
            $statement->bindValue(':reverse_direction', $data['reverse_button']);
            $statement->bindValue(':reverse_rpm', $data['reverse_rpm']);
            $statement->bindValue(':reverse_force', $data['reverse_Force']);
            $statement->bindValue(':reverse_cnt_mode', $data['reverse_count']);
            $statement->bindValue(':reverse_threshold_torque', $data['threshold_torque']);
            $statement->bindValue(':point_size', $data['size']);
            $statement->bindValue(':barcode_start', $data['barcode_start']);
            $statement->bindValue(':tower_light', $data['tower_light']);
            $statement->bindValue(':job_id', $data['job_id']);
            $results = $statement->execute();

        }else{ //不存在，用insert
            $data['tower_light'] = 0;
            $sql = "INSERT INTO `job` ('job_id','job_name','controller_id','ok_job','ok_job_stop','reverse_direction','reverse_rpm','reverse_force','reverse_cnt_mode','reverse_threshold_torque','point_size','barcode_start','tower_light' )
                    VALUES (:job_id,:job_name,:controller_id,:ok_job,:ok_job_stop,:reverse_direction,:reverse_rpm,:reverse_force,:reverse_cnt_mode,:reverse_threshold_torque,:point_size,:barcode_start,:tower_light)";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_name', $data['job_name']);
            $statement->bindValue(':controller_id', $data['controller_type']);
            $statement->bindValue(':ok_job', $data['ok_job']);
            $statement->bindValue(':ok_job_stop', $data['ok_job_stop']);
            $statement->bindValue(':reverse_direction', $data['reverse_button']);
            $statement->bindValue(':reverse_rpm', $data['reverse_rpm']);
            $statement->bindValue(':reverse_force', $data['reverse_Force']);
            $statement->bindValue(':reverse_cnt_mode', $data['reverse_count']);
            $statement->bindValue(':reverse_threshold_torque', $data['threshold_torque']);
            $statement->bindValue(':point_size', $data['size']);
            $statement->bindValue(':barcode_start', $data['barcode_start']);
            $statement->bindValue(':tower_light', $data['tower_light']);
            $statement->bindValue(':job_id', $data['job_id']);
            $results = $statement->execute();

        }

        return $results;
    }

    //檢查job id是否已存在
    public function CheckJobExist($job_id)
    {
        $sql = "SELECT count(*) as count FROM job WHERE job_id = :job_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function SetJobImage($job_id,$img_url)
    {
        $sql = "UPDATE `job` 
                    SET img = :img 
                    WHERE job_id = :job_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':img', $img_url);
            $results = $statement->execute();

        return $results;
    }

    public function DeleteJobById($job_id)
    {

        //先找到該job 是否有存取圖片
        $stmt = $this->db->prepare('SELECT img FROM job WHERE job_id = :job_id');
        $stmt->bindValue(':job_id', $job_id);
        $stmt->execute();
        $job = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($job && !empty($job['img'])) {
            $imgPath = $job['img'];
            if (file_exists($imgPath)) {
                unlink($imgPath);
            }
        }
        
        $stmt = $this->db->prepare('DELETE FROM job WHERE job_id = :job_id');
        $stmt->bindValue(':job_id', $job_id);
        $results = $stmt->execute();


        //找到該job的sequence 是否有存取圖片
        $stmt = $this->db->prepare('SELECT img FROM sequence WHERE job_id = :job_id');
        $stmt->bindValue(':job_id', $job_id);
        $stmt->execute();
        $seq = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($seq && !empty($seq['img'])) {
            $imgPath_seq = $seq['img'];
            if (file_exists($imgPath_seq)) {
                unlink($imgPath_seq);
            }
        }

        

        //刪除sequence
        $stmt = $this->db->prepare('DELETE FROM sequence WHERE job_id = :job_id');
        $stmt->bindValue(':job_id', $job_id);
        $results = $stmt->execute();

        //刪除task
        $stmt = $this->db->prepare('DELETE FROM task WHERE job_id = :job_id');
        $stmt->bindValue(':job_id', $job_id);
        $results = $stmt->execute();

        //刪除其他關聯
        //刪除ccs_normalstep、ccs_advancedstep
        //delete ccs_normalstep
        $statement = $this->db->prepare('DELETE FROM ccs_normalstep WHERE job_id = :job_id ');
        $statement->bindValue(':job_id', $job_id);
        $results = $statement->execute();
        //delete ccs_advancedstep
        $statement = $this->db->prepare('DELETE FROM ccs_advancedstep WHERE job_id = :job_id ');
        $statement->bindValue(':job_id', $job_id);
        $results = $statement->execute();

        //刪除task_message
        $statement = $this->db->prepare('DELETE FROM task_message WHERE job_id = :job_id ');
        $statement->bindValue(':job_id', $job_id);
        $results = $statement->execute();


        

        
        return $results;
    }

    // public function CopyJob($from_job_id,$to_job_id,$to_job_name)
    // {
    //     $stmt = $this->db->prepare('DELETE FROM job WHERE job_id = :job_id');
    //     $stmt->bindValue(':job_id', $job_id);
    //     $results = $stmt->execute();
        
    //     return $results;
    // }

    public function CopyJob($from_job_id,$to_job_id,$to_job_name){
        // 判斷job_id是否存在，若存在就先把舊的刪除
        // $dupli_flag true:表示job_id已存在 false:表示job_id不存在
        $dupli_flag = $this->CheckJobExist($to_job_id);

        if($dupli_flag){
            $this->DeleteJobById($to_job_id);
        }
        $sql= "INSERT INTO job ( job_id,job_name,controller_id,ok_job,ok_job_stop,reverse_force,reverse_rpm,reverse_direction,reverse_cnt_mode,reverse_threshold_torque,point_size,img )
            SELECT  :to_job_id,:to_job_name,controller_id,ok_job,ok_job_stop,reverse_force,reverse_rpm,reverse_direction,reverse_cnt_mode,reverse_threshold_torque,point_size,img
            FROM    job
            WHERE job_id = :job_id ";
        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':to_job_id', $to_job_id);
        $stmt->bindValue(':to_job_name', $to_job_name);
        $stmt->bindValue(':job_id', $from_job_id);

        return $results = $stmt->execute();
    }


    public function check_seq_by_job_id($from_job_id,$to_job_id){
        
        #用$to_job_id 
        #找出有為對應的資料 如果有的話就要刪除
        $query = "SELECT  COUNT(*) AS count FROM sequence WHERE job_id = ?";
        $statement_select = $this->db->prepare($query);
        $statement_select->execute([$to_job_id]);
        $row = $statement_select->fetch(PDO::FETCH_ASSOC);

        if ($row['count'] > 0) {
            $sql_delete = "DELETE FROM sequence WHERE job_id = ?";
            $statement_delete = $this->dbs->prepare($sql_delete);
            $results = $statement_delete->execute([$from_job_id]);
        }

        #用from_job_id
        #找出有為對應的資料 
        $sql= " SELECT *  FROM sequence WHERE job_id = ? ";
        $statement = $this->db->prepare($sql);
        $statement->execute([$from_job_id]);
        return $statement->fetchall();

    }

    public function check_pro_id_for_ccs_normalstep($from_job_id){

        $query = "SELECT * FROM ccs_normalstep WHERE job_id = ? ";
        $statement_select = $this->db->prepare($query);

        $statement_select->execute([$from_job_id]);
        $statement_select->execute();
        $result = $statement_select->fetchAll(PDO::FETCH_ASSOC);
 
        return $result;


    }

    public function check_pro_id_for_ccs_advancedstep($from_job_id){

        $query = "SELECT * FROM ccs_advancedstep WHERE job_id = ? ";
        $statement_select = $this->db->prepare($query);

        $statement_select->execute([$from_job_id]);
        $statement_select->execute();
        $result = $statement_select->fetchAll(PDO::FETCH_ASSOC);
     
        return $result;


    }


    public function check_task_by_job_id($from_job_id,$to_job_id){
        #用$to_job_id 
        #找出有為對應的資料 如果有的話就要刪除

        $query = "SELECT  COUNT(*) AS count FROM  task WHERE job_id = ?";
        $statement_select = $this->db->prepare($query);
        $statement_select->execute([$to_job_id]);
        $row = $statement_select->fetch(PDO::FETCH_ASSOC);

        if ($row['count'] > 0) {
            $sql_delete = "DELETE FROM task WHERE job_id = ?";
            $statement_delete = $this->dbs->prepare($sql_delete);
            $results = $statement_delete->execute([$from_job_id]);
        }

        #用from_job_id
        #找出有為對應的資料 
        $sql= " SELECT *  FROM task WHERE job_id = ? ";
        $statement = $this->db->prepare($sql);
        $statement->execute([$from_job_id]);
        return $statement->fetchall();

    }

    public function Copy_seq_by_job_id($new_temp_seq) {
        $sql = "INSERT INTO `sequence` (sequence_enable, job_id, seq_id, seq_name, img, tightening_repeat, ng_stop, ok_sequence, ok_sequence_stop, sequence_mintime, sequence_maxtime, barcode_start)";
        $sql .= " VALUES (:sequence_enable, :job_id, :seq_id, :seq_name, :img, :tightening_repeat, :ng_stop, :ok_sequence, :ok_sequence_stop, :sequence_mintime, :sequence_maxtime, :barcode_start)";
    
        $statement = $this->db->prepare($sql);
        $insertedrecords = 0;
    
        foreach ($new_temp_seq as $seq) {
           
            if(empty($seq['img'])){
                $seq['img'] = ''; 
            }
        
            $statement->bindParam(':sequence_enable', $seq['sequence_enable'], PDO::PARAM_INT);
            $statement->bindParam(':job_id', $seq['job_id'], PDO::PARAM_INT);
            $statement->bindParam(':seq_id', $seq['seq_id'], PDO::PARAM_INT);
            $statement->bindParam(':seq_name', $seq['seq_name'], PDO::PARAM_STR);
            $statement->bindParam(':img', $seq['img'], PDO::PARAM_STR);
            $statement->bindParam(':tightening_repeat', $seq['tightening_repeat'], PDO::PARAM_INT);
            $statement->bindParam(':ng_stop', $seq['ng_stop'], PDO::PARAM_INT);
            $statement->bindParam(':ok_sequence', $seq['ok_sequence'], PDO::PARAM_INT);
            $statement->bindParam(':ok_sequence_stop', $seq['ok_sequence_stop'], PDO::PARAM_INT);
            $statement->bindParam(':sequence_mintime', $seq['sequence_mintime'], PDO::PARAM_INT);
            $statement->bindParam(':sequence_maxtime', $seq['sequence_maxtime'], PDO::PARAM_INT);
            $statement->bindParam(':barcode_start', $seq['barcode_start'], PDO::PARAM_INT);
    
            if ($statement->execute()) {
                $insertedrecords++;
            } else {
                //print_r($statement->errorInfo());
                error_log("SQL Insert Error: " . implode(" - ", $statement->errorInfo()));
            }
        }
    
        return $insertedrecords;
    }


    public function Copy_task_by_job_id($new_temp_task){

        $sql = "INSERT INTO `task` (job_id, seq_id, task_id, controller, enable_equipment, enable_arm, position_x, position_y, tolerance, tolerance2, pts, template_program_id, circle_div, delay)";
        $sql .= " VALUES (:job_id, :seq_id, :task_id, :controller, :enable_equipment, :enable_arm, :position_x, :position_y, :tolerance, :tolerance2, :pts, :template_program_id, :circle_div, :delay)";

        $statement = $this->db->prepare($sql);
        $insertedRecords_task = 0;

        foreach ($new_temp_task as $task) {
            if ($statement->execute($task)) {
                $insertedRecords_task++;
            } else {
                print_r($statement->errorInfo());
                
            }
        }

        return $insertedRecords_task;
    }
    


    
    //取得job id，依job_type判斷
    public function get_head_job_id(){

        $query = "SELECT job_id FROM job ";

        $statement = $this->db->prepare($query);
        $statement->execute();

        $result = $statement->fetch();
        if ($result == false || empty($result) ){
            return array('0'=> 1, 'missing_id' => 1);
        }

        $query = "SELECT job_id + 1 AS missing_id
                  FROM job
                  WHERE (job_id + 1) NOT IN ( SELECT job_id FROM job  ) order by  missing_id limit 1";

        $statement = $this->db->prepare($query);
        $statement->execute();

        return $statement->fetch();
    }

    //barcode function

    public function EditBarcode($barcode,$match_from,$match_to,$job_id,$seq_id)
    {
        if( $this->CheckBarcodeRepeat($barcode,$match_from,$match_to,$job_id,$seq_id) ){ //重複barcode

            return 'repeat';
        }


        if( $this->CheckBarcodeExist($job_id,$seq_id) ){ //已存在，用update

            $sql = "UPDATE `barcode` 
                    SET barcode = :barcode,
                        barcode_mask_from = :barcode_mask_from,
                        barcode_mask_count = :barcode_mask_count 
                    WHERE barcode_selected_job = :job_id AND barcode_selected_seq = :seq_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':barcode', $barcode);
            $statement->bindValue(':barcode_mask_from', $match_from);
            $statement->bindValue(':barcode_mask_count', $match_to);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $results = $statement->execute();

        }else{ //不存在，用insert

            $sql = "INSERT INTO `barcode` ('barcode','barcode_mask_from','barcode_mask_count','barcode_selected_job','barcode_selected_seq' )
                    VALUES (:barcode,:barcode_mask_from,:barcode_mask_count,:job_id,:seq_id)";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':barcode', $barcode);
            $statement->bindValue(':barcode_mask_from', $match_from);
            $statement->bindValue(':barcode_mask_count', $match_to);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $results = $statement->execute();

        }

        return $results;
    }

    public function CheckBarcodeExist($job_id,$seq_id)
    {
        $sql = "SELECT count(*) as count FROM barcode WHERE barcode_selected_job = :barcode_selected_job AND barcode_selected_seq = :barcode_selected_seq  ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':barcode_selected_job', $job_id);
        $statement->bindValue(':barcode_selected_seq', $seq_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function CheckBarcodeRepeat($barcode,$match_from,$match_to,$job_id,$seq_id)
    {
        $barcode_length = strlen($barcode);
        $target = substr($barcode, $match_from-1, $match_to);
        $sql = "SELECT *,count(*) as count FROM barcode WHERE  barcode_mask_from = :barcode_mask_from AND barcode_mask_count = :barcode_mask_count AND length(barcode) = :barcode_length AND substr(barcode,barcode_mask_from,barcode_mask_count) = :target ";

        $statement = $this->db->prepare($sql);
        $statement->bindValue(':target', $target);
        $statement->bindValue(':barcode_length', $barcode_length, PDO::PARAM_INT);
        $statement->bindValue(':barcode_mask_from', $match_from);
        $statement->bindValue(':barcode_mask_count', $match_to);
        $results = $statement->execute();
        $row = $statement->fetch();

        if ($row['count'] > 0) {
            if($row['barcode_selected_job'] == $job_id && $row['barcode_selected_seq'] == $seq_id){
                return false;
            }
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function getBarcodes($value='')
    {
        $sql = "SELECT barcode.*,job_name, seq_name FROM barcode 
                left join job on barcode.barcode_selected_job = job.job_id
                left join sequence on barcode.barcode_selected_seq = sequence.seq_id AND barcode.barcode_selected_job = sequence.job_id
                ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);
    }

    public function DeleteBarcode($id)
    {
        $stmt = $this->db->prepare('DELETE FROM barcode WHERE id = :id');
        $stmt->bindValue(':id', $id);
        $results = $stmt->execute();

        return $results;
    }

    public function cover_data($new_array, $table_name) {
        $insertedCount = 0;

        if( $table_name == 'ccs_normalstep'){
            foreach ($new_array as $item) {
                $sql = "INSERT INTO $table_name (
                    job_id, seq_id, task_id, step_name, step_targettype, step_targetangle, step_targettorque,
                    step_tooldirection, step_rpm, step_offsetdirection, step_torque_jointoffset, step_hightorque,
                    step_lowtorque, step_threshold_mode, step_threshold_torque, step_threshold_angle, step_monitoringangle,
                    step_highangle, step_lowangle, step_downshift_enable, step_downshift_torque, step_downshift_speed,
                    torque_unit, step_prr, step_prr_rpm, step_prr_angle, step_downshift_mode, step_downshift_angle,gtcs_job_id
                ) VALUES (
                    :job_id, :seq_id, :task_id, :step_name, :step_targettype, :step_targetangle, :step_targettorque,
                    :step_tooldirection, :step_rpm, :step_offsetdirection, :step_torque_jointoffset, :step_hightorque,
                    :step_lowtorque, :step_threshold_mode, :step_threshold_torque, :step_threshold_angle, :step_monitoringangle,
                    :step_highangle, :step_lowangle, :step_downshift_enable, :step_downshift_torque, :step_downshift_speed,
                    :torque_unit, :step_prr, :step_prr_rpm, :step_prr_angle, :step_downshift_mode, :step_downshift_angle,:gtcs_job_id
                )";
                
                $statement = $this->db->prepare($sql);
        
                if ($statement === false) {
                    $errorInfo = $this->db->errorInfo();
                    echo "SQL 错误: " . $errorInfo[2];
                    return; // 退出函数
                }
        
                if ($statement->execute([
                    'job_id' => $item['job_id'],
                    'seq_id' => $item['seq_id'],
                    'task_id' => $item['task_id'],
                    'step_name' => $item['step_name'],
                    'step_targettype' => $item['step_targettype'],
                    'step_targetangle' => $item['step_targetangle'],
                    'step_targettorque' => $item['step_targettorque'],
                    'step_tooldirection' => $item['step_tooldirection'],
                    'step_rpm' => $item['step_rpm'],
                    'step_offsetdirection' => $item['step_offsetdirection'],
                    'step_torque_jointoffset' => $item['step_torque_jointoffset'],
                    'step_hightorque' => $item['step_hightorque'],
                    'step_lowtorque' => $item['step_lowtorque'],
                    'step_threshold_mode' => $item['step_threshold_mode'],
                    'step_threshold_torque' => $item['step_threshold_torque'],
                    'step_threshold_angle' => $item['step_threshold_angle'],
                    'step_monitoringangle' => $item['step_monitoringangle'],
                    'step_highangle' => $item['step_highangle'],
                    'step_lowangle' => $item['step_lowangle'],
                    'step_downshift_enable' => $item['step_downshift_enable'],
                    'step_downshift_torque' => $item['step_downshift_torque'],
                    'step_downshift_speed' => $item['step_downshift_speed'],
                    'torque_unit' => $item['torque_unit'],
                    'step_prr' => $item['step_prr'],
                    'step_prr_rpm' => $item['step_prr_rpm'],
                    'step_prr_angle' => $item['step_prr_angle'],
                    'step_downshift_mode' => $item['step_downshift_mode'],
                    'step_downshift_angle' => $item['step_downshift_angle'],
                    'gtcs_job_id' =>$item['gtcs_job_id']

                ])) {
                    $insertedCount++;
                } else {
                    $errorInfo = $statement->errorInfo();
                    echo "插入失败: " . $errorInfo[2];
                }
            }
        }
        if( $table_name == 'ccs_advancedstep'){
            foreach ($new_array as $item) {
                $sql = "INSERT INTO $table_name ('job_id','seq_id','task_id','step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_delayttime','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_monitoringmode','step_torwin_target','step_torquewindow','step_angwin_target','step_anglewindow','step_hightorque','step_lowtorque','step_monitoringangle','step_highangle','step_lowangle','torque_unit','step_angle_mode','step_slope','gtcs_job_id' )
                    VALUES ( :job_id,:seq_id,:task_id,:step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_delayttime,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_monitoringmode,:step_torwin_target,:step_torquewindow,:step_angwin_target,:step_anglewindow,:step_hightorque,:step_lowtorque,:step_monitoringangle,:step_highangle,:step_lowangle,:torque_unit,:step_angle_mode,:step_slope,:gtcs_job_id )";
                
                $statement = $this->db->prepare($sql);
        
                if ($statement === false) {
                    $errorInfo = $this->db->errorInfo();
                    echo "SQL 错误: " . $errorInfo[2];
                    return; // 退出函数
                }
        
                if ($statement->execute([
                    'job_id' => $item['job_id'],
                    'seq_id' => $item['seq_id'],
                    'task_id' => $item['task_id'],
                    'step_id' => $item['step_id'],
                    'step_name' => $item['step_name'],
                    'step_targettype' => $item['step_targettype'],
                    'step_targetangle' => $item['step_targetangle'],
                    'step_targettorque' => $item['step_targettorque'],
                    'step_delayttime' => 0,
                    'step_tooldirection' => $item['step_tooldirection'],
                    'step_rpm' => $item['step_rpm'],
                    'step_offsetdirection' => $item['step_offsetdirection'],
                    'step_torque_jointoffset' => $item['step_torque_jointoffset'],
                    'step_monitoringmode' => $item['step_monitoringmode'],
                    'step_torwin_target' => $item['step_torwin_target'],
                    'step_torquewindow' => $item['step_torquewindow'],
                    'step_angwin_target' => $item['step_angwin_target'],
                    'step_anglewindow' => $item['step_anglewindow'],
                    'step_hightorque' => $item['step_hightorque'],
                    'step_lowtorque' => $item['step_lowtorque'],
                    'step_monitoringangle' => $item['step_monitoringangle'],                    
                    'step_highangle' => $item['step_highangle'],
                    'step_lowangle' => $item['step_lowangle'],
                    'torque_unit' => $item['torque_unit'],
                    'step_angle_mode' => $item['step_angle_mode'],
                    'step_slope' => $item['step_slope'],
                    'gtcs_job_id' => $item['gtcs_job_id'],

                ])) {
                    $insertedCount++;
                } else {
                    $errorInfo = $statement->errorInfo();
                    echo "插入失败: " . $errorInfo[2];
                }
            }
        }
        
        
    
        return $insertedCount;
    }


    public function check_task_message_by_id($from_job_id){

        $sql= "SELECT * FROM `task_message` WHERE job_id = :job_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $from_job_id);
      
       
        $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC); 
      
        return $rows;
    }

    public function get_task_message_data($new_temp_task_message){
        $sql = "INSERT INTO `task_message` (job_id, seq_id, task_id, img, type, text, timeout)
                VALUES (:job_id, :seq_id, :task_id, :img, :type, :message, :message_timeout)";
        
        $statement = $this->db->prepare($sql);

        foreach ($new_temp_task_message as $task_message) {
  
            if (isset($task_message['job_id'], $task_message['seq_id'], $task_message['task_id'], $task_message['img'], $task_message['type'], $task_message['text'], $task_message['timeout'])) {
              
                $statement->bindValue(':job_id', $task_message['job_id']);
                $statement->bindValue(':seq_id', $task_message['seq_id']);
                $statement->bindValue(':task_id', $task_message['task_id']);
                $statement->bindValue(':img', $task_message['img']);
                $statement->bindValue(':message', $task_message['text']);
                $statement->bindValue(':type', $task_message['type']);
                $statement->bindValue(':message_timeout', $task_message['timeout']);

                $results = $statement->execute();
    
            } 
        }

        return $results;
    }
    
    

}
