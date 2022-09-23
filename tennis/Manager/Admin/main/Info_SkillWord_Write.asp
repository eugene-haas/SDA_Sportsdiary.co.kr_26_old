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
          Contents = LRs("Contents")
					TechCode = LRs("TechCode")
					EnTermName = LRs("EnTermName")
					TermKey = LRs("TermKey")
					TermMidKey = LRs("TermMidKey")
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

<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Info_SkillWord_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./Info_SkillWord_List.asp', { 'i2': i2 });
  }

  function OK_Link() {

    var theForm = document.form1;

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

    if (theForm.iTermMidKey.value == "") {
    	alert('중뷴류를 선택해 주세요.');
    	return theForm.iTermMidKey.focus();
    }

    if (theForm.iSubject.value == "") {
    	alert('국내용어를 입력해 주세요.');
    	return theForm.iSubject.focus();
    }

    if (theForm.iNationalTermName.value == "") {
    	alert('국제용어를 입력해 주세요.');
    	return theForm.iNationalTermName.focus();
    }

    if (theForm.iTechCode.value == "") {
    	alert('기술코드를 입력해 주세요.');
    	return theForm.iTechCode.focus();
    }

  	// 스마트에디터 서브밋
		try {
			elClickedObj.submit();
		} catch (e) { }

  }

  function iTermKey_chg() {

  	var iType = "2";
  	var CType = "";
  	var CSubType = $('#iTermKey').val();

  	//alert(CSubType);

  	var strAjaxUrl = "./Ajax/Info_SkillWord_Write_1.asp";
  	$.ajax({
  		url: strAjaxUrl,
  		type: 'POST',
  		dataType: 'html',
  		data: {
  			iType: iType,
  			CType: CType,
  			CSubType: CSubType
  		},
  		async: false,
  		success: function (retDATA) {
  			if (retDATA) {
  				$('#diviTermMidKey').html(retDATA);
  			} else {
  				$('#diviTermMidKey').html("");
  			}
  		}, error: function (xhr, status, error) {
  			if (error != "") {
  				alert("오류발생! - 시스템관리자에게 문의하십시오!");
  				return;
  			}
  		}
  	});

  }

  function fn_iTermKey() {

  	//alert('TEST');

  	var iType = "1";
  	var CType = "TermKey";
  	var CSubType = "";

  	var strAjaxUrl = "./Ajax/Info_SkillWord_Write_1.asp";
  	$.ajax({
  		url: strAjaxUrl,
  		type: 'POST',
  		dataType: 'html',
  		data: {
  			iType: iType,
  			CType: CType,
  			CSubType: CSubType
  		},
  		async:false,
  		success: function (retDATA) {
  			if (retDATA) {
  				$('#diviTermKey').html(retDATA);
  			} else {
  				$('#diviTermKey').html("");
  			}
  		}, error: function (xhr, status, error) {
  			if (error != "") {
  				alert("오류발생! - 시스템관리자에게 문의하십시오!");
  				return;
  			}
  		}
  	});

  }

</script>

<section>
	<div id="content">

		<!-- S : 내용 시작 -->
		<div class="contents">
			
      <form id="form1" name="form1" action="./Info_SkillWord_Write_p.asp" method="post">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box word_write">

					<tr>
            <th>대분류</th>
						<td colspan="2">
							<span class="right_con">
								<div id="diviTermKey">
									<select name="iTermKey" id="iTermKey" onchange="javascript:iTermKey_chg();">
										<option value="">::대분류를 선택하세요::</option>
									</select>
								</div>
								<% If iType = "2" Then %>등록일 : <%=InsDateCv %><% End If %><br />
							</span>
						</td>
					</tr>

					<tr>
            <th>중분류</th>
						<td colspan="2">
							<span class="right_con">
								<div id="diviTermMidKey">
									<select name="iTermMidKey" id="iTermMidKey">
										<option value="">::중분류를 선택하세요::</option>
									</select>
								</div>
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
					<tr>
            <th>국제용어</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iNationalTermName" name="iNationalTermName" value="<%=NationalTermName %>"  class="in_1"/>
							</span>
						</td>
					</tr>
					<tr>
            <th>기술코드</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iTechCode" name="iTechCode" value="<%=TechCode %>"  class="in_1"/>
							</span>
						</td>
					</tr>
					<tr>
            <th>영문용어</th>
						<td colspan="2">
							<span class="right_con">
								<input type="text" id="iEnTermName" name="iEnTermName" value="<%=EnTermName %>"  class="in_1"/>
							</span>
						</td>
					</tr>
					<tr>
            <th>내용</th>
						<td colspan="2">
							<span class="right_con edit_box">
								<textarea name="iContents" id="iContents" rows="10" cols="100"><%=Contents %></textarea>
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

	<script type="text/javascript">

    // 스마트 에디터 사용시 제일 아래에 해당 코드를 넣어야 반영 됀다.

    var oEditors = [];

    nhn.husky.EZCreator.createInIFrame({

      oAppRef: oEditors,

      elPlaceHolder: "iContents",

      sSkinURI: "../dev/dist/se2/SmartEditor2Skin.html",

      fCreator: "createSEditor2"

    });

    fn_iTermKey();
    
    var iType = Number("<%=iType%>");
    var iMSeq = Number("<%=iMSeq%>");
    var iTermKey = "<%=TermKey%>";
    var iTermMidKey = "<%=TermMidKey%>";

    if (iType == "2") {
    	$("#iTermKey").val(iTermKey);
    	iTermKey_chg();
    	$("#iTermMidKey").val(iTermMidKey);
    }

	</script>

<!--#include file="footer.asp"-->

</html>