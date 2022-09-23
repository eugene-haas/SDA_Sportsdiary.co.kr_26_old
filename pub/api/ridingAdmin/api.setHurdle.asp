<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "RIDX") = "ok" then
		r_gbidx= oJSONoutput.RIDX
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "CHELP") = "ok" then
		chelp= oJSONoutput.CHELP
	End If

	If hasown(oJSONoutput, "ROUNDNO") = "ok" Then '라운드 번호
		roundno= oJSONoutput.ROUNDNO
	End If

	'이름 때문에 헛갈리지 말길...ㅡㅡ+ (체전 인경우 1라운드 2라운드로 찾아야할꺼같음)
	tidxgbidx = r_tidx & r_gbidx


'ridx 값을 기지는 것이 있는지 확인
'장매물 정보가 저장된 것이 있다면 불러오고 없다면 생성
'각각 편집시 자동저장
'확인 버튼을 누르면 실지 사용여부 결정값 업데이트


''장애물타입
''A
'CONST_TYPEA1 = "FEI 238.2.1"
'CONST_TYPEA2 = "FEI 238.2.2"
'
''A1
'CONST_TYPEA_1 = "최적시간"
''B
'CONST_TYPEB = "FEI 274-1.5.3"  > 2phase
''C
'CONST_TYPEC = "FEI 239"



'classhelp 값을 저장해두어야할까?

'마장마술만
Select Case chelp
Case CONST_TYPEA_1,CONST_TYPEA2,CONST_TYPEA1
chk1value = "Y"
chk2value = "N"
Case CONST_TYPEB
chk1value = "Y"
chk2value = "N"
Case CONST_TYPEC
chk1value = "N"
chk2value = "Y"
End select


field = " tidxgbidx,tidx,chk1,chk2,chk3,deduction1,deduction2,deduction3,deduction4,d4second,d5second,deduction5, hurdle1,hurdle2,hurdle3,hurdle4,hurdle5,hurdle6,hurdle7,hurdle8,hurdle9,hurdle10,hurdle11,hurdle12,hurdle13,hurdle14,hurdle15,hurdle16,hurdle17,hurdle18,hurdle19,hurdle20, hurdle2pahasegubun,totallength1,mspeed1,time1,limittime1,totallength2,mspeed2,time2,limittime2,installname,designname,useOK,roundno "

SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx & "' and roundno = " & roundno
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql

Dim hurdle(20)

poptitle = "장애물기준및 배치정보"	

If rs.EOF Then
	'insert
	SQL = "insert into tblHurdleInfo ( tidxgbidx, tidx,chk1,chk2,roundno	) values ('"&tidxgbidx&"',"&r_tidx&",'"&chk1value&"','"&chk2value&"', '"&roundno&"') "
	Call db.execSQLRs(SQL , null, ConStr)

	For i = 1 To 20
		hurdle(i) = ""
	next

	jm01 = chk1value
	jm02 = chk2value
	jm08 = "Y"

	jm03 = ""
	jm04 = ""
	jm05 = ""
	
	jm06 = ""
	jm07 = ""

	jm09 = ""
	jm010 = ""
	hurdle2pahasegubun = ""

	totallength1= ""
	mspeed1 = ""
	time1 = ""
	limittime1 = ""

	totallength2= ""
	mspeed2 = ""
	time2 = ""
	limittime2 = ""

	installname = ""
	designname = ""
	useOK = "N"  '실지 사용여부 설정 확인버튼 누를때 업데이트


Else
	For i = 1 To 20
		hurdle(i) = rs("hurdle" & i)
	next
	

	jm01 = rs("chk1")	
	jm02 = rs("chk2")	
	jm08 = rs("chk3")	

	jm03 = rs("deduction1")	
	jm04 = rs("deduction2")	
	jm05 = rs("deduction3")	
	
	jm06 = rs("deduction4")	
	jm07 = rs("d4second")	

	jm09 = rs("d5second")	
	jm10 = rs("deduction5")	
	hurdle2pahasegubun = rs("hurdle2pahasegubun")

	totallength1= rs("totallength1")
	mspeed1 = rs("mspeed1")
	time1 = rs("time1")
	limittime1 = rs("limittime1")

	totallength2= rs("totallength2")
	mspeed2 = rs("mspeed2")
	time2 = rs("time2")
	limittime2 = rs("limittime2")

	installname = rs("installname")
	designname = rs("designname")
	useOK = rs("useOK")  '실지 사용여부 설정 확인버튼 누를때 업데이트
End If




Dim hurdle_re(20)


'장애물 FEI 238.2.2 의 재경기 라면 (사용안하는걸로 )
'KGAME 라면 들어오지 않음...
'If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then
'		'생성이 안되어있다면 기본 정보를 1라운드 정보로 불러옴
'		SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx & "' and roundno = 1 "
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'		If Not rs.eof then
'		For i = 1 To 20
'			hurdle_re(i) = rs("hurdle" & i)
'		next
'		
'
'		jm01_re = rs("chk1")	
'		jm02_re = rs("chk2")	
'		jm08_re = rs("chk3")	
'
'		jm03_re = rs("deduction1")	
'		jm04_re = rs("deduction2")	
'		jm05_re = rs("deduction3")	
'		
'		jm06_re = rs("deduction4")	
'		jm07_re = rs("d4second")	
'
'		jm09_re = rs("d5second")	
'		jm10_re = rs("deduction5")	
'		hurdle2pahasegubun_re = rs("hurdle2pahasegubun")
'
'		totallength1_re= rs("totallength1")
'		mspeed1_re = rs("mspeed1")
'		time1_re = rs("time1")
'		limittime1_re = rs("limittime1")
'
'		totallength2_re= rs("totallength2")
'		mspeed2_re = rs("mspeed2")
'		time2_re = rs("time2")
'		limittime2_re = rs("limittime2")
'
'		installname_re = rs("installname")
'		designname_re = rs("designname")
'		useOK_re = rs("useOK")  '실지 사용여부 설정 확인버튼 누를때 업데이트
'		End if
'
'End if











rs.close
 db.Dispose
 Set db = Nothing


%>

<div class="modal-content">

<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	<h4><%=poptitle%> <%=chelp%> :R<%=roundno%></h4>
</div>

			<div class="modal-body obstacles">
				<div class="form-group">
					<input type="checkbox" class="form-control" id='jm01' <%If jm01 ="Y" then%>checked<%End if%>  onchange="mx.inputJRC(1, this.value, '<%=tidxgbidx%>',<%=roundno%>)" value="Y"/><label class="control-label lb_txt">소정시간 사용</label>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%If jm01_re ="Y" then%>checked<%End if%><%End if%>
				</div>
				<div class="form-group">
					<input type="checkbox" id='jm02' class="form-control" <%If jm02 ="Y" then%>checked<%End if%> onchange="mx.inputJRC(2, this.value, '<%=tidxgbidx%>',<%=roundno%>)"/><label class="control-label lb_txt">소요시간 고려(순위결정시)</label>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%If jm02_re ="Y" then%>checked<%End if%><%End if%>
				</div>

				<div class="form-group">
					<label class="control-label">장애물 낙하시</label><input type="text" class="form-control ip_txt" id='jm03' value="<%=jm03%>" onkeyup="this.value=mx.inputJRC(3,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5" /> <%If chelp = CONST_TYPEC then%>벌초<%else%>점 감점<%End if%>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm03_re%><%End if%>
				</div>
				<div class="form-group">
					<label class="control-label">1회 거부시</label><input type="text" class="form-control ip_txt" id='jm04' value="<%=jm04%>" onkeyup="this.value=mx.inputJRC(4,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> 
					<%If chelp = CONST_TYPEC then%>벌초<%else%>점 감점<%End if%>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm04_re%><%End if%>
				</div>
				<div class="form-group">
					<label class="control-label">2회 거부시</label><input type="text" class="form-control ip_txt" id='jm05' value="<%=jm05%>" onkeyup="this.value=mx.inputJRC(5,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> 
					<%If chelp = CONST_TYPEC then%>벌초<%else%>점 감점<%End if%>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm05_re%><%End if%>
				</div>
				<div class="form-group">
					<label class="control-label">1회 거부/장애물전도</label><input type="text" class="form-control ip_txt" id='jm06' value="<%=jm06%>" onkeyup="this.value=mx.inputJRC(6,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm06_re%><%End if%>
					<%If chelp = CONST_TYPEC then%>벌초<%else%>점 감점 / 벌초 <input type="text" class="form-control ip_txt" id='jm07'  value="<%=jm07%>"  onkeyup="this.value=mx.inputJRC(7,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> 초<%End if%>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm07_re%><%End if%>
				</div>

				<div class="form-group">
					<input type="checkbox" class="form-control" id='jm08' <%If jm08 ="Y" then%>checked<%End if%> onchange="mx.inputJRC(8, this.value, '<%=tidxgbidx%>',<%=roundno%>)"/><label class="control-label lb_txt">제한시간초과 실권</label>
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm08_re%><%End if%>
				</div>
				<div class="form-group">
					<label class="control-label">소정시간초과 </label>
					<input type="text" class="form-control ip_txt" id='jm09'  value="<%=jm09%>"  onkeyup="this.value=mx.inputJRC(9,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> 
					
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm09_re%><%End if%>					

					초에 감점<input type="text" class="form-control ip_txt" id='jm10' onkeyup="this.value=mx.inputJRC(10,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"  value="<%=jm10%>" /> 점
					&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=jm10_re%><%End if%>
				</div>

				<hr/>

				<div class="form-group">
					<h2 class="cont_tit">장애물 배치정보</h2>
					<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
						<thead>
							<tr>
								<%For i = 1 To 20%>
								<th 
								<%If chelp = CONST_TYPEB then%>
								style="cursor:pointer;<%If CStr(hurdle2pahasegubun) = CStr(i) then%>background:orange;<%End if%>" id="hurdle2p<%=100+i%>" onclick="mx.inputJRC(<%=100+i%> , <%=i%>, '<%=tidxgbidx%>',<%=roundno%>)"
								<%End if%>								
								><%=i%></th>
								<%next%>
							</tr>
						</thead>
						<tbody>
							<tr>
								<%For i = 11 To 30%>
								<td><input type="text" class="form-control"  id='jm<%=i%>'  value= "<%=hurdle(i-10)%>" onkeyup="this.value=mx.inputJRC(<%=i%>,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/></td>
								<%next%>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="form-group">
					<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
					<tr>
					<td>
						<div class="form-group">
							<label class="control-label">전장</label><input type="text" class="form-control ip_txt" id='jm31' value="<%=totallength1%>"  onkeyup="this.value=mx.inputJRC(31,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> (M)
							&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=totallength1_re%><%End if%>
						</div>
						<div class="form-group">
							<label class="control-label">분속</label><input type="text" class="form-control ip_txt" id='jm32' value="<%=mspeed1%>" onkeyup="this.value=mx.inputJRC(32,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> (M/MIN)
							&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=mspeed1_re%><%End if%>
						</div>
						<div class="form-group">
							<label class="control-label">소정시간</label><input type="text" class="form-control ip_txt" id='jm33' value="<%=time1%>" readonly/> (SEC)
							&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=time1_re%><%End if%>
						</div>
						<div class="form-group">
							<label class="control-label">제한시간</label><input type="text" class="form-control ip_txt" id='jm34' value="<%=limittime1%>" readonly/> (SEC)
							&nbsp;&nbsp;<%If chelp = CONST_TYPEA2 And Cdbl(roundno) > 1  Then%><%=limittime1_re%><%End if%>
						</div>
					</td>
					<%If chelp = CONST_TYPEB then%>
					<td>
						<div class="form-group">
							<label class="control-label">전장</label><input type="text" class="form-control ip_txt" id='jm37' value="<%=totallength2%>"  onkeyup="this.value=mx.inputJRC(37,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> (M)
						</div>
						<div class="form-group">
							<label class="control-label">분속</label><input type="text" class="form-control ip_txt" id='jm38' value="<%=mspeed2%>" onkeyup="this.value=mx.inputJRC(38,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/> (M/MIN)
						</div>
						<div class="form-group">
							<label class="control-label">소정시간</label><input type="text" class="form-control ip_txt" id='jm39' value="<%=time2%>" readonly/> (SEC)
						</div>
						<div class="form-group">
							<label class="control-label">제한시간</label><input type="text" class="form-control ip_txt" id='jm40' value="<%=limittime2%>" readonly/> (SEC)
						</div>
					</td>
					<%End if%>
					</tr>
					</table>



				<div class="form-group">
					<div class="row">
						<div class="col-sm-3">
							<label class="control-label">경로설치자</label><input type="text" class="form-control ip_txt" id='jm35' value="<%=installname%>" onkeyup="this.value=mx.inputJRC(35,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"/><!-- 설계자 플레이어로 등록 -->
						</div>
						<div class="col-sm-3">
							<label class="control-label">경로설계자</label><input type="text" class="form-control ip_txt" id='jm36' value="<%=designname%>" onkeyup="this.value=mx.inputJRC(36,this.value, '<%=tidxgbidx%>',<%=roundno%>)" maxlength="5"  onblur="this.value=mx.inputJRC(99,this.value, '<%=tidxgbidx%>',<%=roundno%>)"/>
						</div>
					</div>
				</div>


			<div class="modal-footer">
				<button type="button" class="btn btn-primary" onclick="mx.inputJRC(42,'Y', '<%=tidxgbidx%>',<%=roundno%>)">적용</button>
			</div>

		</div>


</div>
