<%
'#############################################
'오픈부 랭킹저장위치 저장
'#############################################
	'request
	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	Else
		Response.end
	End If
	If hasown(oJSONoutput, "V") = "ok" then
		setvalue = oJSONoutput.V
	Else
		Response.end
	End If


	Set db = new clsDBHelper

			'20101 개나리 20102 국화부
			'20103 베테랑
			'20104 신인부 20105 오픈부
	Select Case setvalue
	Case "개나리" : chklevel = "20101"
	Case "국화부" : chklevel = "20102"
	Case "신인부" : chklevel = "20104"
	Case "오픈부" : chklevel = "20105"
	Case "베테랑부" : chklevel = "20103"
	Case "" : chklevel = ""
	End Select 



	SQL = "Update tblPlayer set openrnkboo = '"&setvalue&"', chklevel = '"&chklevel&"' where playerIDX = " & pidx
	Call db.execSQLRs(SQL , null, ConStr)


	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 3100 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>