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
  <title>Frameset</title>
  <script type="text/javascript">
  document.createElement('header');document.createElement('aside');document.createElement('article');document.createElement('footer');</script>
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <script src="/js/jquery-1.12.2.min.js"></script>
  <script src="/js/jquery-ui.min.js"></script>
  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <script src="/ckeditor/ckeditor.js"></script>
  <link rel="stylesheet" type="text/css" href="/css/style_bmtourney.css?v=2">
  <script src="//cdn.rawgit.com/fgelinas/timepicker/master/jquery.ui.timepicker.js"></script>
  <script src="../../js/CommonAjax.js"></script>
  <script src="../../js/GameNumber/GameNumber.js"></script>
</head>

<body>
      <div class="modal-header game-ctr">
        <h3 id="myModalLabel"><span class="tit">경기 진행순서 설정</span> <span class="txt"></span></h3>
      </div>
      <div class="modal-body game-ctr" style="padding-bottom:0px;">
        <div class="top_control">
          <!-- S: league_tab -->
          <div class="league_tab clearfix">
            <div class="pull-left">
              <select id="selGameTitle" name="selGameTitle" onchange="selGameTitleChanged()">
                <%
                    LSQL = "SELECT GameTitleIDX ,GameTitleName"
                    LSQL = LSQL & " FROM  tblGameTitle"
                    LSQL = LSQL & " WHERE DelYN = 'N'"
                    'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

                    Set LRs = DBCon.Execute(LSQL)
                    If Not (LRs.Eof Or LRs.Bof) Then
                      Do Until LRs.Eof
                        tGameTitleIDX2 = LRs("GameTitleIDX")
                        crypt_tGameTitleIDX2 =crypt.EncryptStringENC(tGameTitleIDX2)
                        tGameTitleName2 = LRs("GameTitleName")

                        IF cdbl(tIDX) = cdbl(tGameTitleIDX2) Then %>
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
            <div class="pull-right">
            </div>
          </div>
          <div class="sel_box">
          </div>
        </div>

        <%  
          Dim Sel_StadiumIDX : Sel_StadiumIDX = 0
        %>
        <div class="scroll_box" id="drowbody">
          <span> [장소 리스트]</span>
          <div id="divStadiumLst" name="divStadiumLst">
          <input id="hiddenGameTitleIdx" name="hiddenGameTitleIdx" type="hidden" value="<%=crypt_tIdx%>">
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
          Dim gameNumberLevelCnt : gameNumberLevelCnt = 0
          Dim selGameNumberLevelIdx : selGameNumberLevelIdx  = 0
          %>
          <div id="divGameLevelList" style="width: 33%; display: inline-block;">
            <table class="table-list">
              <thead>
                <tr>
                  <th>종별 목록</th>
                </tr>
              </thead>
              <colgroup>
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="100px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
              </colgroup>
              <tbody>
              <%
                If(cdbl(tIdx) > 0) Then
                LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & tIdx & "','" & Sel_StadiumIDX & "'"
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
                  If Not (LRs.Eof Or LRs.Bof) Then
                    Do Until LRs.Eof
                      gameNumberLevelCnt = gameNumberLevelCnt + 1
                      tGameTitleIdx = LRs("GameTitleIdx")
                      tGameLevelidx = LRs("GameLevelidx")
                      crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelidx)
                      tTeamGbNM= LRs("TeamGbNM")
                      tLevelNM= LRs("LevelNM")
                      tSexNM= LRs("SexNM")
                      tLevelJooNameNM= LRs("LevelJooNameNM")
                      tLevelJooNum= LRs("LevelJooNum")

                      if(cdbl(gameNumberLevelCnt) = 1) Then
                        selGameNumberLevelIdx = tGameLevelidx
                      End if
              %>
                      <tr>
                       <td style="cursor:pointer" onclick="javascript:selLevel('<%=crypt_tGameLevelidx%>')">
                            <%=tTeamGbNM%>-<%=tLevelNM%>-<%=tLevelJooNameNM%><%=tLevelJooNum%>
                        </td>
                      </tr>
              <%
                      LRs.MoveNext
                    Loop
                  End If
                  LRs.close
                End IF
              %>
              </tbody>
            </table>
          </div> 

          <div id="divGameLevelDtlList" style="width: 33%;display: inline-block;">
            <table class="table-list">
              <thead>
                <tr>
                  <th>종별 세부목록</th>
                </tr>
              </thead>
              <colgroup>
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="100px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
              </colgroup>
              <tbody>
              <%
                LSQL = "EXEC tblGameNumberLevelDtl_Searched_STR_1 '" & tIdx & "','" & selGameNumberLevelIdx & "'"
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                    tPlayLevelTypeNM= LRs("PlayLevelTypeNM")
                    tPlayLevelType= LRs("PlayLevelType")
                    tLevelJooNum= LRs("LevelJooNum")
                    tGameLevelidx = LRs("GameLevelidx")
                    tGameTitleIdx = LRs("GameTitleIdx")
                    crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelidx)
                    tTeamGbNM= LRs("TeamGbNM")
                    tLevelNM= LRs("LevelNM")
                    tSexNM= LRs("SexNM")
                    tLevelJooNameNM= LRs("LevelJooNameNM")
                    tLevelJooNum= LRs("LevelJooNum")

                   %>
                      <tr>
                       <td style="cursor:pointer">
                       <%  IF tPlayLevelType = "B0100001" Then %>
                         [<%=tTeamGbNM%>-<%=tLevelNM%>-<%=tLevelJooNameNM%><%=tLevelJooNum%>]&nbsp;<%=tPlayLevelTypeNM%>&nbsp;<%=tLevelJooNum %>조 
                        <%ELSE%>
                         [<%=tTeamGbNM%>-<%=tLevelNM%>-<%=tLevelJooNameNM%><%=tLevelJooNum%>]&nbsp;<%=tPlayLevelTypeNM %> 
                       <% End IF %>
                        
                        </td>
                      </tr>
                  <%
                    LRs.MoveNext
                  Loop
                End If
                LRs.close
              %>
             
              </tbody>
            </table>
          </div>

           <div style="width: 33%;display: inline-block;">
            <table class="table-list">
              <thead>
                <tr>
                  <th>종별 세부순서</th>
                </tr>
              </thead>
              <colgroup>
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
                <col width="100px">
                <col width="80px">
                <col width="80px">
                <col width="80px">
              </colgroup>
              <tbody>
              
             
              </tbody>
            </table>
          </div>


          <div>
             <table class="table-list">
              <thead>
                <tr>
                  <th>진행순서 리스트</th>
                </tr>
              </thead>
              <colgroup>
                <col width="80px">
                <col width="80px">
              </colgroup>
              <tbody>
             
              </tbody>
            </table>

          </div>
        </div>
      </div>
  </body>
</html>