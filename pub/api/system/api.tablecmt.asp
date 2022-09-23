<%
	If hasown(oJSONoutput, "NM") = "ok" Then  '테이블 명
		TN = chkStrRpl(oJSONoutput.NM,"")
	End If	

	If hasown(oJSONoutput, "CMT") = "ok" Then  '주석
		CMT = oJSONoutput.CMT
	Else
		CMT = ""
	End If	

	If hasown(oJSONoutput, "MD") = "ok" Then  '이전다음  : 0 첫장 :  1 이전 : 2 다음
		MD = chkInt(oJSONoutput.MD,0)
	Else
		MD = 3
	End If	

	MD = chkInt(MD , 3)

	Set db = new clsDBHelper

	Select Case  Cstr(MD)
	Case "1" : itype = "I" '저장 insert
	Case "2" : itype = "U" '수정  update 
	End Select

	If MD = "1" Or MD = "2" then
		'매개변수 배열 준비
		params = Array(_
						db.MakeParam("@I_TYPE"                  ,adVarwchar ,adParamInput ,1 , itype), _
						db.MakeParam("@I_TABLE"                ,adVarwchar ,adParamInput ,50 , TN), _
						db.MakeParam("@I_COLUMN"            ,adVarwchar ,adParamInput ,50 , ""), _
						db.MakeParam("@I_COMMENT"         ,adVarwchar ,adParamInput ,1000 , CMT) _
						)

		'SP를 실행한다. '맨 마지막 매개변수가 Nothing이면 기본 연결문자열   // 각각 사용 하려면 ConStr 각각디비에 프로시져 만들것
		db.ExecSP "UP_SET_TABLE_COMMENT", params, ConStr
	End if

	jstr = "{""result"":""0"",""I"":"""&itype&"""}"
	Response.write jstr

	db.Dispose
	Set db = Nothing
%>