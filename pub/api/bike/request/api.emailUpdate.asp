<%
'######################
'주소 업데이트 (바이크에 있는 정보만 업데이트 한다. ㅡㅡ+
'######################

'{"ADDR":"제주특별자치도 제주시 가령골길 1 (일도2동)","ADDR2":"가가가","ZIPCODE":"63275","SIDO":"제주"}
	'---------------
	If Cookies_midx = "" Then '로그인 여부체크
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If
	'---------------



	If hasown(oJSONoutput, "EMAIL") = "ok" then
		email = oJSONoutput.EMAIL
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	'##############################
	Set db = new clsDBHelper

	'변경내용수정
	SQL = "update tblMember Set Email = '"&email&"' where MemberIDX = " & Cookies_midx 
	Call db.execSQLRs(SQL , null, T_ConStr)

	Call oJSONoutput.Set("CHANGEVAL", email  ) '변경된값
	Call oJSONoutput.Set("TARGETID", "email_chk" ) '원위치값
	Call oJSONoutput.Set("FNO", 11 ) '원위치값
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
 