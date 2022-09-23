<%
'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.tidx
	End if	
	If hasown(oJSONoutput, "TEAM") = "ok" then
		team = oJSONoutput.TEAM
	End If

	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = oJSONoutput.SEQ '임시 테이블 인덱스
	End If

	If hasown(oJSONoutput, "CDBNM") = "ok" then
		cdbnm = oJSONoutput.CDBNM
	End If
	If hasown(oJSONoutput, "SEX") = "ok" then
		sex = oJSONoutput.SEX
		If sex = "1" Then
			sexstr = "남자"
		Else
			sexstr = "여자"
		End if
	End If


	'종목번호 1,2,3 으로 받자
	kindno = isNulldefault(oJSONoutput.get("KNO"),"")
	If kindno = "" Then
		kindno = "1"
	End if


	userclass = isNulldefault(oJSONoutput.Get("UC"), 0)
'request  


'U	남자초등부
'W	여자초등부
'Y	초등부
'S	남자유년부
'T	여자유년부
	

'※ 초등부
'1~4학년 : 유년부 / 5~6학년 : 초등부
'예) 유재석 선수가 초등학교 2학년일 경우, 초등부에 해당되
'는 종목에 참가할 수 없음


	Function getBooName(sexstr,rstr, userclass)
		If InStr(rstr, "유년") > 0 Then
			getBooName = "'"&sexstr & "유년부'" 

		ElseIf InStr(rstr, "초등") > 0 Then
			
			'getBooName = "'"&sexstr & "초등부','" & sexstr & "유년부'" '기획서에 초등학교팀 로그인시만 두개노출이라고 되어있음
			If CDbl(userclass) < 5 Then
			getBooName = "'"&sexstr & "유년부'"
			Else
			getBooName = "'"&sexstr & "초등부'"
			End if



		ElseIf InStr(rstr, "중학") > 0 Then
			getBooName = "'"&sexstr & "중학부'"
		ElseIf InStr(rstr, "고등") > 0 Then
			getBooName = "'"&sexstr & "고등부'"
		ElseIf InStr(rstr, "대학") > 0 Then
			getBooName = "'"&sexstr & "대학부'"
		ElseIf InStr(rstr, "일반") > 0 Then
			getBooName = "'"&sexstr & "일반부'"
		ElseIf InStr(rstr, "대학일반") > 0 Then
			getBooName = "'"&sexstr & "대학일반'부"
		End If
		
	End Function

	boonm = getBooName(sexstr,cdbnm, userclass)



	Set db = new clsDBHelper
	


'	fld = "a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass,a.playeridx,b.playeridx "
'	SQL = "Select "&fld&" from tblPlayer as a left join (select playeridx from tblGameRequest_imsi where team = '"&team&"' and tidx = '"&tidx&"' group by tidx,playeridx) as b "
'	SQL = SQL & " on a.PlayerIDX = b.playeridx where a.Team = '"&team&"' and a.delyn = 'N' " ' and a.nowyear = '"&year(now)&"' "



	'********************************
	'제한 종목당 한팀에서 2명이상 출전하지 못함 체크
	'한선수가 참가가능한 종목수
	'********************************	
'	SQL = "select teamlimit, attgamecnt from sd_gameTitle where gametitleidx = " & tidx
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	If Not rs.eof then
'		teamlimit = rs(0)
'		attgamecnt = rs(1)
'	End if
	'추가할때 체크


	
	SQL = "Select username,leaderidx From tblGameRequest_imsi Where seq = " & seq
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	username = rs(0)
	leaderidx = rs(1)
	

	'참여종목하고 메칭
	'체크되지 않아야할것들 경영에 수구와 아티스틱 코드를 가져오자.
	' D2	31	플렛포옴다이빙
	'		32	스프링보오드1m
	'		33	스프링보오드3m
	'		34	싱크로다이빙3m
	'		35	싱크로다이빙10m
	'		41	싱크로나이즈드스위밍(솔로)
	'		42	싱크로나이즈드스위밍(듀엣)


	fld = "a.cda,a.cdanm,a.cdb,a.cdbnm,a.cdc,a.cdcnm,a.itgubun,a.levelno,a.gbidx,a.Rgamelevelidx,b.idx ,b.capno  ,a.sexno "
	SQL = "select "&fld&" from tblRGameLevel as a "

	
	'kindno 
	'1 경영 D2
	'2 다이빙 E2
	'3 수구 E2 31
	'4 아티스틱 F2
	Select Case kindno

	Case "1" '경영
		SQL = SQL &  " inner join tblTeamGbInfo as i on a.cda = i.PTeamGb and a.cdc = i.teamgb and i.cd_type=1 "
		SQL = SQL &  " left join tblGameRequest_imsi_r as b on a.Rgamelevelidx = b.Rgamelevelidx and  b.seq = '"&seq&"' and b.delyn='N' "

		'남자와 여자 구분해서 보여주어야한다. BC
		If sex = "1" then
		SQL = SQL &  " where a.gametitleidx = '"&tidx&"' and    (a.cdbnm in ("&boonm&")  or a.cdb = 'B' ) and a.delyn='N'   and a.cda= 'D2' and   a.cdc not in ('31','32','33','34','35','41','42')         order by i.orderby asc "
		Else
		SQL = SQL &  " where a.gametitleidx = '"&tidx&"' and    (a.cdbnm in ("&boonm&")  or a.cdb = 'C' ) and a.delyn='N' and a.cda= 'D2' and   a.cdc not in ('31','32','33','34','35','41','42')         order by i.orderby asc "
		End if

	Case "2" '다이빙 (단체, 팀(혼성인경우)) 2명
		SQL = SQL & " inner join tblTeamGbInfo as i on a.cda = i.PTeamGb and a.cdc = i.teamgb and i.cd_type=1 "
		SQL = SQL & " left join tblGameRequest_imsi_r as b on a.Rgamelevelidx = b.Rgamelevelidx and  b.seq = '"&seq&"' and b.delyn='N' "
		
		SQL = SQL & " where a.gametitleidx = '"&tidx&"' "
		
		SQL = SQL & " and  (   (a.sexno in (1,2)  and  (a.cdbnm in ("&boonm&") or a.cdb in ('B','C'))    )  or (a.sexno in (3)  and  a.cdbnm in ("& Replace(Replace(boonm,"남자",""),"여자","")     &") ) ) "

		SQL = SQL & " and a.delyn='N'     and   ( ( a.cda= 'E2' and a.cdc <> '31')  or  (a.cda = 'D2' and  a.cdc in ('31','32','33','34','35','41','42') )  )       order by i.orderby asc "

	Case "3"
		'수구이고 대학 일반 중하나라면 대학일반부가 있어야한다.
		If InStr(boonm, "대학") > 0 Or  InStr(boonm, "일반") > 0 Then
			SQL = SQL &  " inner join tblTeamGbInfo as i on a.cda = i.PTeamGb and a.cdc = i.teamgb and i.cd_type=1 "
			SQL = SQL &  " left join tblGameRequest_imsi_r as b on a.Rgamelevelidx = b.Rgamelevelidx and  b.seq = '"&seq&"' and b.delyn='N' "
			SQL = SQL &  " where a.gametitleidx = '"&tidx&"' and     (  a.cdbnm in ("&boonm&" ,'"&sexstr&"대학일반부')  or a.cdb in ('B','C')   )     and a.delyn='N'     and   ( a.cda= 'E2' and a.cdc = '31')        order by i.orderby asc "
		Else
			SQL = SQL &  " inner join tblTeamGbInfo as i on a.cda = i.PTeamGb and a.cdc = i.teamgb and i.cd_type=1 "
			SQL = SQL &  " left join tblGameRequest_imsi_r as b on a.Rgamelevelidx = b.Rgamelevelidx and  b.seq = '"&seq&"' and b.delyn='N' "
			SQL = SQL &  " where a.gametitleidx = '"&tidx&"' and a.cdbnm in ("&boonm&") and a.delyn='N'     and   ( a.cda= 'E2' and a.cdc = '31')        order by i.orderby asc "
		End if

	Case "4" '아티스틱 듀엣 (2명) 단체에 팀(4~8명)
		SQL = SQL &  " inner join tblTeamGbInfo as i on a.cda = i.PTeamGb and a.cdc = i.teamgb and i.cd_type=1 "
		SQL = SQL &  " left join tblGameRequest_imsi_r as b on a.Rgamelevelidx = b.Rgamelevelidx and  b.seq = '"&seq&"' and b.delyn='N' "
		SQL = SQL &  " where a.gametitleidx = '"&tidx&"' and        ( a.cdbnm in ("&boonm&")  or a.cdb in ('B','C') )                  and a.delyn='N'     and   ( a.cda= 'F2' )         order by i.orderby asc "
	End Select
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.eof Then
		arrB = rs.GetRows()
		booname = arrB(3,0)
		'Call getrowsdrow(arrb)
	End if


	if Cstr(kindno)	="2" Then '다이빙 (단체 인경우 선택된 항목들, 체크항목으로 사용하기 위해 (2명 남여구분해서 카운드 용으로 )
		SQL = "Select sex,cdc from tblgamerequest_imsi as a inner join tblGameRequest_imsi_r as b on a.seq = b.seq and cda= 'E2' and tidx = "&tidx&" and itgubun = 'T' and a.delyn='N'  where b.delyn = 'N' and a.team = '"&team&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
		If Not rs.eof Then
			arrR = rs.GetRows()
		End If
	End if

	if Cstr(kindno)	="4" Then '아티스틱 (단체 인경우 선택된 항목들, 체크항목으로 사용하기 위해 (2명 남여구분해서 카운드 용으로 )
		SQL = "Select sex,cdc from tblgamerequest_imsi as a inner join tblGameRequest_imsi_r as b on a.seq = b.seq and cda= 'F2' and tidx = "&tidx&" and itgubun = 'T' and a.delyn='N'  where b.delyn = 'N' and a.team = '"&team&"'  "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
Call oJSONoutput.Set("sql", sql) '디버깅용

		If Not rs.eof Then
			arrR = rs.GetRows()
		End If
	End if


	'명수체크해준다.########################### 
	Function chkDisabled(sexno, cdc, mysex,  ByRef arrR)
		Dim r_sex, r_cdc,ari,cnt,m,w
		cnt = 0
		m = 0
		w = 0

		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)

				r_sex = arrR(0, ari) 
				r_cdc = arrR(1, ari) 

				If CStr(sexno) = "3" Then '혼성(팀경기) tblRGameLevel.sexno

					If CStr(r_cdc) = CStr(cdc) Then

						If CStr(r_sex) = "1" then
							m = 1
						Else '2
							w = 1
						End If
						
					End if
				Else
					'남여구분해서 각각 신청되도록
					
					If CStr(r_cdc) = CStr(cdc) Then
						
						If CStr(r_sex) = "1" And mysex = "1" then
							cnt = cnt + 1
							'm = 1
						ElseIf CStr(r_sex) = "2" And mysex = "2" Then '2
							cnt = cnt + 1
							'w = 1
						End If
						
					End If
					
				End If
				
			Next
			
			If sexno = "3" Then 
				cnt = m + w
			End if

		End if

'Call oJSONoutput.Set("CNT_"& b_cdc, b_cdc & "_" & cnt) '디버깅용

		If cnt = 2 Then
			chkDisabled = 	"disabled"
		Else
			If sexno = "3" Then
				If (CDbl(m) = 1 And CDbl(mysex) = 1) Or  (CDbl(w) = 1 And CDbl(mysex) = 2)   Then
					chkDisabled = 	"disabled"
				Else
					chkDisabled = ""
				End if
			else
				chkDisabled = ""
			End if
		End if
	End Function 
	'명수체크해준다.########################### 

	'팀 명수체크 4~8 ########################## 
	Function chkTeamCnt(sexno, cdc,  ByRef arrR)
		Dim r_sex, r_cdc,ari,cnt,m,w
		cnt = 0
		m = 0
		w = 0

		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)

				r_sex = arrR(0, ari) 
				r_cdc = arrR(1, ari) 

				If CStr(r_cdc) = CStr(cdc) Then
					cnt = cnt + 1
				End If
				
			Next

		End if

		If cnt >= 8 Then
			chkTeamCnt = "disabled"
		Else
			chkTeamCnt = ""
		End if
	End Function 
	'명수체크해준다.########################### 


	db.Dispose
	Set db = Nothing





%>



		<input type="hidden" id = "check_seq" value="<%=seq%>">
		  

		  <section class="m_modal-player-selc-type">
            <div class="m_modal-player-selc-type__header">
              <h1 class="m_modal-player-selc-type__header__h1"><span><%=username%>(<%=Left(sexstr,1)%>)</span> 참가 종목 선택</h1>

			  <div class="m_modal-player-selc-type__header__selc-box">
				<select class="m_modal-player-selc-type__header__selc-box__selc"  onchange="mx.setBooList(<%=seq%>,'<%=cdbnm%>',<%=sex%>,'<%=userclass%>',$(this).val())">
				  <option value="1" <%If kindno = "1" then%>selected<%End if%>>경영</option>
				  <option value="2" <%If kindno = "2" then%>selected<%End if%>>다이빙</option>
				  <option value="3" <%If kindno = "3" then%>selected<%End if%>>수구</option>
				  <option value="4" <%If kindno = "4" then%>selected<%End if%>>아티스틱 스위밍</option>
                </select>

              </div>
            </div>
            <div class="m_modal-player-selc-type__con">
              <table class="m_modal-player-selc-type__con__tbl">
                <caption>참가 종목 선택 표</caption>
                <thead class="m_modal-player-selc-type__con__tbl__thead">
                  <tr>
                    <th scope="col">
                      <input class="m_modal__chek" id="chekBoxModalPlayertype00" type="checkbox" onclick="px.checkAll($(this))">
                      <label for="chekBoxModalPlayertype00"></label>
                    </th>
                    <th scope="col">세부종목명</th>
                    <th scope="col"><%If kindno = "2" Or kindno = "4" then%><%else%>수모번호<%End if%></th>
                  </tr>
                </thead>
                <tbody class="m_modal-player-selc-type__con__tbl__tbody">
                  <tr>
                    <td></td>
                  </tr>
                  <!-- tr.s_showNum = 입력창 보이게 -->
                  <!-- tr.s_disabled = 입력창 비활성 -->
<%
		If IsArray(arrB) Then 
			For ari = LBound(arrB, 2) To UBound(arrB, 2)
				b_cda = arrB(0, ari) 
				b_cdanm = arrB(1, ari) 
				b_cdb = arrB(2, ari) 
				b_cdbnm = arrB(3, ari) 
				b_cdc = arrB(4, ari) 
				b_cdcnm = arrB(5, ari) 

				b_itgubun= arrB(6, ari) 
				b_levelno= arrB(7, ari) 
				b_gbidx= arrB(8, ari) 
				b_lidx = arrB(9,ari)

				b_idx  = isNulldefault(arrB(10,ari),"")
				b_capno = arrB(11,ari)
				b_sexno = arrB(12,ari) '성별 혼성 3 다이빙(단체 팀구분용)


				disabledteam = ""
				disabledinput = ""
				If b_itgubun = "T" Then 

					If (b_cda = "E2" And b_idx = "")  Then								'다이빙 단체 , 체크상태가아니라면  싱크로다이빙3M,싱크로다이빙10M
						disabledinput = chkDisabled(b_sexno, b_cdc, sex ,arrR)	'참가명수 체크 (tblRGameLevel.sexno)
					End If


					'솔로(Solo), 듀엣(Duet), 팀(Team) / 테크니컬 솔로, 테크니컬 듀엣, 테크니컬 팀 / 프리 솔로, 플리 듀엣, 프리 팀
					If (b_cda = "F2" And (b_cdc = "02" or b_cdc = "06"  or b_cdc = "07" )  And b_idx = "")  Then '아티스틱 단체듀스 , 체크상태가아니라면
						disabledinput = chkDisabled(b_sexno, b_cdc, sex ,arrR)	'참가명수 체크 (tblRGameLevel.sexno)
						'Call oJSONoutput.Set("d_"& ari, b_cdc) '디버깅용
					End If

					
					If (b_cda = "F2" And  (b_cdc = "03" or b_cdc = "12"  or b_cdc = "11" )   And b_idx = "")  Then '아티스틱 단체팀 , 체크상태가아니라면
						disabledteam = chkTeamCnt(b_sexno, b_cdc, arrR) '4~8명
					End if



					If CDbl(b_sexno) = 3 then	'다이빙 혼성 
 					gbnstr = "[팀경기]"
					Else
					gbnstr = "[단체]"
					End if
				Else
					gbnstr = ""
				End if				
				
				%>
				  <tr <%If b_cdcnm = "수구" then%>class="s_showNum"<%End if%>>
					
					<td>
					  <input type="hidden" id="itgubun_<%=CDbl(ari)+1%>" value="<%=b_itgubun%>">
					  <input class="m_modal__chek" id="chekBoxModalPlayertype_<%=ari%>" type="checkbox" <%'=disabledinput%> <%'=disabledteam%>  value="<%=b_lidx%>" <%If b_idx <> "" then%>checked<%End if%>>
                      <label for="chekBoxModalPlayertype_<%=ari%>"></label>
                    </td>



                    
					
					<th scope="row"><%=gbnstr%> <%=b_cdbnm%>&nbsp;<%=b_cdcnm%> 
					<!--
					<%If kindno = "2" And disabledinput = "disabled" then%><span style="color:red">&nbsp;신청불가.(배정,또는 성별확인)</span><%End if%>
					<%If kindno = "4" And disabledinput = "disabled" then%><span style="color:red">&nbsp;신청불가(배정,또는 성별확인)</span><%End if%>
					<%If kindno = "4" And disabledteam = "disabled" then%><span style="color:red">&nbsp;신청불가(8명신청중)</span><%End if%>
					-->
					</th>
					

                    <td><input type="text" id= "cap_<%=ari%>" value="<%=b_capno%>" placeholder="수모번호입력"   onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.setCapno('cap_<%=ari%>', 'chekBoxModalPlayertype_<%=ari%>')" style="width:100%;" maxlength="3"></td>
                  </tr>				
				<%				
			Next
		End if
%>

                </tbody>
              </table>
            </div>
            <!-- span.s_show = 보이게 -->
            <span class="m_modal-player-selc-type__noti s_show">※ 수구에 참가하는 경우 선수의 <em>수모번호</em>를 <em>입력</em>해주세요</span>
            <div class="m_modal-player-list__btns clear">
              <button onclick="mx.setBoo(<%=kindno%>)" id="btnOkPlayerTypeModal" type="button" name="button">확인</button>
              <button onclick="closeModal()" id="btnCancelPlayerTypeModal" type="button" name="button">취소</button><%'=sql%>
            </div>
          </section>


<%
	'debug print
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson
%>