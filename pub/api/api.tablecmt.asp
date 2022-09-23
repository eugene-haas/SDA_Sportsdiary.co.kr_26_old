<%

'CMD:1
'CMT:"테"
'DN:"ITEMCENTER"
'MD:2
'NM:"IC_T_ONLINE_GDS_2"


	DN = oJSONoutput.value("DN") '디비명
	TN = oJSONoutput.value("NM") '테이블명
	CMT = oJSONoutput.value("CMT") '주석
	MD =  oJSONoutput.value("MD") ' 1 인서트 2 업데이트

	DN = chkStrRpl(DN, "") 
	TN = chkStrRpl(TN, "") 
	CMT = chkStrRpl(CMT, "")
	MD = chkInt(MD , 3)


'CMT = "..."
'DN= "Sportsdiary"
'MD = 2
'TN = "tblAssSportsGb"



	ConStr = Replace(ConStr, "ITEMCENTER", DN)
	Set db = new clsDBHelper

	Select Case  Cstr(MD)
	Case "1" : itype = "I"
	Case "2" : itype = "U"
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