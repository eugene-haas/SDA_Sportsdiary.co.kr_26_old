<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
%>

<%
  'Cookie 값 가져오기 
  NowPage = fInject(Request("i2")) 
  iSearchText = fInject(Request("i3"))
  ReqStatus =  fInject(Request("i4"))
  iStartDate = fInject(Request("i5"))
  iEndDate = fInject(Request("i6"))
  iMSeq = fInject(Request("i1"))
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("i8")) 'iType 1 : 쓰기, 2: 수정

  LCnt = 0
  if(NowPage = 0) Then NowPage = 1
  if(iType = 0) Then iType = 1
  'JudoTitleWriteLine "iType", iType
 
  IF (iType = 2) Then
    LSQL = "EXEC Admin_OnlineService_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          LCnt = LCnt + 1
          MSeq = LRs("MSeq")
          iName = LRs("Name")
          iUserID =  LRs("InsID")
          iCertificateName = LRs("CertificateName")
          iPhone = LRs("Phone")
          iBirthDay = LRs("BirthDay")
          iPublishingType = LRs("PublishingType")
          iSubmittingOrg = LRs("SubmittingOrg")
          iReceiveType = LRs("ReceiveType")
          iReceipt_Fax = LRs("Receipt_Fax")
          iPostCode = LRs("Receipt_PostCode")
          iReceipt_Address = LRs("Receipt_Address")
          iReceipt_AddressDetail = LRs("Receipt_AddressDetail")
          iReceipt_VisitDate = LRs("Receipt_VisitDate")
          ilevelType = LRs("levelType")
          iStatus = LRs("Status")
          iPayment = LRs("Payment")
          iInsDateCv = LRs("InsDateCv")
        LRs.MoveNext
      Loop
    End IF
    LRs.close

    If LoginIDYN = "N" Then
      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      response.End
    End IF
  End IF
%>

<%
  Dim iCType : iCType = 1
  Dim Const_iCTypeOnlineService_State
  Dim OSName,OSCode,OSRCnt
  Const_iCTypeOnlineService_State ="OnlineService_State"
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeOnlineService_State & "','" & iTP_Type & "'"
  'JudoTitleWriteLine "LSQL", LSQL
 
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      OSRCnt = OSRCnt + 1 
      OSName = OSName & "^" & LRs("Name") & ""
      OSCode = OSCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close
  'JudoTitleWriteLine "OSRCnt", OSRCnt
  'JudoTitleWriteLine "OSCode", OSCode
  'JudoTitleWriteLine "OSName", OSName
  'response.end
%>



<script type="text/javascript">
  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");
	var price = 5000;

	$( document ).ready(function() {
      
		  if(iType == 2) {
			$("#iUserPhone").val(autoHypenPhone("<%=iPhone%>"));
			$("#selPublishingType").val("<%=iPublishingType%>")	
      $("#selectStatusOption").val("<%=iStatus%>");

			if("<%=iReceiveType%>" == "방문")
			{
          $("#visit").prop("checked",true);
          price = 3000;
          $("#span_Price").text(numberWithCommas(price) + "원");
          $("#datepicker1").datepicker();
          var visitDate = "<%=iReceipt_VisitDate%>";
          $("#datepicker1").val(visitDate);
          document.getElementById('liVisit').style.display = '';
        }
        else {
          $("#post").prop("checked",true);
          price = 5000;
          $("#span_Price").text(numberWithCommas(price) + "원");
          document.getElementById('liVisit').style.display = 'none';
        }
		}
    else
    {
      var date = new Date();
      var day = date.getDate();
      var month = date.getMonth() + 1;
      var year = date.getFullYear();
      if (month < 10) month = "0" + month;
      if (day < 10) day = "0" + day;
      var today = year + "-" + month + "-" + day;       
      $("#datepicker1").attr("value", today);
      price = 5000;
      $("#span_Price").text(numberWithCommas(price) + "원");
      $("#selectStatusOption option")[0].selected = true;
    }
  });

   function toDate(dateStr) {
    var parts = dateStr.split(".");
    return (parts[0] + "-" + parts[1] + "-" + parts[2]);
  }

  function numberWithCommas(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

  
  function Del_Link(i1, i2) 
  {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Certificate_delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./Certificate_list.asp', { 'i2': i2 });
  }

  function chk_frm(){
  
   if(!$('#selectStatusOption').val()){
      alert("팀소속을 선택해주세요.");
      $('#selectStatusOption').focus();
      return false;
  } 

  if(!$('#selectOptionWeight').val()){
      alert("구분을 선택해주세요.");
      $('#selectOptionWeight').focus();
      return false;
  } 

  if(!$('#iName').val()){
      alert("이름을 입력해 주세요.");
      $('#iName').focus();
      return false;
  } 
  
   if(!$('#selectPositionOption').val()){
      alert("직책을 선택해주세요.");
      $('#selectPositionOption').focus();
      return false;
  } 


   if(!$('#selectYear').val()){
      alert("년도를 선택해주세요.");
      $('#selectYear').focus();
      return false;
  } 
  
  return true;
}

function OK_Link() {
  if(iType == 1){

      var input1 = $("<input>")
											.attr("type", "hidden")
											.attr("name", "span_Price").val(price);
      var input2="";

      if($("#visit").prop("checked"))
      {
        input2 = $("<input>")
                  .attr("type", "hidden")
                  .attr("name", "iReceiveType").val("visit");

      }
      else if($("#post").prop("checked"))
      {
        input2 = $("<input>")
                  .attr("type", "hidden")
                  .attr("name", "iReceiveType").val("post");
      }

      var phone  = $("#iUserPhone").val().replace(/[^0-9]/g,'');

      var input3= $("<input>")
									.attr("type", "hidden")
									.attr("name", "iPhone").val(phone);

      var elClickedObj = $("#form1").append($(input1)).append($(input2)).append($(input3));

      try {
        elClickedObj.submit();
      } catch (e) {

      }

  }
  else if( iType == 2){
    	var input1 = $("<input>")
											.attr("type", "hidden")
											.attr("name", "span_Price").val(price);
			var input2="";

			if($("#visit").prop("checked"))
			{
				input2 = $("<input>")
									.attr("type", "hidden")
									.attr("name", "iReceiveType").val("visit");

			}
			else if($("#post").prop("checked"))
			{
				input2 = $("<input>")
									.attr("type", "hidden")
									.attr("name", "iReceiveType").val("post");
			}

      var phone  = $("#iUserPhone").val().replace(/[^0-9]/g,'');

      var input3= $("<input>")
									.attr("type", "hidden")
									.attr("name", "iPhone").val(phone);

			var elClickedObj = $("#form1").append($(input1)).append($(input2)).append($(input2)).append($(input3));

			try {
				elClickedObj.submit();
			} catch (e) {

			}

  }
  
}

function feeChange(Optionfee)
{
  var OptionType = Optionfee.id;

  if(OptionType == "post")
  {
    price = 5000;
    $("#span_Price").text(numberWithCommas(price) + "원");
    document.getElementById('trVisit').style.display = 'none';
  }
  else if(OptionType =="visit")
  {
    price = 3000;
    $("#span_Price").text(numberWithCommas(price) + "원");
    document.getElementById('trVisit').style.display = '';

      var date = new Date();
      var day = date.getDate();
      var month = date.getMonth() + 1;
      var year = date.getFullYear();
      if (month < 10) month = "0" + month;
      if (day < 10) day = "0" + day;
      var today = year + "-" + month + "-" + day;       
      $("#datepicker1").attr("value", today);

  }
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
     		온라인서비스 > 선수증재발급
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Certificate_write_p.asp" method="post" >
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr>
            <th>증명서 종류</th>
						<td>
							<span class="left_name">
              <%
                IF iType = 2 Then
              %>
                  <%=iCertificateName %>
              <%
                ELSE
              %>
                선수증재발급
              <%
                END IF
              %>
							</span>
						</td>
					</tr>

          <tr>
            <th>상태</th>
						<td colspan="2">
							<span class="right_con">
                <select name="selectStatusOption" id="selectStatusOption" class="in_2 cert_use">
                </select>
							</span>
						</td>
					</tr>

          <% if iType ="2" then %>
          <tr>
            <th>신청날짜</th>
            <td>
              <span class="left_name">
                <span class="regist_date"><%=iInsDateCv %></span><br />
              </span>
            </td>
          </tr>
					<% end if %>

          <tr>
            <th>이름</th>
						<td colspan="2">
							<span class="right_con">
								<%
                  IF iType = 1 Then 
                    Response.Write("<input type='text' id='iName' name='iName' class='in_1'/>")
                  ELSE
                    Response.Write("<input type='text' id='iName' name='iName' value='" & iName & "' class='in_1'/>")
                  End IF
                %>
							</span>
						</td>
					</tr>

          <tr>
            <th>아이디</th>
						<td colspan="2">
							<span class="right_con">
								<%
                  IF iType = 1 Then 
                    Response.Write("<input type='text' id='iUserID' name='iUserID' class='in_1'/>")
                  ELSE
                     Response.Write("" & iUserID & "")
                  End IF
                %>
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
                <input type="text" class="in_4" name="iUserPhone" id="iUserPhone" maxlength="13" onKeyUp="this.value = autoHypenPhone(this.value); if($('#UserPhone').val().length==13){$('#postcode').focus();}" />
                <%
                  ELSE
                %>
                <input type="text" class="in_4"  name="iUserPhone" id="iUserPhone" value="<%=iPhone%>"  maxlength="13" onKeyUp="this.value = autoHypenPhone(this.value); if($('#UserPhone').val().length==13){$('#postcode').focus();}" />
                <%
                  End IF
                %>
							</span>
						</td>
					</tr>

          <tr>
            <th>발급용도</th>
						<td colspan="2">
							<span class="right_con">
									<select name="selPublishingType" id="selPublishingType" class="in_2 cert_use">
										<option value="취업용">취업용</option>
										<option value="군입대">군입대</option>
										<option value="진학용">진학용</option>
										<option value="기타">기타</option>
									</select>
							</span>
						</td>
					</tr>
          <tr>

					<tr>
            <th>수령방법</th>
						<td colspan="2">
							<span class="right_con">
							 <input type="radio" name="receive" id="post" class="radio_in" onchange="feeChange(this)" checked="">
               <label for="post">우편수령</label>
               <input type="radio" name="receive" id="visit" class="radio_in" onchange="feeChange(this)">
               <label for="visit">방문수령</label>
							</span>
						</td>
					</tr>
         
          <tr  id="trVisit" name="trVisit" style="display:none">
            <th>방문일자</th>
						<td colspan="2">
							<span class="right_con">
									<input type="text" id="datepicker1" name="datepicker1" class="in_1 date_ipt">
									<!--<span class="date_icon" ></span>-->
									<label for="datepicker1" class="date_icon"></label>
							</span>
						</td>
					</tr>
			
          <tr>
            <tr>
            <th>발급수수료</th>
						<td colspan="2">
							<span class="right_con" id="span_Price" name="span_Price">
							  5,000원
							</span>
						</td>
					</tr>
          <tr>
            <th>수령주소</th>
						<td colspan="2">
							<span class="right_con">
								<div class="address">
                    <%
                      	IF ( iType = 1) THEN
												%>
													<input type="text" id="postcode" name="postcode"   class="in_2"/>
												<%
													Else
												%>
													<input type="text" id="postcode" name="postcode" value="<%=iPostCode%>" class="in_2"/>
												<%
													End If
												%>
                    <a href="javascript:;" Onclick="javascript:execDaumPostcode()">우편번호 검색</a>
                </div>
                <span class="right_con">
								<div class="address">
                    	<%
                        IF ( iType = 1) THEN
                      %>
                      <input type="text" id="UserAddr" name="UserAddr"  class="in_5" />
                      <%
                        ELSE
                      %>
                      <input type="text" id="UserAddr" name="UserAddr" value="<%=iReceipt_Address%>" class="in_6" />
                      <%
                        END IF
                      %>
                      <%
                        IF ( iType = 1) THEN
                      %>
                      <input type="text" id="UserAddrDtl" name="UserAddrDtl"  class="in_5"/>
                      <%
                        ELSE
                      %>
                      <input type="text" id="UserAddrDtl" name="UserAddrDtl" value="<%=iReceipt_AddressDetail%>" class="in_5"/>
                      <%
                        END IF
                      %>
                </div>
							</span>
						</td>
				</table>
				<div class="btn_list">
          <%
          if(iType = 2) Then
          %>
					<input type="button" id="btnOK" name="btnOK" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
          <%
          End If
          %>
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
  var dName = "<%=DName%>"
  var dCode = "<%=DCode%>"
  var dRCnt = "<%=DRCnt%>"
  var dNameArr = dName.split("^");
  var dCodeArr = dCode.split("^");
  var playerPosition = "P00003";

  var pName = "<%=PName%>"
  var pCode = "<%=PCode%>"
  var pRCnt = "<%=PRCnt%>"
  var pNameArr = pName.split("^");
  var pCodeArr = pCode.split("^");

  var wName1 = "<%=WName1%>"
  var wCode1 = "<%=WCode1%>"
  var wRCnt1 = "<%=WRCnt1%>"
  var wNameArr1 = wName1.split("^");
  var wCodeArr1 = wCode1.split("^");

  var wName2 = "<%=WName2%>"
  var wCode2 = "<%=WCode2%>"
  var wRCnt2 = "<%=WRCnt2%>"
  var wNameArr2 = wName2.split("^");
  var wCodeArr2 = wCode2.split("^");

  for(var di=1; di <= dRCnt; di++)
  {
    $("#selectStatusOption").append("<option value=" + dCodeArr[di] + ">" + dNameArr[di] + "</option>");
  }

  for(var pi=1; pi <= pRCnt; pi++)
  {
    $("#selectPositionOption").append("<option value=" + pCodeArr[pi] + ">" + pNameArr[pi] + "</option>");
  }

  $('#selectPositionOption').on('change', function () {
     var selectPositionVal =  $(this).val();
     if(selectPositionVal !="")
     {
        Load(selectPositionVal)
     }
  });

  function Load(selectPosition)
  {
    $('#selectOptionWeight').find('option').remove();
    //$("#selectOptionWeight").append("<option value=''>전체</option>");
    if(playerPosition == selectPosition)
    {
      for(var wi1=1; wi1 <= wRCnt1; wi1++)
      {
        $("#selectOptionWeight").append("<option value=" + wCodeArr1[wi1] + ">" + wNameArr1[wi1] + "</option>");
      }

    }
    else{
      for(var wi2=1; wi2 <= wRCnt2; wi2++)
      {
        $("#selectOptionWeight").append("<option value=" + wCodeArr2[wi2] + ">" + wNameArr2[wi2] + "</option>");
      }
    }
  }
</script>

<script type="text/javascript">
    // 첨부파일 관련
    var LCnt1 = Number("<%=LCnt1%>");
    //alert(LCnt1);

    var PSeq1 = "<%=PSeq1%>";
    var FileName1 = "<%=FileName1%>";
    var PSeq1arr = PSeq1.split("^");
    var FileName1arr = FileName1.split("^");
    
    function FileDel(i4, i5, i6) {
      //alert("i4:" + i4 )
      //alert("i5:" + i5 )
      //alert("i6:" +i6 )
      if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {

      	//alert(i4 + ", " + i5 + " , " + i6 + " , " + filetype);

        var strAjaxUrl = "../dev/dist/CommonFileDelete.asp";
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
            i4: i4,
            i5: i5,
      	    i6: i6,
						i7: "3"
          },
          success: function (retDATA) {
            alert(retDATA);
            if (retDATA == "1") {
              alert("해당 파일이 삭제 됐습니다.");
              $('#fileid_' + i4).remove();
            } else {
              alert("해당 파일이 없습니다.");
              $('#fileid_' + i4).remove();
            }
        
            $('#sFile_1').css('display', '');
        
          }, error: function (xhr, status, error) {
            if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
          }
        });

      }
      else {

      }
    }


    function FN_FileList(i) {
      var iHtmlPC1 = '<p>';
      iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
      iHtmlPC1 = iHtmlPC1 + ' <span><a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a></span>';
      iHtmlPC1 = iHtmlPC1 + ' <span><a href="javascript:;" onClick="javascript:FileDel(&#39;' + PSeq1arr[i] + '&#39;,&#39;' + FileName1arr[i] + '&#39;,&#39;' + iMSeq + '&#39;)" class="ex_btn">X</a></span>';
      iHtmlPC1 = iHtmlPC1 + '</p>';
      iHtmlPC1 = iHtmlPC1 + '</p>';
    	//alert(iHtmlPC1);
      $('#iFileDiv').prepend(iHtmlPC1);

    }
    
    // 파일갯수가 파일제한보다 많을땐 파일추가 부분 삭제
    if (LCnt1 > 0) {

    	for (var i = 1; i < LCnt1 + 1; i++) {
    			$('#sFile_1').css('display', 'none');
    			FN_FileList(i);
    	}
    }
    else {

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
                document.getElementById('postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('UserAddr').value = fullRoadAddr;
                document.getElementById('UserAddr').focus();
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
  var OSName = "<%=OSName%>"
  var OSCode = "<%=OSCode%>"
  var OSRCnt = "<%=OSRCnt%>"
  var OSNameArr = OSName.split("^");
  var OSCodeArr = OSCode.split("^");
  
  for(var i=1; i <= OSRCnt; i++)
  {
    $("#selectStatusOption").append("<option value=" + OSCodeArr[i] + ">" + OSNameArr[i] + "</option>");
  }

</script>


<!--#include file="footer.asp"-->

<%
 
  JudoKorea_DBClose() 
%>

</html>