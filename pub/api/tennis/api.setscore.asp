<%
	'request
	scIDX = oJSONoutput.SCIDX
	p1idx = oJSONoutput.P1
	p2idx = oJSONoutput.P2
	gubun = oJSONoutput.GN '0예선

	groupno = oJSONoutput.JONO '예선조번호
	rd = oJSONoutput.RD 
	grnd = oJSONoutput.GRND 
	sno  = oJSONoutput.SNO 

	Call oJSONoutput.Set("result", "0" )

	'타입 석어서 보낼때 사용
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"

	'$$$$$$$$$$$$$$$$$$$$$$$$
	If s2key = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = False
	End if  

	joinstr = " inner "
	singlegame = false

	Set db = new clsDBHelper

	strfield = " m1set1,m1set2,m1set3,m2set1,m2set2,m2set3,  m1set,m2set,tiebreakpt,set1end,set2end,set3end "
	SQL = "select "& strfield &" from  sd_TennisResult where resultIDX = " & scIDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	If Not rs.eof Then
		m1s1 = rs("m1set1")
		m1s2 = rs("m1set2")
		m1s3 = rs("m1set3")
		m2s1 = rs("m2set1")
		m2s2 = rs("m2set2")
		m2s3 = rs("m2set3")
		set1end = rs("set1end")
		set2end = rs("set2end")
		set3end = rs("set3end")

		m1set = rs("m1set")
		m2set = rs("m2set")
		tiebreakpt = rs("tiebreakpt")
	End if
	'##################################################################

	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "
	strwhere = "  a.gamememberIDX = " & p1idx & " or a.gamememberIDX = " & p2idx

	If gubun = "0" Then
	strsort = " order by a.tryoutsortno asc"
	else
	strsort = " order by a.SortNo asc"
	End If

	strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aATN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW,EnterType  "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN "
	strfield = strAfield &  ", " & strBfield

	SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount
%>


	<div class="modal-dialog">
	  <div class="modal-content">
		<!-- S: modal-header -->
		<div class="modal-header chk-score">
		  <h4 class="modal-title" id="modal-title">SCORE</h4>
		</div>
		<!-- E: modal-header -->
		<div class="modal-body">
		  <h2><span class="left-arrow"><img src="images/tournerment/tourney/yellow-larr.png" alt></span><span id="DP_Win_Title">SET SCORE <%=m1set%> : <%=m2set%></span><span class="right-arrow"><img src="images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
		  
		  <!-- S: board -->
		  <div class="board">
			<!-- S: pop-point-display -->
			<div class="pop-point-display">
			  <!-- S: display-board -->
			  <div class="display-board clearfix">
				<!-- S: point-display -->
				<div class="point-display clearfix">
				  <table class="point-table">
					<thead>
					  <tr>
						<th>PLAYER</th>
						<th>1SET</th>
						<th>2SET</th>
						<th>3SET</th>
						<th>TOTAL</th>
					  </tr>
					</thead>
					<tbody>
<%
i = 0
Do Until rs.eof 
		m1idx = rs("gamememberIDX")
		m2idx = rs("partnerIDX")
		m1name = rs("aname")
		m2name = rs("bname")
		'gno = rs("groupno")
		ateamname1 = rs("aATN")
		ateamname2 = rs("aBTN")
		bteamname1 = rs("bATN")
		bteamname2 = rs("bBTN")
		EnterType = rs("EnterType")
%>
					  <tr>
						<td class="player">
						  <span class="win-mark">
						  <%If i = 0 And CDbl(m1set) > (m2set) then%><img src="images/tournerment/tourney/win@3x.png" alt="win"><%End if%>
						  <%If i = 1 And CDbl(m2set) > (m1set) then%><img src="images/tournerment/tourney/win@3x.png" alt="win"><%End if%>
						  </span>
						  <div class="player-1">
							<span class="player-name" id="DP_Edit_LPlayer"><%=m1name%></span>
							<p class="player-school">
							  <span class="brace-open">(</span>
							  <!-- S: school-box --> 
							  <span class="school-box">
								<span id="DP_Edit_LSCName"><%=ateamname1%></span>,<span><%=ateamname2%></span>
							  </span>
							  <!-- E: school-box -->
							  <span class="brace-close">)</span>
							</p>
						  </div>
						  <div class="player-2">
							<span class="player-name" id="DP_Edit_LPlayer"><%=m2name%></span>
							<p class="player-school">
							  <span class="brace-open">(</span>
							  <!-- S: school-box --> 
							  <span class="school-box">
								<span id="DP_Edit_LSCName"><%=bteamname1%></span>,<span><%=bteamname1%></span>
							  </span>
							  <!-- E: school-box -->
							  <span class="brace-close">)</span>
							</p>
						  </div>
						</td>
						<%If i = 0 then%>
						<td><%=m1s1%><%If m2s1= "7" then%><span class="small">(<%=tiebreakpt%>)</span><%End if%></td>
						<td><%If EnterType = "A" then%>-<%else%><%=m1s2%><%End if%></td>
						<td><%If EnterType = "A" then%>-<%else%><%=m1s3%><%End if%></td>
						<td class="total"><%=m1set%></td>
						<%else%>
						<td><%=m2s1%><%If m1s1= "7" then%><span class="small">(<%=tiebreakpt%>)</span><%End if%></td>
						<td><%If EnterType = "A" then%>-<%else%><%=m2s2%><%End if%></td>
						<td><%If EnterType = "A" then%>-<%else%><%=m2s3%><%End if%></td>
						<td class="total"><%=m2set%></td>
						<%End if%>
					  </tr>
<%
i = i + 1
rs.movenext
loop


If isdate(set1end) = true Then
	set1time = hour(CDate(set1end))
	set1minute = minute(CDate(set1end))
End If

If EnterType = "E" then
	If isdate(set2end) = true Then
		set2time = hour(CDate(set2end))
		set2minute = minute(CDate(set2end))
	End If
	If isdate(set3end) = true Then
		set3time = hour(CDate(set3end))
		set3minute = minute(CDate(set3end))
	End If
End if
%>

					  <tr class="duration">
						<td>MATCH DURATION</td>
						<td><%=set1time%>:<%=set1minute%></td>
						<td><%If EnterType = "E" then%><%=set2time%>:<%=set2minute%><%End if%></td>
						<td><%If EnterType = "E" then%><%=set3time%>:<%=set3minute%><%End if%></td>
						<td><%If EnterType = "A" then%><%=set1time%>:<%=set1minute%><%else%><%=set3time%>:<%=set3minute%><%End if%></td>
					  </tr>
					</tbody>
				  </table>
				</div>
			  <!-- E: display-board -->
			</div>
			<!-- E: pop-point-display -->
		  </div>
		  <!-- E: board -->





		  <!-- S: record -->
		  <div class="record" id="DP_Record"  style="display:block">
			<h3>득실기록</h3>
			<!-- S: set-scroll -->
			<div class="set-scroll">

			  <!-- S: SET -->
			  <section>

<%
	strfield = " rcIDX,resultIDX,midx,name,leftscore,rightscore,gameend,servemidx,servemname,   setno,gameno,playsortno, skill1,skill2,skill3 "
	SQL = "select "& strfield &" from  sd_TennisResult_record where resultIDX = " & scIDX & "  and gameend = 1 order by setno asc, rcIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

i = 0
presetno = 0
Do Until rs.eof 

setno = rs("setno")
pname = rs("name")
leftscore = rs("leftscore")
rightscore = rs("rightscore")

If leftscore > rightscore Then
	wincolor = "orange"
Else
	wincolor = "green"
End if

skill1 = rs("skill1")
skill2 = rs("skill2")
skill3 = rs("skill3")
%>
				<%If i = 0 Or presetno < setno then%>
				<%If presetno > 0 then%>
				</ul>
			  </section>
				<%End if%>
				<h4><%=setno%>SET</h4>
				<ul id="DP_result-list">
				<%End if%>

				  <li>
					<span><%=pname%></span>
					<span class="<%=wincolor%>">WIN</span>

					<span><%=skill1%> / </span>
					<span><%=skill2%><%If skill2 <> ""  then%> / <%End if%></span>
					<span><%=skill3%><%If skill3 <> "" then%> / <%End if%></span>					
					
					<%
					'<span>
					'  <a href="#" class="btn btn-remove">
					'	<i class="fa fa-times"></i>
					'  </a>
					'</span>
					%>
				  </li>

<%
presetno = setno
i = i + 1
rs.movenext
loop
%>
				</ul>
			  </section>
			  <!-- E: SET -->



<%If EnterType = "E" then%>
<%'2 3셋트 표시%>
<%End if%>



			</div>
			<!-- E: set-scroll -->
		  </div>

		  <div class="record" id="DP_GameVideo" style="display:none">
		  </div>
		  <!-- E: record -->

















		 <!-- S: modal footer -->

		 <div class="modal-footer">
		  <p class="wrong-pass" id="DP_wrong-pass"><!--비밀번호를 잘못 입력하셨습니다. 다시 확인해주세요.--></p>
		  <span class="ins_group">
			<label for="ins_code">비밀번호</label>
			<input type="password" id="RoundResPwd" class="ins_code">
		  </span>


		  <!--경기기록실 진입 시 보이는버튼-->
		  <!-- 
		  <a onclick="change_btn();" id="btn_movie" role="button" class="btn btn-movielog btn-check">
			<span class="ic-deco"><img src="images/tournerment/public/film-icon@3x.png" alt></span>
			<span>영상보기</span>
		  </a>
		  <a onclick="change_btn();" id="btn_log" role="button" class="btn btn-movielog btn-check" style="display:none">경기기록보기</a>

		  <a onclick="checkPwd(this);" id="btnEditcheck" role="button" class="btn btn-repair" data-toggle="modal" data-target="#repair-modal" style="display: none">수정하기</a>
		  -->
		  <%If gubun = "0" then%>
		  <a onclick="score.inputScore({'SCIDX':<%=scIDX%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':0,'JONO':<%=groupno%>});" id="btnEditcheck" role="button" class="btn btn-repair" >수정하기</a>
		  <%else%>
		  <a onclick="score.inputMainScore({'SCIDX':<%=scIDX%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0,'RD':<%=rd%>,'GRND':<%=grnd%>,'SNO':<%=sno%>});" id="btnEditcheck" role="button" class="btn btn-repair" >수정하기</a>
		  <%End if%>


		  <a href="#" role="button" class="btn btn-close" data-dismiss="modal">닫기</a>
		 </div>
		 <!--E: modal-footer -->
		</div>
	   <!-- E: modal-body -->
	  </div><!-- modal-content -->


<%

'Set skilldef = nothing
'Set tuser = Nothing
'Set tuserkey = Nothing
'Set gamescore = Nothing

db.Dispose
Set db = Nothing
%>