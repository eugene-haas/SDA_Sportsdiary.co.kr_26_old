<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file='./include/config.asp' -->
  <%

      '푸시설정페이지
      '로그인 되었다면 index.asp로 이동
      Check_Login()

      dim SD_UserID   : SD_UserID = request.Cookies("SD")("UserID")
      iUid = Request.Cookies("SD")("UserID")
      iMost = Request("iMost")     

       CodeGroup = ""
       iType  = "3"

       LSQL = "EXEC Favor_R '" & iType & "','" & iLIMemberIDXG & "','" & CodeGroup & "','','','',''"
       'response.Write "LSQL="&LSQL&"<br>"
       'response.End
       
       Set LRs = DBCon3.Execute(LSQL)
       If Not (LRs.Eof Or LRs.Bof) Then
         Do Until LRs.Eof
          
          iCode01s = iCode01s + "^" + LRs("Code01")

	    		LRs.MoveNext
	    	Loop
        End If
         LRs.close
         
         'iCode01s = "tennis"

  %>
  <%
   CodeGroup = ""
       iType  = "4"
  
       LSQL = "EXEC Favor_R '" & iType & "','" & iLIMemberIDXG & "','" & CodeGroup & "','','','',''"
       'response.Write "LSQL="&LSQL&"<br>"
       'response.End
       
       Set LRs = DBCon3.Execute(LSQL)
       If Not (LRs.Eof Or LRs.Bof) Then
         Do Until LRs.Eof
          
          iiCode01s =  LRs("Code01")
          

	    		LRs.MoveNext
	    	Loop
        End If
         LRs.close
         
         'iCode01s = "tennis"
  %>
  <script type="text/javascript">

      
      /*
      ================================================================================================
      푸시설정 관련
      judo.sportsdiary.co.kr/M_Player/include/gnb.asp         //앱알림 설정페이지
      judo.sportsdiary.co.kr/M_Player/ajax/PushAgreeYN.asp    //앱알림 수신동의 설정 업데이트 페이지
      judo.sportsdiary.co.kr/M_Player/ajax/PushAgree_Fnd.asp  //앱알림 수신동의 설정값 조회하여 Radio button checked처리
      judo.sportsdiary.co.kr/M_Player/ajax/PushSET_Identity.asp  //기기식별자 등록 쿠키조회하여 자동등록처리
      ================================================================================================
      */
    console.log(navigator.userAgent.indexOf("isAppVer=2.0"));
    //푸시 YN 체크 ajax
       function PushAgreeYN(str) {

         console.log(str);

         var strAjaxUrl = "./Ajax/PushAgreeYN.asp";
         var strmessage = "";
         var strtype = "";

         $.ajax({
           url: strAjaxUrl,
           type: 'POST',
           dataType: 'html',
           data: {
             UserID: '<%=SD_UserID%>',
             AgreeYN: str
           },
           success: function (retDATA) {

             var retarr = retDATA.split('|');

             console.log(retDATA);

             if (retarr[0] == "TRUE") {
               alert(retarr[3].replace(/n/gi, "\n"));
             }

           },
           error: function (xhr, status, error) {
             if (error != "") {
               alert("오류발생! - 시스템관리자에게 문의하십시오!");
               return;
             }
           }
         });

       }

         //IN App에서 푸시동의[Y|N] 설정 이 후 웹으로 업데이트 호출합니다.(푸시동의 기기설정)
        function PushrcvAgree(str_agreeYN, str_datetime){
          //alert("DB입력값 [수신여부:" + str_agreeYN + ", 날짜:" + str_datetime + " ]");

          PushAgreeYN(str_agreeYN);
        }
    
       iCode01s = "<%=iCode01s%>"
       iCode01sArr = iCode01s.split("^");

         //관심종목 데이터 조회하여 checked
          $(document).ready(function () {
      
            for (var i = 1; i < iCode01sArr.length + 1; i++) {
      
              $("input:checkbox[name='check']:checkbox[value='" + iCode01sArr[i] + "']").attr("checked", true);
      
            }
      
          });

         $(document).ready(function () {

         $("input:checkbox[name ='check']:checkbox[value='" + iMost + "']").attr("checked", true);

     
         });

          //우선순위 고른 값 check 불가능
        $(document).ready(function () {

          $("input:checkbox[name ='check']:checkbox[value='" + iMost + "']").attr("disabled", true);
                  
        });
    

        //푸시수신동의 데이터 조회 하여 check btn checked
       function PushAgreeFnd(){
         var strAjaxUrl = './Ajax/PushAgree_Fnd.asp';
       
         $.ajax({
             url: strAjaxUrl,
             type: 'POST',
             dataType: 'html',
             data: {
               UserID : '<%=SD_UserID%>'
             },
             success: function(retDATA) {
       
               console.log(retDATA);
       
               if(retDATA){
                 var strcut = retDATA.split('|');
       
                 if (strcut[0] == 'TRUE') {
                   switch(strcut[1]){
                       case 'Y' : $('input[name=PushAgreeYN]').eq(0).prop('checked', true); break;  //수신동의
                       case 'N' : $('input[name=PushAgreeYN]').eq(1).prop('checked', true); break;  //수신거부
                       default  : $('input[name=PushAgreeYN]').eq(0).prop('checked', false); $('input[name=PushAgreeYN]').eq(1).prop('checked', false); //미설정된 상태
                   }
                 }
                 else{  //FALSE|
                   var msg = '';
       
                   switch (strcut[1]) {
                     case '99'   : msg = '일치하는 회원정보 - 없습니다.\n확인 후 다시 이용하세요.'; break;1
                     default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
                   }
                   alert(msg);
                   return;
                 }
               }
             },
             error: function (xhr, status, error) {
               if(error!=''){
                 alert ('오류발생! - 시스템관리자에게 문의하십시오!');
                 return;
               }
             }
         });
       }
       //알림선택 YN값
        $(document).ready(function () {
          $("#PushAgreeYNY").change(function () {
           
            if ($('input:checkbox[id=PushAgreeYNY]').is(':checked') == false) {

              $('[id=PushAgreeYNY]').attr('value', 'N');

              //alert('N')
              PushAgreeYN('N');
            }
            else {
              $('[id=PushAgreeYNY]').attr('value', 'Y');
              //alert('Y')
              PushAgreeYN('Y');
            }
          });
        });     
      
        $(document).ready(function(){
         //푸시수신동의 설정값 조회하여 Radio btn checked
         PushAgreeFnd();
        });

          iLIMemberIDXG = "<%=iLIMemberIDXG%>";
          iUid = "<%=iUid%>";
          iMost = "<%=iiCode01s%>"

      //체크박스 체크 할때마다 처리 ajax
       $(document).ready(function () {
        
          $('input[name="check"]').click(function () {
            var items = [];
            $('input[name="check"]:checkbox:checked').each(function () { items.push($(this).val()); });
            var tmp = items.join('^');
            var cnt = $("input[name=check]:checkbox:checked").length;
       
             if (cnt < 1) {

              alert('다른 관심종목을 선택 후 클릭해 주세요.');
               location.href = "http://sdmain.sportsdiary.co.kr/sdmain/PushSetting_dev.asp";
            }
          else  if ($('input[name="check"]').is(':checked') == true) {
              try {
       
                var strAjaxUrl = "./Ajax/fav_p.asp";
       
       
                $.ajax({
                  url: strAjaxUrl,
                  type: 'post',
                  data: {
       
                    tmp: tmp,
                    iLIMemberIDXG: iLIMemberIDXG,
                    iUid: iUid,
                   iMost: iMost
                  },
       
                  dataType: 'html',
                  success: function (retDATA) {
       
                if (retDATA != "Y") {
                  alert('관심종목 등록에 실패했습니다. 다시 선택 해주세요.');
                  location.href = "http://sdmain.sportsdiary.co.kr/sdmain/interested_category.asp";
                }
                else {
                  alert("등록에 성공했습니다");
                  post_to_url('./PushSetting_dev.asp', { 'Most' : iMost });
                }
       
              }, error: function (xhr, status, error) {
                if (error != "") {
                  alert("오류발생! - 시스템관리자에게 문의하십시오!");
                  return;
                }
              }
              });
                
	     	     } catch (e) { }
	     	     }
	     	      else {
	     	  
            }
                 
            });
       
       });
  
      //우선 순위 데이터는 체크 박스 불가능
            
       $(document).ready(function () {

         $("input:checkbox[name ='check']:checkbox[value='" + iMost + "']").attr("checked", true);

       
       });
      
      
       $(document).ready(function () {

         $("input:checkbox[name ='check']:checkbox[value='" + iMost + "']").attr("disabled", true);

       
       });
    

              

           
     /*================================================================================================*/
  </script>
</head>

<body>
<div class="l pushSetting m_bg_f2f2f2">
  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">앱 알림 수신 설정</h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>
  </div>
  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_boardDeep">

      <h3 class="m_boardDeep__tit">
        알림설정
        <label class="m_switch"><input type="checkbox" name="PushAgreeYN" id="PushAgreeYNY" class="m_switch__checkbox" hidden /><span class="m_switch__slider">알림선택</span></label>
      </h3>

      <table class="pushTermTbl">
        <tbody>
          <tr>
            <th>항목</th><td>모바일 앱 마케팅 알림 동의</td>
          </tr>
          <tr>
            <th>이용목적</th><td>대회일정/결과, 대진표, 실시간 경기진행현황 및 이벤트 등에 대한 정보를 수신 받을 수 있습니다.</td>
          </tr>
          <tr>
            <th>보유기간</th><td>별도 동의 철회 시까지 또는 약관 철회 후 1주일 까지</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="m_boardDeep">
      <h3 class="m_boardDeep__tit">관심종목설정</h3>

      <ul class="categoryList">
       <%
       CodeGroup = "SPORTSGBTYPE"
       iType  = "2"

       LSQL = "EXEC Favor_R '" & iType & "','" & iLIMemberIDXG & "','" & CodeGroup & "','','','',''"
       'response.Write "LSQL="&LSQL&"<br>"
       'response.End
       
       Set LRs = DBCon3.Execute(LSQL)
       If Not (LRs.Eof Or LRs.Bof) Then
         Do Until LRs.Eof
       %>

        <li>
          <label class="categoryList__label">
            <span class="categoryList__labelTxt"><%=LRs("Code01Name")%></span>
            <div class="categoryList__checkWrap">
              <div class="m_switch"><input type="checkbox" id="check" name="check" class="m_switch__checkbox" hidden value="<%=LRs("code01") %>" /><span class="m_switch__slider"></span></div>
            </div>
          </label>
        </li>

        
         <%
	    		LRs.MoveNext
	    	Loop
      
      Else
      %>
      <%

         End If
          LRs.close
         %>
         
                 
         
      </ul>
     
    </div>
  </div>

  <!-- #include file='./include/footer.asp' -->
</div>
</body>
</html>
