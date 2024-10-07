<header>
    <div class="home">
        <img id="header-img" src="./img/home-head.svg">Home
    </div>
    <div class="notification">
        <i style="width:auto; height:40px" class="fa fa-bell" onclick="ClickNotification()"></i>
        <span id="messageCount" class="badge"></span>
    </div>
    <div class="personnel"><i style="width:auto; height: 40px" class="fa fa-user"></i>
        <?php echo $_SESSION['user']; ?>
    </div>
</header>