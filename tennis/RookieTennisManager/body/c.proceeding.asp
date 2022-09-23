<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
		If request("idx") = "" Then
			Response.redirect "./contest.asp"
			Response.End
		End If
		
		tidx = chkInt(chkReqMethod("idx", "GET"), 1)
		teamidx = chkInt(chkReqMethod("teamidx", "GET"), 1)
		entryfilter = chkInt(chkReqMethod("entrylist", "GET"), 0) '0 전체, 1 참가자 , 2 대기자
	'request 처리##############

	Set db = new clsDBHelper
	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo,titlecode,titlegrade "
	SQL = "Select top 1 "&strFieldName&" from "&strTableName&" where DelYN = 'N' and GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If not rs.eof Then
		titlename = rs("gameTitleName")
	End if

	SQL = "select a.TeamGbNm,a.level, b.LevelNm  from tblRGameLevel as a left join tblLevelInfo as b  ON a. level = b.level where a.RGameLevelidx = " & teamidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If not rs.eof Then
	teamnm = rs("TeamGbNm")
	levelnm = rs("LevelNm")
	levelno = rs("level")

	Select Case Left(levelno,3)
	Case "200"
		boo = "단식"
	Case "201"
		boo = "복식"
	End Select
	End IF





'	Dim intTotalCnt, intTotalPage
'	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
'
'	block_size = 10
'
'
'	'대회주최
'	SQL = "Select hostname from tblGameHost where DelYN = 'N' "
'	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rst.EOF Then 
'		arrRS = rst.GetRows()
'	End If
'	
'
'	'대회그룹/등급
'	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
'	Set rsg = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rsg.EOF Then 
'		arrRSG = rsg.GetRows()
'	End if
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>

		<form name="frm" method="post">
		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 45px;">
					<strong>대회진행 <span style="font-size:13px;">(예선진행상황조회)</span> - <span style="color:orange"><%=titlename%> [<%=teamnm%>]</a></strong>
				</h3>
			</div>

			<div class="top-navi-btm">
				<div class="navi-tp-table-wrap"  id="gameinput_area">
					<a href="./contestlevel.asp?idx=<%=tidx%>" class="btn">대회부목록 보기</a>
					<a href="./proceeding.asp?idx=<%=tidx%>&teamidx=<%=teamidx%>" class="btn" style="background:orange;">예선진행상황조회</a>
					<a href="./proceedingA.asp?idx=<%=tidx%>&teamidx=<%=teamidx%>" class="btn">예선결과입력</a>
					<a href="./proceedingB.asp?idx=<%=tidx%>&teamidx=<%=teamidx%>" class="btn">본선대기중경기</a>
					<a href="./proceedingC.asp?idx=<%=tidx%>&teamidx=<%=teamidx%>" class="btn">본선진행중경기</a>
				</div>
			</div>

		</div>
		</form>

<%
	Response.write "<table class=""table-list"">"
	Response.write "<thead><th>조</th><th>경기1</th><th>경기2</th><th>경기3</th></thead>"
	Response.write "<tbody id=""contest"">"
	Response.write " <tr class=""gametitle"" ></tr>"

'	Do Until rs.eof
'		idx = rs("GameTitleIDX")
'		title = rs("gameTitleName")
'		sdate = rs("GameS")
'		edate = rs("GameE")
'		gamecfg = rs("cfg")
'		rcvs = rs("GameRcvDateS")
'		rcve = rs("GameRcvDateE")
'
'		ViewYN = rs("ViewYN")
'		MatchYN = rs("stateNo")
'		viewState = rs("viewState")
'		Select Case MatchYN '게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
'		Case "0" : MatchYN = "<span style='color:blue'>미노출</span>"
'		Case "3" : MatchYN = "<span style='color:orange'>예선노출</span>"
'		Case "4" : MatchYN = "예선마감"
'		Case "5" : MatchYN = "본선노출"
'		Case "6" : MatchYN = "본선마감"
'		Case "7" : MatchYN = "결과노출"
'		End Select
'
'
'		titleCode = rs("titleCode")
'		titleGrade = rs("titleGrade")
'		Select Case titleGrade
'		Case "1" : titleGrade = "SA"
'		Case "2" : titleGrade = "GA"
'		Case "3" : titleGrade = "A"
'		Case "4" : titleGrade = "B"
'		Case "5" : titleGrade = "C"
'		Case "6" : titleGrade = "단체전"
'		End Select 
		%>
			<!-- #include virtual = "/pub/html/RookietennisAdmin/proceeding/a.asp" -->
	<%
'	rs.movenext
'	Loop
	Response.write "</tbody>"
	Response.write "</table>"


	Set rs = Nothing
%>


<div id="Modaltest" class="modal hide fade step2modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="z-index:1100">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel" id="m2_title">선수 교체</h3>
  </div>
  <div class="modal-body" id="Modaltestbody">
      <span> 이름 : </span>
      <input type="hidden" id="p1idx" value="<%=p1idx%>">
      <input type="text" id="p1name" value="<%=p1name%>" width="100px;" class="ui-autocomplete-input" autocomplete="off"  onkeyup="mx.initPlayer()">
      </br><br>

      <span> 핸드폰 : </span><span id="p1phone"><%=p1phone%></span>
      </br><br>
      <span> 클럽1 : </span><span id="p1team1"><%=p1t1%></span>
      </br><br>
      <span> 클럽2 : </span><span id="p1team2"><%=p1t2%></span>

      <span> 이름 : </span>
      <input type="hidden" id="p2idx" value="<%=p2idx%>">
      <input type="text" id="p2name" value="<%=p2name%>" width="100px;" class="ui-autocomplete-input" autocomplete="off"  onkeyup="mx.initPlayer()">
      </br><br>

      <span> 핸드폰 : </span><span id="p2phone"><%=p2phone%></span>
      </br><br>
      <span> 클럽1 : </span><span id="p2team1"><%=p2t1%></span>
      </br><br>
      <span> 클럽2 : </span><span id="p2team2"><%=p2t2%></span>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
    <button class="btn btn-primary" onclick="mx.changePlayer()">저장</button>
  </div>
</div>