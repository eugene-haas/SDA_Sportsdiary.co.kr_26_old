<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  NowPage = fInject(Request("i1")) 
  ReqLocalVal = fInject(Request("i2"))     
  ReqDivisionVal = fInject(Request("i3")) 
  ReqOptionVal = fInject(Request("i4")) 
  ReqTeamNameVal= fInject(Request("i5"))
  iMSeq = fInject(Request("i6"))
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("i7")) 'iType 1 : 쓰기, 2: 수정
  'Cookie 값 가져오기 
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  LCnt = 0
  LCnt1 = 0
  if(NowPage = 0) Then NowPage = 1
  if(iType = 0) Then iType = 1
  IF (iType = 2) Then
    LSQL = "EXEC TeamPlayer_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          LCnt = LCnt + 1
          iTeamName = LRs("TeamName")
          iInsDateCv = LRs("InsDateCv")
          iCoachName = LRs("CoachName")
          iLeaderName = LRs("LeaderName")
          iAddress = LRs("Address")
          iAddressDetail = LRs("AddressDetail")
          iPostCode = LRs("PostCode")
          iPhone = LRs("Phone")
          iLocalName = LRs("Local")
          iTypeOptionName = LRs("TP_TypeOption")
          iDivisionName = LRs("TP_Division")
          iYear = LRs("TP_Year")
        LRs.MoveNext
      Loop
    End IF
    LRs.close
    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then
      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      response.End
    End IF
  End IF
%>

<%
  Dim LSQL 'sqlQuery
  Dim iCType : iCType = 1
  Dim Const_iCTypeLocal,Const_iCTypeDivision,Const_iCTypeTypeOptionSex
  Dim LName,LCode,LRCnt,DName,DCode,DRCnt,OName,OCode,ORCnt
  Const_iCTypeLocal = "Local" 
  Const_iCTypeDivision ="TP_Division"
  Const_iCTypeTypeOptionSex = "TP_TypeOption_Team_Sex"
  
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeLocal & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      LRCnt = LRCnt + 1
      LName = LName & "^" & LRs("Name") & ""
      LCode = LCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeTypeOptionSex & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      ORCnt = ORCnt + 1
      OName = OName & "^" & LRs("Name") & ""
      OCode = OCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeDivision & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      DRCnt = DRCnt + 1 
      DName = DName & "^" & LRs("Name") & ""
      DCode = DCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close
%>

<script type="text/javascript">
  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");
  
  function Del_Link(i1, i2) 
  {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Player_team_info_delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i1) {
  	post_to_url('./Player_team_info.asp', { 'i1': i1 });
  }

function chk_frm(){
  if(!$('#iTeamName').val()){
      alert("팀명을 입력해 주세요.");
      $('#iTeamName').focus();
      return false;
  } 
  
  if($('#iTeamName').val().length < 2 || $('#iTeamName').val().length > 10){
      alert("팀명은 2자~10자입니다.");
      $('#iTeamName').focus();
      return false;
  }	
   if(!$('#selectLocal').val()){
      alert("지역을 선택해주세요.");
      $('#selectLocal').focus();
      return false;
  } 
   if(!$('#selectYear').val()){
      alert("년도를 선택해주세요.");
      $('#selectYear').focus();
      return false;
  } 
   if(!$('#selectDivision').val()){
      alert("구분 값을 선택해주세요.");
      $('#selectDivision').focus();
      return false;
  } 
   if(!$('#selectOptionSex').val()){
      alert("팀 성별을 선택해주세요.");
      $('#selectOptionSex').focus();
      return false;
  } 
  
  if(iType == 1)
  {
    if(!$('#UserPhone2').val()){
        alert("휴대폰 번호를 입력해 주세요.");
        $('#UserPhone2').focus();
        return false;
    }
    if(!$('#UserPhone3').val()){
        alert("휴대폰 번호를 입력해 주세요.");
        $('#UserPhone3').focus();
        return false;
    }
  }
  else
  {
    if(!$('#iPhoneNum').val()){
        alert("휴대폰 번호를 입력해 주세요.");
        $('#iPhoneNum').focus();
        return false;
    }
  }
    

  
  if(!$('#UserAddr').val()){
      alert("주소를 입력해 주세요.");
      $('#UserAddr').focus();
      return false;
  }		

  return true;
}


  function OK_Link() {
    if(chk_frm())
    {
      if(iType == 1){
          var phone1 = $('#UserPhone1').val();
          var phone2 = $('#UserPhone2').val();
          var phone3 = $('#UserPhone3').val();
          var phoneTotal = phone1 + phone2 + phone3

          var input = $("<input>")
                      .attr("type", "hidden")
                      .attr("name", "iPhone").val(phoneTotal);

          var elClickedObj = $("#form1").append($(input));

        try {
          elClickedObj.submit();
        } catch (e) {
        }
      }
      else if(iType ==2)
      {
        var elClickedObj = $("#form1");
        var iPhoeInput = elClickedObj.find('input[name="iPhoneNum"]').val().replace(/[^0-9]/g,'');
        //elClickedObj.find('input[name="iPhoneNum"]').val(iPhoeInput)
          var input = $("<input>")
                      .attr("type", "hidden")
                      .attr("name", "iPhone").val(iPhoeInput);
        elClickedObj.append($(input));
        try {
          elClickedObj.submit();
        } catch (e) {
        }
      }
    }
  }

  function chk_Number(object){
  $(object).keyup(function(){
      $(this).val($(this).val().replace(/[^0-9]/g,""));
  }); 	
}

function autoHypenPhone(str){
	str = str.replace(/[^0-9]/g, '');
	var tmp = '';
	if( str.length < 4){
		return str;
	}else if(str.length < 7){
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3);
		return tmp;
	}else if(str.length < 11){
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3, 3);
		tmp += '-';
		tmp += str.substr(6);
		return tmp;
	}else{				
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3, 4);
		tmp += '-';
		tmp += str.substr(7);
		return tmp;
	}
	return str;
}


</script>

<section>
	<div id="content">
		<!-- S : 내용 시작 -->
		<div class="contents">
      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        팀/선수정보 > 팀/선수정보 > 팀정보
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Player_team_info_write_p.asp" method="post" >
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr>
            <th>팀명</th>
						<td>
							<span class="left_name">
                <%
                IF iType = 1 Then 
                %>
                <input type="text" id="iTeamName" name="iTeamName" class="in_1"/>
                <%
                ELSE
                %>
                  <input type="text" id="iTeamName" name="iTeamName" value="<%=iTeamName%>" class="in_1"/>
                <%
                End IF
                %>
							</span>
						</td>
					</tr>
					<% if iType ="2" then %>
          <tr>
            <th>등록일</th>
            <td>
              <span class="left_name">
                <span class="regist_date"><%=iInsDateCv %></span><br />
              </span>
            </td>
          </tr>
					<% end if %>
					<tr>
            <th>지역</th>
						<td colspan="2">
							<span class="right_con">
								 <select id="selectLocal" name="selectLocal" class="title_select">
                  <option value="">시/도</option>
                </select>
							</span>
						</td>
					</tr>
					<tr>
          <tr>
            <th>년도</th>
						<td colspan="2">
							<span class="right_con">
								 <select id="selectYear" name="selectYear" class="title_select">
                  <option value="">년도</option>
                  <%
                    standardYear = 2010
                    currentYear = year(now()) + 1
                    CntYear = currentYear - standardYear 
                    for i= CntYear to 0 step -1
                      Response.Write("<option value='"& standardYear + i&"'>"& standardYear + i&"</option>")
                    next 
                  %>
                </select>
							</span>
						</td>
					</tr>
					<tr>
            <th>구분</th>
						<td colspan="2">
							<span class="right_con">
                <select id="selectDivision" name="selectDivision" class="title_select">
                  <option value="">구분</option>
                </select>
							</span>
						</td>
					</tr>
					<tr>
            <th>성별</th>
						<td colspan="2">
							<span class="right_con">
							 <select id="selectOptionSex" name="selectOptionSex" class="title_select">
                  <option value="">성별</option>
                </select>
							</span>
						</td>
					</tr>
          <tr>
            <th>연락처</th>
						<td colspan="2">
							<span class="right_con">
                <%
                IF iType = 1 Then 
                %>
                  <select name="UserPhone1" id="UserPhone1">
                    <option value="010" selected>010</option>
                    <option value="011">011</option>
                    <option value="016">016</option>
                    <option value="017">017</option>
                    <option value="018">018</option>
                    <option value="019">019</option>
                  </select>
                  <span>-</span>
                  <input type="text" class="in_2" name="UserPhone2" id="UserPhone2" maxlength="4" onKeyUp="chk_Number(this); if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}"/>
                  <span>-</span>
                  <input type="text" class="in_2" name="UserPhone3" id="UserPhone3" maxlength="4" onKeyUp="chk_Number(this); if($('#UserPhone3').val().length==4){$('#postcode').focus();}"/>
                <%
                ELSE
                  Response.Write("<input type='text' id='iPhoneNum' name='iPhoneNum' value='" & iPhone & "' class='in_1'  maxlength='13'/>")
                End IF
                %>
							</span>
						</td>
					</tr>
            <tr>
            <th>우편번호</th>
						<td colspan="2">
							<span class="right_con">
							    <%
                  IF iType = 1 Then 
                    Response.Write("<input type='text' id='PostCode' name='PostCode' class='in_1'/>")
                  ELSE
                    Response.Write("<input type='text' id='PostCode' name='PostCode' value='" & iPostCode & "' class='in_1'/>")
                  End IF
                  %>
                  <div class="map_2">
                  </div>
							</span>
						</td>
					</tr>
          <tr>
            <th>주소</th>
						<td colspan="2">
							<span class="right_con address_area">
							    <%
                  IF iType = 1 Then 
                    Response.Write("<input type='text' id='UserAddr' name='UserAddr' class='in_1'/>")
                    Response.Write("<a href='javascript:;' Onclick='javascript:execDaumPostcode();'>검색</a>")
                    Response.Write("<input type='text' id='UserAddrDtl' name='UserAddrDtl' class='in_1'/>")
                  ELSE
                    Response.Write("<input type='text' id='UserAddr' name='UserAddr' value='" & iAddress & "' class='in_1'/>")
                    Response.Write("<a href='javascript:;' Onclick='javascript:execDaumPostcode();'>검색</a>")
                    Response.Write("<input type='text' id='UserAddrDtl' name='UserAddrDtl' value='" & iAddressDetail & "' class='in_1'/>")
                  End IF
                    
                  %>
                  <div class="map_2">
                  </div>
							</span>
						</td>
					</tr>
            <tr>
            <th>감독</th>
						<td colspan="2">
							<span class="right_con">
							    <%
                IF iType = 1 Then 
                  Response.Write("<input type='text' id='iLeaderName' name='iLeaderName' class='in_1'/>")
                ELSE
                  Response.Write("<input type='text' id='iLeaderName' name='iLeaderName' value='" & iLeaderName & "' class='in_1'/>")
                End IF 
                %>
							</span>
						</td>
					</tr>
          <tr>
            <th>코치</th>
						<td colspan="2">
							<span class="right_con">
							    <%
                IF iType = 1 Then 
                  Response.Write("<input type='text' id='iCoachName' name='iCoachName' class='in_1'/>")
                ELSE
                  Response.Write("<input type='text' id='iCoachName' name='iCoachName' value='" & iCoachName & "' class='in_1'/>")
                End IF
                %>
							</span>
						</td>
					</tr>
				</table>
				<div class="btn_list">
					<input type="button" id="btnOK" name="btnOK" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
					<input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
					<input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />
          <%
          if(iType = 2) Then
          %>
          <input type="hidden" id="iMSeq" name="iMSeq" value="<%=iMSeq %>" />
          <%
          End If
          %>
					<input type="hidden" id="iType" name="iType" value="<%=iType %>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
				</div>
      </form>
		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>

<script type="text/javascript">
  var lName = "<%=LName%>"
  var lCode = "<%=LCode%>"
  var lRCnt = "<%=LRCnt%>"
  var lNameArr = lName.split("^");
  var lCodeArr = lCode.split("^");

  for(var li=1; li <= lRCnt; li++)
  {
    $("#selectLocal").append("<option value=" + lCodeArr[li] + ">" + lNameArr[li] + "</option>");
  }

  var dName = "<%=DName%>"
  var dCode = "<%=DCode%>"
  var dRCnt = "<%=DRCnt%>"
  var dNameArr = dName.split("^");
  var dCodeArr = dCode.split("^");

  for(var di=1; di <= dRCnt; di++)
  {
    $("#selectDivision").append("<option value=" + dCodeArr[di] + ">" + dNameArr[di] + "</option>");
  }

  var oName = "<%=OName%>"
  var oCode = "<%=OCode%>"
  var oRCnt = "<%=ORCnt%>"
  var oNameArr = oName.split("^");
  var oCodeArr = oCode.split("^");

  for(var oi=1; oi <= oRCnt; oi++)
  {
    $("#selectOptionSex").append("<option value=" + oCodeArr[oi] + ">" + oNameArr[oi] + "</option>");
  }

  if(iType == 1)
  {
      //$("#selectLocal option")[1].selected = true;
      //$("#selectDivision option")[1].selected = true;
      //$("#selectOptionSex option")[1].selected = true;
      $("#selectYear option")[2].selected = true;
  }
  else{
    $("#selectLocal").val('<%=iLocalName%>');
    $("#selectDivision").val('<%=iDivisionName%>');
    $("#selectOptionSex").val('<%=iTypeOptionName%>');
    $("#selectYear").val('<%=iYear%>');
    $("#iPhoneNum").val(autoHypenPhone("<%=iPhone%>"));
  }

</script>

<div id="wrap" style="display: none; border:1px solid #000; width:100%; height:100%; margin:48px 0; position: absolute; z-index:1000;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style=" width:17px;cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onClick="foldDaumPostcode()" alt="접기 버튼">
</div>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<span id="guide" style="color:#999"></span>
<script type="text/javascript">
  var width = 500; //팝업창이 실행될때 위치지정
  var height = 600; //팝업창이 실행될때 위치지정
  function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('PostCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('UserAddr').value = fullRoadAddr;
                document.getElementById('UserAddrDtl').focus();

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
        }
    
</script>

<script type="text/javascript">
var cellPhone = document.getElementById("iPhoneNum");
cellPhone.onkeyup = function(event){
  event = event || window.event;
  var _val = this.value.trim();
  this.value = autoHypenPhone(_val) ;
}
</script>

<!--#include file="footer.asp"-->

<%
 
  JudoKorea_DBClose() 
%>

</html>