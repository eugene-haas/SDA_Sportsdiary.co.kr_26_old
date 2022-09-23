<%
'request
	pidx = oJSONoutput.Get("PIDX")
	Set selectyear = oJSONoutput.Get("SELECTYEAR") '년도배열


	Set db = new clsDBHelper

	'참가확인서 발급요건 확인 기본 1로 온다. (경영만 넣어두었다 일딴 다른건 기록에 들어가면 하자)
	If pidx = "53865" then
	SQL = "select max(rcIDX), max(gametitleidx),max(titlecode), titlename, max(gamedate) "
	SQL = SQL & " from tblRecord  where delyn = 'N' and  ( playeridx = 48565 or playeridx2 = 48565 or playeridx3 = 48565 or playeridx4 = 48565 )  group by titlename order by 5 desc "
	Else
	SQL = "select max(rcIDX), max(gametitleidx),max(titlecode), titlename, max(gamedate) "
	SQL = SQL & " from tblRecord  where delyn = 'N' and  ( playeridx = "&pidx&" or playeridx2 = "&pidx&" or playeridx3 = "&pidx&" or playeridx4 = "&pidx&" )  group by titlename order by 5 desc "
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.eof Then
		arrP = rs.GetRows()
		s_year = Left(arrP(4, 0 ),4)
		e_year = Left(arrP(4, ubound(arrP,2)) , 4)
	End if

	'선택한 대회 매칭
	SQL = "select ctemp4 from tblPlayer where playeridx = '"&pidx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then

		Info4 = Split(rs(0),",")
	End if


	db.Dispose
	Set db = Nothing

'선택한 대회 매칭
'받아온 년도 선택되도록

'Call getrowsdrow(arrp)
%>


					 <div class="m_multi-selc-box t_w100per" id="gametitle" onclick="mx.multiSelectBox($(this))">
                     <button class="m_multi-selc-box__result"  id="selectgame" type="button"></button>
					 <ul>
						<%
						If IsArray(arrP) Then
							For aa = LBound(arrP, 2) To UBound(arrP, 2) 
 								show = false
								m_key = arrP(0, aa)
 								m_title = arrP(3, aa)
 								m_date = arrP(4, aa)


								For intloop = 0 To oJSONoutput.Get("SELECTYEAR").length-1
									If  Left(m_date,4)  = CStr(selectyear.Get(intloop)) Then
										show = True
										Exit For
									End if
								Next
						
								If show = True then
								%>
								   <%
								   lineselect = false
								   If isArray(Info4) Then
										For x = 0 To ubound(info4)
											If CStr(m_key) = CStr(info4(x)) Then
												lineselect = true
											End if
										next
								   End if
								   %>
								<li class="m_multi-selc-box__list <%If lineselect = True then%>s_selected<%End if%>">
								   <button type="button" onclick="mx.SelectValue($(this), '<%=m_key%>' ,<%=pidx%>, 2)"><%=m_title%></button>
								</li>
								<%
								End if

							next
						End if
						%>
                     </ul>
					</div>