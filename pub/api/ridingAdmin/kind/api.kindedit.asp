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

	strTableName = " tblTeamGbInfo "
	strFieldName = "  Teamgbidx,useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby "
	strSort = "  order by teamgbidx desc"
	strWhere = " Teamgbidx =  " & reqidx

	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere &  strSort
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	If Not rs.eof Then
		e_idx = rs(0)
		e_rullyear = rs(1)
		e_pteamgb = rs(2)
		e_pteamgbnm = rs(3)
		e_teamgb = rs(4)
		e_teamgbnm = rs(5)
		e_levelno = rs(6)
		e_levelnm = rs(7)
		e_classnm = rs(8)
		e_classhelp = rs(9)
		e_sortno = rs(10)
	End if


	%><!-- #include virtual = "/pub/html/riding/kindform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
