<%
'#############################################
'대진표 리그 화면 준비 

'group by로 선수 목록정보를 확인한다. > 0 예선준비 1 예선시작 2본선준비 3 본선시작 4 본선완료 

'리그이므로
' if gubun > 0 then
	'	조별 예선 대진표를 보여준다. ( 승패결정과, 출석 체크할수 있는 기능이 있다) 코트지정 ( tennisMember에 사전에 사용할 코트를 지정할수 있어야 하나?)
'else
	'	예선 대진표를 추첨할수 있는 화면을 보여준다.
	'	대회 참가 선수 목록을 가져온다. (gubun = 0)
	'	선수가 부족한 만큼 부전승자를 만든다. ( 이건 토너먼트에서) 부족한 경우 mod 3 =0 이아닌경우 어떻게 ?? 부족합니다 어쩌구 저쩌구....
	'	mode 3 = 0 으로 만들었다 소팅순서 업데이트 해주자. 
'end if

'#############################################
'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM

poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"

Set db = new clsDBHelper

SQL = " Select EntryCnt,attmembercnt,courtcnt,level from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.eof then
	entrycnt = rs("entrycnt") '참가제한인원수
	attmembercnt = rs("attmembercnt") '참가신청자수
	courtcnt = rs("courtcnt") '코트수
	levelno = rs("level")
	poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
End if

'SQL = "select max(gubun) as gubun from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno
SQL = "select COUNT(*) as gubun from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If isNull(rs(0)) = True  Then
	'Response.write "없슴@@@@@@@@@@@@@"	'없슴
Else

	SQL = "SELECT gameMemberIDX , userName "
	SQL = SQL & " FROM sd_TennisMember "
	SQL = SQL & " WHERE GameTitleIDX = "& tidx &" "
	SQL = SQL & " AND gamekey3 = "& levelno 
	SQL = SQL & " AND DelYN = 'N'"
  SQL = SQL & " ORDER BY gameMemberIDX ASC"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	int_tryoutgroupno = 1
	int_tryoutsortNo = 1

	If Not rs.EOF Then 
		'arrRS = rs.GetRows()

			Do Until rs.EOF 

				tablename = " sd_TennisMember "

				strSql = "UPDATE " & tablename & " SET"
				strSql = strSql & " tryoutgroupno = '" & int_tryoutgroupno & "',"
				strSql = strSql & " tryoutsortNo = '" & int_tryoutsortNo & "'"
				strSql = strSql & " WHERE gameMemberIDX = " & rs("gameMemberIDX")



				If int_tryoutsortNo MOD 3 = 0 Then
					int_tryoutsortNo = 1
					int_tryoutgroupno = int_tryoutgroupno + 1
				Else
					int_tryoutsortNo = int_tryoutsortNo + 1
				End If

				Call db.execSQLRs(strSql , null, ConStr)

				rs.movenext

			Loop


	End If
	
	rs.Close
End if




'#############################################

		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.tryoutgroupno > 0 " 'a.tryoutgroupno 부전승 허수 맴버
		strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '게임순

		strAfield = " a. gamememberIDX, a.userName as aname , a.tryoutgroupno, a.tryoutsortno, a.teamAna as aATN, a.teamBNa as aBTN, a.tryoutstateno, a.t_rank,a.key3name "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN, b.positionNo, a.rankpoint as Arankpoint, b.rankpoint as Brankpoint "
		strfield = strAfield &  ", " & strBfield 

		SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort


		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount

		ReDim JSONarr(rscnt-1)

		i = 0
		Do Until rs.eof
			key3name = rs("key3name") '참가부명

		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			rsarr("GNO") = rs("tryoutgroupno")
			rsarr("SNO") = rs("tryoutsortno")
			rsarr("ATANM") = rs("aATN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("STNO") = rs("tryoutstateno") '예선 진행 상태  0
			rsarr("RT1") = rs("t_rank") '예선 결과 순위 1 또는 2라면 통과
			rsarr("ARP") = rs("Arankpoint") '예선 결과 순위 1 또는 2라면 통과
			rsarr("BRP") = rs("Brankpoint") '예선 결과 순위 1 또는 2라면 통과
			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
		datalen = Ubound(JSONarr) - 1

		'스코어 입력 정보 가져오기
		jsonstr = toJSON(JSONarr)
		Set ojson = JSON.Parse(jsonstr)

		tabletype = "0"
		gamestate = "0"


		'ReDim JSONarr(rscnt-1)

		'i = 0
		'Do Until rs.eof
		
'		Set rsarr = jsObject() 
'			rsarr("IDX") = rs(0)
'			rsarr("PN") = rs(1)
'			rsarr("RO") = rs(2)
'			rsarr("CO") = rs(3)
'			rsarr("MAXRO") = trcnt
'			Set JSONarr(i) = rsarr

		'i = i + 1
		'rs.movenext
		'Loop

		'datalen = Ubound(JSONarr) - 1



'		ReDim JSONarr(5)
'		For i = 0 To 5
'		Set rsarr = jsObject() 
'			rsarr("IDX") = i * 100
'			rsarr("RO") = 0
'			rsarr("CO") = i
'			Set JSONarr(i) = rsarr
'		next
'
'	jsonstr = toJSON(JSONarr)
'	Set ojson = JSON.Parse(jsonstr)
'	Response.Write jsonstr
'	Response.write "`##`"
%>


      <!-- S: preli 예선 -->
			<div class="modal-body">
      <div class="preli">



	<%If gamestate <> "" Then  	'게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임%>
      <!-- S: include preli -->
      <div class="preli-table">
        <table class="table table-striped">
        <thead>
          <tr>
          <th>조 그룹</th>
          <th <%If singlegame = False then%>colspan="1"<%End if%>>1번</th>
          <th <%If singlegame = False then%>colspan="1"<%End if%>>2번</th>
          <th <%If singlegame = False then%>colspan="1"<%End if%>>3번</th>
          <th>경기입력</th>
          </tr>
        </thead>



			<tbody>
			  <tr>
				<%
				'예선 gametable 에서 상태를 가져와서 예선 대진표 완료여부 확인 후 표시

				for i = 0 to datalen + 1
					mem1idx = ojson.Get(i).AID
					aname = ojson.Get(i).ANM
					bname = ojson.Get(i).BNM

					groupno = ojson.Get(i).GNO
					sortno = ojson.Get(i).SNO
					ateamA = ojson.Get(i).ATANM
					ateamB = ojson.Get(i).ATBNM
					bteamA = ojson.Get(i).BTANM
					bteamB = ojson.Get(i).BTBNM
					stateno = ojson.Get(i).STNO
					rt1 = ojson.Get(i).RT1
					arp = ojson.Get(i).ARP
					brp = ojson.Get(i).BRP

					'경기결과에 따라 진출여부표시
					'If rt1 = "pass"  then
					If rt1 = "1" Or rt1 = "2"  then
						rt1class = " class=""pass"" "
					Else
						rt1class = ""					
					End If
					
					'각조별 상태
					Select Case stateno 
					Case "0" :   rt1btnstate = "btn-ready" '예선준비중
					Case "2" :   rt1btnstate = "btn-ready" '예선진행중
					Case "4" :   rt1btnstate = "btn-finish" '예선경기종료
					Case "6" :   rt1btnstate = "btn-comp" '예선심판승인완료
					Case "8" :   rt1btnstate = "no-game" '양측부전패(불참)
					End Select
				%>
				  <%If groupno <> groupnotmp then%>
						<td>제<%=groupno%>조</td>
				  <%End if%>

					
					<td <%=rt1class%>>
						<div style='border: 1px solid #73AD21;'  ondrop="mx.drop(event)" ondragover="mx.allowDrop(event)" ondragend="mx.dragEnd(event)" draggable="true" ondragstart="mx.drag(event)"  id="drag_<%=n%>_<%=i%>">
						<table>
							<tr>
								<td>
								
						<span class="player"><%=aname%></span>
						<span >(<%=ateamA%>,<%=ateamB%>)</span>
						<span class="belong"><input type="text" style="width:50px;" value="<%=arp%>" ></span>
						<span class="belong"><input type="text" style="width:50px;" value="" >위</span>
						
								</td>
								<td>
						<%If singlegame = False then%>
								
							<span class="player"><%=bname%></span>
							<span class="belong">(<%=bteamA%>,<%=bteamB%>)</span>
							<span class="belong"><input type="text" style="width:50px;" value="<%=brp%>" ></span>
							<span class="belong"><input type="text" style="width:50px;" value="" >위</span>
								
						<%End if%>	
								</td>
								<tr>
						</table>
						</div>
						
					</td>
					<!--
					<%If singlegame = False then%>
					<td <%=rt1class%>>
						<span class="player"><%=bname%></span>
						<span class="belong"><%=bteamA%>,<%=bteamB%></span>
						<span class="belong"><input type="text" style="width:50px;" value="<%=brp%>" ></span>
						<span class="belong"><input type="text" style="width:50px;" value="" >위</span>
					</td>
					<%End if%>
					-->
					
			  
			  <%If CDbl(sortno) = 3 then%>
					<td>
						<a href="javascript:score.gameSearch({'TT':<%If tabletype = "20"  then%>22<%else%>2<%End if%>, 'SIDX': <%=groupno%>})" class="btn <%=rt1btnstate%>">입력</a>
					</td>
			  </tr>
			 
			  <%If i < datalen + 1 then%>
			  <tr>
			  <%End if%>

			  <%End if%>
			<%
			groupnotmp = groupno
			next%>


			<%For n = 1 To 3- CDbl(sortno)%>
				<td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td>
				<!--<%If singlegame = False then%><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td><%End if%>-->
			<%next%>


			<%If sortno <> "3" then%>
				<td>
					<a href="javascript:score.gameSearch({'TT':<%If tabletype = "20"  then%>22<%else%>2<%End if%>, 'SIDX': <%=groupno%>})" class="btn <%=rt1btnstate%>">입력</a>
				</td>
			<%End if%>


			</tr>
			</tbody>
		

        </table>
      </div>
    <!-- E: include preli -->
	<%End if%>


    </div>
		</div>
      <!-- E: preli 예선 -->

<!-- #include virtual = "/pub/api/tennisAdmin/gametable/inc.leaguebtn.asp" --><%

				

				



db.Dispose
Set db = Nothing
%>

