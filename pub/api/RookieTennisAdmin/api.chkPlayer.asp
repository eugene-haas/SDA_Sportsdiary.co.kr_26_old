<%
'#############################################
'선수 생성시 중복을 확인해준다.
'#############################################
	'request
	name = oJSONoutput.pname
	phone = oJSONoutput.phone

	If isnumeric(phone) = False Then
		Call oJSONoutput.Set("result", 4002 ) '숫자가 아닌전화번호
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	Set db = new clsDBHelper

	'기존 이름과 폰번호가 중복되었는지 확인해서 알려준다.
		SQL = "SELECT top 1 playeridx from tblPlayer where DelYN = 'N' and UserName = '" & name & "' and UserPhone = '" & phone & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
		If rs.eof Then '사용가능
			Call oJSONoutput.Set("result", 4004 ) '사용가능한 선수명 + 전화번호
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.end
		Else
			Call oJSONoutput.Set("result", 4003 ) '등록된 선수
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.end
		End if
%>