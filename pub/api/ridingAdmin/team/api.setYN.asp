<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		e_idx = oJSONoutput.Get("IDX")
	End If

	Set db = new clsDBHelper


	SQL = "select apply_yn,team,nowyear from tblTeamInfo where teamidx = " & e_idx
	Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)
	apply_yn = rs(0)
	team = isnulldefault(rs(1),"")


	If apply_yn = "N" Then  ' > Y
	
		'Sql = "update  "&tablename&" Set   apply_YN = case when apply_YN = 'N' then 'Y' else 'N' end where teamidx = " & e_idx
		Sql = "update  tblTeamInfo Set   apply_YN = 'Y' where teamidx = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update tblWebRegLog Set state = 1 where gubun=3 and  regseq = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

	   '로그에 저장$$$$$$$$$$$$$$$$$$$$$
	   'tblTeamInfo_history
	   infld = " Team,TeamNm,TEAMCD,ShortNm,Sex,SIDO,SIDONM,ZipCode,ADDRESS1,ADDRESS2,PHONE,MADE_DT,EnterType,WorkDt,LEADER_KEY,LEADER_NM,startyear,nowyear,hCDASTR "
	   selectfld = "Team,TeamNm,TEAMCD,ShortNm,Sex,SIDO,SIDONM,ZipCode,ADDRESS1,ADDRESS2,PHONE,MADE_DT,EnterType,WorkDt,LEADER_KEY,LEADER_NM,startyear,nowyear,hCDASTR"
	   SQL = "insert into tblTeamInfo_history ("&infld&") (select "&selectfld&" from tblTeaminfo where teamidx = "&e_idx&" )"
	   Call db.execSQLRs(SQL , null, ConStr)

	   'tblTeamMember_history
	   infld = " nowyear,usertype,team,teamnm,ksportsno,username "
	   selectfld = " nowyear,'L',apply_team,apply_teamnm,ksportsno,username "
	   SQL = "insert into tblTeamMember_history ("&infld&") (select "&selectfld&" from tblLeader where apply_team = '"&team&"' and apply_YN = 'N' and delyn = 'N' and nowyear = '"&year(date)&"' )"
	   selectfld = " nowyear,'P',apply_team,apply_teamnm,ksportsno,username "
	   SQL = SQL & "insert into tblTeamMember_history ("&infld&") (select "&selectfld&" from tblPlayer where apply_team = '"&team&"' and apply_YN = 'N' and delyn = 'N' and nowyear = '"&year(date)&"' )"
	   Call db.execSQLRs(SQL , null, ConStr)

	   '로그에 저장$$$$$$$$$$$$$$$$$$$$$


		'엡데이트 (선수승인상태도 가지고 있어야할꺼 같다)
		SQL = "DECLARE @temp varchar(50); DECLARE @tempnm varchar(50); "
		SQL = SQL & "update tblLeader set @temp = team ,team = apply_team,apply_team = @temp  ,@tempnm = teamnm ,teamnm = apply_teamnm,apply_teamnm = @tempnm,apply_YN = 'Y' "
		SQL = SQL & " 	where apply_team = '"&team&"' and apply_YN = 'N' and delyn = 'N' and nowyear = '"&year(date)&"' " '선수승인전이고 삭제안된 당해년도 선수

		SQL = SQL & "update tblPlayer set @temp = team ,team = apply_team,apply_team = @temp  ,@tempnm = teamnm ,teamnm = apply_teamnm,apply_teamnm = @tempnm,apply_YN = 'Y' "
		SQL = SQL & " 	where apply_team = '"&team&"'  and apply_YN = 'N' and delyn = 'N' "
		Call db.execSQLRs(SQL , null, ConStr)

		'팀명단 로그 생성( 팀단위 승인이므로 개별 선수 승인 불필요) ? 변경내역이 있다면 다시 선청상태가 되어야할까
	
	Else

		Sql = "update  tblTeamInfo Set   apply_YN = 'N' where teamidx = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update tblWebRegLog Set state = 0 where  gubun=3 and regseq = " & e_idx '홈페이지용 생성해둔 부분 그냥 사용
		Call db.execSQLRs(SQL , null, ConStr)

		'엡데이트
		SQL = "DECLARE @temp varchar(50); DECLARE @tempnm varchar(50); "
		SQL = SQL & "update tblLeader set @temp = team ,team = apply_team,apply_team = @temp  ,@tempnm = teamnm ,teamnm = apply_teamnm,apply_teamnm = @tempnm ,apply_YN = 'N' "
		SQL = SQL & " 	where team = '"&team&"' and apply_YN = 'Y' and delyn = 'N' and nowyear = '"&year(date)&"' " '선수승인전이고 삭제안된 당해년도 선수

		SQL = SQL & "update tblPlayer set @temp = team ,team = apply_team,apply_team = @temp  ,@tempnm = teamnm ,teamnm = apply_teamnm,apply_teamnm = @tempnm ,apply_YN = 'N' "
		SQL = SQL & " 	where team = '"&team&"' and apply_YN = 'Y' and delyn = 'N' and nowyear = '"&year(date)&"' " '선수승인전이고 삭제안된 당해년도 선수
		Call db.execSQLRs(SQL , null, ConStr)

	
	   '팀명단 로그 제거$$$$$$$$$$$$$$$$$$$$$
	   'tblTeamInfo_history
	   SQL = "update tblTeamInfo_history set delyn = 'Y' where team = '"&team&"' and nowyear = '"&year(date)&"' and delyn = 'N'"
	   Call db.execSQLRs(SQL , null, ConStr)

	   'tblTeamMember_history
	   SQL = "delete from tblTeamMember_history where team = '"&team&"' and nowyear = '"&year(date)&"' "
	   Call db.execSQLRs(SQL , null, ConStr)
	   '팀명단 로그 제거$$$$$$$$$$$$$$$$$$$$$


	End if



	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>