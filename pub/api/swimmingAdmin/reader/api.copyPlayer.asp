<%
'#############################################
'temp 데이터를 request 테이블에 밀어넣는다.

'중복제거 코드+팀으로  (한명이 여러팀의 리더일수 있다, 한팀에 여러명의 리더가 있을수 있다)
'select * from tblReader  where playeridx in (  select c.playeridx from (   select ROW_NUMBER() over( partition by a.kskey +team order by a.playeridx desc) RN, a.playeridx,a.username,a.startyear from tblReader a ) c  where c.RN > 1  )


'중복 1을 빼거 삭제하는 쿼리
'delete from tblReader  where playeridx in (  select c.playeridx from (   select ROW_NUMBER() over( partition by a.kskey +team order by a.playeridx desc) RN, a.playeridx,a.username,a.startyear from tblReader a ) c  where c.RN > 1  )



'리더는 여러팀을 관리할수 있다 ...한년도에 여러 개가 들어가진다.
'한팀에 여러명의 코치가 있을수 있다 이것도 고려되어야한다. 21.03.11 황동현 요청
'#############################################
	Set db = new clsDBHelper

	'공통 ###########################################
		'table
		selectTbl = "KoreaBadminton_Info.dbo.tblSW_reader_info as k"
		insertTbl = "ks_swimming.dbo.tblReader"


		selectFLD = "PERSON_NO,REG_YEAR,GUBUN,KOR_NM,CHN_NM,ENG_NM,BIRTH_DT"
		selectFLD = selectFLD & ",Case When SEX = 'M' then '1' else '2' end "
		selectFLD = selectFLD & ",SIDO_CD,(select top 1 sidonm from tblsidoinfo where sido = k.sido_cd) As sidonm"
		selectFLD = selectFLD & ",MOBILE_NO,TEAM_CD,TEAM_NM,ADDRESS1,ADDRESS2,ZIPCODE,E_MAIL"
	'공통 ###########################################


	'상태검사
	SQL = "Select startyear from tblReader"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then

		insertFLD =  " kskey,startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,UserPhone,Team,teamnm,addr1,addr2,zipcode,email "
		selectQ = "select " & selectFLD & " from " & selectTbl

		SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")"
		Call db.execSQLRs(SQL , null, ConStr)

	Else

		'SQL = "Select top 1 PERSON_NO from " & selectTbl & " where REG_YEAR = '"&year(date)&"' and  PERSON_NO not in ( select kskey  from tblReader group by kskey,startyear,team  ) " '등록되지 않은 지도자가 있다면
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'If rs.eof Then '모두 등록된 지도자임


			'한팀에 여러명의 코치가 있을수 있다 이것도 고려되어야한다. 21.03.11 황동현 요청

			insertFLD =  " kskey,startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,UserPhone,Team,teamnm,addr1,addr2,zipcode,email "
			selectQ = ""
			selectQ = selectQ & "select " & selectFLD &" from "& selectTbl &" where REG_YEAR = '"&year(date)&"'  "
			'selectQ = selectQ & " and (  PERSON_NO not in (select kskey  from tblReader where startyear = '"&year(date)&"' group by kskey)  "
			'selectQ = selectQ & " or TEAM_CD not in (select team  from tblReader where startyear = '"&year(date)&"' group by kskey,startyear,team)   ) "
			selectQ = selectQ & " and ( PERSON_NO+TEAM_CD not in (select kskey+ team  from ks_swimming.dbo.tblReader where startyear = "&year(date)&" group by kskey,team) )"

			SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")"
			Call db.execSQLRs(SQL , null, ConStr)


			'업데이트 한다.
			SQL = "UPDATE "&insertTbl&" SET "
			'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
			SQL = SQL & "sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
			SQL = SQL & ",UserPhone=k.MOBILE_NO,addr1=k.ADDRESS1,addr2=k.ADDRESS2,zipcode=k.ZIPCODE,email=k.E_MAIL"
			SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
			SQL = SQL & " where kskey  = k.PERSON_NO and  startyear = k.REG_YEAR and team = k.TEAM_CD and k.REG_YEAR = '"&year(Date)&"' " '현재년도
			Call db.execSQLRs(SQL , null, ConStr)

		'Else 	'등록되지 않은 지도자가 있다면
		'
		'	insertFLD =  " kskey,startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,UserPhone,Team,teamnm,addr1,addr2,zipcode,email "
		'	selectQ = ""
		'	selectQ = selectQ & "select " & selectFLD &" from "& selectTbl &" where REG_YEAR = '"&year(date)&"'  "
		'	selectQ = selectQ & " and (  PERSON_NO not in (select kskey  from tblReader where startyear = '"&year(date)&"' group by kskey,startyear,team)  "
		'	selectQ = selectQ & " or REG_YEAR not in (select startyear  from tblReader where startyear = '"&year(date)&"' group by kskey,startyear,team)  "
		'	selectQ = selectQ & " or TEAM_CD not in (select team  from tblReader where startyear = '"&year(date)&"' group by kskey,startyear,team)   ) "
		'
		'	SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")"
		'	Call db.execSQLRs(SQL , null, ConStr)
		'
		'
		'	'업데이트 한다.
		'	SQL = "UPDATE "&insertTbl&" SET "
		'	SQL = SQL & "sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
		'	SQL = SQL & ",UserPhone=k.MOBILE_NO,addr1=k.ADDRESS1,addr2=k.ADDRESS2,zipcode=k.ZIPCODE,email=k.E_MAIL"
		'	SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
		'	SQL = SQL & " where kskey  = k.PERSON_NO and  startyear = k.REG_YEAR and team = k.TEAM_CD and k.REG_YEAR = '"&year(Date)&"' " '현재년도
		'	Call db.execSQLRs(SQL , null, ConStr)
		'End If

    End if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
