<?php 
function includecss_file($part, $cssFileName) {
    $queryString = $_SERVER['QUERY_STRING'];
    $queryStringWithoutUrl = str_replace('url=', '', $queryString);
    $parts = explode('/', $queryStringWithoutUrl);
    $firstPart = $parts[0];
    $extension = pathinfo($cssFileName, PATHINFO_EXTENSION);

    if($firstPart == $part){
        if($extension == 'css'){ ?>
<link rel="stylesheet" type="text/css" href="<?php echo URLROOT; ?>css/<?php echo $cssFileName; ?>?v=<?php echo date('YmdHi');?>">
        <?php }elseif($extension == 'js'){ ?>
<script src="<?php echo URLROOT; ?>js/<?php echo $cssFileName; ?>?v=<?php echo date('YmdHi'); ?>"></script>
        <?php }
    }
}

#載入css
includecss_file("Mains", "main.css");
includecss_file("Calibrations", "calibration.css");
includecss_file("Users", "identification.css");
includecss_file("Settings", "setting.css");

#載入js
includecss_file("Calibrations", "calibrations.js");
   
?>
    