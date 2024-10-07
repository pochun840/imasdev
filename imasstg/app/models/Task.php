<?php

class Task{
    private $db;//condb control box

    // 在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();
    }

    // 取得所有Task
    public function getTasks($job_id,$seq_id)
    {
        $sql = "SELECT task.*,ccs.gtcs_job_id,ccs_a.gtcs_job_id,tst.hole_id FROM `task` 
                LEFT JOIN ccs_normalstep as ccs on task.job_id = ccs.job_id and task.seq_id = ccs.seq_id and task.task_id = ccs.task_id 
                LEFT JOIN ccs_advancedstep as ccs_a on task.job_id = ccs_a.job_id and task.seq_id = ccs_a.seq_id and task.task_id = ccs_a.task_id 
                LEFT JOIN task_socket_tray as tst on task.job_id = tst.job_id and task.seq_id = tst.seq_id and task.task_id = tst.task_id 
                WHERE task.job_id = :job_id AND task.seq_id = :seq_id GROUP BY task.task_id ORDER BY task_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->execute();

        $results = $statement->fetchall(PDO::FETCH_ASSOC);

        // var_dump($results);

        //加入task底下的program
        foreach ($results as $key => $value) {

            $program = $this->GetTaskProgram($job_id,$seq_id,$value['task_id']);

            $results[$key]['program'] = $program;
        }

        return $results;
    }

    // 取得所有Task
    public function getScrewTemplate()
    {
        $sql = "SELECT * FROM `gtcs_sequence_template` ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);
    }

    //取得job id，依job_type判斷
    public function get_head_task_id($job_id,$seq_id){

        $query = "SELECT task_id FROM task where job_id = :job_id AND seq_id = :seq_id ";

        $statement = $this->db->prepare($query);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->execute();

        $result = $statement->fetch();
        if ($result == false || empty($result) ){
            return array('0'=> 1, 'missing_id' => 1);
        }

        $query = "SELECT task_id + 1 AS missing_id
                  FROM task
                  WHERE (task_id + 1) NOT IN ( SELECT task_id FROM task where job_id = :job_id AND seq_id = :seq_id ) order by  missing_id limit 1";

        $statement = $this->db->prepare($query);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->execute();

        $result = $statement->fetch();
        if ($result == false || empty($result) ){
            return array('0'=> 1, 'missing_id' => 1);
        }

        return $result;
    }

    public function CheckTaskExist($job_id,$seq_id,$task_id)
    {
        $sql = "SELECT count(*) as count FROM task WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // task 已存在
        }else{
            return false; // task 不存在
        }
    }

    public function EditTask($data)
    {
        if( $this->CheckTaskExist( $data['job_id'],$data['seq_id'],$data['task_id'] ) ){ //已存在，用update

            $sql = "UPDATE `task` 
                    SET controller = :controller,
                        enable_equipment = :enable_equipment,
                        position_x = :position_x,
                        position_y = :position_y,
                        tolerance = :tolerance,
                        tolerance2 = :tolerance2,
                        pts = :pts,
                        circle_div = :circle_div,
                        delay = :delay,
                        enable_arm = :enable_arm,
                        template_program_id = :template_program_id
                    WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':controller', $data['controller_id']);
            $statement->bindValue(':enable_equipment', '');
            $statement->bindValue(':position_x', $data['position_x']);
            $statement->bindValue(':position_y', $data['position_y']);
            $statement->bindValue(':tolerance', $data['tolerance']);
            $statement->bindValue(':tolerance2', $data['tolerance2']);
            $statement->bindValue(':pts', 1);
            $statement->bindValue(':circle_div', $data['img_div']);
            // $statement->bindValue(':message', $data['message_text']);
            $statement->bindValue(':delay', $data['delaytime']);
            $statement->bindValue(':enable_arm', $data['enable_arm']);
            $statement->bindValue(':template_program_id', $data['screw_template_id']);

            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $results = $statement->execute();

        }else{ //不存在，用insert

            $sql = "INSERT INTO `task` ('job_id','seq_id','task_id','controller','enable_equipment','position_x','position_y','tolerance','tolerance2','pts','circle_div','delay','enable_arm','template_program_id' )
                    VALUES (:job_id,:seq_id,:task_id,:controller,:enable_equipment,:position_x,:position_y,:tolerance,:tolerance2,:pts,:circle_div,:delay,:enable_arm,:template_program_id )";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->bindValue(':controller', $data['controller_id']);
            $statement->bindValue(':enable_equipment', '');
            $statement->bindValue(':position_x', $data['position_x']);
            $statement->bindValue(':position_y', $data['position_y']);
            $statement->bindValue(':tolerance', $data['tolerance']);
            $statement->bindValue(':tolerance2', $data['tolerance2']);
            $statement->bindValue(':pts', 1);
            // $statement->bindValue(':message', $data['message_text']);
            $statement->bindValue(':circle_div', $data['img_div']);
            $statement->bindValue(':delay', $data['delaytime']);
            $statement->bindValue(':enable_arm', $data['enable_arm']);
            $statement->bindValue(':template_program_id', $data['screw_template_id']);
            
            $results = $statement->execute();

        }

        return $results;
    }

    public function GetTaskById($job_id,$seq_id,$task_id)
    {
        $sql= "SELECT task.*,tst.hole_id,tm.text,tm.img,tm.type,tm.timeout as message_timeout FROM task 
               LEFT JOIN task_socket_tray tst on task.job_id = tst.job_id AND task.seq_id = tst.seq_id AND task.task_id = tst.task_id
               LEFT JOIN task_message tm on task.job_id = tm.job_id AND task.seq_id = tm.seq_id AND task.task_id = tm.task_id
               WHERE task.job_id = :job_id AND task.seq_id = :seq_id AND task.task_id = :task_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function GetTaskProgram($job_id,$seq_id,$task_id)
    {
        //判斷在normal還是advanced
        //先抓normal if fetch == false 再去抓advanced
        $sql= "SELECT * FROM ccs_normalstep WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch(PDO::FETCH_ASSOC);

        if($rows == false){
            //只要抓最後一筆Step資料就好
            $sql= "SELECT * FROM ccs_advancedstep WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id  ORDER BY step_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $statement->bindValue(':task_id', $task_id);
            $results = $statement->execute();
            $rows = $statement->fetchall(PDO::FETCH_ASSOC);

            return $rows;
        }else{
            return $rows;
        }
    }

    public function EditTaskProgram($data)
    {
        // code...
        //透過controller_id跟screw_template_id找出特定的template以進行複製
        //20240321 先確認template的type，再根據type更新對應的db
        $sql= "SELECT * FROM gtcs_sequence_template WHERE template_program_id = :template_program_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $data['screw_template_id']);
        $statement->execute();
        $template_sequence_data = $statement->fetch(PDO::FETCH_ASSOC);
        $type = $template_sequence_data['type'];

        //
        if($type == 'normal'){
            $this->edit_normal_task_program($data);
        }else if($type == 'advanced'){
            $this->edit_advanced_task_program($data);
        }

    }

    public function CheckTaskProgramExist($job_id,$seq_id,$task_id)
    {
        $sql = "SELECT count(*) as count FROM ccs_normalstep WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // task 已存在
        }else{
            return false; // task 不存在
        }
    }

    public function CheckTaskProgramExist_adv($job_id,$seq_id,$task_id)
    {
        $sql = "SELECT count(*) as count FROM ccs_advancedstep WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // task 已存在
        }else{
            return false; // task 不存在
        }
    }

    public function DeleteTasksById($job_id,$seq_id,$task_id)
    {
        //delete Task
        $statement = $this->db->prepare('DELETE FROM task WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        //delete ccs_normalstep
        $statement = $this->db->prepare('DELETE FROM ccs_normalstep WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        //delete ccs_advancedstep
        $statement = $this->db->prepare('DELETE FROM ccs_advancedstep WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        //delete task_socket_tray
        $statement = $this->db->prepare('DELETE FROM task_socket_tray WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        //delete task_message
        $statement = $this->db->prepare('DELETE FROM task_message WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
    }

    public function ReOrderTasksId($job_id,$seq_id,$task_id)
    {
        $sql = 'UPDATE `task` SET task_id = task_id-1 WHERE job_id = :job_id AND seq_id = :seq_id AND task_id > :task_id ';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();

        $sql = 'UPDATE `ccs_normalstep` SET task_id = task_id-1 WHERE job_id = :job_id AND seq_id = :seq_id AND task_id > :task_id ';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();

        $sql = 'UPDATE `ccs_advancedstep` SET task_id = task_id-1 WHERE job_id = :job_id AND seq_id = :seq_id AND task_id > :task_id ';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();

        $sql = 'UPDATE `task_socket_tray` SET task_id = task_id-1 WHERE job_id = :job_id AND seq_id = :seq_id AND task_id > :task_id ';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();

    }

    public function edit_normal_task_program($data)
    {
        //get template data
        $sql= "SELECT * FROM gtcs_normalstep_template WHERE template_program_id = :template_program_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $data['screw_template_id']);
        $statement->execute();
        $template_data = $statement->fetch(PDO::FETCH_ASSOC);

        // if( $this->CheckTaskProgramExist( $data['job_id'],$data['seq_id'],$data['task_id'] ) ){//已存在，先刪掉再insert
            $sql= "DELETE FROM `ccs_normalstep` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->execute();
            
            $sql= "DELETE FROM `ccs_advancedstep` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->execute();
        // }
        //insert into ccs_normalstep
        //一樣先check是否重複
        if( $this->CheckTaskProgramExist( $data['job_id'],$data['seq_id'],$data['task_id'] ) ){ //已存在，用update

            $sql = "UPDATE `ccs_normalstep` SET 
                    'step_name' = :step_name,
                    'step_targettype' = :step_targettype,
                    'step_targetangle' = :step_targetangle,
                    'step_targettorque' = :step_targettorque,
                    'step_tooldirection' = :step_tooldirection,
                    'step_rpm' = :step_rpm,
                    'step_offsetdirection' = :step_offsetdirection,
                    'step_torque_jointoffset' = :step_torque_jointoffset,
                    'step_hightorque' = :step_hightorque,
                    'step_lowtorque' = :step_lowtorque,
                    'step_threshold_mode' = :step_threshold_mode,
                    'step_threshold_torque' = :step_threshold_torque,
                    'step_threshold_angle' = :step_threshold_angle,
                    'step_monitoringangle' = :step_monitoringangle,
                    'step_highangle' = :step_highangle,
                    'step_lowangle' = :step_lowangle,
                    'step_downshift_enable' = :step_downshift_enable,
                    'step_downshift_torque' = :step_downshift_torque,
                    'step_downshift_speed' = :step_downshift_speed,
                    'torque_unit' = :torque_unit,
                    'step_prr' = :step_prr,
                    'step_prr_rpm' = :step_prr_rpm,
                    'step_prr_angle' = :step_prr_angle,
                    'step_downshift_mode' = :step_downshift_mode,
                    'step_downshift_angle' = :step_downshift_angle
                WHERE 
                    'job_id' = :job_id AND 'seq_id' = :seq_id AND 'task_id' = :task_id";

            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);

            $statement->bindValue(':step_name', $template_data['step_name']);
            $statement->bindValue(':step_targettype', $template_data['step_targettype']);
            $statement->bindValue(':step_targetangle', $template_data['step_targetangle']);
            $statement->bindValue(':step_targettorque', $template_data['step_targettorque']);
            $statement->bindValue(':step_tooldirection', $template_data['step_tooldirection']);
            $statement->bindValue(':step_rpm', $template_data['step_rpm']);
            $statement->bindValue(':step_offsetdirection', $template_data['step_offsetdirection']);
            $statement->bindValue(':step_torque_jointoffset', $template_data['step_torque_jointoffset']);
            $statement->bindValue(':step_hightorque', $template_data['step_hightorque']);
            $statement->bindValue(':step_lowtorque', $template_data['step_lowtorque']);
            $statement->bindValue(':step_threshold_mode', $template_data['step_threshold_mode']);
            $statement->bindValue(':step_threshold_torque', $template_data['step_threshold_torque']);
            $statement->bindValue(':step_threshold_angle', $template_data['step_threshold_angle']);
            $statement->bindValue(':step_monitoringangle', $template_data['step_monitoringangle']);
            $statement->bindValue(':step_highangle', $template_data['step_highangle']);
            $statement->bindValue(':step_lowangle', $template_data['step_lowangle']);
            $statement->bindValue(':step_downshift_enable', $template_data['step_downshift_enable']);
            $statement->bindValue(':step_downshift_torque', $template_data['step_downshift_torque']);
            $statement->bindValue(':step_downshift_speed', $template_data['step_downshift_speed']);
            $statement->bindValue(':torque_unit', $template_data['torque_unit']);
            $statement->bindValue(':step_prr', $template_data['step_prr']);
            $statement->bindValue(':step_prr_rpm', $template_data['step_prr_rpm']);
            $statement->bindValue(':step_prr_angle', $template_data['step_prr_angle']);
            $statement->bindValue(':step_downshift_mode', $template_data['step_downshift_mode']);
            $statement->bindValue(':step_downshift_angle', $template_data['step_downshift_angle']);

            $results = $statement->execute();

        }else{ //不存在，用insert

            $sql = "INSERT INTO `ccs_normalstep` ('job_id','seq_id','task_id','step_name','step_targettype','step_targetangle','step_targettorque','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_hightorque','step_lowtorque','step_threshold_mode','step_threshold_torque','step_threshold_angle','step_monitoringangle','step_highangle','step_lowangle','step_downshift_enable','step_downshift_torque','step_downshift_speed','torque_unit','step_prr','step_prr_rpm','step_prr_angle','step_downshift_mode','step_downshift_angle' )
                    VALUES (:job_id,:seq_id,:task_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_hightorque,:step_lowtorque,:step_threshold_mode,:step_threshold_torque,:step_threshold_angle,:step_monitoringangle,:step_highangle,:step_lowangle,:step_downshift_enable,:step_downshift_torque,:step_downshift_speed,:torque_unit,:step_prr,:step_prr_rpm,:step_prr_angle,:step_downshift_mode,:step_downshift_angle )";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);

            $statement->bindValue(':step_name', $template_data['step_name']);
            $statement->bindValue(':step_targettype', $template_data['step_targettype']);
            $statement->bindValue(':step_targetangle', $template_data['step_targetangle']);
            $statement->bindValue(':step_targettorque', $template_data['step_targettorque']);
            $statement->bindValue(':step_tooldirection', $template_data['step_tooldirection']);
            $statement->bindValue(':step_rpm', $template_data['step_rpm']);
            $statement->bindValue(':step_offsetdirection', $template_data['step_offsetdirection']);
            $statement->bindValue(':step_torque_jointoffset', $template_data['step_torque_jointoffset']);
            $statement->bindValue(':step_hightorque', $template_data['step_hightorque']);
            $statement->bindValue(':step_lowtorque', $template_data['step_lowtorque']);
            $statement->bindValue(':step_threshold_mode', $template_data['step_threshold_mode']);
            $statement->bindValue(':step_threshold_torque', $template_data['step_threshold_torque']);
            $statement->bindValue(':step_threshold_angle', $template_data['step_threshold_angle']);
            $statement->bindValue(':step_monitoringangle', $template_data['step_monitoringangle']);
            $statement->bindValue(':step_highangle', $template_data['step_highangle']);
            $statement->bindValue(':step_lowangle', $template_data['step_lowangle']);
            $statement->bindValue(':step_downshift_enable', $template_data['step_downshift_enable']);
            $statement->bindValue(':step_downshift_torque', $template_data['step_downshift_torque']);
            $statement->bindValue(':step_downshift_speed', $template_data['step_downshift_speed']);
            $statement->bindValue(':torque_unit', $template_data['torque_unit']);
            $statement->bindValue(':step_prr', $template_data['step_prr']);
            $statement->bindValue(':step_prr_rpm', $template_data['step_prr_rpm']);
            $statement->bindValue(':step_prr_angle', $template_data['step_prr_angle']);
            $statement->bindValue(':step_downshift_mode', $template_data['step_downshift_mode']);
            $statement->bindValue(':step_downshift_angle', $template_data['step_downshift_angle']);
            
            $results = $statement->execute();

        }
    }

    public function edit_advanced_task_program($data)
    {
        //get template data
        $sql= "SELECT * FROM gtcs_advancedstep_template WHERE template_program_id = :template_program_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $data['screw_template_id']);
        $statement->execute();
        $template_data = $statement->fetchall(PDO::FETCH_ASSOC);

        // if( $this->CheckTaskProgramExist_adv( $data['job_id'],$data['seq_id'],$data['task_id'] ) ){//已存在，先刪掉再insert
            $sql= "DELETE FROM `ccs_advancedstep` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->execute();

            $sql= "DELETE FROM `ccs_normalstep` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->execute();
        // }

        foreach ($template_data as $key => $temp_data) {
            $sql = "INSERT INTO `ccs_advancedstep` ('job_id','seq_id','task_id','step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_delayttime','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_monitoringmode','step_torwin_target','step_torquewindow','step_angwin_target','step_anglewindow','step_hightorque','step_lowtorque','step_monitoringangle','step_highangle','step_lowangle','torque_unit','step_angle_mode','step_slope','gtcs_job_id' )
                    VALUES ( :job_id,:seq_id,:task_id,:step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_delayttime,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_monitoringmode,:step_torwin_target,:step_torquewindow,:step_angwin_target,:step_anglewindow,:step_hightorque,:step_lowtorque,:step_monitoringangle,:step_highangle,:step_lowangle,:torque_unit,:step_angle_mode,:step_slope,:gtcs_job_id )";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->bindValue(':step_id', $temp_data['template_step_id']);

            $statement->bindValue(':step_name', $temp_data['step_name']);
            $statement->bindValue(':step_targettype', $temp_data['step_targettype']);
            $statement->bindValue(':step_targetangle', $temp_data['step_targetangle']);
            $statement->bindValue(':step_targettorque', $temp_data['step_targettorque']);
            $statement->bindValue(':step_delayttime', $temp_data['step_delayttime']);
            $statement->bindValue(':step_tooldirection', $temp_data['step_tooldirection']);
            $statement->bindValue(':step_rpm', $temp_data['step_rpm']);
            $statement->bindValue(':step_offsetdirection', $temp_data['step_offsetdirection']);
            $statement->bindValue(':step_torque_jointoffset', $temp_data['step_torque_jointoffset']);
            $statement->bindValue(':step_monitoringmode', $temp_data['step_monitoringmode']);
            $statement->bindValue(':step_torwin_target', $temp_data['step_torwin_target']);
            $statement->bindValue(':step_torquewindow', $temp_data['step_torquewindow']);
            $statement->bindValue(':step_angwin_target', $temp_data['step_angwin_target']);
            $statement->bindValue(':step_anglewindow', $temp_data['step_anglewindow']);
            $statement->bindValue(':step_hightorque', $temp_data['step_hightorque']);
            $statement->bindValue(':step_lowtorque', $temp_data['step_lowtorque']);
            $statement->bindValue(':step_monitoringangle', $temp_data['step_monitoringangle']);
            $statement->bindValue(':step_highangle', $temp_data['step_highangle']);
            $statement->bindValue(':step_lowangle', $temp_data['step_lowangle']);
            $statement->bindValue(':torque_unit', $temp_data['torque_unit']);
            $statement->bindValue(':step_angle_mode', $temp_data['step_angle_mode']);
            $statement->bindValue(':step_slope', $temp_data['step_slope']);
            $statement->bindValue(':gtcs_job_id', '');

            $results = $statement->execute();
        }
    }

    //sockect hole
    public function edit_task_socket_hole($data)
    {
        if( $this->CheckSocketHole( $data['job_id'],$data['seq_id'],$data['task_id'] ) ){ //已存在，用update

            $sql = "UPDATE `task_socket_tray` 
                    SET hole_id = :hole_id 
                    WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':hole_id', $data['sockect_hole']);

            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $results = $statement->execute();


        }else{ //不存在，用insert

            $sql = "INSERT INTO `task_socket_tray` ('job_id','seq_id','task_id','hole_id' )
                    VALUES (:job_id,:seq_id,:task_id,:hole_id)";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':task_id', $data['task_id']);
            $statement->bindValue(':hole_id', $data['sockect_hole']);
            
            $results = $statement->execute();

        }

        return $results;
    }

    public function CheckSocketHole($job_id,$seq_id,$task_id)
    {
        $sql = "SELECT count(*) as count FROM task_socket_tray WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // task 已存在
        }else{
            return false; // task 不存在
        }
    }

    public function EditPositionOnly($job_id,$seq_id,$task_id,$position)
    {
        $sql = "UPDATE `task` 
                    SET circle_div = :circle_div
                    WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':circle_div', $position);

        $statement->bindValue(':seq_id', $job_id);
        $statement->bindValue(':job_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);

        $result = $statement->execute();

        return $result;
    }

    public function SetTaskImage($job_id,$seq_id,$task_id,$img_url,$file_type,$message,$message_timeout)
    {
        
        if( $this->CheckTaskImage($job_id,$seq_id,$task_id) ){ //已存在，用update

            $sql = "UPDATE `task_message` 
                    SET img = :img, `text` = :message, type = :type, timeout = :message_timeout
                    WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $statement->bindValue(':task_id', $task_id);
            $statement->bindValue(':img', $img_url);
            $statement->bindValue(':message', $message);
            $statement->bindValue(':type', $file_type);
            $statement->bindValue(':message_timeout', $message_timeout);

            $results = $statement->execute();


        }else{ //不存在，用insert

            $sql = "INSERT INTO `task_message` ('job_id','seq_id','task_id','img','type','text','timeout' )
                    VALUES (:job_id,:seq_id,:task_id,:img,:type,:message,:message_timeout)";
            $statement = $this->db->prepare($sql);
            // var_dump($this->db->errorInfo());
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $statement->bindValue(':task_id', $task_id);
            $statement->bindValue(':img', $img_url);
            $statement->bindValue(':message', $message);
            $statement->bindValue(':type', $file_type);
            $statement->bindValue(':message_timeout', $message_timeout);
            
            $results = $statement->execute();

        }

        return $results;
    }

    public function CheckTaskImage($job_id,$seq_id,$task_id)
    {
        $sql = "SELECT count(*) as count FROM `task_message` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
        $statement = $this->db->prepare($sql);
        // var_dump($this->db->errorInfo());
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $results = $statement->execute();
        $rows = $statement->fetch();
        
        
        if ($rows['count'] > 0) {
            return true; // task 已存在
        }else{
            return false; // task 不存在
        }
    }

    public function DeleteVirtualMessage($job_id,$seq_id,$task_id)
    {

        $sql= "SELECT * FROM `task_message` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $statement->execute();
        $row = $statement->fetch(PDO::FETCH_ASSOC);


        if(!empty($row)){

            $sql= "DELETE FROM `task_message` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $statement->bindValue(':task_id', $task_id);
            $statement->execute(); 
            return $row['img'];

        }else{
            return false;
        }

        /*$sql= "DELETE FROM `task_message` WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $statement->bindValue(':task_id', $task_id);
        $statement->execute();*/

        //return $row['img'];
    }

}
