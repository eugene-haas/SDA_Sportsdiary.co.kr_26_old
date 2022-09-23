<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>


<% 'Storage 변수 영역 
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>

<% 'Reuqest 데이터 영역
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(Request("tGameTitleIdx")))
  DEC_GameTitleIDX = reqGameTitleIdx
  crypt_ReqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
  'Response.Write "DEC_GameTitleIDX" & DEC_GameTitleIDX & "<br/>"
 
%> 

<script type="text/javascript" src="../../js/GameNumber/autoGameSchedule.js"></script>
<script>
  var locationStr;
</script>
<style>
	#left-navi{display:none;}
	#header{display:none;}
</style>
<!-- S: content -->

<%
  Admin_Authority = crypt.DecryptStringENC(Request.Cookies(global_HP)("Authority"))
  Admin_UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))
%>

<%
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



<button type="button" onClick="javascript:OnGameTitleSearch();">검색</button>
<button type="button" onClick="javascript:printLevelGame();">참가종별경기 출력</button>
<input type="text" class="date_ipt" id="initDatePicker" name="initDatePicker">
<button onClick="javascript:SearchGameLevelDtl();">종별 리스트 확인</button>
<button onClick="javascript:OnGameLevelAllSearch();">종별 전체 확인</button>
<button onClick="javascript:SearchGameScheduleStadium();">장소 확인</button>



<div id="divGameLevelList" name="divGameLevelList"> 

    <div> 
    <span>구분</span>
    <%
      LSQL = " SELECT GroupGameGb, ISNULL(GroupGameGbNM,'') AS GroupGameGbNM  "
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT C.GroupGameGb,dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON C.GameLevelidx = B.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT C.GroupGameGb,dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON C.GameLevelidx = B.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " WHERE AA.GroupGameGb <> ''"
      LSQL = LSQL & " GROUP BY AA.GroupGameGb,AA.GroupGameGbNM"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tGroupGameGbNM =LRs("GroupGameGbNM")
        tGroupGameGb =LRs("GroupGameGb")

        IF tGroupGameGbNM ="" Then
          tGroupGameGbNM ="Null"
        End IF

        %>
          <input type="radio" id="radioGroupGameGb<%=tGroupGameGb%>" name="radioGroupGameGb" value="<%=tGroupGameGb%>"/>
          <label for="radioGroupGameGb<%=tGroupGameGb%>"><%=tGroupGameGbNM%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
    </div>
  <br/>

    <div> 
    <span>종목</span>
    <%
      LSQL = " SELECT TeamGb, ISNULL(TeamGbNm,'') AS TeamGbNm "
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT A.TeamGb, C.TeamGbNm"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " Left Join KoreaBadminton.dbo.tblTeamGbInfo C ON A.TeamGb = C.TeamGb AND C.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT A.TeamGb, C.TeamGbNm"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " Left Join KoreaBadminton.dbo.tblTeamGbInfo C ON A.TeamGb = C.TeamGb AND C.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " WHERE AA.TeamGb <> ''"
      LSQL = LSQL & "    GROUP BY AA.TeamGb,AA.TeamGbNm"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tTeamGbNm =LRs("TeamGbNm")
        tTeamGb =LRs("TeamGb")

        IF tTeamGbNm ="" Then
          tTeamGbNm ="Null"
        End IF

        %>
          <input type="radio" id="radioTeamGB<%=tTeamGb%>" name="radioTeamGB" value="<%=tTeamGb%>"/>
          <label for="radioTeamGB<%=tTeamGb%>"><%=tTeamGbNm%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>
  <br/>
  <div>
    <span>급수</span>
    <%
      LSQL = "  SELECT LevelJooName, ISNULL(LevelJooNameNM,'') AS LevelJooNameNM, OrderBy"
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT C.LevelJooName,D.PubName AS LevelJooNameNM, D.OrderBy"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " Left Join tblPubcode D ON C.LevelJooName = D.PubCode AND D.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT C.LevelJooName,D.PubName AS LevelJooNameNM, D.OrderBy"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " Left Join tblPubcode D ON C.LevelJooName = D.PubCode AND D.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY AA.LevelJooName, AA.LevelJooNameNM, AA.OrderBy"
      LSQL = LSQL & " Order by OrderBy "
      
      'Response.Write "LSQL" & LSQL & "<BR/>"
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tLevelJooNameNM=LRs("LevelJooNameNM")
        tLevelJooName=LRs("LevelJooName")

        IF tLevelJooNameNM ="" Then
          tLevelJooNameNM = "미선택"
        End if
        %>
        <input type="radio" id="radioLevelJooName<%=tLevelJooName%>" name="radioLevelJooName" value="<%=tLevelJooName%>"/>
          <label for="radioLevelJooName<%=tLevelJooName%>"><%=tLevelJooNameNM%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>
  <br/>
  <div>
    <span>종별</span>
    <%
      LSQL = "   SELECT Level, ISNULL(LevelNm,'') AS LevelNm "
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT  C.Level ,D.LevelNm "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " Left Join tblLevelInfo D ON C.Level = D.Level AND D.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT  C.Level ,D.LevelNm"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " Left Join tblLevelInfo D ON C.Level = D.Level AND D.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY  AA.Level ,AA.LevelNm"
      'LSQL = LSQL & " Order BY  AA.Level ,AA.LevelNm"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      'Response.End
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tLevelNm=LRs("LevelNm")
        tLevel=LRs("Level")
        IF tLevelNm ="" Then
          tLevelNm = "미선택"
        End if
        %>
          <input type="radio" id="radioLevel<%=tLevel%>" name="radioLevel" value="<%=tLevel%>"/>
          <label for="radioLevel<%=tLevel%>"><%=tLevelNm%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>
  <br/>
  <div>
    <span>경기구분</span>
    <%
      LSQL = " SELECT PlayLevelType, ISNULL(PlayLevelTypeNM,'') AS PlayLevelTypeNM "
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT B.PlayLevelType, C.PubName AS PlayLevelTypeNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " Left Join tblPubcode C ON B.PlayLevelType = C.PubCode AND C.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT B.PlayLevelType, C.PubName AS PlayLevelTypeNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
      LSQL = LSQL & " Left Join tblPubcode C ON B.PlayLevelType = C.PubCode AND C.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY  AA.PlayLevelType ,AA.PlayLevelTypeNM"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tPlayLevelTypeNM=LRs("PlayLevelTypeNM")
        tPlayLevelType=LRs("PlayLevelType")
        IF tPlayLevelTypeNM ="" Then
          tPlayLevelTypeNM = "미선택"
        End if
        %>
           <input type="radio" id="radioPlayLevelType<%=tPlayLevelType%>" name="radioPlayLevelType" value="<%=tPlayLevelType%>"/>
          <label for="radioPlayLevelType<%=tPlayLevelType%>"><%=tPlayLevelTypeNM%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>

  
  <div id="divStadium" name="divStadium">
  <span>장소 리스트</span>
  <%

      LSQL = " SELECT StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt ,StadiumTime ,StadiumAddr ,StadiumAddrDtl "
      LSQL = LSQL & " FROM tblStadium A "
      LSQL = LSQL & " Where A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        r_StadiumIDX = LRs("StadiumIDX")
        crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
        r_StadiumName = LRs("StadiumName")
        r_StadiumCourt = LRs("StadiumCourt")
        %>

        <button onClick="javascript:SetGameScheduleStadium('<%=crypt_StadiumIDX%>');"><%=r_StadiumName%></button>
        <%
          LRs.MoveNext
        Loop
      End If            

      LRs.Close    
  %>
  </div>
</div>

<br/>
<div id="divGameTourneyInfo" name="divGameTourneyInfo">
 <span>총 경기 : </span>
</div>

<br/>
<span>선택된 종별 리스트 </span>
<br/>



<div id="divGameLevelDtlList" name="divGameLevelDtlList"></div>

<div id="divGameScheduleStadium" name="divGameScheduleStadium">
  <table cellspacing="0" cellpadding="0">
    <thead>
      <tr>
        <th>경기장</th>
        <th>상세설명</th>
      </tr>
    </thead>
    <tbody>
    </tbody>
  </table>
</div>


<!--#include file="../../include/footer.asp"-->
<%
  DBClose()
%>