<?php require APPROOT . 'views/inc/header.tpl'; ?>
<?php echo $data['nav']; ?>

<div class="container-ms">
    <header>
        <div class="home">
            <img id="header-img" src="./img/home-head.svg"><?php echo $text['main_home_text']; ?>
        </div>

        <div class="notification">
            <i style="width:auto; height:40px" class="fa fa-bell" onclick="ClickNotification()"></i>
            <span id="messageCount" class="badge"></span>
        </div>
        <div class="personnel"><i style="width:auto; height: 40px" class="fa fa-user"></i> <?php echo $_SESSION['user']; ?> </div>
    </header>
    <?php //require APPROOT . 'views/inc/head_div.tpl'; ?>

    <!-- Notification -->
    <div id="messageBox" class="messageBox" style="display: none;">
        <div class="topnav-message">
            <label type="text" style="font-size: 24px; padding-left: 3%; margin: 7px 0; color: #000"><b>Notification</b></label>
            <span class="close-message w3-display-topright" onclick="ClickNotification()">&times;</span>
        </div>
        <div class="scrollbar-message" id="style-message">
            <div class="force-overflow-message">
                <div style="padding: 0 10px; padding-bottom: 20px">
                    <div id="EquipmentWarning" style="font-size: 18px">
                        <a><b>Equipment Warning</b></a>
                        <a style="float: right">11m</a>
                    </div>
                    <div id="EW-Mess" style="font-size: 15px; padding-bottom: 5px" class="checkboxFour">
                        <a>recycle box: a-111s2 is reached the <br> threshold count for <a style="color: red">80%</a>. please reset recycle box.</a>
                        <a style="float: right; margin: 5px;">
                            <input type="checkbox" value="1" id="checkboxFourInput" name="" hidden="hidden" checked="checked">
                            <label for="checkboxFourInput"></label>
                        </a>
                    </div>
                    <div>
                        <label class="recyclebox">Recycle box</label>
                        <label class="workstation">workstation 3</label>
                    </div>
                </div>

                <div style="padding: 0 10px; padding-bottom: 20px">
                    <div id="EquipmentRecovery" style="font-size: 18px">
                        <a><b>Equipment recovery</b></a>
                        <a style="float: right">1m</a>
                    </div>
                    <div id="ER-Mess" style="font-size: 15px; padding-bottom: 5px" class="checkboxFour">
                        <a>recycle box: a-111s2 is clear the threshold count.</a>
                        <a style="float: right; margin: 5px;">
                            <input type="checkbox" value="1" id="checkboxFourInput" name="" hidden="hidden" checked="checked">
                            <label for="checkboxFourInput"></label>
                        </a>
                    </div>
                    <div>
                        <label class="recyclebox">Recycle box</label>
                        <label class="workstation">workstation 3</label>
                    </div>
                </div>

                <div style="padding: 0 10px; padding-bottom: 20px">
                    <div id="EquipmentRecovery" style="font-size: 18px">
                        <a><b>Equipment Warning</b></a>
                        <a style="float: right">2h</a>
                    </div>
                    <div id="ER-Mess" style="font-size: 15px; padding-bottom: 10px" class="checkboxFour">
                        <a>Controller:GTCS has............</a>
                        <a style="float: right; margin: 5px;">
                            <input type="checkbox" value="1" id="checkboxFourInput" name="" hidden="hidden" checked="checked">
                            <label for="checkboxFourInput"></label>
                        </a>
                    </div>
                    <div>
                        <label class="recyclebox">Recycle box</label>
                        <label class="workstation">workstation 3</label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="w3-white w3-border">
        <marquee>iAMS - Intelligen Alarm Management System</marquee>
    </div>
    <div style="margin-top: 0%; text-align: center; font-size: 50px"><b>Kilews</b></div>

    <div class="scrollbar" id="style-all">
        <div class="scrollbar-force-overflow">
            <div class="container">
                <div class="menu-button">
                    <div style="margin: 20px 100px" class="w3-center button-container">
                        <?php
                            $count = 0;
                            foreach ($data['rows'] as $key => $value) {
                                if( in_array($value['controller'], $data['permissions']) ){//有權限才顯示
                                // if( in_array($value['controller'], $data['permissions']) || $value['name'] == 'home' ){//有權限才顯示
                                    // echo $value['name'] . ' ';
                                    echo '<button class="menu-item" onclick="window.location.href=\''.$value['link'].'\'">';
                                    echo '<img src="'.$value['img'].'" alt="" style="margin-bottom: 10px">';
                                    echo '<span style="font-size: 18px; line-height: 1.5">'. $text['main_'.$value['name'].'_text'] .'</span>';
                                    echo '</button>';
                                    $count += 1;
                                    if ($count % 4 == 0) {
                                        echo '<br><br>';
                                    }
                                }
                                // echo($key);
                            }
                        ?>

                        <button class="menu-item"  onclick="DB2GTCS()">
                            <img src="./img/database.svg" alt="" style="margin-bottom: 10px;">
                            <span style="font-size: 18px; line-height: 1.5px"><?php echo $text['main_DB_SYNC_text'] ?></span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    function DB2GTCS(argument)
    {
        var yes = confirm('<?php echo $text['Delete_confirm_text']; ?>');

        if (yes) {
            let url = '?url=Settings/GTCS_DB_SYNC';
            $.ajax({
                type: "POST",
                data: { },
                // dataType: "json",
                url: url,
                beforeSend: function() {
                    $('#overlay').removeClass('hidden');
                },
            }).done(function(data) { //成功且有回傳值才會執行
                $('#overlay').addClass('hidden');
                // console.log(data);
                alert('success');
            }).fail(function() {
                // history.go(0);//失敗就重新整理
            });
        } else {

        }
    }

// Notification ....................
let messageCount = 0;

function addMessage() {
    messageCount++;
    document.getElementById('messageCount').innerText = messageCount;
}

function ClickNotification() {
    let messageBox = document.getElementById('messageBox');
    let closeBtn = document.getElementsByClassName("close")[0];
    messageBox.style.display = (messageBox.style.display === 'block') ? 'none' : 'block';
}

addMessage();

</script>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>