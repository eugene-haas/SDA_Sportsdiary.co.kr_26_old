<%
'######################
'참가신청완료
'######################

'{"pg":1,"tidx":23,"name":"참가종목선택","subtype":"2","chkgame":"121,루키:122,CAT3:","CMD":20010,"levelidx":121,"uid":"hjhjkhk"}


	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If

	If hasown(oJSONoutput, "tidx") = "ok" Then
		tidx = oJSONoutput.tidx
	End If

	If hasown(oJSONoutput, "attmidx") = "ok" Then 'sd_bikeAttmember 키값 (팀맴버동의때사용)
		attmidx = oJSONoutput.attmidx
	Else
		attmidx = ""
	End if

	If hasown(oJSONoutput, "chkgame") = "ok" Then  '참가신청종목 수준
		chkgame = Split(oJSONoutput.chkgame,",")
		lelveIDX = chkgame(0)
		ugrade = Left(chkgame(1),4)
	End if

	'##############################
	Set db = new clsDBHelper

	fieldstr = "MemberIDX,userID,UserName,userPhone,birthday,sex,email,zipcode,address "
	SQL = "select " & fieldstr & " from tblMember where MemberIDX = " & Cookies_midx
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

	If Not rs.eof Then
	Uidx = rs("MemberIDX")
	userID		= rs("userID")
	UserName		= rs("UserName")
	userPhone		= rs("userPhone")
	birthday		= rs("birthday")
	sex		= LCase(rs("sex"))
	email		= rs("email")
	zipcode		= rs("zipcode")
	address				= rs("address")
	End if


	db.Dispose
	Set db = Nothing



'나이
myage = Cint(year(date)) - CInt(Left(birthday,4))
if CDbl(mid(Replace(date,"-",""),5))  >  CDbl(Mid(birthday, 5)) Then
	myage = myage - 1
End if

myageST = "Y"

If CDbl(myage) < 19 Then
	myageST = "N"
	'Response.write "미성년자<br><br>"
End if


strjson = JSON.stringify(oJSONoutput)
%>


<!-- ####################################################################### -->
  <input type="hidden" id="myageST" value="<%=myageST%>">

  <div class="sub-content guardian parental_consent">
    <!-- S: top-checke -->
	<div class="top-check">
      <div class="checkbox-design2">
        <label for="my_agree" class="on">
          <span class="on">하기 사항에 대하여 서약하며, 작성한 모든 내용이 모두 사실임을 확인합니다.</span>
          <input type="checkbox" id="my_agree" value="Y" checked>
        </label>
      </div>
    </div>
    <!-- E: top-checke -->
    <!-- S: rule -->
		<!-- #include virtual = "/bike/M_Player/include/inc.agree.asp" -->
    <!-- E: rule -->
    <div class="pd-15">
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
            <p class="p-title">보호자 휴대전화<%'=birthday%></p>
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
    </div>
    <!-- S: check-point -->

		<div class="check-point">
      <p class="p-title">CHECK POINT!</p>
      <ul>
        <li>
          <span class="number"></span>
          <span class="txt">본인포함 팀원 중 미성년자가 있을시 보호자 동의가 있어야 참가신청이 가능합니다.</span>
        </li>
        <li>
          <span class="number"></span>
          <span class="txt">(참가신청서 작성완료 후 보호자동의서 발송함)</span>
        </li>
      </ul>
    </div>


	<!-- E: check-point -->
    <div class="pd-15">
      <!-- S: btn-list -->
      <div class="btn-list">
        <a href="javascript:mx.myAgreeClose()" class="gray-btn">이전</a>
		<%If attmidx = "" then%>
			<%If CDbl(subtype) = 1 then%>
				<a href='javascript:mx.regPerson(<%=strjson%>,"/bike/m_player/request/request_competition_detail.asp")' class="blue-btn">확인</a>
			<%else%>
				<a href='javascript:mx.reqTeamNext(<%=strjson%>,"/bike/m_player/request/request_competition_detail.asp")' class="blue-btn">확인</a>
			<%End if%>
		<%Else '팀원 동의하로 옴%>
			<a href='javascript:mx.regPerson(<%=strjson%>,"/bike/m_player/request/request_competition_detail.asp")' class="blue-btn">확인</a>
		<%End if%>
      </div>
      <!-- E: btn-list -->

      <!-- <div class="btn-list">
        <a href="#" class="gray-btn">이전</a>
        <a href="#" class="bgray-btn">확인</a>
      </div> -->

    </div>
  </div>
