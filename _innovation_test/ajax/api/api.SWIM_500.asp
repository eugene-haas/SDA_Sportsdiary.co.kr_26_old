<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->


<%
'#############################################
'라운드 입력폼
'#############################################

	req_ridx = isNulldefault(oJSONoutput.Get("RIDX"),"") '라운드인덱스
	req_cdc = isNulldefault(oJSONoutput.Get("CDC"),"")

	If req_ridx = "" Then

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치


		If cda = "E2" then
		ridx = 681
		cdc = "01"
		Else
		ridx = 3576
		cdc = "04"
		End if


'		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
'		Call oJSONoutput.Set("servermsg", "채점하실 부를 선택해 주십시오." ) '서버에서 메시지 생성 전달
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.end
	else
		ridx = req_ridx

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치
		cdc = req_cdc

		'Call oJSONoutput.Set("Cookies", oCookies ) 'test 값 확인에 사용
	End if

	Select Case cda
	Case "E2" 
	%><!-- #include virtual = "/pub/fn/fn.swjudge.asp" --><%
	Case "F2" 
	%><!-- #include virtual = "/pub/fn/fn.swjudge.F2.asp" --><%
	End Select 


	Set db = new clsDBHelper

	'기본정보 호출
	SQL = "Select judgeCnt,roundCnt,gameround from sd_gameMember_roundRecord as a inner join tblRGameLevel as b on a.lidx = b.RGameLevelidx where idx = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	judgecnt = rs(0)
	roundcnt = rs(1)
	gameround = rs(2)


	'다이빙
	Select Case cda
	Case "E2"

		fld = ""
		fld = fld & " b.gameround as r_roundno "
		fld = fld & " ,a.tryoutsortNo as orderno "
		fld = fld & " ,case when a.itgubun = 'I' then '개인' else '단체' end as itgubun "
		fld = fld & " ,a.gameMemberIDX as midx "
		fld = fld & " ,case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else a.username end as names"  '파트너 있을때 단체일때 이름가져오기
		fld = fld & " ,a.CDBNM "
		fld = fld & " ,a.CDC "
		fld = fld & " ,a.CDCNM "

		 fld = fld & " ,(case when left(CDCNM,5) = '플렛포옴다' then '1' "
		 fld = fld & "  when left(CDCNM,5) = '스프링보오' then '2' "
		 fld = fld & "  when left(CDCNM,5) = '스프링다이' then '3' "
		 fld = fld & "  when left(CDCNM,5) = '싱크로다이' then '4' "

		 fld = fld & "  when left(CDCNM,2) = '솔로' then '5' " '피겨
		 fld = fld & "  when left(CDCNM,2) = '듀엣' then '5' "
		 fld = fld & "  when left(CDCNM,1) = '팀' then '5' "
		 fld = fld & "  when left(CDCNM,2) = '테크' then '6' "
		 fld = fld & "  when left(CDCNM,2) = '프리' then '7' else '' end) as CDCICON "

		fld = fld & " ,case when a.tryoutresult >= 'a' then 'Y' else 'N' end as isdisabled " '실격 다음맴버
		fld = fld & " ,b.rounding as roundstate " '라운드 진행상태

		fld = fld & " ,b.totalscore as roundscore " '라운드총점 (모든심판입력)
		fld = fld & " ,a.TeamNm as team "
		fld = fld & " ,a.sidonm  "

		fld = fld & " ,b.idx as r_idx  "
		fld = fld & " ,b.lidx as r_lidx  "

		fld = fld & " ,c.codename as div_divname  " '다이브명
		fld = fld & " ,c.code1 as div_divno  " '다이브번호
		fld = fld & " ,c.code3 as div_posture  " '자세
		fld = fld & " ,c.code2 as div_height " '높이
		fld = fld & " ,c.code4 as div_divdifficulty " '난이율

		fld = fld & " ,'' as arti_difficutynoname  " '다이브명
		fld = fld & " ,'' as arti_difficutyno  " '난이도번호
		fld = fld & " ,'' as arti_subcdcnm  " '세부종목상세
		fld = fld & " ,'' as arti_difficulty " '난이도

		fld = fld & " ,b.jumsu"&jno&"  as jumsu "
		fld = fld & " ,b.name"&jno&"  as jname "
		fld = fld & " ,b.jidx"&jno&"  as jidx "

	   'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
	   tbl = " SD_gameMember as a inner join sd_gameMember_roundRecord as b on a.gamememberidx = b.midx  inner join tblgamecode as c on c.seq = b.gamecodeseq "
		SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.idx = " & ridx

	Case "F2"

		fld = ""
		Select Case CDC 
		Case "01","02","03" '피겨
		fld = fld & " case when b.gameround = 1 then '자유종목(1)' when b.gameround = 2 then '자유종목(2)' when b.gameround = 3 then '자유종목(3)' when b.gameround = 4 then '자유종목(4)' when b.gameround = 5 then '프리 루틴' end as r_roundno "
		Case "04","06","12" '테크니컬
		fld = fld & " case when b.gameround < 6 then '테크니컬' when b.gameround = 6 then '프리 루틴-'  end as r_roundno "
		Case Else
		fld = fld & " '프리 루틴.'  as r_roundno "		
		End Select 

		'테크니컬의 엘리먼트 번호
		Select Case CDC 		
		Case "04","06","12" '테크니컬 1,2,3,4,5 라운드에 심판이 엘리먼트일경우.
			If  Cdbl(jno) > judgecnt / 3 * 2 Then
				if Cdbl(gameround) < 6 then
						fld = fld & ", ('E' + cast(b.gameround as varchar))  as inputstr "
				end if
			end if
		case else
		end select 

		Select Case CDC 
		Case "01","02","03" '피겨
			if Cdbl(gameround) = 5 then
					fld = fld & ", 'Y'  as isfree "
			else
					fld = fld & ", 'N'  as isfree "					
			end if

		Case "04","06","12" '테크니컬
			if Cdbl(gameround) = 6 then
					fld = fld & ", 'Y'  as isfree "		
			else
					fld = fld & ", 'N'  as isfree "					
			end if
		Case Else
					fld = fld & ", 'Y'  as isfree "
		End Select 

		fld = fld & " ,a.tryoutsortNo as orderno "
		fld = fld & " ,case when a.itgubun = 'I' then '개인' else '단체' end as itgubun "
		fld = fld & " ,a.gameMemberIDX as midx "
		fld = fld & " ,case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else a.username end as names"  '파트너 있을때 단체일때 이름가져오기
		fld = fld & " ,a.CDBNM "
		fld = fld & " ,a.CDC "
		fld = fld & " ,a.CDCNM "

		fld = fld & " ,(case when left(CDCNM,5) = '플렛포옴다' then '1' "
		fld = fld & "  when left(CDCNM,5) = '스프링보오' then '2' "
		fld = fld & "  when left(CDCNM,5) = '스프링다이' then '3' "
		fld = fld & "  when left(CDCNM,5) = '싱크로다이' then '4' "

		fld = fld & "  when left(CDCNM,2) = '솔로' then '5' " '피겨
		fld = fld & "  when left(CDCNM,2) = '듀엣' then '5' "
		fld = fld & "  when left(CDCNM,1) = '팀' then '5' "
		fld = fld & "  when left(CDCNM,2) = '테크' then '6' "
		fld = fld & "  when left(CDCNM,2) = '프리' then '7' else '' end) as CDCICON "

		fld = fld & " ,case when a.tryoutresult >= 'a' then 'Y' else 'N' end as isdisabled " '실격 다음맴버
		fld = fld & " ,'Y' as roundstate " '라운드 진행상태
		fld = fld & " ,b.totalscore as roundscore " '라운드총점 (모든심판입력)
		fld = fld & " ,a.TeamNm as team "
		fld = fld & " ,a.sidonm  "

		fld = fld & " ,b.idx as r_idx  "
		fld = fld & " ,b.lidx as r_lidx  "

		fld = fld & " ,'' as div_divname  " '다이브명
		fld = fld & " ,'' as div_divno  " '다이브번호
		fld = fld & " ,'' as div_posture  " '자세
		fld = fld & " ,'' as div_height " '높이
		fld = fld & " ,'' as div_difficulty " '난이율

		fld = fld & " ,c.code2 as arti_difficutynoname  " '난이도명
		fld = fld & " ,c.code1 as arti_difficutyno  " '난이도번호
		fld = fld & " ,c.codename as arti_subcdcnm  " '세부종목상세
		fld = fld & " ,c.code4 as arti_difficulty " '난이도



		fld = fld & " ,b.jumsu"&jno&"  as jumsu "
		fld = fld & " ,b.name"&jno&"  as jname "
		fld = fld & " ,b.jidx"&jno&"  as jidx "

	   'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
	   tbl = " SD_gameMember as a inner join sd_gameMember_roundRecord as b on a.gamememberidx = b.midx  inner join tblgamecode as c on c.seq = b.gamecodeseq "
		SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.idx = " & ridx

	End Select 






	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call oJSONoutput.Set("sql", sql ) '정상


	If Not rs.EOF Then
		'배열로 화면 확인
		'arrR = rs.GetRows()
		'Call oJSONoutput.Set("list", arrR ) '배열

		rsobj =  jsonTors_arr(rs)
		objstr = "{""list"": "&rsobj&",""result"":0}"
		Response.write objstr
		Else
		Call oJSONoutput.Set("list", array() ) '정상
		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End If

	Response.end
%>

