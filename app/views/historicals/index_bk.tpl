<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>各種日期選擇器範例</title>

    <!-- jQuery UI Datepicker -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/css/bootstrap-datepicker.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/air-datepicker@2.3.1/dist/css/datepicker.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/vuejs-datepicker/dist/vuejs-datepicker.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pikaday/pikaday.css">
    <link rel="stylesheet" href="http://www.jsdatepicker.com/jsDatePick_ltr.min.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap-datepicker@1.9.0/dist/js/bootstrap-datepicker.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/pikaday/pikaday.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/air-datepicker@2.3.1/dist/js/datepicker.min.js"></script>
    <script src="http://www.jsdatepicker.com/jsDatePick.min.1.3.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vuejs-datepicker"></script>
</head>
<body>

<div class="container mt-5">
    <h2>日期選擇器範例</h2>

    <!-- jQuery UI Datepicker -->
    <div class="mb-3">
        <label for="datepicker-jquery-ui">jQuery UI Datepicker</label>
        <input type="text" id="datepicker-jquery-ui" class="form-control">
    </div>

    <!-- Bootstrap Datepicker -->
    <div class="mb-3">
        <label for="datepicker-bootstrap">Bootstrap Datepicker</label>
        <input type="text" id="datepicker-bootstrap" class="form-control">
    </div>

    <!-- Flatpickr -->
    <div class="mb-3">
        <label for="datepicker-flatpickr">Flatpickr</label>
        <input type="datetime" id="datepicker-flatpickr" class="form-control" style="width: 190px; border-radius: 5px;border: 1px solid #CCCCCC;">
    </div>

    <!-- Moment.js + Bootstrap Datepicker -->
    <div class="mb-3">
        <label for="datepicker-moment">Moment.js + Bootstrap Datepicker</label>
        <input type="text" id="datepicker-moment" class="form-control">
    </div>

 
 

</div>

<script>
    // jQuery UI Datepicker
    $(document).ready(function() {
        $("#datepicker-jquery-ui").datepicker();
    });

    // Bootstrap Datepicker
    $(document).ready(function() {
        $('#datepicker-bootstrap').datepicker();
    });

    // Flatpickr
     flatpickr("#datepicker-flatpickr", {
            enableTime: true,  // 啟用時間選擇
            dateFormat: "Y-m-d H:i",  // 設定日期與時間的顯示格式
            time_24hr: true,  // 使用24小時制（可選）
        });

    // Pikaday
    var picker = new Pikaday({ field: document.getElementById('datepicker-pikaday') });

    // Moment.js + Bootstrap Datepicker
    $(document).ready(function() {
        $('#datepicker-moment').datepicker({
            format: 'yyyy-mm-dd',
            startDate: moment().format('YYYY-MM-DD')
        });
    });

    // Date Range Picker for Bootstrap
    $(document).ready(function() {
        $('#daterange').daterangepicker();
    });

    // Air Datepicker
    new AirDatepicker('#datepicker-air');

    // jsDatePick
    var dp = new JsDatePick({
        useMode: 2,
        target: "datepicker-jsDatePick"
    });

    // Vue.js Datepicker
    new Vue({
        el: '#vue-datepicker',
        data: {
            date: ''
        },
        template: '<vuejs-datepicker v-model="date"></vuejs-datepicker>'
    });
</script>

</body>
</html>
