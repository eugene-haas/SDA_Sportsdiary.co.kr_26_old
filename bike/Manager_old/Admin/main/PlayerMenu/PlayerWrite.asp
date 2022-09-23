<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<link href="/css/modal/modal.css" rel="stylesheet" type="text/css" />
<%
    PTeamIDX  = request("PTeamIDX")
    enc_data  = request("enc_data")
    param_r1  = request("param_r1")
    param_r2  = request("param_r2")
    param_r3  = request("param_r3")
    UserName  = crypt.DecryptStringENC(request("UserName"))
    UserBirth = crypt.DecryptStringENC(request("UserBirth"))
    sDupInfo  = crypt.DecryptStringENC(request("sDupInfo"))
    sConnInfo = crypt.DecryptStringENC(request("sConnInfo"))
    UserPhone = crypt.DecryptStringENC(request("UserPhone"))
    AuthType  = request("AuthType")
    AuthYN    = request("AuthYN")
    Sex     = crypt.DecryptStringENC(request("Sex"))
  'Response.WRITE "PTeamIDX :" &PTeamIDX  &"<BR>"
  'Response.WRITE "enc_data :" &enc_data  &"<BR>"
  'Response.WRITE "param_r1 :" &param_r1  &"<BR>"
  'Response.WRITE "param_r2 :" &param_r2  &"<BR>"
  'Response.WRITE "param_r3 :" &param_r3  &"<BR>"
  'Response.WRITE "UserName :" &UserName  &"<BR>"
  'Response.WRITE "UserBirth  :" &UserBirth &"<BR>"
  'Response.WRITE "sDupInfo :" &sDupInfo  &"<BR>"
  'Response.WRITE "sConnInfo  :" &sConnInfo &"<BR>"
  'Response.WRITE "UserPhone  :" &UserPhone &"<BR>"
  'Response.WRITE "AuthType :" &AuthType  &"<BR>"
  'Response.WRITE "AuthYN   :" &AuthYN    &"<BR>"
  'Response.WRITE "Sex    :" &Sex   &"<BR>"
    
    If AuthType = "MOBILE" Then 
    AuthType_Nm = "휴대폰 안심 본인인증"
    Else
    AuthType_Nm = "아이핀 안심 본인인증"
    End If 
    
    If Sex = "0" Then 
    Sex_text = "여성"
    Else
    Sex_text = "남성"
    End If 

    'Response.write "PTeamIDX :"& PTeamIDX    &"<br>"
    'Response.write "enc_data :"&    enc_data   &"<br>"
    'Response.write "param_r1 :"&    param_r1   &"<br>"
    'Response.write "param_r2 :"&    param_r2   &"<br>"
    'Response.write "param_r3 :"&    param_r3   &"<br>"
    'Response.write "UserName :"&    UserName   &"<br>"
    'Response.write "UserBirth  :"&UserBirth    &"<br>"
    'Response.write "sDupInfo :"&    sDupInfo   &"<br>"
    'Response.write "sConnInfo  :"&sConnInfo    &"<br>"
    'Response.write "UserPhone  :"&UserPhone    &"<br>"
    'Response.write "AuthType :"&    AuthType   &"<br>"
    'Response.write "AuthYN   :"&AuthYN     &"<br>"

    'If UserName = "" Or UserBirth = "" Or sDupInfo = "" Then 
    'Response.write("<script language='javascript'>alert('실명인증 에러'); </script>")
    'Response.End 
    'End If 


    'CSQL = "   SELECT COUNT(*) AS CNT, Teamnm FROM tblPlayerTeamInfo "
    CSQL = "    select count(*)as cnt  from ( SELECT 0 AS CNT, Teamnm FROM tblPlayerTeamInfo "
    CSQL = CSQL & " WHERE DelYN = 'N' " 
    CSQL = CSQL & " AND DI = '"&sDupInfo&"' " 
    CSQL = CSQL & " group by Teamnm) a1  " 

    SET CRs_DI = DBcon.Execute(CSQL)
    
    if Not (CRs_DI.Eof Or CRs_DI.Bof) Then
    Do Until CRs_DI.Eof
    Club_cnt = CRs_DI("CNT")
    CRs_DI.MoveNext
    Loop
    End If
    CRs_DI.close
    
    CSQL = "    SELECT                "
    CSQL = CSQL & "    SidoIDX            "
    CSQL = CSQL & "   ,Sido             "
    CSQL = CSQL & "   ,SidoNm             "
    CSQL = CSQL & " FROM KoreaBadminton.DBO.tblSidoInfo "
    CSQL = CSQL & " WHERE DelYN = 'N' "
    CSQL = CSQL & " ORDER BY ORDERBYNUM ASC " 

    SET CRs = DBcon.Execute(CSQL)



  LSQL = " EXEC tblPlayerTeamInfo_VIEW"
  LSQL = LSQL  & "   @PTeamIDX  ='"& PTeamIDX &"' "
 ' Response.write LSQL
  Set LRs = DBcon.Execute(LSQL)
  
  if Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
      PTeamIDX        =LRs("PTeamIDX")
      PTeamGb       =LRs("PTeamGb")
      Team          =LRs("Team")
      TeamNm        =LRs("TeamNm")
      TeamEnNm        =LRs("TeamEnNm")
      ShortNm       =LRs("ShortNm")
      Sex         =LRs("Sex")
      sido          =LRs("sido")
      sidogugun       =LRs("sidogugun")
      ZipCode       =LRs("ZipCode")
      Address       =LRs("Address")
      AddrDtl       =LRs("AddrDtl")
      StadiumGb       =LRs("StadiumGb")
      CourtCnt        =LRs("CourtCnt")
      MemberCnt       =LRs("MemberCnt")
      Week          =LRs("Week")
    Monday_StartTime    =LRs("Monday_StartTime")
    Monday_EndTime    =LRs("Monday_EndTime")
    Tuesday_StartTime   =LRs("Tuesday_StartTime")
    Tuesday_EndTime   =LRs("Tuesday_EndTime")
    Wednesday_StartTime =LRs("Wednesday_StartTime")
    Wednesday_EndTime   =LRs("Wednesday_EndTime")
    Thursday_StartTime  =LRs("Thursday_StartTime")
    Thursday_EndTime    =LRs("Thursday_EndTime")
    Friday_StartTime    =LRs("Friday_StartTime")
    Friday_EndTime    =LRs("Friday_EndTime")
    Saturday_StartTime  =LRs("Saturday_StartTime")
    Saturday_EndTime    =LRs("Saturday_EndTime")
    Sunday_StartTime    =LRs("Sunday_StartTime")
    Sunday_EndTime    =LRs("Sunday_EndTime")
      TeamTel       =LRs("TeamTel")
      TeamFax       =LRs("TeamFax")
      TeamRegDt       =LRs("TeamRegDt")
      TeamEdDt        =LRs("TeamEdDt")
      EnterType       =LRs("EnterType")
      TeamLoginPwd      =LRs("TeamLoginPwd")
      SvcStartDt      =LRs("SvcStartDt")
      SvcEndDt        =LRs("SvcEndDt")
      DelYN         =LRs("DelYN")
    AdminAthleteCode    =LRs("AdminAthleteCode")
      AdminName       =LRs("AdminName")
      AdminSex        =LRs("AdminSex")
      AdminPhone      =LRs("AdminPhone")
      AdminBirhday      =LRs("AdminBirhday")
    AdminWriteDay     =LRs("AdminWriteDay")
    OwnerAthleteCode    =LRs("OwnerAthleteCode")
      OwnerName       =LRs("OwnerName")
      OwnerSex        =LRs("OwnerSex")
      OwnerPhone      =LRs("OwnerPhone")
      OwnerBirhday      =LRs("OwnerBirhday")
    OwnerWriteDay     =LRs("OwnerWriteDay")
      NowRegYN        =LRs("NowRegYN")
      EditDate        =LRs("EditDate")
      WriteDate       =Left(LRs("WriteDate"),10)    
      SidoNm        =LRs("SidoNm")
      GuGunNm       =LRs("GuGunNm")
      AthleteCode     =LRs("AthleteCode")
    User_WriteDate    =Left(LRs("User_WriteDate") ,10)
    MEMBER_CNT      =LRs("MEMBER_CNT")
    TeamContents      =LRs("TeamContents") 
  LRs.MoveNext
  Loop
  End If
  LRs.close 


  CSQL = "    SELECT GuGunIDX       "
  CSQL = CSQL & "     ,Sido         "
  CSQL = CSQL & "     ,GuGun        "
  CSQL = CSQL & "     ,GuGunNm        "
  CSQL = CSQL & "     ,GuGunNm_A      "
  CSQL = CSQL & "     ,GuGunNm_AS     "
  CSQL = CSQL & "     ,GuGunNm_B      "
  CSQL = CSQL & "     ,DelYN        "
  CSQL = CSQL & "     ,WriteDate      "
  CSQL = CSQL & " FROM dbo.tblGugunInfo   "
  CSQL = CSQL & " WHERE SIDO = '"&sido&"'   "
  
  SET CRs2 = DBcon.Execute(CSQL)

%>
<script src="../../js/jscolor.js"></script>
<script src="../../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
  /**
  * left-menu 체크
  */
  var locationStr = "PlayerMenu/PlayerTeaminfo";  // 대회
  /* left-menu 체크 */

  /**
   * 다음 우편번호 서비스
   */
  function execDaumPostCode() {

    var themeObj = {
       bgColor: "", //바탕 배경색
       searchBgColor: "#0B65C8", //검색창 배경색
       contentBgColor: "#fefefe", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
       pageBgColor: "#dedede", //페이지 배경색
       textColor: "#000", //기본 글자색
       queryTextColor: "#FFFFFF", //검색창 글자색
       //postcodeTextColor: "#000", //우편번호 글자색
       //emphTextColor: "", //강조 글자색
       //outlineColor: "" //테두리
    };

    var width = 500;
    var height = 600;

    new daum.Postcode({
      width: width,
      height: height,
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
        document.getElementById('ZIPCODE').value = data.zonecode; //5자리 새우편번호 사용
    document.getElementById('ADDRESS').value = fullRoadAddr;
        // document.getElementById('ADDRDTL').value = data.jibunAddress;
        document.getElementById('ADDRDTL').focus();
    
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
      },
      theme: themeObj
    }).open({
      popupName: 'postcodePopup', //팝업 이름을 설정(영문,한글,숫자 모두 가능, 영문 추천)
      left: (window.screenLeft) + (document.body.clientWidth / 2) - (width / 2),
      top: (window.screen.height / 2) - (height / 2)
    });
  }

  function fnOnlyNumber_zero()
  {
    document.getElementById("CourtCnt").value = document.getElementById("CourtCnt_ex").value;
  
  }

  function fnOnlyNumber(my) //숫자만 입력받는다
  {
    
    if ((event.keyCode < 48) || (57 < event.keyCode)) 
    {
      alert('숫자만 입력 가능합니다.');
      setTimeout("fnOnlyNumber_zero()",100);
      return;
    }
    document.getElementById("CourtCnt_ex").value  = document.getElementById("CourtCnt").value
  }

  function sido_gubun_search(this_is)
  {
    //return;
    var strAjaxUrl = "/Ajax/enroll/ClubGubun.asp?sido="+escape(this_is.value);
    //location.href = strAjaxUrl
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
      },
      success: function (retDATA) {
        if (retDATA) {
        $('#sidogugun_div').html(retDATA);
        } else {
        $('#sidogugun_div').html("");
        }
      }, error: function (xhr, status, error) {
        if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
      }
    });
  }


  function club_search_ch_click(MemberIDX)
    {
    document.getElementById("club_search_ch").value = MemberIDX;
    }

  function Club_Admin_Open(PTeamIDX,MasterGB,Page)
  {
  <% if MEMBER_CNT = "0" then %>
    alert('등록된 사용자가 없습니다.');
    return;
  <% end if %>
    //$("#AdminDEtail").modal();
    var SearchKeyWord = $("#SearchKeyWord").val();
    var strAjaxUrl = "../../Ajax/Enroll/Admindetail.asp"
    $.ajax(
    {
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: 
      {
         PTeamIDX : PTeamIDX
        ,SearchKeyWord  : SearchKeyWord
    ,MasterGB : MasterGB
    ,Page   : Page
      },
      success: function (retDATA) {
      if (retDATA) 
      {
        document.getElementById("Admin_detail_dev").innerHTML = retDATA;
        $('#Admin_detail').modal();
      } 
      else 
      {
        $('#Admin_detail_dev').html("");
      }
      }, error: function (xhr, status, error) 
      {
        if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
      }
    });

  }


  
  function Club_Admin_Open2(PTeamIDX,MasterGB,Page)
  {
    //$("#AdminDEtail").modal();
    document.getElementById('club_search_ch').value=""
    var SearchKeyWord = $("#SearchKeyWord").val()
    var strAjaxUrl = "../../Ajax/Enroll/Admindetail_sub.asp"
    $.ajax(
    {
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: 
      {
         PTeamIDX : PTeamIDX
        ,SearchKeyWord  : SearchKeyWord
    ,MasterGB : MasterGB
    ,Page   : Page
      },
      success: function (retDATA) {
      if (retDATA) 
      {
        
        document.getElementById("mater_detail_sub").innerHTML = retDATA;
      } 
      else 
      {
        $('#Admin_detail_dev').html("");
      }
      }, error: function (xhr, status, error) 
      {
        if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
      }
    });
  }





  function Admin_update(gubun)
  {
    var MemberIDX = document.getElementById('club_search_ch').value;
    if ( document.getElementById('club_search_ch').value =='')
    {
      alert('동호인을 선택해 주시기 바랍니다');
      return;
    }
  
  if (gubun=='1')
    {
      gubun = "Admin";
      
      

      document.getElementById('AdminMemberIDX').value       = document.getElementById('AdminMemberIDX_'+MemberIDX).value  
      document.getElementById('AdminName').value          = document.getElementById('AdminName_'+MemberIDX).value  
      document.getElementById('AdminSex').value         = document.getElementById('AdminSex_'+MemberIDX).value  
      document.getElementById('AdminPhone').value         = document.getElementById('AdminPhone_'+MemberIDX).value  
      document.getElementById('AdminBirhday').value       = document.getElementById('AdminBirhday_'+MemberIDX).value  
      
      document.getElementById('AdminName_Div').innerHTML      = document.getElementById('AdminName_'+MemberIDX).value  

      if (document.getElementById('AdminSex_'+MemberIDX).value  == 'Man')
      {
        document.getElementById('AdminSex_Div').innerHTML   = "남성" 
      }
      else
      {
        document.getElementById('AdminSex_Div').innerHTML   = "여성" 
      }
      

      document.getElementById('AdminAthleteCode_Div').innerHTML = document.getElementById('AthleteCode_'+MemberIDX).value  
      document.getElementById('Adminphone_Div').innerHTML     = document.getElementById('AdminPhone_'+MemberIDX).value  
      document.getElementById('AdminWriteDay_Div').innerHTML    = "<%=date%>"

    }
  else
    {
      document.getElementById('OwnerMemberIDX').value       = document.getElementById('AdminMemberIDX_'+MemberIDX).value  
      document.getElementById('OwnerName').value          = document.getElementById('AdminName_'+MemberIDX).value  
      document.getElementById('OwnerSex').value         = document.getElementById('AdminSex_'+MemberIDX).value  
      document.getElementById('OwnerPhone').value         = document.getElementById('AdminPhone_'+MemberIDX).value  
      document.getElementById('OwnerBirhday').value       = document.getElementById('AdminBirhday_'+MemberIDX).value  
      
      document.getElementById('OwnerName_Div').innerHTML      = document.getElementById('AdminName_'+MemberIDX).value              
      if (document.getElementById('AdminSex_'+MemberIDX).value  == 'Man')
      {
        document.getElementById('OwnerSex_Div').innerHTML   = "남성" 
      }
      else
      {
        document.getElementById('OwnerSex_Div').innerHTML   = "여성" 
      }
      
      document.getElementById('OwnerAthleteCode_Div').innerHTML = document.getElementById('AthleteCode_'+MemberIDX).value  
      document.getElementById('Ownerphone_Div').innerHTML     = document.getElementById('AdminPhone_'+MemberIDX).value  
      document.getElementById('OwnerWriteDay_Div').innerHTML    = "<%=date%>"

    }
  $('#Admin_detail').modal('hide');
  }

  function OK_Link()
  {
    var result = confirm("클럽정보를 수정하시겠습니까?");
        if(result)
          {
      //document.s_frm.action ="PlayerWrite_p.asp"
      document.s_frm.submit();
      }
  }

</script>
<!-- S : content -->

<section>
  <div id="content">
    
    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: 네비게이션 -->
      <div class="navigation_box"> 생활체육관리 > 클럽리스트</div>
      <!-- E: 네비게이션 -->
      <form id="s_frm" name="s_frm" action="./PlayerWrite_p.asp" method="post">
        <input type="hidden" id="PTeamIDX" name="PTeamIDX" value="<%=PTeamIDX%>">
        <input type="hidden" id="club_search_ch">
        <input type="hidden" id="AdminMemberIDX" name="AdminMemberIDX"> 
        <input type="hidden" id="AdminName"    name="AdminName">      
        <input type="hidden" id="AdminSex"     name="AdminSex">       
        <input type="hidden" id="AdminAthleteCode"  name="AdminAthleteCode">       
        <input type="hidden" id="AdminPhone"   name="AdminPhone">     
        <input type="hidden" id="AdminBirhday"   name="AdminBirhday">   
        <input type="hidden" id="OwnerMemberIDX" name="OwnerMemberIDX"> 
        <input type="hidden" id="OwnerName"    name="OwnerName">      
        <input type="hidden" id="OwnerSex"     name="OwnerSex">       
        <input type="hidden" id="OwnerPhone"   name="OwnerPhone">     
        <input type="hidden" id="OwnerBirhday"   name="OwnerBirhday">   
        <table border="1" cellspacing="0" cellpadding="0" class="Community_wtite_box">
          <tr>
            <th>클럽 등록일</th>
            <td>
              <%=WriteDate%>
            </td>
            <th>클럽명</th>
            <td >
              <%=TeamNm%>
            </td>
            <th>팀코드</th>
            <td >
              <%=Team%>
            </td>
          </tr>

        </table>
        <br>
        <table border="1" cellspacing="0" cellpadding="0" class="Community_wtite_box">
          <tr>
            <th>시/도</th>
            <td colspan="2">
              <div class="sel_box">
                <select  id="sido" name="sido" onchange="javascript:sido_gubun_search(this);"  class="title_select">
                  <option value="">소속 시/도를 선택해주세요</option>
                  <%
                  if Not (CRs.Eof Or CRs.Bof) Then
                  Do Until CRs.Eof
                  %>
                  <option value="<%=CRs("Sido")%>" <% If sido = CRs("sido") Then %> selected<% End If %>><%=CRs("SidoNm")%></option>
                  <%
                  CRs.MoveNext
                  Loop
                  End If
                   
                  CRs.close
                  %>
                </select>
              </div>
            </td>
          </tr>

          <tr>
            <th>구/군</th>
            <td colspan="2">
              <div class="sel_box" id="sidogugun_div">
                <select id="sidogugun" name="sidogugun" class="title_select">
                  <option>소속 구/군를 선택해주세요</option>
                  <%
                  if Not (CRs2.Eof Or CRs2.Bof) Then
                  Do Until CRs2.Eof
                  %>
                  <option value="<%=CRs2("Gugun")%>" <% If sidogugun = CRs2("Gugun") Then %> selected<% End If %>><%=CRs2("GuGunNm")%></option>
                  <%
                  CRs2.MoveNext
                  Loop
                  End If
                   
                  CRs2.close
                  %>
                </select>
              </div>
            </td>
          </tr>

          <tr>
            <th>클럽명</th>
            <td colspan="2">
              <span class="right_con">
                <input type="text"  id="TeamNm"  name="TeamNm"  placeholder="클럽명을 입력해주세요" maxlength="50" style="width:300px;" value="<%=TeamNm%>">
              </span>
            </td>
          </tr>
          <tr>
            <th>주소</th>
            <td >             
              <input type="text"  id="ZIPCODE" name="ZIPCODE" style="width:80px;" value="<%=ZipCode%>" readonly>
              <a href="#" onclick="execDaumPostCode();event.preventDefault();"> 
                우편번호검색
              </a>
              <input type="text" id="ADDRESS" name="ADDRESS"  placeholder="우편번호검색을 눌러 주세요" maxlength="100" style="width:380px;"  value="<%=Address%>" readonly>
              <input type="text" id="ADDRDTL" name="ADDRDTL" placeholder="상세주소 입력" maxlength="100" style="width:380px;" value="<%=AddrDtl%>">
            </td>
          </tr>
          <tr>
            <th>운동장소</th>
            <td >             
              <select id="StadiumGb" name="StadiumGb" class="title_select">
                <option value="">운동장소선택</option>
                <option value="실내운동" <% If StadiumGb = "실내운동" Then %>selected<% End If %>>실내운동</option>
                <option value="실외운동" <% If StadiumGb = "실외운동" Then %>selected<% End If %>>실외운동</option>
              </select>
            </td>
          </tr>
                    <tr>
                      <th>코트 수</th>
                      <td>
            <select id="CourtCnt" name="CourtCnt" class="title_select">
              <% For i = 1 To 99 %>
                <option value="<%=i%>" <% If CLng(CourtCnt) = CLng(i) Then %> selected<% End If %>><%=i%></option>
              <% Next %>
            </select>
                      </td>
                    <tr>
                      <th>인원 수</th>
                      <td>
            <select id="MemberCnt" name="MemberCnt" class="title_select">
              <% For i = 1 To 99 %>
                <option value="<%=i%>" <% If CLng(MemberCnt) = CLng(i) Then %> selected<% End If %>><%=i%></option>
              <% Next %>
            </select>
                      </td>
                    </tr>
                  <tr class="active_day">
                    <th>클럽내용<br>
            클럽시간[월~금 : 10:00 ~ 23:00]
            
          </th>
                    <td>
            <textarea name="TeamContents" id="TeamContents" style="width:700px;"><%=TeamContents%></textarea>
                    </td>
                  </tr>
                  <!-- E: 클럽활동 요일 / 시간 -->
        </table>
        <br>
        클럽등록 / 관리자 정보
        <table border="1" cellspacing="0" cellpadding="0" class="Community_wtite_box">
          <tr>
            <th>이름</th>
            <td colspan="2">
              <label style="float:left;" id="AdminName_Div">
                <%=AdminName%>
              </label>&nbsp;&nbsp;
              <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="클럽 관리자 변경" onclick="javascript:Club_Admin_Open('<%=PTeamIDX%>','Admin');;" style="cursor:pointer; margin-left:10px;" />
            </td>
          </tr>
          <tr>
            <th>성별</th>
            <td colspan="2">
              <label  id="AdminSex_Div">
               <%= AdminSex%>
              </label>
            </td>
          </tr>
          <tr>
            <th>동호인 번호</th>
            <td colspan="2">
              <label  id="AdminAthleteCode_Div">
               <%=AdminAthleteCode%>
              </div>
            </td>
          </tr>
          <tr>
            <th>휴대폰 번호</th>
            <td colspan="2">
              <label id="Adminphone_Div">
               <%=Adminphone%>
              </div>
            </td>
          </tr>
          <tr>
            <th>관리자 등록일</th>
            <td colspan="2">
              <label id="AdminWriteDay_Div">
              <%=AdminWriteDay%>
              </div>
            </td>
          </tr>
                  <!-- E: 클럽활동 요일 / 시간 -->
        </table>
        <br>
        클럽장정보
        <table border="1" cellspacing="0" cellpadding="0" class="Community_wtite_box">
          <tr>
            <th>이름</th>
            <td colspan="2">
              <label style="float:left;" id="OwnerName_Div">
              <%=OwnerName%>
              </label>&nbsp;&nbsp;
              <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="클럽장 변경" onclick="javascript:Club_Admin_Open('<%=PTeamIDX%>','Owner');" style="cursor:pointer; margin-left:10px;" />
            </td>
          </tr>
          <tr>
            <th>성별</th>
            <td colspan="2">
              <label  id="OwnerSex_Div">
               <%= OwnerSex%>
              </label>
            </td>
          </tr>
          <tr>
            <th>동호인 번호</th>
            <td colspan="2">
              <label  id="OwnerAthleteCode_Div">
               <%=OwnerAthleteCode%>
              </label>
            </td>
          </tr>
          <tr>
            <th>휴대폰 번호</th>
            <td colspan="2">
              <label  id="Ownerphone_Div">
               <%=Ownerphone%>
              </label>
            </td>
          </tr>
          <tr>
            <th>관리자 등록일</th>
            <td colspan="2">
              <label  id="OwnerWriteDay_Div">
                <%=OwnerWriteDay%>
              </label>
            </td>
          </tr>
                  <!-- E: 클럽활동 요일 / 시간 -->
        </table>
        <div class="btn_list">
          <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
          <input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript:history.back();" style="cursor:pointer" />

          <input type="hidden" id="iAdminMemberIDX" name="iAdminMemberIDX" value="<%=iAdminMemberIDX %>" />
          <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
          <input type="hidden" id="iName" name="iName" value="<%=Name %>" />
          <input type="hidden" id="iID" name="iID" value="<%=iUserID %>" />
          <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
        </div>
    </form>

    </div>
    <!-- E : 내용 시작 -->
  </div>
<section>
<!--#include file="../../Include/footer.asp"-->
<form name="Search_form">
    <div id="Admin_detail_dev">
    <input type="hidden" id="SearchKeyWord" name="SearchKeyWord">
    </div>
  </form>
  <div id="Member_detail_dev">
  </div>
</html>
<script>
  var oEditors = [];
  
  nhn.husky.EZCreator.createInIFrame({
    oAppRef: oEditors,
    elPlaceHolder: "TeamContents",
    sSkinURI: "../../dev/dist/se2_img/SmartEditor2Skin.html",
    fCreator: "createSEditor2"
  });

  
  $( document ).ready(function() {
    
    //팝업 하단 닫기 영역 기본컬러 SET
    if(!$("#PDailyBgColor").val()) $("#PDailyBgColor").val('222222');
    if(!$("#PDailyTxtColor").val()) $("#PDailyTxtColor").val('FFFFFF');
    //팝업 BgColor, Border, Color
    if(!$("#PBgColor").val()) $("#PBgColor").val('FFFFFF');
    if(!$("#PBorderColor").val()) $("#PBorderColor").val('BBBBBB');
    if(!$("#PBorder").val()) $("#PBorder").val('3');
  });
</script>
