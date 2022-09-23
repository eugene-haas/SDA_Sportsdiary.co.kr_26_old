<%
	If hasown(oJSONoutput, "TN") = "ok" Then  '테이블 명
		TN = chkStrRpl(oJSONoutput.TN,"")
	End If

	If hasown(oJSONoutput, "IDXFIELDNM") = "ok" Then  '테이블 명
		IDXFIELDNM = chkStrRpl(oJSONoutput.IDXFIELDNM,"")
	End If

	If hasown(oJSONoutput, "PN") = "ok" Then
		PN = chkStrRpl(oJSONoutput.PN,"")
	Else
		PN = 1
	End If


	If hasown(oJSONoutput, "F1") = "ok" Then  '검색필드
		F1 = chkStrRpl(oJSONoutput.F1,"")
	End If
	If hasown(oJSONoutput, "F2") = "ok" Then  '필드데이터
		F2 = chkStrRpl(oJSONoutput.F2,"")
	End If

	If hasown(oJSONoutput, "PS") = "ok" Then  '패이지 줄수
		PS = chkStrRpl(oJSONoutput.PS,"")
		intPageSize = PS
	Else
		intPageSize = 10
	End If



	Set db = new clsDBHelper

	SQL = "SELECT DB_NAME()"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		dbname = rs(0)
	End if	

	'필드명들
	SQL = "Select   c.name, c.xusertype, o.xtype  from sysobjects as o INNER JOIN syscolumns as c ON o.id = c.id Where o.xtype = 'u' and o.name = '"&TN&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arr = rs.GetRows()
	End if




	intPageNum = PN
	strTableName = TN
	strFieldName = " * "

	strSort = "  order by " & IDXFIELDNM & " desc"
	strSortR = "  order by " & IDXFIELDNM

	If F1 <> "" And F2 <> "" Then
		strWhere =  " " & F1 & " like '" & F2 & "%' and " &  IDXFIELDNM & "  > 0 "
	else
		strWhere = IDXFIELDNM & "  > 0 "
	End if



	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10

%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">(<%=TN%>) 내용 </button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">

      	<div class="table-box basic-table-box">
        <%


	Sub rsDrow(ByVal rs)
	Dim i 
		For i = 0 To Rs.Fields.Count - 1
			'response.write  Rs.Fields(i).name &","
		Next

		response.write "<table class='table' id=""tblrsdrow"">"
		Response.write "<thead id=""headtest"">"
		For i = 0 To Rs.Fields.Count - 1
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		Next
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>
				<tr class="gametitle">
					<%
						For i = 0 To Rs.Fields.Count - 1
							If Rs.Fields(i).name = "PassEnc"  Then
								Response.write "<td>***</td>"

							elseIf Rs.Fields(i).name = "취소계좌"  And  rsdata(i) <> ""  Then 
								Response.write "<td>" & f_dec(rsdata(i))   & "</td>"

							else
								Response.write "<td>" & rsdata(i)   & "</td>"
							End if
						Next
					%>
				</tr>
			<%
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
	End Sub





        	Call rsDrow(rs)
        

		%>
      	</div>

      </div>

      <!-- s: 정보 검색 -->
    	<!-- <div class="modal-footer"> -->
    	<!-- <div class="info_serch box-shadow"> -->


			<div id="ul_s" class="search-box form-inline container-fluid text-right">
				<div class="form-group">

  				<select id="cnmfind1" class="form-control">
  				<%
  				  if(IsArray(arr)) Then
  					For ar = LBound(arr, 2) To UBound(arr, 2)
  					  If F1 = "" Or  F2 = "" then
  						  Select Case arr(0,ar)
  						  Case "ONLINE_CD"
  							  onlinecdv = GLOBAL_VAR_ONLINECD
  							  Response.Write "<option value=" & arr(0,ar) & " selected>" & arr(0,ar) & "</option>"
  						  Case "WORK_NM"
  							  onlinecdv = GLOBAL_VAR_PENM
  							  Response.Write "<option value=" & arr(0,ar) & " selected>" & arr(0,ar) & "</option>"
  						  Case Else
  							  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & "</option>"
  						  End select
  						Else
  						  If arr(0,ar) = F1 Then
  							  onlinecdv = F2
  							  Response.Write "<option value=" & F1 & " selected>" & F1 & "</option>"
  						  Else
  							  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & "</option>"
  						  End If
  						End if
  					NEXT
  				  End IF
  				%>
  				</select>

  				<%
  				jsonstr = JSON.stringify(oJSONoutput)
  				%>

          <div class="input-group">
            <input type="text" id="cnmfind2" class="form-control" value="<%=onlinecdv%>" onkeydown='if(event.keyCode == 13){mx.goPageSearch(<%=jsonstr%>,1,$("#cnmfind1").val(), $("#cnmfind2").val())}'>
            <div class="input-group-btn">
              <a class="blue-btn btn btn-primary" href='javascript:mx.goPageSearch(<%=jsonstr%>,1,$("#cnmfind1").val(), $("#cnmfind2").val())'>검색</a>
            </div>
          </div>

				</div>

				<div class="form-group">
					<label for="linecount" class="control-label">라인수</label>
					<select id="linecount" class="form-control" onchange='mx.goPageLnCnt(<%=jsonstr%>,1,$("#linecount").val())'>
						<%For i = 0 To 10000 Step 1000%>
						<%If i = 0 Then
						x = 10
						Else
						x = i
						End if
						%>
						<option value="<%=x%>" <%If CDbl(intPageSize) = CDbl(x) then%>selected<%End if%>><%=x%></option>
						<%next%>
					</select>
				</div>
			</div>
      <!-- e: 정보 검색 -->

    	<!-- s: 페이징 버튼 -->
  		<%
  			jsonstr = JSON.stringify(oJSONoutput)
  			Call userPagingT2(intTotalPage, 10, PN, "mx.goPage", jsonstr )
  		%>
    	<!-- e: 페이징 버튼 -->

    </div>

  	<div class="modal-footer">

		<a href="javascript:mx.exportExcel('<%=dbname%>','<%=TN& "_page "& PN %>','tblrsdrow')" class="btn btn-primary" >엑셀출력</a>

		<a href="javascript:$('#myModal').modal('hide');mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'<%=TN%>','DN':'<%=DN%>' })" class="btn btn-primary">컬럼 주석</a>		
		
		<a href="#" class="btn btn-default" data-dismiss="modal">닫기</a>
    </div>


  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
