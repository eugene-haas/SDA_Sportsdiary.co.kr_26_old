<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper
	tblnm = "tblPlayer"
	chkfld = "playerIDX"

	strFieldName = " hpassport,userName,hchipno,hfield,hhairclr,  hpassportagency,hnation,eng_nm,sex,birthday,nowyear,hCDASTR,howner,hownerbirthday,userphone,email,ZipCode,Address1,Address2, usertype,userid "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql &  "  FROM "&tblnm&"  "
	strSql = strSql &  " WHERE "&chkfld&" = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = reqidx
		e_hpassport  = rs(0)
		e_userName = rs(1)
		e_hchipno = rs(2)
		e_hfield = rs(3)
		e_hhairclr = rs(4)


		e_hpassportagency = rs(5)
		e_hnation = rs(6)
		e_eng_nm = rs(7)
		e_sex = rs(8)
		e_birthday = rs(9)
		e_nowyear = rs(10)
		e_hCDASTR = rs(11)
		e_howner = rs(12)
		e_hownerbirthday = rs(13)
		e_userphone = rs(14)
		e_email = rs(15)
		e_ZipCode = rs(16)
		e_Address1 = rs(17)
		e_Address2 = rs(18)
		e_usertype = rs(19)
		e_userid = rs(20)


If e_userid <> "" then
fld = " dbo.FN_DEC_TEXT(BIRTHDAY),dbo.FN_DEC_TEXT(PHONE_NUMBER),EMAIL,username "  '1:심판 2:기타관계자 0:없음 (선수는 playeridx  가 존재함)
SQL = "select "&fld&" from tblWebMember where delYN = 'N' and userid = '"&e_userid&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	e_infobirthday = rs(0)
	e_infophone = rs(1)
	e_infoemail = rs(2)
	e_infousername = rs(3)
End if

	End if
	%>
	 신청인정보 : <%=e_infousername%> (<%=e_userid%> : <%=e_infobirthday%> : <%=e_infophone%>)
	<!-- #include virtual = "/pub/html/riding/horseForm.asp" --><%

	db.Dispose
	Set db = Nothing
%>
