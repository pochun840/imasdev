<?php

class Template{
    private $db;//condb control box

    // 在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();
    }

    // 取得所有Normal Sequence
    public function GetAllNormalStepTemplate()
    {
        $sql = "SELECT * FROM `gtcs_normalstep_template` ORDER BY template_program_id ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);
    }

    //取得job id，依job_type判斷
    public function GetHeadProgramId(){

        $query = "SELECT template_program_id + 1 AS missing_id
                  FROM gtcs_sequence_template
                 WHERE (template_program_id + 1) NOT IN ( SELECT template_program_id FROM gtcs_sequence_template ) order by  missing_id limit 1";

        $statement = $this->db->prepare($query);
        $statement->execute();

        $result = $statement->fetch();
        if ($result == false){
            return array('0'=> 1, 'missing_id' => 1);
        }

        return $result;
    }

    public function EditProgram_Normal($data)
    {
        if( $this->CheckProgramExist($data['program_id']) ){ //已存在，用update

            $sql = "UPDATE `gtcs_normalstep_template` 
                    SET step_name = :step_name,
                        step_targettype = :step_targettype,
                        step_targetangle = :step_targetangle,
                        step_targettorque = :step_targettorque,
                        step_tooldirection = :step_tooldirection,
                        step_rpm = :step_rpm,
                        step_offsetdirection = :step_offsetdirection,
                        step_torque_jointoffset = :step_torque_jointoffset,
                        step_hightorque = :step_hightorque,
                        step_lowtorque = :step_lowtorque,
                        step_threshold_mode = :step_threshold_mode,
                        step_threshold_torque = :step_threshold_torque,
                        step_threshold_angle  = :step_threshold_angle,
                        step_monitoringangle  = :step_monitoringangle,
                        step_highangle = :step_highangle,
                        step_lowangle = :step_lowangle,
                        step_downshift_enable = :step_downshift_enable,
                        step_downshift_torque = :step_downshift_torque,
                        step_downshift_speed  = :step_downshift_speed,
                        torque_unit = :torque_unit,
                        step_prr  = :step_prr,
                        step_prr_rpm  = :step_prr_rpm,
                        step_prr_angle = :step_prr_angle,
                        step_downshift_mode = :step_downshift_mode,
                        step_downshift_angle = :step_downshift_angle
                    WHERE template_program_id = :template_program_id AND template_step_id = 1 ";
            $statement = $this->db->prepare($sql);
            // var_dump($this->db->errorInfo());
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':step_name', $data['program_name']);
            $statement->bindValue(':step_targettype', $data['target_type']);
            $statement->bindValue(':step_targetangle', $data['target_angle']);
            $statement->bindValue(':step_targettorque', $data['target_torque']);
            $statement->bindValue(':step_tooldirection', 0);
            $statement->bindValue(':step_rpm', $data['run_down_speed']);
            $statement->bindValue(':step_offsetdirection', $data['joint_offset']);
            $statement->bindValue(':step_torque_jointoffset', $data['offset_value']);
            $statement->bindValue(':step_hightorque', $data['hi_torque']);
            $statement->bindValue(':step_lowtorque', $data['Lo_torque']);
            $statement->bindValue(':step_threshold_mode', $data['Threshold_Type']);
            $statement->bindValue(':step_threshold_torque', $data['threshold_torque']);
            $statement->bindValue(':step_threshold_angle', $data['threshold_angle']);
            $statement->bindValue(':step_monitoringangle', $data['Monitoring_ON_OFF']);
            $statement->bindValue(':step_highangle', $data['hi_angle']);
            $statement->bindValue(':step_lowangle', $data['lo_angle']);
            $statement->bindValue(':step_downshift_enable', $data['Downshift_ON_OFF']);
            $statement->bindValue(':step_downshift_torque', $data['downshift_torque']);
            $statement->bindValue(':step_downshift_speed', $data['downshift_speed']);
            $statement->bindValue(':torque_unit', 1);//先不管 扭力單位
            $statement->bindValue(':step_prr', $data['Pre_run']);
            $statement->bindValue(':step_prr_rpm', $data['pre_run_rpm']);
            $statement->bindValue(':step_prr_angle', $data['pre_run_angle']);
            $statement->bindValue(':step_downshift_mode', 0);//先不管 downshift mode 
            $statement->bindValue(':step_downshift_angle', 0);//先不管 downshift angle 
            $results = $statement->execute();

        }else{ //不存在，用insert

            $sql = "INSERT INTO `gtcs_sequence_template` ('template_program_id','type' )
                    VALUES (:template_program_id,:type)";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':type', 'normal');
            $results = $statement->execute();

            $sql = "INSERT INTO `gtcs_normalstep_template` ('template_program_id','template_step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_hightorque','step_lowtorque','step_threshold_mode','step_threshold_torque','step_threshold_angle','step_monitoringangle','step_highangle','step_lowangle','step_downshift_enable','step_downshift_torque','step_downshift_speed','torque_unit','step_prr','step_prr_rpm','step_prr_angle','step_downshift_mode','step_downshift_angle' )
                    VALUES (:template_program_id,:template_step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_hightorque,:step_lowtorque,:step_threshold_mode,:step_threshold_torque,:step_threshold_angle,:step_monitoringangle,:step_highangle,:step_lowangle,:step_downshift_enable,:step_downshift_torque,:step_downshift_speed,:torque_unit,:step_prr,:step_prr_rpm,:step_prr_angle,:step_downshift_mode,:step_downshift_angle )";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':template_step_id', 1);
            $statement->bindValue(':step_name', $data['program_name']);
            $statement->bindValue(':step_targettype', $data['target_type']);
            $statement->bindValue(':step_targetangle', $data['target_angle']);
            $statement->bindValue(':step_targettorque', $data['target_torque']);
            $statement->bindValue(':step_tooldirection', 0);
            $statement->bindValue(':step_rpm', $data['run_down_speed']);
            $statement->bindValue(':step_offsetdirection', $data['joint_offset']);
            $statement->bindValue(':step_torque_jointoffset', $data['offset_value']);
            $statement->bindValue(':step_hightorque', $data['hi_torque']);
            $statement->bindValue(':step_lowtorque', $data['Lo_torque']);
            $statement->bindValue(':step_threshold_mode', $data['Threshold_Type']);
            $statement->bindValue(':step_threshold_torque', $data['threshold_torque']);
            $statement->bindValue(':step_threshold_angle', $data['threshold_angle']);
            $statement->bindValue(':step_monitoringangle', $data['Monitoring_ON_OFF']);
            $statement->bindValue(':step_highangle', $data['hi_angle']);
            $statement->bindValue(':step_lowangle', $data['lo_angle']);
            $statement->bindValue(':step_downshift_enable', $data['Downshift_ON_OFF']);
            $statement->bindValue(':step_downshift_torque', $data['downshift_torque']);
            $statement->bindValue(':step_downshift_speed', $data['downshift_speed']);
            $statement->bindValue(':torque_unit', 1);//先不管 扭力單位
            $statement->bindValue(':step_prr', $data['Pre_run']);
            $statement->bindValue(':step_prr_rpm', $data['pre_run_rpm']);
            $statement->bindValue(':step_prr_angle', $data['pre_run_angle']);
            $statement->bindValue(':step_downshift_mode', 0);//先不管 downshift mode 
            $statement->bindValue(':step_downshift_angle', 0);//先不管 downshift angle 
            
            $results = $statement->execute();

        }

        return $results;
    }

    public function CheckProgramExist($template_program_id)
    {
        $sql = "SELECT count(*) as count FROM gtcs_sequence_template WHERE template_program_id = :template_program_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $template_program_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function GetProgramById_Normal($program_id)
    {
        $sql= "SELECT * FROM gtcs_normalstep_template WHERE template_program_id = :template_program_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $program_id);
        $results = $statement->execute();
        $rows = $statement->fetch(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function Copypro($from_pro_id,$to_pro_id,$to_pro_name,$job_type)
    {
        // 判斷seq_id是否存在，若存在就先把舊的刪除
        // $dupli_flag true:表示to_pro_id已存在 false:表示to_pro_id不存在
        $dupli_flag = $this->CheckProgramExist($to_pro_id);

        if($dupli_flag){
            $this->DeleteProgramById($to_pro_id);
        }
        
        $sql = "INSERT INTO `gtcs_sequence_template` ('template_program_id','type' )
                    VALUES (:template_program_id,:type)";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $to_pro_id);
        $statement->bindValue(':type', $job_type);
        $results = $statement->execute();    
        
        if($job_type == 'normal'){
            $sql= "INSERT INTO `gtcs_normalstep_template` (template_program_id,template_step_id,step_name,step_targettype,step_targetangle,step_targettorque,step_tooldirection,step_rpm,step_offsetdirection,step_torque_jointoffset,step_hightorque,step_lowtorque,step_threshold_mode,step_threshold_torque,step_threshold_angle,step_monitoringangle,step_highangle,step_lowangle,step_downshift_enable,step_downshift_torque,step_downshift_speed,torque_unit,step_prr,step_prr_rpm,step_prr_angle,step_downshift_mode,step_downshift_angle )

                SELECT  :to_pro_id,template_step_id,:to_pro_name,step_targettype,step_targetangle,step_targettorque,step_tooldirection,step_rpm,step_offsetdirection,step_torque_jointoffset,step_hightorque,step_lowtorque,step_threshold_mode,step_threshold_torque,step_threshold_angle,step_monitoringangle,step_highangle,step_lowangle,step_downshift_enable,step_downshift_torque,step_downshift_speed,torque_unit,step_prr,step_prr_rpm,step_prr_angle,step_downshift_mode,step_downshift_angle
                FROM    gtcs_normalstep_template
                WHERE template_program_id = :from_pro_id ";
            $stmt = $this->db->prepare($sql);
            $stmt->bindValue(':to_pro_id', $to_pro_id);
            $stmt->bindValue(':to_pro_name', $to_pro_name);
            $stmt->bindValue(':from_pro_id', $from_pro_id);
            $results = $stmt->execute();
        }

        if($job_type == 'advanced'){
            $sql= "INSERT INTO `gtcs_advancedstep_template` (template_program_id,template_program_name,template_step_id,step_name,step_targettype,step_targetangle,step_targettorque,step_delayttime,step_tooldirection,step_rpm,step_offsetdirection,step_torque_jointoffset,step_monitoringmode,step_torwin_target,step_torquewindow,step_angwin_target,step_anglewindow,step_hightorque,step_lowtorque,step_monitoringangle,step_highangle,step_lowangle,torque_unit,step_angle_mode,step_slope )

                SELECT  :to_pro_id,:to_pro_name,template_step_id,step_name,step_targettype,step_targetangle,step_targettorque,step_delayttime,step_tooldirection,step_rpm,step_offsetdirection,step_torque_jointoffset,step_monitoringmode,step_torwin_target,step_torquewindow,step_angwin_target,step_anglewindow,step_hightorque,step_lowtorque,step_monitoringangle,step_highangle,step_lowangle,torque_unit,step_angle_mode,step_slope 
                FROM    gtcs_advancedstep_template
                WHERE template_program_id = :from_pro_id ";
            $stmt = $this->db->prepare($sql);
            $stmt->bindValue(':to_pro_id', $to_pro_id);
            $stmt->bindValue(':to_pro_name', $to_pro_name);
            $stmt->bindValue(':from_pro_id', $from_pro_id);
            $results = $stmt->execute();
        }
        

        return $results;
    }

    public function DeleteProgramById($pro_id)
    {
        //刪除sequence
        $stmt = $this->db->prepare('DELETE FROM gtcs_sequence_template WHERE template_program_id = :template_program_id ');
        $stmt->bindValue(':template_program_id', $pro_id);
        $results = $stmt->execute();
        //刪除normalstep
        $stmt = $this->db->prepare('DELETE FROM gtcs_normalstep_template WHERE template_program_id = :template_program_id ');
        $stmt->bindValue(':template_program_id', $pro_id);
        $results = $stmt->execute();
        //刪除advancedstep
        $stmt = $this->db->prepare('DELETE FROM gtcs_advancedstep_template WHERE template_program_id = :template_program_id ');
        $stmt->bindValue(':template_program_id', $pro_id);
        $results = $stmt->execute();


         //清空 task的 template_program_id
         $sql = "SELECT * FROM task WHERE template_program_id = :template_program_id";
         $statement = $this->db->prepare($sql);
         $statement->bindValue(':template_program_id', $program_id);
         $statement->execute();
         $rows = $statement->fetch(PDO::FETCH_ASSOC);
         if ($rows) {
             $update_sql = "UPDATE task  SET template_program_id = NULL WHERE template_program_id = :template_program_id";
             $update_statement = $this->db->prepare($update_sql);
             $update_statement->bindValue(':template_program_id', $program_id);
             $update_statement->execute();
             
             echo "Record updated successfully.";
         } else {
             echo "No record found.";
         }        


      
    }

    public function EditProgram_Advanced_Name($data){
        if( $this->CheckProgramExist($data['program_id'])){
            $sql = "UPDATE `gtcs_advancedstep_template` 
            SET template_program_name = :template_program_name
            WHERE template_program_id = :template_program_id";

            $statement = $this->db->prepare($sql);
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':template_program_name', $data['program_name']);
            $results = $statement->execute();


        } 
        
        return $results;
    }

    public function EditProgram_Advanced($data)
    {
        if( $this->CheckProgramExist($data['program_id']) ){ //已存在，用update

            $sql = "UPDATE `gtcs_advancedstep_template` 
                    SET template_program_name = :template_program_name,
                        step_name = :step_name,
                        step_targettype = :step_targettype,
                        step_targetangle = :step_targetangle,
                        step_targettorque = :step_targettorque,
                        step_delayttime = :step_delayttime,
                        step_tooldirection = :step_tooldirection,
                        step_rpm = :step_rpm,
                        step_offsetdirection = :step_offsetdirection,
                        step_torque_jointoffset = :step_torque_jointoffset,
                        step_monitoringmode = :step_monitoringmode,
                        step_torwin_target = :step_torwin_target,
                        step_torquewindow = :step_torquewindow,
                        step_angwin_target = :step_angwin_target,
                        step_anglewindow = :step_anglewindow,
                        step_hightorque = :step_hightorque,
                        step_lowtorque = :step_lowtorque,
                        step_torquewindow = :step_torquewindow,
                        step_monitoringangle  = :step_monitoringangle,
                        step_highangle = :step_highangle,
                        step_lowangle = :step_lowangle,
                        torque_unit = :torque_unit,
                        step_angle_mode = :step_angle_mode,
                        step_slope = :step_slope 

                    WHERE template_program_id = :template_program_id AND template_step_id = :template_step_id ";
            $statement = $this->db->prepare($sql);
            // var_dump($this->db->errorInfo());
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':template_step_id', $data['template_step_id']);
            $statement->bindValue(':template_program_name', $data['program_name']);
            $statement->bindValue(':step_name', $data['step_name']);
            $statement->bindValue(':step_targettype', $data['program_target']);
            $statement->bindValue(':step_targetangle', $data['target_angle']);
            $statement->bindValue(':step_targettorque', $data['target_torque']);
            $statement->bindValue(':step_delayttime', $data['step_delayttime']);
            $statement->bindValue(':step_tooldirection', 0);
            $statement->bindValue(':step_rpm', $data['run_down_speed']);
            $statement->bindValue(':step_offsetdirection', $data['joint_offset']);
            $statement->bindValue(':step_torque_jointoffset', $data['offset_value']);
            $statement->bindValue(':step_monitoringmode', $data['monitoringmode']);
            $statement->bindValue(':step_torwin_target', $data['step_torwin_target']);
            $statement->bindValue(':step_torquewindow', $data['step_torquewindow']);
            $statement->bindValue(':step_angwin_target', $data['step_angwin_target']);
            $statement->bindValue(':step_anglewindow', $data['step_anglewindow']);
            $statement->bindValue(':step_hightorque', $data['hi_torque']);
            $statement->bindValue(':step_lowtorque', $data['Lo_torque']);
            $statement->bindValue(':step_monitoringangle', $data['Monitoring_ON_OFF']);
            $statement->bindValue(':step_highangle', $data['hi_angle']);
            $statement->bindValue(':step_lowangle', $data['lo_angle']);
            $statement->bindValue(':torque_unit', 1);//先不管 扭力單位
            $statement->bindValue(':step_angle_mode', $data['step_angle_mode']);//先不管 扭力單位
            $statement->bindValue(':step_slope', 2000);//先不管斜率
            $results = $statement->execute();

        }else{ //不存在，用insert

            $sql = "INSERT INTO `gtcs_sequence_template` ('template_program_id','type' )
                    VALUES (:template_program_id,:type)";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':type', 'advanced');
            $results = $statement->execute();

            $sql = "INSERT INTO `gtcs_advancedstep_template` ('template_program_id','template_program_name','template_step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_delayttime','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_monitoringmode','step_torwin_target','step_torquewindow','step_angwin_target','step_anglewindow','step_hightorque','step_lowtorque','step_monitoringangle','step_highangle','step_lowangle','torque_unit','step_angle_mode','step_slope' )
                    VALUES (:template_program_id,:template_program_name,:template_step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_delayttime,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_monitoringmode,:step_torwin_target,:step_torquewindow,:step_angwin_target,:step_anglewindow,:step_hightorque,:step_lowtorque,:step_monitoringangle,:step_highangle,:step_lowangle,:torque_unit,:step_angle_mode,:step_slope )";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':template_program_name', $data['program_name']);
            $statement->bindValue(':template_step_id', $data['template_step_id']);
            $statement->bindValue(':step_name', $data['step_name']);
            $statement->bindValue(':step_targettype', $data['program_target']);
            $statement->bindValue(':step_targetangle', $data['target_angle']);
            $statement->bindValue(':step_targettorque', $data['target_torque']);
            $statement->bindValue(':step_delayttime', $data['step_delayttime']);
            $statement->bindValue(':step_tooldirection', 0);
            $statement->bindValue(':step_rpm', $data['run_down_speed']);
            $statement->bindValue(':step_offsetdirection', $data['joint_offset']);
            $statement->bindValue(':step_torque_jointoffset', $data['offset_value']);
            $statement->bindValue(':step_monitoringmode', $data['monitoringmode']);
            $statement->bindValue(':step_torwin_target', $data['step_torwin_target']);
            $statement->bindValue(':step_torquewindow', $data['step_torquewindow']);
            $statement->bindValue(':step_angwin_target', $data['step_angwin_target']);
            $statement->bindValue(':step_anglewindow', $data['step_anglewindow']);
            $statement->bindValue(':step_hightorque', $data['hi_torque']);
            $statement->bindValue(':step_lowtorque', $data['Lo_torque']);
            $statement->bindValue(':step_monitoringangle', $data['Monitoring_ON_OFF']);
            $statement->bindValue(':step_highangle', $data['hi_angle']);
            $statement->bindValue(':step_lowangle', $data['lo_angle']);
            $statement->bindValue(':torque_unit', 1);//先不管 扭力單位
            $statement->bindValue(':step_angle_mode', $data['step_angle_mode']);//先不管 扭力單位
            $statement->bindValue(':step_slope', 2000);//先不管斜率
            
            $results = $statement->execute();

        }

        return $results;
    }

    // 取得所有Advanced Template
    public function GetAllAdvancedStepTemplate()
    {
        $sql = "SELECT COUNT(*) as count,* FROM `gtcs_advancedstep_template` 
                GROUP BY template_program_id  
                ORDER BY template_program_id,MAX(template_step_id ) DESC ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);
    }

    public function GetProgramById_Advanced($program_id)
    {
        $sql= "SELECT * FROM gtcs_advancedstep_template WHERE template_program_id = :template_program_id order by template_step_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $program_id);
        $results = $statement->execute();
        $rows = $statement->fetchall(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function GetHeadAdvancedStepId($template_program_id)
    {
        $query = "SELECT template_step_id + 1 AS missing_id
                  FROM gtcs_advancedstep_template
                 WHERE (template_step_id + 1) NOT IN (SELECT template_step_id FROM gtcs_advancedstep_template where template_program_id = '".$template_program_id."' ) order by  missing_id limit 1";

        $statement = $this->db->prepare($query);
        $statement->execute();

        $result = $statement->fetch();
        if ($result == false){
            return array('0'=> 1, 'missing_id' => 1);
        }

        return $result;
    }

    public function EditStep_Advanced($data)
    {
        if( $this->CheckStepExist($data['program_id'],$data['step_id']) ){ //已存在，用update

            $sql = "UPDATE `gtcs_advancedstep_template` 
                    SET template_program_name = :template_program_name,
                        step_name = :step_name,
                        step_targettype = :step_targettype,
                        step_targetangle = :step_targetangle,
                        step_targettorque = :step_targettorque,
                        step_delayttime = :step_delayttime,
                        step_tooldirection = :step_tooldirection,
                        step_rpm = :step_rpm,
                        step_offsetdirection = :step_offsetdirection,
                        step_torque_jointoffset = :step_torque_jointoffset,
                        step_monitoringmode = :step_monitoringmode,
                        step_torwin_target = :step_torwin_target,
                        step_torquewindow = :step_torquewindow,
                        step_angwin_target = :step_angwin_target,
                        step_anglewindow = :step_anglewindow,
                        step_hightorque = :step_hightorque,
                        step_lowtorque = :step_lowtorque,
                        step_torquewindow = :step_torquewindow,
                        step_monitoringangle  = :step_monitoringangle,
                        step_highangle = :step_highangle,
                        step_lowangle = :step_lowangle,
                        torque_unit = :torque_unit,
                        step_angle_mode = :step_angle_mode,
                        step_slope = :step_slope 

                    WHERE template_program_id = :template_program_id AND template_step_id = :template_step_id ";
            $statement = $this->db->prepare($sql);
            // var_dump($this->db->errorInfo());
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':template_program_name', $data['program_name']);
            $statement->bindValue(':template_step_id', $data['step_id']);
            $statement->bindValue(':step_name', $data['step_name']);
            $statement->bindValue(':step_targettype', $data['target_type']);
            $statement->bindValue(':step_targetangle', $data['target_angle']);
            $statement->bindValue(':step_targettorque', $data['target_torque']);
            $statement->bindValue(':step_delayttime', $data['delay_time']);
            $statement->bindValue(':step_tooldirection', $data['direction']);
            $statement->bindValue(':step_rpm', $data['run_down_speed']);
            $statement->bindValue(':step_offsetdirection', $data['joint_offset']);
            $statement->bindValue(':step_torque_jointoffset', $data['offset_value']);
            $statement->bindValue(':step_monitoringmode', $data['monitor_mode']);
            $statement->bindValue(':step_torwin_target', $data['torque_window']);
            $statement->bindValue(':step_torquewindow', $data['torque_window_range']);
            $statement->bindValue(':step_angwin_target', $data['angle_window']);
            $statement->bindValue(':step_anglewindow', $data['angle_window_range']);
            $statement->bindValue(':step_hightorque', $data['hi_torque']);
            $statement->bindValue(':step_lowtorque', $data['lo_torque']);
            $statement->bindValue(':step_monitoringangle', $data['monitor_angle']);
            $statement->bindValue(':step_highangle', $data['hi_angle']);
            $statement->bindValue(':step_lowangle', $data['lo_angle']);
            $statement->bindValue(':torque_unit', 1);//先不管 扭力單位
            $statement->bindValue(':step_angle_mode', $data['record_angle_val']);//先不管
            $statement->bindValue(':step_slope', 2000);//先不管斜率
            $results = $statement->execute();

        }else{ //不存在，用insert

            $sql = "INSERT INTO `gtcs_advancedstep_template` ('template_program_id','template_program_name','template_step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_delayttime','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_monitoringmode','step_torwin_target','step_torquewindow','step_angwin_target','step_anglewindow','step_hightorque','step_lowtorque','step_monitoringangle','step_highangle','step_lowangle','torque_unit','step_angle_mode','step_slope' )
                    VALUES (:template_program_id,:template_program_name,:template_step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_delayttime,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_monitoringmode,:step_torwin_target,:step_torquewindow,:step_angwin_target,:step_anglewindow,:step_hightorque,:step_lowtorque,:step_monitoringangle,:step_highangle,:step_lowangle,:torque_unit,:step_angle_mode,:step_slope )";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':template_program_id', $data['program_id']);
            $statement->bindValue(':template_program_name', $data['program_name']);
            $statement->bindValue(':template_step_id', $data['step_id']);
            $statement->bindValue(':step_name', $data['step_name']);
            $statement->bindValue(':step_targettype', $data['target_type']);
            $statement->bindValue(':step_targetangle', $data['target_angle']);
            $statement->bindValue(':step_targettorque', $data['target_torque']);
            $statement->bindValue(':step_delayttime', $data['delay_time']);
            $statement->bindValue(':step_tooldirection', $data['direction']);
            $statement->bindValue(':step_rpm', $data['run_down_speed']);
            $statement->bindValue(':step_offsetdirection', $data['joint_offset']);
            $statement->bindValue(':step_torque_jointoffset', $data['offset_value']);
            $statement->bindValue(':step_monitoringmode', $data['monitor_mode']);
            $statement->bindValue(':step_torwin_target', $data['torque_window']);
            $statement->bindValue(':step_torquewindow', $data['torque_window_range']);
            $statement->bindValue(':step_angwin_target', $data['angle_window']);
            $statement->bindValue(':step_anglewindow', $data['angle_window_range']);
            $statement->bindValue(':step_hightorque', $data['hi_torque']);
            $statement->bindValue(':step_lowtorque', $data['lo_torque']);
            $statement->bindValue(':step_monitoringangle', $data['monitor_angle']);
            $statement->bindValue(':step_highangle', $data['hi_angle']);
            $statement->bindValue(':step_lowangle', $data['lo_angle']);
            $statement->bindValue(':torque_unit', 1);//先不管 扭力單位
            $statement->bindValue(':step_angle_mode', $data['record_angle_val']);//先不管
            $statement->bindValue(':step_slope', 2000);//先不管斜率
            
            $results = $statement->execute();

        }

        return $results;
    }

    public function CheckStepExist($template_program_id,$step_id)
    {
        $sql = "SELECT count(*) as count FROM gtcs_advancedstep_template WHERE template_program_id = :template_program_id AND  template_step_id = :template_step_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $template_program_id);
        $statement->bindValue(':template_step_id', $step_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function GetStepById_Advanced($program_id,$step)
    {
        $sql= "SELECT * FROM gtcs_advancedstep_template WHERE template_program_id = :template_program_id AND template_step_id = :template_step_id order by template_step_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':template_program_id', $program_id);
        $statement->bindValue(':template_step_id', $step);
        $results = $statement->execute();
        $rows = $statement->fetch(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function Copystep($from_pro_id,$from_step_id,$to_step_id,$to_step_name,$job_type)
    {
        // 判斷seq_id是否存在，若存在就先把舊的刪除
        // $dupli_flag true:表示to_pro_id已存在 false:表示to_pro_id不存在
        $dupli_flag = $this->CheckStepExist($from_pro_id,$to_step_id);

        if($dupli_flag){
            $this->DeleteStepById($from_pro_id,$to_step_id);
        }

        if($job_type == 'advanced'){
            $sql= "INSERT INTO `gtcs_advancedstep_template` (template_program_id,template_program_name,template_step_id,step_name,step_targettype,step_targetangle,step_targettorque,step_delayttime,step_tooldirection,step_rpm,step_offsetdirection,step_torque_jointoffset,step_monitoringmode,step_torwin_target,step_torquewindow,step_angwin_target,step_anglewindow,step_hightorque,step_lowtorque,step_monitoringangle,step_highangle,step_lowangle,torque_unit,step_angle_mode,step_slope )

                SELECT  template_program_id,template_program_name,:to_step_id,:to_step_name,step_targettype,step_targetangle,step_targettorque,step_delayttime,step_tooldirection,step_rpm,step_offsetdirection,step_torque_jointoffset,step_monitoringmode,step_torwin_target,step_torquewindow,step_angwin_target,step_anglewindow,step_hightorque,step_lowtorque,step_monitoringangle,step_highangle,step_lowangle,torque_unit,step_angle_mode,step_slope 
                FROM    gtcs_advancedstep_template
                WHERE template_program_id = :from_pro_id AND template_step_id = :from_step_id ";
            $stmt = $this->db->prepare($sql);
            
            $stmt->bindValue(':from_pro_id', $from_pro_id);
            $stmt->bindValue(':from_step_id', $from_step_id);
            $stmt->bindValue(':to_step_id', $to_step_id);
            $stmt->bindValue(':to_step_name', $to_step_name);
            $results = $stmt->execute();
        }
        
        return $results;
    }

    public function DeleteStepById($template_program_id,$step_id)
    {
        //刪除advancedstep
        $stmt = $this->db->prepare('DELETE FROM gtcs_advancedstep_template WHERE template_program_id = :template_program_id AND template_step_id = :template_step_id ');
        $stmt->bindValue(':template_program_id', $template_program_id);
        $stmt->bindValue(':template_step_id', $step_id);
        $results = $stmt->execute();

        //更新seq_id
        $sql2= "UPDATE gtcs_advancedstep_template SET template_step_id = template_step_id - 1 WHERE template_program_id = :template_program_id AND template_step_id > :template_step_id;";
        $statement2 = $this->db->prepare($sql2);
        $statement2->bindValue(':template_program_id', $template_program_id);
        $statement2->bindValue(':template_step_id', $step_id);
        $results2 = $statement2->execute();
    }


    public function search_data_info($program_id) {

        $sql = "SELECT * FROM task WHERE template_program_id = ?";
        $statement = $this->db->prepare($sql);
        $statement->execute([$program_id]);
        return $statement->fetchAll(PDO::FETCH_ASSOC);
    }

    public function search_data($program_id,$table){

        $sql = "SELECT * FROM " . $table . " WHERE template_program_id = ?";
        $statement = $this->db->prepare($sql);
        $statement->execute([$program_id]);
        $results = $statement->fetchAll(PDO::FETCH_ASSOC);
        return $results;
    }

    


    public function cover_data($new_array,$table_name){
        $insertedCount = 0;
        
        if($table_name == "ccs_advancedstep"){

            $sql = "DELETE FROM ccs_advancedstep  WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
            try {
                $statement = $this->db->prepare($sql);
                
                if ($statement === false) {
                    $errorInfo = $this->db->errorInfo();
                    error_log('数据库准备语句失败: ' . $errorInfo[2]);
                    return;
                }
        
                foreach ($new_array as $item) {
                    if (!$statement->execute([
                        ':job_id' => $item['job_id'],
                        ':seq_id' => $item['seq_id'],
                        ':task_id' => $item['task_id']
                    ])) {
                        // 打印执行失败的错误信息
                        $errorInfo = $statement->errorInfo();
                        error_log('执行删除操作失败: ' . $errorInfo[2]);
                    }
                }
            } catch (PDOException $e) {
                error_log('数据库删除错误: ' . $e->getMessage());
            }





         
            foreach ($new_array as $item) {
                $sql = "INSERT INTO $table_name ('job_id','seq_id','task_id','step_id','step_name','step_targettype','step_targetangle','step_targettorque','step_delayttime','step_tooldirection','step_rpm','step_offsetdirection','step_torque_jointoffset','step_monitoringmode','step_torwin_target','step_torquewindow','step_angwin_target','step_anglewindow','step_hightorque','step_lowtorque','step_monitoringangle','step_highangle','step_lowangle','torque_unit','step_angle_mode','step_slope' )
                    VALUES ( :job_id,:seq_id,:task_id,:step_id,:step_name,:step_targettype,:step_targetangle,:step_targettorque,:step_delayttime,:step_tooldirection,:step_rpm,:step_offsetdirection,:step_torque_jointoffset,:step_monitoringmode,:step_torwin_target,:step_torquewindow,:step_angwin_target,:step_anglewindow,:step_hightorque,:step_lowtorque,:step_monitoringangle,:step_highangle,:step_lowangle,:torque_unit,:step_angle_mode,:step_slope )";
                
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
                    'step_slope' => $item['step_slope']
                ])) {
                    $insertedCount++;
                } else {
                    $errorInfo = $statement->errorInfo();
                    echo "插入失败: " . $errorInfo[2];
                }
            }



        }

        
        if ($table_name == "ccs_normalstep" ){
            $sql = "DELETE FROM ccs_normalstep  WHERE job_id = :job_id AND seq_id = :seq_id AND task_id = :task_id";
    
            try {
                $statement = $this->db->prepare($sql);
                
                if ($statement === false) {
                    $errorInfo = $this->db->errorInfo();
                    error_log('数据库准备语句失败: ' . $errorInfo[2]);
                    return;
                }
        
                foreach ($new_array as $item) {
                    if (!$statement->execute([
                        ':job_id' => $item['job_id'],
                        ':seq_id' => $item['seq_id'],
                        ':task_id' => $item['task_id']
                    ])) {
                        // 打印执行失败的错误信息
                        $errorInfo = $statement->errorInfo();
                        error_log('执行删除操作失败: ' . $errorInfo[2]);
                    }
                }
            } catch (PDOException $e) {
                error_log('数据库删除错误: ' . $e->getMessage());
            }


            //新增資料
            foreach ($new_array as $item) {
                // 构建 SQL 插入语句
                $sql = "INSERT INTO $table_name (
                            job_id, seq_id, task_id, step_name, step_targettype, step_targetangle, 
                            step_targettorque, step_tooldirection, step_rpm, step_offsetdirection, 
                            step_torque_jointoffset, step_hightorque, step_lowtorque, step_threshold_mode, 
                            step_threshold_torque, step_threshold_angle, step_monitoringangle, step_highangle, 
                            step_lowangle, step_downshift_enable, step_downshift_torque, step_downshift_speed, 
                            torque_unit, step_prr, step_prr_rpm, step_prr_angle, step_downshift_mode, 
                            step_downshift_angle
                        ) VALUES (
                            :job_id, :seq_id, :task_id, :step_name, :step_targettype, :step_targetangle, 
                            :step_targettorque, :step_tooldirection, :step_rpm, :step_offsetdirection, 
                            :step_torque_jointoffset, :step_hightorque, :step_lowtorque, :step_threshold_mode, 
                            :step_threshold_torque, :step_threshold_angle, :step_monitoringangle, :step_highangle, 
                            :step_lowangle, :step_downshift_enable, :step_downshift_torque, :step_downshift_speed, 
                            :torque_unit, :step_prr, :step_prr_rpm, :step_prr_angle, :step_downshift_mode, 
                            :step_downshift_angle
                        )";
                
                try {
                    $statement = $this->db->prepare($sql);
        
                    // 执行插入操作
                    if ($statement->execute([
                        ':job_id' => $item['job_id'],
                        ':seq_id' => $item['seq_id'],
                        ':task_id' => $item['task_id'],
                        ':step_name' => $item['step_name'],
                        ':step_targettype' => $item['step_targettype'],
                        ':step_targetangle' => $item['step_targetangle'],
                        ':step_targettorque' => $item['step_targettorque'],
                        ':step_tooldirection' => $item['step_tooldirection'],
                        ':step_rpm' => $item['step_rpm'],
                        ':step_offsetdirection' => $item['step_offsetdirection'],
                        ':step_torque_jointoffset' => $item['step_torque_jointoffset'],
                        ':step_hightorque' => $item['step_hightorque'],
                        ':step_lowtorque' => $item['step_lowtorque'],
                        ':step_threshold_mode' => $item['step_threshold_mode'],
                        ':step_threshold_torque' => $item['step_threshold_torque'],
                        ':step_threshold_angle' => $item['step_threshold_angle'],
                        ':step_monitoringangle' => $item['step_monitoringangle'],
                        ':step_highangle' => $item['step_highangle'],
                        ':step_lowangle' => $item['step_lowangle'],
                        ':step_downshift_enable' => $item['step_downshift_enable'],
                        ':step_downshift_torque' => $item['step_downshift_torque'],
                        ':step_downshift_speed' => $item['step_downshift_speed'],
                        ':torque_unit' => $item['torque_unit'],
                        ':step_prr' => $item['step_prr'],
                        ':step_prr_rpm' => $item['step_prr_rpm'],
                        ':step_prr_angle' => $item['step_prr_angle'],
                        ':step_downshift_mode' => $item['step_downshift_mode'],
                        ':step_downshift_angle' => $item['step_downshift_angle']
                    ])) {
                        $insertedCount++;
                    } else {
                        // 输出插入失败的错误信息
                        $errorInfo = $statement->errorInfo();
                        error_log('执行插入操作失败: ' . $errorInfo[2]);
                    }
                } catch (PDOException $e) {
                    // 捕获并记录数据库异常
                    error_log('数据库插入错误: ' . $e->getMessage());
                }
            }


        }
        return $insertedCount;

    
    }
    

    public function get_job_by_pro_id($program_id){
        $sql = "SELECT job.job_id , job.job_name 
                FROM task 
                LEFT JOIN job ON task.job_id = job.job_id 
                WHERE task.template_program_id = ?";
        $statement = $this->db->prepare($sql);
        $statement->execute([$program_id]);
        $results = $statement->fetchAll(PDO::FETCH_ASSOC);
    
        return $results;
    }
}