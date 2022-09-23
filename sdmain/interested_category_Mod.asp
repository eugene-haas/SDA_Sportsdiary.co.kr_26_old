<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!--#include file="./include/config.asp"-->

  <%
    Most = Request("Most")
    iUid = Request.Cookies("SD")("UserID")
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

   <script src="js/Common_Js.js"></script>
   <script type="text/javascript">

     iiCode01s = "<%=iiCode01s %>";
     iMost = "<%=Most%>";
     iLIMemberIDXG = "<%=iLIMemberIDXG%>";
     iUid = "<%=iUid%>";

     $(document).ready(function () {
    
      $("#submit").click(function () {
        var items = [];
        $('input[name="check"]:checkbox:checked').each(function () { items.push($(this).val()); });
        var tmp = items.join('^');
        var cnt = $("input[name=check]:checkbox:checked").length;
        var iMost = $(this).val();

         if (cnt < 1) {

          alert('우선 순위 관심종목 한종류만 선택해주세요.');

        }

        else if(confirm("우선 순위 관심종목 등록 하시겠습니까?") == true) {
          try {
    
            var strAjaxUrl = "./Ajax/fav_p.asp";    
    
            $.ajax({
              url: strAjaxUrl,
              type: 'post',
              data: {
    
                tmp: tmp,
                iLIMemberIDXG: iLIMemberIDXG,
                iUid: iUid,
                iMost: tmp
              },
    
              dataType: 'html',
              success: function (retDATA) {
    
                if (retDATA != "Y") {
                  alert('관심종목 등록에 실패했습니다. 다시 선택 해주세요.');
                  location.href = "http://sdmain.sportsdiary.co.kr/sdmain/interested_category.asp";
                }
                else {
                  alert("관심종목 등록에 성공했습니다..");
                  post_to_url('./PushSetting_dev.asp', { 'Most' : iMost , 'tmp' : tmp});
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
     
     $(document).ready(function () {

       //라디오 요소처럼 동작시킬 체크박스 그룹 셀렉터

       $('input[type="checkbox"][name="check"]').click(function () {

         //클릭 이벤트 발생한 요소가 체크 상태인 경우

         if ($(this).prop('checked')) {

           //체크박스 그룹의 요소 전체를 체크 해제후 클릭한 요소 체크 상태지정

           $('input[type="checkbox"][name="check"]').prop('checked', false);

           $(this).prop('checked', true);

         }

       });

     });

      $(document).ready(function () {

        $("input:checkbox[name ='check']:checkbox[value='" + iiCode01s + "']").attr("checked", true);

      
      });

                   
  </script>

</head>
<body>
<div class="l interestedCategory">
  <div class="l_content">
    <header class="m_jumboHeader">
    <h4 style="color:red">우선 순위 관심 종목을 선택해 주세요.</h4>
         <h1 class="m_jumboHeader__tit">
      
        <span class="m_jumboHeader__titPoint">관심종목</span>을 추가하여<br /> 나만을 위한 정보를 받아보세요.
      </h1>
      <p class="m_jumboHeader__subTxt">
        <span>설정</span> <span class="m_jumboHeader__subTxtGt">&gt;</span> <span>마이페이지</span> <span class="m_jumboHeader__subTxtGt">&gt;</span> <span>앱 알림 수신설정에서 변경 가능합니다.</span>
      </p>
    </header>

    <section class="m_jumboCon">
      <p class="m_jumboCon__txt">
        <span class="m_jumboCon__txtPoint">우선순위 관심종목부터</span>을 선택해 주세요.
      </p>
     

      <form class="form">
       <%      

       iType = "2"
       CodeGroup = "SPORTSGBTYPE"

       LSQL = "EXEC Favor_R '" & iType & "','" & iLIMemberIDXG & "','" & CodeGroup & "','','','',''"
       'response.Write "LSQL="&LSQL&"<br>"
       'response.End
       
       Set LRs = DBCon3.Execute(LSQL)
       If Not (LRs.Eof Or LRs.Bof) Then
         Do Until LRs.Eof
         
         
       %>
        <input type="checkbox" id="chk_<%=LRs("code01") %>" name="check" class="form__checkbox" hidden  value="<%=LRs("code01") %>"/><label for="chk_<%=LRs("code01") %>" class="form__label"><%=LRs("code01name") %></label>
          <input type="hidden" id="Most" name="Most" value="<%=LRs("code01") %>"/>
      <%
         LRs.MoveNext
           Loop
         End If
         
       %>

      </form>

      <div class="m_jumboCon__btns">
        <button id="submit"  class="m_jumboCon__btn" >확인</button>
      </div>
    </section>
  </div>
  <!-- #include file='./include/footer.asp' -->
</div>
</body>
</html>
<%
LRs.close
%>