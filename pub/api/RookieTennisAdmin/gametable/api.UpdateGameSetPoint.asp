<%
  
  resultIDX = oJSONoutput.RESULTINDEX
  mSetValue = oJSONoutput.VALUE
  mSetIndex = oJSONoutput.SETINDEX
  

  Set db = new clsDBHelper

  'for each a in regions
  '  regionValue = Split(a,"^")
  '  groupNo = regionValue(0) 
  '  region = regionValue(1)
    SQL = " Update sd_TennisResult"
    IF cDbl(mSetIndex) = 1 Then
      SQL = SQL & " Set m1set1 = " & mSetValue 
      SQL = SQL & " where resultIDX = "& resultIDX 
      Call db.execSQLRs(SQL , null, ConStr)
    elseif cDbl(mSetIndex) = 2 Then
      SQL = SQL & " Set m2set1 = " & mSetValue 
      SQL = SQL & " where resultIDX = "& resultIDX 
      Call db.execSQLRs(SQL , null, ConStr)
    end if
  
  
  
  '  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'		Do Until rs.eof
	'			delidx2 = rs(0)
  '      'Response.write "delidx2 :" & delidx2 & "</br>  "		
  '      subSQL = "update sd_TennisMember Set place = '" & region & "'  where gamememberIDX = " & delidx2
	'			'Response.Write subSQL &"<br>"
	'			Call db.execSQLRs(subSQL , null, ConStr)
	'			rs.movenext
	'		Loop
  'next
  
  db.Dispose
	Set db = Nothing
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  

%>