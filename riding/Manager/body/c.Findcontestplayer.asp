<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%

 'Controller ################################################################################################

	  '등록된 최소년도
	  SQL = "Select min(gameYear) from sd_TennisTitle where delYN = 'N' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If  isNull(rs(0)) = true then
		  minyear = year(date)
	  Else
		  minyear = rs(0)
	  End if



	'#############################
	intPageNum = PN 'requestRiding.asp에서 정의
	intPageSize = 20

	If F1_0 = "" Then
		F1_0 = 1
	End if

	'신청기간 ,  모집상태 , 참가신청수(명), 참가말 수량, 마방신청, 톱밥신청포수, 총참가비원

	'복합마술의 경우 한개만 포함되도록 해야한다. (마장마술만 포함시키자 >> 조건은:  복합마술의 장애물은 (field 값이 gametype = 0 복합마술 장애물) 100이상은 제외되지 않는 종목, 아래는 제외할 종목
	subP = "(select count(distinct p1_playeridx) from tblGameRequest where GameTitleIDX = a.gametitleidx  and delYN = 'N' and gametype >= 100  ) as pcnt "
	subH = "(select count(distinct p2_playeridx) from tblGameRequest where GameTitleIDX =a.gametitleidx  and delYN = 'N' and gametype >= 100  ) as hcnt "

	subMB = "(select count( mabang) from tblGameRequest where GameTitleIDX =a.gametitleidx and mabang = 'Y' and delYN = 'N' and gametype >= 100 ) as mabang "
	subTB = "(select sum(topbob) from tblGameRequest where GameTitleIDX =a.gametitleidx  and delYN = 'N' and gametype >= 100  ) as topbob "
	subPM = "(select sum(payment) from tblGameRequest where GameTitleIDX =a.gametitleidx and delYN = 'N' and gametype >= 100  ) as payment "

	strTableName = " sd_TennisTitle as a "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,EnterType,stateNO,titleGrade,kgame,gamearea, gametypeE, gametypeA, gametypeL, gametypeP, gametypeG ,atts,atte ," & subP & "," & subH & "," & subMB & "," & subTB & "," & subPM
	'strFieldName = subseq1

	strSort = "  ORDER By gametitleidx Desc"
	strSortR = "  ORDER By  gametitleidx Asc"


	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and gameYear = '"&year(date)&"' "
		F1_0 = 1 '선수 말 (2)
	Else

		'Response.write f2
		'Response.end
		
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("gameyear","atte","atts","atte","gametype*","gametitlename")
			F2_0 = F2(0)
			F2_1 = F2(1)
			F2_2 = F2(2)
			F2_3 = F2(3)
			F2_4 = F2(4)
			F2_5 = F2(5)

		strWhere = " DelYN = 'N' and gameYear = '"&year(date)&"' "

			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' "
			If F2_1 <> "" Then
				Select Case F2_1
				Case "1" : strWhere = strWhere & " and " & fieldarr(1) & " >= getdate() "    '진행
				Case "2" : strWhere = strWhere & " and " & fieldarr(1) & " < getdate() "    '마감
				Case "3" : strWhere = strWhere & ""  '전체
				End select
			End If
			
			If F2_2 <> "" Then
				strWhere = strWhere & " and " & fieldarr(2) & " >= '"&F2_2&"' "    
			End If
			If F2_3 <> "" Then
				strWhere = strWhere & " and " & fieldarr(3) & " <= '"&F2_3&"' "
			End if			
			If F2_4 <> "NNN" And F2_4 <> "" Then
				F2_E = Left(F2_4,1)
				F2_A = Mid(F2_4,2,1)
				F2_L = Right(F2_4,1)
				strWhere = strWhere & " and ( " 
				x = 0
				If F2_E = "E" Then
					strWhere = strWhere & "  gametypeE = 'Y' "
					x = x + 1
				End If
				If F2_A = "A" Then
					If x = 0 then
						strWhere = strWhere & "  gametypeA = 'Y' "
					Else
						strWhere = strWhere & " or  gametypeA = 'Y' "
					End If
					x = x + 1
				End If
				If F2_L = "L" Then
					If x = 0 then
						strWhere = strWhere & "  gametypeL = 'Y' "
					Else
						strWhere = strWhere & " or gametypeL = 'Y' "
					End if
				End if	
				strWhere = strWhere & ")"
			End If
			
			If F2_5 <> "" Then
				strWhere = strWhere & " and " & fieldarr(5) & " like '%"&F2_5&"%' "
			End if

			
			'엑셀에 넣을 json 만들자.@@@
			'
			'엑셀에 넣을 json 만들자.@@@
		End if
	End if

'Response.write strwhere & "<br>"
'Response.write F2_E & "<br>"

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	if rs.eof Then
		arrList = ""
	Else
		Set rsdic = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
		For i = 0 To Rs.Fields.Count - 1
			rsdic.Add LCase(Rs.Fields(i).name), i 
		Next
		arrList = rs.getrows()
	end if
	set rs = Nothing
%>
<%'View ####################################################################################################%>
<div class="admin_content">
	<!-- s: 페이지 타이틀 -->
	<div class="page_title"><h1>대회정보 - 대회신청 정보 (tblGameRequest)</h1></div>
	<!-- e: 페이지 타이틀 -->

	<!-- s: 정보 검색 -->
	<div class="info_serch">
		<!-- #include virtual = "/pub/html/riding/attmemberform.asp" -->
	</div>
	<!-- e: 정보 검색 -->

	<hr />

	<!-- s: 전체 페이지 -->
	<div class="btn-toolbar">
<!-- 		<a href="" class="btn btn-primary">엑셀다운로드</a> -->
		<!-- 전체 <span id="totcnt"><%=intTotalCnt%></span>건</a> -->
	</div>
	<!-- s: 전체 페이지 -->

	<!-- s: 테이블 리스트 -->
	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover">
			<thead>
				<tr>
					<th>NO</th>
					<th>년도</th>
					<th>대회기간</th>
					<th>국제구분</th>
					<th>대회명</th>
					<th>장소</th>
					<th>대회구분</th>
					<th>신청기간</th>
					<th>모집상태</th>
					<th>참가신청</th>
					<th>참가말</th>
<!-- 					<th>마방신청</th> -->
<!-- 					<th>톱밥신청포수</th> -->
					<th>총참가비(원)</th>
					<th>상세보기</th>
				</tr>
			</thead>

			<tbody id="contest">

			<%
			If IsArray(arrList) Then
			For ar = LBound(arrList, 2) To UBound(arrList, 2)
				'dic 소문자로
				'GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,EnterType,stateNO,titleGrade,kgame
				seq= arrList(rsdic.Item("gametitleidx"), ar)
				gameYear= arrList(rsdic.Item("gameyear"), ar)
				games= arrList(rsdic.Item("games"), ar)
				gamee   = arrList(rsdic.Item("gamee"), ar)
				gameperiod = Right(Replace(games,"-","."),5) & " ~ " & Right(Replace(gamee,"-","."),5)
				kgame= arrList(rsdic.Item("kgame"), ar)
				If kgame = "N" then
				kgamestr   = "국내"
				Else
				kgamestr   = "국제"
				End if
				gamenm= arrList(rsdic.Item("gametitlename"), ar)
				gamearea= arrList(rsdic.Item("gamearea"), ar)
				enterE= arrList(rsdic.Item("gametypee"), ar)
				enterA= arrList(rsdic.Item("gametypea"), ar)
				enterL= arrList(rsdic.Item("gametypel"), ar)
				If enterE = "Y" Then
					enterstr = ",전문"
				End If
				If enterE = "Y" Then
					enterstr = enterstr & ",생활"
				End If
				If enterE = "Y" Then
					enterstr = enterstr & ",유소년"
				End if				
				atts= arrList(rsdic.Item("atts"), ar)
				atte= arrList(rsdic.Item("atte"), ar)
				attstr = Mid(atts,6,5) & "~"& Mid(atte,6,5)
				If CDate(atte) < Date() Then
					attstate = "마감"
					attstyle = "background:#337AB7;color:white;"
				Else
					attstate = "진행중"
					attstyle = "background:#595959;color:white;"
				End if
				pcnt= arrList(rsdic.Item("pcnt"), ar)
				hcnt= arrList(rsdic.Item("hcnt"), ar)
				mabang= arrList(rsdic.Item("mabang"), ar)
				topbob= arrList(rsdic.Item("topbob"), ar)
				payment= arrList(rsdic.Item("payment"), ar)



			%>
						<tr onclick="mx.input_edit(<%=seq%>)" style="cursor:pointer;" id="titlelist_<%=seq%>">
							<td><%=seq%></td>
							<td><%=gameYear%></td>
							<td><%=gameperiod%></td>
							<td><%=kgamestr%></td>
							<td style="text-align:left;"><%=gamenm%></td>
							<td><%=gamearea%></td>
							<td><%=Mid(enterstr,2)%></td>
							<td><%=replace(attstr,"-",".")%></td>
							<td style="<%=attstyle%>"><%=attstate%></td>
							<td><%=pcnt%></td>
							<td><%=hcnt%></td>

<!-- 							<td><%=mabang%></td> -->
<!-- 							<td><%=topbob%></td> -->
							<td><%=payment%></td>
							<td><a href="./findcontestlevel.asp" class="btn btn-primary">상세보기</a></td>
						</tr>
			<%
			Next
			End if
			%>


			</tbody>
		</table>
	</div>




<%
	jsonstr = JSON.stringify(oJSONoutput)
	Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
%>
</div>

