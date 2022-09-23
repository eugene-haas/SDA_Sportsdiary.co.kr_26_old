<%
'request
PIDX = oJSONoutput.Get("PIDX")

playerinfo = request.Cookies("playerinfo")
If playerinfo <> ""  Then

	playerinfo = f_dec(playerinfo)
	Set playerobj = JSON.Parse( join(array(playerinfo)) )

	s_team =  playerobj.Get("a")
	s_username =  playerobj.Get("b")
	s_birthday = playerobj.Get("c")
	s_userphone =  playerobj.Get("d")
	s_pidx = playerobj.Get("e")
	s_skey = playerobj.Get("f")
	s_lastregyear = playerobj.Get("g")
Else
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end		
		'잘못된 접근
End if

If pidx <> s_pidx Then
	Response.end
End if



	Set db = new clsDBHelper


	pagesize = 15
	'선수정보
	SQL = "select addr1,addr2, team,teamnm,   ctemp1,ctemp2,ctemp3,ctemp4  from tblPlayer where playeridx = "&s_pidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	
	If rs.eof Then
		Response.end
	else
		addr1 = rs(0)
		addr2 = rs(1)
		teamnm = rs(3)

		info1 = rs(4) '발급용도
		info2 = rs(5) '제출처
		info3 = rs(6) '증명서 종류 1 대회참가확인서 2 선수실적증명서
		info4 = rs(7) ' 대참인경우 대회 tblrecord index 들 

		If info3 = "1" Then
			title = "대회참가확인서"
		Else
			title = "대회참가실적확인서"
		End If
		
	End if




	'참가확인서 발급요건 확인 기본 1로 온다. (경영만 넣어두었다 일딴 다른건 기록에 들어가면 하자)
	If s_pidx = "53865" then

		If info3 = "1" Then '대회참가확인서

			SQL = ""
			SQL = SQL & " select count(*) from "
			SQL = SQL & " (select * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&")) and  ( playeridx = 48565 or playeridx2 = 48565 or playeridx3 = 48565 or playeridx4 = 48565 ) ) as a  "
'			SQL = SQL & " (select top 35 * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&")) and delyn = 'N' ) as a  " 'test
			SQL = SQL & " left join sd_gametitle as b "
			SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
			SQL = SQL & " where a.delyn = 'N'	 "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If CDbl(rs(0)) > 0 then
				recordcnt = rs(0)

				'페이지수
				totalpagecount = int(recordcnt / pagesize)
				if ( recordcnt mod pagesize ) > 0 then totalpagecount = totalpagecount + 1
				if totalpagecount <= 0 then : totalpagecount = 1

				SQL = ""
				SQL = SQL & " select a.gamedate,a.titlename,b.games,b.gamee,a.gamearea,a.cdcnm,a.gameresult,a.roundstr,a.gameorder,a.cda from "
				SQL = SQL & " (select * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&")) and   ( playeridx = 48565 or playeridx2 = 48565 or playeridx3 = 48565 or playeridx4 = 48565 ) ) as a  "
'				SQL = SQL & " (select  top 35 * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&")) and delyn = 'N'  ) as a  " 'test
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	order by gamedate desc  "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					arrH = rs.GetRows()
				End if

			Else
				totalpagecount = 1
			End if
	
		
		Else '실적증명

				SQL = ""
				SQL = SQL & " select count(*) from "
				SQL = SQL & " (select *  from tblRecord where delyn = 'N' and delyn = 'N' and  ( playeridx = 48565 or playeridx2 = 48565 or playeridx3 = 48565 or playeridx4 = 48565 )) as a  "
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	 "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If CDbl(rs(0)) > 0 then
				recordcnt = rs(0)

				'페이지수
				totalpagecount = int(recordcnt / pagesize)
				if ( recordcnt mod pagesize ) > 0 then totalpagecount = totalpagecount + 1
				if totalpagecount <= 0 then : totalpagecount = 1

				SQL = ""
				SQL = SQL & " select a.gamedate,a.titlename,b.games,b.gamee,a.gamearea,a.cdcnm,a.gameresult,a.roundstr,a.gameorder,a.cda from "
				SQL = SQL & " (select *  from tblRecord where delyn = 'N' and  delyn = 'N' and  ( playeridx = 48565 or playeridx2 = 48565 or playeridx3 = 48565 or playeridx4 = 48565 )) as a  "
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	order by gamedate desc  "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					arrH = rs.GetRows()
				End if

			Else
				totalpagecount = 1
			End if


		End if

	Else '실제로 나올곳

		If info3 = "1" Then '대회참가확인서

				SQL = ""
				SQL = SQL & " select count(*) from "
				SQL = SQL & " (select * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&"))  and  ( playeridx = "&s_pidx&" or playeridx2 = "&s_pidx&" or playeridx3 = "&s_pidx&" or playeridx4 = "&s_pidx&" ) ) as a  "
				'SQL = SQL & " (select top 35 * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&")) and delyn = 'N' ) as a  " 'test
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	 "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If CDbl(rs(0)) > 0 then
				recordcnt = rs(0)

				'페이지수
				totalpagecount = int(recordcnt / pagesize)
				if ( recordcnt mod pagesize ) > 0 then totalpagecount = totalpagecount + 1
				if totalpagecount <= 0 then : totalpagecount = 1

				SQL = ""
				SQL = SQL & " select a.gamedate,a.titlename,b.games,b.gamee,a.gamearea,a.cdcnm,a.gameresult,a.roundstr,a.gameorder,a.cda from "
				SQL = SQL & " (select * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&"))  and  ( playeridx = "&s_pidx&" or playeridx2 = "&s_pidx&" or playeridx3 = "&s_pidx&" or playeridx4 = "&s_pidx&" ) ) as a  "
				'SQL = SQL & " (select  top 35 * from tblRecord where titlename in (select titlename from tblRecord where delyn = 'N' and rcIDX in ("&info4&")) and delyn = 'N'  ) as a  " 'test
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	order by gamedate desc  "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					arrH = rs.GetRows()
				End if

			Else
				totalpagecount = 1
			End if
	
		
		Else '실적증명

				SQL = ""
				SQL = SQL & " select count(*) from "
				SQL = SQL & " (select *  from tblRecord where delyn = 'N' and delyn = 'N' and  ( playeridx = "&s_pidx&" or playeridx2 = "&s_pidx&" or playeridx3 = "&s_pidx&" or playeridx4 = "&s_pidx&" )) as a  "
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	 "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If CDbl(rs(0)) > 0 then
				recordcnt = rs(0)

				'페이지수
				totalpagecount = int(recordcnt / pagesize)
				if ( recordcnt mod pagesize ) > 0 then totalpagecount = totalpagecount + 1
				if totalpagecount <= 0 then : totalpagecount = 1

				SQL = ""
				SQL = SQL & " select a.gamedate,a.titlename,b.games,b.gamee,a.gamearea,a.cdcnm,a.gameresult,a.roundstr,a.gameorder,a.cda from "
				SQL = SQL & " (select *  from tblRecord where delyn = 'N' and  delyn = 'N' and  ( playeridx = "&s_pidx&" or playeridx2 = "&s_pidx&" or playeridx3 = "&s_pidx&" or playeridx4 = "&s_pidx&" )) as a  "
				SQL = SQL & " left join sd_gametitle as b "
				SQL = SQL & "	on a.gametitleidx = b.gametitleidx and b.delyn = 'N'  "
				SQL = SQL & " where a.delyn = 'N'	order by gamedate desc  "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					arrH = rs.GetRows()
				End if

			Else
				totalpagecount = 1
			End if




		End if
	
	End if






	db.Dispose
	Set db = Nothing
%>
  
  
  <link rel="stylesheet" href="/home/css/default.css?ver=1.8">
  <link rel="stylesheet" href="/home/css/style.css?ver=1.8">





   <div class="l_print">
      <ol>

<%
startno = 0 'LBound(arrH, 2)
For x = 0 To totalpagecount-1
%>
         <li class="l_print__page">
            <section class="m_confirmation">
               <header class="m_confirmation__header">
                  <h1><%=title%></h1>
               </header>
               <div class="m_confirmation__con">
                  <table class="m_confirmation__con__tbl">
                     <thead class="m_confirmation__con__tbl__head">
                        <tr>
                           <th class="t_ls2">종목</th>
                           <td>경영</td>
                           <th class="t_ls4">발급번호</th>
                           <td><%=year(date)%>-<%=seq%></td>
                        </tr>
                        <tr>
                           <th class="t_ls4">발급일자</th>
                           <td><%=date%></td>
                           <th class="t_ls4">발급부수</th>
                           <td>1</td>
                        </tr>
                        <tr>
                           <th class="t_ls2">성명</th>
                           <td><%=s_username%></td>
                           <th class="t_ls4">생년월일</th>
                           <td><%=Left(s_birthday,2)%>.<%=Mid(s_birthday,3,2)%>.<%=Right(s_birthday,2)%></td>
                        </tr>
                        <tr>
                           <th class="t_ls2">주소</th>
                           <td><%=addr1%></td>
                           <th class="t_ls2">소속</th>
                           <td><%=teamnm%></td>
                        </tr>
                        <tr>
                           <th class="t_ls2">용도</th>
                           <td><%=info1%></td>
                           <th class="t_ls3">제출처</th>
                           <td><%=info2%></td>
                        </tr>
                     </thead>
                     <tbody class="m_confirmation__con__tbl__body">
                        <tr>
                           <td colspan="4">
                              <div class="m_confirmation__con__tbl__body__tbl-wrap">
                                 <table class="m_confirmation__con__tbl__body__tbl">
                                    <thead class="m_confirmation__con__tbl__body__tbl__head">
                                       <tr>
                                          <th>년도</th>
                                          <th>대회명</th>
                                          <th>대회기간</th>
                                          <th>장소</th>
                                          <th>종목</th>
                                          <th>기록</th>
                                          <th>순위</th>
                                          <th>비고</th>
                                       </tr>
                                    </thead>
                                    <tbody class="m_confirmation__con__tbl__body__tbl__body">
                                       <!-- // max length = 15 -->
										<%
											n = 1
											If IsArray(arrH)  Then
												For ar = startno To UBound(arrH, 2)
													h_gamedate = arrH(0, ar)
													h_title = arrH(1,ar)
													h_games = isnulldefault(arrH(2,ar),"")
													h_gamee = arrH(3,ar)
													h_gamearea = arrH(4,ar)
													h_cdcnm = arrH(5,ar)
													h_gameresult = arrH(6,ar)
													h_roundstr = arrH(7,ar)
													h_gameorder = arrH(8, ar)
													h_cda = arrH(9,ar)
										%>
													   <tr>
														  <td><%=Left(h_gamedate,4)%></td>
														  <th><span class="m_confirmation__con__tbl__body__tbl__body__title"><%=h_title%></span></th>
														  <td>
														  <%If h_games = "" then%>
														  <%=Left(h_gamedate,10)%>
														  <%else%>
														  <%=Left(h_games,10)%>~<%=Left(h_gamee,10)%>
														  <%End if%>
														  </td>
														  <td><%=gamearea%></td>
														  <td><%=h_cdcnm%></td>
														  <td><%If h_cda = "D2" then%><%=Left(h_gameresult,2)& ":"	& Mid(h_gameresult,3,2)& "."&Mid(h_gameresult,5,2)%><%End if%></td>
														  <td><%=h_gameorder%>위</td>
														  <td><%=h_roundstr%></td>
													   </tr>
										<%
													If n Mod pagesize =  0 Then
														startno = ar + 1
														Exit For
													End if
												n = n + 1
												Next
											End if

											'중간에 안나왔을수 있으니
											startno = ar + 1

											'If x = totalpagecount-1 Then '마지막 페이지라면
											'Response.write n
											'남은갯수만큼 루프
											'remainderloopcnt = Abs( n - 15)
											'	For i = 1 To remainderloopcnt + 1
											'		Response.write "<tr><td></td><td></td><td></td><td></td></tr>"
											'	next
											'End if
										%>

									</tbody>
                                 </table>

											<%
											If x = totalpagecount-1 Then '마지막 페이지라면
											'Response.write n
											'남은갯수만큼 루프
											remainderloopcnt = Abs( n - pagesize)
												If remainderloopcnt = 0 Then
												else
													Response.write remainderloopcnt & "<span>-------- <span class=""t_ls4"">이하여백</span> --------</span>"
												End if
											End if
											%>
											<span class="t_sample">견본</span>

                              </div>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="4" class="t_lh128">본 연맹에서는 상기인의 실적을 위와 같이 확인함.</td>
                        </tr>
                     </tbody>
                     <tfoot class="m_confirmation__con__tbl__foot">
                        <tr>
                           <td colspan="4"><!--기록대조확인 : 안동욱--></td>
                        </tr>
                     </tfoot>
                  </table>
               </div>
               <footer class="m_confirmation__footer t_sample">
                  <h2>사단법인 대한수영연맹회장</h2>
               </footer>
            </section>
         </li>



<%next%>


      </ol>
   </div>