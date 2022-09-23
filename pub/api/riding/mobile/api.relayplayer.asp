<%
'#############################################
'릴레이 팀멤버
'#############################################
	'request

  Set db = new clsDBHelper

  If hasown(oJSONoutput, "MIDX") = "ok" then
    midx = fInject(oJSONoutput.MIDX)
  End if

  If hasown(oJSONoutput, "HNM") = "ok" then
    hnm = fInject(oJSONoutput.HNM)
  End if


'리그토너먼트 구분 2, 3 
SQL = "select b.pnm,a.bigo,a.username,c.username from SD_tennisMember as a inner join sd_groupMember as b on a.gamememberidx = b.gamememberidx inner join sd_tennisMember_partner as c on a.gamememberidx = c.gamememberidx  where a.gameMemberidx = "& midx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


If Not rs.EOF Then
	arrZ = rs.GetRows()
	l_teamnm = arrZ(3,0)
End If

%>
	<div class="inner-popup__header">
	  <span><%=l_teamnm%></span>
	  <button type="button" onclick="$('#realyplayerpop').hide()"><img src="/m_player/Result/ico_close.svg" alt="모달창 닫기"></button>
	</div>

	<div class="inner-popup__con">
	  <table>
		<thead>
		  <tr>
			<th>선수명</th>
			<th>마명</th>
			<th>비고</th>
		  </tr>
		</thead>
		<tbody>
<%


If IsArray(arrZ) Then 
rowcnt = UBound(arrZ, 2) + 1

	For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
		l_pnm = arrZ(0,ari)
		l_bigo = arrZ(1,ari)
		l_teamnm = arrZ(2,ari)
		l_hnm = arrZ(3,ari)
%>
  
	  <tr>
		<th><%=l_pnm%></th>
		<%If ari = 0 then%>
		<td rowspan="<%=rowcnt%>"><%=l_hnm%></td>
		<td rowspan="<%=rowcnt%>"><%=l_bigo%></td>
		<%End if%>
	  </tr>
<%
	Next
End if
%>

		</tbody>
	  </table>
	</div>


<%
	Set rs = Nothing
	db.Dispose
	Set db = Nothing

%>
