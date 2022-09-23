<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  NowPage = fInject(Request("i2")) 
  ReqLocalVal = fInject(Request("i3"))     
  ReqOptionVal = fInject(Request("i4")) 
  ReqSearchVal= fInject(Request("i5"))
  iMSeq = fInject(Request("i1"))
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("i6")) 'iType 1 : 쓰기, 2: 수정
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
          iInsDateCv = LRs("InsDateCv")
          iName = LRs("Name")
          iLocal = LRs("Local")
          iTypeOption = LRs("TP_TypeOption")
          iLicenseNum = LRs("LicenseNum")
          iLicenseDate = LRs("LicenseDate")
        LRs.MoveNext
      Loop
    End IF
    LRs.close
    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then
      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      response.End
    End IF
  ELSE
   iYear =Year(Now) & "." & Month(Now) & "." & Day(Now)
  END IF
%>


<%
  Dim iCType : iCType = 1
  Dim Const_iCTypeLocal : Const_iCTypeLocal = "Local" 
  Dim Const_iCTypeOption : Const_iCTypeOption = "TP_TypeOption" 
  Dim CSubType : CSubType = "T00007" 
  Dim LName,LCode,LRCnt
  Dim TName,TCode,TRCnt

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
 
  iCType = 2
  LSQL = "EXEC CodePropertyName_Search_Type_STR " & "'" & iCType & "','" & Const_iCTypeOption & "'" & ",'" & CSubType & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  'Response.End
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      TName = TName & "^" & LRs("Name") & ""
      TCode = TCode & "^" & LRs("Code") & ""
      TRCnt = TRCnt + 1
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
  
  function Del_Link(i1, i2) 
  {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
      post_to_url('./Player_Inter_Judge_delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i1) {
    post_to_url('./Player_Inter_Judge.asp', { 'i1': i1 });
  }

function chk_frm(){
  if(!$('#selectTypeOption').val()){
      alert("구분을 선택해주세요.");
      $('#selectTypeOption').focus();
      return false;
  } 

  if(!$('#selectLocal').val()){
      alert("지역을 선택해주세요.");
      $('#selectLocal').focus();
      return false;
  } 
  
  if($('#iName').val().length < 2 || $('#iName').val().length > 10){
      alert("이름은 2자~10자입니다.");
      $('#iName').focus();
      return false;
  } 
   if(!$('#iLicenseNum').val()){
      alert("라이센스 번호를 입력해주세요.");
      $('#iLicenseNum').focus();
      return false;
  } 

   if(!$('#selectLicenseDate').val()){
      alert("취득일을 입력해주세요.");
      $('#selectLicenseDate').focus();
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

  $( document ).ready(function() {
    if(iType == 1)
  {
      var date = new Date();
      var day = date.getDate();
      var month = date.getMonth() + 1;
      var year = date.getFullYear();
      if (month < 10) month = "0" + month;
      if (day < 10) day = "0" + day;
      var today = year + "-" + month + "-" + day;       
      $("#selectLicenseDate").attr("value", today);
   
  }
  else{
    var licenseDate =toDate("<%=iLicenseDate%>")
    $("#selectLocal").val('<%=iLocal%>');
    $("#selectTypeOption").val('<%=iTypeOption%>');
   $("#selectLicenseDate").val(licenseDate);
  }

   
});

</script>

<section>
  <div id="content">
    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        팀/선수정보 > 팀/선수정보 > 국제심판
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Player_Inter_Judge_write_p.asp" method="post" >
        <table cellspacing="0" cellpadding="0" class="Community_wtite_box">
          <tr>
            <th>구분</th>
            <td>
              <span class="left_name">
                <select id="selectTypeOption" name="selectTypeOption" class="title_select">
                  <option value="">구분</option>
                </select>
              
              </span>
            </td>
          </tr>
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
            <th>이름</th>
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
          
          <% if iType = 2 then %>
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
            <th>자격증번호</th>
            <td colspan="2">
              <span class="right_con">
               <%
                IF iType = 1 Then 
                %>
                <input type="text" id="iLicenseNum" name="iLicenseNum" class="in_1"/>
                <%
                ELSE
                %>
                  <input type="text" id="iLicenseNum" name="iLicenseNum" value="<%=iLicenseNum%>"class="in_1"/>
                <%
                End IF
                %>
              </span>
            </td>
          </tr>
          <tr>
            <th>취득일</th>
            <td colspan="2">
              <span class="right_con">
             <%
                IF iType = 1 Then 
                %>
                <input type="text" name="selectLicenseDate" id="selectLicenseDate"  class="in_1 date_ipt"/>
                <%
                ELSE
                %>
                  <input type="text" name="selectLicenseDate" id="selectLicenseDate" class="in_1 date_ipt">
                <%
                End IF
                %>
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
  var lName = "<%=LName%>"
  var lCode = "<%=LCode%>"
  var lRCnt = "<%=LRCnt%>"
  var lNameArr = lName.split("^");
  var lCodeArr = lCode.split("^");

  for(var li=1; li <= lRCnt; li++)
  {
    $("#selectLocal").append("<option value=" + lCodeArr[li] + ">" + lNameArr[li] + "</option>");
  }


  var tName = "<%=TName%>"
  var tCode = "<%=TCode%>"
  var tRCnt = "<%=TRCnt%>"
  var tNameArr = tName.split("^");
  var tCodeArr = tCode.split("^");

  for(var ti=1; ti <= tRCnt; ti++)
  {
    $("#selectTypeOption").append("<option value=" + tCodeArr[ti] + ">" + tNameArr[ti] + "</option>");
  }
  

  function toDate(dateStr) {
    var parts = dateStr.split(".");
    return (parts[0] + "-" + parts[1] + "-" + parts[2]);
  }

</script>


<!--#include file="footer.asp"-->

<%
  JudoKorea_DBClose() 
%>

</html>