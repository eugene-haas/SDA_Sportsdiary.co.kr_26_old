<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  Name = fInject(Request.Cookies("UserName"))
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

    LSQL = "EXEC tblSvcSctInfo_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
	  'response.Write "LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon4.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
          SctNm = LRs("SctNm")
          Director = LRs("Director")
					SidoNm = LRs("SidoNm")
          Address = LRs("Address")
          AddrDtl = LRs("AddrDtl")
					ZipCode = LRs("ZipCode")
          Phone = LRs("Phone")
					Mobile = LRs("Mobile")
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


    JudoKorea_DBClose()
  
  End If
  
%>

<script type="text/javascript">

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Stadium_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./Stadium_List.asp', { 'i2': i2 });
  }

  function OK_Link() {

  	//alert('test');

  	if ($('#iSctNm').val() == "") {
  	  alert('도장명을 입력해 주세요.');
  	  return $('#iSctNm').focus();
  	}

  	if ($('#iDirector').val() == "") {
  		alert('관장명을 입력해 주세요.');
  		return $('#iDirector').focus();
  	}

  	if ($('#PostCode').val() == "") {
  		alert('주소를 입력해 주세요.');
  		return $('#PostCode').focus();
  	}

  	if ($('#UserAddr').val() == "") {
  		alert('주소를 입력해 주세요.');
  		return $('#PostCode').focus();
  	}

  	if ($('#UserAddrDtl').val() == "") {
  		alert('상세주소를 입력해 주세요.');
  		return $('#UserAddrDtl').focus();
  	}
  	

    // 스마트에디트 아닐때
    //var theForm = document.form1;
    //
    //if (theForm.iSctNm.value == "") {
    //  alert('도장명을 입력해 주세요.');
    //  return theForm.iSctNm.focus();
    //}
    //
    //if (theForm.iDirector.value == "") {
    //	alert('관장명을 입력해 주세요.');
    //	return theForm.iDirector.focus();
    //}
		//
    //if (theForm.PostCode.value == "") {
    //	alert('주소를 입력해 주세요.');
    //	return theForm.PostCode.focus();
    //}
		//
    //if (theForm.UserAddr.value == "") {
    //	alert('주소를 입력해 주세요.');
    //	return theForm.PostCode.focus();
    //}
		//
    //if (theForm.UserAddrDtl.value == "") {
    //	alert('상세주소를 입력해 주세요.');
    //	return theForm.UserAddrDtl.focus();
    //}
		//
    //if (theForm.iPhone.value == "") {
    //	alert('전화번호를 입력해 주세요.');
    //	return theForm.iPhone.focus();
    //}
		//
    //if (theForm.iMobile.value == "") {
    //	alert('핸드폰번호를 입력해 주세요.');
    //	return theForm.iMobile.focus();
    //}
    
  	var theForm = document.form1;

    if (confirm("해당 글을 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./Stadium_Write_p.asp";
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
			
      <form id="form1" name="form1" action="./Stadium_Write_p.asp" method="post">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">

					<tr>
            <th>도장명</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iSctNm" name="iSctNm" value="<%=SctNm %>" class="in_1"/>
							</span>
						</td>
					</tr>

					<tr>
            <th>관장명</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iDirector" name="iDirector" value="<%=Director %>"  class="in_1"/>
							</span>
						</td>
					</tr>

					<tr>
            <th>우편번호</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="PostCode" name="PostCode" value="<%=ZipCode %>" readonly class="in_1"/>
								<a href='javascript:;' onclick='javascript:execDaumPostcode();'>검색</a>
							</span>
						</td>
					</tr>

					<tr>
            <th>주소</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="UserAddr" name="UserAddr" value="<%=Address %>" readonly class="in_1"/>
							</span>
						</td>
					</tr>

					<tr>
            <th>주소상세</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="UserAddrDtl" name="UserAddrDtl" value="<%=AddrDtl %>" class="in_1"/>
							</span>
						</td>
					</tr>

					<tr>
            <th>전화번호</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iPhone" name="iPhone" value="<%=Phone %>"  class="in_1"/>
							</span>
						</td>
					</tr>

					<tr>
            <th>핸드폰번호</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iMobile" name="iMobile" value="<%=Mobile %>"  class="in_1"/>
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
					<input type="hidden" id="iName" name="iName" value="<%=Name %>" />
					<input type="hidden" id="iID" name="iID" value="<%=iLoginID %>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
					<input type="hidden" id="iSidoNm" name="iSidoNm" value="<%=SidoNm %>" />

				</div>
      </form>

		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>

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
                document.getElementById('iSidoNm').value = data.sido;
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