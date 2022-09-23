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
		selectTbl = "KoreaBadminton_Info.dbo.tblSW_person_info as k"
		insertTbl = "tblPlayer"
		'최초 등록된 정보 인서트
		SQL = "Select min(REG_YEAR) from " & selectTbl
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If  isNull(rs(0)) = true Then
			minyear = year(date)
		Else
			minyear = rs(0)
		End if

		selectFLD = "PERSON_NO,REG_YEAR,REG_YEAR,'I',KOR_CD,KOR_CD_FIRST,KOR_NM,CHN_NM,ENG_NM,BIRTH_DT"
		selectFLD = selectFLD & ",Case When SEX = 'M' then '1' else '2' end "
		selectFLD = selectFLD & ",NATION_CD,SIDO_CD,(select top 1 sidonm from tblsidoinfo where sido = k.sido_cd) As sidonm"
		selectFLD = selectFLD & ",CLASS_CD,(select top 1 pteamgbnm from tblteamgbinfo where cd_type= 0 And pteamgb = k.CLASS_CD) As pteamgbnm"
		selectFLD = selectFLD & ",KIND_CD,(select top 1 cd_boonm from tblteamgbinfo where cd_type= 2 And cd_boo = k.KIND_CD) As cd_boonm"
		selectFLD = selectFLD & ",MOBILE_NO,'E',TEAM_CD,TEAM_NM,SC_GRADE,ADDRESS1,ADDRESS2,ZIPCODE,E_MAIL"

		'기록 필드
		historyFld = " kskey,nowyear,username,sidocode,cdb,team,teamnm,userclass "
	'공통 ###########################################


	'tblPlayer 상태검사 (21.03.09 엘리트인지 여부 추가 생체작업준비)
	SQL = "Select max(nowyear),min(nowyear) from tblPlayer where EnterType = 'E' and delyn = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If isNull(rs(0)) = true Then

		insertFLD =  " kskey,startyear,nowyear,userType,ksportsno,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,EnterType,Team,teamnm,userclass,addr1,addr2,zipcode,email "

		selectQ = "select " & selectFLD & " from " & selectTbl & " where REG_YEAR = '"&minyear&"' "

		SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")"
		Call db.execSQLRs(SQL , null, ConStr)

		'히스토리 넣기(신규발생건만 넣는다)
		SQL = "Insert into tblPlayer_history ( "&historyFld&" ) (select "&historyFld&" from tblPlayer where DelYn = 'N' and EnterType = 'E' )"
		Call db.execSQLRs(SQL , null, ConStr)

	Else

		maxyear = rs(0) '마지막 등록된 정보
		minyear = rs(1)
		'nextyear = CDbl(maxyear) + 1
		nowyear = year(date)

		SQL = "Select top 1 PERSON_NO from " & selectTbl & " where REG_YEAR = '" & nowyear & "' and PERSON_NO not in ( select kskey from tblPlayer where DelYn = 'N' and EnterType = 'E' ) "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		If rs.eof Then
			'기존값 찾아서 업데이트 같은날짜로 (maxyear)
			'히스토리 넣기(신규발생건만 넣는다) 변경되기 전에 먼저 넣는다.
			selectQ = "select PERSON_NO,REG_YEAR,KOR_NM,SIDO_CD,KIND_CD,TEAM_CD,TEAM_NM,SC_GRADE from " & selectTbl & " where REG_YEAR = '" & nowyear & "' and PERSON_NO not in ( select kskey from tblPlayer where DelYn = 'N' and EnterType = 'E' ) "
			SQL = "Insert into tblPlayer_history ( "&historyFld&" ) ( "&selectQ&" )"
			Call db.execSQLRs(SQL , null, ConStr)


			'인서트 되어야할덧들 먼저하고...
			insertFLD =  " kskey,startyear,nowyear,userType,ksportsno,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,EnterType,Team,teamnm,userclass,addr1,addr2,zipcode,email "
			selectQ = "select " & selectFLD & " from " & selectTbl & " where REG_YEAR = '" & nowyear & "' and PERSON_NO not in ( select kskey from tblPlayer where DelYn = 'N' and EnterType = 'E' ) "
			SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")"
			Call db.execSQLRs(SQL , null, ConStr)


			'전체내용으로 업데이트 한다.
			SQL = "UPDATE "&insertTbl&" SET "
			'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
			SQL = SQL & "nowyear = k.REG_YEAR,ksportsno=k.KOR_CD,ksportsnoS=k.KOR_CD_FIRST,userName= k.KOR_NM,userNameCn=k.CHN_NM,userNameEn=k.ENG_NM"
			SQL = SQL & ",sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
			SQL = SQL & ",CDA = k.CLASS_CD, CDANM = (select top 1 pteamgbnm from tblteamgbinfo where cd_type= 0 And pteamgb = k.CLASS_CD) "
			SQL = SQL & ",CDB= k.KIND_CD,CDBNM = (select top 1 cd_boonm from tblteamgbinfo where cd_type= 2 And cd_boo = k.KIND_CD)"
			SQL = SQL & ",UserPhone=k.MOBILE_NO,team=k.TEAM_CD,teamnm=k.TEAM_NM,userclass=k.SC_GRADE,addr1=k.ADDRESS1,addr2=k.ADDRESS2,zipcode=k.ZIPCODE,email=k.E_MAIL"

			SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
			SQL = SQL & " where kskey  = k.PERSON_NO and k.REG_YEAR = '" & nowyear & "' "
			Call db.execSQLRs(SQL , null, ConStr)

		Else
			'히스토리 넣기(신규발생건만 넣는다) 변경되기 전에 먼저 넣는다.
			selectQ = "select PERSON_NO,REG_YEAR,KOR_NM,SIDO_CD,KIND_CD,TEAM_CD,TEAM_NM,SC_GRADE from " & selectTbl & " where REG_YEAR = '" & nowyear & "' and PERSON_NO not in ( select kskey from tblPlayer where DelYn = 'N' and EnterType = 'E') "
			SQL = "Insert into tblPlayer_history ( "&historyFld&" ) ( "&selectQ&" )"
			Call db.execSQLRs(SQL , null, ConStr)


			'인서트 되어야할덧들 먼저하고...
			insertFLD =  " kskey,startyear,nowyear,userType,ksportsno,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,EnterType,Team,teamnm,userclass,addr1,addr2,zipcode,email "
			selectQ = "select " & selectFLD & " from " & selectTbl & " where REG_YEAR = '" & nowyear & "' and PERSON_NO not in ( select kskey from tblPlayer where DelYn = 'N' and EnterType = 'E') "
			SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")"
			Call db.execSQLRs(SQL , null, ConStr)


			'전체내용으로 업데이트 한다. 	'다음날짜값으로 업데이트 (nowyear)   nowyear > nowyear
			SQL = "UPDATE "&insertTbl&" SET "
			'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
			SQL = SQL & "nowyear = k.REG_YEAR,ksportsno=k.KOR_CD,ksportsnoS=k.KOR_CD_FIRST,userName= k.KOR_NM,userNameCn=k.CHN_NM,userNameEn=k.ENG_NM"
			SQL = SQL & ",sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
			SQL = SQL & ",CDA = k.CLASS_CD, CDANM = (select top 1 pteamgbnm from tblteamgbinfo where cd_type= 0 And pteamgb = k.CLASS_CD) "
			SQL = SQL & ",CDB= k.KIND_CD,CDBNM = (select top 1 cd_boonm from tblteamgbinfo where cd_type= 2 And cd_boo = k.KIND_CD)"
			SQL = SQL & ",UserPhone=k.MOBILE_NO,team=k.TEAM_CD,teamnm=k.TEAM_NM,userclass=k.SC_GRADE,addr1=k.ADDRESS1,addr2=k.ADDRESS2,zipcode=k.ZIPCODE,email=k.E_MAIL"

			SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
			SQL = SQL & " where kskey  = k.PERSON_NO and k.REG_YEAR = '" & nowyear & "' "
			Call db.execSQLRs(SQL , null, ConStr)


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
		End if
    End if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
