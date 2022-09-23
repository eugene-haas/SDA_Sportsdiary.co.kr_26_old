

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  LSQL = "SELECT GameLevelDtlidx "
  LSQL = LSQL & " FROM  tblTourney"
  LSQL = LSQL & " WHERE GameLevelIdx is null"
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br>"
  Set LRs = DBCon.Execute(LSQL)

  IF NOT (LRs.Eof Or LRs.Bof) Then
    TourneyArray = LRs.getrows()
  End If

  If IsArray(TourneyArray) Then
      For ar = LBound(TourneyArray, 2) To UBound(TourneyArray, 2) 
        '1. Tourney에서 LevelDtlIdx를 가져옴.
        GameLevelDtlidx= TourneyArray(0, ar) 
        'Response.Write " GameLevelIdx : " & GameLevelIdx
        LSQL = "SELECT Top 1 GameLevelidx "
        LSQL = LSQL & " FROM  tblGameLevelDtl"
        LSQL = LSQL & " WHERE GameLevelDtlidx = '" & GameLevelDtlidx & "'"
        'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL2  & "<br>"
        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          LevelDtlArray = LRs.getrows()
        End If

        
        If IsArray(LevelDtlArray) Then
          For ar2 = LBound(LevelDtlArray, 2) To UBound(LevelDtlArray, 2) 
            GameLevelidx = LevelDtlArray(0, ar2) 
            
            LSQL = "UPDATE tblTourney "
            LSQL = LSQL & " Set  GameLevelidx = '" & GameLevelidx & "'"
            LSQL = LSQL & " WHERE GameLevelDtlidx = '" & GameLevelDtlidx &"'"
            
            'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br>"
            Set LRs2 = DBCon.Execute(LSQL)

          Next
        End If	
      Next
  End If	     

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  
<%
  DBClose()
%>


