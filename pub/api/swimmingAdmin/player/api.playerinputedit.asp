<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " PlayerIDX,MemberIDX,userID,startyear,nowyear,userType,kskey,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,ProfileIMG,WriteDate,EnterType,TeamNm,userClass,Team "

	strSql = "SELECT top 1  " & strFieldName &  "  FROM tblPlayer  WHERE PlayerIDX = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
		e_idx = arrR(0, ari)
		e_MemberIDX = arrR(1, ari)
		e_userID = arrR(2, ari)
		e_startyear = arrR(3, ari)
		e_nowyear = arrR(4, ari)
		e_userType = arrR(5, ari)
		e_ksportsno = arrR(6, ari) 'kskey로 변경
		e_ksportsnoS = arrR(7, ari)
		e_UserName = arrR(8, ari)
		e_userNameCn = arrR(9, ari)
		e_userNameEn = arrR(10, ari)
		e_Birthday = arrR(11, ari)
		e_Sex = arrR(12, ari)
		e_nation = arrR(13, ari)
		e_sidoCode = arrR(14, ari)
		e_sido = arrR(15, ari)
		e_CDA = arrR(16, ari)
		e_CDANM = arrR(17, ari)
		e_CDB = arrR(18, ari)
		e_CDBNM = arrR(19, ari)
		e_UserPhone = arrR(20, ari)
		e_ProfileIMG = arrR(21, ari)
		e_WriteDate = arrR(22, ari)
		e_EnterType = arrR(23, ari)
		e_TeamNm = arrR(24, ari)
		e_userClass = arrR(25, ari)
		e_Team = arrR(26, ari)
		e_idx = reqidx
		Next
	End If
	
	%><!-- #include virtual = "/pub/html/swimming/playersform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
