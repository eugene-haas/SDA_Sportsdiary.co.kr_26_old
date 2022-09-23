<%
'#############################################
'체육회 팀정보를 불러온다
'#############################################
	
	'request
	'If hasown(oJSONoutput, "TIDX") = "ok" Then 
	'	tidx = oJSONoutput.TIDX
	'End If

	Set db = new clsDBHelper 

	'공통 ###########################################
		'table
		selectTbl = "KoreaBadminton_Info.dbo.tblES_team_info as k"
		targetTbl = "tblTeamInfo"


		'최초 등록된 정보 인서트
		SQL = "Select top 1 TeamIDX from " & targetTbl
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof then

			'조인 업데이트 해야하겠지		(폰정보가 처음에 잘안들어가져있다. 이름으로 해보자) 19년도 20년도순으로 두번넣자.

			SQL = "update "&targetTbl& " set "
			SQL = SQL & "	TEAMCD = k.TEAM_CD "
			SQL = SQL & "	,PHONE = k.PHONE_NO "
			SQL = SQL & "	,Sex = k.SEX "
			SQL = SQL & "	,SIDO = k.SIDO_CD "
			SQL = SQL & "	,SIDONM = (select top 1 SidoNm from tblSidoInfo where  sido = k.SIDO_CD ) "
			SQL = SQL & "	,ZIPCODE = k.ZIPCODE "
			SQL = SQL & "	,ADDRESS1 = k.ADDRESS1 "
			SQL = SQL & "	,ADDRESS2 = k.ADDRESS2 "
			SQL = SQL & "	,MADE_DT = k.MADE_DT "
			SQL = SQL & "	,HEAD_NM = k.HEAD_NM "
			SQL = SQL & "	,LEADER_NM = k.LEADER_NM "
			SQL = SQL & " from SD_Riding.dbo."&targetTbl&" as a inner join "&selectTbl&" "
			SQL = SQL & " on a.TeamNM = k.TEAM_NM  "
			'Call db.execSQLRs(SQL , null, ConStr)	

			'테스트 대회에 넣었던 멤버들 삭제
			'SQL = "Delete From tblPlayer_test Where playeridx In (Select a.playeridx from tblPlayer_test as a inner join sd_TennisMember as b on a.PlayerIDX = b.PlayerIDX where a.MemberIDX <> '' ) "
			'Call db.execSQLRs(SQL , null, ConStr)

			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.end

		Else


			SQL = "Select top 1 TEAM_CD from " & selectTbl & " where TEAM_CD not in ( select Team from "&targetTbl&" where team is not null ) " '등록되지 않은 지도자가 있다면
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof Then '모두 등록된 지도자임

				'업데이트 한다.
				SQL = "UPDATE "&targetTbl&" SET "
				'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
				SQL = SQL & "sido = k.SIDO_CD, sidonm = (select top 1 sidonm from tblsidoinfo where sidonm = k.SIDO_CD) "
				SQL = SQL & ",phone=k.PHONE_NO,teamnm=k.TEAM_NM,Address1=k.ADDRESS1,Address2=k.ADDRESS2,zipcode=k.ZIPCODE "	
				SQL = SQL & " FROM "&targetTbl&"  ,  " & selectTbl
				SQL = SQL & " where team  = k.TEAM_CD " 'and k.REG_YEAR = '"&year(Date)&"' " '현재년도
				Call db.execSQLRs(SQL , null, ConStr)

			Else 	'등록되지 않은 지도자가 있다면
				insertFLD = " Team,TeamNm,sido,sidoNM,sex,ZipCode,Address1,Address2,phone,MADE_DT,EnterType,HEAD_NM,LEADER_NM "

				selectFLD = " TEAM_CD,TEAM_NM,SIDO_CD, (select top 1 sidonm from tblsidoinfo where sido = k.sido_cd) As sidonm "
				selectFLD = selectFLD & ",SEX,ZIPCODE,ADDRESS1,ADDRESS2 "
				selectFLD = selectFLD & ",PHONE_NO,MADE_DT,'E',HEAD_NM,LEADER_NM"

				selectQ = "select " & selectFLD & " from " & selectTbl & " where  TEAM_CD not in ( select Team from "&targetTbl&"  ) "
				SQL = "Insert into " & targetTbl & "( "&insertFLD&" ) ("&selectQ&")" 
				Call db.execSQLRs(SQL , null, ConStr)


				'업데이트 한다.
				SQL = "UPDATE "&targetTbl&" SET "
				'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
				SQL = SQL & "sido = k.SIDO_CD, sidonm = (select top 1 sidonm from tblsidoinfo where sidonm = k.SIDO_CD) "
				SQL = SQL & ",phone=k.PHONE_NO,teamnm=k.TEAM_NM,Address1=k.ADDRESS1,Address2=k.ADDRESS2,zipcode=k.ZIPCODE "	
				SQL = SQL & " FROM "&targetTbl&"  ,  " & selectTbl
				SQL = SQL & " where team  = k.TEAM_CD " 'and k.REG_YEAR = '"&year(Date)&"' " '현재년도
				Call db.execSQLRs(SQL , null, ConStr)
			End If


		End if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>