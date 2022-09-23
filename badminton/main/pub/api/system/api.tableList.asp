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
	
	'필드명들
	SQL = "Select   c.name, c.xusertype, o.xtype  from sysobjects as o INNER JOIN syscolumns as c ON o.id = c.id Where o.xtype = 'u' and o.name = '"&TN&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	
	
'Response.write sql
'Response.end
	
	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if






	intPageNum = PN
	strTableName = TN
	strFieldName = " * "

	strSort = "  order by " & IDXFIELDNM & " desc"
	strSortR = "  order by " & IDXFIELDNM

	If F1 <> "" And F2 <> "" Then
		strWhere =  " " & F1 & "= '" & F2 & "' and " &  IDXFIELDNM & "  > 0 "
	else
		strWhere = IDXFIELDNM & "  > 0 "
	End if



	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10
%>
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<h4 class="modal-title" id="myModalLabel">(<%=TN%>) 내용 </h4>
		  </div>
		  <div class="modal-body">
    				<div class="table-box basic-table-box" >
<%
						Call rsDrow(rs)
%>
    				</div>
		  </div>



			<!-- s: 정보 검색 -->
				<div class="info_serch box-shadow">

					<div class="search-box">
						<ul id="ul_s">
							<li>

							<select id="cnmfind1" style="width:auto;"> 
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
							<input type="text" id="cnmfind2" style="width:auto;" value="<%=onlinecdv%>" onkeydown='if(event.keyCode == 13){mx.goPageSearch(<%=jsonstr%>,1,$("#cnmfind1").val(), $("#cnmfind2").val())}'>
							<a class="blue-btn" href='javascript:mx.goPageSearch(<%=jsonstr%>,1,$("#cnmfind1").val(), $("#cnmfind2").val())' style="width:100px;">검색</a>

							</li>
							<li>
							&nbsp;&nbsp;&nbsp;&nbsp;라인수
							<select id="linecount" style="width:auto;" onchange='mx.goPageLnCnt(<%=jsonstr%>,1,$("#linecount").val())'> 
								<%For i = 0 To 1000 Step 100%>
								<%If i = 0 Then
								x = 10
								Else
								x = i
								End if
								%>
								<option value="<%=x%>" <%If CDbl(intPageSize) = CDbl(x) then%>selected<%End if%>><%=x%></option>
								<%next%>
							</select>
		
							
							
							</li>
						</ul>
					</div>

				</div>
			<!-- e: 정보 검색 -->



		<!-- s: 더보기 버튼 -->
		<div class="paging">
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPaginglinkBike2 (intTotalPage, 10, PN, "mx.goPage", jsonstr )
			%>
		</div>
		<!-- e: 더보기 버튼 -->		

		  <div class="modal-footer">
			<a href="#" class="white-btn" data-dismiss="modal">닫기</a>
		  </div>
		</div>
	  </div>
<%
	

	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>