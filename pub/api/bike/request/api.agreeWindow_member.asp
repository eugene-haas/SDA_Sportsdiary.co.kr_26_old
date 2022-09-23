<%
Response.end
'######################
'참가신청완료 (사용되지 않는페이지
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

	fieldstr = "titleIDX,GameTitleName,GameS,GameE,GameRcvDateS,GameRcvDateE,GameYear,EnterType,DelYN,cfg,hostname,organize,titleCode,summary,GameArea,zipcode,sido,addr"
	SQL = "SELECT TOP 1 "&fieldstr&"  FROM sd_bikeTitle where titleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		entertype = rs("entertype")
		If entertype = "A" Then
			enterstr = "생활체육"
		Else
			enterstr = "엘리트"		
		End if
		title = rs("GameTitleName")
		games = Replace(rs("games"),"-",".")
		gamee = Replace(rs("gamee"),"-",".")
		GameRcvDateS = Replace(rs("GameRcvDateS"),"-",".")
		GameRcvDateE = Replace(rs("GameRcvDateE"),"-",".")
	End If


	fieldstr = "a.levelIDX,a.titleIDX,a.levelno,a.detailtitle,a.gameday,a.entertype,a.solocnt,a.gamecnt, b.title,b.subtitle,a.booNM "
	SQL = "select "&fieldstr&" from sd_bikeLevel as a INNER JOIN sd_titleList as b ON  a.levelno = b.levelno  where a.delYN = 'N' and a.titleIDX = " & tidx & " and a.levelIDX = " & lelveIDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Call rsDrow(rs)
	If Not rs.eof Then
		arrRS = rs.GetRows()
	End if
	If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			subtitle = arrRS(9, ar)
			boonm = arrRS(10, ar)
			dtltitle = arrRS(3, ar)

		Next
	End if



	db.Dispose
	Set db = Nothing




'birthday = 20000705

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




<input type="hidden" id="myageST" value="<%=myageST%>">

<label for="my_agree" class="checkbox-label">
            <input type="checkbox" id="my_agree"  value="Y" checked>
            <span>동의여부</span>
</label>


생일이 : <%=birthday%><br>
나이가 : <%=myage%><br>


<input type="text" id="parent_name" >보호자명<br>
<input type="text" id="parent_phone" >휴대전화<br>
<input type="text" id="parent_relation" > 참가자와의 관계<br>




<a href="javascript:mx.myAgreeClose()">[취소]</a>&nbsp;&nbsp;&nbsp;
<%If CDbl(subtype) = 1 then%>
<a href='javascript:mx.regPerson(<%=strjson%>,"request_end.asp")'>[참가신청]</a><br><!--참가신청 진행 -->
<%else%>
<a href='javascript:mx.reqTeamNext(<%=strjson%>,"request_end.asp")'>[참가신청]</a><br><!--참가신청 진행 -->
<%End if%>


<!-- ####################################################################### -->

  <div class="sub-content guardian">
    <!-- S: sub-navigation -->
    <div class="sub-navigation">
      <h2>신청대회정보</h2>
    </div>
    <!-- E: sub-navigation -->
    <div class="pd-15 pt-none pb-none">
      <p class="t-title">[<%=enterstr%>] <%=title%></p>
      <!-- S: list-info -->
      <div class="list-info">
		<ul>
          <li>
            <span class="l-name">종목구분</span>
            <span class="r-con">개인종목</span>
          </li>
          <li>
            <span class="l-name">부구분</span>
            <span class="r-con">남자부</span>
          </li>
          <li>
            <span class="l-name">신청종목</span>
            <span class="r-con">
              <span class="txt">200m 기록(CAT3)</span>
              <span clas="txt">독주경기(CAT4)</span>           
            </span>
          </li>
          <li>
            <span class="l-name">종목구분</span>
            <span class="r-con">개인종목</span>
          </li>
        </ul>

      </div>
    </div>
    <!-- E: list-info -->
    <div class="c-ment">
      <span class="txt">
          상기 보호자는 [스포츠다이어리배 양양대회]에 참가함에 있어 주최 측의 경기규칙을 준수하고, 경기 중 발생할 수 있는 부상의 위험을 인지하 고, 대회 중 일어난 사고 및 장비파손과 분실 등 물적, 인적 피해에 대한 책임은 전적으로 본인에게 있음을 동의하며, 보호자 동의 서약서 내용 본 대회에 참가를 허락합니다.
      </span>
    </div>
    <div class="pd-15">
      <!-- S: b-list-info -->
      <div class="b-list-info">
        <ul>
          <li>
            <p class="p-title">보호자명</p>
            <dl>
              <dd>
                <input type="text" placeholder="이름을 입력해주세요.">
              </dd>
            </dl>
          </li>
          <li>
            <p class="p-title">보호자(동의인) 주소</p>
            <dl>
              <dd>
                <a href="#" class="bgray-btn">주소찾기</a>
              </dd>
              <dd>
                <input type="text" value="기본 주소">
              </dd>
              <dd>
                <input type="text" placeholder="남어지 주소 입력">
              </dd>
            </dl>
          </li>
          <li>
            <p class="p-title">생년월일</p>
            <dl>
              <dd>
                <input type="text" placeholder="생년월일 6자리를 입력하세요." maxlength="6">
              </dd>
            </dl>
          </li>
          <li>
            <p class="p-title">참가자와의 관계</p>
            <dl>
              <dd>
                <label class="label-tab">
                  <input type="radio" name="marrige-type">
                  <span class="txt">부</span>
                </label>
                <label class="label-tab">
                  <input type="radio" name="marrige-type">
                  <span class="txt">모</span>
                </label>
                <label class="label-tab etx-btn">
                  <input type="radio" name="marrige-type">
                  <span class="txt">기타</span>
                </label>
              </dd>
              <dd class="etx">
                <input type="text" placeholder="참가자와의 관계를 입력해주세요.">
              </dd>
            </dl>
          </li>
        </ul>
      </div>
      <!-- E: b-list-info -->
      <!-- S: 개인정보취급방침 -->
      <div class="privacy-box">
        <label for="check1" class="checkbox-label">
          <input type="checkbox" id="check1" checked>
          <span>개인정보취급방침 동의</span>
        </label>
        <div class="privacy-con">
          개인정보 취급방침 동의 내용을 넣어주세요. 개인정보 취급방침 동의 내용을 넣어주세요. 개인정보 취급방침 동의 내용을 넣어주세요. 개인정보 취급방침 동의 내용을 넣어주세요. 개인정보 취급방침 동의 내용을 넣어주세요. 개인정보 취급방침 동의 내용을 넣어주세요.
        </div>
      </div>
      <!-- E: 개인정보취급방침 -->
      <p class="b-ment">상기 안내사항을 모두 확인하였으며,</p>
      <!-- S: btn-box -->
      <div class="btn-box">
        <a href="#" class="bgray-btn">동의합니다.</a>
        <a href="#" class="blue-btn">동의합니다.</a>
      </div>
      <!-- E: btn-box -->
    </div>
  </div>