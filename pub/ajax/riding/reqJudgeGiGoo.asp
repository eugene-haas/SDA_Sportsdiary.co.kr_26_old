<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->



<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수

    ' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
	'fnc >> GetOrderType >> fn_riding.asp



Sub orderUpdate( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType) '게임인덱스, 클레스인덱스,  부인덱스, 라운드번호, 순위방식에 따른 타입
	Dim wherestr,SQL , selecttbl, rs,arrP,pcode,bestsc,maxorder,ar,chkrdno, kgame

	'체전여부 확인	
	SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	kgame = rs(0)

	Select Case  orderType 

	Case "MM" '마장마술

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드
						'부별순위 업데이트 (pubcode) 부별업데이트   ROW_NUMBER 'score_total2 종합관찰점수 총합 (tryoutresult 정상 0 기권관련 숫자 100,200...)
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"' and gubun < 100 and ( (tryoutresult  = '0' and score_total > 0) or  (tryoutresult in ('r','e') ) ) " 
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_per end desc,Case when (tryoutresult = '0') then  midval end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
					Next
				End if
			End If
		else
			'부별순위 업데이트 (pubcode) 부별업데이트   ROW_NUMBER
			'Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end desc,Case when (tryoutresult = '0') then  midval end desc
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"' and gubun < 100 and ( (tryoutresult  = '0' and score_total > 0) or  (tryoutresult in ('r','e') ) )  "
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_per end desc,Case when (tryoutresult = '0') then  midval end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		End If

		'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and score_total > 0) or  (tryoutresult in ('r','e') ) )   "
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_per end desc,Case when (tryoutresult = '0') then  midval end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

	Case "C" 'typeC 239

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트 (통합 또는 체전 경기결과 합산에 사용)
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드
						'$$$$$$$$$$$$$$$$
						'부별순위 업데이트 (pubcode) 부별업데이트 
						'부별 소팅해서 인덱스 순으로 가져온다.  tryoutresult  in ( '0','r','e') and score_total > 0 
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') ))  "
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
						'$$$$$$$$$$$$$$$$
					Next
				End if
			End If
		else
			'$$$$$$$$$$$$$$$$
			'부별순위 업데이트 (pubcode) 부별업데이트 
			'부별 소팅해서 인덱스 순으로 가져온다. 
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') )) "
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
			'$$$$$$$$$$$$$$$$
		End If

		'전체순위 업데이트 (각경기별) 전체업데이트 
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') )) "
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)


	End Select 
End Sub


'*** 소팅주의 tryoutresult가 앞에온이유는 이거에 순위를 부여해야해서...꼴지에다..





' http://tennis.sportsdiary.co.kr/pub/ajax/riding/reqJudge.asp?test=t
'############################################
	If request("test") = "t" Then
    REQ = "{""CMD"":901,""TIDX"":45,""GBIDX"":243,""KGAME"":""N"",""TEAMGB"":""20205""}" 
	else
		REQ = request("REQ")
	End if



	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		'Set oJSONoutput = JSON.Parse(REQ)
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	'define CMD
	CMD_SETGIGOO = 114 '지구력설정 셋팅
	
	
	CMD_GAMEINPUT2 = 15001	'공지사항저장2
	CMD_GAMEINPUTEDITOK = 15002	'수정
	CMD_GAMEINPUTDEL = 15003	'삭제

	CMD_SETRECORDINIT = 400	'심사지점 수 최고점수 저정
	CMD_SETSIGN = 401
	CMD_SETSHOW = 402
	CMD_EXCEPTMAX = 403 '최고점제거
	CMD_EXCEPTMIN = 404


	CMD_RC01 = 20000	'기록입력시작 01
	CMD_RC02 = 20010	
	CMD_RC03 = 500	'저장후 reload
	CMD_MMRCOK = 505 '저장후 reload 마장마술 저장 (통합으로)
	CMD_RCCLOSE= 501	'기록창에서 창닫음 (입력상태복구)


	CMD_SETGIVEUP = 300	'기권사유선택
	CMD_SETGIVEUPDOC = 301	'사유서제출
	CMD_SETGAMESTATE = 620	'경기상태변경

	CMD_JRCOK = 510	'장애물 A타입 저장
	CMD_JRCOK2 = 520	'장애물 B타입 저장
	CMD_JRCOK3 = 530	'장애물 C타입 저장
	CMD_JRCOKA_1 = 540	'장애물 A_1타입 저장

	CMD_JREGAME = 600 '재경기생성 
	CMD_JREGAMEDEL = 610	'재경기 삭제

    CMD_SUMBOO_INJUDGE = 11101        ' 수동 통합 - 심사기록입력
    CMD_DIVBOO_INJUDGE  = 11102        ' 수동 분리 - 심사기록입력
    CMD_REFRESHBOO_INJUDGE = 11103    ' 부 재조회 - 심사기록입력


	CMD_CHANGEWINDOW = 30000 '선수변경창

	CMD_SEARCHPLAYER = 30030 '선수검색
	CMD_SEARCHPLAYERGROUP = 30031	'그룹선수검색
	CMD_CHANGEPLAYER = 700 '변경
	CMD_CHANGEGROUPPLAYER = 778 '릴레이선수 변경

	CMD_CHANGEMAKEPLAYER = 710 '선수생성변경
	CMD_SAVEJUDGE = 720 '심판저장

	CMD_SEARCHHORSE = 30040  '말검색
	CMD_CHANGEHORSE = 800		'말변경
	CMD_CHANGEMAKEHORSE = 810		'말생성변경
	CMD_BMRESULT = 900 '복합마술 경기결과생성

	CMD_SETJUDGE = 31000	'심판,스크라이버,	스튜어드, set-in, shadow
	CMD_SEARCHJUDGE =  30050	'심판검색

	CMD_VALUATION = 150 '채점 상세 기록 


	CMD_CHANGEBOO = 30051 '부서변경
	CMD_CHANGEBOOOK = 730 '부변경

	CMD_SETHURDLE =  40000 '장애물 기준및 배칭창
	CMD_JRC = 740  '장애물기준및 배치정보 내용 입력

	CMD_SETDT2 = 750
	CMD_CHANGEORDER = 751	'체전 2라운드 경기순서변경


	CMD_GAMEINRC = 13010'게임결과 입력 (릴레이 토너먼트)
	CMD_SETSAVETN = 815 '승패저장
	CMD_SETORDER = 112 '리그 순위 변경
	CMD_SETGIGOLEG = 113
	CMD_SETVALGEEGOO = 779 '경기결과값 입력
	CMD_SETGIVEUPGEEGOO = 302

	CMD_SAVERESULT = 901	'경기최종결과 저장

	Select Case CDbl(CMD)

	Case CMD_SAVERESULT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.saveResult.asp" --><%
	Response.End

	
	Case CMD_SETGIVEUPGEEGOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveupgeegoo.asp" --><% 
	Response.End


	Case CMD_SETVALGEEGOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setvalGeeGoo.asp" --><%
	Response.End

	Case CMD_SETGIGOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setGiGoo.asp" --><%
	Response.End


	Case CMD_SETGIGOLEG
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setBeeGo.asp" --><%
	Response.End

	Case CMD_SETORDER
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setOrder.asp" --><%
	Response.End

	Case CMD_SETSAVETN
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setSaveTN.asp" --><%
	Response.End

	case CMD_GAMEINRC
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setresultWindow.asp" --><% 
	Response.End


	case CMD_CHANGEORDER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeorder.asp" --><% 
	Response.End


	case CMD_SETDT2 '체전 2.1 2.2 2라운드 시간설정
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setDT2.asp" --><% 
	Response.End

	case CMD_JRC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jrc.asp" --><% 
	Response.End

	case CMD_SETHURDLE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.sethurdle.asp" --><% 
	Response.End

	case CMD_VALUATION
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.valuation.asp" --><% 
	Response.End


	case CMD_SETJUDGE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setJudge.asp" --><% 
	Response.End
	case CMD_SEARCHJUDGE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchJudge.asp" --><% 
	Response.End


	'#################################################################


	case CMD_BMRESULT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.BMResult.asp" --><%  '복합마술 경기결과 생성
	Response.End

	case CMD_CHANGEBOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeboo.asp" --><% 
	Response.End

	case CMD_CHANGEBOOOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeboook.asp" --><% 
	Response.End

	case CMD_CHANGEWINDOW
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changewindow.asp" --><% 
	Response.End

	case CMD_SEARCHPLAYERGROUP
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchplayergroup.asp" --><% 
	Response.End

	case CMD_SEARCHPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchplayer.asp" --><% 
	Response.End

	case CMD_SAVEJUDGE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.savejudge.asp" --><% 
	Response.End




	case CMD_CHANGEPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeplayer.asp" --><% 
	Response.End

	Case CMD_CHANGEGROUPPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changegroupplayer.asp" --><% 
	Response.End

	case CMD_CHANGEMAKEPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changemakeplayer.asp" --><% 
	Response.End


	case CMD_SEARCHHORSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchhorse.asp" --><% 
	Response.End

	case CMD_CHANGEHORSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changehorse.asp" --><% 
	Response.End

	case CMD_CHANGEMAKEHORSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changemakehorse.asp" --><% 
	Response.End





	case CMD_JREGAMEDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jReGameDel.asp" --><% 
	Response.End

	case CMD_JREGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jReGame.asp" --><% 
	Response.End

	case CMD_JRCOK3
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK3_detail.asp" --><% 
	Response.End
	case CMD_JRCOK2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK2_detail.asp" --><% 
	Response.End
	case CMD_JRCOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK_detail.asp" --><% 
	Response.End
	case CMD_JRCOKA_1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOKA_1_detail.asp" --><% 
	Response.End



	case CMD_SETGAMESTATE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgamestate.asp" --><% 
	Response.End
	case CMD_SETGIVEUP
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveup.asp" --><% 
	Response.End

	case CMD_SETGIVEUPDOC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveupdoc.asp" --><% 
	Response.End


	case CMD_RCCLOSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rcclose.asp" --><% 
	Response.End

	case CMD_RC01
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc01_typeA.asp" --><% 
	Response.End
	case CMD_RC02
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc02_detail.asp" --><% 
	Response.End

	
	
	
	case CMD_RC03 '마장마술 저장 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc03_MM.asp" --><% 
	Response.End

	case CMD_MMRCOK 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.mmTypeOk_detail.asp" --><% 
	Response.End




	case CMD_SETSIGN
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setsign.asp" --><% 
	Response.End

	case CMD_SETSHOW 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setshow.asp" --><% 
	Response.End

	case CMD_EXCEPTMAX 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.exceptmax.asp" --><% 
	Response.End
	case CMD_EXCEPTMIN 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.exceptmin.asp" --><% 
	Response.End




	case CMD_SETRECORDINIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setrecordinit.asp" --><% 
	Response.End

	case CMD_GAMEINPUT2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scSavenotice2.asp" --><% 
	Response.End

	case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.orderNoticeEditOk.asp" --><% 
	Response.End

	case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.orderNoticeDel.asp" --><% 
	Response.End

    case CMD_SUMBOO_INJUDGE    
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.sumboo.asp" --><%
	Response.End

    case CMD_DIVBOO_INJUDGE    
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.divboo.asp" --><%
	Response.End

    case CMD_REFRESHBOO_INJUDGE		
        %><!-- #include virtual = "/pub/api/RidingAdmin/api.refresh.boo.injudge.asp" --><%
	Response.End



	End Select
%>
