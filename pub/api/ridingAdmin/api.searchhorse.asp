<%
'#############################################
'말검색
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx= oJSONoutput.MIDX
	End If

	
	If hasown(oJSONoutput, "PNM") = "ok" Then 
		pnm= oJSONoutput.PNM
	End If
	

	SQL = "Select top 10 playeridx,nowyear,usertype,username,userphone,birthday,hpassport,ksportsno from tblPlayer where delyn='N' and usertype='H' and username like '" &pnm& "%' order by len(username) asc"
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
			pidx = arr(0, ar)
			nowyear = arr(1, ar)
			username = arr(3,ar)
			userphone = arr(4,ar)
			birthday = arr(5,ar)
			passport = arr(6,ar)

	%>
		<div class="form-inline" style="margin-top:10px;">
			<div class="form-group" style="width:78%">
				마명:<%=username %> 여권번호:<%=passport%>
			</div>
			<div class="form-group"  style="width:20%">
				<button type="button" class="btn btn-primary" onmousedown="mx.changeHorse(<%=midx%>,<%=pidx%>)">변경</button>
			</div>
		</div>
	<%
		Next
	End if%>

<div class="form-inline" style="margin-top:10px;">
	<div class="form-group" style="width:78%">
		<input class="form-control" id="newpname" placeholder="마명"   style="width:30%"/>
		<input class="form-control" id="newpno" placeholder="여권번호"  style="width:30%"/>
	</div>
	<div class="form-group"  style="width:20%">
	<button type="button" class="btn btn-primary" onmousedown="mx.changeMakeHorse(<%=midx%>)">생성</button>
	</div>
</div>