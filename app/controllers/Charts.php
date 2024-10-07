<?php

class Charts extends Controller
{
    private $DashboardModel;
    private $NavsController;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->DashboardModel = $this->model('Main');
        $this->NavsController = $this->controller_new('Navs');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
        ];
        
        $this->view('chart/index', $data);

    }

    
}