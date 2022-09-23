<!DOCTYPE html>
<html>

<head>

  <meta charset="utf-8">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

  <script type="text/javascript">


    $(function () {

      $("#submit").click(function () {

        var isel = "";
        var iselcnt = Number(0);

        var selectedCheck = new Array();
        $('.inputchk:checked').each(function () {
          selectedCheck.push(this.value);
          iselcnt = iselcnt + 1;
        });
        // alert(selectedCheck + '\n개수 : '+selectedCheck.length); 
        if (selectedCheck.length < 1) {
          alert("관심종목을 선택하지 않으셨습니다.\n관심종목을 선택하여 주세요");
          return false;
        }

        for (var i = 0; i < iselcnt; i++) {
          isel = isel + "^" + selectedCheck[i];
        }

        fn_sel(isel);

      });

    });

    function fn_sel(slc) {

      alert(slc);

    }

  </script>

</head>

<body>
  <ul class="allchk">
    <h1 style="color: red">관심종목을 선택하지 않으셨습니다. </h1>
    <h3>관심종목을 선택해 주세요</h3>
    <label>
      <input class="inputchk" name="class[1]" value="1" type="checkbox">배드민턴</label>
    <label>
      <input class="inputchk" name="class[2]" value="2" type="checkbox">유도</label>
    <label>
      <input class="inputchk" name="class[3]" value="3" type="checkbox">테니스</label>
    <label>
      <input class="inputchk" name="class[4]" value="4" type="checkbox">자전거</label>
    <label>
      <input class="inputchk" name="class[5]" value="5" type="checkbox">수영</label>
  </ul>
  <button type='submit' class='btn btn-primary' id='submit'>확인</button>
</body>
</html>