<%
'######################
'수정폼
'######################
	If hasown(oJSONoutput, "FNO") = "ok" then
		fno = oJSONoutput.FNO
	End If
	If hasown(oJSONoutput, "OVAL") = "ok" then
		ovalue = oJSONoutput.OVAL
	End If
	If hasown(oJSONoutput, "TARGET") = "ok" then
		targetid = oJSONoutput.TARGET
	End If


	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"
		  
Select Case CDbl(fno)
Case 1
%>
		  <div class="tel-in">
            <div class="select-box">
              <input type="hidden" id="orgvalue" value="<%=ovalue%>"><!-- 인증번호 -->
			  <input type="hidden" id="confNo"><!-- 인증번호 -->
              <input type="hidden" id="confPno"><!-- 인증받은 폰번호 -->

			  <select name="" id="tel1" class="tel-1">
                  <option value="010">010</option>
                  <option value="011">011</option>
              </select>
            </div>
            <div class="input-box">
              <input type="text" class="tel-1" maxlength="4"  id="tel2" onkeydown = "mx.chkNo()">
            </div>
            <div class="input-box">
              <input type="text" class="tel-1" maxlength="4"  id="tel3" onkeydown = "mx.chkNo()">
            </div>
            <div class="r-btn">
              <a href="javascript:mx.chkMSG()" class="bgray-btn">인증</a>
            </div>
          </div>
          <div class="bt-number">
            <div class="input-box">
              <input type="text" class="tel-1" placeholder="인증번호 입력" id="chkrnd_no" maxlength="4" onkeydown = "mx.chkNo()">
              <span class="r-txt blue-txt" id="chktime">3:00</span>
            </div>
          </div>
          <!-- S: btn-list -->
          <div class="btn-list t-btn-list">
            <a href="javascript:mx.changeForm('<%=ovalue%>','<%=targetid%>',2)" class="gray-btn">취소</a>
            <a href="javascript:mx.compRnd();" class="blue-btn">완료</a>
          </div>
          <!-- E: btn-list -->
<%Case 2%>
		  <input type="text" value="<%=ovalue%>" class="in-tel" readonly>
          <!-- <span class="blue-txt certification">인증완료</span> -->
          <div class="r-btn">
            <a href="javascript:mx.changeForm('<%=ovalue%>', '<%=targetid%>', 1)" class="bgray-btn">수정</a>
          </div>



<%Case 5 '주소수정
	my_addr = Split(ovalue,":")
%>
          <div class="r-btn">
            <a href="javascript:Postcode()" class="bgray-btn addre">주소찾기</a>
          </div>
		  <div class="bt-in-box">
			<input type="text" placeholder="기본주소" id="uaddr" onfocus="Postcode()" value="<%=my_addr(0)%>">
			<input type="text" placeholder="나머지 주소 입력" id="uaddr2"  value="<%=my_addr(1)%>">
		  </div>
        </li>
        <li>
          <!-- S: btn-list -->
          <div class="btn-list t-btn-list">
            <a href="javascript:mx.changeForm('<%=ovalue%>', '<%=targetid%>', 6)" class="gray-btn">취소</a>
            <a href="javascript:mx.saveAddr()" class="blue-btn">완료</a>
          </div>
          <!-- E: btn-list -->
<%Case 6%>
          <span class="addre-txt"><%=replace(ovalue,":"," ")%></span>
          <div class="r-btn">
            <a href="javascript:mx.changeForm('<%=ovalue%>', '<%=targetid%>', 5)" class="bgray-btn modified-btn">수정</a>
          </div>	
 		  <div style="height:15px;"></div>




<%Case 10 '이메일
'myemail = Split(ovalue,"@")
%>
          <div class="email-con">
            <div class="input-box">
              <input type="text" class="tel-1" id="str_email1" maxlength="20">
            </div>
            <span class="txt">@</span>
            <div class="input-box">
              <input type="text" class="tel-1" id="str_email2" maxlength="20">
            </div>
            <div class="select-box">
              <select name="" id="str_emaillist" onchange="mx.setEmail()">
				 <option value="">직접입력</option>
				 <option value="naver.com">naver.com</option>
				 <option value="gmail.com">gmail.com</option>
				 <option value="hanmail.net">daum.net</option>
				 <option value="hanmail.net">hanmail.net</option>
				 <option value="hotmail.com">hotmail.com</option>
				 <option value="nate.com">nate.com</option>
				 <option value="yahoo.co.kr">yahoo.co.kr</option>
			  </select>
            </div>
          </div>
          <!-- S: btn-list -->
          <div class="btn-list t-btn-list email-btn-list">
            <a href="javascript:mx.changeForm('<%=ovalue%>', '<%=targetid%>', 11)" class="gray-btn">취소</a>
            <a href="javascript:mx.saveEmail()" class="blue-btn">완료</a>
          </div>
          <!-- E: btn-list -->
<%Case 11%>
		  <span class="email-box">
		  <%=Split(ovalue,"@")(0)%><br>@<%=Split(ovalue,"@")(1)%>
		  </span>
          <div class="r-btn">
            <a href="javascript:mx.changeForm('<%=ovalue%>', '<%=targetid%>', 10)" class="bgray-btn">수정</a>
          </div> 
<%End Select %>