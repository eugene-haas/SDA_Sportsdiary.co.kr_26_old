<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request
r_tidx = oJSONoutput.TIDX
title = oJSONoutput.TITLE

If hasown(oJSONoutput, "PTYPE") = "ok" Then '선수말, 1,2
	ptype = oJSONoutput.PTYPE
End If
If hasown(oJSONoutput, "GTYPE") = "ok" Then '개인 단체, 1,2
	gtype = oJSONoutput.GTYPE
End if

If hasown(oJSONoutput, "GBIDX") = "ok" Then '설정불러오기 위한 값
	gbidx = oJSONoutput.GBIDX
End if


Set db = new clsDBHelper

	SQL = "Select gameyear from sd_tennisTitle where gametitleidx = " & r_tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gameyear = rs(0)
'	plimitidxs = rs(1) '개별인경우 바꿔야한다 작업진행 중지
'	hlimitidxs = rs(2)



	strFieldName = " seq, gubun,chkyear,Teamgbnm,  chkHkind   ,chkClass,updown,zeropointcnt,chkandor,prizecnt,attokYN,limitTeamgbnm,limitchkClass,writedate "
	strSort = "  ORDER By seq Desc"
	strWhere = " DelYN = 'N' and gubun= '"&ptype&"' and chkyear = '"& gameyear &"' "

	SQL = "Select " & strFieldName & " from tblLimitAtt where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	if rs.eof Then
		arrList = ""
	Else
		Dim rsdic
		Set rsdic = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
		For i = 0 To Rs.Fields.Count - 1
			rsdic.Add LCase(Rs.Fields(i).name), i
		Next
		arrList = rs.getrows()
	end if
	set rs = Nothing


	'룰이 선수들 모아서 개인인지 단체인지 판단한다고 해서 이렇게 만든것 같다. 설명을 참 개떡같이 해주었구나..욕XXXXx

	'기승제한
	strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.gameno,a.GbIDX ,a.horselimit,a.playerlimit,a.horselimit2,a.playerlimit2 "
	strfieldB = " b.TeamGbNm,b.ridingclass,b.ridingclasshelp,b.levelnm "
	strFieldName = strfieldA &  "," & strfieldB
	strSort = "  ORDER BY a.gameno asc"
	If gtype = "1"  Then '개인
	strWhere = " a.GameTitleIDX = "&r_tidx&" and a.DelYN = 'N'  and b.pteamgb = '201' group by a.gameno,a.gbidx,b.TeamGbNm,b.ridingclass,b.ridingclasshelp,b.levelnm    ,a.horselimit,a.playerlimit,a.horselimit2,a.playerlimit2 "
	Else
	strWhere = " a.GameTitleIDX = "&r_tidx&" and a.DelYN = 'N' and  b.pteamgb = '202'  group by a.gameno,a.gbidx,b.TeamGbNm,b.ridingclass,b.ridingclasshelp,b.levelnm    ,a.horselimit,a.playerlimit,a.horselimit2,a.playerlimit2 "
	End if

	strWhere = " a.GameTitleIDX = "&r_tidx&" and a.DelYN = 'N'  group by a.gameno,a.gbidx,b.TeamGbNm,b.ridingclass,b.ridingclasshelp,b.levelnm    ,a.horselimit,a.playerlimit,a.horselimit2,a.playerlimit2 "

	SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	'Response.write  sql

	if rs.eof Then
		arrR = ""
	Else
		Set rdic = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
		For i = 0 To Rs.Fields.Count - 1
			rdic.Add LCase(Rs.Fields(i).name), i
		Next
		arrR = rs.getrows()
	end if
	set rs = Nothing


%>
<!-- 헤더 코트s -->

<div class="modal-dialog modal-xl">
  <div class="modal-content">


    <div class='modal-header'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 id='myModalLabel'>참가신청 제한 : <%=title%></h4>
    </div>
  <!-- 헤더 코트e -->

    <div class="modal-body">
      <div class="editor-box">



				1. 기승제한
				<div class="form-horizontal">
				<a href="javascript:mx.setLimit(<%=r_tidx%>,'<%=title%>',<%=ptype%>, 1)" class="btn btn-<%If gtype = "1" then%>primary<%else%>default<%End if%>" style="width:100px;" id="tab01">개인</a>
				<a href="javascript:mx.setLimit(<%=r_tidx%>,'<%=title%>',<%=ptype%>, 2)" class="btn btn-<%If gtype = "2" then%>primary<%else%>default<%End if%>" style="width:100px;" id="tab02">단체</a>
				</div>
				<div class="table-wrap" style="height:300px;">
				<table cellspacing="0" cellpadding="0" class="table"><!--table-hover scrolltbody short-->
					<thead>
						<tr>
								<th>경기번호</th>
								<th>종목</th>
								<th>마종</th>
								<th>Class</th>
								<th>Class안내</th>
								<th>인당 기승마</th>
								<th>기승마 인원</th>
						</tr>
					</thead>

					<tbody  class="gametitle" id="lvllist">
						<%
							If IsArray(arrR) Then
								For ar = LBound(arrR, 2) To UBound(arrR, 2)
										gameno= arrR(rdic.Item("gameno"), ar)
										gbidx= arrR(rdic.Item("gbidx"), ar)
										teamgbnm= arrR(rdic.Item("teamgbnm"), ar)
										ridingclass   = arrR(rdic.Item("ridingclass"), ar)
										ridingclasshelp= arrR(rdic.Item("ridingclasshelp"), ar)
										levelnm= arrR(rdic.Item("levelnm"), ar)

										horselimit= arrR(rdic.Item("horselimit"), ar) '인당 말
										playerlimit= arrR(rdic.Item("playerlimit"), ar) '말당 인
										horselimit2= arrR(rdic.Item("horselimit2"), ar) '단체 : 인당말
										playerlimit2= arrR(rdic.Item("playerlimit2"), ar) '단체 : 말당인
						%>
						<tr onclick="mx.input_setcheck(<%=r_tidx%>,<%=gbidx%>,<%=ptype%>,<%=gtype%>)" style="cursor:pointer;" id="lvllist_<%=r_tidx%>_<%=gbidx%>">
								<td><%=gameno%></td>
								<td><%=teamgbnm%></td>
								<td><%=levelnm%></td>
								<td> <%=ridingclass%></td>
								<td><%=ridingclasshelp%> : <%=horselimit%></td>
								<td>
									<div class="form-group">
										<label class="col-sm-2" style="padding:7px 0 0px;">1인</label>
										<div class="col-sm-10">
											<select id="phno_<%=gbidx%>" class="form-control" onchange="mx.setP_Hs(<%=r_tidx%>,<%=gbidx%>,<%=gtype%>)">
											<option value="">==선택==</option>
											<%For i = 1 To 3%>
												<%If gtype= "1" then%>
												<option value="<%=i%>" <%If CStr(horselimit) = CStr(i) then%>selected<%End if%>><%=i%>마</option>
												<%else%>
												<option value="<%=i%>" <%If CStr(horselimit2) = CStr(i) then%>selected<%End if%>><%=i%>마</option>
												<%End if%>
											<%Next%>
											</select>
										</div>
									</div>
								</td>
								<td>
									<label class="col-sm-2" style="padding:7px 0 0px;">1마</label>
										<div class="col-sm-10">
											<select id="hpno_<%=gbidx%>" class="form-control" onchange="mx.setH_Ps(<%=r_tidx%>,<%=gbidx%>,<%=gtype%>)">
											<option value="">==선택==</option>
											<%For i = 1 To 3%>
											<%If gtype= "1" then%>
											<option value="<%=i%>"  <%If CStr(playerlimit) = CStr(i) then%>selected<%End if%>><%=i%>인</option>
											<%else%>
											<option value="<%=i%>"  <%If CStr(playerlimit2) = CStr(i) then%>selected<%End if%>><%=i%>인</option>
											<%End if%>
											<%Next%>
											</select>
										</div>
									</div>
								</td>
						</tr>
						<%
								Next
							End If
						%>
					</tbody>
				</table>
				</div>









		   2참가자격제한 * 설정에서 등록된 참가자격제한 항목입니다.<br>
				<div class="form-horizontal">
				<a href="javascript:mx.setLimit(<%=r_tidx%>,'<%=title%>',1, <%=gtype%>)" class="btn btn-<%If ptype = "1" then%>primary<%else%>default<%End if%>" style="width:100px;" id="tab01">선수</a>
				<a href="javascript:mx.setLimit(<%=r_tidx%>,'<%=title%>',2, <%=gtype%>)" class="btn btn-<%If ptype = "2" then%>primary<%else%>default<%End if%>" style="width:100px;" id="tab02">말</a>
				</div>
				
				<div class="table-wrap" style="height:300px;">
				<table cellspacing="0" cellpadding="0" class="table" width="100%">
					<thead>
						<tr>
								<th colspan="9">조건</th>
								<th colspan="3">참가제한사항</th>
						</tr>
						<tr>
								<th>No</th>
								<th>등록년도</th>
								<th>종목</th>
								<th>마종</th>
								<th>class</th>
								<th>해당범위</th>
								<th>무감점 횟수</th>
								<th>조건</th>
								<th>입상실적(횟수)</th>
								<th>참가가능여부</th>
								<th>종목</th>
								<th>class</th>
						</tr>
					</thead>

					<tbody  class="gametitle" id="attchklist">
			<%
			If IsArray(arrList) Then
				For ar = LBound(arrList, 2) To UBound(arrList, 2)
					'dic 소문자로
					seq= arrList(rsdic.Item("seq"), ar)
					chkyear= arrList(rsdic.Item("chkyear"), ar)
					Teamgbnm= arrList(rsdic.Item("teamgbnm"), ar)
					chkHkind   = arrList(rsdic.Item("chkhkind"), ar)
					chkClass= arrList(rsdic.Item("chkclass"), ar)
					updown= arrList(rsdic.Item("updown"), ar)
					zeropointcnt= arrList(rsdic.Item("zeropointcnt"), ar)
					chkandor= arrList(rsdic.Item("chkandor"), ar)
					prizecnt= arrList(rsdic.Item("prizecnt"), ar)

					attokYN= arrList(rsdic.Item("attokyn"), ar)
					limitchkClass= arrList(rsdic.Item("limitchkclass"), ar)
					limitTeamgbnm= arrList(rsdic.Item("limitteamgbnm"), ar)
					writedate= arrList(rsdic.Item("writedate"), ar)

					If chkClass <> "" and chkClass <> "-1" Then
						chkClass = classarr(chkClass)
					End If
					If limitchkClass <> "" and limitchkClass <> "-1" then
						limitchkClass = classarr(limitchkClass)
					End if
				%>
							<tr onclick="mx.input_chk(<%=seq%>,<%=ptype%>,<%=gtype%>)" style="cursor:pointer;" id="chk_<%=seq%>">
								<td><%=seq%></td>
								<td><%=chkyear%></td>
								<td><%=Teamgbnm%></td>
								<td><%=chkHkind%></td>
								<td><%=chkClass%></td>
								<td><%=updown%></td>
								<td><%=zeropointcnt%></td>
								<td><%=chkandor%></td>
								<td><%=prizecnt%></td>

								<td><%=attokYN%></td>
								<td><%=limitTeamgbnm%></td>
								<td><%=limitchkClass%></td>
							</tr>
				<%
				Next
			End if
			%>
					</tbody>
				</table>
				</div>




	  </div>
    </div>





    <div id="rtbtnarea" class="modal-footer">
      <button type="button" data-dismiss='modal' aria-hidden='true' class="btn btn-default">닫기</button>
    </div>



  </div>
</div>






<%
db.Dispose
Set db = Nothing
%>
