<?php

class Sequences extends Controller
{
    private $SequenceModel;
    private $NavsController;
    // 在建構子中將 Post 物件（Model）實例化
    public function __construct()
    {
        $this->SequenceModel = $this->model('Sequence');
        $this->NavsController = $this->controller_new('Navs');
        $this->ProductModel = $this->model('Product');
    }

    // 取得所有Jobs
    public function index($job_id){

        if( isset($job_id) && !empty($job_id) ){

        }else{
            $job_id = 1;
        }

        $isMobile = $this->isMobileCheck();
        $nav = $this->NavsController->get_nav();
        $sequences = $this->SequenceModel->getSequences($job_id);
        $job = $this->SequenceModel->getJob($job_id);
        $job_name = $job['job_name'];

        $data = [
            'isMobile' => $isMobile,
            'nav' => $nav,
            'job_id' => $job_id,
            'job_name' => $job_name,
            'sequences' => $sequences,
        ];
        
        $this->view('sequence/index', $data);

    }

    public function get_head_seq_id_normal(){
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "job_id,";
        }
        //因job id是由系統指派，在create job時，抓取最前面的job id 帶入
        $head_job_id = $this->SequenceModel->get_head_seq_id($job_id);

        echo json_encode($head_job_id);
        exit();
    }

    //create seq
    public function edit_seq(){

        $error_message = '';

        if(isset($_POST)){//form資料
            $data_array = $_POST;
            $input_check = true;
            $error_message = '';

            if( !empty($data_array['seq_id']) && isset($data_array['seq_id'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "seq_id,";
            }
            if( !empty($data_array['seq_name']) && isset($data_array['seq_name'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "seq_name,";
            }
            if( isset($data_array['stop_on_NG']) && $data_array['stop_on_NG'] >=0 && $data_array['stop_on_NG'] <= 9 ){
            }else{ 
                $input_check = false;
                $error_message .= "stop_on_NG,";
            }
            // if(  !empty($data_array['seq_enable']) && isset($data_array['seq_enable']) ){
            //     if($data_array['seq_enable'] == 'true'){
            //         $data_array['seq_enable'] = 1;
            //     }else{
            //         $data_array['seq_enable'] = 0;
            //     }
            // }else{ 
            //     $input_check = false;
            //     $error_message .= "seq_enable,";
            // }
            if(  !empty($data_array['ok_seq']) && isset($data_array['ok_seq'])  ){
                if($data_array['ok_seq'] == 'true'){
                    $data_array['ok_seq'] = 1;
                }else{
                    $data_array['ok_seq'] = 0;
                }
            }else{ 
                $input_check = false;
                $error_message .= "ok_seq,";
            }
            if(  !empty($data_array['ok_seq_stop']) && isset($data_array['ok_seq_stop'])  ){
                if($data_array['ok_seq_stop'] == 'true'){
                    $data_array['ok_seq_stop'] = 1;
                }else{
                    $data_array['ok_seq_stop'] = 0;
                }
            }else{ 
                $input_check = false;
                $error_message .= "ok_seq_stop,";
            }
            if(  !empty($data_array['timeout']) && isset($data_array['timeout'])  ){
            }else{ 
                $input_check = false;
                $error_message .= "timeout,";
            }

            if( !empty($data_array['barcode_enable']) && isset($data_array['barcode_enable'])  ){
                if($data_array['barcode_enable'] == 'true'){
                    $data_array['barcode_enable'] = 1;
                }else{
                    $data_array['barcode_enable'] = 0;
                }

            }else{ 
                $input_check = false;
                $error_message .= "barcode_enable,";
            }
            

            if ($input_check) {
                $jobs = $this->SequenceModel->EditSeq($data_array);
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
                $image_upload_path="./img/seq_img/".$image_new_name;
                $is_uploaded = move_uploaded_file($_FILES["croppedImage"]["tmp_name"],$image_upload_path);

                if($is_uploaded){
                    // 把img url寫入資料庫
                    // echo 'Image Successfully Uploaded';
                    $this->SequenceModel->SetSeqImage($data_array['job_id'],$data_array['seq_id'],$image_upload_path);
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

    //get job by id
    public function get_seq_by_id(){
        $input_check = true;
        //因job id是由系統指派，在create job時，抓取最前面的job id 帶入
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false; 
        }
        if( !empty($_POST['seq_id']) && isset($_POST['seq_id'])  ){
            $seq_id = $_POST['seq_id'];
        }else{ 
            $input_check = false; 
        }

        if($input_check){
            $sequence_data = $this->SequenceModel->GetSeqById($job_id,$seq_id);    
        }

        echo json_encode($sequence_data);
    }

    // enable disable seq
    public function Enable_Disable_Seq()
    {
        $error_message = '';
        $input_check = true;

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
        if( isset($_POST['status'])  ){
            $status = $_POST['status'];
        }else{ 
            $input_check = false; 
            $error_message .= "status,";
        }

        if($status == 'false'){
            $status = 0;
        }else{
            $status = 1;
        }

        if ($input_check) {
            $res = $this->SequenceModel->EnableDisableSeq($job_id,$seq_id,$status);
        }

        $data = [
                'result' => $res,
                'error_message' => $error_message
            ];

        echo json_encode($data);

    }


    //copy sequence
    public function copy_seq()
    {
        $input_check = true;
        $res = 'fail';
        $error_message = '';
        if( !empty($_POST['from_job_id']) && isset($_POST['from_job_id'])  ){
            $from_job_id = $_POST['from_job_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "from_job_id,";
        }

        if( !empty($_POST['from_seq_id']) && isset($_POST['from_seq_id'])  ){
            $from_seq_id = $_POST['from_seq_id'];    
        }else{ 
            $input_check = false; 
            $error_message .= "from_seq_id,";
        }

        if( !empty($_POST['to_seq_id']) && isset($_POST['to_seq_id'])  ){
            $to_seq_id = $_POST['to_seq_id'];
        }else{ 
            $input_check = false; 
            $error_message .= "to_seq_id,";
        }

        if( !empty($_POST['to_seq_name']) && isset($_POST['to_seq_name'])  ){
            $to_seq_name = $_POST['to_seq_name'];    
        }else{ 
            $input_check = false; 
            $error_message .= "to_seq_name,";
        }

        if ($input_check) {
            $result = $this->SequenceModel->CopySeq($from_job_id,$from_seq_id,$to_seq_id,$to_seq_name);

            //透過job_id 及 $from_seq_id  找出對應的task 
            $temp_task = $this->SequenceModel->check_task_by_seq_id($from_job_id, $from_seq_id,$to_seq_id);
            if(!empty($temp_task)){
                $new_temp_task = array();
                foreach($temp_task as $kk =>$vv){
                    $new_temp_task[$kk]['job_id'] = $vv['job_id'];
                    $new_temp_task[$kk]['seq_id'] = $to_seq_id;
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
 
                $insertedrecords_task = $this->SequenceModel->copy_task_by_seq_id($new_temp_task); 
                $table_name = 'ccs_normalstep';
                
                $res = $this->SequenceModel->check_pro_id_template($table_name,$from_job_id,$from_seq_id);
                if(!empty($res)){
                    $new_temp_normalstep = array();
                    $table_name ='ccs_normalstep';
                    foreach($res as $k_cc =>$v_cc){
                        $new_temp_normalstep[$k_cc]['job_id'] = $vv['job_id'];
                        $new_temp_normalstep[$k_cc]['seq_id'] = $to_seq_id;
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
                    $table_name = 'ccs_advancedstep';
                    $res1 = $this->SequenceModel->check_pro_id_template($table_name,$from_job_id,$from_seq_id);
                    if(!empty($res1)){
                        foreach($res1 as $k_cc =>$v_cc){
                            $new_temp_advancedstep[$k_cc]['job_id'] = $v_cc['job_id']; 
                            $new_temp_advancedstep[$k_cc]['seq_id'] = $to_seq_id;
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
                //$from_job_id,$from_seq_id,
                $res_tmp = $this->SequenceModel->check_task_message_by_id($from_job_id,$from_seq_id);
                if(!empty($res_tmp)){
                    
                    foreach($res_tmp as $k_m =>$v_m){
                        $new_temp_task_message[$k_m]['job_id']  = $v_m['job_id'];
                        $new_temp_task_message[$k_m]['seq_id']  = $to_seq_id;
                        $new_temp_task_message[$k_m]['task_id'] = $v_m['task_id'];
                        $new_temp_task_message[$k_m]['type']    = $v_m['type'];
                        $new_temp_task_message[$k_m]['text']    = $v_m['text'];
                        $new_temp_task_message[$k_m]['img']     = $v_m['img'];
                        $new_temp_task_message[$k_m]['timeout'] = $v_m['timeout'];
                        $new_temp_task_message[$k_m]['status']  = $v_m['status'];
                       
                    }
                    $count = $this->SequenceModel->cover_data($new_temp_task_message);
                }
            }
            echo json_encode(array('error' => ''));
            exit();
        }else{
            echo json_encode(array('error' => $error_message));
            exit();
        }

    }

    //delete job
    public function delete_seq_by_id()
    {
        $input_check = true;
        if( !empty($_POST['job_id']) && isset($_POST['job_id'])  ){
            $job_id = $_POST['job_id'];
        }else{ 
            $input_check = false; 
        }
        if( !empty($_POST['seq_id']) && isset($_POST['seq_id'])  ){
            $seq_id = $_POST['seq_id'];
        }else{ 
            $input_check = false; 
        }

        if($input_check){
            //delete sequecne table
            $seq_data = $this->SequenceModel->DeleteSeqById($job_id,$seq_id);
            //delete normalsetp table
            // if($job_id>100){
            //     $seq_data = $this->SequenceModel->delete_advancedstep_by_job_seq_id($job_id,$seq_id);
            // }else{
            //     $seq_data = $this->SequenceModel->delete_normalstep_by_job_seq_id($job_id,$seq_id);
            // }
            
        }

        echo json_encode(array('error' => '','result' => $seq_data));
    }

}