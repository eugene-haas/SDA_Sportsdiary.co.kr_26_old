<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
	RoleType = "K002IM"
%>
<!--#include file="CheckRole.asp"-->

<%

  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

	iDivision = fInject(Request("iDivision"))
	iSearchCol1 = fInject(Request("iSearchCol1"))

	iImageType = fInject(Request("iImageType"))
	iViewYN = fInject(Request("iViewYN"))
	iLocateGb = fInject(Request("iLocateGb"))

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  'Name = fInject(Request.cookies(global_HP)("UserName"))
	Name = fInject(Request.cookies("UserName"))

  'iLoginID = decode(fInject(Request.cookies(global_HP)("UserID")),0)
	iUserID = fInject(Request.cookies("UserID"))
	iUserID = decode(iUserID,0)
	iLoginID = iUserID

  ' 뷰 관련
  Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  LCnt = 0

  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt1, PSeq1, FileName1, FilePath1, ReplyYN
  LCnt1 = 0

  If iType = "2" Then

    iMSeq = fInject(Request("i1"))
    MSeq = decode(iMSeq,0)

		iFType	= "1"

    LSQL = "EXEC AD_tblADImageInfo_R '" & iFType & "','" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End

    Set LRs = DBCon6.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      Do Until LRs.Eof

          LCnt = LCnt + 1
					Subject = LRs("Subject")
					SportsGb = LRs("SportsGb")
					LocateGb = LRs("LocateGb")
					ImgURL = LRs("ImgURL")
					ImageType = LRs("ImageType")
					BColor = LRs("BColor")
					ViewYN = LRs("ViewYN")
					txtMemo = LRs("txtMemo")
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

		FileCnt = LCnt

    If FileCnt <> "0" Then

      LCnt1 = 0

			iFType	= "2"

      LSQL = "EXEC AD_tblADImageInfo_R '" & iFType & "','" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
      'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)

      If Not (LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof

            LCnt1 = LCnt1 + 1
            PSeq1 = PSeq1&"^"&encode(LRs("ImageInfoIDX"),0)&""
            FileName1 = FileName1&"^"&LRs("ImgFileNm")&""
            FilePath1 = FilePath1&"^"&LRs("ImgURL")&""

          LRs.MoveNext
        Loop

      End If

      LRs.close

    End If

		'DbClose()

  End If

%>

<script src="../dev/dist/jscolor.js"></script>
<!--<script src="../dev/dist/se2_img/js/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>-->
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>


<script type="text/javascript">

  $("#iFile_1").on("change", function () {

    alert("test");

  });

  var selSearchValue1 = ""
  var txtSearchValue = "<%=iSearchText%>"
  var selSearchValue = "<%=iSearchCol%>"
  var selSearchValue2 = ""

  var selSearchValue3 = "<%=iDivision%>";
  var selSearchValue4 = "<%=iSearchCol1%>";

  var selSearchValue5 = "<%=iImageType%>";
  var selSearchValue6 = "<%=iViewYN%>";
  var selSearchValue7 = "<%=iLocateGb%>";

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

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
    	post_to_url('./AD_BN_IMG_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./AD_BN_IMG_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iImageType': selSearchValue5, 'iViewYN': selSearchValue6, 'iLocateGb': selSearchValue7 });
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
      alert('제목을 입력해 주세요.');
      return theForm.iSubject.focus();
    }

  	// 첨부파일 1개 이상 있는지 체크 : S //
    if ($('#iFileYN').val() == "Y") {

    }
    else {

    	var iFID = "";
    	var iFIDYN = "";

    	for (var i = 1; i < filecnt + 1; i++) {

    		iFID = "iFile_" + i;

    		iFIDYN = iFIDYN + document.getElementById('' + iFID + '').value;

    	}

    	if (iFIDYN == "") {
    		alert('<%=global_File_Val %>');
    		return
    	}

    }
  	// 첨부파일 1개 이상 있는지 체크 : E //


    //if (iContents == "") {
    //  alert('<%=global_Contents_Val %>');
    //  // 스마트에디터 포커스
    //  oEditors.getById["iContents"].exec("FOCUS");
    //  return
    //}

    // 스마트에디터 서브밋
    try {
      elClickedObj.submit();
    } catch (e) { }

  }

</script>

<section>
  <div id="content">

    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <div class="loaction">
          <strong>광고 관리</strong> &gt; 이미지 관리
        </div>
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./AD_BN_IMG_Write_p.asp" method="post" ENCTYPE="multipart/form-data">

        <table cellspacing="0" cellpadding="0" class="table-list basic-table Community_wtite_box">

					<input type="hidden" id="iFileYN" name="iFileYN" value="N" />

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


					<tr>
            <th>코드그룹</th>
            <td colspan="2">
              <span class="right_con">

								<select id="iImageType" name="iImageType" class="title_select medium">
									<%
									  ' 리스트 조회
										iiNowPage = "1"
										iPagePerData = "1"
										iBlockPage = "1"
									  iiType = "1"
										iiDivision = "1"
										iiSportsGb = "tennis"
										iiCode01 = ""
										iiCode02 = ""
										iiCode03 = ""
										iiCode04 = ""
										iiCode01Group = "IMGTYPE"
										iiCode02Group = ""
										iiCode03Group = ""
										iiCode04Group = ""
										iiSearchCol = "T"
										iiSearchText = ""
										iiSearchCol1 = "S2Y"

									  LSQL1 = "EXEC AD_tblADCode_S '" & iiNowPage & "','" & iPagePerData & "','" & iBlockPage & "','" & iiType & "','" & iiDivision & "','" & iiSportsGb & "','" & iiCode01 & "','" & iiCode02 & "','" & iiCode03 & "','" & iiCode04 & "','" & iiCode01Group & "','" & iiCode02Group & "','" & iiCode03Group & "','" & iiCode04Group & "','" & iiSearchCol & "','" & iiSearchText & "','" & iiSearchCol1 & "','','','','',''"
										'response.Write "LSQL1=LSQL1=LSQL1="&LSQL1&"<br>"
									  'response.End

									  Set LRs = DBCon6.Execute(LSQL1)

									  If Not (LRs.Eof Or LRs.Bof) Then
									    Do Until LRs.Eof
									%>
								  <option value="<%=LRs("Code01") %>" <% if LRs("Code01") = ImageType then  %>selected<% end if %>>[<%=LRs("SportsGbNm") %>] <%=LRs("Code01Name") %></option>
									<%
									      LRs.MoveNext
									    Loop
									%>

									<%
									    Else
									%>
									<option value="">그룹없음</option>
									<%
									  End If

									  LRs.close
									%>
								</select>

							</span>
            </td>
          </tr>

					<tr>
            <th>크기</th>
            <td colspan="2">
              <span class="right_con">

								<select id="iLocateGb" name="iLocateGb" class="title_select medium">
									<%
									  ' 리스트 조회
										iiNowPage = "1"
										iPagePerData = "1"
										iBlockPage = "1"
									  iiType = "1"
										iiiDivision = "2"
										iiSportsGb = "tennis"
										iiCode01 = ""
										iiCode02 = ""
										iiCode03 = ""
										iiCode04 = ""
										iiCode01Group = "LOCATEGBTYPE"
										iiCode02Group = ""
										iiCode03Group = ""
										iiCode04Group = ""
										iiSearchCol = "T"
										iiSearchText = ""
										iiSearchCol1 = "S2Y"

									  LSQL2 = "EXEC AD_tblADCode_S '" & iiNowPage & "','" & iPagePerData & "','" & iBlockPage & "','" & iiType & "','" & iiiDivision & "','" & iiSportsGb & "','" & iiCode01 & "','" & iiCode02 & "','" & iiCode03 & "','" & iiCode04 & "','" & iiCode01Group & "','" & iiCode02Group & "','" & iiCode03Group & "','" & iiCode04Group & "','" & iiSearchCol & "','" & iiSearchText & "','" & iiSearchCol1 & "','','','','',''"
										'response.Write "LSQL1=LSQL1=LSQL1="&LSQL2&"<br>"
									  'response.End

									  Set LRs = DBCon6.Execute(LSQL2)

									  If Not (LRs.Eof Or LRs.Bof) Then
									    Do Until LRs.Eof
									%>
								  <option value="<%=LRs("Code01") %>" <% if LRs("Code01") = LocateGb then  %>selected<% end if %>><%=LRs("Code01Name") %></option>
									<%
									      LRs.MoveNext
									    Loop
									%>

									<%
									    Else
									%>
									<option value="">크기없음</option>
									<%
									  End If

									  LRs.close
									%>
								</select>
                <span style="color:red;">* 업로드 이미지 사이즈 입니다.</span>
							</span>
            </td>
          </tr>


          <tr>
            <th>제목</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iSubject" name="iSubject" value="<%=Subject %>" class="in_1"/>
              </span>
            </td>
          </tr>

					<tr>
            <th>배경색</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iBC" name="iBC" class="jscolor in_1" value="<%=BColor %>" />
              </span>
            </td>
          </tr>

					<tr style="display:none;">
            <th>링크주소</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iLink" name="iLink" value="" class="in_1"/>
              </span>
            </td>
          </tr>

					<tr>
            <th>메모사항</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text" id="iMemo" name="iMemo" value="<%=txtMemo %>" style="height:30px;" class="in_1" maxlength="1000" />
              </span>
            </td>
          </tr>

          <tr>
            <th>파일</th>
            <td>
              <span class="right_con">
                <div id="iFileDiv" name="iFileDiv">
                  <span id="sFile_1"><!--<input type="file" id="iFile_1" name="iFile" class="csfile" onchange="readURL(this);" />-->
										<!--<input type="file" id="iFile_1" name="iFile" class="csfile" />-->
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

					<tr>
            <th>사용유무</th>
            <td colspan="2">
              <span class="right_con">
                <select id="iViewYN" name="iViewYN" class="title_select medium">
								  <option value="Y"<% if ViewYN = "Y" then  %>selected<% end if %>>사용중</option>
								  <option value="N"<% if ViewYN = "N" then  %>selected<% end if %>>미사용</option>
								</select>
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
					<input type="button" id="btnDel" name="btnDel" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
					<input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
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

    if (LCnt1 > 0) {
    	$('#iFileYN').val("Y");
    }

    var PSeq1 = "<%=PSeq1%>";
    var FileName1 = "<%=FileName1%>";
    var FilePath1 = "<%=FilePath1%>";

    var PSeq1arr = PSeq1.split("^");
    var FileName1arr = FileName1.split("^");
    var FilePath1arr = FilePath1.split("^");

    function FileUp() {

    	var ImgChkExt = Checkfiles_Img2('iFile_1');

    	//var ImgChkLength = CheckFiles_Size1('iFile_1');

    	//if (ImgChkExt == "N" || ImgChkLength == "N") {
    	if (ImgChkExt == "N") {

    	}
    	else {



    	}

    }

    function MovieUp() {

    	insertMovie2('HatQmVJ5Uew');

    }

    function FileDel(i4, i5, i6) {

      var ifdtag = "N";

      var strAjaxUrl = "./Ajax/Ad/AD_BN_IMG_Write_FileChk.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        async: false,
        data: {
          i4: i4
        },
        success: function (retDATA) {

          //alert(retDATA);

          if (retDATA == "OK") {

            ifdtag = "N";

          }
          else {

            ifdtag = "Y";

          }

        }, error: function (xhr, status, error) {
          if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
        }
      });

      if (ifdtag == "Y") {

        if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {

          var ifid = $('#iID').val();

          //alert(i4 + ", " + i5 + " , " + i6);

          // i7 : 1 - 커뮤니티>공지사항,KATA뉴스,자유게시판,신문고
          var strAjaxUrl = "../dev/dist/CommonFileADIMGDelete.asp";
          $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
              i4: i4,
              i5: i5,
              i6: i6,
              i7: "1",
              i8: ifid
            },
            success: function (retDATA) {

              //alert(retDATA);

              if (retDATA == "1") {

                alert("해당 파일이 삭제 됐습니다.");
                $('#fileid_' + i4).remove();
                $('#iFileYN').val("N");
              } else {

                alert("해당 파일이 없습니다.");
                $('#fileid_' + i4).remove();
                $('#iFileYN').val("N");
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
      else {

        alert('광고 연결 관리에서 사용 중입니다.\n광고 연결 관리에서 사용 중인 항목을 처리 후 삭제 가능 합니다.');

      }

    }

    function FileDown(i3) {

    	//window.open("<%=global_depth %>/FileDown/" + i3, "_blank");
    	//window.open("<%=global_depth %>/dev/dist/dl.asp?FileName=" + i3);
    	location.href = "../dev/dist/dlADIMG.asp?FileName=" + i3;

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

    if (iType == 2) {
      $("#selSearch1").val(iSubType);
      $("#selSearch2").val(iNoticeYN);
    }

  </script>
	<% AD_DBClose() %>
