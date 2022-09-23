
<!-- #include file="../../dev/dist/config.asp"-->
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
<%
  Const DefaultMinute = 15
  Const DefaultHour = 60
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  Const const_Empty = "empty"

  REQ = Request("Req")
  'REQ = "{""CMD"":5,""tGameTitleIDX"":""A0B63180CC3215B403232E31C8E393B4"",""tStadiumIDX"":"""",""tGameDay"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = 0
      DEC_GameTitleIDX = 0
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if 

  If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = const_Empty
      DEC_GameDay= const_Empty
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
    End If
  End if 

    If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = 0
      DEC_StadiumIDX= 0
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))
    End If
  End if 
   

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  %>

  <ul>
    <%
      LSQL = " SELECT StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt ,StadiumTime ,StadiumAddr ,StadiumAddrDtl "
      LSQL = LSQL & " FROM tblStadium A "
      LSQL = LSQL & " Where A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      'Response.Write "LSQL : " & LSQL& "<BR/>"
      Set LRs = Dbcon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arrySadium= LRs.getrows()
      End If
        
    
      If IsArray(arrySadium) Then
        For ar = LBound(arrySadium, 2) To UBound(arrySadium, 2) 
          TotalTime = "0"
          r_StadiumIDX = arrySadium(0, ar) 
          crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
          r_StadiumName = arrySadium(2, ar) 
          r_StadiumCourt = arrySadium(3, ar) 
          
     
        %>
          <li
          <%IF CDBL(DEC_StadiumIDX) = CDBL(r_StadiumIDX) Then%> class="on" <%End IF%> onclick="javascript:SelectGameStadium('<%=crypt_StadiumIDX%>','<%=r_StadiumName%>');">
            <div class="l-con">
              <span class="name"><%=r_StadiumName%></span>
              <span class="coat"><%=r_StadiumCourt%>코트</span>
            </div>

            <div class="r-con">
              <span class="playe-number">
                총 <span class="red-font">
                <%
                  LSQL = " EXEC tblGameSchedule_Stadium_STR '" & DEC_GameTitleIDX & "','" & r_StadiumIDX & "', '" & DEC_GameDay & "'"
                  'Response.Write "LSQL" & LSQL &"<BR/>"
                  Set LRs = Dbcon.Execute(LSQL)
                  If Not (LRs.Eof Or LRs.Bof) Then
                    Do Until LRs.Eof
                      r_StadiumIDX2 =  LRs("StadiumIDX") 
                      r_TotalTourney2 =  LRs("TotalTourney")
                      r_TourneyCnt2 =  LRs("TourneyCnt")
                      r_TourneyTeamCnt2 =  LRs("TourneyTeamCnt")
                      TotalTime = DefaultMinute * r_TourneyCnt2 
                    LRs.MoveNext
                    Loop
                  ELSE
                    r_TotalTourney2 = 0
                  End If
                %>
                <%=r_TotalTourney2%> 경기</span>
              </span>
              <span class="date">
                <i class="fas fa-clock"></i>
                
                <span class="date-number">

                <%
                  GameHour = cdbl(TotalTime) \ cdbl(DefaultHour)
                  GameMinute = cdbl(TotalTime) mod cdbl(DefaultHour)

                  IF cdbl(GameHour) > 0 Then
                    Response.Write GameHour & "시 "
                  ELSE
                    Response.Write GameHour & "시 "
                  END IF

                  IF cdbl(GameMinute) > 0 Then
                    Response.Write GameMinute & "분"
                  ELSE
                    Response.Write GameMinute & "분"
                  END IF
                %>
                </span>
              </span>
              <i class="fas fa-chevron-circle-right"></i>
            </div>

          </li>
        <%
          Next

      Else
      %>
      
				<li >
					<div class="l-con">
						<span class="name">경기장이 존재하지 않습니다.</span>
					</div>
				</li>

      <%
      End If            
      LRs.Close    
    %>
    </ul>
<%
  'Response.Write "LSQL" & LSQL & "<BR/>"
  DBClose()
%>
