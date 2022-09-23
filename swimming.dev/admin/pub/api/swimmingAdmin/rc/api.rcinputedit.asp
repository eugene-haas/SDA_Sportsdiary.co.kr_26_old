<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " rcIDX,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,gubun,    kskey2,kskey3,kskey4,playerIDX2,playerIDX3,playerIDX4,UserName2,UserName3,UserName4 " 

	SQL = "select top 1 "&strFieldName&" from tblRecord where rcIDX = " & reqidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


    If Not rs.EOF Then
		arrR = rs.GetRows()
    End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
		e_idx = arrR(0, ari)
		e_titleCode= arrR(1, ari)
		e_titlename= arrR(2, ari)
		e_CDA= arrR(3, ari)
		e_CDANM= arrR(4, ari)
		e_CDB= arrR(5, ari)
		e_CDBNM= arrR(6, ari)
		e_CDC= arrR(7, ari)
		e_CDCNM= arrR(8, ari)
		e_kskey= arrR(9, ari)
		e_ksportsno= arrR(10, ari)
		e_playerIDX= arrR(11, ari)
		e_UserName= arrR(12, ari)
		e_Birthday= arrR(13, ari)
		e_Sex= arrR(14, ari)
		e_nation= arrR(15, ari)
		e_sidoCode= arrR(16, ari)
		e_sido= arrR(17, ari)
		e_gameDate= arrR(18, ari)
		e_EnterType= arrR(19, ari)
		e_Team= arrR(20, ari)
		e_TeamNm= arrR(21, ari)
		e_userClass= arrR(22, ari)
		e_rctype= arrR(23, ari)
		e_gamearea= arrR(24, ari)
		e_gameResult= arrR(25, ari)
		e_gameOrder= arrR(26, ari)
		e_rane= arrR(27, ari)
		e_gubun = arrR(28,ari)

		e_kskey2 = arrR(29,ari)
		e_kskey3 = arrR(30,ari)
		e_kskey4 = arrR(31,ari)
		e_pidx2 = arrR(32,ari)
		e_pidx3 = arrR(33,ari)
		e_pidx4 = arrR(34,ari)
		e_UserName2 = arrR(35,ari)
		e_UserName3 = arrR(36,ari)
		e_UserName4 = arrR(37,ari)

		Next
	End If
	
	%><!-- #include virtual = "/pub/html/swimming/html.rcform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
