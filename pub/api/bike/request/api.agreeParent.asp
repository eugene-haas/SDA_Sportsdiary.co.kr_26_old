<%
'######################
'부모동의완료
'######################

	If hasown(oJSONoutput, "attmidx") = "ok" then
		attmidx = oJSONoutput.attmidx
	End If	

	If hasown(oJSONoutput, "PNM") = "ok" then
		pnm = oJSONoutput.PNM
	End If	
	If hasown(oJSONoutput, "PADDR") = "ok" then
		paddr = htmlEncode(oJSONoutput.PADDR)
	End If	
	If hasown(oJSONoutput, "PRT") = "ok" then
		prt = htmlEncode(oJSONoutput.PRT)
	End If	

	'##############################
	Set db = new clsDBHelper

	SQL = "select groupno from sd_bikeAttMember where attmidx = " & attmidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	groupno = rs(0)

	'변경내용수정
	If groupno = "0" then
	SQL = "update sd_bikeAttMember Set myagree='Y',p_nm2 = '"&pnm&"',p_addr = '"&paddr&"',p_relation2='"&prt&"',p_agree='Y' where attmidx = " & attmidx 
	Else
	SQL = "update sd_bikeAttMember Set myagree='Y',p_nm2 = '"&pnm&"',p_addr = '"&paddr&"',p_relation2='"&prt&"',p_agree='Y' where groupno = " & groupno 
	End if
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", "9090" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
