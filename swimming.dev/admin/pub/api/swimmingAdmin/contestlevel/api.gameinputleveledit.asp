<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno,WriteDate,DelYN "

	strSql = "SELECT top 1  " & strFieldName &  "  FROM tblRGameLevel   WHERE RGameLevelidx = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = rs(0)
		tidx  = rs(1)
		e_GbIDX  = rs(2)
		e_Sexno = rs(3)
		e_ITgubun = rs(4)
		e_CDA = rs(5)
		e_CDANM = rs(6)
		e_CDB = rs(7)
		e_CDBNM = rs(8)
		e_CDC = rs(9)
		e_CDCNM = rs(10)
		e_levelno = rs(11)
		e_WriteDate = rs(12)
		e_DelYN = rs(13)

		Select Case e_sexno
		Case "1","2"
			e_CDBNM = Mid(e_CDBNM,3)
		Case "3"
			e_CDBNM = e_CDBNM
		End Select 
	End if

	%><!-- #include virtual = "/pub/html/swimming/gameinfolevelform.asp" --><%

	db.Dispose
	Set db = Nothing
%>