<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	'경기번호는 

	Set db = new clsDBHelper

	strFieldName = " rcIDX,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,DelYN " 

	strSort = "  order by rcIDX desc"
	strSortR = "  order by rcIDX "

	SQL = "select top 20 "&strFieldName&" from tblRecord as a  where delYn = 'N' order by rcIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


    If Not rs.EOF Then
		arrR = rs.GetRows()
    End If





	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			l_idx = arrR(0, ari)
			l_titleCode= arrR(1, ari)
			l_titlename= arrR(2, ari)
			l_CDA= arrR(3, ari)
			l_CDANM= arrR(4, ari)
			l_CDB= arrR(5, ari)
			l_CDBNM= arrR(6, ari)
			l_CDC= arrR(7, ari)
			l_CDCNM= arrR(8, ari)
			l_kskey= arrR(9, ari)
			l_ksportsno= arrR(10, ari)
			l_playerIDX= arrR(11, ari)
			l_UserName= arrR(12, ari)
			l_Birthday= arrR(13, ari)
			l_Sex= arrR(14, ari)
			l_nation= arrR(15, ari)
			l_sidoCode= arrR(16, ari)
			l_sido= arrR(17, ari)
			l_gameDate= arrR(18, ari)
			l_EnterType= arrR(19, ari)
			l_Team= arrR(20, ari)
			l_TeamNm= arrR(21, ari)
			l_userClass= arrR(22, ari)
			l_rctype= arrR(23, ari)
			l_gamearea= arrR(24, ari)
			l_gameResult= arrR(25, ari)
			l_gameOrder= arrR(26, ari)
			l_rane= arrR(27, ari)

	%><!-- #include virtual = "/pub/html/swimming/html.rcList.asp" --><%


		pre_gameno = r_a2
		Next
	End if


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>