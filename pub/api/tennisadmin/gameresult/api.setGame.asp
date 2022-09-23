<%
'#############################################
'대진표 리그 화면 준비 (랭킹포인트 적용 화면 호출)
'#############################################

'request
idx = oJSONoutput.IDX 'tblRGameLevel idx
tidx = oJSONoutput.TIDX
levelno = oJSONoutput.LEVELNO
title = oJSONoutput.TITLE
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = title & " " & teamnm & " (" & areanm & ") "

Set db = new clsDBHelper

'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = "Select GameS,titleCode,titleGrade,gametitlename from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		games = Left(rs("games"),10)
		titlecode = rs("titlecode")
		titlegrade = rs("titleGrade")
		gametitle = rs("gametitlename")
	End if

	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,setpoint from  tblRGameLevel  where DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	setpoint = "N"
	If Not rs.eof then
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호
        bigo=rs("bigo")
		endround = rs("endround")					'진행될 최종라운드
		setpoint = rs("setpoint")					'포인 설정 여부
	End If
	

	'선수에서 삭제된 명단 제거
	'SELECT PlayerIDX FROM sd_TennisMember WHERE GameTitleIDX = 152 and gamekey3 = 20101002 and gubun in (0,1) and PlayerIDX NOT IN ( SELECT DISTINCT PlayerIDX FROM tblPlayer)
	SQL = "Update sd_TennisMember Set delYN = 'Y' WHERE GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and gubun in (0,1) and PlayerIDX NOT IN ( SELECT DISTINCT PlayerIDX FROM tblPlayer)"
	Call db.execSQLRs(SQL , null, ConStr)

'기본정보#####################################

'참가자 목록 로그에 인서트###############################
	'들가간게 있는 지 확인한다 .....확인되면 넣지 말자.... 참가신청기간이 종료되었는지 확인 (로그생성을 위해 대회 시작전에 참가자 목록을 다 넣어둔다.)

	If setpoint = "N" Then
		insertfield = " gameyear,PlayerIDX,partnerIDX,playerIDXNm,partnerIDXNm,PlayerIDXTeamName1,PlayerIDXTeamName2,partnerIDXTeamName1,partnerIDXTeamName2,key1,key1name,key3,key3name "
		strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.gubun in ( 0, 1) and a.DelYN = 'N' and a.playerIDX > 1 "
		strfield = " "&year(date)&",a.PlayerIDX,b.PlayerIDX,a.userName,b.userName,a.teamAna,a.teamBNa, b.teamANa,b.teamBNa,a.GameTitleIDX,'"&title&"',a.teamGb,key3name "
		Selectquery = " Select " & strfield & " from  " & strtable & " as a LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX where " & strwhere

		SQL = "Insert into sd_TennisScore ( "&insertfield&" ) " & Selectquery
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update tblRGameLevel Set setpoint = 'Y' where RGameLevelidx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	End if
'#############################################


'랭킹포인트 집계해서 넣어주기#############################
'시작 memberidx 
SQL = " Select top 1 gameMemberIDX,username  from  " & strtable & " where GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and gubun in ( 0, 1) and DelYN = 'N' and playerIDX > 1 order by gameMemberIDX asc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If rs.eof Then
	startmidx = 0 
Else
	startmidx = rs(0) '루프 시작 인덱스
	uname = rs(1)
End if



'##############################################
' 소스 뷰 경계
'##############################################
%>

<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
	<h3 id='myModalLabel'>
	<%Call ajaxUrlPrint(USER_IP) 'ajax 파일 화면에서 찾기위에 작업용[회사내부]용으로 추가%>
	<%=levelno%>-- <%=poptitle%></h3>

  </div>
<!-- 헤더 코트e -->
<div class='modal-body'>


<div class="scroll_box" style="margin-top:5px;font-size:12px;" id="rp_updatelog">
</div>


<div id="rtbtnarea" style="width:98%;margin:auto;height:40px;overflow:auto;text-align:center;padding-top:5px;font-size:18px;">
	시작선수:<%=uname%> >> <a href="javascript:sd.setRank(1,<%=tidx%>,<%=levelno%>,<%=startmidx%>)" class="btn">포인트 반영</a>
</div>



</div>
<%
db.Dispose
Set db = Nothing
%>
