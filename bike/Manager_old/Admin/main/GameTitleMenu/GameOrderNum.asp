<!-- #include file="../../dev/dist/config.asp"-->
<% 
  'REQ = "{""CMD"":2,""NationType"":""B0010001"",""GameTitleName"":""테스트대회"",""GamePlace"":""테스트대회"",""GameStartDate"":""2017-12-07"",""GameEndDate"":""2017-12-31"",""GameTitleLocation"":""01"",""EnterType"":""A"",""ViewYN"":""Y""}"
  tIdx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tIdx =crypt.EncryptStringENC(tIdx )

  if tidx = "" then
    Response.Write "<script>alert('잘못된 경로로 이동하셨습니다.')</script>"
    Response.Write "<script>location.href='./index.asp'</script>"
    Response.End
  End if

  LSQL = "SELECT GameTitleIDX ,GameTitleName,GameS,GameE ,EnterType, PersonalPayment, GroupPayment"
  LSQL = LSQL & " FROM  tblGameTitle"
  LSQL = LSQL & " WHERE GameTitleIDX = " &  tidx
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleIDX = LRs("GameTitleIDX")
      tGameTitleEnterType = LRs("EnterType")
      tGameTitleName = LRs("GameTitleName")
      tGameS = LRs("GameS")
      tGameE = LRs("GameE")
      tEnterType = LRS("EnterType") 
      tPersonalPayment= LRS("PersonalPayment")
      tGroupPayment= LRS("GroupPayment")
      LRs.MoveNext
    Loop
  End If
  LRs.close
%>

<html>
  <head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta charset="utf-8">
  <title>경기 진행순서</title>
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <script src="/js/jquery-1.12.2.min.js"></script>
  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <link href="/css/lib/jquery-ui.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <link rel="stylesheet" href="/css/admin/admin.d.style.css">
  <script src="../../js/CommonAjax.js"></script>
  <script src="../../js/GameNumber/GameNumber.js"></script>
  <script >
      $(document).ready(function() {
      var gameTitleIDX = "<%=crypt_tIdx%>";

      SelGameNumber(gameTitleIDX);

        $(".up, .down").click(function() {
          var $element = this;
          var row = $($element).parents("tr:first");
          var swapRow = $(this).is('.up') ? row.prev() : row.next();

          if ($(this).is('.up')) {
              row.insertBefore(swapRow);
          } else {
              row.insertAfter(swapRow);
          }
          SetLevelGameNumber();
          
          /*   
          if(swapRow.children()) {
            var tempValue = row.children().first().html();
            alert(tempValue)
            var firstValue = swapRow.children().first().html()
            row.children().first().html(firstValue);
            alert(firstValue)
            swapRow.children().first().html(tempValue);
          }
          */
        
        });
    });

  </script>
</head>

<body>
      <!-- S: setup-header -->
      <div class="setup-header">
        <h3 id="myModalLabel"><span class="tit">경기 진행순서 설정</span> <span class="txt"></span></h3>
      </div>
      <!-- E: setup-header -->
      
      <!-- S: setup-body -->
      <div class="setup-body game-number" id="divGameNumberBody">
       
      </div>
      <!-- E: setup-body -->
  </body>
</html>