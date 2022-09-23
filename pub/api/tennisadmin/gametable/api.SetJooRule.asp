<%
  RGameLevelIDX = oJSONoutput.IDX 
  GameTitleIDX =  oJSONoutput.GAMETITLEIDX
  ChkRull =  oJSONoutput.CHKRULL

  'Response.Write "RGameLevelIDX : " & RGameLevelIDX & "</br>"
  'Response.Write "GameTitleIDX : " & GameTitleIDX & "</br>"
  'Response.Write "ChkRull : " & ChkRull & "</br>"

  IF ChkRull = 1 Then
    ChkRull = "Y"
  ELSE 
    ChkRull = "N"
  END IF

	Set db = new clsDBHelper
  SQL = " Update tblRGameLevel"
  SQL = SQL & " Set chkJooRull = '" & ChkRull & "'"
  SQL = SQL & " Where RGameLevelidx = " & RGameLevelIDX
  'Response.write "SQL : " & SQL & "</br>"
  Call db.execSQLRs(SQL , null, ConStr)
  db.Dispose
  Set db = Nothing
  
  'Response.End
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
%>