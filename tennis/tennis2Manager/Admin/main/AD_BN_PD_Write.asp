﻿<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "K003ACM"	
%>
<!--#include file="CheckRole.asp"-->

<%
	
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

	iDivision = fInject(Request("iDivision"))
	iSearchCol1 = fInject(Request("iSearchCol1"))

	iSportsGb = "tennis"

	viViewYN = fInject(Request("iViewYN"))

	viCateLocate1 = fInject(Request("iCateLocate1"))
	viCateLocate2 = fInject(Request("iCateLocate2"))
	viCateLocate3 = fInject(Request("iCateLocate3"))
	viCateLocate4 = fInject(Request("iCateLocate4"))

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  'Name = fInject(Request.cookies(global_HP)("UserName"))
	Name = fInject(Request.cookies("UserName"))

  'iLoginID = decode(fInject(Request.cookies(global_HP)("UserID")),0)
	iUserID = fInject(Request.cookies("UserID"))
	iUserID = decode(iUserID,0)
	iLoginID = iUserID

	PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

  ' 뷰 관련
  Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  LCnt = 0

  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt1, PSeq1, FileName1, FilePath1, ReplyYN
  LCnt1 = 0

  If iType = "2" Then

    iMSeq = fInject(Request("i1"))
    MSeq = decode(iMSeq,0)

		irType = "1"

    LSQL = "EXEC AD_tblADProductLocate_R '" & irType & "','" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon6.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      Do Until LRs.Eof
      
          LCnt = LCnt + 1
					CateLocate1 = LRs("CateLocate1")
          CateLocate2 = LRs("CateLocate2")
					CateLocate3 = LRs("CateLocate3")
					CateLocate4 = LRs("CateLocate4")
					DateProdS = LRs("DateProdS")
					DateProdE = LRs("DateProdE")
					Title = LRs("Title")
					txtMemo = LRs("txtMemo")
          LinkType = LRs("LinkType")
					Link = LRs("Link")
					ViewCnt = LRs("ViewCnt")
					TypeDiscount = LRs("TypeDiscount")
					DiscountValue = LRs("DiscountValue")
					txtWorker = LRs("txtWorker")
					ViewYN = LRs("ViewYN")

          PeriodType = LRs("PeriodType")
          defaultPayment = LRs("defaultPayment")
          TimeProdS = LRs("TimeProdS")
					TimeProdE = LRs("TimeProdE")

          Payment = LRs("Payment")
          LocateIDX = LRs("LocateIDX")
  
					ProductKeyCode = LRs("ProductKeyCode")
					ProductNm = LRs("ProductNm")
					Subject = LRs("Subject")
					ImgFileNm = LRs("ImgFileNm")
					ImageInfoIDX = LRs("ImageInfoIDX")
					eImageInfoIDX = encode(ImageInfoIDX,0)

          InsDateCv = LRs("InsDateCv")
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


    'If FileCnt <> "0" Then
		'
    '  LCnt1 = 0
		'
    '  LSQL = "EXEC Community_Board_Pds_R '" & MSeq & "'"
    '  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    '  'response.End
  	'
    '  Set LRs = DBCon6.Execute(LSQL)
		'
    '  If Not (LRs.Eof Or LRs.Bof) Then
		'
    '    Do Until LRs.Eof
		'
    '        LCnt1 = LCnt1 + 1
    '        PSeq1 = PSeq1&"^"&LRs("PSeq")&""
    '        FileName1 = FileName1&"^"&LRs("FileName")&""
    '        FilePath1 = FilePath1&"^"&LRs("FilePath")&""
		'
    '      LRs.MoveNext
    '    Loop
		'
    '  End If
  	'
    '  LRs.close
		'
    'End If
  
  End If
  
%>

<link href="../Css/jquery-ui.css" rel="stylesheet" />
<script src="../Js/jquery-ui.js" type="text/javascript"></script>
<script src="../Js/datepicker-ko.js" type="text/javascript"></script>

<link href="js/timepicker/jquery.ui.timepicker.css" rel="stylesheet" />
<script src="js/timepicker/jquery.ui.timepicker.js"></script>

<!--<script src="../dev/dist/se2_img/js/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>-->
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>

<style>
  input::placeholder {
    color: #ccc;
  }
  /* - Internet Explorer 10–11
   - Internet Explorer Mobile 10-11 */
  :-ms-input-placeholder {
    color: #ccc !important;
  }
</style>

<script type="text/javascript">

  $(function () {
    $('.timepicker').timepicker({
      //timeFormat: 'h:mm p',
      //interval: 60,
      //minTime: '10',
      //maxTime: '6:00pm',
      //defaultTime: '11',
      //startTime: '10:00',
      //dynamic: false,
      //dropdown: true,
      //scrollbar: true
      timeFormat: 'hh:mm'
    });
  });

  $("#iFile_1").on("change", function () {

    alert("test");

  });

  var selSearchValue1 = "";
  var txtSearchValue = "<%=iSearchText%>";
  var selSearchValue = "<%=iSearchCol%>";
  var selSearchValue2 = "";

  var selSearchValue3 = "<%=iDivision%>";
  var selSearchValue4 = "<%=iSearchCol1%>";

  var selSearchValue6 = "<%=viViewYN%>";

  var selSearchValue8 = "<%=viCateLocate1%>";
  var selSearchValue9 = "<%=viCateLocate2%>";
  var selSearchValue10 = "<%=viCateLocate3%>";
  var selSearchValue11 = "<%=viCateLocate4%>";

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  var iFileNum = 1;
  var iFileLimitDf = Number("<%=global_fileNum%>"); // 첨부파일 가능 갯수

  var iFileLimitNum = iFileLimitDf; // 수정시 파일 갯수에 따라 동적으로 변하는 값
  var iFileLimitNum1 = iFileLimitDf; // 변하지 않는 기본초기값.iFileLimitNum 과 같은 숫자를 적으면 됌.


  function FN_iFileDivP() {

    if (iFileNum < iFileLimitNum) {

      $('#FN_iFile_' + iFileNum).css('display', 'none');

      iFileNum = iFileNum + 1;

      var iHtmlPC = '';

      iHtmlPC = iHtmlPC + '<span id="sFile_' + iFileNum + '"><input type="file" id="iFile_' + iFileNum + '" name="iFile" class="csfile" onchange="javascript:Checkfiles_Img2(&#39;iFile_' + iFileNum + '&#39;);" /><span id="FN_iFile_' + iFileNum + '" class="btn_icon">&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivP();">+</a>&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivM(' + iFileNum + ');">-</a></span><br /></span>';

      iHtmlPC = iHtmlPC + '';

      $('#iFileDiv').append(iHtmlPC);

    }
    else {
      alert('현재 첨부 파일 추가는 ' + iFileLimitNum + '개 까지 만 가능 합니다.');
    }

  }

  function FN_iFileDivM(i1) {

    if (i1 == "1") {

      $('#iFile_1').val('');

    }
    else {

      //alert('iFile_' + i1);
      $('#sFile_' + iFileNum).remove();
      iFileNum = iFileNum - 1;
      $('#FN_iFile_' + iFileNum).css('display', '');

    }

  }

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
      post_to_url('./AD_BN_PD_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    //else {
    //
    //}
  }

  function CancelLink(i2) {
    post_to_url('./AD_BN_PD_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iViewYN': selSearchValue6, 'iCateLocate1': selSearchValue8, 'iCateLocate2': selSearchValue9, 'iCateLocate3': selSearchValue10, 'iCateLocate4': selSearchValue11 });
  }

  function OK_Link() {

    // 스마트에디트 아닐때
    //var theForm = document.form1;
    //
    //
    //if (theForm.iSubject.value == "") {
    //  alert('<%=global_Subject_Val %>');
    //  return theForm.iSubject.focus();
    //}
    //
    //if (confirm("해당 글을 저장 하시겠습니까?") == true) {
    //  try {
    //
    //    theForm.method = "post";
    //    theForm.target = "_self";
    //    theForm.action = "./Community_Photo_Write_p.asp";
    //    theForm.submit();
    //
    //  } catch (e) { }
    //}
    //else {
    //
    //}

    var theForm = document.form1;

    // 업로드파일갯수
    var filecnt = $('.csfile').length;
    //alert(filecnt);
    $('#iFilecnt').val(filecnt);

    // 스마트에디터 value 체크
    var elClickedObj = $("#form1");
    oEditors.getById["iContents"].exec("UPDATE_CONTENTS_FIELD", []);
    var iContents = $("#iContents").val();

    // 스마트에디터 공란인데 <p><br></p> 가 들어가서 빈값을 <p><br></p> 로 잡아야 함
    //alert(iContents);
    // 빈값에 태그가 들어가서 값을 빈값으로 변경해줌
    if (iContents == "<p><br></p>") {
      iContents = "";
    }

    if (theForm.iCateLocate1.value == "") {
      alert('대분류를 입력해 주세요.');
      return theForm.iCateLocate1.focus();
    }

    //if (theForm.iCateLocate2.value == "") {
    //	alert('중분류를 입력해 주세요.');
    //	return theForm.iCateLocate2.focus();
    //}
		//
    //if (theForm.iCateLocate3.value == "") {
    //	alert('소분류를 입력해 주세요.');
    //	return theForm.iCateLocate3.focus();
    //}

    if (theForm.iCateLocate4.value == "") {
      alert('광고순번을 입력해 주세요.');
      return theForm.iCateLocate4.focus();
    }

    if (theForm.iDateProdS.value == "") {
      alert('공지시작 일을 입력해 주세요.');
      return theForm.iDateProdS.focus();
    }
    
    if (theForm.iDateProdE.value == "") {
      alert('공지종료 일을 입력해 주세요.');
      return theForm.iDateProdE.focus();
    }

    if (theForm.hdimgselno.value == "") {
      alert('이미지 선택해 주세요.');
      return theForm.btnimgsel.focus();
    }

    if (theForm.iTitle.value == "") {
      alert('제목을 입력해 주세요.');
      return theForm.iTitle.focus();
    }

    //if (theForm.iLK.value == "") {
    //	alert('이동주소를 입력해 주세요.');
    //	return theForm.iLK.focus();
    //}

    // 첨부파일 1개 이상 있는지 체크 : S //
    //var iFID = "";
    //var iFIDYN = "";
		//
    //for (var i = 1; i < filecnt + 1; i++) {
		//
    //	iFID = "iFile_" + i;
		//
    //	iFIDYN = iFIDYN + document.getElementById('' + iFID + '').value;
		//
    //}
    //
    //if (iFIDYN == "") {
    //	alert('<%=global_File_Val %>');
    //	return
    //}
    // 첨부파일 1개 이상 있는지 체크 : E //

    
    //if (iContents == "") {
    //  alert('<%=global_Contents_Val %>');
    //  // 스마트에디터 포커스
    //  oEditors.getById["iContents"].exec("FOCUS");
    //  return
    //}

    // 스마트에디터 서브밋
    //try {
      elClickedObj.submit();
    //}
    //catch (e) {
    //  
    //}

  }

  function fn_w_CateLocate1(tvalue) {

    $('#iCateLocate2').html('<option value="">전체-중분류</option>');
    $('#iCateLocate3').html('<option value="">전체-소분류</option>');
    $('#iCateLocate4').html('<option value="">전체-광고순번</option>');

    var vCateLocate1 = tvalue;

    var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel1.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      async: false,
      data: {
        vCateLocate1: vCateLocate1
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iCateLocate2').html(retDATA);
          if (retDATA == '\r\n<option value=\"\">전체-중분류</option>\r\n') {

            fn_w_CateLocate4();

          }
        }
        else {
          $('#iCateLocate2').html("");
        }
      },
      error: function (xhr, status, error) {
        if (error != '') {
          alert("fn_w_CateLocate1 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        }
      }
  });

  }

  function fn_w_CateLocate2(tvalue1) {

    $('#iCateLocate3').html('<option value="">전체-소분류</option>');
    $('#iCateLocate4').html('<option value="">전체-광고순번</option>');

    var vCateLocate1 = $('#iCateLocate1').val();
    var vCateLocate2 = tvalue1;

    var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel2.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      async: false,
      data: {
        vCateLocate1: vCateLocate1,
        vCateLocate2: vCateLocate2
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iCateLocate3').html(retDATA);
          if (retDATA == '\r\n<option value=\"\">전체-소분류</option>\r\n') {

            fn_w_CateLocate4();

          }
        }
        else {
          $('#iCateLocate3').html("");
        }
      },
      error: function (xhr, status, error) {
        if (error != '') {
          alert("fn_w_CateLocate2 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        }
      }
    });

  }

  function fn_w_CateLocate3(tvalue2) {

    $('#iCateLocate4').html('<option value="">전체-광고순번</option>');

    var vCateLocate1 = $('#iCateLocate1').val();
    var vCateLocate2 = $('#iCateLocate2').val();
    var vCateLocate3 = tvalue2;

    var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel3.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      async: false,
      data: {
        vCateLocate1: vCateLocate1,
        vCateLocate2: vCateLocate2,
        vCateLocate3: vCateLocate3
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iCateLocate4').html(retDATA);
        }
        else {
          $('#iCateLocate4').html("");
        }
      },
      error: function (xhr, status, error) {
        if (error != '') {
          alert("fn_w_CateLocate3 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        }
      }
    });

  }

  function fn_w_CateLocate4() {

    var vCateLocate1 = $('#iCateLocate1').val();
    var vCateLocate2 = $('#iCateLocate2').val();

    var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel4.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      async: false,
      data: {
        vCateLocate1: vCateLocate1,
        vCateLocate2: vCateLocate2
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iCateLocate4').html(retDATA);
        }
        else {
          $('#iCateLocate4').html("");
        }
      },
      error: function (xhr, status, error) {
        if (error != '') {
          alert("fn_w_CateLocate4 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        }
      }
    });

  }

  function fn_imgpop() {

    var theForm = document.form1;
		
    if (theForm.iCateLocate1.value == "") {
      alert('대분류를 입력해 주세요.');
      return theForm.iCateLocate1.focus();
    }
		
    //if (theForm.iCateLocate2.value == "") {
    //	alert('중분류를 입력해 주세요.');
    //	return theForm.iCateLocate2.focus();
    //}
    //
    //if (theForm.iCateLocate3.value == "") {
    //	alert('소분류를 입력해 주세요.');
    //	return theForm.iCateLocate3.focus();
    //}

    if (theForm.iCateLocate4.value == "") {
      alert('광고순번을 입력해 주세요.');
      return theForm.iCateLocate4.focus();
    }

    var url = "./AD_BN_PD_Write_Pop.asp";
    var title = "imgpop1";
    var status = "toolbar=no,directories=no,scrollbars=yes,resizable=no,status=no,menubar=no,width=1100, height=850, top=50,left=20";
    
    var form = document.createElement("form");
    form.setAttribute("method", "post");
    form.setAttribute("action", url);
    form.setAttribute("target", title);
    
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = "piCateLocate1";
    input.value = $('#iCateLocate1').val();
    form.appendChild(input);
    
    input = document.createElement('input');
    input.type = 'hidden';
    input.name = "piCateLocate2";
    input.value = $('#iCateLocate2').val();
    form.appendChild(input);
    
    input = document.createElement('input');
    input.type = 'hidden';
    input.name = "piCateLocate3";
    input.value = $('#iCateLocate3').val();
    form.appendChild(input);
    
    input = document.createElement('input');
    input.type = 'hidden';
    input.name = "piCateLocate4";
    input.value = $('#iCateLocate4').val();
    form.appendChild(input);
    
    document.body.appendChild(form);
    
    //if (/Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor)) {
    //	window.open(url, title);
    //} else {
      window.open(url, title, status);
    //}
    
    form.submit();
    
    document.body.removeChild(form);

  }

  function fn_PeriodType(ipt,ilidx) {

    //alert(ipt + ', ' + ilidx);

    var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_Write_PeriodType.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      async: false,
      data: {
        iPeriodType: ipt,
        iLocateIDX: ilidx
      },
      success: function (retDATA) {
        if (retDATA) {
          //alert(retDATA);
          $('#iPayment').attr("placeholder",retDATA);
        }
        else {
          $('#iPayment').attr("placeholder","");
        }
      },
      error: function (xhr, status, error) {
        if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        }
      }
    });

  }

</script>

<section>
  <div id="content">

    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <div class="loaction">
          <strong>광고 관리</strong> &gt; 광고 연결 관리
        </div>
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./AD_BN_PD_Write_p.asp" method="post" ENCTYPE="multipart/form-data">

        <table cellspacing="0" cellpadding="0" class="table-list basic-table Community_wtite_box">

          <input type="hidden" id="selSearch1" name="selSearch1" value="" />

          <% if iType ="2" then %>
          <tr>
            <th>등록일</th>
            <td colspan="2">
              <span class="left_name">
                <span class="regist_date"><%=InsDateCv %></span><br />
              </span>
            </td>
          </tr>
          <% end if %>


					<tr>
            <th>분류</th>

            <td colspan="2">
              <span class="right_con">
								<select id="iCateLocate1" name="iCateLocate1" class="title_select" onchange="javascript:fn_w_CateLocate1(this.options[this.selectedIndex].value);" style="width:150px;">
									<%
									  ' 리스트 조회
									  iiType = "1"
										iiDivision = "1"
										iiSearchCol = "T"
										iiSearchText = ""
										iiSearchCol1 = "S2Y"
										iiCateLocate1 = ""

									  LSQL = "EXEC AD_tblADLocate_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iiType & "','" & iiDivision & "','" & iSportsGb & "','" & iiCateLocate1 & "','" & iCateLocate2 & "','" & iCateLocate3 & "','" & iCateLocate4 & "','" & iLocateGb & "','" & iViewYN & "','" & iiSearchCol & "','" & iiSearchText & "','" & iiSearchCol1 & "','','','','',''"
										'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
									  'response.End
  
									  Set LRs = DBCon6.Execute(LSQL)
									          
									  If Not (LRs.Eof Or LRs.Bof) Then
									%>
									<option value="">전체-대분류</option>
									<%
									    Do Until LRs.Eof
									%>
								  <option value="<%=LRs("CateLocate1") %>"><%=LRs("CateLocate1Nm") %></option>
									<%
									      LRs.MoveNext
									    Loop
									%>

									<%
									    Else
									%>
									<option value="">대분류없음</option>
									<%
									  End If
  
									  LRs.close
									%>
								</select>
							</span>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="right_con">
								<select id="iCateLocate2" name="iCateLocate2" class="title_select" onchange="javascript:fn_w_CateLocate2(this.options[this.selectedIndex].value);" style="width:150px;">
									<option value="">전체-중분류</option>
								</select>
							</span>
							&nbsp;&nbsp;&nbsp;&nbsp
							<span class="right_con">
								<select id="iCateLocate3" name="iCateLocate3" class="title_select" onchange="javascript:fn_w_CateLocate3(this.options[this.selectedIndex].value);" style="width:150px;">
									<option value="">전체-소분류</option>
								</select>
							</span>
							&nbsp;&nbsp;&nbsp;&nbsp
							<span class="right_con">
								<select id="iCateLocate4" name="iCateLocate4" class="title_select" style="width:130px;">
									<option value="">전체-광고순번</option>
								</select>
							</span>

            </td>

          </tr>
					
          <tr>
            <th>공지기간</th>
            <td colspan="2">
              <input type="text" id="iDateProdS" name="iDateProdS" class="date_ipt in_3" value="<%=DateProdS%>" readonly style="width:150px;" />&nbsp;<input type="text" readonly id="iTimeProdS" name="iTimeProdS" class='timepicker' style="width:150px;" value="<%=TimeProdS%>">&nbsp;&nbsp;~&nbsp;&nbsp;<input type="text" readonly id="iDateProdE" name="iDateProdE" class="date_ipt in_3" value="<%=DateProdE%>" style="width:150px;" />&nbsp;<input type="text" id="iTimeProdE" name="iTimeProdE" readonly class='timepicker' style="width:150px;" value="<%=TimeProdE%>">&nbsp;
              <select id="iPeriodType" name="iPeriodType" class="title_select" style="width:150px;" onchange="javascript:fn_PeriodType(this.options[this.selectedIndex].value,'<%=LocateIDX %>');">
							  <option value="W"<% if PeriodType = "W" then  %>selected<% end if %>>주간</option>
							  <option value="M"<% if PeriodType = "M" then  %>selected<% end if %>>월간</option>
                <option value="Y"<% if PeriodType = "Y" then  %>selected<% end if %>>년간</option>
							</select>
            </td>
          </tr>

					<tr>
            <th>이미지 선택</th>
            <td colspan="2">
							<span class="btn_right">
								<input type="button" id="btnimgsel" name="btnimgsel" class="btn_confirm" value="이미지 선택 팝업" onclick="javascript: fn_imgpop();" style="cursor:pointer" />
              </span>
							&nbsp;&nbsp;&nbsp;&nbsp
              <span class="right_con" id="imgsel">
                <%=Subject %><% if ImgFileNm <> "" then %>(<%=ImgFileNm %>)<% end if %>
              </span>
							<span class="right_con"><input type="hidden" id="hdimgselno" name="hdimgselno" value="<%=eImageInfoIDX %>" /></span>
            </td>
          </tr>

					<tr>
            <th>제목</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iTitle" name="iTitle" value="<%=Title %>" class="in_1"/>
              </span>
            </td>
          </tr>

					<tr>
            <th>메모사항</th>
            <td colspan="2">
              <span>
                <input type="text" id="itxtMemo" name="itxtMemo" value="<%=txtMemo %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr>
            <th>실이동타입</th>
            <td colspan="2">
              <span class="right_con">
                <select id="iLKType" name="iLKType" class="title_select" style="width:150px;">
								  <option value="1"<% if LinkType = "1" then  %>selected<% end if %>>현창 주소이동</option>
								  <option value="2"<% if LinkType = "2" then  %>selected<% end if %>>새창 주소이동</option>
								</select>
              </span>
            </td>
          </tr>

					<tr>
            <th>실이동주소</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iLK" name="iLK" value="<%=Link %>" class="in_1" />
              </span>
            </td>
          </tr>

					<tr>
            <th>상품-코드</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iProductKeyCode" name="iProductKeyCode" value="<%=ProductKeyCode %>" class="in_1" />
              </span>
            </td>
          </tr>

					<tr>
            <th>상품-이름</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iProductNm" name="iProductNm" value="<%=ProductNm %>" class="in_1" />
              </span>
            </td>
          </tr>

					<tr>
            <th>상품-할인구분</th>
            <td colspan="2">
              <span class="right_con">
                <select id="iTypeDiscount" name="iTypeDiscount" class="title_select">
									<option value="W"<% if TypeDiscount = "W" then %> selected<% end if %>>금액</option>
									<option value="P"<% if TypeDiscount = "P" then %> selected<% end if %>>퍼센트</option>
								</select>
              </span>
            </td>
          </tr>

					<tr>
            <th>상품-할인비용</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iDiscountValue" name="iDiscountValue" value="<%=DiscountValue %>" class="in_1" />
              </span>
            </td>
          </tr>

					<tr>
            <th>상품-담당자</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="itxtWorker" name="itxtWorker" value="<%=txtWorker %>" class="in_1" />
              </span>
            </td>
          </tr>

          <tr>
            <th>계약금액</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iPayment" name="iPayment" value="<%=Payment %>" placeholder="<%=defaultPayment %>" class="in_1" />
              </span>
            </td>
          </tr>

					<tr>
            <th>사용유무</th>
            <td colspan="2">
              <span class="right_con">
                <select id="iViewYN" name="iViewYN" class="title_select">
								  <option value="Y"<% if ViewYN = "Y" then  %>selected<% end if %>>사용중</option>
								  <option value="N"<% if ViewYN = "N" then  %>selected<% end if %>>미사용</option>
								</select>
              </span>
            </td>
          </tr>

          <tr style="display:none;">
            <th>파일</th>
            <td>
              <span class="right_con">
                <div id="iFileDiv" name="iFileDiv">
                  <span id="sFile_1"><!--<input type="file" id="iFile_1" name="iFile" class="csfile" onchange="readURL(this);" />-->
										<input type="file" id="iFile_1" name="iFile" class="csfile" onchange="javascript:FileUp();" />
                    <!--<span id="FN_iFile_1" class="btn_icon">&nbsp;
                      <a href="javascript:;" onclick="javascript:FN_iFileDivP();">+</a>&nbsp;
                      <a href="javascript:;" class="btn_file_del" onclick="javascript:FN_iFileDivM(1);">-</a>
                    </span><br />-->
                  </span>
                </div>
              </span>
            </td>
						<td id="hddis" style="display:none;">
              <span class="right_con">
                <img id="blah" src="#" alt="your image" />
								<input type="hidden" id="blah1" name="blah1" value="1" />
              </span>
            </td>
          </tr>

					<!--<tr>
            <th>동영상추가</th>
            <td colspan="2">
              <span class="right_con">
								<a href="javascript:;" onclick="javascript:MovieUp();">동영상추가</a>
              </span>
            </td>
          </tr>-->

          <tr style="display:none;">
            <th>내용</th>
            <td colspan="2">
              <span class="right_con edit_box">
                <textarea name="iContents" id="iContents" rows="10" cols="100">.</textarea>
              </span>
            </td>
          </tr>

					<!-- 공지유무 -->
          <!--<input type="hidden" id="selSearch2" name="selSearch2" value="N" />-->
					<!--<tr>
            <th>메인페이지 노출 <br>
              유/무</th>
						<td colspan="2">
							<span class="right_con">
								<select id="selSearch2" name="selSearch2" class="title_select">
									<option value="Y">Y</option>
									<option value="N" selected>N</option>
								</select>
							</span>
              <span class="existence">※메인페이지 노출은 최상위 <%'=global_MainTNewsCnt %>개만 노출됩니다.</span>
						</td>
					</tr>-->

        </table>
        <div class="btn_list">
          <input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="목록" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />
          <div class="btn_right">
            <input type="button" id="btnDel" name="btnDel" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
            <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
          </div>
          <input type="hidden" id="iMSeq" name="iMSeq" value="<%=iMSeq %>" />
          <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
          <input type="hidden" id="iName" name="iName" value="<%=Name %>" />
          <input type="hidden" id="iID" name="iID" value="<%=iLoginID %>" />
          <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
          <input type="hidden" id="iFilecnt" name="iFilecnt" value="0" />
        </div>
			</form>
    </div>
    <!-- E : 내용 시작 -->
  </div>
<section>

<script type="text/javascript">

  // 스마트 에디터 사용시 제일 아래에 해당 코드를 넣어야 반영 됀다.

  var oEditors = [];

  nhn.husky.EZCreator.createInIFrame({

    oAppRef: oEditors,

    elPlaceHolder: "iContents",

    //sSkinURI: "../dev/dist/se2_img/SmartEditor2Skin.html",
    sSkinURI: "../dev/dist/se2/SmartEditor2Skin.html",

    fCreator: "createSEditor2"

  });


  // 첨부파일 관련

  var LCnt1 = Number("<%=LCnt1%>");
  //alert(LCnt1);

  var PSeq1 = "<%=PSeq1%>";
  var FileName1 = "<%=FileName1%>";
  var FilePath1 = "<%=FilePath1%>";

  var PSeq1arr = PSeq1.split("^");
  var FileName1arr = FileName1.split("^");
  var FilePath1arr = FilePath1.split("^");

  function FileUp() {

    var ImgChkExt = Checkfiles_Img1('iFile_1');

    var ImgChkLength = CheckFiles_Size1('iFile_1');

    if (ImgChkExt == "N" || ImgChkLength == "N") {
      return;
    }
    else {

      var strAjaxUrl = "../dev/dist/CommonFileImgUp.asp";

      var formData = new FormData();
      formData.append("iFile", $("input[name=iFile]")[0].files[0]);

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        processData: false,
        contentType: false,
        data: formData,
        success: function (retDATA) {
      
          //alert(retDATA);
      
          if (retDATA != "") {
      
            insertIMG2(retDATA);
      
          } else {
      
            alert("이미지 업로드에 실패 했습니다.");
      
          }
      
        },
        error: function (xhr, status, error) {
          if (error != "") { alert("에러발생 - 시스템관리자에게 문의하십시오!"); return; }
        }
      });

    }

  }

  function MovieUp() {

    insertMovie2('HatQmVJ5Uew');

  }

  function FileDel(i4, i5, i6) {

    if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {

      //alert(i4 + ", " + i5 + " , " + i6);

      // i7 : 1 - 커뮤니티>공지사항,KATA뉴스,자유게시판,신문고
      var strAjaxUrl = "../dev/dist/CommonFileDelete.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          i4: i4,
          i5: i5,
          i6: i6,
          i7: "1"
        },
        success: function (retDATA) {
      
          //alert(retDATA);
      
          if (retDATA == "1") {
      
            alert("해당 파일이 삭제 됐습니다.");
            $('#fileid_' + i4).remove();
          } else {
      
            alert("해당 파일이 없습니다.");
            $('#fileid_' + i4).remove();
          }
      
          // 파일 삭제 해서 총 파일수 -1
          LCnt1 = LCnt1 - 1;
      
          // 파일추가부분이 총파일수 보다 커야 보이게
          if (LCnt1 < iFileLimitNum1) {
      
            $('#sFile_1').css('display', '');
      
            // 파일추가부분도 파일 갯수에 따라 가변적으로 iFileLimitNum1 은 변하지 않는 기본초기값
            iFileLimitNum = iFileLimitNum1 - LCnt1;
      
          }
      
        }, error: function (xhr, status, error) {
          if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
        }
      });

    }
    else {
      return;
    }

  }

  function FileDown(i3) {

    //window.open("<%=global_depth %>/FileDown/" + i3, "_blank");
    //window.open("<%=global_depth %>/dev/dist/dl.asp?FileName=" + i3);
    location.href = "../dev/dist/dl.asp?FileName=" + i3;

  }

  function FN_FileList(i1) {

    var iHtmlPC1 = '<table>';
    
    for (var i = 1; i < i1 + 1; i++) {

      iHtmlPC1 = iHtmlPC1 + '<tr id=fileid_' + PSeq1arr[i] + '>';
      //iHtmlPC1 = iHtmlPC1 + ' <td><a href="javsdcript:;" onClick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;)">' + FileName1arr[i] + '</a></td>';
      //iHtmlPC1 = iHtmlPC1 + ' <td><a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a></td>';
      iHtmlPC1 = iHtmlPC1 + ' <td><a href="javascript:;" onclick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;);">' + FileName1arr[i] + '</a></td>';
      iHtmlPC1 = iHtmlPC1 + ' <td><a href="javascript:;" onClick="javascript:FileDel(&#39;' + PSeq1arr[i] + '&#39;,&#39;' + FileName1arr[i] + '&#39;,&#39;' + iMSeq + '&#39;)" class="ex_btn">X</a></td>';
      iHtmlPC1 = iHtmlPC1 + '</tr>';

    }

    iHtmlPC1 = iHtmlPC1 + '</table>';

    $('#iFileDiv').prepend(iHtmlPC1);
    //alert(iHtmlPC1);

  }

  // 파일갯수가 파일제한보다 많을땐 파일추가 부분 삭제
  if (LCnt1 >= iFileLimitNum) {

    //$('#sFile_1').remove();
    $('#sFile_1').css('display', 'none');

    FN_FileList(LCnt1);

  }
  else {

    FN_FileList(LCnt1);
    iFileLimitNum = iFileLimitNum1 - LCnt1;

  }
  
  var iType = Number("<%=iType%>");
  var iSubType = "<%=SubType%>";
  var iNoticeYN = "<%=NoticeYN%>";

  var ieCateLocate1 = "<%=CateLocate1%>";
  var ieCateLocate2 = "<%=CateLocate2%>";
  var ieCateLocate3 = "<%=CateLocate3%>";
  var ieCateLocate4 = "<%=CateLocate4%>";

  if (iType == 2) {
    $("#selSearch1").val(iSubType);
    $("#selSearch2").val(iNoticeYN);

    fn_w_CateLocate1(ieCateLocate1);
    $("#iCateLocate1").val(ieCateLocate1);

    fn_w_CateLocate2(ieCateLocate2);
    $("#iCateLocate2").val(ieCateLocate2);

    fn_w_CateLocate3(ieCateLocate3);
    $("#iCateLocate3").val(ieCateLocate3);

    fn_w_CateLocate4();
    $("#iCateLocate4").val(ieCateLocate4);
  }
  
  $(function () {

    $('#iDateProdS').datepicker({
      changeMonth: true,
      changeYear: true,
      dateFormat: "yy-mm-dd"
    });
    
    $('#iDateProdE').datepicker({
      changeMonth: true,
      changeYear: true,
      dateFormat: "yy-mm-dd"
    });

  });

</script>
<% AD_DBClose() %>
