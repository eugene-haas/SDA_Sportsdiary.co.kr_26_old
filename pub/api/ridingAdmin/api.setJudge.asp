<%
'#############################################
'심판, 스크라이버, 스튜어드 , sit-in, shadow 등록
'#############################################
	Set db = new clsDBHelper

	'request
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



	strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfield = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp "
	strWhere2 = " a.RGameLevelidx = "&ridx&" and a.DelYN = 'N' and b.DelYN = 'N' "



	'Bpidx,Epidx,Mpidx,Cpidx,Hpidx,'Bname,Ename,Mname,Cname,Hname
	'Bpidx_s,Epidx_s,Mpidx_s,Cpidx_s,Hpidx_s,Bname_s,Ename_s,Mname_s,Cname_s,Hname_s,
	'etcAidx,etcBidx,etcCidx,etcAname,etcBname,etcCname


	Select Case anm
	Case "B","E","M","C","H"
		Select Case  typeno
		Case "1" '심판
			selectnm = "심판"
			jfield =  ","&anm&"pidx, "&anm&"name "
		Case "2" '스크라이버
			selectnm = "스크라이버"
			jfield =  ","&anm&"pidx_s, "&anm&"name_s "
		End Select 
		

	Case "A"
		Select Case  typeno
		Case "1" '스튜어드
			selectnm = "스튜어드"
			jfield =  ",etcAidx, etcAname "
		Case "2" 'Sit-in
			selectnm = "Sit-in"
			jfield =  ",etcBidx, etcBname "
		Case "3" 'shadow
			selectnm = "shadow"
			jfield =  ",etcCidx, etcCname "
		End Select 

	End Select 

	SQL = "Select top 1  "&strfield& jfield &" from "&strTableName2&" where " & strWhere2 
'Response.write sql
'Response.end
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	title = rs(0)
	pidxs = rs(1)
	nms = rs(2)



  db.Dispose
  Set db = Nothing

%>
 
			
			<div class="modal-dialog modal-md">
				<div class="modal-contents">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<%=title%> 
					</div>
					<div class="modal-body">


						<h4 class="control-label"><%=selectnm%></h4>
						<div class="">
							<div class="form-group">
						    <input class="form-control autocomplete" id="pfff" placeholder="이름을 입력해주세요"  oninput="mx.searchJudge('<%=anm%>','<%=typeno%>','<%=tidx%>',<%=ridx%>, this.value)"/>
						  </div>
						</div>


						<div class="form-inline" id="choiceplayers">
						<%If pidxs <> "" And isnull(pidxs) = False then%>
						<input type="hidden" id="pidxs" value="<%=pidxs%>">
						<input type="hidden" id="nms" value="<%=nms%>">
						<%
						pidxsarr = Split(pidxs,",")
						nmsarr = Split(nms, ",")
						For i = 0 To ubound(pidxsarr)
						%>
					
						<div class="form-inline" style="margin-top:10px;"> 
						<div class="form-group" style="width:78%"> 
							<%=nmsarr(i)%>
						</div> 
						<div class="form-group"  style="width:20%"> 
							<button type="button" class="btn btn-primary" onmousedown="mx.delarr(<%=pidxsarr(i)%>);mx.delarr('<%=nmsarr(i)%>');$(this).parent().parent().remove()">취소</button> 
						</div> 
						</div>


						<%
						next
						%>
						<%End if%>
							<!-- 선택한 심판 보일곳 -->
						</div>

						<div class="form-inline" id="searchplayers">

								<!-- 검색내용 불러올곳... -->
						</div>



					</div>
					<div class="modal-footer">
						<button type="button" data-dismiss="modal" aria-hidden="true" class="btn btn-default">닫기</button>
						<button type="button" class="btn btn-primary" onmousedown="mx.saveJudge('<%=anm%>','<%=typeno%>','<%=tidx%>',<%=ridx%>)">등록</button>
					</div>
				</div>
			</div>


		