<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
		'For intloop = 0 To oJSONoutput.PARR.length-1
		'   Response.write  reqArr.Get(intloop) & "<br>"
		'Next
		'Response.end

		code1 = reqArr.Get(0)   '-- 종목코드
		codeIT = reqArr.Get(1) '--개인/단체 (I / T)
		sexno = reqArr.Get(2)  '--남자/ 여자 / 혼성
		boocode = reqArr.Get(3)  '--초등부 ...X 1,23,3....a,b,c,!,@..
		boodetailcode = reqArr.Get(4) '세부 종목 코드
		tidx = reqArr.Get(5)
	End if

	Set db = new clsDBHelper 




		'단계 1
			SQL = "Select pteamgb,Pteamgbnm,pteamgbengnm, teamgb,teamgbnm,cd_mcnt from tblTeamGbInfo where cd_type='1' and delyn = 'N' and pteamgb = '"&code1&"' and Teamgb = '"&boodetailcode&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Call rsdrow(rs)
'Response.end

			cd_ano = rs(0)
			cd_anm = rs(1)
			cd_anm_e = rs(2)
			cd_cno = rs(3)
			cd_cnm = rs(4)
			codeIT = rs(5) 'itgubun


			Select Case Left(boocode,2)
			Case "유년","초등" : schoolno = 1
			Case "중학" : schoolno = 2
			Case "고등" : schoolno = 3
			Case "대학" : schoolno = 4
			Case "일반" : schoolno = 5
			End Select 

			SQL = "select cd_boo,cd_booNm,cd_booNm_short,cd_booLevelno,sexno,orderby   from  tblTeamGbInfo  where cd_boo = '"&boocode&"' and cd_type = '2' and DELYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			If rs.eof Then
				'SQL = "Select  max(cd_boo)  from tblTeamGbInfo cd_type = '2' and DELYN = 'N' "
				'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				'cd_bno = CDbl(rs(0)) + 1
				'
				'SQL = "SET NOCOUNT ON  insert into tblTeamGbInfo (cd_type,cd_boo,cd_boonm,cd_booLevelno,sexno )  values  (2, "&cd_bno&", '"&cd_bnm&"',  '"&schoolno&"' ) "
				'Call db.execSQLRs(SQL , null, ConStr)
				'
				'cd_bnm_s = ""
				'cd_bno_m = schoolno
			else
				cd_bno = rs(0) 'A~;  *A~
				cd_bnm = rs(1)
				cd_bnm_s = rs(2)   '단축명
				cd_bno_m = rs(3)   '1~9 번까지 초등~ 성인
				cd_sexno = rs(4)
				cd_orderby = rs(5)
			End If

			levelno = cd_ano & cd_bno & cd_cno
			SQL = "select teamgbidx from  tblTeamGbInfo  where levelno = '"&levelno&"' and cd_type = '3' and DELYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'단계 2없다면 insert 자료 만들기
			If rs.eof Then
				SQL = "SET NOCOUNT ON  insert into tblTeamGbInfo ( cd_type, pteamgb,Pteamgbnm,pteamgbengnm,cd_boo,cd_boonm,cd_boonm_short,cd_boolevelno,teamgb,teamgbnm,levelno,sexno,cd_mcnt,orderby) values "
				SQL = SQL & "(3, '"&cd_ano&"', '"&cd_anm&"', '"&cd_anm_e&"', '"&cd_bno&"', '"&cd_bnm&"', '"&cd_bnm_s&"', '"&cd_bno_m&"', '"&cd_cno&"', '"&cd_cnm&"', '"&levelno&"', '"&sexno&"','"&codeIT&"','"&cd_orderby&"')  SELECT @@IDENTITY"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				gbidx = rs(0)
			Else
				gbidx = rs(0)
			End If
			

		'등록여부 확인 동일 부서 확인
			SQL = "select  levelno from tblRGameLevel where GameTitleIDX = '"&tidx&"' and gbidx = '"&gbidx&"' and delyn = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				Call oJSONoutput.Set("result", 2)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
			Response.end
			End if


		'단계 3 최종 저장
			insertfield = " GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno "
			insertvalue = " '"&tidx&"','"&gbidx&"','"&sexno&"','"&codeIT&"','"&cd_ano&"','"&cd_anm&"','"&cd_bno&"','"&cd_bnm&"','"&cd_cno&"','"&cd_cnm&"','"&levelno&"'   "

			SQL = "SET NOCOUNT ON INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES " 'confirm 확인여부
			SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			idx = rs(0)

			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>