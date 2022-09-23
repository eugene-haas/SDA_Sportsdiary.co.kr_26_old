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
      $(".up, .down").click(function() {
        var $element = this;
        var row = $($element).parents("tr:first");
        var swapRow = $(this).is('.up') ? row.prev() : row.next();

        if ($(this).is('.up')) {
            row.insertBefore(swapRow);
        } else {
            row.insertAfter(swapRow);
        }

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
        SetLevelGameNumber();
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
      <div class="setup-body game-number">

        <!-- S: top-ctr -->
        <div class="top-ctr">
          <!-- S: stair -->
          <div class="stair clearfix">
              <select id="selGameTitle" name="selGameTitle" class="sel-ctr" onchange="selGameTitleChanged()">
                <%
                    LSQL = "SELECT GameTitleIDX ,GameTitleName"
                    LSQL = LSQL & " FROM  tblGameTitle"
                    LSQL = LSQL & " WHERE DelYN = 'N'"
                    'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

                    Set LRs = DBCon.Execute(LSQL)
                    If Not (LRs.Eof Or LRs.Bof) Then
                      Do Until LRs.Eof
                        tGameTitleIDX2 = LRs("GameTitleIDX")
                        crypt_tGameTitleIDX2 = crypt.EncryptStringENC(tGameTitleIDX2)
                        tGameTitleName2 = LRs("GameTitleName")

                        IF cdbl(tGameTitleIDX) = cdbl(tGameTitleIDX2) Then %>
                        <option value="<%=crypt_tGameTitleIDX2%>" selected><%=tGameTitleName2%></option>
                        <%ELSE%>
                        <option value="<%=crypt_tGameTitleIDX2%>"><%=tGameTitleName2%></option>
                        <% End IF
                        LRs.MoveNext
                      Loop
                    End If
                    LRs.close
                %>
              </select>
          </div>
          <!-- E: stair -->

          <!-- S: stair -->
          <div class="stair">
            <span> [장소 리스트]</span>
            <div id="divStadiumLst" name="divStadiumLst" class="stadium-list">
              <select name="selStadium" id="selStadium" onclick="selStadium()" >
              <%
                LSQL = " SELECT  StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt  "
                LSQL = LSQL & " FROM  tblStadium "
                LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & tIdx & "'"
                'Response.Write "LSQL " & LSQL 
                Set LRs = DBCon.Execute(LSQL)
                  If Not (LRs.Eof Or LRs.Bof) Then
                    Do Until LRs.Eof
                      StadiumCnt = StadiumCnt + 1
                      tGameTitleIDX3 = LRs("GameTitleIDX")
                      crypt_tGameTitleIDX3 =crypt.EncryptStringENC(tGameTitleIDX3)
                      tStadiumIDX = LRs("StadiumIDX")
                      tStadiumCourt = LRs("StadiumCourt")
                      
                      IF CDBL(StadiumCnt) = CDBL(1) Then
                        Sel_StadiumIDX = tStadiumIDX
                      End IF
                      crypt_tStadiumIDX =crypt.EncryptStringENC(tStadiumIDX)
                      tStadiumName = LRs("StadiumName")
                      IF CDBL(tStadiumIDX) =CDBL(Sel_StadiumIDX) Then
                      %>
                      <option value="<%=crypt_tStadiumIDX%>" checked> <%=tStadiumName%>-코트 수 : <%=tStadiumCourt%></option>
                      <%Else%>
                      <option value="<%=crypt_tStadiumIDX%>" > <%=tStadiumName%>-코트 수 : <%=tStadiumCourt%></option>
                      <%End If%>
                      <%                    
                    LRs.MoveNext
                  Loop
                End If
                LRs.close
              %>
              </select>
            </div>
            <%

              LSQL = " SELECT  Count(*) as GameNumberCnt "
              LSQL = LSQL & " FROM tblGameLevel "
              LSQL = LSQL & " where  UseYN ='Y' and  DelYN='N' and  GameTitleIDX = '" & tIdx & "' and  StadiumNum = '" & Sel_StadiumIDX &"' and GameNumber='0' "
      
              'Response.write "LSQL " & LSQL & "<br>"
              Set LRs = DBCon.Execute(LSQL)
              If Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                    GameNumberCnt = LRs("GameNumberCnt")
                  LRs.MoveNext
                Loop
              End If
              LRs.close

              '해당 대회에 속한 체육관이 있다면 최대 GameNumberMax번호를 가져옵니다.
              IF CDBL(GameNumberCnt) > 0 Then
                Dim GameLevelidxs :GameLevelidxs = ""
                LSQL = " SELECT  GameLevelidx "
                LSQL = LSQL & " FROM tblGameLevel "
                LSQL = LSQL & " where  UseYN ='Y' and  DelYN='N' and  GameTitleIDX = '" & tIdx & "' and  StadiumNum = '" & Sel_StadiumIDX &"' and GameNumber='0' "
                LSQL = LSQL & " order by GameLevelidx desc"
                'Response.write "LSQL " & LSQL & "<br>"
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                      GameLevelidxs = LRs("GameLevelidx") & "_" & GameLevelidxs 
                    LRs.MoveNext
                  Loop
                End If
                LRs.close


                LSQL = " SELECT Top 1 GameNumber "
                LSQL = LSQL & " FROM tblGameLevel "
                LSQL = LSQL & " where  UseYN ='Y' and  DelYN='N' and  GameTitleIDX = '" & tIdx & "' and  StadiumNum = '" & Sel_StadiumIDX &"' "
                LSQL = LSQL & " Order by GameNumber Desc "
                'Response.write "LSQL " & LSQL & "<br>"

                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                      GameNumberMax = LRs("GameNumber")
                    LRs.MoveNext
                  Loop
                End If
                LRs.close
              End IF

              'Response.Write "GameLevelidxs" & GameLevelidxs
            Dim gameNumberLevelCnt : gameNumberLevelCnt = 0
            Dim selGameNumberLevelIdx : selGameNumberLevelIdx  = 0
            %>

            
            <a href="javascript:SetGameNumber();"  class="btn btn-confirm">진행순서 적용</a>
          </div>
          <!-- E: stair -->
        </div>
        <!-- E: top-ctr -->

        <%  
          Dim Sel_StadiumIDX : Sel_StadiumIDX = 0
        %>

        <!-- S: content-wrap -->
        <div class="content-wrap divn-hori" id="drowbody">
          <!-- S: divGameLevelList remote-arr -->
          <div id="divGameLevelList" class="remote-arr">
          <%
            'Response.Write "GameNumberCnt : " & GameNumberCnt & "<br>"
            'Response.Write "GameNumberMax : " & GameNumberMax & "<br>"
          %>
            <table id="tableGameLevelList" class="table table-arr table-fix-head">
            <caption class="sr-only">종별 순서</caption>
              <tbody>
                <tr>
                  <th>순서</th>
                  <th>종별 목록</th>
                  <th>팀 수</th>
                  <th colspan="2">인원 수</th>
                  <!-- <th>-</th> -->
                </tr>
              </tbody>
            </table>

            <table class="table table-arr table-fix-body">
              <tbody>
              <%
                If(cdbl(tIdx) > 0) Then
                LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & tIdx & "','" & Sel_StadiumIDX & "'"
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
                  If Not (LRs.Eof Or LRs.Bof) Then
                    Do Until LRs.Eof
                      gameNumberLevelCnt = gameNumberLevelCnt + 1
                      tGameNumber = LRs("GameNumber")
                      tGameTitleIdx = LRs("GameTitleIdx")
                      tGameLevelidx = LRs("GameLevelidx")
                      crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelidx)
                      tTeamGbNM= LRs("TeamGbNM")
                      tLevelNM= LRs("LevelNM")
                      tSexNM= LRs("SexNM")
                      tLevelJooNameNM= LRs("LevelJooNameNM")
                      tLevelJooNum= LRs("LevelJooNum")
                      tTeamGroupCnt = LRs("TeamGroupCnt")
                      tParticipateCnt= LRs("ParticipateCnt") 

                      if(cdbl(gameNumberLevelCnt) = 1) Then
                        selGameNumberLevelIdx = tGameLevelidx
                      End if
              %>    
                      <tr>
                        <td> 
                          <input type="hidden" value="<%=crypt_tGameLevelidx%>">
                          <%=tGameNumber%>
                        </td>
                        <td>
                          <input type="hidden"  value="<%=tGameLevelidx%>">
                          <%=tTeamGbNM%>-<%=tLevelNM%>-<%=tLevelJooNameNM%><%=tLevelJooNum%>
                        </td>
                        <td>
                          <%=tTeamGroupCnt%>
                        </td>
                        <td>
                          <%=tParticipateCnt%>
                          <button class="btn btn-basic up">Up </button>
                          <button class="btn btn-gray down">Down </button>
                        </td>
                      </tr>
              <%
                      LRs.MoveNext
                    Loop
                  End If
                  LRs.close
                End IF

                if cdbl(gameNumberLevelCnt) = 0 Then
                %>
                <tr>
                  <td colspan="4">
                    등록된 종별이 없습니다.
                  </td>
                </tr>
                <%
                End if
                %>
              </tbody>
            </table>
          </div> 
          <!-- E: divGameLevelList remote-arr -->

          <!-- S: show-arr -->
           <div class="show-arr">
            <!-- S: table-arr -->
             <table class="table table-arr table-fix-head">
              <tbody>
                <tr>
                  <!-- 하단의 table-fix-body > tbody 의 개수만큼 
                  colspan 값을 넣어서 사용 -->
                  <th colspan="">진행순서 리스트</th>
                </tr>
              </tbody>
            </table>
            <!-- E: table-arr -->

            <!-- S: table-arr -->
            <table class="table table-arr table-fix-body">
              <tbody>
             
              </tbody>
            </table>
            <!-- E: table-arr -->
          </div>
          <!-- E: show-arr -->

        </div>
        <!-- E: content-wrap -->
      </div>
      <!-- E: setup-body -->
  </body>
</html>