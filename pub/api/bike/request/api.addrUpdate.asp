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



	If hasown(oJSONoutput, "ADDR") = "ok" then
		addr = oJSONoutput.ADDR
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	
	If hasown(oJSONoutput, "ADDR2") = "ok" then
		addr2 = htmlEncode(oJSONoutput.ADDR2)
	End If	
	If hasown(oJSONoutput, "ZIPCODE") = "ok" then
		zipcode = htmlEncode(oJSONoutput.ZIPCODE)
	End If	

	'##############################
	Set db = new clsDBHelper

	'변경내용수정
	SQL = "update tblMember Set address = '"&addr&"',addressDtl = '"&addr2&"',zipcode='"&zipcode&"' where MemberIDX = " & Cookies_midx 
	Call db.execSQLRs(SQL , null, T_ConStr)


	Call oJSONoutput.Set("CHANGEVAL", addr&":"&addr2  ) '변경된값
	Call oJSONoutput.Set("TARGETID", "addr_chk" ) '원위치값
	Call oJSONoutput.Set("FNO", 6 ) '원위치값
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
 