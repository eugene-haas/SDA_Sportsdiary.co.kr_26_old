<!-- #include file="../../dev/dist/config.asp"-->
<% 
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
	Const PersonGame = "B0030001"
	Const GroupGame = "B0030002"

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ko">
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="author" content="administrator1" />
    <meta name="company" content="Microsoft Corporation" />
  <title>스코어지</title>

  </head>

  <body>
<%

	Dim GameTitleIDX	: GameTitleIDX 		= fInject(Request("GameTitleIDX"))
	Dim DEC_GameTitleIDX	: DEC_GameTitleIDX 		= crypt.DecryptStringENC(GameTitleIDX)

  LSQL = "SELECT GameTitleName"
  LSQL = LSQL & " FROM  tblGameTitle"
  LSQL = LSQL & " WHERE GameTitleIDX = " &  DEC_GameTitleIDX
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      tGameTitleName = LRs("GameTitleName")
      LRs.MoveNext
      Loop
  End If
  LRs.close

	DEC_TempNum = ""
	DEC_Searchkeyword =""
	DEC_Searchkey = ""
	DEC_GroupGameGb = ""
	LSQL = " EXEC tblGameSchedule_Level_STR '" & DEC_GameTitleIDX & "', '" & DEC_Searchkeyword & "'"
	'Response.WRite lsql
	Set LRs = Dbcon.Execute(LSQL)

	If Not(LRs.Eof Or LRs.Bof) Then 
%>
    <span style="vertical-align: middle;text-align: center; font-size: 20pt;"><%=tGameTitleName%></span>
    <table border="1">
    <tr>
        <td>번호</td>
        <td>종별</td>
        <td>경기수</td>
    </tr>
        
<% 
        Do Until LRs.Eof
         LCnt = LCnt + 1
          tTouneyCount = LRs("TouneyCount")
          tTeamTouneyCount = LRs("TeamTouneyCount")
          tGroupGameGb = LRs("GroupGameGb") 
          tTeamGbNM= LRs("TeamGbNM")
          tSexNM = LRs("SexNM") 
          tPlayTypeNm = LRs("PlayTypeNm")
          tLevelNm = LRs("LevelNm")
          tLevelJooNameNM= LRs("LevelJooNameNM")
          tLevelJooNum= LRs("LevelJooNum")
          


%>      
        <tr>
            <td><%=LCnt%></td>
            <td><% Response.Write tTeamGbNM & "-" & tSexNM & tPlayTypeNm  & " " & tLevelNM  & " " & tLevelJooNameNM & " " & tLevelJooNum %></td>
            <td>
            <%
              IF tGroupGameGb = PersonGame Then
                Response.Write tTouneyCount
              ELSEIF tGroupGameGb = GroupGame Then
                Response.Write tTeamTouneyCount
              End if
            %>
            </td>
  
        </tr>
<%
            LRs.MoveNext
          Loop
%>

    </table>
	</body>
</html>
<%
    End If

    'Response.Write "CSQL" & CSQL & "<BR/><BR/><BR/><BR/>"
    'Response.Write "DEC_PlayLevelType" & DEC_PlayLevelType & "<BR/><BR/><BR/><BR/>"

    Response.Buffer = True
    Response.Buffer = True
    Response.ContentType = "application/vnd.ms-excel"
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-disposition","attachment;filename=" & DEC_GameDay & "경기진행순서.xls"
    Response.AddHeader "Content-disposition","attachment;filename=" & DEC_GameDay & "경기진행순서.xls"
%>

