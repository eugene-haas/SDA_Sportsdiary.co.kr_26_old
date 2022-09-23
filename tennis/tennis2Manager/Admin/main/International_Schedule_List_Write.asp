<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%
  Name = fInject(Request.Cookies("UserName"))
  iLoginID = decode(fInject(Request.cookies("UserID")),0)
%>

<%
  Dim NowPage, iType
  NowPage = fInject(Request("i2"))  		' 현재페이지
	iYear = fInject(Request("i3"))  			' 년도
	iTextSearch = fInject(Request("i4"))  ' 텍스트
  iType = fInject(Request("i5"))  			' 글쓰기 1, 수정 2
 	'JudoTitleWriteLine "iType", iType


  ' 뷰 관련
  Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  LCnt = 0
  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt1, PSeq1, FileName1, FilePath1
  LCnt1 = 0
  If iType = "2" Then
    iMSeq = fInject(Request("i1"))
    MSeq = decode(iMSeq,0)
    LSQL = "EXEC Conference_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
		  Do Until LRs.Eof
          LCnt = LCnt + 1
          iTitle = LRs("Title")
          iContents = LRs("Contents")
					iStartDate = LRs("StartDate")
					iEndDate = LRs("EndDate")
					iLocation = LRs("Location")
					FileCnt = LRs("FileCnt")
          FileYN = LRs("FileYN")
          LoginIDYN = LRs("LoginIDYN")
					InsDateCv = LRs("InsDateCv")
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
      LSQL = "EXEC Conference_Board_Pds_Read_STR '" & MSeq & "'"
	    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End
      Set LRs = DBCon4.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
		    Do Until LRs.Eof
            LCnt1 = LCnt1 + 1
						
            PSeq1 = PSeq1&"^"&LRs("PSeq")&""
            FileName1 = FileName1&"^"&LRs("FileName")&""
            FilePath1 = FilePath1&"^"&LRs("FilePath")&""
						GroupName1 = GroupName1&"^"&LRs("GroupName")&""

						if(LRs("GroupName") = "첨부파일") Then
							AttachLCnt = AttachLCnt + 1
						End if	

          LRs.MoveNext
		    Loop
      End If
      LRs.close
    End If
  End If
  'JudoTitleWriteLine "LCnt1", LCnt1
	'JudoTitleWriteLine "FileCnt", FileCnt
%>

<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>
  
<script type="text/javascript">
	var iType = Number("<%=iType%>");
	var iMSeq = Number("<%=iMSeq%>");

  $( document ).ready(function() {
		/*
		if(iType == 1)
		{
			$("#iStartDate").val(getDefaultDate());
			$("#iEndDate").val(getDefaultDate());
		}
		*/
    document.getElementById("selectYear").selectedIndex = "1";
  })
</script>

<script type="text/javascript">

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./International_Schedule_List_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

	function getDefaultDate(){
			var now = new Date();
			var day = ("0" + now.getDate()).slice(-2);
			var month = ("0" + (now.getMonth() + 1)).slice(-2);
			var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
			return today;
	}

  function CancelLink(i2) {
  	post_to_url('./International_Schedule_List.asp', { 'i2': i2});
  }

  function chk_frm(){
  
   if(!$('#iTitle').val()){
      alert("제목을 입력해주세요.");
      $('#iTitle').focus();
      return false;
  } 

  if(!$('#iContents').val()){
      alert("내용을 입력해주세요.");
      $('#iContents').focus();
      return false;
  } 

  if(!$('#iLocation').val()){
      alert("지역을 입력해주세요.");
      $('#iLocation').focus();
      return false;
  } 
  
	if(!$('#iStartDate').val()){
      alert("참가신청 기간을 선택해주세요.");
      $('#iStartDate').focus();
      return false;
  } 

	if(!$('#iEndDate').val()){
      alert("참가신청 기간을 선택해주세요.");
      $('#iEndDate').focus();
      return false;
  } 

	if($('#iStartDate').val() > $('#iEndDate').val())
	{
		  alert("시작날짜가 종료날짜보다 클 순 없습니다..");
      $('#iStartDate').focus();
      return false;
	}
  
  return true;
}

  function OK_Link() {
		if(chk_frm())
		{
			var theForm = document.form1;
			
			if (confirm("해당 글을 저장 하시겠습니까?") == true) {
				try {
					theForm.submit();
				} catch (e) { }
			}
			else {
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
        대회정보 > 국제대회
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./International_Schedule_List_Write_p.asp" method="post" ENCTYPE="multipart/form-data">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
			
					<tr>
            <th>제목</th>
						<td>
							<span class="left_name">
								<span class="right_con">
									<%
										IF ( iType = 1) THEN
									%>
										<input type="text" id="iTitle" name="iTitle" class="in_6"/>
									<%
										Else
									%>
										<input type="text" id="iTitle" name="iTitle" value="<%=iTitle%>" class="in_6"/>
									<%
										End If
									%>
								</span>
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
            <th>내용</th>
						<td colspan="2">
							<%
								IF ( iType = 1) THEN
							%>
								<input type="text" id="iContents" name="iContents" class="in_6"/>
							<%
								Else
							%>
								<input type="text" id="iContents" name="iContents" value="<%=iContents%>" class="in_6"/>
							<%
								End If
							%>
						</td>
					</tr>

					<tr>
            <th>장소</th>
						<td colspan="2">
							<%
								IF ( iType = 1) THEN
							%>
								<input type="text" id="iLocation" name="iLocation" class="in_6"/>
							<%
								Else
							%>
								<input type="text" id="iLocation" name="iLocation" value="<%=iLocation%>" class="in_6"/>
							<%
								End If
							%>
						</td>
					</tr>
					<tr>
            <th>참가신청기간</th>
						<td colspan="2">
							<%
								IF ( iType = 1) THEN
							%>
								<input id="iStartDate" name="iStartDate" class="in_6 date_ipt"/>
								~
								<input id="iEndDate" name="iEndDate" class="in_6 date_ipt"/>
							<%
								Else
							%>
								<input id="iStartDate" name="iStartDate" value="<%=iStartDate%>"  class="in_6 date_ipt"/>
								~
								<input id="iEndDate" name="iEndDate" value="<%=iEndDate%>"  class="in_6 date_ipt"/>
							<%
								End If
							%>
						</td>
					</tr>

					<tr>
            <th>대진표</th>
						<td colspan="2">
							<span class="right_con">
								<div class="file_list_box" id="MatchFile_Listbox" name="MatchFile_Listbox">
								</div>
								<div id="MatchFile_write" name="MatchFile_write">
									<span id="sFile_1">
										<input type="file" id="iFile_1" name="iMatchFile" class="csfile" />
									</span>
								</div>
							</span>
						</td>
					</tr>

					<tr>
            <th>대회결과</th>
						<td colspan="2">
							<span class="right_con">
								<div class="file_list_box" id="ResultFile_Listbox" name="ResultFile_Listbox">
								</div>
								<div id="ResultFile_write" name="ResultFile_write">
									<span id="sFile_2">
										<input type="file" id="iFile_2" name="iResultFile" class="csfile" />
									</span>
								</div>
							</span>
						</td>
					</tr>
					
					<tr>
            <th>첨부파일</th>
						<td colspan="2">
							<span class="right_con">
								<div class="file_list_box" id="AttachFile_Listbox" name="AttachFile_Listbox">
								</div>
								<div  id="AttachFile_write" name="AttachFile_write">
									<div class="file_add" id="file_add_1" class="">
										<input type="file"  id="iAttachFile_1" name="iAttachFile" class="csfile" />
									</div>
									<div id="iAttachFile_PlusDelete_1"  class="plus_delete_btn">
										<a href="javascript:;" class="btn_file_del" onclick="javascript:FN_iFileDivM(1);">-</a>
										<a href="javascript:;" class="btn_file_plus" onclick="javascript:FN_iFileDivP();">+</a>
									</div>
								</div>
							</span>
						</td>
					</tr>

				</table>
				<div class="btn_list">
					<%
						IF ( iType = 2) THEN
					%>
					<input type="button" id="btnOK" name="btnOK" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
					<%
						END IF 
					%>
					<input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
					<input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript:CancelLink('<%=NowPage %>');" style="cursor:pointer" />
					<%
						IF ( iType = 2) THEN
					%>
					<input type="hidden" id="iMSeq" name="iMSeq" value="<%=iMSeq %>" />
					<%
						END IF 
					%>
					<input type="hidden" id="iType" name="iType" value="<%=iType %>" />
					<input type="hidden" id="iName" name="iName" value="<%=Name %>" />
					<input type="hidden" id="iID" name="iID" value="<%=iLoginID %>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />

				</div>
      </form>

		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>


  <script type="text/javascript">
		var iFileNum = 1;
		var iFileLimitDF = Number("<%=global_fileNum%>"); // 첨부파일 개수 현재:3개
		var iFileLimitNum = iFileLimitDF; // 변하지 않는 기본초기값.iFileLimitNum 과 같은 숫자를 적으면 됌.
		var iFileLimitNum1 = iFileLimitDF; // 변하지 않는 기본초기값.iFileLimitNum 과 같은 숫자를 적으면 됌.
    // 첨부파일 관련
    var LCnt1 = Number("<%=LCnt1%>");
		var AttachLCnt = Number("<%=AttachLCnt%>");

    var PSeq1 = "<%=PSeq1%>";
    var FileName1 = "<%=FileName1%>";
    var FilePath1 = "<%=FilePath1%>";
    var GroupName1 = "<%=GroupName1%>";

    var PSeq1arr = PSeq1.split("^");
    var FileName1arr = FileName1.split("^");
    var FilePath1arr = FilePath1.split("^");
    var GroupName1arr = GroupName1.split("^");
	
    function FileDel(i4, i5, i6, i8) {
				
      if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {
				// i7 : 1 - 협회정보
        var strAjaxUrl = "../dev/dist/CommonFileDelete.asp";
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
            i4: i4,
            i5: i5,
      	    i6: i6,
						i7: "4"
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
						
            if (i8 == "대진표") {
            	$('#MatchFile_write').css('display', '');
            }
						else if(i8 == "대회결과"){
							$('#ResultFile_write').css('display', '');
						}
            else if(i8 =="첨부파일"){
							
							AttachLCnt = AttachLCnt - 1;
							
							// 파일추가부분이 총파일수 보다 커야 보이게

							if (AttachLCnt < iFileLimitNum1)
							{
								$('#AttachFile_write').css('display', '');

								iFileLimitNum = iFileLimitNum1 - AttachLCnt;
							}
            }
        
          }, error: function (xhr, status, error) {
            if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
          }
        });

      }
      else {

      }

    }

		function FN_iFileDivM(i1) {
			if (i1 == "1") {
				$('#iFile_1').val('');
			}
			else {
				$('#file_add_' + i1).remove();
				iFileNum = iFileNum - 1;
				$('#iAttachFile_PlusDelete_' + iFileNum).css('display', '');
			}
  	}

		function FN_iFileDivP()
		{
			if (iFileNum < iFileLimitNum)
			{
				$('#iAttachFile_PlusDelete_' + iFileNum).css('display', 'none');

				iFileNum = iFileNum + 1;

				var iHtmlPC = '';

				iHtmlPC = iHtmlPC + '<div class="file_add" id="file_add_' + iFileNum + '">' +
																'<input type="file" id="iFile_' + iFileNum + '" name="iAttachFile" class="csfile" />' +
															'<div id="iAttachFile_PlusDelete_'+ iFileNum +'" class="plus_delete_btn">' +
																'<a href="javascript:;" class="btn_file_del" onclick="javascript:FN_iFileDivM(' + iFileNum + ');">-</a>' +
																'<a href="javascript:;" class="btn_file_plus" onclick="javascript:FN_iFileDivP();">+</a>' +
															'</div>' +
														'</div>';

				$('#AttachFile_write').append(iHtmlPC);
			}
			else {
				alert('현재 첨부 파일 추가는 ' + iFileLimitNum + '개 까지 만 가능 합니다.');
			}
		}
	
	
		function FN_MatchFileList(i) 
		{
			var iHtmlPC1 = '<p>';
			iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
			iHtmlPC1 = iHtmlPC1 + ' <span>'
			iHtmlPC1 = iHtmlPC1 + '<a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a>'
			iHtmlPC1 = iHtmlPC1 + '</span>';
			iHtmlPC1 = iHtmlPC1 + ' <span>'
			iHtmlPC1 = iHtmlPC1 + '<a href="javascript:;" onClick="javascript:FileDel(&#39;' +  PSeq1arr[i] + '&#39,&#39'  + FileName1arr[i] +  '&#39;,&#39;'  + iMSeq +  '&#39;,&#39;' + GroupName1arr[i] + '&#39)"; class="ex_btn">X'
			iHtmlPC1 = iHtmlPC1 + '</a>';
			iHtmlPC1 = iHtmlPC1+ '</span>';
			iHtmlPC1 = iHtmlPC1 + '</p>';
			iHtmlPC1 = iHtmlPC1 + '</p>';
			$('#MatchFile_Listbox').prepend(iHtmlPC1);
		}

		
		function FN_ResultFileList(i) 
		{
			var iHtmlPC1 = '<p>';
			iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
			iHtmlPC1 = iHtmlPC1 + ' <span>'
			iHtmlPC1 = iHtmlPC1 + '<a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a>'
			iHtmlPC1 = iHtmlPC1 + '</span>';
			iHtmlPC1 = iHtmlPC1 + ' <span>'
			iHtmlPC1 = iHtmlPC1 + '<a href="javascript:;" onClick="javascript:FileDel(&#39;' +  PSeq1arr[i] + '&#39,&#39'  + FileName1arr[i] +  '&#39;,&#39;'  + iMSeq +  '&#39;,&#39;' + GroupName1arr[i] + '&#39)"; class="ex_btn">X'
			iHtmlPC1 = iHtmlPC1 + '</a>';
			iHtmlPC1 = iHtmlPC1+ '</span>';
			iHtmlPC1 = iHtmlPC1 + '</p>';
			iHtmlPC1 = iHtmlPC1 + '</p>';
			$('#ResultFile_Listbox').prepend(iHtmlPC1);
		}



		function FN_AttachFileList(i) 
		{
			var iHtmlPC1 = '<p>';
			iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
			iHtmlPC1 = iHtmlPC1 + ' <span>'
			iHtmlPC1 = iHtmlPC1 + '<a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a>'
			iHtmlPC1 = iHtmlPC1 + '</span>';
			iHtmlPC1 = iHtmlPC1 + ' <span>'
			iHtmlPC1 = iHtmlPC1 + '<a href="javascript:;" onClick="javascript:FileDel(&#39;' +  PSeq1arr[i] + '&#39,&#39'  + FileName1arr[i] +  '&#39;,&#39;'  + iMSeq +  '&#39;,&#39;' + GroupName1arr[i] + '&#39)"; class="ex_btn">X'
			iHtmlPC1 = iHtmlPC1 + '</a>';
			iHtmlPC1 = iHtmlPC1+ '</span>';
			iHtmlPC1 = iHtmlPC1 + '</p>';
			iHtmlPC1 = iHtmlPC1 + '</p>';
			$('#AttachFile_Listbox').prepend(iHtmlPC1);
		}


		if(AttachLCnt >= iFileLimitNum)
				$('#AttachFile_write').css('display', 'none');
		else
			iFileLimitNum = iFileLimitNum - AttachLCnt

		
    // 파일갯수가 파일제한보다 많을땐 파일추가 부분 삭제
    if (LCnt1 > 0) {
    	for (var i = 1; i < LCnt1 + 1; i++) {
    		if (GroupName1arr[i] == "대진표") {
    			$('#MatchFile_write').css('display', 'none');
    			FN_MatchFileList(i);
    		}
    		else if (GroupName1arr[i] == "대회결과") {
    			$('#ResultFile_write').css('display', 'none');
    			FN_ResultFileList(i);
    		}
				else if (GroupName1arr[i] == "첨부파일")
				{
    			FN_AttachFileList(i);
				}
    	}
    }
    else {
    }
  </script>
<!--#include file="footer.asp"-->

</html>