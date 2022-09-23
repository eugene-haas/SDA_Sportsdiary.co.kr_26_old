<%
'#############################################
'선수변경창
'#############################################


	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "TYPENO") = "ok" Then 
		typeno = oJSONoutput.TYPENO
	End If
	If hasown(oJSONoutput, "REQIDX") = "ok" Then 
		reqidx = oJSONoutput.REQIDX
	End If
	
%>

<%If typeno = "1" then%>
			<div class="modal-dialog modal-md">
				<div class="modal-contents">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						선수명 추가 및 변경
					</div>
					<div class="modal-body">


						<h4 class="control-label">선수명 변경</h4>
						<div class="">
							<div class="form-group">
						    <input class="form-control autocomplete" id="pfff" placeholder="선수명을 입력해주세요"  oninput="mx.searchPlayer(<%=midx%>, this.value)"/>
						  </div>
						</div>


						<div class="form-inline" id="searchplayers">

						</div>



					</div>
					<div class="modal-footer">
						<button type="button" data-dismiss="modal" aria-hidden="true" class="btn btn-default">닫기</button>
						<button type="button" class="btn btn-primary">등록</button>
					</div>
				</div>
			</div>
<%elseIf typeno = "100" Then  
'팀원 교체 릴레이 코스트
	Set db = new clsDBHelper

	SQL = "select seq,kskey,playeridx,username,team,teamnm  from tblgamerequest_r where requestIDX  = " & reqidx & " and startMember = 'N' "


	'SQL = "select idx,gameMemberIDX,pidx,pnm,tidx,gbidx from sd_groupMember  where gameMemberidx = ( select top 1 gameMemberIDX from sd_groupMember where idx = " & midx & " )  order by orderno"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arr = rs.GetRows()
	End If
	rs.close
   db.Dispose
   Set db = Nothing
%>
			<div class="modal-dialog modal-md">
				<div class="modal-contents">
					<div class="modal-header">
						<button type="button" class="close" onclick="window.location.reload();">×</button>
						렐리이 선수 변경
					</div>
					<div class="modal-body">


						<h4 class="control-label">선수명 변경</h4>
						<!-- <div class="">
							<div class="form-group">
						    <input class="form-control autocomplete" id="pfff" placeholder="선수명을 입력해주세요"  oninput="mx.searchPlayerGroup(<%=midx%>, this.value)"/>
						  </div>
						</div> -->


						<div class="form-inline" id="searchplayers">

	<%
	If IsArray(arr) Then
		For ar = LBound(arr, 2) To UBound(arr, 2)
			t_seq = arr(0, ar)
			t_kskey = arr(1, ar)
			t_pidx = arr(2, ar)
			t_username = arr(3,ar)
	%>
		<div class="form-inline" style="margin-top:10px;">
			<div class="form-group" style="width:78%">
				이름:<%=t_username %> 체육인번호:<%=t_kskey%> <!-- 생일 : <%=birthday%>  -->
			</div>
			<div class="form-group"  style="width:20%">
				<button type="button" class="btn btn-primary" onmousedown="mx.changeGroupPlayer(<%=t_seq%>,<%=midx%>)">변경</button>
			</div>
		</div>
	<%
		Next
	End If
	%>

						</div>

					</div>
					<div class="modal-footer">
						<button type="button" onclick="window.location.reload();" class="btn btn-default">닫기</button>
					</div>
				</div>
			</div>


<%else%>
			<div class="modal-dialog modal-md">
				<div class="modal-contents">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						마명 추가 및 변경
					</div>
					<div class="modal-body">


						<h4 class="control-label">마명 변경</h4>
						<div class="">
							<div class="form-group">
						    <input class="form-control autocomplete" id="pfff" placeholder="마명을 입력해주세요"  oninput="mx.searchHorse(<%=midx%>, this.value)"/>
						  </div>
						</div>


						<div class="form-inline" id="searchplayers">

						</div>



					</div>
					<div class="modal-footer">
						<button type="button" data-dismiss="modal" aria-hidden="true" class="btn btn-default">닫기</button>
						<button type="button" class="btn btn-primary">등록</button>
					</div>
				</div>
			</div>
<%End if%>