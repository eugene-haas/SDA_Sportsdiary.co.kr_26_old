<%
	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx       
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if

	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx and pubcode = a.pubcode and delYN = 'N' ) as attcnt " '신청명수

	readlattcnt = " ,(select count(DISTINCT p1_playerIDX) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx and pubcode = a.pubcode and delYN = 'N' and gameResult in ('0','E')  ) as realattcnt " '실인원 중복제거

	strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
	strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType " & attcnt & readlattcnt & " ,okYN, a.engCode "
	strFieldName = strfieldA &  "," & strfieldB
	strSort = "  ORDER BY gameday, gameno asc, a.pubcode , RGameLevelidx Desc"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and b.DelYN = 'N' and a.gbidx =  '"&find_gbidx&"' "

	SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



'Response.write sql
'Call rsdrow(rs)
'Response.end 

	If Not rs.EOF Then
		arrR = rs.GetRows()
	Else
		arrR = ""
	End If

'Call GetRowsDrow(arrR)


'	'부별성립여부
	SQL = "select TeamGb,realcnt,TeamGbNm from tblRealPersonNo where useyear ='"&nowgameyear&"' " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If Not rs.EOF Then
		arrB = rs.GetRows()
	End If

'	Call rsdrow(rs)
'	Response.end
              
'    strRDetail = uxGetStrDetailList(arrR)           ' Rinding List String 
 '   strBLimit  = uxGetStrLimitList(arrB)            ' 부별 인원수 List String 


%>
        <!-- ******** list data와 부별 limit를 hidden string으로 가지고 있는다. *****  -->                    
        <input type="hidden" id="hide_strRDetail" value="<%=strRDetail%>">
        <input type="hidden" id="hide_strBLimit" value="<%=strBLimit%>">
        <input type="hidden" id="hide_tidx" value="<%=tidx%>">
        <input type="hidden" id="hide_gYear" value="<%=nowgameyear%>">
<%

'Call getRowsDrow(arrR)
'Response.end

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			r_a1 = arrR(0, ari) 'idx
			idx = r_a1
			r_a2 = arrR(1, ari) 'gameno
			r_a3 = arrR(2, ari) 'tidx
			r_a4 = arrR(3, ari) 'gbidx
			r_a5 = arrR(4, ari) 'pubcode
			r_a6 = arrR(5, ari) 'pubname
			r_a7 = arrR(6, ari) '시작
			r_a8 = arrR(7, ari) '종료
			r_a9 = arrR(8, ari) '게임일
			r_a10 = arrR(9, ari)
			r_a11 = arrR(10, ari)
			r_a12 = arrR(11, ari) 
			r_a13 = arrR(12, ari) 'fee
			r_a14 = arrR(13, ari) 'cfg



			chk1 = Left(r_a14,1)
			chk2 = Mid(r_a14,2,1)
			chk3 = Mid(r_a14,3,1)
			chk4 = Mid(r_a14,4,1)

			r_b1 = arrR(14, ari)
			r_b2 = arrR(15, ari)
			r_b3 = arrR(16, ari)
			r_b4 = arrR(17, ari) '개인/단체
			r_b5 = arrR(18, ari) 
			r_b6 = arrR(19, ari) '종목
			r_b7 = arrR(20, ari)
			r_b8 = arrR(21, ari) '마종
			r_b9 = arrR(22, ari) 'class
			r_b10 = arrR(23, ari) 'classhelp
			r_b11 = arrR(24, ari)            

			r_attcnt = arrR(25, ari) ' 신청명수
			r_readlattcnt = arrR(26, ari) '실인원

			r_a15 = arrR(27, ari) 'okYN 성립완료 확정
            r_a16 = arrR(28, ari) 'pub code engName


			titlestr = r_b6 & "/" & r_b8 & "/" & r_b9 & "/" & r_b10  

			If CStr(r_a2) <> CStr(pre_gameno) Then
				trborder = "style=""border-top:2px solid red;"" "
			Else
				trborder = ""
			End If
			
			If CStr(r_a9) <> CStr(pre_gameday) Then
				day_trborder = "style=""border-top:2px solid green;"" "
			Else
				day_trborder = ""
			End If
%>


		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>"><!-- style="cursor:pointer"  -->

			<td <%=trborder%> ><span><%=r_a6%></span></td>
			<td <%=trborder%> ><span><%=r_readlattcnt%></span></td>
			<td <%=trborder%> ><span><%=r_attcnt%></span></td>

			<td <%=trborder%>><span>
			  <%
				chkst = false
				If IsArray(arrB) Then 
					For arb = LBound(arrB, 2) To UBound(arrB, 2)
						chk_gb = arrB(0, arb) '성립미성립 체크 (마장마술...)
						chk_cnt = arrB(1, arb) '성립미성립 체크 (성립명수...)
						If CStr(r_b5) = CStr(chk_gb) And CDbl(r_readlattcnt) >= CDbl(chk_cnt) Then
							Response.write "성립 : " & chk_cnt
							chkst = True
						End If
						If CStr(r_b5) = CStr(chk_gb) Then
							chk_boocnt = chk_cnt
						End if
					Next
					If chkst = False then
						Response.write "<span style='color:red'>미성립 : </span>" & chk_boocnt
					End if
				Else
					Response.write "조건생성안됨"
				end if	
			  %>
			</span></td>

			<td <%=trborder%>><input type="checkbox" id="<%=r_a4%>_<%=r_a5%>" value=<%=idx%>></td><!-- gbidx + pubcode    클릭시 연계성 알려줌 나중에 -->




		  </tr>
<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		Next
	End if
%>

