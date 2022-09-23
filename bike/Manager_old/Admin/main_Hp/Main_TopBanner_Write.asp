<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->

<%

  iSubType = fInject(Request("iSubType"))
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))
  iNoticeYN = fInject(Request("iNoticeYN"))

  iDivision = fInject(Request("iDivision"))
  iSearchCol1 = fInject(Request("iSearchCol1"))

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  'Name = fInject(Request.cookies(global_HP)("UserName"))
  Name = fInject(Request.cookies("UserName"))

  'iLoginID = decode(fInject(Request.cookies(global_HP)("UserID")),0)
  iUserID = fInject(Request.cookies("UserID"))
  iLoginID = decode(iUserID,0)

  ' 뷰 관련
  Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  LCnt = 0

  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt1, PSeq1, FileName1, FilePath1, ReplyYN
  LCnt1 = 0

  If iType = "2" Then

    iMSeq = fInject(Request("i1"))
    MSeq = crypt.DecryptStringENC(iMSeq)

    LSQL = "EXEC Community_Board_R '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      Do Until LRs.Eof
      
          LCnt = LCnt + 1
          Subject = LRs("Subject")
          SubTypeName = LRs("SubTypeName")
          SubType = LRs("SubType")
          Contents = LRs("Contents")
          ReplyYN = LRs("ReplyYN")
          NoticeYN = LRs("NoticeYN")
          InsDateCv = LRs("InsDateCv")
          FileYN = LRs("FileYN")
          FileCnt = LRs("FileCnt")
          LoginIDYN = LRs("LoginIDYN")
					StartDate = LRs("StartDate")
          EndDate = LRs("EndDate")
          DefaultYN = LRs("DefaultYN")
					LinkHref = LRs("LinkHref")
					BColor = LRs("BColor")

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


    If FileCnt <> "0" Then

      LCnt1 = 0

      LSQL = "EXEC Community_Board_Pds_R '" & MSeq & "'"
      'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End
  
      Set LRs = DBCon.Execute(LSQL)

      If Not (LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof

            LCnt1 = LCnt1 + 1
            PSeq1 = PSeq1&"^"&LRs("PSeq")&""
            FileName1 = FileName1&"^"&LRs("FileName")&""
            FilePath1 = FilePath1&"^"&LRs("FilePath")&""

          LRs.MoveNext
        Loop

      End If
  
      LRs.close

    End If

    'DBClose()
  
  End If
  
%>

<script src="../js/jscolor.js"></script>
<!--<script src="../dev/dist/se2_img/js/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>-->
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>


<script type="text/javascript">
  /**
   * left-menu 체크
   */
	var locationStr = "Main_TopBanner_List"; // 배너관리
  /* left-menu 체크 */


  $("#iFile_1").on("change", function () {

    alert("test");

  });

  var selSearchValue1 = "<%=iSubType%>"
  var txtSearchValue = "<%=iSearchText%>"
  var selSearchValue = "<%=iSearchCol%>"
  var selSearchValue2 = "<%=iNoticeYN%>"

  var selSearchValue3 = "<%=iDivision%>";
  var selSearchValue4 = "<%=iSearchCol1%>";

  var iType = Number("<%=iType%>");
  var iMSeq = "<%=iMSeq%>";

  var iFileNum = 1;
  var iFileLimitDf = Number("<%=global_fileNum%>"); // 첨부파일 가능 갯수
  iFileLimitDf = 1;

  var iFileLimitNum = iFileLimitDf; // 수정시 파일 갯수에 따라 동적으로 변하는 값
  var iFileLimitNum1 = iFileLimitDf; // 변하지 않는 기본초기값.iFileLimitNum 과 같은 숫자를 적으면 됌.


  function FN_iFileDivP() {

    if (iFileNum < iFileLimitNum) {

      $('#FN_iFile_' + iFileNum).css('display', 'none');

      iFileNum = iFileNum + 1;

      var iHtmlPC = '';

      iHtmlPC = iHtmlPC + '<span id="sFile_' + iFileNum + '"><input type="file" id="iFile_' + iFileNum + '" name="iFile" class="csfile" onchange="javascript:Checkfiles_Img2(&#39;iFile_' + iFileNum + '&#39;);" /><span id="FN_iFile_' + iFileNum + '" class="added-list">&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivP();" class="btn"><i class="fas fa-plus"></i></a>&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivM(' + iFileNum + ');" class="btn btn_file_del"><i class="fas fa-minus"></i></a></span></span>';

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
    	post_to_url('./Main_TopBanner_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./Main_TopBanner_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
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

    if (theForm.iSubject.value == "") {
      alert('<%=global_Subject_Val %>');
      return theForm.iSubject.focus();
    }


    // 첨부파일 1개 이상 있는지 체크 : S //
    //var iFID = "";
    //var iFIDYN = "";
    //
    //for (var i = 1; i < filecnt + 1; i++) {
    //
    //  iFID = "iFile_" + i;
    //
    //  iFIDYN = iFIDYN + document.getElementById('' + iFID + '').value;
    //
    //}
    //
    //if (iFIDYN == "") {
    //  alert('<%=global_File_Val %>');
    //  return
    //}
    // 첨부파일 1개 이상 있는지 체크 : E //

    
    if (iContents == "") {
      alert('<%=global_Contents_Val %>');
      // 스마트에디터 포커스
      oEditors.getById["iContents"].exec("FOCUS");
      return
    }

    // 스마트에디터 서브밋
    try {
      elClickedObj.submit();
    } catch (e) { }

  }

  // S : 리플 관련
  var hdieRSeq2i = "";
  var LCnt2i = "";

  var iContentsNo = "";

  function Reply_Link(i1, i2, i3, i4) {
    // 1:Insert 2:Mod
    //alert("iMSeq :" + i1 + "  " + "NowPage : " + i2 + "  " + "eRSeq2 : " + i4);
    if (i3 == "2") {

      //alert(hdieRSeq2i);
      var hdieRSeq2iarr = hdieRSeq2i.split("^");

      for (var i = 1; i < Number(LCnt2i) + 1; i++) {
        //alert(hdieRSeq2iarr[i]);
        if (hdieRSeq2iarr[i] == i4) {

        }
        else {
          $('#sp1_' + hdieRSeq2iarr[i]).css('display', 'none');       //수정, 삭제 버튼 none
        }
      }

      var iContents = $("#txtContents_" + i4).html();

      iContentsNo = iContents;
      //iContents = iContents.replace(/<br>/g, "");

      //cnt_ i4 영억에 textarea Tag와 데이터를 넣고 

      var iHtmlcnt = '<textarea name="txtContents" id="txtContents_' + i4 + '" rows="4" cols="130">' + iContents + '</textarea>';
      $('#cnt_' + i4).html(iHtmlcnt);

      $('#sp1_' + i4).css('display', 'none');       //수정, 삭제 버튼 none
      $('#spiContentsMain').css('display', 'none'); //textArea와  입력하기 버튼을 묶은 span None
      $('#sp2_' + i4).css('display', 'block')        //입력 버튼 block
    }
  }

  function No_Link(i4) {

  	var iHtmlcnt = iContentsNo;
  	iHtmlcnt = '<textarea name="txtContents_' + i4 + '" id="txtContents_' + i4 + '" rows="4" cols="130" readonly="readonly">' + iContentsNo + '</textarea>';

    var hdieRSeq2iarr = hdieRSeq2i.split("^");

    for (var i = 1; i < Number(LCnt2i) + 1; i++) {
      //alert(hdieRSeq2iarr[i]);
      if (hdieRSeq2iarr[i] == i4) {

      }
      else {
        $('#sp1_' + hdieRSeq2iarr[i]).css('display', 'block');       //수정, 삭제 버튼 none
      }
    }

    $('#cnt_' + i4).html(iHtmlcnt);
    //$('#sp1_' + i4).css('display', 'block');
    $('#sp1_' + i4).css('display', 'block');              //수정, 삭제 버튼 block
    $('#spiContentsMain').css('display', 'block');        //textArea와  입력하기 버튼을 묶은 block None
    $('#sp2_' + i4).css('display', 'none'); //저장 취소   //입력 버튼 None
  }

  function CommentSave_Link(i1, i2, i3, i4) {

  	var iContentsNo = $('#txtContents_' + i4).val();

    if (i3 == "1") {

      var documentForm = document.commentForm;

      $('#iiMSeq').val(i1);
      $('#iiNowPage').val(i2);
      $('#iiType').val(i3);
      $('#iiRSeq').val(i4);

      if (documentForm.iContentsMain.value == "") {
        alert('<%=global_Contents_Val %>');
        return documentForm.iContentsMain.focus();
      }
      if (confirm("해당 글을 저장 하시겠습니까?") == true) {
        try {
          documentForm.method = "post";
          documentForm.target = "_self";
          documentForm.action = "./Main_TopBanner_Reply_p.asp";
          documentForm.submit();
        } catch (e) { }
      }
      else {
      }
    }
    else {

      var documentForm = document.commentForm;

      $('#iiMSeq').val(i1);
      $('#iiNowPage').val(i2);
      $('#iiType').val(i3);
      $('#iiRSeq').val(i4);

      var ivaltc = $('#txtContents_' + i4).val();

      if (ivaltc == "") {
      	alert('<%=global_Contents_Val %>');
      	return $('#txtContents_' + i4).focus();
      }

      //if (documentForm.txtContents + i4.value == "") {
      //  alert('<%=global_Contents_Val %>');
      //  return documentForm.txtContents + i4.focus();
      //}

      try {
        documentForm.method = "post";
        documentForm.target = "_self";
        documentForm.action = "./Main_TopBanner_Reply_p.asp";
        documentForm.submit();
      } catch (e) { }
    }
  }

  function ReplyDel_Link(i1, i2, i3, i4) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Main_TopBanner_Reply_Delete_p.asp', { 'i1': i1, 'i2': i2, 'i3': i3, 'i4': i4 });
    }
    else {
    }
  }
  // E : 리플 관련

</script>

  <div id="content" class="qna_write">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>상단 배너관리 등록/수정</h2>
      <a href="./Main_TopBanner_List.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>홈페이지관리</li>
          <li>메인</li>
          <li><a href="./Main_TopBanner_List.asp">상단 배너관리</a></li>
          <li><a href="./Main_TopBanner_Write.asp">상단 배너관리 등록/수정</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->

    </div>
    <!-- E: page_title -->

    <!-- S : 내용 시작 -->
      <form id="form1" name="form1" action="./Main_TopBanner_Write_p.asp" method="post" ENCTYPE="multipart/form-data">
        <table class="left-head view-table">

          <input type="hidden" id="selSearch1" name="selSearch1" value="" />

          <% if iType ="2" then %>
          <tr>
            <th>등록일</th>
            <td>
              <span class="left_name">
                <span class="regist_date"><%=InsDateCv %></span><br />
              </span>
            </td>
          </tr>
          <% end if %>

          <tr class="half-line">
            <th>제목</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iSubject" name="iSubject" value="<%=Subject %>" />
              </span>
            </td>
          </tr>

					<tr>
						<th>공지기간</th>
						<td colspan="2">
								<span class="con"><input type="text" id="iStartDate" name="iStartDate" class="date_ipt in_3" value="<%=StartDate%>" /></span>&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;<span class="con"><input type="text" id="iEndDate" name="iEndDate" class="date_ipt in_3" value="<%=EndDate%>" /></span>
						</td>
					</tr>

          <tr class="file-line">
            <th>파일</th>
            <td colspan="2">
              <span>
                <div id="iFileDiv" name="iFileDiv">
                  <span id="sFile_1">
                    <!--<input type="file" id="iFile_1" name="iFile" class="csfile" onchange="readURL(this);" />-->
                    <!--<input type="file" id="iFile_1" name="iFile" class="csfile" onchange="javascript:FileUp();" />-->
                    <!--<input type="file" id="iFile_1" name="iFile" class="csfile" onchange="javascript:Checkfiles_Img('iFile_1');" />-->
                    <input type="file" id="iFile_1" name="iFile" class="csfile">
                    <span id="FN_iFile_1" class="added-list" style="display:none;">
                      <a href="javascript:;" onclick="javascript:FN_iFileDivP();" class="btn">
                        <i class="fas fa-plus"></i>
                      </a>
                      <a href="javascript:;" class="btn btn_file_del" onclick="javascript:FN_iFileDivM(1);">
                        <i class="fas fa-minus"></i>
                      </a>
                    </span>
                  </span>
                </div>
              </span>
            </td>
            <td id="hddis" style="display:none;">
              <span class="right_con">
                <img id="blah" src="javascript:;" alt="your image" />
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

					<tr>
            <th>링크주소</th>
            <td colspan="2">
							<input type="text" id="iLH" name="iLH" value="<%=LinkHref %>" />
            </td>
          </tr>

					<tr>
            <th>배경색</th>
            <td colspan="2">
							<input type="text" id="iBC" name="iBC" readonly class="jscolor" value="<%=BColor %>" />
            </td>
          </tr>

          <tr style="display:none;">
            <th>내용</th>
            <td colspan="2">
              <span class="right_con edit_box">
                <textarea name="iContents" id="iContents" rows="10" cols="100">N</textarea>
              </span>
            </td>
          </tr>

					<% if iType ="2" then %>
					<tr>
            <th>기본배너</th>
            <td colspan="2">
              <span class="con">
                <select id="iDB" name="iDB" class="title_select">
                  <option value="Y">Y</option>
                  <option value="N" selected>N</option>
                </select>
              </span>
              <span class="guide-txt">※기본배너는 1 개만 유지 됩니다.</span>
            </td>
          </tr>
					<% else %>
					<input type="hidden" id="iDB" name="iDB" value="N" />
					<% end if %>

          <!-- 공지유무 -->
          <input type="hidden" id="selSearch2" name="selSearch2" value="N" />
          <!--<tr>
            <th>공지 유/무</th>
            <td colspan="2">
              <span class="right_con">
                <select id="selSearch2" name="selSearch2" class="title_select">
                  <option value="Y">Y</option>
                  <option value="N" selected>N</option>
                </select>
              </span>
              <span class="existence">※공지는 최상위 <%'=global_MainTNewsCnt %>개만 상단에 노출됩니다.</span>
            </td>
          </tr>-->

        </table>

        <!-- S: btn-list-right -->
        <div class="btn-list-right">
          <input type="button" id="btnDel" name="btnDel" class="btn btn-red" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
          <input type="button" id="btnOK" name="btnOK" class="btn btn-confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
          <input type="button" id="btnCC" name="btnCC" class="btn btn-cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />
          
          <input type="hidden" id="iMSeq" name="iMSeq" value="<%=iMSeq %>" />
          <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
          <input type="hidden" id="iName" name="iName" value="<%=Name %>" />
          <input type="hidden" id="iID" name="iID" value="<%=iLoginID %>" />
          <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
          <input type="hidden" id="iFilecnt" name="iFilecnt" value="0" />
          <input type="hidden" id="iDivision" name="iDivision" value="<%=iDivision %>" />
        </div>
        <!-- E: btn-list-right -->

      </form>

      <!-- S: reply-wrap 리플영역 -->
      <div class="reply-wrap" id="divRP" style="display:none;">
        <form id="commentForm" name="commentForm">
          <p class="reply-number" id="reply_number" name="reply_number">답변 0개</p>
          <ul class="reply_list">
            <%
              Dim LCnt2        ' 데이터 행 개수
              Dim MSeq2, RSeq2 ' 게시물 고유 아이디, 리플 고유 아이디
              Dim Name2        ' 작성자 이름
              Dim Contents2    ' 내용
              Dim InsDateCv2   ' 작성날짜
              Dim LoginIDYN2   ' 로그인된 여부
              Dim eRSeq2       ' Rseq2 복호화 데이터
              LCnt2 = 0
              RSeq2 = "" '리플 고유 번호는 왜 필요할까?

                'NowPage  :현재 페이지
                'MSeq     :게시글 번호
                'iLoginID :로그인 아이디
                'RSeq2    :리플 고유 번호

              if ReplyYN = "Y" then

                irType = "1"
                ieRSeq2 = ""

                LSQL = "EXEC Community_Board_Reply_S '" & irType & "','" & NowPage & "','" & MSeq & "','" & iLoginID & "','" & RSeq2 & "','','','','',''"

                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                'response.End

                Set LRs = DBCon.Execute(LSQL)

                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                      LCnt2 = LCnt2 + 1
                      RSeq2 = LRs("RSeq")
                      MSeq2 = LRs("MSeq")
                      Name2 = LRs("Name")
                      Contents2 = ReHtmlSpecialChars(LRs("Contents"))
                      Contents2 = Replace(Contents2, chr(13), "<BR>")
                      InsDateCv2 = LRs("InsDateCv")
                      LoginIDYN2 = LRs("LoginIDYN")
                      eRSeq2 = crypt.EncryptStringENC(RSeq2)
                      ieRSeq2 = ieRSeq2&"^"&eRSeq2
            %>
              <li>
                <p class="tit"><strong><%=Name2 %></strong> <span><%=InsDateCv2%></span></p>
                <!--<p class="txt"><%=Contents2 %><br /></p>-->
                <span id="cnt_<%=eRSeq2 %>"><textarea name="txtContents_<%=eRSeq2 %>" id="txtContents_<%=eRSeq2 %>" rows="4" cols="130" readonly="readonly"><%=Replace(Contents2,"<BR>","") %></textarea></span>
                <% If LoginIDYN2 = "Y" Then %>
                <p  id="sp1_<%=eRSeq2 %>" class="btn-reply">
                  <a href="javascript:;" class="btn btn-blue-empty" onClick="javascript:Reply_Link('<%=iMSeq %>','<%=NowPage %>','2','<%=eRSeq2 %>');">수정</a>
                  <a href="javascript:;" class="btn btn-red" onClick="javascript:ReplyDel_Link('<%=iMSeq %>','<%=NowPage %>','2','<%=eRSeq2 %>');">삭제</a>
                </p>
                <p  id="sp2_<%=eRSeq2 %>" class="btn-reply" style="display:none;">
                  <a href="javascript:;" class="btn btn-confirm" onClick="javascript:CommentSave_Link('<%=iMSeq %>','<%=NowPage %>','2','<%=eRSeq2 %>');">저장</a>
                  <a href="javascript:;" class="btn btn-cancel" onClick="javascript:No_Link('<%=eRSeq2 %>');">취소</a> </p>
                <% End IF %>
              </li>
            <%
                  LRs.MoveNext
                  Loop
                End IF
                LRs.close
              End IF

              DBClose()

            %>
            <li class="last">
							<span id="spiContentsMain">
								<!-- <p class="tit"><strong><%=iName %></strong></p> -->
								<textarea id="iContentsMain" name="iContentsMain" rows="4" cols="130"></textarea>
								<!-- S: btn-list-right -->
								<div class="btn-list-right">
									<a href="javascript:;" class="btn btn-basic" onclick="javascript:CommentSave_Link('<%=iMSeq %>','<%=NowPage %>','1','<%=eRSeq2 %>');">답변</a>
								</div>
							</span>
              <!-- E: btn-list-right -->
              <input type="hidden" id="iiMSeq" name="iiMSeq" value="" />
              <input type="hidden" id="iiNowPage" name="iiNowPage" value="" />
              <input type="hidden" id="iiType" name="iiType" value="" />
              <input type="hidden" id="iiRSeq" name="iiRSeq" value="" />
            </li>
          </ul>
        </form>
      </div>
      <!-- E: reply-wrap 리플영역 -->

    </div>
    <!-- E : content TopBanner_write -->


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


    // 리플 관련
    var hdieRSeq2 = "<%=ieRSeq2%>";
    hdieRSeq2i = hdieRSeq2;

    var LCnt2 = Number("<%=LCnt2%>");
    LCnt2i = LCnt2;

    if (LCnt2 > 0) {
      ($('#reply_number').html("답변 " + LCnt2 + "개"));
    }
    else {
      ($('#reply_number').html(""));
    }


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

        }, error: function (xhr, status, error) {
          if (error != "") { alert("에러발생 - 시스템관리자에게 문의하십시오!"); return; }
        }
      });

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
            i7: "1",
						i8: "TB"
          },
          success: function (retDATA) {
        
            //alert(retDATA);
        
            if (retDATA == "Y") {
        
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

      }

    }

    function FileDown(i3) {

      //window.open("<%=global_depth %>/FileDown/" + i3, "_blank");
      //window.open("<%=global_depth %>/dev/dist/dl.asp?FileName=" + i3);
    	location.href = "../dev/dist/dl.asp?FileName=" + i3 + "&FileDivision=TB";

    }

    function FN_FileList(i1) {

      var iHtmlPC1 = '<table>';
      
      for (var i = 1; i < i1 + 1; i++) {

        iHtmlPC1 = iHtmlPC1 + '<tr id=fileid_' + PSeq1arr[i] + '>';
        //iHtmlPC1 = iHtmlPC1 + ' <td><a href="javsdcript:;" onClick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;)">' + FileName1arr[i] + '</a></td>';
        //iHtmlPC1 = iHtmlPC1 + ' <td><a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a></td>';
        iHtmlPC1 = iHtmlPC1 + ' <td><a href="javascript:;" onclick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;);">' + FileName1arr[i] + '</a></td>';
        iHtmlPC1 = iHtmlPC1 + ' <td><a href="javascript:;" onClick="javascript:FileDel(&#39;' + PSeq1arr[i] + '&#39;,&#39;' + FileName1arr[i] + '&#39;,&#39;' + iMSeq + '&#39;)" class="btn btn-cancel">삭제</a></td>';
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
    var iDefaultYN = "<%=DefaultYN%>";

    if (iType == 2) {
      $("#selSearch1").val(iSubType);
      $("#selSearch2").val(iNoticeYN);
      $("#iDB").val(iDefaultYN);
    }
    
  </script>

<!--#include file="../include/footer.asp"-->

</html>