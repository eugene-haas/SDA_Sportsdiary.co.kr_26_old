<%
'#############################################

'결과 생성 코트정보 변경

'#############################################

'{"CMD":82001,"IDX":81,"TitleIDX":25,"Title":"입력테스트","TeamNM":"신인부","AreaNM":"부천","ONEMORE":"notok","roundSel":"0","RESET":"notok","COURTAREA":0,"T_M1IDX":14662,"T_M2IDX":14652,"T_SORTNO":6,"T_RD":1,"S3KEY":"20104001","RIDX":22232,"NOWCTNO":2234}
	'request


	Dim tidx, m1idx, m2idx, titleidx, levelno

	

	If hasown(oJSONoutput, "TitleIDX") = "ok" then
		tidx = oJSONoutput.TitleIDX
	End If

	m1idx = oJSONoutput.T_M1IDX  
	m2idx = oJSONoutput.T_M2IDX
	titleidx = oJSONoutput.TitleIDX
	levelno = oJSONoutput.S3KEY

	Set db = new clsDBHelper		

		'player item 정보 가져오기
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strtablesub2 = " sd_TennisItemSetHistory "
		strwhere = "  a.gamememberIDX in ("& m1idx &","& m2idx &")"
		strsort = " order by a.sortno asc"
		inquery1 = " (select top 1 item1Name from " & strtablesub2 & " as c where c.playerIDX = a.PlayerIDX order by WriteDate desc ) as aRacket "
		inquery2 = " (select top 1 item1Name from " & strtablesub2 & " as c where c.playerIDX = b.PlayerIDX order by WriteDate desc ) as bRacket "
		strAfield = " a. gamememberIDX, a.userName as aname, a.PlayerIDX ,a.teamAna as aATN, a.teamBNa as aBTN  "
		strBfield = " b.partnerIDX, b.userName as bname, b.PlayerIDX ,b.teamAna as bATN , b.teamBNa as bBTN "
		strfield = strAfield &  ", " & inquery1 &  ", " & strBfield &  ", " & inquery2
		SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
'		Response.write(SQL)
'		Response.end
		If Not rs.EOF Then
			playerItemRS = rs.GetRows()	
			laPlayerName =  playerItemRS(1, 0)
			lbPlayerName =  playerItemRS(7, 0)
			laPlayerIDX = playerItemRS(2, 0)
			lbPlayerIDX = playerItemRS(8, 0)
			laRacket     =  playerItemRS(5, 0)
			lbRacket     =  playerItemRS(11,0)			
			If IsArray(playerItemRS) then
				raPlayerName =  playerItemRS(1, 1)
				rbPlayerName =  playerItemRS(7, 1)
				raPlayerIDX = playerItemRS(2, 1)
				rbPlayerIDX = playerItemRS(8, 1)
				raRacket     =  playerItemRS(5, 1)
				rbRacket     =  playerItemRS(11,1)
			End If
		End If

		'Call oJSONoutput.Set("resout", 0 )
		'strjson = JSON.stringify(oJSONoutput)



		'racket정보 가져오기
		strtable = " sd_TennisItem "
		strwhere = " itemType1 = 'racket' AND itemType2 = 'frame' "
		strsort = " order by ItemIDX "
		strfield = "itemIDX, orderBy, itemName "
		SQL2 = "select "& strfield &" from  " & strtable & " where " & strwhere & strsort
		Set rs2 = db.ExecSQLReturnRS(SQL2 , null, ConStr)
		
		
		ItemListRS = rs2.GetRows()
		
		


	db.Dispose
	Set db = Nothing

%>


	


<div class='modal-header game-ctr'>
	<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
	<h3 id='myModalLabel'>SPORTS BRAND REAL SURVEY</h3>
</div>

	<!-- <div style="text-align:center;width:100%;padding-top:8px;">

	</div> -->

	<div class="modal-body laket-modal">
		<!-- s: player-con -->
		<div class="player-con l-con">
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<img src="/images/tenis/l_icon.png" alt="">
						<span class="player-title">PLAYER 1</span>
						<img src="/images/tenis/r_icon.png" alt="">
					</td>
				</tr>
				<tr>
					<th>
						<span>Name</span>
					</th>
					<th>
						<span>Tennis Racquet</span>
					</th>
				</tr>
				<tr>
					<td>
						<span><%= laPlayerName %></span>
					</td>
					<td>
						<span class="l-img">
							<img src="/images/tenis/tenis_icon1.png" alt="">
						</span>
						<span class="txt" id=<%= laPlayerIDX %> > <%= laRacket %></span>
						<select name="" id="" onchange=	"mx.setLaket(<%= titleidx %>, <%= levelno %>, <%= laPlayerIDX %> ,$(this).val() )" >
							<option value="">:: 선택 ::</option>
							<% itemList(laRacket) %>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<span><%= lbPlayerName %></span>
					</td>
					<td>
						<span class="l-img">
							<img src="/images/tenis/tenis_icon1.png" alt="">
						</span>
						<span class="txt" id=<%= lbPlayerIDX %>><%= lbRacket %></span>
						<select name="" id="" onchange=	"mx.setLaket(<%= titleidx %>, <%= levelno %>, <%= lbPlayerIDX %> ,$(this).val() )" >
							<option value="">:: 선택 ::</option>
							<% itemList(lbRacket) %>
						</select>
					</td>
				</tr>
			</table>
		</div>

		
		<!-- e: player-con -->
		<!-- s: center-con -->
		<div class="vs-con">
			<span>VS</span>
		</div>
		<!-- e: center-con -->
		<!-- s: player-con -->
		<div class="player-con r-con">
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<img src="/images/tenis/l_icon.png" alt="">
						<span class="player-title">PLAYER 2</span>
						<img src="/images/tenis/r_icon.png" alt="">
					</td>
				</tr>
				<tr>
					<th>
						<span>Name</span>
					</th>
					<th>
						<span>Tennis Racquet</span>
					</th>
				</tr>
				<tr>
					<td>
						<span><%= raPlayerName %></span>
					</td>
					<td>
						<span class="l-img">
							<img src="/images/tenis/tenis_icon1.png" alt="">
						</span>
						<span class="txt" id=<%= raPlayerIDX %>><%= raRacket %></span>
						<select name="" id="" onchange=	"mx.setLaket(<%= titleidx %>, <%= levelno %>, <%= raPlayerIDX %> ,$(this).val() )"  >
							<option value="">:: 선택 ::</option>
							<% itemList(raRacket) %>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<span><%= rbPlayerName %></span>
					</td>
					<td>
						<span class="l-img">
							<img src="/images/tenis/tenis_icon1.png" alt="">
						</span>
						<span class="txt" id=<%= rbPlayerIDX %>><%= rbRacket %></span>
						<select name="" id="" onchange=	"mx.setLaket(<%= titleidx %>, <%= levelno %>, <%= rbPlayerIDX %> ,$(this).val() )" >
							<option value="">:: 선택 ::</option>
							<% itemList(rbRacket) %>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<!-- e: player-con -->
	</div>


<!--	<div class="modal-footer">
		<a href="#" class="btn btn-primary blue-btn">등록하기</a>
		<a href="#" class="btn btn-primary blue-btn">수정하기</a>
	</div> -->
	<script>
		var $vsCon = $(".vs-con");
		var $tableHeight = $(".laketmodal .modal-body .player-con").outerHeight(true);
		$vsCon.css("height",$tableHeight);
	</script>