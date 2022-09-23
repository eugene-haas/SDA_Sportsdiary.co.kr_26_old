<script>
  /**
   * 캘린더 호출
   */
  if ($('.date_ipt')) {
    $('.date_ipt').datepicker({
      'changeYear' : true,
      'changeMonth' : true,
      'yearRange' : '1900:',
      'dateFormat': 'yy-mm-dd'
    });
  }
</script>

</body>
</html>