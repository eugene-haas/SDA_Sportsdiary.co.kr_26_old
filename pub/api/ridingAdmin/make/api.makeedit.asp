<%
'#############################################

'넌도 종목관리 수정 정보 불러오기

'DB SD_Riding 
'tblPubCode (코드 정의)
'년도별 등록된 코드값
'tblTeamGbInfo 

'#############################################
	'request
	reqidx = oJSONoutput.IDX


	Set db = new clsDBHelper

	strTableName = " tblRealPersonNo "
	strFieldName = "  idx,useyear,TeamGb,TeamGbNm,realcnt "
	strWhere = " idx =  " & reqidx

	SQL = "Select top 1 " & strFieldName & " from " & strTableName & " where " & strWhere 
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	If Not rs.eof Then
		e_idx = rs(0)
		e_rullyear = rs(1)
		e_teamgb = rs(2)
		e_teamgbnm = rs(3)
		e_realcnt = rs(4)
	End if


	%><!-- #include virtual = "/pub/html/riding/makeform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
