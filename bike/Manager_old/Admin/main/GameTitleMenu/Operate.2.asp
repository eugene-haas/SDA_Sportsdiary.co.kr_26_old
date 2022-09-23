<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script type="text/javascript" src="../../js/GameTitleMenu/Operate.js"></script>

<% 'Storage 변수 영역 
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>

<% 'Reuqest 데이터 영역
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(Request("tGameTitleIdx")))
  crypt_ReqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)

  reqGroupGameGb = fInject(crypt.DecryptStringENC(Request("tGroupGameGb")))
  crypt_reqGroupGameGb = crypt.EncryptStringENC(Request(reqGroupGameGb))
  
  reqTeamGb= fInject(crypt.DecryptStringENC(Request("tTeamGb")))
  '테스트 값
  'reqTeamGb =fInject(crypt.DecryptStringENC("2F9A5AB5A680D3EDDEE944350E247FCB"))
  crypt_reqTeamGb = crypt.EncryptStringENC(Request(reqTeamGb))

  reqPlayTypeSex= fInject(Request("tPlayTypeSex"))
  '테스트 값
  'reqPlayTypeSex = "E300F22B66DC861AB9DA1717B0C3A093|704C5971F9D17ABC8687A215715ABCE6"
  If InStr(reqPlayTypeSex,"|") > 1 Then
    arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
    reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
    reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
  End if

  reqLevel= fInject(Request("tLevel"))
  'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
  If InStr(reqLevel,"|") > 1 Then
    arr_reqLevel = Split(reqLevel,"|")
    reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
    reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
    reqLevelJooNum = arr_reqLevel(2)
  End if
%> 

<% 'Request 값이 없을 경우 기본값

  IF CDBL(Len(reqGroupGameGb)) = Cdbl(0) Then
    reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  End If

  IF CDBL(Len(reqTeamGb)) = Cdbl(0) Then
    reqTeamGb = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqTeamGb = ""
  End If

%>

<style>
  #left-navi{display:none;}
  #header{display:none;}
</style>

<script>
  var locationStr;

</script>

<% ' Request 값 확인 영역
  'Response.WrIte "reqGameTitleIdx : " & reqGameTitleIdx  & "<br/>"
  'Response.WrIte "reqGroupGameGb : " & reqGroupGameGb  & "<br/>"
  'Response.WrIte "reqPlayTypeSex : " & reqPlayTypeSex  & "<br/>"
  'Response.WrIte "reqSex  : " & reqSex   & "<br/>"
  'Response.WrIte "reqPlayType : " & reqPlayType   & "<br/>"
  'Response.WrIte "reqLevel : " & reqLevel & "<br/>"
  'Response.WrIte "reqLevelJooName : " & reqLevelJooName   & "<br/>"
  'Response.WrIte "reqLevelJooNum : " & reqLevelJooNum   & "<br/>"
%> 

<!-- S: content -->
<div class="Game_operation">
  <h2 class="t_title">경기운영관리</h2>
  <!-- s: 대회선택 -->
  <div class="competition_select">
    <select id="selGameTitleIdx" name="selGameTitleIdx" onchange="OnGameTitleChanged(this.value)">
      <option value="">::대회 선택::</option>
        <% 
            Dim GameTitleIdxCnt : GameTitleIdxCnt = 0
            LSQL = " SELECT GameTitleIDX, GameTitleName"
            LSQL = LSQL & " FROM tblGameTitle "
            LSQL = LSQL & " WHERE DelYN = 'N'" 
            Set LRs = Dbcon.Execute(LSQL)

            IF Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                  GameTitleIdxCnt = GameTitleIdxCnt  + 1
                  tGameTitleIdx = LRs("GameTitleIDX")
                  crypt_tGameTitleIdx = crypt.EncryptStringENC(tGameTitleIdx)
                  tGameTitleName = LRs("GameTitleName")
            
                  IF(Len(reqGameTitleIdx) = 0 ) Then
                    IF (GameTitleIdxCnt = 1) Then
                      reqGameTitleIdx = tGameTitleIdx
                      crypt_reqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
                    End IF
                  End IF

                  If CDBL(reqGameTitleIdx) = CDBL(tGameTitleIdx)Then 
                    %>
                      <option value="<%=crypt_tGameTitleIdx%>" selected> <%=tGameTitleName%></option>
                    <% Else %>
                      <option value="<%=crypt_tGameTitleIdx%>" > <%=tGameTitleName%></option>
                    <%
                  End IF
                LRs.MoveNext()
              Loop
            End If   
            LRs.Close         
        %>
    </select>
  </div>
  <%
  '대회 설정
  Call oJSONoutput.Set("tGameTitleIdx", crypt_reqGameTitleIdx )
  strjson = JSON.stringify(oJSONoutput)  
  'Response.Write  "strjson : " & strjson & "<br/>"
  %>
  <!-- e: 대회선택 -->
  <!-- s: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->
  <div class="tab">
    <ul>
      <li class="on">
        <a href='javascript:href_Move("Operate.asp")'>대진표</a>
      </li>
      <li>
        <a href='javascript:href_Move("GameOrder.asp")'>경기진행 순서</a>
      </li>
      <li>
        <a href='javascript:href_Move("GameResult.asp")'>경기진행 결과</a>
      </li>
      <li>
        <a href='javascript:href_Move("GameGift.asp")'>상품수령 관리</a>
      </li>
    </ul>
  </div>
  <!-- e: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->
  <!-- s: 연선 조 순위 결과 -->
  <div class="ranking_result" id="divGameLevelMenu">
    <%
      '예선 본선 값 설정
      LSQL = " SELECT PubCode, PubName  "
      LSQL = LSQL & " FROM  tblPubcode "
      LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
      LSQL = LSQL & " ORDER BY OrderBy "
      
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arryGroupGameGb = LRs.getrows()
      End If
    %>
    <label>
      <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 
            if(tGroupGameGbName = "개인전") Then
      %>
            <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>"  onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
            <span>개인전</span>
      <%
            END IF
          Next
        End If      
      %>
    </label>

    <label>
         <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 

            if(tGroupGameGbName = "단체전") Then
              %>
                <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>" onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
                <span>단체전</span>
              <%
            END IF
          Next
        End If      
      %>
    </label>

    <select id="selPlayTypeSex" name="selPlayTypeSex"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
      <%
          LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
          LSQL = LSQL & " FROM tblGameLevel"
          LSQL = LSQL & " WHERE DelYN = 'N'"
          LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
          LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
          LSQL = LSQL & " GROUP BY Sex, PlayType"
          
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              tSex = LRs("Sex")
              crypt_tSex = crypt.EncryptStringENC(tSex)
              tSexName= LRs("SexName")
              tPlayType = LRs("PlayType")
              crypt_tPlayType= crypt.EncryptStringENC(tPlayType)
              tPlayTypeName= LRs("PlayTypeName")

              IF (reqSex = tSex) and  (reqPlayType = tPlayType) Then %>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" selected><%=tSexName & tPlayTypeName%></option>
              <%Else%>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" ><%=tSexName & tPlayTypeName%></option>
              <%End IF
              LRs.MoveNext()
              Loop
            End If   
          LRs.Close        
          %>
    </select>

    <% 'Response.Write " LSQL : " & LSQL & "<BR/>"  %>
    <select id="selTeamGb" name="selTeamGb"  onChange='OnGameLevelChanged(<%=strjson%>)'>
        <option value="">::부서 선택::</option>
      <%
        LSQL = " SELECT a.TeamGb, KoreaBadminton.dbo.FN_NameSch(a.TeamGb,'TeamGb') AS TeamGbNm"
        LSQL = LSQL & " FROM tblGameLevel a"
        LSQL = LSQL & " inner Join tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN = 'N'"
        LSQL = LSQL & " WHERE a.DelYN = 'N'"
        LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
        LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
        LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
        LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
        LSQL = LSQL & " GROUP BY a.TeamGb, Sex"
        Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tTeamGb = LRs("TeamGb")
            crypt_tTeamGb = crypt.EncryptStringENC(tTeamGb)

            IF (reqTeamGb = tTeamGb) Then
            %>
            <option value="<%=crypt_tTeamGb%>" selected ><%=LRs("TeamGbNM")%></option>
            <% ELSE  %>
            <option value="<%=crypt_tTeamGb%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%></option>
            <% END IF
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        %>
        
    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
    <select  id="selLevel" name="selLevel"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
        <% 
            LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNm , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNameNm, LevelJooName,LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "' "
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "' "
            LSQL = LSQL & " AND Sex = '" & ReqSex & "' "
            LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "' "
            LSQL = LSQL & " AND TeamGb = '" & reqTeamGb & "' "
            LSQL = LSQL & " AND Level <> '' "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"
            
             Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                  tLevel = LRs("Level")
                  crypt_tLevel = crypt.EncryptStringENC(tLevel)
                  tLevelNM = LRs("LevelNm")

                  tLevelJooName = LRs("LevelJooName")
                  crypt_tLevelJooName = crypt.EncryptStringENC(tLevelJooName)

                  tLevelJooNameNm= LRs("LevelJooNameNm")

                  IF(tLevelJooNameNm = "미선택") Then
                    tLevelJooNameNm = ""
                  End IF

                  tLevelJooNum = LRs("LevelJooNum") 
                  IF (reqLevel = tLevel) AND (reqLevelJooName = tLevelJooName) And (reqLevelJooNum = tLevelJooNum) Then%>      
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>" selected> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%ELSE%>
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>"> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%
                  END IF
                    LRs.MoveNext()
                  Loop
                End If   
              LRs.Close %>
    </select>
    <a href="javascript:popupOpen('ranking_result_popup.asp');" class="red_btn">예선 조순위 결과 <i class="fas fa-angle-right"></i></a>
  </div>
  <!-- e: 연선 조 순위 결과 -->
  <!-- s: 검색 -->
  <div class="search_box">
    <select>
      <option>::경기장소 선택::</option>
    </select>
    <select>
      <option>코트 선택</option>
    </select>
    <input type="text" placeholder="이름을 검색하세요">
    <a href="#" class="gray_btn">검색</a>
  </div>
  <!-- e: 검색 -->
  <!-- s: 태아불 상단 버튼 -->
  <div class="top_btn_list">
    <a href="#">
      <i class="fas fa-print"></i>
      <span>경기진행 순서 출력</span>
    </a>
    <a href="#">
      <i class="fas fa-print"></i>
      <span>경기기록지 출력</span>
    </a>
  </div>
  <!-- e: 태아불 상단 버튼 -->
  <!-- s: 리스트 table -->
  <table cellspacing="0" cellpadding="0">
    <tr>
      <th>경기번호</th>
      <th>코트번호</th>
      <th>단체전 오더등록</th>
      <th>종목</th>
      <th>대진표</th>
      <th colspan="2">팀1</th>
      <th colspan="2">팀2</th>
      <th>승패결과</th>
      <th>그외판정</th>
      <th>승자서명</th>
    </tr>
    <tr>
      <td>
        <span>1</span>
      </td>
      <td>
        <span>1</span>
      </td>
      <td>
        <a href="#" class="blue_btn" data-toggle="modal" data-target=".group-order">출전선수 오더</a>
      </td>
      <td>
        <span>혼합복식 40D</span>
      </td>
      <td>
        <span>예선7조</span>
      </td>
      <td>
        <span>강원</span>
      </td>
      <td>
        <span>최보라</span> / 
        <span>이준희</span>
      </td>
      <td>
        <span>부산</span>
      </td>
      <td>
        <span>홍원표</span>/ 
        <span>김정연</span>
      </td>
      <td>
        <a href="#" class="red_btn" data-toggle="modal" data-target=".live-score">경기중</a>
      </td>
      <td>
        <a href="#" class="red_btn" data-toggle="modal" data-target=".etc-judge">경기중</a>
      </td>
      <td>
        <a href="#" class="red_btn" data-toggle="modal" data-target=".winner-sign">경기중</a>
      </td>
    </tr>
    <tr>
      <td>
        <span>2</span>
      </td>
      <td>
        <span>2</span>
      </td>
      <td>
        <a href="#" class="blue_btn" data-toggle="modal" data-target=".group-order">출전선수 오더</a>
      </td>
      <td>
        <span>혼합복식 40D</span>
      </td>
      <td>
        <span>예선7조</span>
      </td>
      <td>
        <span>강원</span>
      </td>
      <td>
        <span>최보라</span> / 
        <span>이준희</span>
      </td>
      <td>
        <span>부산</span>
      </td>
      <td>
        <span>홍원표</span>/ 
        <span>김정연</span>
      </td>
      <td>
        <a href="#" class="gray_btn">선택</a>
      </td>
      <td>
        <a href="#" class="gray_btn">선택</a>
      </td>
      <td>
        <a href="#" class="gray_btn">선택</a>
      </td>
    </tr>
  </table>
  <!-- e: 리스트 table -->
  <script>
    function popupOpen(addrs, w, h){
      if (w === undefined)
        w = 1280;
      if (h === undefined)
        h = 747;
      var popWidth = w; // 팝업창 넓이
      var popHeight = h; // 팝업창 높이
      var winWidth = document.body.clientWidth; // 현재창 넓이
      var winHeight = document.body.clientHeight; // 현재창 높이
      var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
      var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
      var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
      var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데


      var popUrl = addrs; //팝업창에 출력될 페이지 URL
      var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
      window.open(popUrl,"",popOption);
    }
  </script>
</div>
<!-- E: content -->

<!-- S: group-order -->
<!-- #include file = "../../include/modal/group.order.asp" -->
<!-- E: group-order -->

<!-- S: live-score -->
<!-- #include file = "../../include/modal/live.score.asp" -->
<!-- E: live-score -->

<!-- S: etc-judge -->
<!-- #include file = "../../include/modal/etc.judge.asp" -->
<!-- E: etc-judge -->

<!-- S: winner-sign -->
<!-- #include file = "../../include/modal/winner.sign.asp" -->
<!-- E: winner-sign -->

<!--#include file="../../include/footer.asp"-->

<script>
  //$(".group-order").modal();
</script>

<%
  DBClose()
%>