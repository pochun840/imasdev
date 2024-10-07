<?php

class Nav{
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

    // 取得Nav列
    public function GetNav()
    {
        $sql = 'SELECT * FROM nav';
        $statement = $this->db->prepare($sql);
        $results = $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);;
    }

    // 取得permission by user id
    public function GetPermissionsByUserId($uid)
    {
        $sql = 'SELECT DISTINCT p.Route
                FROM cc_userroles ur
                JOIN cc_rolepermissions rp ON ur.RoleID = rp.RoleID
                JOIN cc_permissions p ON rp.PermissionID = p.ID
                WHERE ur.UserID = :uid';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':uid', $uid);
        $results = $statement->execute();

        return $statement->fetchall(PDO::FETCH_ASSOC);;
    }

    // 取得user id by account
    public function GetUserIdByAccount($account)
    {
        $sql = 'SELECT * FROM users WHERE account = :account';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':account', $account);
        $statement->execute();
        $results = $statement->fetch(PDO::FETCH_ASSOC);

        return $results['id'];
    }

    // 取得user id by account
    public function GetRoleIdByAccount($account)
    {
        $sql = 'SELECT * FROM users 
                LEFT JOIN cc_userroles ON users.id = cc_userroles.UserID 
                WHERE account = :account ';
        $statement = $this->db->prepare($sql);
        $statement->bindValue(':account', $account);
        $statement->execute();
        $results = $statement->fetch(PDO::FETCH_ASSOC);

        return $results['RoleID'];
    }

}
