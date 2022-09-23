<%
'#############################################


'#############################################
	'request
	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End If
	If hasown(oJSONoutput, "midx") = "ok" then
		midx = oJSONoutput.midx
	End If
	If hasown(oJSONoutput, "uname") = "ok" then
		uname = oJSONoutput.uname
	End If
	If hasown(oJSONoutput, "ubank") = "ok" then
		ubank = oJSONoutput.ubank
	End If
	If hasown(oJSONoutput, "uacct") = "ok" then
		uacct = oJSONoutput.uacct
		inbankacc = f_enc(Replace(uacct,"-",""))
	End If


	Set db = new clsDBHelper

	
	SQL = "SELECT gametitleidx, level from tblgamerequest where requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	If Not rs.eof Then
		tidx = rs(0)
		levelno = rs(1)
	End if

	'환불계좌 정보 입력
	SQL = "Update SD_RookieTennis.dbo.TB_RVAS_LIST Set  recustnm = '"&uname&"' , rebanknm='"&ubank&"', refund = '"& inbankacc &"',tidx='"&tidx&"',levelno='"&levelno&"',refunddate=getdate() where CUST_CD = '" & Left(sitecode,2) & ridx & "' and STAT_CD = '0' "
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "update tblGameRequest Set delYN = 'Y' where RequestIDX = " & ridx
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "delete sd_TennisMember where gameMemberIDX = " & midx
	Call db.execSQLRs(SQL , null, ConStr)
	SQL = "delete from sd_TennisMember_partner where gameMemberIDX = " & midx
	Call db.execSQLRs(SQL , null, ConStr)


	If ridx <> "" And isnull(ridx) = False then
	'발급받은 가상계좌정보 사용막음
	SQL = "UPDATE SD_RookieTennis.dbo.TB_RVAS_MAST Set STAT_CD = '0' where CUST_CD = '" & Left(sitecode,2) & ridx & "' "
	Call db.execSQLRs(SQL , null, ConStr)
	End if


	'가상계좌정보 초기화 해야겠군.============
	'SQL = "Update TB_RVAS_MAST Set STAT_CD= '1' ,ENTRY_IDNO = null , CUST_CD = null,IN_GB = '1',PAY_AMT = 0,PAY_FROM_DATE='00000000',PAY_TO_DATE='99999999',CUST_NM = null,ENTRY_DATE = null  where  CUST_CD = '" & ridx & "' "
	'Call db.execSQLRs(SQL , null, ConStr)

	'1년단위로 일괄 초기화
	'가상계좌정보 초기화 해야겠군.============


	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>