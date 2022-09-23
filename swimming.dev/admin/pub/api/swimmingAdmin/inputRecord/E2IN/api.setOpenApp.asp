<%
'#############################################
'결과완료여부 저장
'#############################################
	'request
	lidx = oJSONoutput.get("LIDX")
	fld = oJSONoutput.get("FLD")
	
		Set db = new clsDBHelper

		'통합부도 저장되어야한다.
		select case fld
		case "DAY1"
			SQL = "Update tblRGameLevel Set resultopenAMYN = 'Y',resultopenPMYN = 'N' where RGameLevelidx = " & lidx & " or grouplevelidx = " & lidx
			Call db.execSQLRs(SQL , null, ConStr) 	
		case ""
			SQL = "Update tblRGameLevel Set resultopenAMYN = 'N',resultopenPMYN = 'N' where RGameLevelidx = " & lidx & " or grouplevelidx = " & lidx
			Call db.execSQLRs(SQL , null, ConStr) 			
		End select 


	Call oJSONoutput.Set("SQL", 0 )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


