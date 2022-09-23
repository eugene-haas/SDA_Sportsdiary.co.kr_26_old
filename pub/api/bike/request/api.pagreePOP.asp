<%
'request
	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "LVLIDX") = "ok" then
		levelIDX = oJSONoutput.LVLIDX
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	
	If hasown(oJSONoutput, "GN") = "ok" then
		gubun = oJSONoutput.GN
	End If	


	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If

	If hasown(oJSONoutput, "chkgame") = "ok" Then '신청정보   116,루키:117,CAT3:118,루키:  (부에 키값(levelno), 선수등급)
		chkgame = oJSONoutput.chkgame
	End If



	If hasown(oJSONoutput, "adult") = "ok" Then '성인미성인 Y N 부모 동의 문자 발송여부
		adult = oJSONoutput.adult
	End if	
	If hasown(oJSONoutput, "agree") = "ok" Then 
		agree = oJSONoutput.agree
	End if	

	If hasown(oJSONoutput, "p_nm") = "ok" Then 
		p_nm = oJSONoutput.p_nm
	End if	
	If hasown(oJSONoutput, "p_phone") = "ok" Then 
		p_phone = oJSONoutput.p_phone
	End if	
	If hasown(oJSONoutput, "p_relation") = "ok" Then 
		p_relation = oJSONoutput.p_relation
	End if	

	If hasown(oJSONoutput, "gno") = "ok" Then ' 한꺼번에 신청한 번호 정보
		gno = oJSONoutput.gno
	End If	

	If hasown(oJSONoutput, "gameidx") = "ok" Then 'sd_bikegame 게임정보
		gameidx = oJSONoutput.gameidx
	End If	
'request

	'##################
	'발송정보
	'##################
	m_nm = p_nm
	m_pn = p_phone
	'##################


	Set db = new clsDBHelper

	'##################
	'대회 및 종목 정보
	'##################
'	chkgames = Split(chkgame,":") '단체 1개씩
'	levelIDX  = Split(chkgames(0),",")(0)
'
	fieldstr = "a.GameTitleName,a.GameS,a.GameE,a.GameRcvDateS,a.GameRcvDateE,b.levelno,b.detailtitle,b.gameday,a.entertype,b.sex,b.booNM,b.subtitle "
	SQL = "SELECT TOP 1 "&fieldstr&"  FROM sd_bikeTitle as a INNER JOIN sd_bikeLevel as b ON a.titleIDX = b.titleIDX  where a.titleIDX = " & tidx & " and b.levelIDX = " & levelIDX & " and b.delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		title = rs("GameTitleName")
		games = Replace(rs("games"),"-",".")
		gamee = Replace(rs("gamee"),"-",".")
		GameRcvDateS = Replace(rs("GameRcvDateS"),"-",".")
		GameRcvDateE = Replace(rs("GameRcvDateE"),"-",".")
		detailTitle = rs("detailtitle")
		entertype = rs("entertype")
		If entertype = "E" Then
			enterstr  = "엘리트"
		Else
			enterstr = "생활체육"
		End If
		booNM = rs("booNM")
		subtitle = left(rs("subtitle"),2)
	End If


	
	'타입 석어서 보내기
	If DEBUG_MODE  And InStr(DEBUG_IP, USER_IP) > 0 Then
		toNumber = DEBUG_PNO
	Else
		toNumber = m_pn	
	End if	

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"

	db.Dispose
	Set db = Nothing
%>

  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">보호자동의 문자발송</h4>
      </div>
      <div class="modal-body pt-none">
				<!-- S: b-list-info -->
				<div class="b-list-info">
					<ul>
						<li>
							<p class="p-title">보호자 정보</p>
							<dl>
								<dd>
									<input type="text" placeholder="보호자 이름을 입력해주세요."  id="parent_name" maxlength="10" onkeydown = "if(event.keyCode == 13){$('#ptel2').focus();}">
								</dd>
							</dl>
						</li>
						<li>
							<p class="p-title">보호자 휴대전화</p>
							<dl>
								<dd>
									<div class="select-box">
									  <select name="" id="ptel1">
										<option value="010">010</option>
										<option value="011">011</option>
									  </select>
									</div>
									<div class="input-box">
										<input type="text" id="ptel2" onkeydown = "if(event.keyCode == 13){$('#ptel3').focus();}else{mx.chkNo()}" maxlength="4">
									</div>
									<div class="input-box">
										<input type="text" id="ptel3" onkeydown = "mx.chkNo()"  maxlength="4">
									</div>
								</dd>
							</dl>
						</li>
						<li>
							<p class="p-title">참가자와의 관계</p>
							<dl>
							  <dd>
								<label class="label-tab">
								  <input type="radio" name="parent_relation" value="부">
								  <span class="txt">부</span>
								</label>
								<label class="label-tab">
								  <input type="radio" name="parent_relation" value="모">
								  <span class="txt">모</span>
								</label>
								<label class="label-tab etx-btn">
								  <input type="radio" name="parent_relation" value="기타">
								  <span class="txt">기타</span>
								</label>
							  </dd>
								<dd class="etx">
					                <input type="text" placeholder="참가자와의 관계를 입력해주세요." id="parent_etc" maxlength="10">
								</dd>
							</dl>
						</li>
					</ul>
				</div>
				<!-- E: b-list-info -->
				
				<!-- S: btn-list -->
				<div class="btn-list">
					<a href="#" class="gray-btn" data-dismiss="modal">취소</a>
					
					<a href='javascript:mx.sendReLms(<%=strjson%>,"request_sms_modal")' class="blue-btn">확인</a>
				</div>
				<!-- E: btn-list -->
			</div>
		</div>
	</div>