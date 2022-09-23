<!--#include file="../../dev/dist/config.asp"-->


<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<% 'Storage 변수 영역 
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>

<% 'Reuqest 데이터 영역
  reqGameTitleIdx = 696
  crypt_ReqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
  LSQL = "SELECT GameTitleName"
  LSQL = LSQL & " FROM tblGameTitle "
  LSQL = LSQL & " where GameTitleIDX = '" & reqGameTitleIdx & "'"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRs("GameTitleName")
      LRs.MoveNext
    Loop
  End If
  Response.Write "tGameTitleName" & tGameTitleName & "<br/>"

  
  LSQL = " select a.TourneyIDX, b.StadiumNum "
  LSQL = LSQL & " FROM  tblTourney a "
  LSQL = LSQL & " inner Join tblGameLevel b on a.GameLevelIdx = b.GameLevelidx "
  LSQL = LSQL & " where a.GameTitleIDX = '" & reqGameTitleIdx & "'"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arryTourney = LRs.getrows()
  End If

  If IsArray(arryTourney) Then
    For ar = LBound(arryTourney, 2) To UBound(arryTourney, 2) 
      TourneyIDX    = arryTourney(0, ar) 
      StadiumNum  = arryTourney(1, ar) 

      Response.Write "TourneyIDX" & TourneyIDX & "<br/>"
      Response.Write "StadiumNum" & StadiumNum & "<br/>"
      LSQL = "UPDATE tblTourney"
      LSQL = LSQL & " SET StadiumIDX ='"& StadiumNum & "'"
      LSQL = LSQL & " where TourneyIDX = '" & TourneyIDX & "'"
      Response.Write "LSQL : " & LSQL & "<br/>"
      Set LRs = DBCon.Execute(LSQL)
    Next
  End If      


  Response.Write "<br/><br/><br/><br/><br/>"
  
  LSQL = " select a.TourneyTeamIDX,b.StadiumNum "
  LSQL = LSQL & " FROM  tblTourneyTeam a "
  LSQL = LSQL & " inner Join tblGameLevel b on a.GameLevelIdx = b.GameLevelidx "
  LSQL = LSQL & " where a.GameTitleIDX = '" & reqGameTitleIdx & "'"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arryTourneyTeam = LRs.getrows()
  End If

  If IsArray(arryTourneyTeam) Then
    For ar = LBound(arryTourneyTeam, 2) To UBound(arryTourneyTeam, 2) 
      TourneyTeamIDX    = arryTourneyTeam(0, ar) 
      StadiumNum  = arryTourneyTeam(1, ar) 

      LSQL = "UPDATE tblTourneyTeam"
      LSQL = LSQL & " SET StadiumIDX ='"& StadiumNum & "'"
      LSQL = LSQL & " where TourneyTeamIDX = '" & TourneyTeamIDX & "'"
      Response.Write "LSQL : " & LSQL & "<br/>"
     Set LRs = DBCon.Execute(LSQL)
    Next
  End If      


%>

<%
  DBClose()
%>