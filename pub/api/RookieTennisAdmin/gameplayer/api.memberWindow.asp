<%
'#############################################
' 선수관리, 신청정보 관리에 나오는 선수별 랭킹 포인트 기록 및 수정 화면
'#############################################

'request


'대회신청정보 수정에서 오면 받는다.
If hasown(oJSONoutput, "NM") = "ok" then
	nm = oJSONoutput.NM
Else
	nm = ""
End If

Set db = new clsDBHelper


	If nm <> "" Then
	'현재 등록된 선수 제외
	'notinquery  = " and m.username + replace(m.userphone,'-','') not in (select username + userphone from SD_Tennis.dbo.tblPlayer) " '카타 플레이어 제외
	notinquery2  = " and m.username + replace(m.userphone,'-','') not in (select username + userphone from SD_RookieTennis.dbo.tblPlayer) " ' 플레이어 제외
	SQL = "select top 30 m.memberidx,m.userid,m.username,m.userphone,m.birthday,m.sex from tblMember as m where username like '"&nm&"%'  " & notinquery & notinquery2
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)
	End if

'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then
'		arrRS = rs.GetRows()
'	End If
'
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rs)


'	strfield = "titleName as '대회명' ,teamGbName as '출전부서',rankno as '순위',getpoint as '포인트',ptuse as '반영', gamedate as '게임일자'  "
'	SQL = "select "&strfield&"  from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX = "&idx&" order by getpoint desc, gamedate desc  "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'#############################################




%>

<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'>통합계정검색</h3>

  </div>
<!-- 헤더 코트e -->
<div class='modal-body '>


<table class="table-list admin-table-list" id="rankplayerinfo">
<tr>
	<th scope="row">통합계정(Kata선수제외(품), 등록선수제외)</th>
	<td id="sel_VersusGb">
	<input type="text" id="membernm"  value ="<%=nm%>"  style="margin-top:9px;">
    <a href="javascript:mx.findMember('find')" class="btn_a btn_func">이름으로찾기</a>
	</td>
</tr>
</table>

<div class="scroll_box" style="margin-top:5px;font-size:12px;">
	

<table class="table-list admin-table-list">
<%
If nm <> "" Then
	If not rs.eof then
		'Call rsdrow(rs)
		Do Until rs.eof 
			fmidx = rs(0)
			fuid = rs(1)
			funame = rs(2)
			fuphone = rs(3)
			fbirth = rs(4)
			fsex = rs(5)
		%>
		<tr>
			<td><%=fmidx%></td>
			<td><%=fuid%></td>
			<td><%=funame%></td>
			<td><%=fuphone%></td>
			<td><a href="javascript:mx.memberChoice('<%=fmidx%>','<%=fuid%>','<%=funame%>','<%=fuphone%>','<%=fbirth%>','<%=fsex%>')" class="btn_a btn_func">선택</a></td>
		</tr>
		<%
		rs.movenext
		loop
	End if
End if
%>
</table>



<%


db.Dispose
Set db = Nothing
%>

</div>



</div>
