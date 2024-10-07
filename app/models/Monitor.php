<?php

class Monitor{
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


    public function GetMonitorRow()
    {
        $sql = "SELECT * FROM `monitor` ORDER BY row,position ";
        $statement = $this->db->prepare($sql);
        $result = $statement->execute();
        $results = $statement->fetchall(PDO::FETCH_ASSOC);

        return $results;
    }

    // 取得Monitor by id
    public function getMonitorById($monitor_id)
    {
        $sql = "SELECT * FROM `monitor` WHERE id = :monitor_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':id', $monitor_id);
        $statement->execute();

        return $statement->fetch(PDO::FETCH_ASSOC);
    }

    // 編輯Monitor
    public function editMonitor($data)
    {
        if($data['mode'] == 'add'){
            $sql = "INSERT INTO `monitor` ('row','position','name','ip','operators','jobs')
                    VALUES (:row,:position,:name,:ip,:operators,:jobs)";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':row', $data['station_row']);
            $statement->bindValue(':position', $data['station_position']);
            $statement->bindValue(':name', $data['station_name']);
            $statement->bindValue(':ip', $data['station_ip']);
            $statement->bindValue(':operators', $data['station_operators']);
            $statement->bindValue(':jobs', $data['station_jobs']);
        }

        if($data['mode'] == 'edit'){
            $sql = "UPDATE `monitor` SET row = :row, position = :position, name = :name, ip = :ip, operators = :operators, jobs = :jobs
                    WHERE id = :id";
            $statement = $this->db->prepare($sql);
            $statement->bindValue(':row', $data['station_row']);
            $statement->bindValue(':position', $data['station_position']);
            $statement->bindValue(':name', $data['station_name']);
            $statement->bindValue(':ip', $data['station_ip']);
            $statement->bindValue(':operators', $data['station_operators']);
            $statement->bindValue(':jobs', $data['station_jobs']);
            $statement->bindValue(':id', $data['station_id']);
        }
        
        return $statement->execute();

        // return $statement->fetch(PDO::FETCH_ASSOC);
    }

    public function deleteMonitor($station_id)
    {
        $sql = "DELETE from `monitor` WHERE id = :id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':id', $station_id);

        return $statement->execute();
    }


    public function getJobList($value='')
    {
        $sql = "SELECT job.job_id,job.job_name from `job` WHERE 1 = 1 ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getUsersList($value='')
    {
        $sql = "SELECT users.id,users.account from `users` WHERE 1 = 1 ";
        $statement = $this->db->prepare($sql);
        $statement->execute();

        return $statement->fetchAll(PDO::FETCH_ASSOC);
    }








    //-------------------------------------------------------------------------------------------------------

}
