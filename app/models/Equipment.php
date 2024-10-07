<?php

class Equipment{
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

    public function SetTowerLight($data)
    {
        $sql = "UPDATE `equipment_tower_light` SET red_light = :red_light, green_light = :green_light, yellow_light = :yellow_light, buzzer = :buzzer, pulse_time = :pulse_time WHERE light_event_id = :light_event_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':red_light', $data['NG_red_light']);
        $statement->bindValue(':green_light', $data['NG_green_light']);
        $statement->bindValue(':yellow_light', $data['NG_yellow_light']);
        $statement->bindValue(':buzzer', $data['NG_buzzer']);
        $statement->bindValue(':pulse_time', $data['NG_time']);
        $statement->bindValue(':light_event_id', '0');// 0 = ng, 1 = ok, 2 = ok-all, 3 = ok-sequence, 4 = sensor error
        $results = $statement->execute();

        $sql = "UPDATE `equipment_tower_light` SET red_light = :red_light, green_light = :green_light, yellow_light = :yellow_light, buzzer = :buzzer, pulse_time = :pulse_time WHERE light_event_id = :light_event_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':red_light', $data['OK_red_light']);
        $statement->bindValue(':green_light', $data['OK_green_light']);
        $statement->bindValue(':yellow_light', $data['OK_yellow_light']);
        $statement->bindValue(':buzzer', $data['OK_buzzer']);
        $statement->bindValue(':pulse_time', $data['OK_time']);
        $statement->bindValue(':light_event_id', 1);// 0 = ng, 1 = ok, 2 = ok-all, 3 = ok-sequence, 4 = sensor error
        $statement->execute();

        $sql = "UPDATE `equipment_tower_light` SET red_light = :red_light, green_light = :green_light, yellow_light = :yellow_light, buzzer = :buzzer, pulse_time = :pulse_time WHERE light_event_id = :light_event_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':red_light', $data['OKALL_red_light']);
        $statement->bindValue(':green_light', $data['OKALL_green_light']);
        $statement->bindValue(':yellow_light', $data['OKALL_yellow_light']);
        $statement->bindValue(':buzzer', $data['OKALL_buzzer']);
        $statement->bindValue(':pulse_time', $data['OKALL_time']);
        $statement->bindValue(':light_event_id', 2);// 0 = ng, 1 = ok, 2 = ok-all, 3 = ok-sequence, 4 = sensor error
        $statement->execute();

        $sql = "UPDATE `equipment_tower_light` SET red_light = :red_light, green_light = :green_light, yellow_light = :yellow_light, buzzer = :buzzer, pulse_time = :pulse_time WHERE light_event_id = :light_event_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':red_light', $data['OK_SEQ_red_light']);
        $statement->bindValue(':green_light', $data['OK_SEQ_green_light']);
        $statement->bindValue(':yellow_light', $data['OK_SEQ_yellow_light']);
        $statement->bindValue(':buzzer', $data['OK_SEQ_buzzer']);
        $statement->bindValue(':pulse_time', $data['OK_SEQ_time']);
        $statement->bindValue(':light_event_id', 3);// 0 = ng, 1 = ok, 2 = ok-all, 3 = ok-sequence, 4 = sensor error
        $statement->execute();

        $sql = "UPDATE `equipment_tower_light` SET red_light = :red_light, green_light = :green_light, yellow_light = :yellow_light, buzzer = :buzzer, pulse_time = :pulse_time WHERE light_event_id = :light_event_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':red_light', $data['ERROR_red_light']);
        $statement->bindValue(':green_light', $data['ERROR_green_light']);
        $statement->bindValue(':yellow_light', $data['ERROR_yellow_light']);
        $statement->bindValue(':buzzer', $data['ERROR_buzzer']);
        $statement->bindValue(':pulse_time', $data['ERROR_time']);
        $statement->bindValue(':light_event_id', 4);// 0 = ng, 1 = ok, 2 = ok-all, 3 = ok-sequence, 4 = sensor error
        $results = $statement->execute();
        
        // $results = $statement->fetch(PDO::FETCH_ASSOC);
        return $results;
    }

    public function GetTowerLightSetting()
    {
        $sql = "SELECT * FROM `equipment_tower_light` ORDER BY  light_event_id ";
        $statement = $this->db->prepare($sql);
        $results = $statement->execute();
        $results = $statement->fetchall(PDO::FETCH_ASSOC);

        return $results;
    }

    public function GetIOPinSetting()
    {
        $sql = "SELECT * FROM `equipment_io_pin` WHERE pin_type = 'output' ORDER BY pin_number ";
        $statement = $this->db->prepare($sql);
        // $statement->bindValue(':device_id', $device_id);
        $results = $statement->execute();
        $results = $statement->fetchall(PDO::FETCH_ASSOC);

        return $results;
    }

    public function Save_Controller_IP($ip)
    {
        $sql = "UPDATE `controller` SET ip = :ip WHERE controller_id = :controller_id ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':ip', $ip);
        $statement->bindValue(':controller_id', 1);
        $result = $statement->execute();

        return $result;
    }

    public function GetControllerIP($controller_id)
    {
        $sql = "SELECT * FROM `controller` WHERE controller_id = :controller_id  ";
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':controller_id', $controller_id);
        $statement->execute();
        $result = $statement->fetch(PDO::FETCH_ASSOC);

        return $result['ip'];
    }


}
