<?php

class Setting{
    private $db;//cc db
    private $db_gtcs;//gtcs tcscon.db

    // 在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();

        $dbPath = '../localfile.db';
        $this->db_gtcs = new PDO("sqlite:$dbPath");

    }

    public function get_all_jobs()
    {
        $sql = "SELECT * FROM job ORDER BY job_id ";
        $statement = $this->db->prepare($sql);
        $results = $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function get_all_sequences($job_id)
    {
        // code...
    }

    public function get_all_tasks()
    {
        $sql = "SELECT * FROM ccs_normalstep ORDER BY job_id,seq_id,task_id ";
        $statement = $this->db->prepare($sql);
        $results = $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function get_all_tasks_advanced()
    {
        $sql = "SELECT * FROM ccs_advancedstep ORDER BY job_id,seq_id,task_id ";
        $statement = $this->db->prepare($sql);
        $results = $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function JobIdCheck($job_id,$job_data)
    {
        if( $this->CheckJobGTCS($job_id) ){ //已存在，
            $sql = "DELETE FROM `job` WHERE job_id = :job_id ";
            $statement = $this->db_gtcs->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->execute();
        } //不存在，用insert

        $sql = "INSERT INTO `job` ('job_id','job_name','ok_job','ok_job_stop','reverse_direction','reverse_rpm','reverse_force','reverse_cnt_mode','reverse_threshold_torque','torque_unit' )
                VALUES (:job_id,:job_name,:ok_job,:ok_job_stop,:reverse_direction,:reverse_rpm,:reverse_force,:reverse_cnt_mode,:reverse_threshold_torque,:torque_unit)";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':job_name', $job_data['job_name']);
        $statement->bindValue(':ok_job', $job_data['ok_job']);
        $statement->bindValue(':ok_job_stop', 0); //改成0，因為會妨害中控與GTCS溝通 $job_data['ok_job_stop']
        $statement->bindValue(':reverse_direction', $job_data['reverse_direction']);
        $statement->bindValue(':reverse_rpm', $job_data['reverse_rpm']);
        $statement->bindValue(':reverse_force', $job_data['reverse_force']);
        $statement->bindValue(':reverse_cnt_mode', $job_data['reverse_cnt_mode']);
        $statement->bindValue(':reverse_threshold_torque', $job_data['reverse_threshold_torque']);        
        $statement->bindValue(':torque_unit', 1);
        $results = $statement->execute();

        return $results;
    }

    public function SeqIdCheck($job_id,$seq_id,$seq_data)
    {
        // if( $this->CheckSeqGTCS($job_id,$seq_id) ){ //已存在，
            $sql = "DELETE FROM `sequence` WHERE job_id = :job_id ";
            $statement = $this->db_gtcs->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            // $statement->bindValue(':seq_id', $seq_id);
            $statement->execute();
        // }

        $sql = "INSERT INTO `sequence` ('sequence_enable','job_id','sequence_id','sequence_name','tightening_repeat','ng_stop','ok_sequence','ok_sequence_stop','sequence_mintime','sequence_maxtime' )
                VALUES (:sequence_enable,:job_id,:sequence_id,:sequence_name,:tightening_repeat,:ng_stop,:ok_sequence,:ok_sequence_stop,:sequence_mintime,:sequence_maxtime)";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':sequence_enable', 1);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':sequence_id', 1);
        $statement->bindValue(':sequence_name', $seq_data['seq_name']);
        $statement->bindValue(':tightening_repeat', $seq_data['tightening_repeat']);
        $statement->bindValue(':ng_stop', 0); //改成0，因為會妨害中控與GTCS溝通 $seq_data['ng_stop']
        $statement->bindValue(':ok_sequence', $seq_data['ok_sequence']);
        $statement->bindValue(':ok_sequence_stop', 0); //改成0，因為會妨害中控與GTCS溝通 $seq_data['ok_sequence_stop']
        $statement->bindValue(':sequence_mintime', $seq_data['sequence_mintime']);
        $statement->bindValue(':sequence_maxtime', $seq_data['sequence_maxtime']);
        $results = $statement->execute();

        return $results;

    }

    public function TaskIdCheck($task_data,$job_id,$seq_name)
    {
        // if( $this->CheckSeqGTCS($data['job_id']) ){ //已存在，
            $sql = "DELETE FROM `normalstep` WHERE job_id = :job_id AND sequence_id = :seq_id ";
            $statement = $this->db_gtcs->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $task_data['seq_id']);
            $statement->execute();
        // }

        $sql = "INSERT INTO `normalstep` ('job_id','sequence_id','sequence_name','step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_hightorque','step_lowtorque','step_threshold_mode','step_threshold_torque','step_threshold_angle','step_monitoringangle','step_highangle','step_lowangle','step_downshift_enable','step_downshift_torque','step_downshift_speed','torque_unit','step_prr','step_prr_rpm','step_prr_angle','step_downshift_mode','step_downshift_angle' )
                VALUES (:job_id,:sequence_id,:sequence_name,:step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_hightorque,:step_lowtorque,:step_threshold_mode,:step_threshold_torque,:step_threshold_angle,:step_monitoringangle,:step_highangle,:step_lowangle,:step_downshift_enable,:step_downshift_torque,:step_downshift_speed,:torque_unit,:step_prr,:step_prr_rpm,:step_prr_angle,:step_downshift_mode,:step_downshift_angle )";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':sequence_id', 1); // for normalstep
        $statement->bindValue(':sequence_name', $seq_name);
        $statement->bindValue(':step_id', 1);// for normalstep
        $statement->bindValue(':step_name', $task_data['step_name']);
        $statement->bindValue(':step_targettype', $task_data['step_targettype']);
        $statement->bindValue(':step_targetangle', $task_data['step_targetangle']);
        $statement->bindValue(':step_targettorque', $task_data['step_targettorque']);
        $statement->bindValue(':step_tooldirection', $task_data['step_tooldirection']);
        $statement->bindValue(':step_rpm', $task_data['step_rpm']);
        $statement->bindValue(':step_offsetdirection', $task_data['step_offsetdirection']);
        $statement->bindValue(':step_torque_jointoffset', $task_data['step_torque_jointoffset']);
        $statement->bindValue(':step_hightorque', $task_data['step_hightorque']);
        $statement->bindValue(':step_lowtorque', $task_data['step_lowtorque']);
        $statement->bindValue(':step_threshold_mode', $task_data['step_threshold_mode']);
        $statement->bindValue(':step_threshold_torque', $task_data['step_threshold_torque']);
        $statement->bindValue(':step_threshold_angle', $task_data['step_threshold_angle']);
        $statement->bindValue(':step_monitoringangle', $task_data['step_monitoringangle']);
        $statement->bindValue(':step_highangle', $task_data['step_highangle']);
        $statement->bindValue(':step_lowangle', $task_data['step_lowangle']);
        $statement->bindValue(':step_downshift_enable', $task_data['step_downshift_enable']);
        $statement->bindValue(':step_downshift_torque', $task_data['step_downshift_torque']);
        $statement->bindValue(':step_downshift_speed', $task_data['step_downshift_speed']);
        $statement->bindValue(':torque_unit', $task_data['torque_unit']);
        $statement->bindValue(':step_prr', $task_data['step_prr']);
        $statement->bindValue(':step_prr_rpm', $task_data['step_prr_rpm']);
        $statement->bindValue(':step_prr_angle', $task_data['step_prr_angle']);
        $statement->bindValue(':step_downshift_mode', $task_data['step_downshift_mode']);
        $statement->bindValue(':step_downshift_angle', $task_data['step_downshift_angle']);
        $results = $statement->execute();

        return $results;
    }

    public function TaskIdCheck_Advanced($task_data,$job_id,$seq_name)
    {
        // if( $this->CheckSeqGTCS($data['job_id']) ){ //已存在，
            $sql = "DELETE FROM `advancedstep` WHERE job_id = :job_id AND sequence_id = :seq_id AND step_id = :step_id ";
            $statement = $this->db_gtcs->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $task_data['seq_id']);
            $statement->bindValue(':step_id', $task_data['step_id']);
            $statement->execute();
        // }

        $sql = "INSERT INTO `advancedstep` ('job_id','sequence_id','sequence_name','step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_delayttime','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_monitoringmode','step_torwin_target','step_torquewindow','step_angwin_target','step_anglewindow','step_hightorque','step_lowtorque','step_monitoringangle','step_highangle','step_lowangle','torque_unit','step_angle_mode','step_slope' )
                VALUES (:job_id,:sequence_id,:sequence_name,:step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_delayttime,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_monitoringmode,:step_torwin_target,:step_torquewindow,:step_angwin_target,:step_anglewindow,:step_hightorque,:step_lowtorque,:step_monitoringangle,:step_highangle,:step_lowangle,:torque_unit,:step_angle_mode,:step_slope )";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':sequence_id', 1); // for normalstep
        $statement->bindValue(':sequence_name', $seq_name);
        $statement->bindValue(':step_id', $task_data['step_id']);// for normalstep
        $statement->bindValue(':step_name', $task_data['step_name']);
        $statement->bindValue(':step_targettype', $task_data['step_targettype']);
        $statement->bindValue(':step_targetangle', $task_data['step_targetangle']);
        $statement->bindValue(':step_targettorque', $task_data['step_targettorque']);
        $statement->bindValue(':step_delayttime', $task_data['step_delayttime']);
        $statement->bindValue(':step_tooldirection', $task_data['step_tooldirection']);
        $statement->bindValue(':step_rpm', $task_data['step_rpm']);
        $statement->bindValue(':step_offsetdirection', $task_data['step_offsetdirection']);
        $statement->bindValue(':step_torque_jointoffset', $task_data['step_torque_jointoffset']);
        $statement->bindValue(':step_monitoringmode', $task_data['step_monitoringmode']);
        $statement->bindValue(':step_torwin_target', $task_data['step_torwin_target']);
        $statement->bindValue(':step_torquewindow', $task_data['step_torquewindow']);
        $statement->bindValue(':step_angwin_target', $task_data['step_angwin_target']);
        $statement->bindValue(':step_anglewindow', $task_data['step_anglewindow']);

        $statement->bindValue(':step_hightorque', $task_data['step_hightorque']);
        $statement->bindValue(':step_lowtorque', $task_data['step_lowtorque']);
        $statement->bindValue(':step_monitoringangle', $task_data['step_monitoringangle']);
        $statement->bindValue(':step_highangle', $task_data['step_highangle']);
        $statement->bindValue(':step_lowangle', $task_data['step_lowangle']);
        $statement->bindValue(':torque_unit', $task_data['torque_unit']);
        $statement->bindValue(':step_angle_mode', $task_data['step_angle_mode']);
        $statement->bindValue(':step_slope', $task_data['step_slope']);
        $results = $statement->execute();

        return $results;
    }

    public function TaskUpdate($task,$gtcs_job_id)
    {
        $sql = "UPDATE `ccs_normalstep` 
                    SET gtcs_job_id = :gtcs_job_id 
                    WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':gtcs_job_id', $gtcs_job_id);
            $statement->bindValue(':job_id', $task['job_id']);
            $statement->bindValue(':seq_id', $task['seq_id']);
            $statement->bindValue(':task_id', $task['task_id']);
            
            $results = $statement->execute();

        return $results;
    }

    public function TaskUpdate_Advanced($task,$gtcs_job_id)
    {
        $sql = "UPDATE `ccs_advancedstep` 
                    SET gtcs_job_id = :gtcs_job_id 
                    WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':gtcs_job_id', $gtcs_job_id);
            $statement->bindValue(':job_id', $task['job_id']);
            $statement->bindValue(':seq_id', $task['seq_id']);
            $statement->bindValue(':task_id', $task['task_id']);
            
            $results = $statement->execute();

        return $results;
    }

    //檢查gtcs job id是否已存在
    public function CheckJobGTCS($job_id)
    {
        $sql = "SELECT count(*) as count FROM job WHERE job_id = :job_id";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    //檢查gtcs seq id是否已存在
    public function CheckSeqGTCS($job_id,$seq_id)
    {
        $sql = "SELECT count(*) as count FROM sequence WHERE job_id = :job_id ";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        // $statement->bindValue(':seq_id', $seq_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function SetDeviceSetting($device_id,$device_name)
    {
        $sql = "UPDATE `device` SET device_id = :device_id, device_name = :device_name ";
        $statement = $this->db_gtcs->prepare($sql);
        $statement->bindValue(':device_id', $device_id);
        $statement->bindValue(':device_name', $device_name);
        
        $results = $statement->execute();

        return $results;
    }

    //補充空白欄位
    public function ColumnReplenish($replenish)
    {
        foreach ($replenish as $table_name => $value) {
            foreach ($value as $column_name => $default) {
                $sql = "UPDATE $table_name SET $column_name = '".strval($default)."'";
                $statement = $this->db_gtcs->prepare($sql);
                
                $results = $statement->execute();
            }
        }
    }

}
