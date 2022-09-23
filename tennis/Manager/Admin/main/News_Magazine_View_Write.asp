<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%

	iSubType = fInject(Request("iSubType"))
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

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

    LSQL = "EXEC News_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon4.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
          N_Year = LRs("N_Year")
          SubTypeName = LRs("SubTypeName")
					SubType = LRs("SubType")
          InsDateCv = LRs("InsDateCv")
          FileYN = LRs("FileYN")
          FileCnt = LRs("FileCnt")
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


    If FileCnt <> "0" Then

      LCnt1 = 0

      LSQL = "EXEC News_Board_Pds_Read_STR '" & MSeq & "'"
	    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End
  
      Set LRs = DBCon4.Execute(LSQL)

      If Not (LRs.Eof Or LRs.Bof) Then

		    Do Until LRs.Eof

            LCnt1 = LCnt1 + 1
            PSeq1 = PSeq1&"^"&LRs("PSeq")&""
            FileName1 = FileName1&"^"&LRs("FileName")&""
            FilePath1 = FilePath1&"^"&LRs("FilePath")&""
						FileType1 = FileType1&"^"&LRs("FileType")&""

          LRs.MoveNext
		    Loop

      End If
  
      LRs.close

    End If

  
  End If
  
%>

<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	var selSearchValue1 = "<%=iSubType%>"
	var txtSearchValue = "<%=iSearchText%>"
	var selSearchValue = "<%=iSearchCol%>"

	var iType = Number("<%=iType%>");
	var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./News_Magazine_View_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	post_to_url('./News_Magazine_View_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function OK_Link() {

  	if ($('#iFile_1').val() != '') {
  		$('#iFileType1').val('1');
  	}

  	if ($('#iFile_2').val() != '') {
  		$('#iFileType2').val('2');
  	}
  	

    // 스마트에디트 아닐때
    var theForm = document.form1;
    
    if (theForm.iFile_1.value == "") {
      alert('썸네일 이미지를 선택해 주세요.');
      return theForm.iFile_1.focus();
    }
		
    if (theForm.iFile_2.value == "") {
    	alert('계간유도 파일을 선택해 주세요.');
    	return theForm.iFile_2.focus();
    }
    
    if (confirm("해당 글을 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./News_Magazine_View_Write_p.asp";
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
      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        유도소식 > 계간유도 > 계간유도
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./News_Magazine_View_Write_p.asp" method="post" ENCTYPE="multipart/form-data">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">

					<tr>
            <th>구분</th>
						<td>
							<span class="left_name">
								<span class="right_con">
									<select id="selSearch1" name="selSearch1" class="title_select">
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
            <th>발행년도</th>
						<td colspan="2">
							<span class="right_con">
								<select name="iyear" id="iyear">
									<option value="2010">2010년</option>
									<option value="2011">2011년</option>
									<option value="2012">2012년</option>
									<option value="2013">2013년</option>
									<option value="2014">2014년</option>
									<option value="2015">2015년</option>
									<option value="2016">2016년</option>
									<%
										Dim iYear, iYear_no
										iYear = Year(Now())
										iYear_no = iYear - 2016

										For i = 1 To iYear_no
									%>
									<option value="<%= 2016 + i %>"><%= 2016 + i %>년</option>
									<option value="<%= 2016 + i + 1 %>"><%= 2016 + i + 1 %>년</option>
									<%
										Next
									%>
								</select>
							</span>
						</td>
					</tr>

					<tr>
            <th>썸네일 이미지</th>
						<td colspan="2">
							<span class="right_con">
								<div id="iFileDiv" name="iFileDiv">
									<span id="sFile_1"><input type="file" id="iFile_1" name="iFile" class="csfile" onchange="javascript:Checkfiles_Img('iFile_1');" />
									</span>
								</div>
							</span>
						</td>
					</tr>

					<tr>
            <th>계간유도 파일</th>
						<td colspan="2">
							<span class="right_con">
								<div id="iFileDiv2" name="iFileDiv2">
									<span id="sFile_2"><input type="file" id="iFile_2" name="iFile" class="csfile" onchange="javascript:Checkfiles_Pdf('iFile_2');" />
									</span>
								</div>
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
          <input type="hidden" id="iFilecnt" name="iFilecnt" value="0" />
					<input type="hidden" id="iFileType1" name="iFileType1" value="" />
					<input type="hidden" id="iFileType2" name="iFileType2" value="" />

				</div>
      </form>

		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>


  <script type="text/javascript">

  	var iType = Number("<%=iType%>");
  	var iSubType = "<%=SubType%>";
  	var iN_Year = "<%=N_Year%>";

  	if (iType == 2) {
  		$("#selSearch1").val(iSubType);
  		$('#iyear').val(iN_Year);
  	}
  	else {
  		var iNowYear = new Date();
  		//alert(iNowYear.getFullYear());
  		$('#iyear').val(iNowYear.getFullYear());
  	}


    // 첨부파일 관련

    var LCnt1 = Number("<%=LCnt1%>");
    //alert(LCnt1);

    var PSeq1 = "<%=PSeq1%>";
    var FileName1 = "<%=FileName1%>";
    var FilePath1 = "<%=FilePath1%>";
    var FileType1 = "<%=FileType1%>";

    var PSeq1arr = PSeq1.split("^");
    var FileName1arr = FileName1.split("^");
    var FilePath1arr = FilePath1.split("^");
    var FileType1arr = FileType1.split("^");

    function FileDel(i4, i5, i6, filetype) {

      if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {

      	//alert(i4 + ", " + i5 + " , " + i6 + " , " + filetype);
				//
      	//$('#fileid_' + i4).remove();
				//
      	//if (filetype == "1") {
      	//	$('#sFile_1').css('display', '');
      	//}
      	//else {
      	//	$('#sFile_2').css('display', '');
      	//}

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
						i7: "2"
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
        
            if (filetype == "1") {
            	$('#sFile_1').css('display', '');
            }
            else {
            	$('#sFile_2').css('display', '');
            }
        
          }, error: function (xhr, status, error) {
            if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
          }
        });

      }
      else {

      }

    }


    function FN_FileList(i) {

    	var filetype = "1";

      var iHtmlPC1 = '<p>';
      
      iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
      //iHtmlPC1 = iHtmlPC1 + ' <td><a href="javsdcript:;" onClick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;)">' + FileName1arr[i] + '</a></td>';
      iHtmlPC1 = iHtmlPC1 + ' <span><a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a></span>';
      iHtmlPC1 = iHtmlPC1 + ' <span><a href="javascript:;" onClick="javascript:FileDel(&#39;' + PSeq1arr[i] + '&#39;,&#39;' + FileName1arr[i] + '&#39;,&#39;' + iMSeq + '&#39;,&#39;' + filetype + '&#39;)" class="ex_btn">X</a></span>';
      iHtmlPC1 = iHtmlPC1 + '</p>';

      iHtmlPC1 = iHtmlPC1 + '</p>';

    	//alert(iHtmlPC1);

      $('#iFileDiv').prepend(iHtmlPC1);

    }

    function FN_FileList2(i) {

    	var filetype = "2";

    	var iHtmlPC1 = '<p>';

    	iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
    	//iHtmlPC1 = iHtmlPC1 + ' <td><a href="javsdcript:;" onClick="javascript:FileDown(&#39;' + FileName1arr[i] + '&#39;)">' + FileName1arr[i] + '</a></td>';
    	iHtmlPC1 = iHtmlPC1 + ' <span><a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a></span>';
    	iHtmlPC1 = iHtmlPC1 + ' <span><a href="javascript:;" onClick="javascript:FileDel(&#39;' + PSeq1arr[i] + '&#39;,&#39;' + FileName1arr[i] + '&#39;,&#39;' + iMSeq + '&#39;,&#39;' + filetype + '&#39;)" class="ex_btn">X</a></span>';
    	iHtmlPC1 = iHtmlPC1 + '</p>';

    	iHtmlPC1 = iHtmlPC1 + '</p>';

    	//alert(iHtmlPC1);

    	$('#iFileDiv2').prepend(iHtmlPC1);

    }

    // 파일갯수가 파일제한보다 많을땐 파일추가 부분 삭제
    if (LCnt1 > 0) {

    	for (var i = 1; i < LCnt1 + 1; i++) {

    		if (FileType1arr[i] == "1") {

    			$('#sFile_1').css('display', 'none');

    			FN_FileList(i);

    			$('#iFileType1').val('1');

    		}
    		else {

    			$('#sFile_2').css('display', 'none');

    			FN_FileList2(i);

    			$('#iFileType2').val('2');

    		}

    	}
   
    }
    else {

    }
		
  </script>


<!--#include file="footer.asp"-->

</html>