<%
'#############################################

'대회 정보 수정

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR 

		code1 = reqArr.Get(0)   '-- 종목코드
		codeIT = reqArr.Get(1) '--개인/단체 (I / T)
		sexno = reqArr.Get(2)  '--남자/ 여자 / 혼성
		boocode = reqArr.Get(3)  '--초등부 ...
		boodetailcode = reqArr.Get(4) '세부 종목 코드
		tidx = reqArr.Get(5)

		e_idx = reqArr.Get(6)
	End if

	Set db = new clsDBHelper 

		'단계 1
			SQL = "Select pteamgb,Pteamgbnm,pteamgbengnm, teamgb,teamgbnm from tblTeamGbInfo where cd_type='1' and delyn = 'N' and pteamgb = '"&code1&"' and Teamgb = '"&boodetailcode&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			cd_ano = rs(0)
			cd_anm = rs(1)
			cd_anm_e = rs(2)
			cd_cno = rs(3)
			cd_cnm = rs(4)

			Select Case sexno
			Case "3"
				cd_bnm = boocode
			Case "1"
				cd_bnm = "남자" & boocode
			Case "2"
				cd_bnm = "여자" & boocode
			End Select 

			SQL = "select cd_booNm from tblTeamGbInfo where cd_type='2' and delyn='N' and cd_boo = '"&boocode&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				cd_bnm = rs(0)
			End if


			Select Case Left(boocode,2)
			Case "유년","초등" : schoolno = 1
			Case "중학" : schoolno = 2
			Case "고등" : schoolno = 3
			Case "대학" : schoolno = 4
			Case "일반" : schoolno = 5
			End Select 

			SQL = "select cd_boo,cd_booNm_short,cd_booLevelno   from  tblTeamGbInfo  where cd_boo = '"&boocode&"' and cd_type = '2' and DELYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof Then
				SQL = "Select  max(cd_boo)  from tblTeamGbInfo cd_type = '2' and DELYN = 'N' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				cd_bno = CDbl(rs(0)) + 1

				SQL = "SET NOCOUNT ON  insert into tblTeamGbInfo (cd_type,cd_boo,cd_boonm,cd_booLevelno,sexno )  values  (2, "&cd_bno&", '"&cd_bnm&"',  '"&sexno&"' ) "
				Call db.execSQLRs(SQL , null, ConStr)

				cd_bnm_s = ""
				cd_bno_m = schoolno
			Else
				cd_bno = rs(0) 'A~;  *A~
				cd_bnm_s = rs(1)   '단축명
				cd_bno_m = rs(2)   '1~9 번까지 초등~ 성인
			End if

			levelno = cd_ano & cd_bno & cd_cno
			SQL = "select teamgbidx from  tblTeamGbInfo  where levelno = '"&levelno&"' and cd_type = '3' and DELYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		'단계 2없다면 insert 자료 만들기
			If rs.eof Then
				SQL = "SET NOCOUNT ON  insert into tblTeamGbInfo ( cd_type, pteamgb,Pteamgbnm,pteamgbengnm,cd_boo,cd_boonm,cd_boonm_short,cd_boolevelno,teamgb,teamgbnm,levelno,sexno,cd_mcnt) values "
				SQL = SQL & "(3, '"&cd_ano&"', '"&cd_anm&"', '"&cd_anm_e&"', '"&cd_bno&"', '"&cd_bnm&"', '"&cd_bnm_s&"', '"&cd_bno_m&"', '"&cd_cno&"', '"&cd_cnm&"', '"&levelno&"', '"&sexno&"','"&codeIT&"')  SELECT @@IDENTITY"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				gbidx = rs(0)
			Else
				gbidx = rs(0)
			End If


			'등록여부 확인 동일 부서 확인
'			SQL = "select  levelno from tblRGameLevel where GameTitleIDX = '"&tidx&"' and gbidx = '"&gbidx&"' and delyn = 'N' "
'			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'			If Not rs.eof Then
'				Call oJSONoutput.Set("result", 2)
'				strjson = JSON.stringify(oJSONoutput)
'				Response.Write strjson
'			Response.end
'			End If
	
			'참가 신청자가 있는지 여부 확인
			SQL = "select  GameTitleIDX from tblGameRequest where GameTitleIDX = '"&tidx&"' and gbidx = '"&gbidx&"' and delyn = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				Call oJSONoutput.Set("result", 3)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
			Response.end
			End If





		'업데이트
		 upfld = " CDA = '"&cd_ano&"',CDANM = '"&cd_anm&"',CDB = '"&cd_bno&"',CDBNM = '"&cd_bnm&"',CDC = '"&cd_cno&"',CDCNM = '"&cd_cnm&"',levelno = '"&levelno&"',sexno = '"&sexno&"',ITgubun = '"&codeIT&"'  "

		strSql = "update  tblRGameLevel Set   " & upfld & " where rgamelevelidx = " & e_idx
		Call db.execSQLRs(strSQL , null, ConStr)



		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>