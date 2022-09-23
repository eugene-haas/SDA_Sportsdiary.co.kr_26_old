<%
'#############################################

'복사저장

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		targetIDX = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "CIDX") = "ok" then
		copyIDX = oJSONoutput.CIDX
	End if	

	Set db = new clsDBHelper 

		'현재 복사될 대회에 생성된 부서가 있다면 복사되지 않도록 제한
			gamecnt = " (select count(*) from tblRgameLevel where delyn = 'N' and gametitleidx = a.gametitleidx )  as gcnt "
			strSql = "SELECT "&gamecnt&"  FROM sd_gameTitle as a WHERE delyn = 'N' and gametitleidx = " & targetIDX
			Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		


			
			If rs(0) <> "0" Then
				Call oJSONoutput.Set("result", 4)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if



		'insert 

			SQL = "insert into tblRgameLevel  ( GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno )  "
			SQL = SQL & "( select "&targetIDX&",GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno from tblRgameLevel where gametitleidx = "&copyIDX&" and delyn = 'N' )"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		

			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>