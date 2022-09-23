<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
 '로그인 체크 
  Check_UserLogin()

  'Cookie 값 가져오기 
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  iName = fInject(Request.Cookies("UserName"))
%>

<%

  iMSeq = fInject(Request("i1")) 
  MSeq = decode(iMSeq,0)
  NowPage = fInject(Request("i2")) 
  iSearchText = fInject(Request("i3"))
  iSearchCol = fInject(Request("i4"))
  iType= fInject(Request("i5")) 'iType 1 : 쓰기, 2: 수정

  LCnt = 0
  LCnt1 = 0

  if(NowPage = 0) Then NowPage = 1
  if(iType = 0) Then iType = 1

  IF (iType = 2) Then
    LSQL = "EXEC Community_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          LCnt = LCnt + 1
          iSubject = LRs("Subject")
          iContents = LRs("Contents")
          InsDateCv = LRs("InsDateCv")
          FileYN = LRs("FileYN")
          FileCnt = LRs("FileCnt")
          LoginIDYN = LRs("LoginIDYN")
          iSubType= LRs("SubType")
        LRs.MoveNext
      Loop
    End IF
    LRs.close
    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then
      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      response.End
    End IF

    If FileCnt <> "0" Then
      LCnt1 = 0
      LSQL = "EXEC Community_Board_Pds_Read_STR '" & MSeq & "'"
	    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End
      Set LRs = DBCon4.Execute(LSQL)
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
  End IF
%>

<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
  var txtSearchValue = "<%=iSearchText%>"
	var selSearchValue = "<%=iSearchCol%>"
  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  var iFileNum = 1;
  var iFileLimitDf = Number("<%=global_fileNum%>"); // 첨부파일 가능 갯수
  var iFileLimitNum = iFileLimitDf; // 수정시 파일 갯수에 따라 동적으로 변하는 값
  var iFileLimitNum1 = iFileLimitDf; // 
  
  function Del_Link(i1, i2) 
  {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./FAQ_List_delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./FAQ_List.asp', { 'i2': i2 });
  }

  function chk_frm(){
  if(!$('#iSubject').val()){
      alert("팀명을 입력해 주세요.");
      $('#iSubject').focus();
      return false;
  } 
  return true;
}

function OK_Link() {
  if(chk_frm()) {
    var elClickedObj = $("#form1");
    oEditors.getById["iContents"].exec("UPDATE_CONTENTS_FIELD", []);
    var iContents = $("#iContents").val();

    //스마트에디터 공랑인데 <p><br></p>가 들어가서 빈값을 <p><br></p>로 잡아야함 
    //alert(iContents);
    //빈값에 태그가 들어가서 값을 빈값으로 변경해줌

    if(iContents == "<p><br></p>") {
      iContents = "";
    }

    try {
      elClickedObj.submit();
    } catch (e) {

    }
  }
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
      <form id="form1" name="form1" action="./FAQ_List_Write_p.asp" method="post" ENCTYPE="multipart/form-data">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr>
            <th>제목</th>
						<td>
							<span class="left_name">
                <%
                IF iType = 1 Then 
                %>
                <input type="text" id="iSubject" name="iSubject" class="in_1"/>
                <%
                ELSE
                %>
                  <input type="text" id="iSubject" name="iSubject" value="<%=iSubject%>" class="in_1"/>
                <%
                End IF
                %>
							</span>
						</td>
					</tr>
          
          <tr>
            <th>유형</th>
						<td>
							<span class="left_name">
                <select id="selSubType" name="selSubType">
                  <option value="회원가입">회원가입</option>
                  <option value="온라인서비스">온라인서비스</option>
                  <option value="계간유도">계간유도</option>
                </select>
							</span>
						</td>
					</tr>

        
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
            <th>파일</th>
						<td colspan="2">
							<span class="right_con">
								<div id="iFileDiv" name="iFileDiv">
									<span id="sFile_1">
                    <input type="file" id="iFile_1" name="iFile" class="csfile" />
										<span id="FN_iFile_1" class="btn_icon">&nbsp;
											<a href="javascript:;" onclick="javascript:FN_iFileDivP();">+</a>&nbsp;
											<a href="javascript:;" class="btn_file_del" onclick="javascript:FN_iFileDivM(1);">-</a>
										</span>
                  <br />
									</span>
								</div>
							</span>
						</td>
					</tr>

          <tr>
            <th>내용</th>
						<td colspan="2">
							<span class="right_con">
                  <textarea name="iContents" id="iContents" rows="10" cols="100">
                    <%=iContents %>
                  </textarea>
							</span>
						</td>
					</tr>

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
					<input type="hidden" id="iType" name="iType" value="<%=iType%>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
				</div>
      </form>
		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>


<script type="text/javascript">
  var oEditors = [];
  nhn.husky.EZCreator.createInIFrame({
    oAppRef: oEditors,
    elPlaceHolder: "iContents",
    sSkinURI: "../dev/dist/se2/SmartEditor2Skin.html",
    fCreator: "createSEditor2"
  });
</script>

<script type="text/javascript">
  var LCnt1 = Number("<%=LCnt1%>");
  var PSeq1 = "<%=PSeq1%>";
  var FileName1 = "<%=FileName1%>";
  var FilePath1 = "<%=FilePath1%>";
  var PSeq1arr = PSeq1.split("^");
  var FileName1arr = FileName1.split("^");
  var FilePath1arr = FilePath1.split("^");

  function FileDown(i3) {
    window.open("../FileDown/" + i3, "_blank");
  }

  function FN_iFileDivP() {
    if (iFileNum < iFileLimitNum) {
      $('#FN_iFile_' + iFileNum).css('display', 'none');
      iFileNum = iFileNum + 1;
      var iHtmlPC = '';
      iHtmlPC = iHtmlPC + '<span id="sFile_' + iFileNum + '"><input type="file" id="iFile_' + iFileNum + '" name="iFile" class="csfile" /><span id="FN_iFile_' + iFileNum + '" class="btn_icon">&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivP();">+</a>&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivM(' + iFileNum + ');">-</a></span><br /></span>';
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

  function FileDel(i4, i5, i6) {
    if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {
      //alert(i4 + ", " + i5 + " , " + i6);
      // i7 : 1 - 협회정보
      var strAjaxUrl = "../dev/dist/CommonFileDelete.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          i4: i4,
          i5: i5,
          i6: i6
        },
        success: function (retDATA) {
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
    }
  }

  function FN_FileList(i1) {
    var iHtmlPC1 = '<table>';
    for (var i = 1; i < i1 + 1; i++) {
      iHtmlPC1 = iHtmlPC1 + '<tr id=fileid_' + PSeq1arr[i] + '>';
      iHtmlPC1 = iHtmlPC1 + ' <td><a href="javsdcript:;" onClick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;)">'+ FileName1arr[i] + '</a></td>';
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
</script>

<script type="text/javascript">
  $("#selSubType").val('<%=iSubType%>');
</script>

<!--#include file="footer.asp"-->
<%
  JudoKorea_DBClose() 
%>
</html>