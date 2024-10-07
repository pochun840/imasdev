
<?php $ps_text = '
<!--
API
參數說明：start_date         => 起始日期(只接受 格式為：YYYYMMDD,共8碼)
　　　　　end_date           => 起始日期(只接受 格式為：YYYYMMDD,共8碼)
　　　　　limit              => 筆數 (數字)
　　　　　status             => 狀態(0=>全部 , 1=>OK ,2=>OK-SEQ 3=>OK-JOB 4 =>NG 5=>NS 6=> REVERSE)
	     operator           => 人員
         job                => (0=>列出所有的job)
         mode               =>(ng_rank(NG排行)、ng_reason(錯誤原因)、)

-->';

header("Access-Control-Allow-Credentials: true ");
header("Access-Control-Allow-Methods: OPTIONS, GET, POST");
header("Access-Control-Allow-Headers: Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control");

//echo $ps_text;
# 輸出結果
if(!empty($data['type'])){

    switch($data['type']){

        case 'xml':
            $xml = '<?php xml version="1.0" encoding="UTF-8" ?>'."\n";
            $xml.= $ps_text."\n";
            $xml.= '<info>'."\n";
            foreach($data['resitem'] as $k => $v){
                $xml.= '<item>'."\n";
                $xml.= '<cc_barcodesn><![CDATA['.$v['cc_barcodesn'].']]></cc_barcodesn>'."\n";
                $xml.= '<cc_station><![CDATA['.$v['cc_station'].']]></cc_station>'."\n";
                $xml.= '<cc_job_id><![CDATA['.$v['cc_job_id'].']]></cc_job_id>'."\n";
                $xml.= '<cc_seq_id><![CDATA['.$v['cc_seq_id'].']]></cc_seq_id>'."\n";
                $xml.= '<cc_task_id><![CDATA['.$v['cc_task_id'].']]></cc_task_id>'."\n";
                $xml.= '<cc_equipment><![CDATA['.$v['cc_equipment'].']]></cc_equipment>'."\n";
                $xml.= '<cc_operator><![CDATA['.$v['cc_operator'].']]></cc_operator>'."\n";
                $xml.= '<system_sn><![CDATA['.$v['system_sn'].']]></system_sn>'."\n";
                $xml.= '<data_time><![CDATA['.$v['data_time'].']]></data_time>'."\n";
                $xml.= '<device_type><![CDATA['.$v['device_type'].']]></device_type>'."\n";
                $xml.= '<device_id><![CDATA['.$v['device_id'].']]></device_id>'."\n";
                $xml.= '<device_sn><![CDATA['.$v['device_sn'].']]></device_sn>'."\n";
                $xml.= '<tool_type><![CDATA['.$v['tool_type'].']]></tool_type>'."\n";
                $xml.= '<tool_sn><![CDATA['.$v['tool_sn'].']]></tool_sn>'."\n";
                $xml.= '<tool_status><![CDATA['.$v['tool_status'].']]></tool_status>'."\n";
                $xml.= '<job_id><![CDATA['.$v['job_id'].']]></job_id>'."\n";
                $xml.= '<job_name><![CDATA['.$v['job_name'].']]></job_name>'."\n";
                $xml.= '<sequence_id><![CDATA['.$v['sequence_id'].']]></sequence_id>'."\n";
                $xml.= '<sequence_name><![CDATA['.$v['sequence_name'].']]></sequence_name>'."\n";
                $xml.= '<step_id><![CDATA['.$v['step_id'].']]></step_id>'."\n";
                $xml.= '<fasten_torque><![CDATA['.$v['fasten_torque'].']]></fasten_torque>'."\n";
                $xml.= '<torque_unit><![CDATA['.$v['torque_unit'].']]></torque_unit>'."\n";
                $xml.= '<fasten_time><![CDATA['.$v['fasten_time'].']]></fasten_time>'."\n";
                $xml.= '  </item>'."\n";


            }
            $xml.= '</info>'."\n";

        header('Content-type: text/xml; charset=utf-8');
        echo $xml;

        break;

        case 'json':
            header('Content-type: application/json; charset=utf-8');
            echo json_encode($data['resitem']);

        break;

        case 'array':
            header('Content-type: text/html; charset=utf-8');
            echo "<pre>";
            print_r($data['resitem']);
            echo "</pre>";
        break;

    }

}

?>