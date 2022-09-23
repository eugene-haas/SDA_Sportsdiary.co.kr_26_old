
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
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tGameLevelName"":""""}"
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



  If hasown(oJSONoutput, "tGameLevelName") = "ok" then
    If ISNull(oJSONoutput.tGameLevelName) Or oJSONoutput.tGameLevelName = "" Then
      GameLevelName = ""
      DEC_GameLevelName = ""
    Else
      GameLevelName = fInject(oJSONoutput.tGameLevelName)
      DEC_GameLevelName = fInject(oJSONoutput.tGameLevelName)
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

  <!-- S: top-search -->
  <div class="top-search">
    <input type="text" id="txtGameLevelName" name="txtGameLevelName" placeholder="종별을 검색해주세요." >
    <a  href="javascript:OnGameLevelSearch();" >조회</a>
  </div>
  <!-- E: top-search -->
  <table cellspacing="0" cellpadding="0" id="tableGameNumberLevel">
    <tr>
      <th>종별</th>
      <th>미지정</th>
    </tr>
    <tbody>
    <%
      LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & DEC_GameTitleIDX& "','" & DEC_GameLevelName & "'"
      'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            LCnt = LCnt + 1
            tGameNumber = LRs("GameNumber")
            tGameTitleIdx = LRs("GameTitleIdx")
            tGameLevelidx = LRs("GameLevelidx")
            crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelidx)
            IF CDBL(LCnt) = 1 Then
              selCrypt_tGameLevelIdx = crypt_tGameLevelIdx
            END IF
            tGameLevelidxs = tGameLevelidxs & tGameLevelidx & "_"
            tLevelNM= LRs("LevelNM")
            tSex= LRs("Sex")
            tSexNM = LRs("SexNM") 
            tTeamGroupCnt = LRs("TeamGroupCnt")
            tParticipateCnt= LRs("ParticipateCnt") 
            tEnterType= LRs("EnterType")
            tTeamGb = LRs("TeamGb")
            tTeamGbNM= LRs("TeamGbNM")
            tGroupGameGb = LRs("GroupGameGb")
            tGroupGameGbNm = LRs("GroupGameGbNm")
            tPlayType = LRs("PlayType")
            tPlayTypeNm = LRs("PlayTypeNm")
            tLevelJooNameNM= LRs("LevelJooNameNM")
            tLevelJooNum= LRs("LevelJooNum")
            tLevelJooName = LRs("LevelJooName")
            tLevel = LRs("Level")
            tLevelNm = LRs("LevelNm")
            tTeamTouneyCount= LRs("TeamTouneyCount")
            tTouneyCount= LRs("TouneyCount")
            %>
            <tr id="<%=crypt_tGameLevelidx%>">
              <td>
                <% Response.Write tTeamGbNM & "-" & tSexNM & tPlayTypeNm  & " " & tLevelNM  & " " & tLevelJooNameNM & " " & tLevelJooNum %>
              </td>
              <td>
                <% IF tGroupGameGb = GroupGame Then%>
                  <%Response.Write tTeamTouneyCount%>
                <%Else%>
                  <%Response.Write tTouneyCount%>
                <%End IF%>
                <input type="hidden" name="hiddenGameLevelIdx<%=LCnt%>" id="hiddenGameLevelIdx<%=LCnt%>" value="<%=crypt_tGameLevelidx%>">
                <input type="hidden" name="hiddenNumber" id="hiddenNumber" value="<%=LCnt%>">
              </td>
            </tr>
            <%
            LRs.MoveNext
          Loop
      END IF
    %>

    <% IF CDBL(LCnt) = 0 Then%>
      <td colspan=3>	
        조회 결과가 존재 하지 않습니다.
      </td>
    <%END IF%>
    </tbody>
  </table>

<%
  DBClose()
%>
  
<input type="hidden" id="selGameLevel" name="selGameLevel" value="<%=selCrypt_tGameLevelIdx%>">