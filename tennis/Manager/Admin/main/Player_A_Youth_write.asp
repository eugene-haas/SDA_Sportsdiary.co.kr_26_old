<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  NowPage = fInject(Request("i2")) 
  ReqOptionVal = fInject(Request("i3")) 
  ReqTextSearchVal= fInject(Request("i4"))
  ReqWeightVal =  fInject(Request("i5"))
  iYear =  fInject(Request("i6"))
  iMSeq = fInject(Request("i1"))
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("i7")) 'iType 1 : 쓰기, 2: 수정
  'Cookie 값 가져오기 
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  LCnt = 0
  LCnt1 = 0
  if(NowPage = 0) Then NowPage = 1
  if(iType = 0) Then iType = 1
  iTP_Type = "T00005" ' 국가대표후보선수
  'JudoTitleWriteLine "iType", iType
 
  IF (iType = 2) Then
    LSQL = "EXEC TeamPlayer_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          LCnt = LCnt + 1
          iSchool = LRs("School")
          iInsDateCv = LRs("InsDateCv")
          iWeight = LRs("TP_Weight")
          iTypeOption = LRs("TP_TypeOption")
          iName = LRs("Name")
          iPosition = LRs("TP_Position")
          iLink = LRs("Link")
          iYear = LRs("TP_Year")
          FileCnt = LRs("FileCnt")
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
      LSQL = "EXEC TeamPlayer_Board_Pds_Read_STR '" & MSeq & "'"
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

<%
  Dim LSQL 'sqlQuery
  Dim iCType : iCType = 1
  Dim Const_iCTypeLocal,Const_iCTypeOptionDivision
  
  Const_iCTypeOptionDivision ="TP_TypeOption_Team_Division"
  Const_iCTypeWeightDivision = "WeightDivision"
  Const_iCtypePosition = "Position"

  iCType = 2
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeOptionDivision & "','" & iTP_Type & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      DRCnt = DRCnt + 1 
      DName = DName & "^" & LRs("Name") & ""
      DCode = DCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  
  iCType = 1
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCtypePosition & "','" & iTP_Type & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      PRCnt = PRCnt + 1 
      PName = PName & "^" & LRs("Name") & ""
      PCode = PCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  iCType = 1
  WExceptCode = "W00001"
  LSQL = "EXEC CodePropertyName_Search_Type_STR " & "'" & iCType & "','" & Const_iCTypeWeightDivision & "'" & ",''"
  'JudoTitleWriteLine "LSQL", LSQL
  'Response.ENd
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
      IF(LRs("Code") <> WExceptCode) Then
        WRCnt1 = WRCnt1 + 1
        WName1 = WName1 & "^" & LRs("Name") & ""
        WCode1 = WCode1 & "^" & LRs("Code") & ""
      ELSE
        WRCnt2 = WRCnt2 + 1
        WName2 = WName2 & "^" & LRs("Name") & ""
        WCode2 = WCode2 & "^" & LRs("Code") & ""
      End IF
      LRs.MoveNext
      Loop
  End If
  LRs.close
  
	'JudoTitleWriteLine "TP_Year", TP_Year
  'JudoTitleWriteLine "LCode", LCode
  'JudoTitleWriteLine "LRCnt", LRCnt
  'JudoTitleWriteLine "DName", DName
  'JudoTitleWriteLine "DCode", DCode
  'JudoTitleWriteLine "DRCnt", DRCnt
  'JudoTitleWriteLine "OName", OName
  'JudoTitleWriteLine "OCode", OCode
  'JudoTitleWriteLine "ORCnt", ORCnt

%>

<script type="text/javascript">
  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");
  
  $( document ).ready(function() {
      if(iType == 1)
      {
        $("#selectTypeOption option")[0].selected = true;
        $("#selectPositionOption option")[1].selected = true;
        $("#selectYear option")[2].selected = true;
        //$("#selectOptionWeight option")[1].selected = true;
      }
      else{
        $("#selectTypeOption").val('<%=iTypeOption %>');
        $("#selectPositionOption").val('<%=iPosition %>');
        $("#selectOptionWeight").val('<%=iWeight %>')
        $("#selectYear").val('<%=iYear%>');
      }
      Load($("#selectPositionOption").val())
  });

  
  function Del_Link(i1, i2) 
  {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Player_A_Youth_delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i1) {
  	post_to_url('./Player_A_Youth.asp', { 'i1': i1 });
  }

  function chk_frm(){
  
   if(!$('#selectTypeOption').val()){
      alert("팀소속을 선택해주세요.");
      $('#selectTypeOption').focus();
      return false;
  } 

  if(!$('#selectOptionWeight').val()){
      alert("구분을 선택해주세요.");
      $('#selectOptionWeight').focus();
      return false;
  } 

  if(!$('#iName').val()){
      alert("이름을 입력해 주세요.");
      $('#iName').focus();
      return false;
  } 
  
   if(!$('#selectPositionOption').val()){
      alert("직책을 선택해주세요.");
      $('#selectPositionOption').focus();
      return false;
  } 

   if(!$('#selectYear').val()){
      alert("년도를 선택해주세요.");
      $('#selectYear').focus();
      return false;
  } 
  
  return true;
}

function OK_Link() {
  if(chk_frm()){
      var elClickedObj = $("#form1");
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
     		팀/선수정보 > 대표팀정보 > 청소년선수
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Player_A_Youth_write_p.asp" method="post" ENCTYPE="multipart/form-data">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr>
            <th>팀소속</th>
						<td>
							<span class="left_name">
                <select id="selectTypeOption" name="selectTypeOption" class="title_select">
                </select>
							</span>
						</td>
					</tr>
					<% if iType ="2" then %>
          <tr>
            <th>등록일</th>
            <td>
              <span class="left_name">
                <span class="regist_date"><%=iInsDateCv %></span><br />
              </span>
            </td>
          </tr>
					<% end if %>
          <tr>
            <th>직책</th>
						<td colspan="2">
							<span class="right_con">
                <select id="selectPositionOption" name="selectPositionOption" class="title_select">
                </select>
							</span>
						</td>
					</tr>
          <tr>
					<tr>
            <th>구분</th>
						<td colspan="2">
							<span class="right_con">
							 <select id="selectOptionWeight" name="selectOptionWeight" class="title_select">
                <option value="">구분</option>
              </select>
							</span>
						</td>
					</tr>
					<tr>
          
            <th>이름</th>
						<td colspan="2">
							<span class="right_con">
								<%
                  IF iType = 1 Then 
                    Response.Write("<input type='text' id='iName' name='iName' class='in_1'/>")
                  ELSE
                    Response.Write("<input type='text' id='iName' name='iName' value='" & iName & "' class='in_1'/>")
                  End IF
                %>
							</span>
						</td>
					</tr>
          <tr>

            <tr>
          <th>학교</th>
						<td colspan="2">
							<span class="right_con">
							    <%
                  IF iType = 1 Then 
                    Response.Write("<input type='text' id='iSchool' name='iSchool' class='in_1'/>")
                  ELSE
                    Response.Write("<input type='text' id='iSchool' name='iSchool' value='" & iSchool & "' class='in_1'/>")
                  End IF
                  %>
                  <div class="map_2">
                  </div>
							</span>
						</td>
					</tr>
            <th>이미지</th>
						<td colspan="2">
							<span class="right_con">
								<div id="iFileDiv" name="iFileDiv">
									<span id="sFile_1"><input type="file" id="iFile_1" name="iFile" class="csfile" />
									</span>
								</div>
							</span>
						</td>
					</tr>
        
            <tr>
            <th>년도</th>
						<td colspan="2">
							<span class="right_con">
								 <select id="selectYear" name="selectYear" class="title_select">
                  <option value="">년도</option>
                  <%
                    standardYear = 2010
                    currentYear = year(now()) + 1
                    CntYear = currentYear - standardYear 
                    for i= CntYear to 0 step -1
                      Response.Write("<option value='"& standardYear + i&"'>"& standardYear + i&"</option>")
                    next 
                  %>
                </select>
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
					<input type="hidden" id="iType" name="iType" value="<%=iType %>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
				</div>
      </form>
		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>

<script type="text/javascript">
  var dName = "<%=DName%>"
  var dCode = "<%=DCode%>"
  var dRCnt = "<%=DRCnt%>"
  var dNameArr = dName.split("^");
  var dCodeArr = dCode.split("^");
  var playerPosition = "P00003";

  var pName = "<%=PName%>"
  var pCode = "<%=PCode%>"
  var pRCnt = "<%=PRCnt%>"
  var pNameArr = pName.split("^");
  var pCodeArr = pCode.split("^");

  var wName1 = "<%=WName1%>"
  var wCode1 = "<%=WCode1%>"
  var wRCnt1 = "<%=WRCnt1%>"
  var wNameArr1 = wName1.split("^");
  var wCodeArr1 = wCode1.split("^");

  var wName2 = "<%=WName2%>"
  var wCode2 = "<%=WCode2%>"
  var wRCnt2 = "<%=WRCnt2%>"
  var wNameArr2 = wName2.split("^");
  var wCodeArr2 = wCode2.split("^");

  for(var di=1; di <= dRCnt; di++)
  {
    $("#selectTypeOption").append("<option value=" + dCodeArr[di] + ">" + dNameArr[di] + "</option>");
  }

  for(var pi=1; pi <= pRCnt; pi++)
  {
    $("#selectPositionOption").append("<option value=" + pCodeArr[pi] + ">" + pNameArr[pi] + "</option>");
  }

  $('#selectPositionOption').on('change', function () {
     var selectPositionVal =  $(this).val();
     if(selectPositionVal !="")
     {
        Load(selectPositionVal)
     }
  });

  function Load(selectPosition)
  {
    $('#selectOptionWeight').find('option').remove();
    //$("#selectOptionWeight").append("<option value=''>전체</option>");
    if(playerPosition == selectPosition)
    {
      for(var wi1=1; wi1 <= wRCnt1; wi1++)
      {
        $("#selectOptionWeight").append("<option value=" + wCodeArr1[wi1] + ">" + wNameArr1[wi1] + "</option>");
      }

    }
    else{
      for(var wi2=1; wi2 <= wRCnt2; wi2++)
      {
        $("#selectOptionWeight").append("<option value=" + wCodeArr2[wi2] + ">" + wNameArr2[wi2] + "</option>");
      }
    }
  }
</script>

<script type="text/javascript">
    // 첨부파일 관련
    var LCnt1 = Number("<%=LCnt1%>");
    //alert(LCnt1);

    var PSeq1 = "<%=PSeq1%>";
    var FileName1 = "<%=FileName1%>";
    var PSeq1arr = PSeq1.split("^");
    var FileName1arr = FileName1.split("^");
    
    function FileDel(i4, i5, i6) {
      //alert("i4:" + i4 )
      //alert("i5:" + i5 )
      //alert("i6:" +i6 )
      if (confirm("선택한 파일을 삭제 하시겠습니까?") == true) {

      	//alert(i4 + ", " + i5 + " , " + i6 + " , " + filetype);

        var strAjaxUrl = "../dev/dist/CommonFileDelete.asp";
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
            i4: i4,
            i5: i5,
      	    i6: i6,
						i7: "3"
          },
          success: function (retDATA) {
            alert(retDATA);
            if (retDATA == "1") {
              alert("해당 파일이 삭제 됐습니다.");
              $('#fileid_' + i4).remove();
            } else {
              alert("해당 파일이 없습니다.");
              $('#fileid_' + i4).remove();
            }
        
            $('#sFile_1').css('display', '');
        
          }, error: function (xhr, status, error) {
            if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
          }
        });

      }
      else {

      }
    }


    function FN_FileList(i) {
      var iHtmlPC1 = '<p>';
      iHtmlPC1 = iHtmlPC1 + '<p id=fileid_' + PSeq1arr[i] + '>';
      iHtmlPC1 = iHtmlPC1 + ' <span><a href="../FileDown/' + FileName1arr[i] + '">' + FileName1arr[i] + '</a></span>';
      iHtmlPC1 = iHtmlPC1 + ' <span><a href="javascript:;" onClick="javascript:FileDel(&#39;' + PSeq1arr[i] + '&#39;,&#39;' + FileName1arr[i] + '&#39;,&#39;' + iMSeq + '&#39;)" class="ex_btn">X</a></span>';
      iHtmlPC1 = iHtmlPC1 + '</p>';
      iHtmlPC1 = iHtmlPC1 + '</p>';
    	//alert(iHtmlPC1);
      $('#iFileDiv').prepend(iHtmlPC1);

    }
    
    // 파일갯수가 파일제한보다 많을땐 파일추가 부분 삭제
    if (LCnt1 > 0) {

    	for (var i = 1; i < LCnt1 + 1; i++) {
    			$('#sFile_1').css('display', 'none');
    			FN_FileList(i);
    	}
    }
    else {

    }
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
                document.getElementById('UserAddr').value = fullRoadAddr;
                document.getElementById('UserAddr').focus();
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

<%
 
  JudoKorea_DBClose() 
%>

</html>