<%
'#############################################
'릴레이에서 선수변경창
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then  'groupmember idx
		requestidx= oJSONoutput.MIDX
	End If

	
	If hasown(oJSONoutput, "PNM") = "ok" Then 
		pnm= oJSONoutput.PNM
	End If
	
	SQL = "select idx,gameMemberIDX,pidx,pnm,tidx,gbidx from sd_groupMember  where gameMemberidx = ( select top 1 gameMemberIDX from sd_groupMember where idx = " & requestidx & " )  order by orderno"

	'SQL = "Select top 10 playeridx,nowyear,usertype,username,userphone,birthday,hpassport,ksportsno from tblPlayer where delyn='N' and usertype='P' and username like '" &pnm& "%' order by len(username) asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rs)
'Response.end

	If Not rs.EOF Then
		arr = rs.GetRows()
	End If
	rs.close
	

  db.Dispose
  Set db = Nothing
%>

	<%
	If IsArray(arr) Then
		For ar = LBound(arr, 2) To UBound(arr, 2)
			idx = arr(0, ar)
			midx = arr(1,ar)
			pidx = arr(2, ar)
			username = arr(3,ar)
			tidx = arr(4,ar)
			gbidx = arr(5,ar)

	%>
		<div class="form-inline" style="margin-top:10px;">
			<div class="form-group" style="width:78%">
				이름:<%=username %> <!-- 체육인번호:<%=kno%> 생일 : <%=birthday%> -->
			</div>
			<div class="form-group"  style="width:20%">
				<button type="button" class="btn btn-primary" onmousedown="mx.changePlayerGroup(<%=requestidx%>,<%=idx%>)">변경</button>
			</div>
		</div>
	<%
		Next
	End if%>

<!-- <div class="form-inline" style="margin-top:10px;">
	<div class="form-group" style="width:78%">
		<input class="form-control" id="newpname" placeholder="이름"   style="width:30%"/>
		<input class="form-control" id="newpno" placeholder="체육인번호"  style="width:30%"/>
		<input class="form-control" id="newpbirth" placeholder="생일 8자리숫자"  style="width:30%"/>
	</div>
	<div class="form-group"  style="width:20%">
	<button type="button" class="btn btn-primary" onmousedown="mx.changeMakePlayer(<%=midx%>)">생성</button>
	</div>
</div> -->