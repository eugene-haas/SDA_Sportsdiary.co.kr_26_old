<%
'#############################################
'리더정보 갱신
'#############################################
	Set db = new clsDBHelper 

	'공통 ###########################################
		'table
		selectTbl = "KoreaBadminton_Info.dbo.tblES_reader_info as k"
		insertTbl = "tblLeader"

	
		selectFLD = "PERSON_NO,REG_YEAR,GUBUN,KOR_NM,CHN_NM,ENG_NM,BIRTH_DT"
		selectFLD = selectFLD & ",SEX "
		selectFLD = selectFLD & ",SIDO_CD,(select top 1 sidonm from tblsidoinfo where sido = k.sido_cd) As sidonm"
		selectFLD = selectFLD & ",MOBILE_NO,TEAM_CD,TEAM_NM,ADDRESS1,ADDRESS2,ZIPCODE,E_MAIL,KIND_CD"	
	'공통 ###########################################


	'상태검사
	SQL = "Select startyear from tblLeader"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If rs.eof Then

		'SQL = "delete from tblReader"
		'Call db.execSQLRs(SQL , null, ConStr)

		insertFLD =  " ksportsno,startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,UserPhone,Team,teamnm,addr1,addr2,zipcode,email,CDB "
		selectQ = "select " & selectFLD & " from " & selectTbl 
		
		SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")" 
		Call db.execSQLRs(SQL , null, ConStr)

	Else

		SQL = "Select top 1 PERSON_NO from " & selectTbl & " where PERSON_NO not in ( select ksportsno from tblLeader ) " '등록되지 않은 지도자가 있다면
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then '모두 등록된 지도자임

			'업데이트 한다.
			SQL = "UPDATE "&insertTbl&" SET "
			'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
			SQL = SQL & "sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
			SQL = SQL & ",UserPhone=k.MOBILE_NO,team=k.TEAM_CD,teamnm=k.TEAM_NM,addr1=k.ADDRESS1,addr2=k.ADDRESS2,zipcode=k.ZIPCODE,email=k.E_MAIL,CDB=k.KIND_CD"	
			SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
			SQL = SQL & " where ksportsno  = k.PERSON_NO and k.REG_YEAR = '"&year(Date)&"' " '현재년도

		Else 	'등록되지 않은 지도자가 있다면
			
			insertFLD =  " ksportsno,startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,UserPhone,Team,teamnm,addr1,addr2,zipcode,email,CDB "
			selectQ = "select " & selectFLD & " from " & selectTbl & " where  PERSON_NO not in ( select ksportsno from tblLeader  ) "
			SQL = "Insert into " & insertTbl & "( "&insertFLD&" ) ("&selectQ&")" 
			Call db.execSQLRs(SQL , null, ConStr)


			'업데이트 한다.
			SQL = "UPDATE "&insertTbl&" SET "
			'SQL = SQL & " 테이블명A.필드명 = 테이블명B.필드명 "
			SQL = SQL & "sidocode = k.SIDO_CD, sido = (select top 1 sidonm from tblsidoinfo where sido = k.SIDO_CD) "
			SQL = SQL & ",UserPhone=k.MOBILE_NO,team=k.TEAM_CD,teamnm=k.TEAM_NM,addr1=k.ADDRESS1,addr2=k.ADDRESS2,zipcode=k.ZIPCODE,email=k.E_MAIL,CDB=k.KIND_CD"	
			SQL = SQL & " FROM "&insertTbl&"  ,  " & selectTbl
			SQL = SQL & " where ksportsno  = k.PERSON_NO and k.REG_YEAR = '"&year(Date)&"' " '현재년도
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