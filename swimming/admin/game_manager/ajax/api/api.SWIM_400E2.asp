<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<!-- #include virtual = "/pub/fn/fn.swjudge.asp" -->
<%
'#############################################
'/game_manager/pages/list.asp 
'대회 종목 리스트
'#############################################

	req_lidx = isNulldefault(oJSONoutput.Get("LIDX"),"") '직접호출할경우만(대회번호)

	If req_lidx = "" Then

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치

		If cda = "E2" then
		lidx = 11377
		Else
		lidx = 12563
		End if


'		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
'		Call oJSONoutput.Set("servermsg", "채점하실 부를 선택해 주십시오." ) '서버에서 메시지 생성 전달
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.end
	else
		lidx = req_lidx

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치

		'Call oJSONoutput.Set("Cookies", oCookies ) 'test 값 확인에 사용
	End if



	Set db = new clsDBHelper

	'기본정보 호출
	booinfo = getBooInfo(lidx, db, ConStr, CDA)
	grouplevelidx = booinfo(0) '그룹 묶음 
	RoundCnt =  booinfo(1)'라운드수
	judgeCnt =  booinfo(2)'심사위원수
	lidxs = booinfo(3)
	cdc = booinfo(4)
	'tidx = booinfo(5)


	'다이빙
	fld = " b.gameno "
	fld = fld & " ,c.gameround as r_roundno "
	fld = fld & " ,a.tryoutsortNo as orderno "

	fld = fld & " ,(select code1 from tblgamecode where seq =  c.gamecodeseq) as div_divno " '다이브번호
	fld = fld & " ,'' as arti_difficutyno " '난이도번호

	fld = fld & " ,a.itgubun "
	fld = fld & " ,a.gameMemberIDX as midx "
	fld = fld & " ,case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else a.username end as names"  '파트너 있을때 단체일때 이름
	fld = fld & " ,case when a.itgubun = 'T' then (SELECT count(*) from SD_gameMember_partner where gamememberidx = a.gamememberidx) else 1 end as membercnt "  '맴버카운트
	fld = fld & " ,a.CDBNM "
	fld = fld & " ,a.CDC "
	fld = fld & " ,a.CDCNM "
	fld = fld & " ,a.tryoutresult as resultstr "
	fld = fld & " ,a.TeamNm as team "
	fld = fld & " , case when b.Sexno = 1 then '남자' when b.sexno = 2 then '여자' else '혼성'  end as sexstr "
	fld = fld & " ,a.sidonm  "

	fld = fld & " ,c.idx as r_idx  "
	fld = fld & " ,c.lidx as r_lidx  "

	fld = fld & " ,c.jumsu"&jno&"  as jumsu "
	fld = fld & " ,c.name"&jno&"  as jname "
	fld = fld & " ,c.jidx"&jno&"  as jidx "
	fld = fld & " ,c.jidx"&jno&"  as jidx "		


	'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
	tbl = " SD_gameMember as a inner join tblRGameLevel as b  ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and b.delYN = 'N'  inner join sd_gameMember_roundRecord as c on a.gamememberidx = c.midx "
	
	If grouplevelidx = "0" Then '단독운영 / 묶음 운영
		sortstr = " c.gameround, a.tryoutsortno asc "
	else
		sortstr =  "c.gameround, b.gameno, a.tryoutsortno asc "
	End If	
	
	'c.rounding 500에서 확인한다 리스트 확인용이므로 주면안됨
	SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.jumsu"&jno&"	 is Null " '심사하지 않은것만 보이게
	SQL = SQL & " and a.gubun in (1,3) and a.tryoutsortno > 0 and a.tryoutResult < 'a' "				'불참제외
	SQL = SQL & " order by " & sortstr  
	'** 다이빙 다음선수가 준비 되지 않았다면 빈리스트를 보낸다.
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If Not rs.EOF Then
		'배열로 화면 확인
		'arrR = rs.GetRows()
		'Call oJSONoutput.Set("list", arrR ) '배열

		cdbnm = rs("CDBNM")
		cdc = rs("CDC")
		cdcnm = rs("CDCNM")
		jname = rs("jname")
		gameround = rs("r_roundno")

		Select Case Left(cdcnm,5)
		Case "플렛포옴다" : CDCICON = 1
		Case "스프링보오" : CDCICON = 2
		Case "스프링다이" : CDCICON = 3
		Case "싱크로다이" : CDCICON = 4
		Case Else 
			Select Case Left(cdcnm,2)
			Case "솔로" : CDCICON = 5
			Case "듀엣" : CDCICON = 5
			Case "팀(" : CDCICON = 5
			Case "테크" : CDCICON = 6
			Case "프리" : CDCICON = 7
			End Select
		End Select 


		judgepartname = jno
		fullname = ""

		rsobj =  jsonTors_arr(rs)
		objstr = "{""list"": "&rsobj&",""result"":0}"

		Set oJSONoutput = JSON.Parse( join(array(objstr)) )
		Call oJSONoutput.Set("cdbnm", cdbnm ) 
		Call oJSONoutput.Set("cdc", cdc ) 
		Call oJSONoutput.Set("cdcnm", cdcnm ) 
		Call oJSONoutput.Set("jname", jname )
		Call oJSONoutput.Set("cdcicon", CDCICON )
		Call oJSONoutput.Set("judgepartname", judgepartname )
		Call oJSONoutput.Set("fullname", fullname )		



		'Call oJSONoutput.Set("sql", sql ) 
		'Call oJSONoutput.Set("jno", jno ) '배열		




		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

	Else
		Call oJSONoutput.Set("list", array() ) '정상
		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End If

	Response.end
%>

