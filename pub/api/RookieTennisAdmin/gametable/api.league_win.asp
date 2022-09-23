<%
'#############################################
'리그 승패 결정
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
levelno = oJSONoutput.S3KEY
winidx = oJSONoutput.WINIDX 'gamememberidx
nowcourtidx = oJSONoutput.NOWCTNO

midx1 = oJSONoutput.MIDX1
midx2 = oJSONoutput.MIDX2
ridx = oJSONoutput.RIDX

jono = oJSONoutput.JONO


Set db = new clsDBHelper

strtable = " sd_TennisMember "
strtablesub =" sd_TennisMember_partner "
strtablesub2 = " tblGameRequest "
strresulttable = " sd_TennisResult "


Sub setWinf(midx1, midx2,winidx, cancel)
	Dim SQL	,WL
	If cancel = True Then '취소
		WL = "-"
	Else
		WL = "+"
	End If
	
	If CDbl(midx1) = CDbl(winidx) Then
		SQL = "update sd_tennisMember Set t_win = t_win "&WL&" 1 where  gameMemberIDX = " & midx1 & " and t_win "&WL&" 1 >=0  "
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "update sd_tennisMember Set t_lose = t_lose "&WL&" 1 where  gameMemberIDX = " & midx2 & " and  t_lose "&WL&" 1  >=0 "
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		SQL = "update sd_tennisMember Set t_win = t_win "&WL&" 1 where  gameMemberIDX = " & midx2 & " and t_win "&WL&" 1 >=0  "
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "update sd_tennisMember Set t_lose = t_lose "&WL&" 1 where  gameMemberIDX = " & midx1 & " and t_lose "&WL&" 1 >=0 "
		Call db.execSQLRs(SQL , null, ConStr)
	End If
End sub


If CDbl(ridx) = 0 Then '결과값확인 (코트값이 없을때 넘어옴 		'?? 코트 반환X)

		StateNo = 1 ' 0 진행중, 1 경기종료, 2 경기진행중 (테블릿 입력과 관련된건데 써야할까?)
		Preresult = "ADMIN"
		insertfield = " gameMemberIDX1,gameMemberIDX2,winIDX,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno " 'gubun 0 예선 1 본선
		insertvalue = " "&midx1&","&midx2&","&winidx&", "&StateNo&",0,getdate(),'운영자','"&Preresult&"','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & jono  
		SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)

		'조의 인원 별 승패를 파악해서 1등 2등을 셋팅하고 리그에 복사할 필요까지가 있을까?
		'조의 인원파악및 승패 내역 파악
		'sd_tennisMember 에  t_win t_lose 를 사용하여 승패 정보를 예선 대진표에 보여주자. (update )

		'반영된 승패 업데이트 ###############



		Call setWinf(midx1, midx2,winidx, false)
		'반영된 승패 업데이트 ###############

else
		'결과가 있고 승자가 같다면 취소
		SQL  = "select winidx from sd_TennisResult where resultIDX = " & ridx & " and winidx = '"&winidx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then

			SQL  = "select winidx,* from sd_TennisResult where resultIDX = " & ridx
			Set rsp = db.ExecSQLReturnRS(SQL , null, ConStr)

		'	If USER_IP = "118.33.86.240" Then
		'		Call rsdrow(rsp)
		'		Response.end
		'	End if					

			winidxval = rsp("winidx")
			If winidxval = "" Or isnull(winidxval) = True  Then
			
			else
				'이전 winidx 값을 가지고
				'반영된 승패 우선차감 ###############
				Call setWinf(midx1, midx2,winidxval, true)
				'반영된 승패 업데이트 ###############
			End if

			SQL = "Update sd_TennisCourt Set courtstate = 0 where idx =  (select top 1 courtno from sd_TennisResult where resultIDX = " & ridx & " )"
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "Update sd_TennisResult Set winIDX = "&winidx&",stateno = 1,preresult='ADMIN' where resultIDX = " & ridx
			Call db.execSQLRs(SQL , null, ConStr)

			'반영된 승패 업데이트 ###############
			Call setWinf(midx1, midx2,winidx, false)
			'반영된 승패 업데이트 ###############


		Else '결과가 있고 승자가 같다면취소
			SQL = "delete from sd_TennisResult  where resultIDX = " & ridx
			Call db.execSQLRs(SQL , null, ConStr)
			
			'반영된 승패 업데이트 ###############
			Call setWinf(midx1, midx2,winidx,true)
			'반영된 승패 업데이트 ###############

		End if
End if


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>