<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script type="text/javascript" src="../../js/GameTitleMenu/GameGift.js"></script>

<% 'Storage 변수 영역 
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>

<% 'Reuqest 데이터 영역
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(Request("tGameTitleIdx")))
  crypt_reqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
  reqGroupGameGb = fInject(crypt.DecryptStringENC(Request("tGroupGameGb")))
  crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  reqTeamGb= fInject(crypt.DecryptStringENC(Request("tTeamGb")))
  crypt_reqTeamGb = crypt.EncryptStringENC(reqTeamGb)
  reqPlayTypeSex= fInject(Request("tPlayTypeSex"))
  reqLevel= fInject(Request("tLevel"))

  '새로 추가된 Param
  reqGameDay = fInject(Request("GameDay")) '사용
  reqStadiumIDX = fInject(crypt.DecryptStringENC(Request("StadiumIDX"))) '사용
  crypt_reqStadiumIDX = crypt.EncryptStringENC(reqStadiumIDX)
  reqStadiumNumber = fInject(Request("StadiumNumber")) '사용
  reqSearchName = fInject(Request("SearchName")) '사용
  reqPlayLevelType = fInject(Request("PlayLevelType")) '미사용
%>

<script>
  href_Move = function(hrefMove){
    var ParmmStorage = {};
    ParmmStorage.tGameTtitleIdx = $("#selGameTitleIdx").val();
    ParmmStorage.tGroupGameGb = "<%=crypt_reqGroupGameGb%>";
    ParmmStorage.tTeamGb = "<%=crypt_reqTeamGb%>";
    ParmmStorage.tPlayTypeSex = "<%=reqPlayTypeSex%>";
    ParmmStorage.tLevel = "<%=reqLevel%>";
    ParmmStorage.tPlayLevelType= "<%=reqPlayLevelType%>";
    ParmmStorage.StadiumNumber = "<%=reqStadiumNumber%>"

    tGameTitleIdx = ParmmStorage.tGameTtitleIdx;
    GroupGameGbValue = ParmmStorage.tGroupGameGb;
    TeamGbValue = ParmmStorage.tTeamGb;
    PlayTypeSexValue = ParmmStorage.tPlayTypeSex;
    PlayLevelType =  ParmmStorage.tPlayLevelType;
    LevelValue = ParmmStorage.tLevel;

    GameDay = $("#selGameDay").val();
    StadiumIDX = $("#selStadiumIDX").val();
    StadiumNumber = ParmmStorage.StadiumNumber;
    SearchName = $("#txtSearchName").val();
    
     if (hrefMove == "Operate.asp") {
      post_to_url('./' + hrefMove, { 'GameTitle': tGameTitleIdx,'GroupGameGb': GroupGameGbValue,'TeamGb': TeamGbValue,'Level': LevelValue, 'PlayType': PlayTypeSexValue, 'GameDay' : GameDay, 'StadiumIDX' : StadiumIDX ,'StadiumNumber' : StadiumNumber, 'SearchName' : SearchName, 'PlayLevelType' : PlayLevelType}); 
    }
    else {
      post_to_url('./' + hrefMove, { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue, 'GameDay' : GameDay, 'StadiumIDX' : StadiumIDX ,'StadiumNumber' : StadiumNumber, 'SearchName' : SearchName, 'PlayLevelType' : PlayLevelType}); 
    }
  };
</script>

<%
'Request 값이 없을 경우 기본값
  '테스트 값
  'reqPlayTypeSex = "E300F22B66DC861AB9DA1717B0C3A093|704C5971F9D17ABC8687A215715ABCE6"
  If InStr(reqPlayTypeSex,"|") > 1 Then
    arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
    reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
    reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
  End if

  
  'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
  If InStr(reqLevel,"|") > 1 Then
    arr_reqLevel = Split(reqLevel,"|")
    reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
    reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
    reqLevelJooNum = arr_reqLevel(2)
  End if

  IF CDBL(Len(reqGroupGameGb)) = Cdbl(0) Then
    reqGroupGameGb = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = ""
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
<div class="GameGift">
  <h2 class="t_title">경기운영관리</h2>
  <!-- s: 대회선택 -->
  <div class="competition_select">
    <% 
      Admin_Authority = crypt.DecryptStringENC(Request.Cookies(global_HP)("Authority"))
      Admin_UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))

      IF (Admin_Authority <> "O") Then
        Dim tblGameTitleCnt :tblGameTitleCnt = 0
        LSQL = " SELECT GameTitleIDX, GameTitleName"
        LSQL = LSQL & " FROM tblGameTitle "
        LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & reqGameTitleIdx & "'" 
        Set LRs = Dbcon.Execute(LSQL)

        IF Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            tblGameTitleCnt = tblGameTitleCnt + 1
            tGameTitleName = LRs("GameTitleName")
            LRs.MoveNext()
          Loop
        End If   
        LRs.Close         

        IF cdbl(tblGameTitleCnt) = 0 Then
          LSQL = " SELECT Top 1 GameTitleIDX, GameTitleName"
          LSQL = LSQL & " FROM tblGameTitle "
          LSQL = LSQL & " WHERE DelYN = 'N' " 
          LSQL = LSQL & " Order By WriteDate desc " 

          Set LRs = Dbcon.Execute(LSQL)

          IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              crypt_reqGameTitleIdx =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
              tGameTitleName = LRs("GameTitleName")
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        End IF
    %>
    <input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
    <input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_reqGameTitleIdx%>">
    <% Else%>
     <select id="selGameTitleIdx" name="selGameTitleIdx"  onchange="OnGameTitleChanged(this.value)">
        <option value="">::대회 선택::</option>
          <% 
              Dim GameTitleIdxCnt : GameTitleIdxCnt = 0
              LSQL = " SELECT a.GameTitleIDX, a.GameTitleName"
              LSQL = LSQL & " FROM tblGameTitle a "
              LSQL = LSQL & " INNER JOIN tblAdminGameTitle d on d.AdminID = '" & Admin_UserID &"' And a.GameTitleIDX = d.GameTitleIDX " 
              LSQL = LSQL & " WHERE a.DelYN = 'N'" 
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
    <% End IF %>
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
      <li>
        <a href='javascript:href_Move("Operate.asp")'>대진표</a>
      </li>
      <li>
        <a href='javascript:href_Move("GameOrder.asp")'>경기진행 순서</a>
      </li>
      <li>
        <a href='javascript:href_Move("GameResult.asp")'>경기진행 결과</a>
      </li>
      <li class="on">
        <a href='javascript:href_Move("GameGift.asp")'>경기실적 관리</a>
      </li>
    </ul>
  </div>
  <!-- e: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->
  <!-- s: 연선 조 순위 결과 -->
  <!--
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
  </div>
  -->
  <!--<a href="javascript:popupOpen('ranking_result_popup.asp');" class="red_btn">예선 최종 순위 결과 <i class="fas fa-angle-right"></i></a>-->
  <!-- e: 연선 조 순위 결과 -->
  <!-- s: 검색 -->

  
  <div class="search_box" id="DP_SelBox" >

     <select id="selGameDay" onChange='OnSearchChanged()'>
       <option value="">::경기일자 선택::</option>
      <%
        LSQL = " SELECT GameDay"
        LSQL = LSQL & " FROM "
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT A.GameDay"
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
        LSQL = LSQL & " AND A.GameDay IS NOT NULL"
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT A.GameDay"
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
        LSQL = LSQL & " AND A.GameDay IS NOT NULL"
        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " GROUP BY AA.GameDay"     
        
        Set LRs = Dbcon.Execute(LSQL)
        IF Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof  
            IF reqGameDay = LRs("GameDay") Then
              selectedReqGameDay = "selected"
            Else
              selectedReqGameDay =""
            End IF
            Response.Write "<option value=" & LRs("GameDay") & " " &  selectedReqGameDay  &">" & LRs("GameDay") & "</option>"  
            LRs.MoveNext()
          Loop
        End If    
      %>
    </select>  

    <select id="selStadiumIDX" onChange='OnSearchChanged()'>
      <option value="">::경기장소 선택::</option>
      <%
        LSQL = " SELECT AA.StadiumIDX, AA.StadiumName"
        LSQL = LSQL & " FROM"
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
        LSQL = LSQL & " FROM tblTourney A"
        LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
        IF reqGameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
        END IF
        LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
        LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
        LSQL = LSQL & " FROM tblTourneyTeam A"
        LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
        IF reqGameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
        END IF
        LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
        LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
        LSQL = LSQL & " ) AA"
        LSQL = LSQL & " GROUP BY AA.StadiumIDX, AA.StadiumName"
      
        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            StadiumIDX = LRs("StadiumIDX")
            StadiumName = LRs("StadiumName")
            crypt_StadiumIDX = crypt.EncryptStringENC(StadiumIDX)

            IF reqStadiumIDX = StadiumIDX Then
              selectedStadiumIDX = "selected"
            Else
              selectedStadiumIDX =""
            End IF
          
        %>
            <option value="<%=crypt_StadiumIDX%>" <%=selectedStadiumIDX%>><%=StadiumName%></option>
        <%
            LRs.MoveNext
          Loop
        End If            
        LRs.Close    
      %>
    </select>
	<select id="selGroupGameGb" onChange='OnSearchChanged()'>
    <option value="">경기유형 선택</option>
      <%
      LSQL = "  SELECT GroupGameGb,GroupGameGbNM  "
      LSQL = LSQL & " FROM"
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT C.GroupGameGb, dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
      IF reqGameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
      END IF
      IF reqStadiumIDX <> "" Then
        LSQL = LSQL & " AND A.StadiumIDX = '" & reqStadiumIDX & "'"
      End IF
      IF reqStadiumNumber <> "" Then
      LSQL = LSQL & " AND A.StadiumNum = '" & reqStadiumNumber & "'"
      End IF
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT C.GroupGameGb, dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
      IF reqGameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
      END IF
      IF reqStadiumIDX <> "" Then
        LSQL = LSQL & " AND A.StadiumIDX = '" & reqStadiumIDX & "'"
      End IF
      IF reqStadiumNumber <> "" Then
        LSQL = LSQL & " AND A.StadiumNum = '" & reqStadiumNumber & "'"
      End IF
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY AA.GroupGameGb,AA.GroupGameGbNM"
      

      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
      %>
          <option value="<%=crypt.EncryptStringENC(LRs("GroupGameGb")) %>" 
          <%
          If reqGroupGameGb = LRs("GroupGameGb") Then
          %>
          selected
          <%End If%>>
          <%=LRs("GroupGameGbNM") %>
          </option>
      <%
          LRs.MoveNext
        Loop
      Else
      End If      
      LRs.Close        
      %>
    </select>
    
    <select id="selTotalClass" name="selTotalClass" onChange='OnSearchChanged()'>
      <option value="">종별 선택</option>
        <%
        LSQL = " SELECT Sex, SexNm, PlayType, PlayTypeNM, GameType, TeamGb, TeamGbNm,Level ,LevelNm, LevelJooNum,LevelJooName,LevelJooNameNM"
        LSQL = LSQL & " FROM"
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT SexNm = (case E.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ), "
        LSQL = LSQL & " E.Sex, E.PlayType, E.GameType, E.TeamGb,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.PlayType,'PubCode') AS PlayTypeNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.TeamGb,'TeamGb') AS TeamGbNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.Level,'Level') AS LevelNm, "
        LSQL = LSQL & " E.Level,"
        LSQL = LSQL & " E.LevelJooName,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.LevelJooName,'PubCode') AS LevelJooNameNM,"
        LSQL = LSQL & " E.LevelJooNum "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N'"
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"

        IF reqGameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
        END IF

        IF reqStadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & reqStadiumIDX & "'"
        End IF

        IF reqGroupGameGb <> "" Then
          LSQL = LSQL & " AND E.GroupGameGb = '" & reqGroupGameGb & "'"
        End IF

        IF reqStadiumNumber <> "" Then
        LSQL = LSQL & " AND A.StadiumNum = '" & reqStadiumNumber & "'"
        End IF

        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT SexNm = (case E.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ), "
        LSQL = LSQL & " E.Sex, E.PlayType, E.GameType, E.TeamGb,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.PlayType,'PubCode') AS PlayTypeNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.TeamGb,'TeamGb') AS TeamGbNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.Level,'Level') AS LevelNm, "
        LSQL = LSQL & " E.Level,"
        LSQL = LSQL & " E.LevelJooName,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.LevelJooName,'PubCode') AS LevelJooNameNM,"
        LSQL = LSQL & " E.LevelJooNum "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"

        IF reqGameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
        END IF

        IF reqStadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & reqStadiumIDX & "'"
        End IF

        IF reqGroupGameGb <> "" Then
          LSQL = LSQL & " AND E.GroupGameGb = '" & reqGroupGameGb & "'"
        End IF

        IF reqStadiumNumber <> "" Then
          LSQL = LSQL & " AND A.StadiumNum = '" & reqStadiumNumber & "'"
        End IF

        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " GROUP BY AA.Sex, AA.SexNm,AA.PlayType, AA.PlayTypeNM,AA.GameType, AA.TeamGb, AA.TeamGbNm, AA.LevelNm, AA.Level, AA.LevelJooNum,AA.LevelJooName,AA.LevelJooNameNm"
        

        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            o_SexNm = LRS("SexNm")
            o_Sex = LRS("Sex")
            o_PlayType = LRS("PlayType")
            o_PlayTypeNM= LRS("PlayTypeNM")
            o_GameType = LRS("GameType")
            o_TeamGb = LRS("TeamGb")
            o_TeamGbNm = LRS("TeamGbNm")
            o_LevelNm = LRS("LevelNm")
            o_Level = LRS("Level")
            o_LevelJooName = LRS("LevelJooName")
            o_LevelJooNameNM = LRS("LevelJooNameNM")
            o_LevelJooNum = LRS("LevelJooNum")
            o_ParamValue = reqSex & "|" & reqPlayType & "|" & reqTeamGb & "|" & reqLevel & "|" & reqLevelJooName & "|" & reqLevelJooNum
            o_Value = o_Sex & "|" & o_PlayType & "|" & o_TeamGb & "|" & o_Level & "|" & o_LevelJooName  & "|" & o_LevelJooNum 

  
        %>
            <option value="<%=o_Value%>" 
            <%
            If o_Value  = o_ParamValue Then
            %>
            selected
            <%End If%>>
            <%Response.Write o_SexNm & o_PlayTypeNM & o_TeamGbNm & " " & o_LevelNm  & " " & o_LevelJooNameNM & " " & o_LevelJooNum %>
            </option>
        <%
            LRs.MoveNext
          Loop
        Else
        End If      
        LRs.Close        
        %>

    </select>
    <%
      'Response.Write "o_ParamValue" & o_ParamValue & "<br/>"
      'Response.Write "o_Value" & o_Value & "<br/>"
    %>
  <select id="selPlayLevelType" onChange='OnSearchChanged()'>
      <option value="">경기구분 선택</option>
        <%
        LSQL = " SELECT PlayLevelType,PlayLevelTypeNM "
        LSQL = LSQL & " FROM"
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT  C.PlayLevelType, dbo.FN_NameSch(C.PlayLevelType, 'PubCode') AS PlayLevelTypeNM"
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N'"
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"

        IF reqGameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
        END IF

        IF reqStadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & reqStadiumIDX & "'"
        End IF

        IF reqGroupGameGb <> "" Then
          LSQL = LSQL & " AND E.GroupGameGb = '" & reqGroupGameGb & "'"
        End IF

        IF reqStadiumNumber <> "" Then
        LSQL = LSQL & " AND A.StadiumNum = '" & reqStadiumNumber & "'"
        End IF

        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT C.PlayLevelType, dbo.FN_NameSch(C.PlayLevelType, 'PubCode') AS PlayLevelTypeNM"
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"

        IF reqGameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
        END IF

        IF reqStadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & reqStadiumIDX & "'"
        End IF

        IF reqGroupGameGb <> "" Then
          LSQL = LSQL & " AND E.GroupGameGb = '" & reqGroupGameGb & "'"
        End IF

        IF reqStadiumNumber <> "" Then
          LSQL = LSQL & " AND A.StadiumNum = '" & reqStadiumNumber & "'"
        End IF

        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " GROUP BY AA.PlayLevelType,AA.PlayLevelTypeNM"
        

        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
        %>
            <option value="<%=LRs("PlayLevelType") %>" 
            <%
            If reqPlayLevelType = LRs("PlayLevelType") Then
            %>
            selected
            <%End If%>>
            <%=LRs("PlayLevelTypeNM") %>
            </option>
        <%
            LRs.MoveNext
          Loop
        Else
        End If      
        LRs.Close        
        %>
    </select>
    <%'Response.Write "LSQL" & LSQL%>
    
    <select>
      <option>::실적구분 선택::</option>
    </select>
    <input id="txtSearchName" type="text" placeholder="이름을 검색하세요" value="<%=reqSearchName%>">
    <a href="javascript:OnSearchClick();" class="gray_btn">검색</a>
  </div>
  <!-- e: 검색 -->
  <!-- s: 태아불 상단 버튼 -->
	<!--
  <div class="top_btn_list">
    <a href="#">
      <i class="fas fa-print"></i>
      <span>경기진행 순서 출력</span>
    </a>
    <a href="#">
      <i class="fas fa-print"></i>
      <span>경기기록지 출력</span>
    </a>
  </div>-->
  <!-- e: 태아불 상단 버튼 -->
  <!-- s: 리스트 table -->
	<div class="h-30"></div>
  <span id="spanSearchResult" name="spanSearchResult"></span>
  <table cellspacing="0" cellpadding="0">
    <tr>
      <th>종목</th>
      <th>실적</th>
      <th>팀명</th>
      <th>선수명</th>
      <th>선수명</th>
      <th>점수</th>
      <th>상품수령</th>
      <th>수령확인서명</th>
    </tr>
    <tbody id="tbGameGift" name="tbGameGift">
      <tr>
        <td colspan="8">조회 결과가 존재 하지 않습니다.</td>
      </tr>
    </tbody>
      <!--
        <tr>
          <td>
            <span>혼합복식 40D</span>
          </td>
          <td>
            <span>본선</span>
          </td>
          <td>
            <span>우승</span>
          </td>
          <td>
            <span>강원</span>
          </td>
          <td>
            <span>최보라</span> / 
            <span>이준희</span>
          </td>
          <td>
            <span>최보라</span>
          </td>
          <td>
            <a href="#" class="blue_btn" data-toggle="modal" data-target=".live-score">서명하기</a>
          </td>
          <td>
            <label class="switch">
              <input type="checkbox" class="switch-input" checked>
              <span class="switch-label" data-on="수령" data-off="미수령"></span>
              <span class="switch-handle"></span>
            </label>
          </td>
        </tr>
    <tr>
      <td>
        <span>혼합복식 40D</span>
      </td>
      <td>
        <span>본선</span>
      </td>
			<td>
        <span>우승</span>
      </td>
			<td>
        <span>강원</span>
      </td>
      <td>
        <span>최보라</span> / 
        <span>이준희</span>
      </td>
      <td>
        <span>최보라</span>
      </td>
      <td>
        <a href="#" class="gray_btn" data-toggle="modal" data-target=".group-order">서명하기</a>
      </td>
			<td>
        <label class="switch">
					<input type="checkbox" class="switch-input" checked>
					<span class="switch-label" data-on="수령" data-off="미수령"></span>
					<span class="switch-handle"></span>
				</label>
      </td>
    </tr>
    -->
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