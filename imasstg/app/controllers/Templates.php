<?php

class Templates extends Controller
{
    private $TemplateModel;
    private $NavsController;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->TemplateModel = $this->model('Template');
        $this->NavsController = $this->controller_new('Navs');
    }

    // 
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
        ];
        
        $this->view('template/index', $data);

    }

    // 
    public function normalstep_index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $NormalSteps = $this->TemplateModel->GetAllNormalStepTemplate();

        //前端顯示預處理
        foreach ($NormalSteps as $key => $value) {
            if($NormalSteps[$key]['step_targettype'] == 1){
                $NormalSteps[$key]['step_targettorque'] = '0';
            }else{
                $NormalSteps[$key]['step_targetangle'] = '0';
            }


            if($NormalSteps[$key]['step_downshift_enable'] == 0){
                $NormalSteps[$key]['step_downshift_enable'] = 'OFF';
            }else{
                $NormalSteps[$key]['step_downshift_enable'] = 'ON';
            }

            if($NormalSteps[$key]['step_threshold_mode'] == 0){
                $NormalSteps[$key]['step_threshold_mode'] = 'OFF';
            }else{
                $NormalSteps[$key]['step_threshold_mode'] = 'ON';
            }

            if($NormalSteps[$key]['step_monitoringangle'] == 0){
                $NormalSteps[$key]['step_monitoringangle'] = 'OFF';
            }else{
                $NormalSteps[$key]['step_monitoringangle'] = 'ON';
            }

            if($NormalSteps[$key]['step_prr'] == 0){
                $NormalSteps[$key]['step_prr'] = 'OFF';
            }else{
                $NormalSteps[$key]['step_prr'] = 'ON';
            }
        }

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'NormalSteps' => $NormalSteps,
        ];
        
        $this->view('template/gtcs/normal.index', $data);

    }

    // 
    public function advancedstep_index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $AdvancedSteps = $this->TemplateModel->GetAllAdvancedStepTemplate();

        foreach ($AdvancedSteps as $key => $advstep) {
            $advancedstep = $this->TemplateModel->GetProgramById_Advanced($advstep['template_program_id']);
            foreach ($advancedstep as $key2 => $step) {
                $AdvancedSteps[$key]['targettype_list'][$key2] = $step['step_targettype'];
            }
        }

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'AdvancedSteps' => $AdvancedSteps,
        ];
        
        $this->view('template/gtcs/adv.index', $data);

    }

    // 
    public function advancedstep_step($template_program_id){

        if( isset($template_program_id) && !empty($template_program_id) ){

        }else{
            $template_program_id = 1;
        }

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $program_name = '';

        $advancedstep = $this->TemplateModel->GetProgramById_Advanced($template_program_id);
        foreach ($advancedstep as $key => $value) {//預處理 為了list顯示
            if($advancedstep[$key]['step_targettype'] == 1){
                $advancedstep[$key]['step_targettorque'] = '0';
            }else{
                $advancedstep[$key]['step_targetangle'] = '0';
            }
            //判斷是用window還是Hi-Lo， 
            //step_monitoringmode  0 window ，1 Hi-Lo
            if($value['step_monitoringmode'] == 0){
                $advancedstep[$key]['step_hightorque'] = $advancedstep[$key]['step_torwin_target'] + $advancedstep[$key]['step_torquewindow'];
                $advancedstep[$key]['step_lowtorque'] = $advancedstep[$key]['step_torwin_target'] - $advancedstep[$key]['step_torquewindow'];
                $advancedstep[$key]['step_highangle'] = $advancedstep[$key]['step_angwin_target'] + $advancedstep[$key]['step_anglewindow'];
                $advancedstep[$key]['step_lowangle'] = $advancedstep[$key]['step_angwin_target'] - $advancedstep[$key]['step_anglewindow'];
            }

            //判斷如果是target type = torque，是否要監控角度，有的話才顯示Hi A Lo A
            if ($value['step_targettype'] == 2 && $value['step_monitoringangle'] == 0) {
                $advancedstep[$key]['step_highangle'] = '-';
                $advancedstep[$key]['step_lowangle'] = '-';
            }
        }


        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'steps' => $advancedstep,
            'program_id' => $template_program_id,
            'program_name' => $advancedstep[0]['template_program_name'],
        ];
        
        $this->view('template/gtcs/adv.step.index', $data);

    }

    //get all normalstep
    public function get_all_program_normal($value='')
    {
        // code...
    }

    public function get_head_program_id(){
        $head_job_id = $this->TemplateModel->GetHeadProgramId();

        echo json_encode($head_job_id);
        exit();
    }

    //create seq
    public function edit_program(){

        $error_message = '';

        if(isset($_POST)){//form資料
            $data_array = $_POST;
            $input_check = true;
            $error_message = '';
            //要再加入判斷
            if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            }else{ 
                $input_check = false; 
                $error_message .= 'program_id';
            }
            if( !empty($_POST['program_name']) && isset($_POST['program_name'])  ){
            }else{ 
                $input_check = false; 
                $error_message .= 'program_name';
            }
            if( isset($_POST['target_type'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'target_type';
            }
            if( !empty($_POST['target_angle']) && isset($_POST['target_angle'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'target_angle';
            }
            if( !empty($_POST['target_torque']) && isset($_POST['target_torque'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'target_torque';
            }
            if(  isset($_POST['hi_angle'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'hi_angle';
            }
            if(  isset($_POST['lo_angle'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'lo_angle';
            }
            if( !empty($_POST['hi_torque']) && isset($_POST['hi_torque'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'hi_torque';
            }
            if(  isset($_POST['Lo_torque'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'Lo_torque';
            }
            if(  isset($_POST['joint_offset'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'joint_offset';
            }
            if(  isset($_POST['offset_value'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'offset_value';
            }
            if( !empty($_POST['run_down_speed']) && isset($_POST['run_down_speed'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'run_down_speed';
            }
            if( isset($_POST['Threshold_Type'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'Threshold_Type';
            }
            if(  isset($_POST['threshold_torque'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'threshold_torque';
            }
            if(  isset($_POST['threshold_angle'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'threshold_angle';
            }
            if(  isset($_POST['Downshift_ON_OFF'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'Downshift_ON_OFF';
            }
            if(  isset($_POST['downshift_torque'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'downshift_torque';
            }
            if( isset($_POST['downshift_speed'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'downshift_speed';
            }
            if(  isset($_POST['Pre_run'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'Pre_run';
            }
            if( !empty($_POST['pre_run_rpm']) && isset($_POST['pre_run_rpm'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'pre_run_rpm';
            }
            if( !empty($_POST['pre_run_angle']) && isset($_POST['pre_run_angle'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'pre_run_angle';
            }
            if(  isset($_POST['Monitoring_ON_OFF'])  ){
            }else{ 
                $input_check = false;
                $error_message .= 'Monitoring_ON_OFF';
            }

            if ($input_check) {
                $step = $this->TemplateModel->EditProgram_Normal($data_array);
            }
        }

        echo json_encode(array('error' => $error_message));
        exit();
    }

    public function get_program_by_id()
    {
        $input_check = true;
        //因job id是由系統指派，在create job時，抓取最前面的job id 帶入
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
        }

        if($input_check){
            $program_data = $this->TemplateModel->GetProgramById_Normal($program_id);    
        }

        echo json_encode($program_data);
    }

    //copy program
    public function copy_program()
    {
        $input_check = true;
        $res = 'fail';
        $error_message = '';

        if( !empty($_POST['from_pro_id']) && isset($_POST['from_pro_id'])  ){
            $from_pro_id = $_POST['from_pro_id'];    
        }else{ 
            $input_check = false; 
            $error_message .= "from_pro_id,";
        }

        if( !empty($_POST['to_pro_id']) && isset($_POST['to_pro_id'])  ){
            $to_pro_id = $_POST['to_pro_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "to_pro_id,";
        }

        if( !empty($_POST['to_pro_name']) && isset($_POST['to_pro_name'])  ){
            $to_pro_name = $_POST['to_pro_name'];    
        }else{ 
            $input_check = false; 
            $error_message .= "to_pro_name,";
        }

        if( !empty($_POST['job_type']) && isset($_POST['job_type'])  ){
            $job_type = $_POST['job_type'];    
        }else{ 
            $input_check = false; 
            $error_message .= "job_type,";
        }

        if ($input_check) {
            $result = $this->TemplateModel->Copypro($from_pro_id,$to_pro_id,$to_pro_name,$job_type);
            echo json_encode(array('error' => ''));
            exit();
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

    }

    //delete program
    public function delete_program_by_id()
    {
        $input_check = true;
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
        }

        if($input_check){
            //delete program 
            $seq_data = $this->TemplateModel->DeleteProgramById($program_id);            
        }

        echo json_encode(array('error' => '','result' => $seq_data));
    }

    //get gtcs templates
    public function get_gtcs_templates($value='')
    {
        // code...
        $NormalSteps = $this->TemplateModel->GetAllNormalStepTemplate();
        $AdvSteps = $this->TemplateModel->GetAllAdvancedStepTemplate();
        $merge = array_merge($NormalSteps,$AdvSteps);
        echo json_encode($merge);
        exit();
    }


    public function edit_gtcs_adv_program(){

        $input_check = true;
        $res = 'fail';
        $error_message = '';     

        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $data['program_id'] = $_POST['program_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_id,";
        }
        if( !empty($_POST['program_name']) && isset($_POST['program_name'])  ){
            $data['program_name'] = $_POST['program_name'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_name,";
        }

        if($input_check){
            $this->TemplateModel->EditProgram_Advanced_Name($data);
        }

    }

    public function create_gtcs_adv_program()
    {
        $input_check = true;
        $res = 'fail';
        $error_message = '';
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $data['program_id'] = $_POST['program_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_id,";
        }
        if( !empty($_POST['program_name']) && isset($_POST['program_name'])  ){
            $data['program_name'] = $_POST['program_name'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_name,";
        }
        if( isset($_POST['program_target'])  ){
            $data['program_target'] = $_POST['program_target'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_target,";
        }

        //step預設值
        $data['step_name'] = 'step name';
        $data['template_step_id'] = 1;
        $data['target_angle'] = 1800;
        $data['target_torque'] = 0.5;
        $data['step_delayttime'] = 0;
        $data['run_down_speed'] = 100;
        $data['joint_offset'] = 0;
        $data['offset_value'] = 0;
        $data['monitoringmode'] = 1;
        $data['step_torwin_target'] = 0.5;
        $data['step_torquewindow'] = 0.05;
        $data['step_angwin_target'] = 1800;
        $data['step_anglewindow'] = 360;
        $data['hi_torque'] = 0.6;
        $data['Lo_torque'] = 0;
        $data['Monitoring_ON_OFF'] = 0;
        $data['hi_angle'] = 30600;
        $data['lo_angle'] = 0;
        $data['step_angle_mode'] = 1;

        if($input_check){
            //create template seq
            //create default first step by program_target
            $this->TemplateModel->EditProgram_Advanced($data);
            
        }

        echo json_encode(array('error' => $error_message));
    }

    public function get_head_advanced_step_id(){

        $input_check = true;
        $res = 'fail';
        $error_message = '';
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_id,";
        }

        if($input_check){
            $head_step_id = $this->TemplateModel->GetHeadAdvancedStepId($program_id);
            echo json_encode($head_step_id);
        }else{
            echo json_encode(array('error' => $error_message));
        }

        exit();
    }

    public function edit_step($value='')
    {
        $input_check = true;
        $error_message = '';
        if( isset($_POST['program_id'])  ){
            $data['program_id'] = $_POST['program_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_id,";
        }
        if( isset($_POST['program_name'])  ){
            $data['program_name'] = $_POST['program_name'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_name,";
        }
        if( !empty($_POST['step_id']) && isset($_POST['step_id'])  ){
            $data['step_id'] = $_POST['step_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "step_id,";
        }
        if( !empty($_POST['step_name']) && isset($_POST['step_name'])  ){
            $data['step_name'] = $_POST['step_name'];
        }else{ 
            $input_check = false; 
            $error_message .= "step_name,";
        }
        if( isset($_POST['target_type'])  ){
            $data['target_type'] = $_POST['target_type'];
        }else{ 
            $input_check = false; 
            $error_message .= "target_type,";
        }
        if( isset($_POST['direction'])  ){
            $data['direction'] = $_POST['direction'];
        }else{ 
            $input_check = false; 
            $error_message .= "direction,";
        }
        if( isset($_POST['run_down_speed'])  ){
            $data['run_down_speed'] = $_POST['run_down_speed'];
        }else{ 
            $input_check = false; 
            $error_message .= "run_down_speed,";
        }
        if( isset($_POST['target_torque'])  ){
            $data['target_torque'] = $_POST['target_torque'];
        }else{ 
            $input_check = false; 
            $error_message .= "target_torque,";
        }
        if( isset($_POST['target_angle'])  ){
            $data['target_angle'] = $_POST['target_angle'];
        }else{ 
            $input_check = false; 
            $error_message .= "target_angle,";
        }
        if( isset($_POST['delay_time'])  ){
            $data['delay_time'] = $_POST['delay_time'];
        }else{ 
            $input_check = false; 
            $error_message .= "delay_time,";
        }
        if( isset($_POST['joint_offset'])  ){
            $data['joint_offset'] = $_POST['joint_offset'];
        }else{ 
            $input_check = false; 
            $error_message .= "joint_offset,";
        }
        if( isset($_POST['offset_value'])  ){
            $data['offset_value'] = $_POST['offset_value'];
        }else{ 
            $input_check = false; 
            $error_message .= "offset_value,";
        }
        if( isset($_POST['monitor_mode'])  ){
            $data['monitor_mode'] = $_POST['monitor_mode'];
        }else{ 
            $input_check = false; 
            $error_message .= "monitor_mode,";
        }
        if( isset($_POST['monitor_angle'])  ){
            $data['monitor_angle'] = $_POST['monitor_angle'];
        }else{ 
            $input_check = false; 
            $error_message .= "monitor_angle,";
        }
        if( isset($_POST['over_angle_stop'])  ){
            $data['over_angle_stop'] = $_POST['over_angle_stop'];
        }else{ 
            $input_check = false; 
            $error_message .= "over_angle_stop,";
        }
        if( isset($_POST['hi_torque'])  ){
            $data['hi_torque'] = $_POST['hi_torque'];
        }else{ 
            $input_check = false; 
            $error_message .= "hi_torque,";
        }
        if( isset($_POST['lo_torque'])  ){
            $data['lo_torque'] = $_POST['lo_torque'];
        }else{ 
            $input_check = false; 
            $error_message .= "lo_torque,";
        }
        if( isset($_POST['hi_angle'])  ){
            $data['hi_angle'] = $_POST['hi_angle'];
        }else{ 
            $input_check = false; 
            $error_message .= "hi_angle,";
        }
        if( isset($_POST['lo_angle'])  ){
            $data['lo_angle'] = $_POST['lo_angle'];
        }else{ 
            $input_check = false; 
            $error_message .= "lo_angle,";
        }
        if( isset($_POST['record_angle_val'])  ){
            $data['record_angle_val'] = $_POST['record_angle_val'];
        }else{ 
            $input_check = false; 
            $error_message .= "record_angle_val,";
        }
        if( isset($_POST['torque_window'])  ){
            $data['torque_window'] = $_POST['torque_window'];
        }else{ 
            $input_check = false; 
            $error_message .= "torque_window,";
        }
        if( isset($_POST['torque_window_range'])  ){
            $data['torque_window_range'] = $_POST['torque_window_range'];
        }else{ 
            $input_check = false; 
            $error_message .= "torque_window_range,";
        }
        if( isset($_POST['angle_window'])  ){
            $data['angle_window'] = $_POST['angle_window'];
        }else{ 
            $input_check = false; 
            $error_message .= "angle_window,";
        }
        if( isset($_POST['angle_window_range'])  ){
            $data['angle_window_range'] = $_POST['angle_window_range'];
        }else{ 
            $input_check = false; 
            $error_message .= "angle_window_range,";
        }


        if($input_check){
            $result = $this->TemplateModel->EditStep_Advanced($data);
            echo json_encode(array('error' => $error_message,'result' => $result));
        }else{
            echo json_encode(array('error' => $error_message));
        }

        exit();
    }


    public function get_advanced_step()
    {
        $input_check = true;
        $res = 'fail';
        $error_message = '';
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "program_id,";
        }
        if( !empty($_POST['step_id']) && isset($_POST['step_id'])  ){
            $step_id = $_POST['step_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "step_id,";
        }

        if($input_check){
            $step_detail = $this->TemplateModel->GetStepById_Advanced($program_id,$step_id);
            echo json_encode($step_detail);
        }else{
            echo json_encode(array('error' => $error_message));
        }

        exit();
    }

    //copy program
    public function copy_step()
    {
        $input_check = true;
        $res = 'fail';
        $error_message = '';

        if( !empty($_POST['from_pro_id']) && isset($_POST['from_pro_id'])  ){
            $from_pro_id = $_POST['from_pro_id'];    
        }else{ 
            $input_check = false; 
            $error_message .= "from_pro_id,";
        }

        if( !empty($_POST['from_step_id']) && isset($_POST['from_step_id'])  ){
            $from_step_id = $_POST['from_step_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "from_step_id,";
        }

        if( !empty($_POST['to_step_id']) && isset($_POST['to_step_id'])  ){
            $to_step_id = $_POST['to_step_id'];    
        }else{ 
            $input_check = false; 
            $error_message .= "to_step_id,";
        }

        if( !empty($_POST['to_step_name']) && isset($_POST['to_step_name'])  ){
            $to_step_name = $_POST['to_step_name'];    
        }else{ 
            $input_check = false; 
            $error_message .= "to_step_name,";
        }

        if( !empty($_POST['job_type']) && isset($_POST['job_type'])  ){
            $job_type = $_POST['job_type'];    
        }else{ 
            $input_check = false; 
            $error_message .= "job_type,";
        }

        if ($input_check) {
            $result = $this->TemplateModel->Copystep($from_pro_id,$from_step_id,$to_step_id,$to_step_name,$job_type);
            echo json_encode(array('error' => ''));
            exit();
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

    }

    //delete program
    public function delete_advanced_step_by_id()
    {
        $input_check = true;
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
        }
        if( !empty($_POST['step_id']) && isset($_POST['step_id'])  ){
            $step_id = $_POST['step_id'];
        }else{ 
            $input_check = false; 
        }

        if($input_check){
            //delete program 
            $seq_data = $this->TemplateModel->DeleteStepById($program_id,$step_id);            
        }

        echo json_encode(array('error' => '','result' => $seq_data));
    }

    //sync program
    public function sync_program_step(){

        if( !empty($_POST['jobid']) && isset($_POST['jobid'])  ){
            $jobid = $_POST['jobid'];
        }else{ 
            $input_check = false; 
        }

        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
        }
        //table_url
        if( !empty($_POST['table_url']) && isset($_POST['table_url'])  ){
            $table_url = $_POST['table_url'];
            if($table_url == "normalstep"){
                $table_name ="ccs_normalstep";
                $table  = "gtcs_normalstep_template";
            }

            if($table_url == "advancedstep"){
                $table_name ="ccs_advancedstep";
                $table  = "gtcs_advancedstep_template";
            }
        }else{ 
            $input_check = false; 
        }

        
        //用 program_id 從 gtcs_normalstep_template or gtcs_advancedstep_template 取出資料
        $temp_data = $this->TemplateModel->search_data($program_id,$table); //4 
        $temp = $this->TemplateModel->search_data_info($program_id); // 2

        if(!empty($temp)){

            if ($table_url == "advancedstep") {

                $new_temp_advancedstep = array();
                foreach ($temp_data as $kk => $item) {
                    // 如果 $temp 有多筆資料，則使用迴圈遍歷每一筆 $temp
                    foreach ($temp as $temp_item) {
                        $new_temp_advancedstep[] = array(
                            'job_id' => $temp_item['job_id'],
                            'seq_id' => $temp_item['seq_id'],
                            'task_id' => $temp_item['task_id'],
                            'step_id' => $item['template_step_id'],
                            'step_name' => $item['step_name'],
                            'step_targettype' => $item['step_targettype'],
                            'step_targetangle' => $item['step_targetangle'],
                            'step_targettorque' => $item['step_targettorque'],
                            'step_delayttime' => $item['step_delayttime'],
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
                        );
                    }
                }
            }

            if($table_url == "normalstep"){


                $new_temp_normalstep = array();

                foreach ($temp_data as $kk => $item) {
                    // 如果 $temp 有多筆資料，則使用迴圈遍歷每一筆 $temp
                    foreach ($temp as $temp_item) {
                        $new_temp_normalstep[] = array(
                            'job_id' => $temp_item['job_id'],
                            'seq_id' => $temp_item['seq_id'],
                            'task_id' => $temp_item['task_id'],
                            'step_name' => $item['step_name'],
                            'step_targettype' => $item['step_targettype'],
                            'step_targetangle' => $item['step_targetangle'],
                            'step_targettorque' => $item['step_targettorque'],
                            'step_tooldirection' => $item['step_tooldirection'],
                            'step_rpm' => $item['step_rpm'],
                            'step_offsetdirection' => $item['step_offsetdirection'],
                            'step_torque_jointoffset' =>$item['step_torque_jointoffset'],
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
                            'step_downshift_angle' => $item['step_downshift_angle']
                
                        );
                    }
                }

                
            }

            if($table_url == "advancedstep" && !empty($new_temp_advancedstep)){
                $res = $this->TemplateModel->cover_data($new_temp_advancedstep,$table_name);
            }

            if($table_url == "normalstep" && !empty($new_temp_normalstep)){
                $res = $this->TemplateModel->cover_data($new_temp_normalstep,$table_name);
            }

           
        }
        
    }

    public function check_task_by_pro_id(){
        $input_check = true;
        if( !empty($_POST['program_id']) && isset($_POST['program_id'])  ){
            $program_id = $_POST['program_id'];
        }else{ 
            $input_check = false; 
        }
        if($input_check){
            $res = $this->TemplateModel->get_job_by_pro_id($program_id);

            if(!empty($res)){
            
                #儲存唯一的job_id
                $uniquejobs = array();
                #紀錄job_id 是否已經存在
                $seenjobids = array();

                foreach ($res as $row) {
                    #如果 job_id 不在 $seenjobids裡，則需要加到 $uniquejobs
                    if (!in_array($row['job_id'], $seenjobids)) {
                        $seenjobids[] = $row['job_id']; 
                        $uniquejobs[] = $row; 
                        
                    }
                }
                header('Content-Type: application/json');
                echo json_encode($uniquejobs);

            }else{
                echo json_encode([]);
            }

        }else{
            echo json_encode(['error' => 'Invalid input']);    
        }

    }
    
}