   <div class="force-overflow-fastening">
                            <table class="table table-bordered table-hover" id="fastening-table">
                                <thead id="header-table" style="text-align: center; vertical-align: middle">
                                    <tr>
                                        <?php 
                                            if(!empty($data['user_role_title'])){
                                                if($data['user_role_title'] =="Super admin"){?>
                                                     <th><button id="toggle-select-all" onclick="selectAllCheckboxes()" class="ExportButton" ><?php echo $text['Select_all_text'];?></button></th>
                                                <?php }else{ ?>
                                                    <th><i></i></th>
                                                <?php }
                                            }
                                        
                                        ?>
                                        <th><?php echo $text['Index_text']; ?></th>
                                        <th><?php echo $text['Time_text']; ?></th>
                                        <th><?php echo $text['Station_text']; ?></th>
                                        <th><?php echo $text['BarcodeSN_text']; ?></th>
                                        <th><?php echo $text['Job_Name_text']; ?></th>
                                        <th><?php echo $text['Seq_Name_text']; ?></th>
                                        <th><?php echo $text['Task_text']; ?></th>
                                        <th><?php echo $text['Equipment_text']; ?></th>
                                        <th><?php echo $text['Torque_range_text']; ?></th>
                                        <th><?php echo $text['Angle_range_text']; ?></th>
                                        <th><?php echo $text['Final_Torque_text']; ?></th>
                                        <th><?php echo $text['Final_Angle_text']; ?></th>
                                        <th><?php echo $text['Status_text']; ?></th>
                                        <th><?php echo $text['Error_text']; ?></th>
                                        <th><?php echo $text['Program_text']; ?></th>
                                        <th><?php echo $text['Action_text']; ?></th>
                                    </tr>
                                </thead>
                                 <tbody id="tbody1" style="background-color: #F2F1F1; font-size: 1.8vmin;text-align: center; vertical-align: middle;">
                                    
                                    <?php 
                                    if(isset($data['info'])){
                                    foreach($data['info'] as $k_info =>$v_info){
                                        
                                        
                                        $link ='?url=Historicals/nextinfo/'.$v_info['id'];
                                        ?>
                                        <tr>
                                            <td style="text-align: center;">
                                                <input class="form-check-input" type="checkbox" name="test1" id="test1"  value="<?php echo $v_info['id'];?>" style="zoom:1.2;vertical-align: middle;">
                                            </td>
                                            <td><?php echo $v_info['system_sn'];?></td>
                                            <td><?php echo $v_info['data_time'];?></td>
                                            <td></td>
                                            <td><?php echo $v_info['cc_barcodesn'];?></td>
                                            <td><?php echo $v_info['job_name'];?></td>
                                            <td><?php echo $v_info['sequence_name'];?></td>
                                            <td><?php echo $v_info['cc_task_id'];?></td>
                                            <td><?php echo $data['res_controller_arr'][$v_info['cc_equipment']];?></td>
                                            <td><?php echo $v_info['step_lowtorque']." ~ ".$v_info['step_hightorque'];?></td>
                                            <td><?php echo $v_info['step_lowangle']." ~ ".$v_info['step_highangle'];?></td>
                                            <td><?php echo $v_info['fasten_torque'].$data['torque_arr'][$v_info['torque_unit']] ;?></td>
                                            <td><?php echo $v_info['fasten_angle'] . " deg";?></td>
                                            <td style="background-color:<?php echo $data['status_arr']['status_color'][$v_info['fasten_status']];?> font-size: 20px"><?php echo $data['status_arr']['status_type'][$v_info['fasten_status']];?></td>
                                            <td><?php echo $data['status_arr']['error_msg'][$v_info['error_message']];?></td>
                                            <td><?php echo $v_info['cc_program_id'];?></td>
                                            <td>
                                                <a href=" <?php echo $link;?> " >
                                                    <img src="./img/info-30.png" alt="" style="height: 28px; vertical-align: middle;" >
                                                </a>
                                            </td>
                                        </tr>
                                    <?php }?>
                                    <?php }?>
                                </tbody>
                               
                            </table>

                            
                            <?php if( $data['nopage'] == "1" ){ ?>
                                <div class="pagination" align="center">
                                    <!-- 上一頁 -->
                                    <?php if ($data['page'] > 1): ?>
                                        <a class="prev" href="?url=Historicals&p=<?php echo ($data['page'] - 1); ?>">Pre</a>
                                    <?php endif; ?>
                                    
                                    <!-- 顯示第一頁 -->
                                    <?php if ($data['page'] > 3): ?>
                                        <a class="page-link" href="?url=Historicals&p=1">1</a>
                                        <span class="ellipsis">...</span>
                                    <?php endif; ?>
                                    
                                    <!-- 顯示中間的頁碼 -->
                                    <?php
                                    $start = max(1, $data['page'] - 2); // 顯示當前頁之前的兩頁
                                    $end = min($data['totalPages'], $data['page'] + 2); // 顯示當前頁之後的兩頁
                                    
                                    for ($i = $start; $i <= $end; $i++): ?>
                                        <?php if ($i == $data['page']): ?>
                                            <span class="current-page"><?php echo $i; ?></span>
                                        <?php else: ?>
                                            <a class="page-link" href="?url=Historicals&p=<?php echo $i; ?>"><?php echo $i; ?></a>
                                        <?php endif; ?>
                                    <?php endfor; ?>

                                    <!-- 顯示最後一頁 -->
                                    <?php if ($data['page'] < $data['totalPages'] - 2): ?>
                                        <span class="ellipsis">...</span>
                                        <a class="page-link" href="?url=Historicals&p=<?php echo $data['totalPages']; ?>"><?php echo $data['totalPages']; ?></a>
                                    <?php endif; ?>
                                    
                                    <!-- 下一頁 -->
                                    <?php if ($data['page'] < $data['totalPages']): ?>
                                        <a class="next" href="?url=Historicals&p=<?php echo ($data['page'] + 1); ?>">Next</a>
                                    <?php endif; ?>
                                </div>
                            <?php } ?>

                            <div id="pagination_new"></div>

                        </div>