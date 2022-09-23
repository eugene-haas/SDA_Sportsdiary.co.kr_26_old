
<%
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
	'수정불가상태인지 체크
	sub chkEndMode(tidx, oJSONoutput,db,ConStr)
		Dim SQL,rs,strjson
		SQL = "select Editmode from tblEvalTable where delkey = 0 and editmode = 0 and evaltableidx = " & tidx 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			if not rs.eof then
				Call oJSONoutput.Set("result", 112 )
				Call oJSONoutput.Set("servermsg", "수정모드를 해제 후 이용하십시오." )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End	
			end if
	end sub

'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

%>