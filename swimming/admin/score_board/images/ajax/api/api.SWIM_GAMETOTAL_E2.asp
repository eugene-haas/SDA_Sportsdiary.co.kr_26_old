<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<!-- #include virtual = "/pub/fn/fn.swjudge.asp" -->
<%
'#############################################
'라운드 입력폼
'#############################################
	tidx = isNulldefault(oJSONoutput.Get("TIDX"),"")
	CDA = "E2"
	
	Set db = new clsDBHelper

'현재 진행중인 대회 찾기

'진행중인 대회 리스트 가져오기

  SQL = "select top 1 lidx from  sd_gameMember_roundRecord  where tidx = " & tidx & " and rounding = 'Y' order by idx desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

' Call oJSONoutput.Set("sql", SQL ) '정상
' 		strjson = JSON.stringify(oJSONoutput)
' 		Response.Write strjson
' response.end

  if rs.eof then
    '진행중인 게임 없음
  else
    '진행 중인 lidxs 구하기
    '기본정보 호출
    lidx = rs(0)
    booinfo = getBooInfo(lidx, db, ConStr, CDA)
    grouplevelidx = booinfo(0) '그룹 묶음 
    RoundCnt =  booinfo(1)'라운드수
    judgeCnt =  booinfo(2)'심사위원수
    lidxs = booinfo(3)
    cdc = booinfo(4)
		cdbnm = booinfo(6)
		cdcnm = booinfo(7)
  end if

	'10명까지만 보여줄지 확인 필요

		fld = " a.tryoutsortNo as gameno "
		fld = fld & ",(case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else a.userName end ) as name "   '파트너 있을때 단체일때 이름가져오기
		fld = fld & ",a.TeamNm as team "
		fld = fld & ",a.userClass "
		fld = fld & ", case when a.Sex = 1 then '남자' else '여자' end  as sex "
		fld = fld & ",a.CDANM "
		fld = fld & ",a.CDBNM "
		fld = fld & ",a.CDCNM "
		fld = fld & ",a.tryoutresult as record "
		fld = fld & ",(case when ISNUMERIC(a.tryoutresult) = 1 then a.tryoutresult else (select codeNm from tblCode where gubun = 2 and cda = '"&CDA&"' and code = a.tryoutresult) end ) as record " '제제사유시
		
		fld = fld & ",a.tryouttotalorder as ranking "
		fld = fld & ",(case when b.tryoutgamestarttime = '13:00' then 'PM' else 'AM' end ) as ampm "
		fld = fld & " , '"&RoundCnt&"' as roundcnt "
		fld = fld & ",(SELECT  STUFF(( select ','+ cast(totalscore as varchar) from sd_gameMember_roundRecord where midx = a.gamememberidx for XML path('') ),1,1, '' )) as roundscore "

		
		'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
		tbl = " SD_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N'  "
  
		If grouplevelidx = "0" Then '단독운영 / 묶음 운영
			sortstr = " a.tryoutsortno asc "
		else
			sortstr =  " b.gameno, a.tryoutsortno asc "
		End If	
	SQL = "select "&fld&"  from "&tbl&" where b.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.RgameLevelidx in ( " & lidxs & ") order by " & sortstr
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	'실격인 경우 0 으로 표시되어서 실격표시 하지 않았음. 기본값 0 이므로 표시 여부는 클라이언트에서 판단

	If not rs.EOF Then
		'배열로 화면 확인
		'arrR = rs.GetRows()
		'Call oJSONoutput.Set("list", arrR ) '배열

		rsobj =  jsonTors_arr(rs)
		objstr = "{""list"": "&rsobj&",""CDBNM"":"""&cdbnm&""",""CDCNM"":"""&cdcnm&""",""roundcnt"":"&roundcnt&",""result"":""0""}"
		Response.write objstr
	Else
		Call oJSONoutput.Set("list", array() ) '정상
		Call oJSONoutput.Set("roundcnt", 0 ) 
		Call oJSONoutput.Set("CDBNM", cdcnm ) 
		Call oJSONoutput.Set("CDCNM", cdbnm ) 		
		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End If

	db.Dispose
	Set db = Nothing
%>

