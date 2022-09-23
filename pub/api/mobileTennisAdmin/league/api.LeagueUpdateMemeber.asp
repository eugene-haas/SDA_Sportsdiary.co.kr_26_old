<%
'p1 0
'jono 0
'PLAYERIDX 0
'PLAYERIDXSub 0
'GAMEMEMBERIDX

'StateNo  게임 종료등 999

	idx = oJSONoutput.IDX 'tblRGameLevel idx
	If hasown(oJSONoutput, "GAMEMEMBERIDX") = "ok" then
		GAMEMEMBERIDX = oJSONoutput.GAMEMEMBERIDX
		tidx = oJSONoutput.TitleIDX
		title = oJSONoutput.Title
		teamnm = oJSONoutput.TeamNM
		areanm = oJSONoutput.AreaNM
		stateNo = oJSONoutput.StateNo
		S3KEY = oJSONoutput.S3KEY
		P1 = oJSONoutput.P1
		JONO = oJSONoutput.JONO
		PLAYERIDX = oJSONoutput.PLAYERIDX
		PLAYERIDXSub = oJSONoutput.PLAYERIDXSub
		EndGroup = oJSONoutput.EndGroup
	Else
		GAMEMEMBERIDX = -1
	End if

	If hasown(oJSONoutput, "POS") = "ok" then
		pos = oJSONoutput.pos
	End if




  '타입 석어서 보내기
  Call oJSONoutput.Set("result", "0" )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"


    Set db = new clsDBHelper
	changetype = "member"

	If CDbl(GAMEMEMBERIDX) = 0 Then '신규팀생성 또는 선수 생성화면

		If isnumeric(pos) = true Then
		headtitle = "선수생성"
		Else
			If pos = "newjoo" then
				headtitle = "신규팀등록 [신규조생성]"
			Else
				headtitle = "신규팀등록"
			End if
		End if

	Else
		headtitle = "선수 교체"

		If CDbl(GAMEMEMBERIDX) = -1 Then '대회신청 페이지에서 온경우

			SQL = "SELECT top 1 P1_PlayerIDX,P2_PlayerIDX,gameTitleIDX,level,    p1_username,p1_teamnm,p1_teamnm2,p1_userphone,  p2_username,p2_teamnm,p2_teamnm2,p2_userphone     from tblGameRequest where RequestIDX = " & idx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				p1idx = rs(0)
				p2idx = rs(1)
				tidx = rs(2)
				oldlevelno = rs(3)

				p1name = rs("p1_username")
				p1team1 = rs("p1_teamnm")
				p1team2 = rs("p1_teamnm2")
				p1phone = rs("p1_userphone")

				p2name = rs("p2_username")
				p2team1 = rs("p2_teamnm")
				p2team2 = rs("p2_teamnm2")
				p2phone = rs("p2_userphone")
			End if


			SQL = "SELECT top 1 gamememberidx from sd_TennisMember where RequestIDX = " & idx
			Set rrs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rrs.eof then
				SQL = "SELECT top 1 gamememberidx from sd_TennisMember where gameTitleIDX = "&tidx&" and gamekey3 = "&oldlevelno&" and  playerIDX =  " & p1idx & " and gubun in (0,1) "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof then
					'GAMEMEMBERIDX = -1 '대기자인경우
					changetype = "waitmember"
				Else
					GAMEMEMBERIDX = rs(0)
				End If
			Else
				If rrs.eof then
					'GAMEMEMBERIDX = -1 '대기자인경우
					changetype = "waitmember"
				Else
					GAMEMEMBERIDX = rrs(0)
				End If
			End if

		End If




		If changetype ="member" then
			'맴버 정보 가져오기
			SQL = "SELECT Top 1 a.gameMemberIDX, a.PlayerIDX, a.userName, a.TeamANa, a.TeamBNa, a.Sex,"
			SQL = SQL & " b.PlayerIDX as partner_PlayerIDX, b.userName as partner_UserName, b.TeamANa as partner_TeamANa, b.TeamBNa as partner_TeamBNa, b.Sex as partner_Sex,a.requestIDX as reqIDX "
			SQL = SQL & " FROM sd_TennisMember as a LEFT JOIN sd_TennisMember_partner b on a.gameMemberIDX = b.gameMemberIDX "
			SQL = SQL & " where a.gameMemberIDX = "& GAMEMEMBERIDX &" and a.DelYN = 'N' "
			'Response.Write "<Br>"
			'Response.Write "SQL : " & SQL & "<Br>"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof then
			  gameMemberIDX = rs("gameMemberIDX") '참가제한인원수
			  p1_IDX = rs("PlayerIDX") '참가신청자수
			  p1_UserName = rs("userName") '코트수
			  p1_TeamA = rs("TeamANa")
			  p1_TeamB = rs("TeamBNa")
			  p1_Sex = rs("Sex")
			  p2_IDX = rs("partner_PlayerIDX")
			  p2_UserName = rs("partner_UserName")
			  p2_TeamA = rs("partner_TeamANa")
			  p2_TeamB = rs("partner_TeamBNa")
			  p2_Sex = rs("partner_Sex")

			  '신청인덱스
			  reqIDX = rs("reqIDX")
			End If

			' 1선수 정보 가져오기
			SQL = "SELECT Top 1 UserPhone, EnterType"
			SQL = SQL & " FROM tblPlayer "
			SQL = SQL & " where PlayerIDX = "& p1_IDX &" and DelYN = 'N' "'
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof then
			  p1_UserPhone = rs("UserPhone") '참가제한인원수
			  p1_EnterType = rs("EnterType") '참가신청자수
			End if


			'2 선수 정보 가져오기
			SQL = "SELECT Top 1 UserPhone, EnterType"
			SQL = SQL & " FROM tblPlayer "
			SQL = SQL & " where PlayerIDX = "& p2_IDX &" and DelYN = 'N' "'
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof then
			  p2_UserPhone = rs("UserPhone") '참가제한인원수
			  p2_EnterType = rs("EnterType") '참가신청자수
			End if
		Else
			  p1_IDX = p1idx
			  p1_UserName = p1name
			  p1_TeamA = p1team1
			  p1_TeamB = p1team2
			  p1_UserPhone = p1phone

			  p2_IDX = p2idx
			  p2_UserName = p2name
			  p2_TeamA = p2team1
			  p2_TeamB = p2team2
			  p2_UserPhone = p2phone
		End if


	End if
    db.Dispose
    Set db = Nothing
%>
  <div class='modal-header game-ctr'>
    <button type='button' class='close' onclick="$('#Modaltest').hide()">×</button>
    <h3 id='myModalLabel'><%=headtitle%></h3>
  </div>


<%If CDbl(GAMEMEMBERIDX) = 0 Then '신규팀생성 또는 선수 생성화면%>

	<%If isnumeric(pos) = true Then%>
	  <div class="modal-content" id="Modaltestbody">
			<table class="sch-table">
				<tbody>
				  <tr>
			  <colgroup>
				<col width="*">
			  </colgroup>
				<td id = "player1">
				  
				  <input type="hidden" id="p1idx" value="<%=p1_IDX%>">
				  <input type="text" id="nname" value="<%=p1_UserName%>" width="100%" class="ui-autocomplete-input" autocomplete="off"><a href="javascript:mx.chkPlayer()" class="btn_a">중복체크</a>
				  </br><br>

				  <span> 핸드폰 : </span><span><input type="text" id="nphone" style="width:150px;"  placeholder="ex)01000000000" ></span>
				  </br><br>
				  <span> 클럽1 : </span><span><input type="text" id="nteam1" style="width:150px;" width="150px;" ></span>
				  </br><br>
				  <span> 클럽2 : </span><span><input type="text" id="nteam2" style="width:150px;" width="150px;" ></span>
				</td>
				</tbody>
			  </table>

	  </div>

	  <div class="modal-footer">
		<!-- <div class="btn_list btn_3"> -->
		<button class="btn btn-primary" onclick="mx.setPlayer(<%=idx%>)">선수생성</button>
		<!-- </div> -->
	  </div>

	<%else%>
	  <div class="modal-content" id="Modaltestbody">
			<table class="sch-table">
				<tbody>
				  <tr>
			  <colgroup>
				<col width="*">
			  </colgroup>
				<input type="hidden" id="tryout_pos" value="<%=pos%>">
				<td id = "player1">
				  
				  <input type="hidden" id="p1idx" value="<%=p1_IDX%>">
				  <input type="text" id="p1name" value="<%=p1_UserName%>"  class="ui-autocomplete-input" autocomplete="off" onkeyup="mx.initPlayer()">
				  </br><br>

				  <span> 핸드폰 : </span><span id="p1phone"><%=p1_UserPhone%></span>
				  </br><br>
				  <span> 클럽1 : </span><span id="p1team1"><%=p1_TeamA%></span>
				  </br><br>
				  <span> 클럽2 : </span><span id="p1team2"><%=p1_TeamB%></span>
				</td>

				<td id="player2">
				  
				  <input type="hidden" id="p2idx" value="<%=p2_IDX%>">
				  <input type="text" id="p2name" value="<%=p2_UserName%>"  class="ui-autocomplete-input" autocomplete="off"  onkeyup="mx.initPlayer()">
				   </br><br>

				  <span> 핸드폰 : </span><span id="p2phone"><%=p2_UserPhone%></span>
				  </br><br>
				  <span> 클럽1 : </span><span id="p2team1"><%=p2_TeamA%></span>
				  </br><br>
				  <span> 클럽2 : </span><span id="p2team2"><%=p2_TeamB%></span>
				</td>
				</tbody>
			  </table>

	  </div>

	  <div class="modal-footer">
		<!-- <div class="btn_list btn_3"> -->
		<!-- <button class="btn btn-primary" onclick="mx.setPlayer()">선수등록</button> -->
		<button  onclick="mx.setTeam(<%=idx%>)" style="width:100%">신규팀등록</button>
		<!-- </div> -->
	  </div>
	<%End if%>

<%Else '선수교체%>
	<%If CDbl(GAMEMEMBERIDX) = -1 Then '대회신청 페이지에서 온경우%>
	<input type="hidden" id="requestidx" value="<%=idx%>">
	<%else%>
		<input type="hidden" id="requestidx" value="<%=reqIDX%>">
	<%End if%>


  <div class="modal-content" id="Modaltestbody">
		<table class="sch-table">
			<tbody>
			  <tr>
		  <colgroup>
			<col width="*">
		  </colgroup>
			<input type="hidden" id="orgp1idx" value="<%=p1_IDX%>">
			<input type="hidden" id="orgp2idx" value="<%=p2_IDX%>">
			<input type="hidden" id="wait" value="<%=changetype%>">
			<td id = "player1">
			  
			  <input type="hidden" id="p1idx" value="<%=p1_IDX%>">
			  <input type="text" id="p1name" value="<%=p1_UserName%>" width="100px;" class="ui-autocomplete-input" autocomplete="off" onkeyup="mx.initPlayer()">
			  </br><br>

			  <span> 핸드폰 : </span><span id="p1phone"><%=p1_UserPhone%></span>
			  </br><br>
			  <span> 클럽1 : </span><span id="p1team1"><%=p1_TeamA%></span>
			  </br><br>
			  <span> 클럽2 : </span><span id="p1team2"><%=p1_TeamB%></span>
			</td>

			<td id="player2">
			  
			  <input type="hidden" id="p2idx" value="<%=p2_IDX%>">
			  <input type="text" id="p2name" value="<%=p2_UserName%>" width="100px;" class="ui-autocomplete-input" autocomplete="off"  onkeyup="mx.initPlayer()">
			   </br><br>

			  <span> 핸드폰 : </span><span id="p2phone"><%=p2_UserPhone%></span>
			  </br><br>
			  <span> 클럽1 : </span><span id="p2team1"><%=p2_TeamA%></span>
			  </br><br>
			  <span> 클럽2 : </span><span id="p2team2"><%=p2_TeamB%></span>
			</td>
			</tbody>
		  </table>

  </div>

  <div class="modal-footer">
    <button class="btn btn-primary" onclick="mx.changePlayer()" style="width:100%">저장</button>
  </div>
<%End if%>
