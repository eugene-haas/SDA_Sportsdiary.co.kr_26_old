<%
'######################
'지역 시도 시군구 검색
'######################
	If hasown(oJSONoutput, "SDNO") = "ok" then
		sdno = oJSONoutput.SDNO
	End If


	If hasown(oJSONoutput, "GB") = "ok" then
		s_sidono = oJSONoutput.GB
	End If

	Select Case sdno
	Case "1" : s_sidono1 = s_sidono
	Case "2" : s_sidono2 = s_sidono
	End Select 

	Set db = new clsDBHelper


	SQL = "Select sido,sidonm from tblSidoInfo where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrSD = rs.GetRows()
	End If


	SQL = "Select GuGunNm from tblGugunInfo where delYN = 'N' and Sido = '"&s_sidono&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrGG = rs.GetRows()
	End If




	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/riding/common/html.sido.asp" -->