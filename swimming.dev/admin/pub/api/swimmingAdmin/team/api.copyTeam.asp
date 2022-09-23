<%
'#############################################
'temp 데이터를 request 테이블에 밀어넣는다.
'#############################################
	
	'request
	'If hasown(oJSONoutput, "TIDX") = "ok" Then 
	'	tidx = oJSONoutput.TIDX
	'End If

	Set db = new clsDBHelper 

	'공통 ###########################################
		'table
		selectTbl = "KoreaBadminton_Info.dbo.tblSW_team_info as k"
		insertTbl = "tblTeamInfo"
		'최초 등록된 정보 인서트
		SQL = "Select max(REG_YEAR) from " & selectTbl
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If  isNull(rs(0)) = true Then
			maxyear = year(date)
		Else
			maxyear = rs(0)
		End if
	
		selectFLD = " 'E',TEAM_CD,TEAM_NM,SIDO_CD, (select top 1 sidonm from tblsidoinfo where sido = k.sido_cd) As sidonm "
		selectFLD = selectFLD & ",ZIPCODE,ADDRESS1,ADDRESS2 ,Case When SEX = 'M' then '1' when SEX= 'W' then '2' else '2' end "
		selectFLD = selectFLD & ",PHONE_NO,REG_YEAR,MADE_DT,DIS_DT,HEAD_NM,LEADER_NM"

		insertFLD =  " EnterType,Team,TeamNm,sidocode,sido,ZipCode,Address,AddrDtl,Sexno,TeamTel,TeamRegDt,TeamMakeDt,SvcEndDt,jangname,readername "
	'공통 ###########################################


	'tblTeamInfo 상태검사
	SQL = "Select count(*) from "& insertTbl
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Cdbl(rs(0)) = 1 Then '국가대표만 있는상태

		selectQ = "select " & selectFLD & " from " & selectTbl 
		SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")" 
		Call db.execSQLRs(SQL , null, ConStr)

	Else

		'신규 추가 된것들 인서트
		selectQ = "select " & selectFLD & " from " & selectTbl & " where TEAM_CD  not in ( select team from "&insertTbl&"  where delyn='N' and entertype = 'E') "
		SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")" 
		Call db.execSQLRs(SQL , null, ConStr)


		'전체내용으로 업데이트 한다.
		SQL = "UPDATE "&insertTbl&" SET "
		'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
		SQL = SQL & "TeamNm = k.TEAM_NM "
		SQL = SQL & ",sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
		SQL = SQL & ",ZipCode = k.ZIPCODE, Address = k.ADDRESS1,AddrDtl=k.ADDRESS2,TeamTel = k.PHONE_NO "
		SQL = SQL & ",jangname = 'HEAD_NM',readername = 'LEADER_NM' "
		
		SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
		SQL = SQL & " where team  = k.TEAM_CD "
		Call db.execSQLRs(SQL , null, ConStr)

    End if


	'UPDATE 테이블명A
	'SET
	'    테이블명A.필드명 = 테이블명B.필드명
	'
	'FROM 테이블명A, 테이블명B
	'
	'WHERE 테이블A.ID = 테이블B.ID
	'################################
	'if exists (select * from t where pk = @id)
	'update
	'else
	'insert 


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>