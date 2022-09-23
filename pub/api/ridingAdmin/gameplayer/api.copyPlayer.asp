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
		selectTbl = "KoreaBadminton_Info.dbo.tblES_person_info as k"
		targetTbl = "tblPlayer"

		'1. 우선 PERSON_NO 업데이트 부터 하자..
		'조인 업데이트 해야하겠지		(폰정보가 처음에 잘안들어가져있다. 이름으로 해보자) 19년도 20년도순으로 두번넣자.

			'SQL = "update "&targetTbl& " set "
			'SQL = SQL & "	ksportsno = k.PERSON_NO "
			'SQL = SQL & "	,nowyear = k.REG_YEAR "
			'SQL = SQL & "	,userType = 'P' "
			'SQL = SQL & "	,UserName = k.KOR_NM "
			'SQL = SQL & "	,UserPhone = k.MOBILE_NO "
			'SQL = SQL & "	,Sex = k.SEX "
			'SQL = SQL & "	,KSTEAMCD = k.TEAM_CD "
			'SQL = SQL & "	,KSTEAMNM = k.TEAM_NM "
			'SQL = SQL & "	,email = k.E_MAIL "
			'SQL = SQL & "	,ENG_NM = k.ENG_NM "
			'SQL = SQL & "	,CHN_NM = k.CHN_NM "
			'SQL = SQL & "	,ZIPCODE = k.ZIPCODE "
			'SQL = SQL & "	,ADDRESS1 = k.ADDRESS1 "
			'SQL = SQL & "	,ADDRESS2 = k.ADDRESS2 "
			'SQL = SQL & "	,SIDO = k.SIDO_CD "
			'SQL = SQL & "	,Birthday = case when left(k.BIRTH_DT,1) = '0' or left(k.BIRTH_DT,1) = '1' then  '20' + k.BIRTH_DT else '19' +k.BIRTH_DT end"
			'SQL = SQL & "	,SIDONM = (select top 1 SidoNm from tblSidoInfo where  sido = k.SIDO_CD ) "
			'SQL = SQL & "	,CDB = k.KIND_CD "
			'SQL = SQL & "	,SC_GRADE = k.SC_GRADE "
			'SQL = SQL & " from SD_Riding.dbo."&targetTbl&" as a inner join "&selectTbl&" "
			'SQL = SQL & " on a.username = k.KOR_NM  and k.MOBILE_NO <> '' where  a.userType = 'P'  and a.UserPhone <> '' and k.REG_YEAR = '2020' "
			'Call db.execSQLRs(SQL , null, ConStr)

			'테스트 대회에 넣었던 멤버들 삭제
			'SQL = "Delete From tblPlayer_test Where playeridx In (Select a.playeridx from tblPlayer_test as a inner join sd_TennisMember as b on a.PlayerIDX = b.PlayerIDX where a.MemberIDX <> '' ) "
			'Call db.execSQLRs(SQL , null, ConStr)

			'Call oJSONoutput.Set("result", 0 )
			'strjson = JSON.stringify(oJSONoutput)
			'Response.Write strjson
			'
			'Set rs = Nothing
			'db.Dispose
			'Set db = Nothing
			'Response.end


			'대상 필드
			targetFld = "ksportsno,startyear,nowyear,userType,UserName,ENG_NM,CHN_NM,UserPhone,Sex,Birthday,KSTEAMCD,KSTEAMNm,email,ZIPCODE,ADDRESS1,ADDRESS2,SIDO,SIDONM,CDB,cdbnm,SC_GRADE"

			'조회 필드
			selectFLD = "PERSON_NO,REG_YEAR,REG_YEAR,'P',KOR_NM,ENG_NM,CHN_NM,MOBILE_NO,SEX"
			selectFLD = selectFLD & ",	case when left(k.BIRTH_DT,1) = '0' or left(k.BIRTH_DT,1) = '1' then  '20' + k.BIRTH_DT else '19' +k.BIRTH_DT end "
			selectFLD = selectFLD & ",TEAM_CD,TEAM_NM,E_MAIL,ZIPCODE,ADDRESS1,ADDRESS2,SIDO_CD,(select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) As sidonm"
			selectFLD = selectFLD & ",KIND_CD, (select top 1 cdbnm from tblKSpubcode where cdb = k.KIND_CD)  ,SC_GRADE"

			'기록 필드
			historyFld = " ksportsno,nowyear,username,sido,cdb,team,teamnm "



			'select top 1 PERSON_NO from KoreaBadminton_Info.dbo.tblES_person_info as k where PERSON_NO not in ( select ksportsno from tblplayer where userType = 'P' and DelYN = 'N' )
			SQL = "Select top 1 PERSON_NO from " & selectTbl & " where PERSON_NO not in ( select ksportsno from "&targetTbl&" where  userType = 'P' and DelYN = 'N' ) " '등록되지 않은 지도자가 있다면
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


			If rs.eof Then '모두 등록됨

				'히스토리 넣기, nowyear 가 변경되는 것만 넣기
				historysavetarget = "select PERSON_NO from "&selectTbl &" where REG_YEAR = '"&year(date)&"' "
				SQL = "Insert into tblPlayer_history ( "&historyFld&" ) (select "&historyFld&" from "&targetTbl&" where DelYn = 'N' and userType = 'P' and nowyear < "&year(date)&" and ksportsno in ( "&historysavetarget&" )  )"
				Call db.execSQLRs(SQL , null, ConStr)

				'업데이트 한다.
				SQL = "UPDATE "&targetTbl&" SET "
				'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
				SQL = SQL & "sido = k.SIDO_CD, sidonm = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
				SQL = SQL & ",userPhone=k.PHONE_NO,KSTEAMCD=k.TEAM_CD,KSTEAMNM=k.TEAM_NM,Address1=k.ADDRESS1,Address2=k.ADDRESS2,zipcode=k.ZIPCODE "
				SQL = SQL & "	,Birthday = case when left(k.BIRTH_DT,1) = '0' or left(k.BIRTH_DT,1) = '1' then  '20' + k.BIRTH_DT else '19' +k.BIRTH_DT end ,yearpt=0,yearprice=0 " '포인트초기화
				SQL = SQL & " FROM "&targetTbl&"  ,  " & selectTbl
				SQL = SQL & " where ksportsno  = k.PERSON_NO and delYN = 'N' and userType='P' and k.REG_YEAR = '"&year(Date)&"' " '현재년도
				Call db.execSQLRs(SQL , null, ConStr)

			Else 	'등록되지 않은  선수 존재

				'비등록 선수 저장
				selectQ = "select " & selectFLD & " from " & selectTbl & " where  PERSON_NO not in ( select ksportsno from "&targetTbl&" where  userType = 'P' and DelYN = 'N' ) and  REG_YEAR = '"&year(Date)&"'  "
				SQL = "Insert into " & targetTbl & "( "&targetFld&" ) ("&selectQ&")"
				Call db.execSQLRs(SQL , null, ConStr)


				'히스토리 넣기, nowyear 가 변경되는 것만 넣기
				historysavetarget = "select PERSON_NO from "&selectTbl &" where REG_YEAR = '"&year(date)&"' "
				SQL = "Insert into tblPlayer_history ( "&historyFld&" ) (select "&historyFld&" from "&targetTbl&" where DelYn = 'N' and userType = 'P' and nowyear < "&year(date)&" and ksportsno in ( "&historysavetarget&" )  )"
				Call db.execSQLRs(SQL , null, ConStr)


				'나머지 선수들 업데이트
				SQL = "UPDATE "&targetTbl&" SET "
				'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
				SQL = SQL & "sido = k.SIDO_CD, sidonm = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
				SQL = SQL & ",userPhone=k.PHONE_NO,KSTEAMCD=k.TEAM_CD,KSTEAMNM=k.TEAM_NM,Address1=k.ADDRESS1,Address2=k.ADDRESS2,zipcode=k.ZIPCODE "
				SQL = SQL & "	,Birthday = case when left(k.BIRTH_DT,1) = '0' or left(k.BIRTH_DT,1) = '1' then  '20' + k.BIRTH_DT else '19' +k.BIRTH_DT end ,yearpt=0,yearprice=0 " '포인트초기화
				SQL = SQL & " FROM "&targetTbl&"  ,  " & selectTbl
				SQL = SQL & " where ksportsno  = k.PERSON_NO and delYN = 'N' and userType='P' and k.REG_YEAR = '"&year(Date)&"' " '현재년도
				Call db.execSQLRs(SQL , null, ConStr)

			End If




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
