<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../public/img/cc_icon.png" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="60x60" href="../public/img/icon.svg>
    <link rel="icon" type='image' sizes="192x192" href="../public/img/icon.svg">

    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="theme-color" content="#000000">

    <!-- <link rel="stylesheet" href="<?php echo URLROOT; ?>/css/style.css"> -->
    <!-- <link rel="stylesheet" href="<?php echo URLROOT; ?>/css/datatables.min.css"> -->
    <!-- <link rel="stylesheet" href="<?php echo URLROOT; ?>/css/sweetalert2.css"> -->
    <!-- <script src="<?php echo URLROOT; ?>/js/datatables.min.js"></script> -->
    <!-- <script src="<?php echo URLROOT; ?>/js/sweetalert2.js"></script> -->
    <!-- <script src="<?php echo URLROOT; ?>/js/main.js"></script> -->

    <script src="<?php echo URLROOT; ?>/js/jquery-3.7.1.min.js"></script>
    <script src="<?php echo URLROOT; ?>/js/sweetalert2.js"></script>
    <script src="<?php echo URLROOT; ?>/js/moment.min.js"></script>
    
    <title><?php echo SITENAME; ?></title>
</head>
<body>


<link rel="stylesheet" href="<?php echo URLROOT; ?>css/w3.css" type="text/css">
<link rel="stylesheet" href="<?php echo URLROOT; ?>css/login.css" type="text/css">
<link href='<?php echo URLROOT; ?>css/boxicons.min.css' rel='stylesheet'>

    <div class="container">
        <header>
            <h2>Kilews</h2>
            <h4><?php echo $text['login_text']; ?></h4>
        </header>
        <form action="?url=Logins" method="POST">
            <input checked id='login' name="action" type='radio' value='login' required onchange="toggleUsernameField()">
            <label for='login'><?php echo $text['account_text']; ?></label>

            <input id='idlogin' name='action' type='radio' value='idlogin' onchange="toggleUsernameField()">
            <label for='idlogin'>ID</label>

            <div id='wrapper'>
                <div id='arrow'></div>
                <input id='username' name="username" placeholder='<?php echo $text['account_text']; ?>' type='text'>
                <input id='password' name="password" placeholder='<?php echo $text['password_text']; ?>' type='password'>
            </div>
            <button type='submit' id="loginButton"><?php echo $text['account_text'].' '.$text['login_text']; ?></button>
        </form>

        <!--  Change Language -->
        <div id="language-selector" class="w3-padding w3-display-botom">
            <label style="font-size: 16px; color: #fff" for="language"><?php echo $text['select_language_text']; ?> :</label>&nbsp;
            <select class="custom-select" id="language" onchange="language_change()">
                <option value="zh-tw">繁中</option>
                <option value="zh-cn">简中</option>
                <option value="en-us">English</option>
                <option value="vi-vn">Tiếng Việt</option>
            </select>
        </div>
    </div>

  <script>
    function language_change() {
        let lang = document.getElementById('language').value;

        $.ajax({
          type: "POST",
          url: "?url=Mains/change_language",
          data: {'language':lang},
          dataType: "json",
          // encode: true,
          // async: false,//等待ajax完成
        }).done(function (data) {//成功且有回傳值才會執行
            window.location = window.location.href;
        });
    }

    $(document).ready(function () {
        <?php
            if(isset($data['error_message'])){
                if($data['error_message'] != ''){
                    echo "alert('",$data['error_message'],"')";
                }
            }
        ?>
        document.getElementById("language").value = "<?php echo $_SESSION['language']; ?>";
    });

// Change Language .......
function changeLanguage()
{
    var selectedLanguage = document.getElementById("language").value;

    var elements = document.querySelectorAll("[data-zh], [data-en], [data-vi]");

    elements.forEach(function(element) {
        switch (selectedLanguage) {
            case "zh":
                element.textContent = element.getAttribute("data-zh");
                break;
            case "en":
                element.textContent = element.getAttribute("data-en");
                break;
            case "vi":
                element.textContent = element.getAttribute("data-vi");
                break;
            default:
                element.textContent = element.getAttribute("data-en");
                break;
        }
    });
}

// Function to toggle visibility of username field based on selected action
function toggleUsernameField()
{
    var idLoginRadio = document.getElementById('idlogin');
    var usernameField = document.getElementById('username');

    // If ID login is selected, hide the username field
    if (idLoginRadio.checked) {
        usernameField.style.display = 'none';
        document.getElementById('loginButton').innerHTML = 'ID <?php echo $text['login_text']; ?>';
    } else {
        usernameField.style.display = ''; // Show the username field
        document.getElementById('loginButton').innerHTML = '<?php echo $text['account_text'].' '.$text['login_text']; ?>';
    }
}

  </script>

<?php require APPROOT . 'views/inc/footer.tpl'; ?>