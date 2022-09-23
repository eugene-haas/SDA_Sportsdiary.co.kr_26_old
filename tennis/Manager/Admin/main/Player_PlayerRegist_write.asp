<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  NowPage = fInject(Request("i1")) 
  ReqLocalVal = fInject(Request("i2"))     
  ReqDivisionVal = fInject(Request("i3")) 
  ReqOptionVal = fInject(Request("i4")) 
  ReqTeamNameVal= fInject(Request("i5"))
  iMSeq = fInject(Request("i6"))
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("i7")) 'iType 1 : 쓰기, 2: 수정
  'Cookie 값 가져오기 
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  LCnt = 0
  LCnt1 = 0
  if(NowPage = 0) Then NowPage = 1
  if(iType = 0) Then iType = 1
  IF (iType = 2) Then
    LSQL = "EXEC TeamPlayer_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          LCnt = LCnt + 1
          iTeamName = LRs("TeamName")
          iInsDateCv = LRs("InsDateCv")
          iCoachName = LRs("CoachName")
          iLeaderName = LRs("LeaderName")
          iWeight = LRs("TP_Weight")
          iName = LRs("Name")
          iAddress = LRs("Address")
          iPhone = LRs("Phone")
          iLocalName = LRs("Local")
          iTypeOptionName = LRs("TP_TypeOption")
          iDivisionName = LRs("TP_Division")
          iUserAddr = LRs("Address")
          iYear = LRs("TP_Year")
        LRs.MoveNext
      Loop
    End IF
    LRs.close
    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then
      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      response.End
    End IF
  End IF
%>

<%
  Dim LSQL 'sqlQuery
  Dim iCType : iCType = 1
  Dim Const_iCTypeLocal,Const_iCTypeDivision,Const_iCTypeTypeOptionSex
  Dim LName,LCode,LRCnt,DName,DCode,DRCnt,OName,OCode,ORCnt
  Const_iCTypeLocal = "Local" 
  Const_iCTypeDivision ="TP_Division"
  Const_iCTypeTypeOptionSex = "TP_TypeOption_Sex"
  Const_iCTypeWeightDivision = "WeightDivision"
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeLocal & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      LRCnt = LRCnt + 1
      LName = LName & "^" & LRs("Name") & ""
      LCode = LCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeTypeOptionSex & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      ORCnt = ORCnt + 1
      OName = OName & "^" & LRs("Name") & ""
      OCode = OCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeDivision & "','" & "'"
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

  WExceptCode = "W00001"
  LSQL = "EXEC CodePropertyName_Search_Type_STR " & "'" & iCType & "','" & Const_iCTypeWeightDivision & "'" & ",''"
  'JudoTitleWriteLine "LSQL", LSQL
  'Response.ENd
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
      IF(LRs("Code") <> WExceptCode) Then
        WRCnt = WRCnt + 1
        WName = WName & "^" & LRs("Name") & ""
        WCode = WCode & "^" & LRs("Code") & ""
      End IF
      LRs.MoveNext
      Loop
  End If
  LRs.close
  

%>

<script type="text/javascript">
  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");
  
  function Del_Link(i1, i2) 
  {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Player_PlayerRegist_delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i1) {
  	post_to_url('./Player_PlayerRegist.asp', { 'i1': i1 });
  }

function chk_frm(){
  if(!$('#iTeamName').val()){
      alert("팀명을 입력해 주세요.");
      $('#iTeamName').focus();
      return false;
  } 
  
  if($('#iTeamName').val().length < 2 || $('#iTeamName').val().length > 10){
      alert("팀명은 2자~10자입니다.");
      $('#iTeamName').focus();
      return false;
  }	
   if(!$('#selectLocal').val()){
      alert("지역을 선택해주세요.");
      $('#selectLocal').focus();
      return false;
  } 
   if(!$('#selectYear').val()){
      alert("년도를 선택해주세요.");
      $('#selectYear').focus();
      return false;
  } 
   if(!$('#selectDivision').val()){
      alert("구분 값을 선택해주세요.");
      $('#selectDivision').focus();
      return false;
  } 
   if(!$('#selectOptionSex').val()){
      alert("팀 성별을 선택해주세요.");
      $('#selectOptionSex').focus();
      return false;
  } 
  return true;
}
  function OK_Link() {
    if(chk_frm())
    {
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
        팀/선수정보 > 팀/선수정보 > 선수등록현황
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Player_PlayerRegist_write_p.asp" method="post" >
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr>
            <th>팀명</th>
						<td>
							<span class="left_name">
                <%
                IF iType = 1 Then 
                %>
                <input type="text" id="iTeamName" name="iTeamName" class="in_1"/>
                <%
                ELSE
                %>
                  <input type="text" id="iTeamName" name="iTeamName" value="<%=iTeamName%>" class="in_1"/>
                <%
                End IF
                %>
							</span>
						</td>
					</tr>
          <tr>
            <th>선수명</th>
						<td>
							<span class="left_name">
                <%
                IF iType = 1 Then 
                %>
                <input type="text" id="iName" name="iName" class="in_1"/>
                <%
                ELSE
                %>
                  <input type="text" id="iName" name="iName" value="<%=iName%>"class="in_1"/>
                <%
                End IF
                %>
							</span>
						</td>
					</tr>
          <tr>
            <th>체급</th>
						<td>
							<span class="left_name">
               <select id="selectOptionWeight" name="selectOptionWeight" class="title_select">
                <option value="">체급</option>
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
            <th>지역</th>
						<td colspan="2">
							<span class="right_con">
								 <select id="selectLocal" name="selectLocal" class="title_select">
                  <option value="">시/도</option>
                </select>
							</span>
						</td>
					</tr>
					<tr>
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
					<tr>
            <th>구분</th>
						<td colspan="2">
							<span class="right_con">
                <select id="selectDivision" name="selectDivision" class="title_select">
                  <option value="">구분</option>
                </select>
							</span>
						</td>
					</tr>
					<tr>
            <th>성별</th>
						<td colspan="2">
							<span class="right_con">
							 <select id="selectOptionSex" name="selectOptionSex" class="title_select">
                  <option value="">성별</option>
                </select>
							</span>
						</td>
					</tr>
				</table>
				<div class="btn_list">
					<input type="button" id="btnOK" name="btnOK" class="btn_del" value="삭제" onclick="javascript: Del_Link('<%=iMSeq %>', '<%=NowPage %>')" style="cursor:pointer" />
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
  var lName = "<%=LName%>"
  var lCode = "<%=LCode%>"
  var lRCnt = "<%=LRCnt%>"
  var lNameArr = lName.split("^");
  var lCodeArr = lCode.split("^");

  for(var li=1; li <= lRCnt; li++)
  {
    $("#selectLocal").append("<option value=" + lCodeArr[li] + ">" + lNameArr[li] + "</option>");
  }

  var dName = "<%=DName%>"
  var dCode = "<%=DCode%>"
  var dRCnt = "<%=DRCnt%>"
  var dNameArr = dName.split("^");
  var dCodeArr = dCode.split("^");

  for(var di=1; di <= dRCnt; di++)
  {
    $("#selectDivision").append("<option value=" + dCodeArr[di] + ">" + dNameArr[di] + "</option>");
  }

  var oName = "<%=OName%>"
  var oCode = "<%=OCode%>"
  var oRCnt = "<%=ORCnt%>"
  var oNameArr = oName.split("^");
  var oCodeArr = oCode.split("^");

  for(var oi=1; oi <= oRCnt; oi++)
  {
    $("#selectOptionSex").append("<option value=" + oCodeArr[oi] + ">" + oNameArr[oi] + "</option>");
  }
   
  var wName = "<%=WName%>"
  var wCode = "<%=WCode%>"
  var wRCnt = "<%=WRCnt%>"
  var wNameArr = wName.split("^");
  var wCodeArr = wCode.split("^");

  for(var wi=1; wi <= wRCnt; wi++)
  {
    $("#selectOptionWeight").append("<option value=" + wCodeArr[wi] + ">" + wNameArr[wi] + "</option>");
  }


  if(iType == 1)
  {
      //$("#selectLocal option")[1].selected = true;
      //$("#selectDivision option")[1].selected = true;
      //$("#selectOptionSex option")[1].selected = true;
      $("#selectYear option")[2].selected = true;
  }
  else{
    $("#selectLocal").val('<%=iLocalName%>');
    $("#selectDivision").val('<%=iDivisionName%>');
    $("#selectOptionSex").val('<%=iTypeOptionName%>');
    $("#selectOptionWeight").val('<%=iWeight%>')
    $("#selectYear").val('<%=iYear%>');
    $("#iPhoneNum").val(autoHypenPhone("<%=iPhone%>"));
  }

</script>


<!--#include file="footer.asp"-->

<%
 
  JudoKorea_DBClose() 
%>

</html>