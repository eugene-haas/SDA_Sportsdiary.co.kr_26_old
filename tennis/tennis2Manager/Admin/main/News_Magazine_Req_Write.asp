<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  iLoginName = fInject(Request.Cookies("UserName"))
  iLoginID = decode(fInject(Request.cookies("UserID")),0)

  ' 뷰 관련
  Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  LCnt = 0

  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt1, PSeq1, FileName1, FilePath1
  LCnt1 = 0

  If iType = "2" Then

    iMSeq = fInject(Request("i1"))
    MSeq = decode(iMSeq,0)

    LSQL = "EXEC Subscription_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon4.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
					Status = LRs("Status")
          Division = LRs("Division")
          StartYear = LRs("StartYear")
          StartSection = LRs("StartSection")
          StartSectionName = LRs("StartSectionName")
					EndYear = LRs("EndYear")
          EndSection = LRs("EndSection")
          EndSectionName = LRs("EndSectionName")
					Period = LRs("Period")
					Payment = LRs("Payment")
					InsDateCv = LRs("InsDateCv")
					Name = LRs("Name")
					Phone = LRs("Phone")
					PostCode = LRs("PostCode")
					Address = LRs("Address")
					AddressDetail = LRs("AddressDetail")
					Email = LRs("Email")
					DepositorName = LRs("DepositorName")
          LoginIDYN = LRs("LoginIDYN")

        LRs.MoveNext
		  Loop

    End If
  
    LRs.close

    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then

      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
      response.End

    End If
  
  End If
  
%>

<script type="text/javascript">

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./News_Magazine_Req_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./News_Magazine_Req_List.asp', { 'i2': i2 });
  }

  function OK_Link() {

    // 스마트에디트 아닐때
    var theForm = document.form1;
    
    
    if (theForm.iPayment.value == "") {
      alert('발송료를 입력해 주세요.');
      return theForm.iPayment.focus();
    }
    
    if (theForm.iName.value == "") {
    	alert('신청자명을 입력해 주세요.');
    	return theForm.iName.focus();
    }

    if (theForm.iPhone.value == "") {
    	alert('연락처를 입력해 주세요.');
    	return theForm.iPhone.focus();
    }

    if (theForm.PostCode.value == "") {
    	alert('우편번호를 입력해 주세요.');
    	return theForm.PostCode.focus();
    }

    if (theForm.UserAddr.value == "") {
    	alert('주소를 입력해 주세요.');
    	return theForm.UserAddr.focus();
    }

    if (theForm.UserAddrDtl.value == "") {
    	alert('상세주소를 입력해 주세요.');
    	return theForm.UserAddrDtl.focus();
    }

    if (theForm.iEmail.value == "") {
    	alert('이메일을 입력해 주세요.');
    	return theForm.iEmail.focus();
    }

    if (theForm.iDepositorName.value == "") {
    	alert('입금자명을 입력해 주세요.');
    	return theForm.iDepositorName.focus();
    }
    
    if (confirm("해당 글을 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./News_Magazine_Req_Write_p.asp";
        theForm.submit();
    
      } catch (e) { }
    }
    else {
    
    }

  }

</script>

<section>
	<div id="content">

		<!-- S : 내용 시작 -->
		<div class="contents">
			
      <form id="form1" name="form1" action="./News_Magazine_Req_Write_p.asp" method="post">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr class="state">
            <th class="state">상태</th>
						<td colspan="4" class="state_result">
							<span class="right_con">
								<select id="iStatus" name="iStatus" class="title_select">
									<%
										' 리스트 조회
										CiType = "1"
										CType = "Subscription_State"
										CSubType = ""

										'LCnt2 = 0

										LSQL = "EXEC CodePropertyName_Search_Type_STR '" & CiType & "','" & CType & "','" & CSubType & "'"
										'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
										'response.End
  
										Set LRs = DBCon4.Execute(LSQL)
										
										If Not (LRs.Eof Or LRs.Bof) Then
											Do Until LRs.Eof
													'LCnt2 = LCnt2 + 1
									%>
									<option value="<%=LRs("Code") %>" <% if Status = LRs("Code") then %>selected<% end if %>><%=LRs("Name") %></option>
									<%
											LRs.MoveNext
										Loop
										End If

										LRs.close

										'JudoKorea_DBClose()

									%>
								</select>
							</span>
						</td>
					</tr>

					<tr>
            <th>구독구분</th>
						<td colspan="4">
							<span class="right_con">
								<select name="iDivision" id="iDivision" class="title_select">
									<option value="신규" <% if Division = "신규" then %>selected<% end if %>>신규</option>
									<option value="재구독" <% if Division = "재구독" then %>selected<% end if %>>재구독</option>
								</select>
							</span>
						</td>
					</tr>

					<tr>
            <th>신청년도</th>
						<td colspan="2">
							<span class="right_con">
								<select name="isyear" id="isyear" class="title_select">
									<option value="2010">2010년</option>
									<option value="2011">2011년</option>
									<option value="2012">2012년</option>
									<option value="2013">2013년</option>
									<option value="2014">2014년</option>
									<option value="2015">2015년</option>
									<option value="2016">2016년</option>
									<%
										Dim iSYear, iSYear_no
										iSYear = Year(Now())
										'iSYear = 2018
										iSYear_no = iSYear - 2016

										For i = 1 To iSYear_no
									%>
									<option value="<%= 2016 + i %>"><%= 2016 + i %>년</option>
									<%
										Next
									%>
									<option value="<%= 2016 + iSYear_no + 1 %>"><%= 2016 + iSYear_no + 1 %>년</option>
								</select>
							</span>
						</td>
						<th>신청호</th>
						<td colspan="2">
							<span class="right_con">
								<select id="iStartSection" name="iStartSection" class="title_select">
									<%
										' 리스트 조회
										CiType = "1"
										CType = "Subscription_Section"
										CSubType = ""

										LCnt2 = 0

										LSQL = "EXEC CodePropertyName_Search_Type_STR '" & CiType & "','" & CType & "','" & CSubType & "'"
										'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
										'response.End
  
										Set LRs = DBCon4.Execute(LSQL)
										
										If Not (LRs.Eof Or LRs.Bof) Then
											Do Until LRs.Eof
													LCnt2 = LCnt2 + 1
									%>
									<option value="<%=LRs("Code") %>"><%=LRs("Name") %></option>
									<%
											LRs.MoveNext
										Loop
										End If

										LRs.close

										'JudoKorea_DBClose()

									%>
								</select>
							</span>
						</td>
					</tr>

					<tr>
            
					</tr>

					<tr>
            <th>종료년도</th>
						<td colspan="2">
							<span class="right_con">
								<select name="ieyear" id="ieyear" class="title_select">
									<option value="2010">2010년</option>
									<option value="2011">2011년</option>
									<option value="2012">2012년</option>
									<option value="2013">2013년</option>
									<option value="2014">2014년</option>
									<option value="2015">2015년</option>
									<option value="2016">2016년</option>
									<%
										Dim iEYear, iEYear_no
										iEYear = Year(Now())
										'iEYear = 2018
										iEYear_no = iEYear - 2016

										For i = 1 To iEYear_no
									%>
									<option value="<%= 2016 + i %>"><%= 2016 + i %>년</option>
									<%
										Next
									%>
									<option value="<%= 2016 + iEYear_no + 1 %>"><%= 2016 + iEYear_no + 1 %>년</option>
									<option value="<%= 2016 + iEYear_no + 2 %>"><%= 2016 + iEYear_no + 2 %>년</option>
									<option value="<%= 2016 + iEYear_no + 3 %>"><%= 2016 + iEYear_no + 3 %>년</option>
									<option value="<%= 2016 + iEYear_no + 4 %>"><%= 2016 + iEYear_no + 4 %>년</option>
								</select>
							</span>
						</td>
						<th>종료호</th>
						<td colspan="2">
							<span class="right_con">
								<select id="iEndSection" name="iEndSection" class="title_select">
										<%
											' 리스트 조회
											CiType = "1"
											CType = "Subscription_Section"
											CSubType = ""

											LCnt2 = 0

											LSQL = "EXEC CodePropertyName_Search_Type_STR '" & CiType & "','" & CType & "','" & CSubType & "'"
											'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
											'response.End
  
											Set LRs = DBCon4.Execute(LSQL)
										
											If Not (LRs.Eof Or LRs.Bof) Then
												Do Until LRs.Eof
														LCnt2 = LCnt2 + 1
										%>
										<option value="<%=LRs("Code") %>"><%=LRs("Name") %></option>
										<%
												LRs.MoveNext
											Loop
											End If

											LRs.close

											JudoKorea_DBClose()

										%>
									</select>
							</span>
						</td>
					</tr>

					<tr>
            
					</tr>

					<tr>
            <th>구독기간</th>
						<td colspan="2">
							<span class="right_con">
								<select name="iPeriod" id="iPeriod" class="title_select">
									<option value="T" <% if Period = "T" then %>selected<% end if %>>무제한</option>
									<option value="1" <% if Period = "1" then %>selected<% end if %>>1년</option>
									<option value="2" <% if Period = "2" then %>selected<% end if %>>2년</option>
									<option value="3" <% if Period = "3" then %>selected<% end if %>>3년</option>
									<option value="4" <% if Period = "4" then %>selected<% end if %>>4년</option>
									<option value="5" <% if Period = "5" then %>selected<% end if %>>5년</option>
									<option value="10" <% if Period = "10" then %>selected<% end if %>>10년</option>
								</select>
							</span>
						</td>
						<th>발송료</th>
						<td colspan="4">
							<span class="right_con">
								<input type="text" id="iPayment" name="iPayment" value="<%=Payment %>" />
							</span> 원
						</td>
					</tr>
					</tr>
            <th>신청자명</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iName" name="iName" value="<%=Name %>" />
							</span>
						</td>
						<th>연락처</th>
						<td colspan="4">
							<span class="right_con">
								<input type="text" id="iPhone" name="iPhone" value="<%=Phone %>" />
							</span>
						</td>
					</tr>
					<tr>
            <th>우편번호</th>
						<td colspan="4" class="postal_code">
							<span class="right_con">
								<input type="text" id='PostCode' name='PostCode' value="<%=PostCode %>" />
							</span>
							<a href='javascript:;' onclick='javascript:execDaumPostcode();'>검색</a>
						</td>
					</tr>


					<tr>
            <th>주소</th>
						<td colspan="4">
							<span class="right_con">
								<input type="text" id="UserAddr" name="UserAddr" value="<%=Address %>" class='in_1' />
							</span>
						</td>
					</tr>

					<tr>
            <th>주소상세</th>
						<td colspan="4">
							<span class="right_con">
								<input type="text" id="UserAddrDtl" name="UserAddrDtl" value="<%=AddressDetail %>" class='in_1' />
							</span>
						</td>
					</tr>

					<tr>
            <th>이메일</th>
						<td colspan="4">
							<span class="right_con">
								<input type="text" id="iEmail" name="iEmail" value="<%=Email %>" class='in_1' />
							</span>
						</td>
					</tr>

					<tr>
            <th>입금자명</th>
						<td colspan="4">
							<span class="right_con">
								<input type="text" id="iDepositorName" name="iDepositorName" value="<%=DepositorName %>" />
							</span>
						</td>
					</tr>
					
				</table>
				<div class="btn_list">
					<input type="button" id="btnDel" name="btnDel" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
					<input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
					<input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />

					<input type="hidden" id="iMSeq" name="iMSeq" value="<%=iMSeq %>" />
					<input type="hidden" id="iType" name="iType" value="<%=iType %>" />
					<input type="hidden" id="iLN" name="iLN" value="<%=iLoginName %>" />
					<input type="hidden" id="iID" name="iID" value="<%=iLoginID %>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
					<input type="hidden" id="iStartSectionName" name="iStartSectionName" value="<%=StartSectionName %>" />
				</div>
      </form>

		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>

	<script type="text/javascript">
		
		var iType = Number("<%=iType%>");
		var iStartYear = "<%=StartYear%>";
		var iStartSection = "<%=StartSection%>";
		var iEndYear = "<%=EndYear%>";
		var iEndSection = "<%=EndSection%>";
		var iPeriod = "<%=Period%>";

		if (iType == 1) {
			var iNowYear = new Date();
			$('#isyear').val(iNowYear.getFullYear());
			$('#ieyear').val(iNowYear.getFullYear() + 1);
		}
		else {
			$('#isyear').val(iStartYear);
			$('#iStartSection').val(iStartSection);
			$('#ieyear').val(iEndYear);
			$('#iEndSection').val(iEndSection);
		}

		//$("#ieyear").val(selSearchValue03);

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

<!--#include file="footer.asp"-->

</html>