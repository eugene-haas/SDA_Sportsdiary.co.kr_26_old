<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'말새끼 증명서 프린터 화면
'#############################################
	'request
	If hasown(oJSONoutput, "SEQ") = "ok" then
		e_idx = oJSONoutput.Get("SEQ")
	End If


	Set db = new clsDBHelper

	'orderid = '"&session_uid&"' and OR_type in ('H','E1','E2')   '체크해야겠지만 패스
	SQL = "select OrderIDX,OR_type,orderid,targetidx,targetnm,targetmsg1,targetmsg2,printcnt,GameTitleIDX,Team from tblOrderTable where delyn = 'N' and OrderIDX = " & E_IDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	Else

		printcnt = rs("printcnt")
		targetidx = rs("targetidx")
		makeno = year(date) & "-" &  rs("orderidx") '발급번호 
		hnm = rs("targetnm")

		If targetidx = "" Then
			Call oJSONoutput.Set("result", 1 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

		If printcnt > 0 Then
			Call oJSONoutput.Set("result", 1 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	end if


	'말정보 tblPlayer
	SQL = "Select playeridx,hpassport,hnation,hhairclr,Birthday from tblPlayer where playeridx = " & targetidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		hpassport = rs("hpassport")
		hnation = rs("hnation")
		Birthday = isnulldefault(rs("Birthday"),"")
		hidx = rs("playeridx")


		'말경기실적 페이지당 15개씩 최대...몇페이지인지 확인... 최대 5장 (75)
		'기간, 대회명, 종목, 순위
		'SQL = "Select "&fld&" from sd_tennisMember as a INNER JOIN sd_tennisMember_partner as b On  a.gamememberidx = b.gamememberidx and b.delyn = 'N'
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

		fld = "gameDate,titlename,CDBNM,CLASSNM,CLASSHELPNM,pubcodeNM,gameOrder,rcIDX,tidx,TO_CD,gbIDX,levelno,CDANM,CDCNM,ksportsno,playerIDX,UserName,pidx,horseName,gameYear,Team,TeamNm,userClass,attmembercnt,booOrrder,pubcode,Roundstr,RgameLevelIDX,midx,ESSEND,SEQ,gamepoint,getMoney"

		'SQL = "select  count(*)  from tblGameRecord where delyn = 'N'  "  'test
		SQL = "select  count(*)  from tblGameRecord where delyn = 'N' and  pidx = '"&hidx&"' "  
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

		If CDbl(rs(0)) > 0 then
			recordcnt = rs(0)

			'페이지수
			totalpagecount = int(recordcnt / 15)
			if ( recordcnt mod 15 ) > 0 then totalpagecount = totalpagecount + 1
			if totalpagecount <= 0 then : totalpagecount = 1

			'SQL = "select  "&fld&" from tblGameRecord where delyn = 'N'    order by gamedate desc " 'test
			SQL = "select  "&fld&" from tblGameRecord where delyn = 'N'   and  pidx = '"&hidx&"'  order by gamedate desc "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If Not rs.EOF Then
				arrH = rs.GetRows()
			End If
		Else
			totalpagecount = 1
		End if
	End if


  db.Dispose
  Set db = Nothing
%>

<%
startno = 0 'LBound(arrH, 2)
For x = 0 To totalpagecount-1%>
<div class="print">
				<span class="print_nori t_rt">페이지 <%=x+1%></span>
                  <table>
                     <thead>
                        <tr>
                           <th class="t_title" colspan="4">말경기실적증명서<img src="/images/apply-online/print_logo.svg" alt=""></th>
                        </tr>
                        <tr>
                           <th>종목</th>
                           <td>승마</td>
                           <th>발급번호</th>
                           <td><%=makeno%></td>
                        </tr>
                        <tr>
                           <th>발급일자</th>
                           <td><%=year(date)%>/<%=addZero(month(date))%>/<%=addZero(day(date))%></td>
                           <th>여권번호</th>
                           <td><%=hpassport%></td>
                        </tr>
                        <tr>
                           <th>마명</th>
                           <td><%=hnm%></td>
                           <th>산지</th>
                           <td><%=hnation%></td>
                        </tr>
                        <tr>
                           <th>모색</th>
                           <td><%=hhairclr%></td>
                           <th>생년</th>
                           <td><%=Left(Birthday,4)%></td>
                        </tr>
                     </thead>
                     <tbody>
                        <tr>
                           <td colspan="4" class="print-inner">
                              <table>
                                 <thead>
                                    <tr>
                                       <th colspan="4" class="print-inner__title">말경기실적</th>
                                    </tr>
                                    <tr>
                                       <th>기간</th>
                                       <th>대회명</th>
                                       <th>종목</th>
                                       <th>순위</th>
                                    </tr>
                                 </thead>
                                 <tbody>
						<%
							n = 1
							If IsArray(arrH)  Then
								For ar = startno To UBound(arrH, 2)
									h_gamedate = arrH(0, ar)
									h_title = arrH(1,ar)
									h_cdbnm = arrH(2,ar)
									h_classnm = arrH(3,ar)
									h_classhelpnm = arrH(4,ar)
									h_pubnm = arrH(5,ar)
									h_gameorder = arrH(6,ar)
						%>
												<tr>
                                       <td><%=Left(h_gamedate,10)%></td>
                                       <td><%=h_title%></td>
                                       <td><%=h_cdbnm%> <%=h_classnm%> Class <%=h_pubnm%></td>
                                       <%If h_gameorder = "0" then%>
									   <td></td>
									   <%else%>
									   <td><%=h_gameorder%>위</td>
									   <%End if%>
                                    </tr>
						<%
									If n Mod 15 =  0 Then
										startno = ar + 1
										Exit For
									End if
								n = n + 1
								Next
							End if

							'중간에 안나왔을수 있으니
							startno = ar + 1

							If x = totalpagecount-1 then
							'Response.write n
							'남은갯수만큼 루프
							remainderloopcnt = Abs( n - 15)
								For i = 1 To remainderloopcnt + 1
									Response.write "<tr><td></td><td></td><td></td><td></td></tr>"
								next
							End if
						%>
                                 </tbody>
                              </table>
                           </td>
                        </tr>
                     </tbody>
                     <tfoot>
                        <tr>
                           <td colspan="4">
                              <span>위와 같이 말 경기실적을 증명함.</span>
                              <strong>사단법인 <em>대한승마협회장</em></strong>
										<img src="/images/apply-online/print_stamp.png" alt="">
                           </td>
                        </tr>
                     </tfoot>
                  </table>
               </div>

<%next%>