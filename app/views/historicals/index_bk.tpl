<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Flatpickr with Moment.js</title>

  <!-- 引入 Flatpickr 的 CSS -->
  <!--<link rel="stylesheet" href="css/flatpickr_min.css">-->

  <!-- 引入 Moment.js -->
  <!--<script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/moment.min.js"></script>-->
  <!--<script src="js/moment.min.js"></script>-->
  <!-- 引入 jQuery 和 Flatpickr 的 JS -->
  <!--<script src="js/jquery-3.7.1.min.js"></script>-->
  <!--<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>-->
  <!--<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>-->
  <!--<script src="js/flatpickr.js"></script>-->


  <script src="../public/js/jquery-3.7.1.min.js"></script>
  <script src="../public/js/sweetalert2.js"></script>
  <script src="../public/js/moment.min.js"></script>



  
  <link rel="stylesheet" href="../public/css/historical.css?v=202404111200" type="text/css">
  <link rel="stylesheet" href="../public/css/flatpickr_min.css?v=202412041130" type="text/css">
  
  <script src="../public/js/flatpickr.js"></script>
  <script src="../public/js/historical.js?v=202412040414"></script>
  
  <script src="/public/js/echarts_min.js?v=202412040414"></script>
  <script src="/public/js/html2canvas_min.js?v=202412040414"></script>


</head>
<body>

  <!-- 用於選擇日期和時間的輸入框 -->

<input type="text" id="FromDate"  class="form-control input-ms" style="margin-right: 7px">
<input type="datetime-local" id="meeting-time">
<script>
    // 使用 Flatpickr 並搭配 Moment.js 格式化
    flatpickr("#FromDate", {
      enableTime: true,                // 開啟時間選擇功能
      dateFormat: "Y-m-d H:i",         // 設定日期和時間格式
      onChange: function(selectedDates, dateStr, instance) {
        // 使用 Moment.js 進行格式化
        const formattedDate = moment(dateStr, "YYYY-MM-DD HH:mm").format("YYYY-MM-DD HH:mm");
        console.log(formattedDate);  // 輸出格式化後的日期時間
      }
    });
  </script>
</body>
</html>
