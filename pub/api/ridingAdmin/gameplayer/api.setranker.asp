<%
'#############################################
'동일 이름의 포인트 정보를 클릭한 아이디로 모두 합친다.
'#############################################
	'request

	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	End If
	If hasown(oJSONoutput, "PNAME") = "ok" then
		pname = oJSONoutput.PNAME
	End If

	If hasown(oJSONoutput, "PTITLE") = "ok" then
		ptitle = oJSONoutput.PTITLE
	End If

    If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End If


	Set db = new clsDBHelper



	rnkquery = "(SELECT sum(getpoint) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as '랭킹포인트' "
	rnkcount = "(SELECT count(*) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as '랭킹갯수' "
	strTableName = " tblPlayer as a "
	strFieldName = " PlayerIDX,UserName,WriteDate,dblrnk ,levelup,openrnkboo , chkTIDX,startrnkdate,gameday,chklevel,endrnkdate "
	strFieldName = strFieldName & " ,"&rnkquery&", "&rnkcount&"  "
	strSort = "  ORDER By UserName Asc"
	strSortR = "  ORDER By  UserName Desc"
	strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and playeridx = " & pidx

	SQL = "Select "&strFieldName&" from "&strTableName&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		dblrnk = rs("dblrnk")
		levelup =rs("levelup") '승급년도
		chkTIDX = rs("chkTIDX")
		startrnkdate = rs("gameday") '수정
		endrnkdate = rs("endrnkdate")
		chklevel = rs("chklevel")
	End if

%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'>외부랭커포인트날짜지정</h3>
</div>

<%'Call rsdrow(rs)%>

<table class="table-list admin-table-list" id="playerlist">
<colgroup><col width="70px"><col width="60px"><col width="150px"><col width="60px"><col width="60px"><col width="60px"></colgroup>
<thead id="headtest">
<tr><th>승급자</th>
<th>승급대회</th>
<th>부서(필수)</th>
<th><span>승급일(필수-없으면랭킹오류)</span></th>
<th><span>종료</span></th>
<th><span>반영여부</span></th>
</tr>
</thead>

<tbody id="contest">

<tr class="gametitle">
		<td><%=pname%></td>
		<td><%=ptitle%></td>
		<td>
			<select id="boono" class="sl_search">
				<option value="">필수선택</option>
				<option value="20101" <%If chklevel = "20101" then%>selected<%End if%>>개나리</option>
				<option value="20104" <%If chklevel = "20104" then%>selected<%End if%>>신인부</option>
			<select >
		</td>
		<td>
			<input type="date" id="rnkstart" value="<%=startrnkdate%>" placeholder="<%=date%>" style="height:31px;margin-bottom:0px;">
		</td>
		<td>
			<input type="date" id="rnkend" value="<%=endrnkdate%>" placeholder="<%=date+ 720%>" style="height:31px;margin-bottom:0px;">
		</td>
		<td ><input type="checkbox" id="rnkyn" value="Y" <%If dblrnk = "Y" then%>checked<%End if%>></td>
	</tr>
</tbody>
</table>



<%'Call rsDrow(rs)%>


<div style="text-align:center;">
<%
	strjson = JSON.stringify(oJSONoutput)
%>

<% If tidx <> "" Then %>
    <a href='javascript:sd.setRankerOK(<%=strjson%>)' class="btn">선택된값으로 외부랭킹적용 반영</a>
<% Else %>
    <a href='javascript:mx.setRankerOK(<%=strjson%>)' class="btn">선택된값으로 외부랭킹적용 반영</a>
<% End If %>
</div>


<%
db.Dispose
Set db = Nothing
Call oJSONoutput.Set("result", 0 )
'strjson = JSON.stringify(oJSONoutput)
'Response.Write strjson
%>
