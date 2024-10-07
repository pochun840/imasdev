<?php

class Sequence{
    private $db;//condb control box

    // 在建構子將 Database 物件實例化
    public function __construct()
    {
        $this->db = new Database;
        $this->db = $this->db->getDb_cc();
    }

    // 取得所有Sequence
    public function getSequences($job_id)
    {
        $sql = "SELECT * FROM `sequence` WHERE job_id = :job_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);
    }

    // 取得所有Sequence
    public function getSequences_enable($job_id)
    {
        $sql = "SELECT * FROM `sequence` WHERE job_id = :job_id AND sequence_enable = 1";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);
    }

    // 取得所有Sequence
    public function getJob($job_id)
    {
        $sql = "SELECT * FROM `job` WHERE job_id = :job_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->execute();

        return $statement->fetch(PDO::FETCH_ASSOC);
    }


    //取得job id，依job_type判斷
    public function get_head_seq_id($job_id){

        $query = "SELECT seq_id FROM sequence where job_id = :job_id ";

        $statement = $this->db->prepare($query);
        $statement->bindValue(':job_id', $job_id);
        $statement->execute();

        $result = $statement->fetch();
        if ($result == false || empty($result) ){
            return array('0'=> 1, 'missing_id' => 1);
        }

        $query = "SELECT seq_id + 1 AS missing_id
                  FROM sequence
                  WHERE (seq_id + 1) NOT IN ( SELECT seq_id FROM sequence where job_id = :job_id ) order by  missing_id limit 1";

        $statement = $this->db->prepare($query);
        $statement->bindValue(':job_id', $job_id);
        $statement->execute();

        return $statement->fetch();
    }

    //編輯or新增job
    public function EditSeq($data)
    {
        if( $this->CheckSeqExist($data['job_id'],$data['seq_id']) ){ //已存在，用update

            $sql = "UPDATE `sequence` 
                    SET 
                        seq_name = :seq_name,
                        tightening_repeat = :tightening_repeat,
                        ng_stop = :ng_stop,
                        ok_sequence = :ok_sequence,
                        ok_sequence_stop = :ok_sequence_stop,
                        sequence_mintime = :sequence_mintime,
                        sequence_maxtime = :sequence_maxtime,
                        barcode_start = :barcode_start
                    WHERE job_id = :job_id AND seq_id = :seq_id";
            $statement = $this->db->prepare($sql);
           // $statement->bindValue(':sequence_enable', $data['seq_enable']);
            $statement->bindValue(':seq_name', $data['seq_name']);
            $statement->bindValue(':tightening_repeat', 1); //中控預設1
            $statement->bindValue(':ng_stop', $data['stop_on_NG']);
            $statement->bindValue(':ok_sequence', $data['ok_seq']);
            $statement->bindValue(':ok_sequence_stop', $data['ok_seq_stop']);
            $statement->bindValue(':sequence_maxtime', $data['timeout']);
            $statement->bindValue(':barcode_start', $data['barcode_enable']);
            $statement->bindValue(':sequence_mintime', 0);
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':job_id', $data['job_id']);
            $results = $statement->execute();

        }else{ //不存在，用insert

            //echo "eeeeerty";die();
            $sql = "INSERT INTO `sequence` ('sequence_enable','job_id','seq_id','seq_name','tightening_repeat','ng_stop','ok_sequence','ok_sequence_stop','sequence_mintime','sequence_maxtime','img' ,'barcode_start' )
                    VALUES (:sequence_enable,:job_id,:seq_id,:seq_name,:tightening_repeat,:ng_stop,:ok_sequence,:ok_sequence_stop,:sequence_mintime,:sequence_maxtime,:img,:barcode_start)";
            $statement = $this->db->prepare($sql);

            $statement->bindValue(':sequence_enable', 1);
            $statement->bindValue(':seq_name', $data['seq_name']);
            $statement->bindValue(':tightening_repeat', 1); //中控預設1
            $statement->bindValue(':ng_stop', $data['stop_on_NG']);
            $statement->bindValue(':ok_sequence', $data['ok_seq']);
            $statement->bindValue(':ok_sequence_stop', $data['ok_seq_stop']);
            $statement->bindValue(':sequence_mintime', 0);
            $statement->bindValue(':sequence_maxtime', $data['timeout']);
            $statement->bindValue(':img', '');
            $statement->bindValue(':seq_id', $data['seq_id']);
            $statement->bindValue(':job_id', $data['job_id']);
            $statement->bindValue(':barcode_start', $data['barcode_enable']);
            $results = $statement->execute();

        }

        return $results;
    }

    //get seq by job_id and seq_id
    public function GetSeqById($job_id,$seq_id){

        $sql= "SELECT * FROM sequence WHERE job_id = :job_id AND seq_id = :seq_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $results = $statement->execute();
        $rows = $statement->fetch(PDO::FETCH_ASSOC);

        return $rows;
    }

    //enable or disable sequence
    public function EnableDisableSeq($job_id,$seq_id,$status)   
    {
        $sql = "UPDATE `sequence` SET 'sequence_enable'= :sequence_enable WHERE job_id = :job_id AND seq_id = :seq_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':sequence_enable', $status);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $results = $statement->execute();
        return $results;
    }

    public function SetSeqImage($job_id,$seq_id,$img_url)
    {
        $sql = "UPDATE `sequence` 
                    SET img = :img 
                    WHERE job_id = :job_id AND seq_id = :seq_id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':job_id', $job_id);
            $statement->bindValue(':seq_id', $seq_id);
            $statement->bindValue(':img', $img_url);
            $results = $statement->execute();

        return $results;
    }

    //檢查job id是否已存在
    public function CheckSeqExist($job_id,$seq_id)
    {
        $sql = "SELECT count(*) as count FROM sequence WHERE job_id = :job_id AND seq_id = :seq_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $results = $statement->execute();
        $rows = $statement->fetch();

        if ($rows['count'] > 0) {
            return true; // job 已存在
        }else{
            return false; // job 不存在
        }
    }

    public function CopySeq($from_job_id,$from_seq_id,$to_seq_id,$to_seq_name)
    {
        // 判斷seq_id是否存在，若存在就先把舊的刪除
        // $dupli_flag true:表示job_id已存在 false:表示job_id不存在
        $dupli_flag = $this->CheckSeqExist($from_job_id,$to_seq_id);

        if($dupli_flag){
            $this->DeleteSeqById($from_job_id,$to_seq_id);
        }
        $sql= "INSERT INTO sequence ( sequence_enable,job_id,seq_id,seq_name,img,tightening_repeat,ng_stop,ok_sequence,ok_sequence_stop,sequence_mintime,sequence_maxtime )
            SELECT  sequence_enable,job_id,:to_seq_id,:to_seq_name,img,tightening_repeat,ng_stop,ok_sequence,ok_sequence_stop,sequence_mintime,sequence_maxtime
            FROM    sequence
            WHERE job_id = :job_id AND seq_id = :seq_id";
        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':to_seq_id', $to_seq_id);
        $stmt->bindValue(':to_seq_name', $to_seq_name);

        $stmt->bindValue(':job_id', $from_job_id);
        $stmt->bindValue(':seq_id', $from_seq_id);

        return $results = $stmt->execute();
    }

    public function DeleteSeqById($job_id,$seq_id)
    {

          //找到該job的sequence 是否有存取圖片
          $stmt = $this->db->prepare('SELECT img FROM sequence WHERE job_id = :job_id AND seq_id =:seq_id');
          $stmt->bindValue(':job_id', $job_id);
          $stmt->bindValue(':seq_id', $seq_id);
          $stmt->execute();
          $seq = $stmt->fetch(PDO::FETCH_ASSOC);
  
          if ($seq && !empty($seq['img'])) {
              $imgPath_seq = $seq['img'];
              if (file_exists($imgPath_seq)) {
                  unlink($imgPath_seq);
              }
          }


        //刪除sequence
        $stmt = $this->db->prepare('DELETE FROM sequence WHERE job_id = :job_id AND seq_id = :seq_id');
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results = $stmt->execute();

        //更新seq_id
        $sql2= "UPDATE sequence SET seq_id = seq_id - 1 WHERE job_id = :job_id AND seq_id > :seq_id";
        $stmt = $this->db->prepare($sql2);
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results2 = $stmt->execute();


        //更新對應的step

        //刪除task
        $stmt = $this->db->prepare('DELETE FROM task WHERE job_id = :job_id AND seq_id = :seq_id');
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results = $stmt->execute();

        //刪除task_meaasge
        $stmt = $this->db->prepare('DELETE FROM task_message WHERE job_id = :job_id AND seq_id = :seq_id');
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results = $stmt->execute();


        //更新task的seq_id
        $sql2= "UPDATE task SET seq_id = seq_id - 1 WHERE job_id = :job_id AND seq_id > :seq_id";
        $stmt = $this->db->prepare($sql2);
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results2 = $stmt->execute();



        //刪除其他關聯
        //delete ccs_normalstep
        $statement = $this->db->prepare('DELETE FROM ccs_normalstep WHERE job_id = :job_id AND seq_id = :seq_id  ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $results = $statement->execute();
        //delete ccs_advancedstep
        $statement = $this->db->prepare('DELETE FROM ccs_advancedstep WHERE job_id = :job_id AND seq_id = :seq_id  ');
        $statement->bindValue(':job_id', $job_id);
        $statement->bindValue(':seq_id', $seq_id);
        $results = $statement->execute();

         //更新ccs_normalstep
        $sql2= "UPDATE ccs_normalstep SET seq_id = seq_id - 1 WHERE job_id = :job_id AND seq_id > :seq_id";
        $stmt = $this->db->prepare($sql2);
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results2 = $stmt->execute();
        //ccs_advancedstep
        $sql2= "UPDATE ccs_advancedstep SET seq_id = seq_id - 1 WHERE job_id = :job_id AND seq_id > :seq_id";
        $stmt = $this->db->prepare($sql2);
        $stmt->bindValue(':job_id', $job_id);
        $stmt->bindValue(':seq_id', $seq_id);
        $results2 = $stmt->execute();
        
        return $results;
    }


    public function check_task_by_seq_id($from_job_id, $from_seq_id, $to_seq_id)
    {
        // 先用 $from_job_id 和 $to_seq_id 在 task 查詢是否有資料
        $query = "SELECT COUNT(*) AS count FROM task WHERE job_id = ? AND seq_id = ? ";
        $statement_select = $this->db->prepare($query);
        $statement_select->execute([$from_job_id, $to_seq_id]);
        $row = $statement_select->fetch(PDO::FETCH_ASSOC);
    
        //有資料的話就要刪除
        if ($row['count'] > 0) {
            $sql_delete = "DELETE FROM task WHERE job_id = ? AND seq_id = ?";
            $statement_delete = $this->db->prepare($sql_delete);
            $statement_delete->execute([$from_job_id, $to_seq_id]);
        }
    
        //查詢 $from_job_id 和 $from_seq_id 在 task是否有資料
        $sql = "SELECT * FROM task WHERE job_id = :job_id AND seq_id = :seq_id";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $from_job_id);
        $statement->bindValue(':seq_id', $from_seq_id);
        $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);
    
        return $rows;
    
    }


    public function copy_task_by_seq_id($new_temp_task){
        $sql = "INSERT INTO `task` (job_id, seq_id, task_id, controller, enable_equipment, enable_arm, position_x, position_y, tolerance, tolerance2, pts, template_program_id, circle_div, delay)
                VALUES (:job_id, :seq_id, :task_id, :controller, :enable_equipment, :enable_arm, :position_x, :position_y, :tolerance, :tolerance2, :pts, :template_program_id, :circle_div, :delay)";

        $statement = $this->db->prepare($sql);
        $insertedRecords_task = 0;

        foreach ($new_temp_task as $task) {
            $params = array(
                ':job_id' => $task['job_id'],
                ':seq_id' => $task['seq_id'],
                ':task_id' => $task['task_id'],
                ':controller' => $task['controller'],
                ':enable_equipment' => $task['enable_equipment'],
                ':enable_arm' => $task['enable_arm'],
                ':position_x' => $task['position_x'],
                ':position_y' => $task['position_y'],
                ':tolerance' => $task['tolerance'],
                ':tolerance2' => $task['tolerance2'],
                ':pts' => $task['pts'],
                ':template_program_id' => $task['template_program_id'],
                ':circle_div' => $task['circle_div'],
                ':delay' => $task['delay']
            );

            if ($statement->execute($params)) {
                $insertedRecords_task++;
            } else {
            
                $errorInfo = $statement->errorInfo();
                echo "SQL Error: " . $errorInfo[2];
            }
        }

        return $insertedRecords_task;
    }

    public function check_pro_id_template($table_name,$from_job_id,$from_seq_id){

        $allowed_tables = array('ccs_normalstep', 'ccs_advancedstep');

        if (!in_array($table_name, $allowed_tables)) {
            throw new InvalidArgumentException('Invalid table name.');
        }

        $sql = "SELECT * FROM $table_name WHERE job_id = :job_id AND seq_id = :seq_id ";
        $stmt = $this->db->prepare($sql); 
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':job_id', $from_job_id);
        $statement->bindValue(':seq_id', $from_seq_id);
        $statement->execute();
        $rows = $statement->fetchAll(PDO::FETCH_ASSOC);
    
        return $rows;
        
    }
    public function check_pro_id_for_ccs_normalstep($new_temp_task,$from_job_id){


        foreach($new_temp_task as $key =>$task ){
            $query = "SELECT * FROM ccs_normalstep WHERE job_id = ? AND seq_id = ?  ";
            $statement_select = $this->db->prepare($query);

            $statement_select->execute([$from_job_id,$task['seq_id'] ]);
            $statement_select->execute();
            $result = $statement_select->fetchAll(PDO::FETCH_ASSOC);

        }
        return $result;


    }


    
    

}
