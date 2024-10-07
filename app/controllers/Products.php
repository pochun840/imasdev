<?php

class Products extends Controller
{
    private $ProductModel;
    private $SequenceModel;
    private $NavsController;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->ProductModel = $this->model('Product');
        $this->SequenceModel = $this->model('Sequence');
        $this->NavsController = $this->controller_new('Navs');
    }

    // 取得所有Jobs
    public function index(){

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $jobs = $this->ProductModel->getJobs();

        $status = array();
        $status['ok_job'][0] = 'OFF';
        $status['ok_job'][1] = 'ON';
        $status['ok_job_stop'][0] = 'OFF';
        $status['ok_job_stop'][1] = 'ON';
        $status['reverse_direction'][0] = 'CW';
        $status['reverse_direction'][1] = 'CCW';
        $status['reverse_cnt_mode'][0] = 'OFF';
        $status['reverse_cnt_mode'][1] = 'ON';

        // var_dump($jobs);

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'jobs' => $jobs,
        ];
        
        $this->view('product/index', $data);

    }

    //get product list
    public function get_head_job_id(){
        //因由系統指派job id
        $head_job_id = $this->ProductModel->get_head_job_id();

        echo json_encode($head_job_id);
        exit();
    }

    //get product by id
    public function get_job_by_id()
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "job_id,";
        }

        if ($input_check) {
            $job_detail = $this->ProductModel->getJobById($job_id);
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

        echo json_encode($job_detail);
        exit();

    }


    //edit product by id
    public function edit_job()
    {
        $error_message = '';

        if(isset($_POST)){//form資料
            $data_array = $_POST;
            $input_check = true;
            $error_message = '';

            if( !empty($data_array['controller_type']) && isset($data_array['controller_type'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "controller_type,";
            }
            if( !empty($data_array['job_id']) && isset($data_array['job_id'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "job_id,";
            }
            if( !empty($data_array['job_name']) && isset($data_array['job_name'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "job_name,";
            }
            if(  !empty($data_array['ok_job']) && isset($data_array['ok_job']) ){
                if($data_array['ok_job'] == 'true'){
                    $data_array['ok_job'] = 1;
                }else{
                    $data_array['ok_job'] = 0;
                }
            }else{ 
                $input_check = false;
                $error_message .= "ok_job,";
            }
            if(  !empty($data_array['ok_job_stop']) && isset($data_array['ok_job_stop'])  ){
                if($data_array['ok_job_stop'] == 'true'){
                    $data_array['ok_job_stop'] = 1;
                }else{
                    $data_array['ok_job_stop'] = 0;
                }
            }else{ 
                $input_check = false;
                $error_message .= "ok_job_stop,";
            }
            if(  isset($data_array['reverse_button'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "reverse_button,";
            }
            if(  !empty($data_array['reverse_rpm']) && isset($data_array['reverse_rpm'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "reverse_rpm,";
            }
            if(  !empty($data_array['reverse_Force']) && isset($data_array['reverse_Force'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "reverse_Force,";
            }
            if(  isset($data_array['reverse_count'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "reverse_count,";
            }
            if( isset($data_array['threshold_torque']) && $data_array['threshold_torque'] >= 0  ){
            }else{ 
                $input_check = false;
                $error_message .= "threshold_torque,";
            }
            if( isset($data_array['size'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "size,";
            }
            if(  !empty($data_array['barcode_start']) && isset($data_array['barcode_start']) ){
                if($data_array['barcode_start'] == 'true'){
                    $data_array['barcode_start'] = 1;
                }else{
                    $data_array['barcode_start'] = 0;
                }
            }else{ 
                $input_check = false;
                $error_message .= "ok_job,";
            }
            if(  !empty($data_array['tower_light']) && isset($data_array['tower_light']) ){
                if($data_array['tower_light'] == 'true'){
                    $data_array['tower_light'] = 1;
                }else{
                    $data_array['tower_light'] = 0;
                }
            }else{ 
                $input_check = false;
                $error_message .= "ok_job,";
            }

            if ($input_check) {
                $jobs = $this->ProductModel->EditJob($data_array);
            }
        }

        // var_dump($_FILES);

        if(!empty($_FILES) && $input_check){//圖片資料
            $input_image=$_FILES['croppedImage']['tmp_name'];
            $image_info = @getimagesize($input_image);
            // var_dump($image_info);
            if($image_info == false){
                // echo "The selected file is not image.";
                $error_message .= 'The selected file is not image, ';
            }else{
                $image_array=explode('/',$_FILES['croppedImage']['type']);
                $image_type = $image_array[1];
                $t=time();
                $datetime = date("Y-m-dHms",$t);
                $image_new_name = $datetime.'.'.$image_type;
                $image_upload_path="./img/job_img/".$image_new_name;
                $is_uploaded = move_uploaded_file($_FILES["croppedImage"]["tmp_name"],$image_upload_path);

                if($is_uploaded){
                    // 把img url寫入資料庫
                    // echo 'Image Successfully Uploaded';
                    $this->ProductModel->SetJobImage($data_array['job_id'],$image_upload_path);
                }
                else{
                    // echo 'Something Went Wrong!';
                    $error_message .= 'image upload error';
                }
            }
        }

        echo json_encode(array('error' => $error_message));
        exit();
    }

    //copy product by id
    public function copy_job($value='')
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['from_job_id']) && isset($_POST['from_job_id'])  ){
            $from_job_id = $_POST['from_job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "from_job_id,";
        }
        if( !empty($_POST['to_job_id']) && isset($_POST['to_job_id'])  ){
            $to_job_id = $_POST['to_job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "to_job_id,";
        }
        if( !empty($_POST['to_job_name']) && isset($_POST['to_job_name'])  ){
            $to_job_name = $_POST['to_job_name'];
        }else{ 
            $input_check = false;
            $error_message .= "to_job_name,";
        }

        if ($input_check) {
            
            $result  = $this->ProductModel->CopyJob($from_job_id,$to_job_id,$to_job_name);  //單純copy job 功能
            $select_seq = $this->ProductModel->check_seq_by_job_id($from_job_id,$to_job_id); //用$from_job_id,$to_job_id 找出對應的seq資料
            if(!empty($select_seq)){

                $new_temp_seq = array();
                foreach($select_seq as $key =>$val){
                    
                    if(empty($val['barcode_start'])){
                        $val['barcode_start'] = 0;
                    }

                    $new_temp_seq[$key]['sequence_enable'] = $val['sequence_enable'];
                    $new_temp_seq[$key]['job_id'] = $to_job_id;
                    $new_temp_seq[$key]['seq_id'] = $val['seq_id'];
                    $new_temp_seq[$key]['seq_name'] = $val['seq_name'];
                    $new_temp_seq[$key]['img'] = $val['img'];
                    $new_temp_seq[$key]['tightening_repeat'] = $val['tightening_repeat'];
                    $new_temp_seq[$key]['ng_stop'] = $val['ng_stop'];
                    $new_temp_seq[$key]['ok_sequence'] = $val['ok_sequence'];
                    $new_temp_seq[$key]['ok_sequence_stop'] = $val['ok_sequence_stop'];
                    $new_temp_seq[$key]['sequence_mintime'] = $val['sequence_mintime'];
                    $new_temp_seq[$key]['sequence_maxtime'] = $val['sequence_maxtime'];
                    $new_temp_seq[$key]['barcode_start'] = $val['barcode_start'];
              
                }
                $insertedrecords = $this->ProductModel->Copy_seq_by_job_id($new_temp_seq);  //copy seq  
                //var_dump($insertedrecords);

            }

            $select_task = $this->ProductModel->check_task_by_job_id($from_job_id,$to_job_id); //用$from_job_id,$to_job_id 找出對應的task資料
            if(!empty($select_task)){
                $new_temp_task = array();
                foreach($select_task as $kk =>$vv){
                    $new_temp_task[$kk]['job_id'] = $to_job_id;
                    $new_temp_task[$kk]['seq_id'] = $vv['seq_id'];
                    $new_temp_task[$kk]['task_id'] = $vv['task_id'];
                    $new_temp_task[$kk]['controller'] = $vv['controller'];
                    $new_temp_task[$kk]['enable_equipment'] = $vv['enable_equipment'];
                    $new_temp_task[$kk]['enable_arm'] = $vv['enable_arm'];
                    $new_temp_task[$kk]['position_x'] = $vv['position_x'];
                    $new_temp_task[$kk]['position_y'] = $vv['position_y'];
                    $new_temp_task[$kk]['tolerance'] = $vv['tolerance'];
                    $new_temp_task[$kk]['tolerance2'] = $vv['tolerance2'];
                    $new_temp_task[$kk]['pts'] = $vv['pts'];
                    $new_temp_task[$kk]['template_program_id'] = $vv['template_program_id'];
                    $new_temp_task[$kk]['circle_div'] = $vv['circle_div'];
                    $new_temp_task[$kk]['delay'] = $vv['delay'];

                }
                
                $insertedrecords_task = $this->ProductModel->Copy_task_by_job_id($new_temp_task);  //copy task  
                $res = $this->ProductModel->check_pro_id_for_ccs_normalstep($from_job_id);

              
                
                if(!empty($res)){
                    $new_temp_normalstep = array();
                    $table_name ='ccs_normalstep';
                    foreach($res as $k_cc =>$v_cc){
                        $new_temp_normalstep[$k_cc]['job_id'] = $to_job_id; 
                        $new_temp_normalstep[$k_cc]['seq_id'] = $v_cc['seq_id'];
                        $new_temp_normalstep[$k_cc]['task_id'] = $v_cc['task_id'];
                        $new_temp_normalstep[$k_cc]['step_name'] = $v_cc['step_name'];
                        $new_temp_normalstep[$k_cc]['step_targettype'] = $v_cc['step_targettype'];
                        $new_temp_normalstep[$k_cc]['step_targetangle'] = $v_cc['step_targetangle'];
                        $new_temp_normalstep[$k_cc]['step_targettorque'] = $v_cc['step_targettorque'];
                        $new_temp_normalstep[$k_cc]['step_tooldirection'] = $v_cc['step_tooldirection'];
                        $new_temp_normalstep[$k_cc]['step_rpm'] = $v_cc['step_rpm'];
                        $new_temp_normalstep[$k_cc]['step_offsetdirection'] = $v_cc['step_offsetdirection'];
                        $new_temp_normalstep[$k_cc]['step_torque_jointoffset'] = $v_cc['step_torque_jointoffset'];
                        $new_temp_normalstep[$k_cc]['step_hightorque'] = $v_cc['step_hightorque'];
                        $new_temp_normalstep[$k_cc]['step_lowtorque'] = $v_cc['step_lowtorque'];
                        $new_temp_normalstep[$k_cc]['step_threshold_mode'] = $v_cc['step_threshold_mode'];
                        $new_temp_normalstep[$k_cc]['step_threshold_torque'] = $v_cc['step_threshold_torque'];
                        $new_temp_normalstep[$k_cc]['step_threshold_angle'] = $v_cc['step_threshold_angle'];
                        $new_temp_normalstep[$k_cc]['step_monitoringangle'] = $v_cc['step_monitoringangle'];
                        $new_temp_normalstep[$k_cc]['step_highangle'] = $v_cc['step_highangle'];
                        $new_temp_normalstep[$k_cc]['step_lowangle'] = $v_cc['step_lowangle'];
                        $new_temp_normalstep[$k_cc]['step_downshift_enable'] = $v_cc['step_downshift_enable'];
                        $new_temp_normalstep[$k_cc]['step_downshift_torque'] = $v_cc['step_downshift_torque'];
                        $new_temp_normalstep[$k_cc]['step_downshift_speed'] = $v_cc['step_downshift_speed'];
                        $new_temp_normalstep[$k_cc]['torque_unit'] = $v_cc['torque_unit'];
                        $new_temp_normalstep[$k_cc]['step_prr'] = $v_cc['step_prr'];
                        $new_temp_normalstep[$k_cc]['step_prr_rpm'] = $v_cc['step_prr_rpm'];
                        $new_temp_normalstep[$k_cc]['step_prr_angle'] = $v_cc['step_prr_angle'];
                        $new_temp_normalstep[$k_cc]['step_downshift_mode'] = $v_cc['step_downshift_mode'];
                        $new_temp_normalstep[$k_cc]['step_downshift_angle'] = $v_cc['step_downshift_angle'];
                        $new_temp_normalstep[$k_cc]['gtcs_job_id'] = $v_cc['gtcs_job_id'];
                    }

                    $count = $this->ProductModel->cover_data($new_temp_normalstep,$table_name);
                 
                }else{
                    //ccs_advancedstep
                    // var_dump($new_temp_task);
                    // exit();
                    $res1 = $this->ProductModel->check_pro_id_for_ccs_advancedstep($from_job_id);
                    if(!empty($res1)){
                        $new_temp_advancedstep = array();
                        $table_name ='ccs_advancedstep';
                        foreach($res1 as $k_cc =>$v_cc){
                            $new_temp_advancedstep[$k_cc]['job_id'] = $to_job_id; 
                            $new_temp_advancedstep[$k_cc]['seq_id'] = $v_cc['seq_id'];
                            $new_temp_advancedstep[$k_cc]['task_id'] = $v_cc['task_id'];
                            $new_temp_advancedstep[$k_cc]['step_id'] = $v_cc['step_id'];
                            $new_temp_advancedstep[$k_cc]['step_name'] = $v_cc['step_name'];
                            $new_temp_advancedstep[$k_cc]['step_targettype'] = $v_cc['step_targettype'];
                            $new_temp_advancedstep[$k_cc]['step_targetangle'] = $v_cc['step_targetangle'];
                            $new_temp_advancedstep[$k_cc]['step_targettorque'] = $v_cc['step_targettorque'];
                            $new_temp_advancedstep[$k_cc]['step_tooldirection'] = $v_cc['step_tooldirection'];
                            $new_temp_advancedstep[$k_cc]['step_rpm'] = $v_cc['step_rpm'];
                            $new_temp_advancedstep[$k_cc]['step_offsetdirection'] = $v_cc['step_offsetdirection'];
                            $new_temp_advancedstep[$k_cc]['step_torque_jointoffset'] = $v_cc['step_torque_jointoffset'];
                            $new_temp_advancedstep[$k_cc]['step_monitoringmode'] = $v_cc['step_monitoringmode'];
                            $new_temp_advancedstep[$k_cc]['step_torwin_target'] = $v_cc['step_torwin_target'];
                            $new_temp_advancedstep[$k_cc]['step_torquewindow'] = $v_cc['step_torquewindow'];
                            $new_temp_advancedstep[$k_cc]['step_angwin_target'] = $v_cc['step_angwin_target'];
                            $new_temp_advancedstep[$k_cc]['step_anglewindow'] = $v_cc['step_anglewindow'];
                            $new_temp_advancedstep[$k_cc]['step_hightorque'] = $v_cc['step_hightorque'];
                            $new_temp_advancedstep[$k_cc]['step_lowtorque'] = $v_cc['step_lowtorque'];
                            $new_temp_advancedstep[$k_cc]['step_monitoringangle'] = $v_cc['step_monitoringangle'];
                            $new_temp_advancedstep[$k_cc]['step_highangle'] = $v_cc['step_highangle'];
                            $new_temp_advancedstep[$k_cc]['step_lowangle'] = $v_cc['step_lowangle'];
                            $new_temp_advancedstep[$k_cc]['torque_unit'] = $v_cc['torque_unit'];
                            $new_temp_advancedstep[$k_cc]['step_angle_mode'] = $v_cc['step_angle_mode'];
                            $new_temp_advancedstep[$k_cc]['step_slope'] = $v_cc['step_slope'];
                            $new_temp_advancedstep[$k_cc]['gtcs_job_id'] = $v_cc['gtcs_job_id'];
                        }
                        $count = $this->ProductModel->cover_data($new_temp_advancedstep,$table_name);
                    }
                }

                //文字訊息(task_message) 的copy 
                $res_tmp = $this->ProductModel->check_task_message_by_id($from_job_id);
                if(!empty($res_tmp)){
                    
                    foreach($res_tmp as $k_m =>$v_m){
                        $new_temp_task_message[$k_m]['job_id']  = $to_job_id; 
                        $new_temp_task_message[$k_m]['seq_id']  = $v_m['seq_id'];
                        $new_temp_task_message[$k_m]['task_id'] = $v_m['task_id'];
                        $new_temp_task_message[$k_m]['type']    = $v_m['type'];
                        $new_temp_task_message[$k_m]['text']    = $v_m['text'];
                        $new_temp_task_message[$k_m]['img']     = $v_m['img'];
                        $new_temp_task_message[$k_m]['timeout'] = $v_m['timeout'];
                        $new_temp_task_message[$k_m]['status']  = $v_m['status'];
                       
                    }
                    $count = $this->ProductModel->get_task_message_data($new_temp_task_message);
                }

            }

            
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

        echo json_encode($result);
        exit();
    }

    //delete product by id
    public function delete_job($value='')
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "job_id,";
        }

        if ($input_check) {
            $result = $this->ProductModel->DeleteJobById($job_id);
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

        echo json_encode($result);
        exit();
    }

    //get job seq list
    public function get_seq_list_by_job_id($value='')
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "job_id,";
        }

        if ($input_check) {
            $result = $this->SequenceModel->getSequences($job_id);
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }
        
        echo json_encode($result);
        exit();
    }


    // add & edit barcode
    // barcode + match from + match to 組成key
    // key 重複的話就跳出提醒 不要直接覆蓋
    public function Edit_Barcode($value='')
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['barcode']) && isset($_POST['barcode'])  ){
            $barcode = $_POST['barcode'];
        }else{ 
            $input_check = false;
            $error_message .= "barcode,";
        }
        if( !empty($_POST['match_from']) && isset($_POST['match_from'])  ){
            $match_from = $_POST['match_from'];
        }else{ 
            $input_check = false;
            $error_message .= "match_from,";
        }
        if( !empty($_POST['match_to']) && isset($_POST['match_to'])  ){
            $match_to = $_POST['match_to'];
        }else{ 
            $input_check = false;
            $error_message .= "match_to,";
        }
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false;
            $error_message .= "job_id,";
        }
        if( !empty($_POST['seq_id']) && isset($_POST['seq_id'])  ){
            $seq_id = $_POST['seq_id'];
        }else{ 
            $input_check = false;
            $error_message .= "seq_id,";
        }

        if ($input_check) {
            $result = $this->ProductModel->EditBarcode($barcode,$match_from,$match_to,$job_id,$seq_id);
        }else{
            echo json_encode(array('result' => '', 'error' => $error_message));
            exit();
        }

        echo json_encode(array('result' => $result, 'error' => $error_message));
        exit();
    }

    // delete barcode
    public function Delete_Barcode($value='')
    {
        $input_check = true;
        $error_message = '';
        if( !empty($_POST['id']) && isset($_POST['id'])  ){
            $id = $_POST['id'];
        }else{ 
            $input_check = false;
            $error_message .= "id,";
        }
        
        if ($input_check) {
            $result = $this->ProductModel->DeleteBarcode($id);
        }else{
            echo json_encode(array('result' => '', 'error' => $error_message));
            exit();
        }

        echo json_encode(array('result' => $result, 'error' => $error_message));
        exit();
    }

    // load barcode list
    public function Get_All_Barcode($value='')
    {
        $result = $this->ProductModel->getBarcodes();
        echo json_encode($result);
        exit();
    }

}