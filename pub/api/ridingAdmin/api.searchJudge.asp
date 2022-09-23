<%
'#############################################
'선수변경창
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "PNM") = "ok" Then 
		pnm= oJSONoutput.PNM
	End If

	If hasown(oJSONoutput, "ANM") = "ok" Then  'BEMCH    A(스튜어드, sit-in , shadow)
		anm = oJSONoutput.ANM
	End If
	If hasown(oJSONoutput, "TYPENO") = "ok" Then  '구분 1 심판 2 스크라이버,   A:1,2,3
		typeno = oJSONoutput.TYPENO
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" Then  'tblRGameLevel.RGameLevelidx
		ridx = oJSONoutput.RIDX
	End If


	
	Select Case anm
	Case "B","E","M","C","H"
		Select Case  typeno
		Case "1" '심판
			strw = " delyn='N' and usertype in ('J','S') "
		Case "2" '스크라이버
			strw = " delyn='N' and usertype in ('J','S') "
		End Select 
		

	Case "A"
		Select Case  typeno
		Case "1" '스튜어드
			strw = " delyn='N' and usertype in ('J','S') "
		Case "2" 'sit-in
			strw = " delyn='N' and usertype in ('J','S') "
		Case "3" 'shadow
			strw = " delyn='N' and usertype in ('J','S') "
		End Select 

	End Select 
	SQL = "Select top 10 playeridx,nowyear,usertype,username,userphone,birthday,hpassport,ksportsno,kef1,kef2,kef3 from tblPlayer where "& strw &" and username like '" &pnm& "%' order by len(username) asc"
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

	<table cellspacing="0" cellpadding="0" class="table table-hover">
		<thead>
			<tr>
				<th>NO</th>
				<th>심판명</th>
				<th>생년월일</th>
				<th>등급(마장,장애물)</th>
				<th>스튜어드</th>
				<th>선택</th>
			</tr>
		</thead>

		<tbody id="jglist">

	<%
	If IsArray(arr) Then
		For ar = LBound(arr, 2) To UBound(arr, 2)
			pidx = arr(0, ar)
			nowyear = arr(1, ar)
			username = arr(3,ar)
			userphone = arr(4,ar)
			birthday = arr(5,ar)
			kno = arr(7,ar)
			kef1 = arr(8,ar)
			kef2 = arr(9, ar)
			kef3 = arr(10,ar)
	%>
				<tr>
					<td><%=pidx%></td>
					<td><%=username %></td>
					<td><%=birthday%></td>
					<td><%=kef1%>,<%=kef2%></td>
					<td><%=kef3%></td>
					<td><button type="button" class="btn btn-primary" onmousedown="mx.choicePlayer('<%=anm%>','<%=typeno%>','<%=tidx%>',<%=ridx%>,<%=pidx%>,'<%=username%>')">선택</button></td>
				</tr>





		<!-- <div class="form-inline" style="margin-top:10px;">
			<div class="form-group" style="width:78%">
				이름:<%=username %> 체육인번호:<%=kno%> 생일 : <%=birthday%>
			</div>
			<div class="form-group"  style="width:20%">
				<button type="button" class="btn btn-primary" onmousedown="mx.changePlayer(<%=midx%>,<%=pidx%>)">변경</button>
			</div>
		</div> -->

	<%
		Next
	End if%>

			</tbody>
		</table>		
