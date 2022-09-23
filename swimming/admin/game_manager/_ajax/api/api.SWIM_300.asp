<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<%
'#############################################
'/game_manager/pages/list.asp 
'대회 종목 리스트
'#############################################

	req_tidx = oJSONoutput.Get("TIDX") '직접호출할경우만(대회번호)

	If req_tidx = "" then
		'Response.write Cookies_adminDecode

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치

		'Call oJSONoutput.Set("Cookies", oCookies ) 'test 값 확인에 사용
	End if


	Set db = new clsDBHelper

	'다이빙
	Select Case cda
	Case "E2"
			fld = " RGameLevelidx as lidx "						'종목키
			
			fld = fld & " ,(ROW_NUMBER() OVER(ORDER BY cast(gameno as int))) as gameno "

			fld = fld & " ,Gbidx "										'종목 코드키
			fld = fld & " ,itgubun "									'개인/단체 (I, T)
			
			cdbnmlist = " (SELECT  STUFF(( select ','+ CDBNM from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx group by CDBNM for XML path('') ),1,1, '' ))"
			fld = fld & " ,"&cdbnmlist&" as CDBNM " '여러부서로 보여줘야함. 참여부(초등부)
			'fld = fld & " ,CDBNM "										'참여부 (초등부)

			fld = fld & " ,CDC "											'경기명칭 (스프링보드 1M)
			fld = fld & " ,CDCNM "										'경기명칭 (스프링보드 1M)

			fld = fld & " ,(case when left(CDCNM,5) = '플렛포옴다' then '1' "
			fld = fld & "  when left(CDCNM,5) = '스프링보오' then '2' "
			fld = fld & "  when left(CDCNM,5) = '스프링다이' then '3' "
			fld = fld & "  when left(CDCNM,5) = '싱크로다이' then '4' "

			fld = fld & "  when left(CDCNM,2) = '솔로' then '5' " '피겨
			fld = fld & "  when left(CDCNM,2) = '듀엣' then '5' "
			fld = fld & "  when left(CDCNM,1) = '팀' then '5' "
			fld = fld & "  when left(CDCNM,2) = '테크' then '6' "
			fld = fld & "  when left(CDCNM,2) = '프리' then '7' else '' end) as CDCICON "

			fld = fld & " , tryoutgamedate  "	'대회일자
			fld = fld & " ,finalgamedate  "		'두번째대회일자 (아티스틱만사용)
			'fld = fld & " ,gameno "									'경기순서번호

			fld = fld & " , isnull(RoundCnt,0) as roundcnt "	'경기라운드수
			fld = fld & " , isnull(judgeCnt,0) as judgecnt "	'경기진행 심판수
			fld = fld & " , grouplevelidx as gidx"							'그룹 대표인덱스 (lidx 대표값)
			'fld = fld & " ,gamecodeidx	"							'난이도 정의 인덱스
			fld = fld & " , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx ) as gcnt " '그룹통합 갯수
			'fld = fld & " ,(SELECT  STUFF(( select ','+ cast(RgameLevelidx as varchar) from tblRGameLevel where (grouplevelidx is not null and grouplevelidx = a.grouplevelidx) or  RgameLevelidx = a.RgameLevelidx group by RgameLevelidx for XML path('') ),1,1, '' )) as lidxs "
			fld = fld & " ,	(select top 1 name1 from sd_gameMember_roundRecord where lidx  =a.RGameLevelidx) as setjudge "
			
			'수구빼고 31
			'strsort = " order by cast(gameno as int) "	

			'#############################
			'오늘날짜에 로그인한 심판위치에 판정이 안된것들만 
			'#############################
			strwhere = " and (tryoutgamedate = '"&Date&"' or finalgamedate = '"&Date&"')  "
			strwhere = strwhere & " and judgecnt > 0 and RoundCnt > 0 " '심판수설정, 라운드수 설정된것들
			'#############################
			
			SQL = ";with tbl as ( "
			SQL = SQL & "select "&fld&" from tblRGameLevel  as a where  delyn = 'N' and gametitleidx = " & tidx  & " and CDA='"&cda&"'  and CDC <> '31' " & strwhere
			SQL = SQL & ")"

			'심판이 설정된것만 , 완료안된것
			SQL = SQL & " select * from tbl as t left join tblRgameLevel_judgeEndCheck as e on t.lidx = e.rgamelevelidx  "
			SQL = SQL & " where  (  gidx is null or gidx = lidx ) and setjudge is not null "
			SQL = SQL & " and (judge_endchk"&jno&" > 0 or judge_endchk"&jno&" is Null) "&strwhere&"  order by  cast(gameno as int)  "  'judge_endchk > 0 종료안되었거나 생성안되었을때만

	Case "F2" '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

			'오늘경기수
			strwhere = " and   ((cdc in ('01','04','06','12') and (tryoutgamedate = '"&Date&"' or finalgamedate = '"&Date&"'))  or (cdc in ('02','03' ,'05','07','11') and finalgamedate = '"&Date&"' ))  "
			strwhere = strwhere & " and judgecnt > 0 and RoundCnt > 0  " '심판수설정, 라운드수 설정된것들
			strwhere = strwhere & " and (select count(lidx) from sd_gameMember_roundRecord where lidx = a.RGameLevelidx and gamecodeseq is null ) = 0 "
			
			SQL = "select count(*) as cnt from tblRGameLevel  as a left join tblRgameLevel_judgeEndCheck as b on a.rgamelevelidx = b.rgamelevelidx  "
			SQL = SQL & " where  delyn = 'N' and gametitleidx = " & tidx  & " and CDA='"&cda&"'  and (  grouplevelidx is null or grouplevelidx = a.RGameLevelidx ) "
			SQL = SQL & " "&strwhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			todaygamecnt = rs(0)

			'남은경기수
			SQL = "select count(*) as cnt from tblRGameLevel  as a left join tblRgameLevel_judgeEndCheck as b on a.rgamelevelidx = b.rgamelevelidx  "
			SQL = SQL & " where  delyn = 'N' and gametitleidx = " & tidx  & " and CDA='"&cda&"'  and (  grouplevelidx is null or grouplevelidx = a.RGameLevelidx ) "

			SQL = SQL & " and (( tryoutgamedate = finalgamedate and (tryoutgamedate = '"&date&"' or finalgamedate = '"&date&"') and (judge_endchk"&jno&" > 0 or judge_endchk"&jno&" is Null)  ) "
			SQL = SQL & " or (tryoutgamedate <> finalgamedate and finalgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) ) " '설명: 날짜가 다르고 두번째(프리의 날짜가 오늘이고 피겨가진행되었거나 안되었을때)
			SQL = SQL & " or (tryoutgamedate <> finalgamedate and tryoutgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) )) "  '프리를 먼저했다고 쳤을때 추가함..
			SQL = SQL & " "&strwhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			todayreavegame = rs(0)
			startnumber = todaygamecnt - todayreavegame




			fld = " a.RGameLevelidx as lidx "						'종목키
			fld = fld & " ,(ROW_NUMBER() OVER(ORDER BY cast(gameno as int))+ "&startnumber&") as gameno "			
			fld = fld & " ,gbidx "											'종목 코드키
			fld = fld & " ,itgubun "										'개인/단체 (I, T)

			cdbnmlist = " (SELECT  STUFF(( select ','+ CDBNM from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx group by CDBNM for XML path('') ),1,1, '' ))"
			fld = fld & ", (case when grouplevelidx is null then CDBNM else "&cdbnmlist&" end ) as CDBNM " '여러부서로 보여줘야함.
			'fld = fld & " ,CDBNM "										'참여부 (초등부)

			fld = fld & " ,CDC "												'경기명칭 (스프링보드 1M)
			fld = fld & " ,CDCNM "											'경기명칭 (스프링보드 1M)

			fld = fld & " ,(case when left(CDCNM,5) = '플렛포옴다' then '1' "
			fld = fld & "  when left(CDCNM,5) = '스프링보오' then '2' "
			fld = fld & "  when left(CDCNM,5) = '스프링다이' then '3' "
			fld = fld & "  when left(CDCNM,5) = '싱크로다이' then '4' "

			fld = fld & "  when left(CDCNM,2) = '솔로' then '5' " '피겨
			fld = fld & "  when left(CDCNM,2) = '듀엣' then '5' "
			fld = fld & "  when left(CDCNM,1) = '팀' then '5' "
			fld = fld & "  when left(CDCNM,2) = '테크' then '6' "
			fld = fld & "  when left(CDCNM,2) = '프리' then '7' else '' end) as CDCICON "

			fld = fld & " , tryoutgamedate  "	'대회일자
			fld = fld & " ,finalgamedate "		'두번째대회일자 (아티스틱만사용)
			'fld = fld & " ,gameno "									'경기순서번호

			fld = fld & " , isnull(RoundCnt,0) as roundcnt "	'경기라운드수
			fld = fld & " , isnull(judgeCnt,0) as judgecnt "	'경기진행 심판수
			fld = fld & " , grouplevelidx "							'그룹 대표인덱스 (lidx 대표값)

			fld = fld & " , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx ) as gcnt " '그룹통합 갯수

		

		'#############################
		'오늘날짜에 로그인한 심판위치에 판정이 안된것들만 (목록에서 뺄지 플레그로 줄지 판단)
		'#############################
		'피겨솔로, 테크 or 피겨듀엣,팀, 프리
		strwhere = " and   ((cdc in ('01','04','06','12') and (tryoutgamedate = '"&Date&"' or finalgamedate = '"&Date&"'))  or (cdc in ('02','03' ,'05','07','11') and finalgamedate = '"&Date&"' ))  "
		strwhere = strwhere & " and judgecnt > 0 and RoundCnt > 0  " '심판수설정, 라운드수 설정된것들
		strwhere = strwhere & " and (select count(lidx) from sd_gameMember_roundRecord where lidx = a.RGameLevelidx and gamecodeseq is null ) = 0 "
		'#############################


		'완료안된것
		SQL = "select "&fld&" from tblRGameLevel  as a left join tblRgameLevel_judgeEndCheck as b on a.rgamelevelidx = b.rgamelevelidx  "
		SQL = SQL & " where  delyn = 'N' and gametitleidx = " & tidx  & " and CDA='"&cda&"'  and (  grouplevelidx is null or grouplevelidx = a.RGameLevelidx ) "

		'두날짜가 다르다면 , 같다면 으로 보일지 말지 결정...	(프리는 동시에 하던지 다음날 하던지 임...)	
		'날짜가 두개 있다.... 날짜가 두개라면 미리 2를 넣어두고. 한개라면 1을 넣어두고 빼자...0이되면 ..완료다.		피겨를 먼제 무조건 하고 프리를 하게 되어있다 구조가. 바뀌면 진행안됨.
		SQL = SQL & " and ( "
		SQL = SQL & "					( tryoutgamedate = finalgamedate and (tryoutgamedate = '"&date&"' or finalgamedate = '"&date&"') and (judge_endchk"&jno&" > 0 or judge_endchk"&jno&" is Null)  ) "
		SQL = SQL & "  or	"
		SQL = SQL & "			(	"
		SQL = SQL & "				(tryoutgamedate < finalgamedate and finalgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) )  or 	"
		SQL = SQL & "				(tryoutgamedate < finalgamedate and tryoutgamedate = '"&date&"' and (judge_endchk"&jno&" = 2 or judge_endchk"&jno&" is Null) )	"
		SQL = SQL & "			)	"
		SQL = SQL & "  or	"
		SQL = SQL & "			(	"
		SQL = SQL & "				(tryoutgamedate > finalgamedate and finalgamedate = '"&date&"' and (judge_endchk"&jno&" = 2 or judge_endchk"&jno&" is Null) )  or 	"
		SQL = SQL & "				(tryoutgamedate > finalgamedate and tryoutgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) )	"
		SQL = SQL & "			)	"
		SQL = SQL & "	)	"

		'SQL = SQL & " or (tryoutgamedate <> finalgamedate and finalgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) ) " '설명: 날짜가 다르고 두번째(프리의 날짜가 오늘이고 피겨가진행되었거나 안되었을때)
		'SQL = SQL & " or (tryoutgamedate <> finalgamedate and tryoutgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) )) "  '프리를 먼저했다고 쳤을때 추가함..
		'SQL = SQL & " or (tryoutgamedate < finalgamedate and finalgamedate = '"&date&"' and (judge_endchk"&jno&" = 1 or judge_endchk"&jno&" is Null) ) " '설명: 날짜가 다르고 두번째(프리의 날짜가 오늘이고 피겨가진행되었거나 안되었을때)
		'SQL = SQL & " or (tryoutgamedate < finalgamedate and tryoutgamedate = '"&date&"' and (judge_endchk"&jno&" = 2 or judge_endchk"&jno&" is Null) )) "  '프리를 먼저했다고 쳤을때 추가함..		
		SQL = SQL & " "&strwhere&" order by  cast(gameno as int)  "  'judge_endchk > 0 종료안되었거나 생성안되었을때만

	End Select 

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		  ' Call oJSONoutput.Set("sql", sql ) '정상
		  ' strjson = JSON.stringify(oJSONoutput)
		  ' Response.Write strjson
		  ' response.end


	If Not rs.EOF Then
		'배열로 화면 확인
		'arrR = rs.GetRows()
		'Call oJSONoutput.Set("todaygamecnt", arrR ) '배열

		rsobj =  jsonTors_arr(rs)
		objstr = "{""list"": "&rsobj&",""result"":0}"

		Set oJSONoutput = JSON.Parse( join(array(objstr)) )
'Call oJSONoutput.Set("sql", sql ) 'debug
'Call oJSONoutput.Set("todaygamecnt", todaygamecnt ) 
'Call oJSONoutput.Set("todayreavegame", todayreavegame ) 
'Call oJSONoutput.Set("startnumber", startnumber ) 

 

		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		'Response.write objstr
	Else
'Call oJSONoutput.Set("sql", sql ) 'debug
		Call oJSONoutput.Set("list", array() ) '정상
		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		'Response.end	
	End If





	'Call oJSONoutput.Set("result", "0" ) '정상
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson
	Response.end
%>


