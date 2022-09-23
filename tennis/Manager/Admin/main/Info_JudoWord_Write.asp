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

    LSQL = "EXEC Infomation_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
	  'response.Write "LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon4.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
          Subject = LRs("Subject")
          NationalTermName = LRs("NationalTermName")
          Pronunciation = LRs("Pronunciation")
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


    JudoKorea_DBClose()
  
  End If
  
%>

<script type="text/javascript">

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Info_JudoWord_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./Info_JudoWord_List.asp', { 'i2': i2 });
  }

  function OK_Link() {

    // 스마트에디트 아닐때
    var theForm = document.form1;
    
    
    if (theForm.iNationalTermName.value == "") {
      alert('국제용어를 입력해 주세요.');
      return theForm.iNationalTermName.focus();
    }
    
    if (theForm.iPronunciation.value == "") {
    	alert('발음을 입력해 주세요.');
      return theForm.iPronunciation.focus();
    }

    if (theForm.iSubject.value == "") {
    	alert('국내용어를 입력해 주세요.');
    	return theForm.iSubject.focus();
    }
    
    if (confirm("해당 글을 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
  	    theForm.action = "./Info_JudoWord_Write_p.asp";
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
			
      <form id="form1" name="form1" action="./Info_JudoWord_Write_p.asp" method="post">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">

					<tr>
            <th>국제용어</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iNationalTermName" name="iNationalTermName" value="<%=NationalTermName %>" class="in_1"/>
								<% If iType = "2" Then %>등록일 : <%=InsDateCv %><% End If %><br />
							</span>
						</td>
					</tr>

					<tr>
            <th>발음</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iPronunciation" name="iPronunciation" value="<%=Pronunciation %>"  class="in_1"/>
							</span>
						</td>
					</tr>

					<tr>
            <th>국내용어</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iSubject" name="iSubject" value="<%=Subject %>"  class="in_1"/>
							</span>
						</td>
					</tr>
					
				</table>
				<div class="btn_list">
					<input type="button" id="btnOK" name="btnOK" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
					<input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
					<input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />

					<input type="hidden" id="iMSeq" name="iMSeq" value="<%=iMSeq %>" />
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

<!--#include file="footer.asp"-->

</html>