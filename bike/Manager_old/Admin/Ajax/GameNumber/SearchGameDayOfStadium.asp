
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
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  REQ = Request("Req")
  'REQ = "{""CMD"":5,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tStadiumIDX"":""75E0A26C83058B63F8E491C30A30C149""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if  

  If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))
    End If
  End if  

  
 

  If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
    End If
  End if  



  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 30  ' 한화면에 출력할 갯수
  BlockPage = 5      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0
  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

   If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>  

<select id="selStadiumIDX" name="selStadiumIDX" onchange="OnStadiumChanged();">
  <option value="">::경기장소 선택::</option>
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

      
      if DEC_StadiumIDX <> "" Then
      %>
      <option value="<%=crypt_StadiumIDX%>" <%If cdbl(DEC_StadiumIDX) = cdbl(r_StadiumIDX) Then%> selected <%End If%> ><%=r_StadiumName%> ( 코트 : <%=r_StadiumCourt%>)</option>
      <% Else %>
      <option value="<%=crypt_StadiumIDX%>" ><%=r_StadiumName%> ( 코트 : <%=r_StadiumCourt%>)</option>
      <% End IF %>
      <%
        LRs.MoveNext
      Loop
    End If            

    LRs.Close    
  %>
</select>
      
<select id="selGameDay" name="selGameDay" onchange="OnStadiumChanged();">
  <option value="" <%If GameDay = "" Then%>selected<%End If%>>::경기일자 선택::</option>
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
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    IF DEC_StadiumIDX <> "" Then
      LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
    End IF
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
    IF DEC_StadiumIDX <> "" Then
      LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
    End IF
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    LSQL = LSQL & " AND A.GameDay IS NOT NULL"
    LSQL = LSQL & " ) AS AA"
    LSQL = LSQL & " WHERE AA.GameDay <> ''"
    LSQL = LSQL & " GROUP BY AA.GameDay"
    'Response.Write "LSQL" & LSQL & "<BR/>"
    Set LRs = Dbcon.Execute(LSQL)

  
      If Not (LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof
      %>
          <option value="<%=LRs("GameDay") %>" <%If GameDay = LRs("GameDay") Then%>selected<%End If%>><%=LRs("GameDay") %></option>
      <%
          LRs.MoveNext
        Loop

      End If
   
    LRs.Close
  %>
</select>

<%
  DBClose()
%>