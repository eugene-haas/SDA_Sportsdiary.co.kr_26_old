<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!--#include file="./include/config.asp"-->

  <%
    iMost = Request("Most")
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

  %>
   <script src="js/Common_Js.js"></script>
   <script type="text/javascript">

     iMost = "<%=iMost%>"
     iLIMemberIDXG = "<%=iLIMemberIDXG%>";
     iUid = "<%=iUid%>";


        $(document).ready(function () {
        
          $("#submit").click(function () {
            var items = [];
            $('input[name="check"]:checkbox:checked').each(function () { items.push($(this).val()); });
            var tmp = items.join('^');
            var cnt = $("input[name=check]:checkbox:checked").length;
            var iMost = $('input:checkbox[name="check"]').val();



            if (cnt < 1) {

              alert('관심종목을 선택하지 않으셨습니다.\n관심종목을 선택하여 주세요.');

            }

            else if (confirm("관심종목 등록 하시겠습니까?") == true) {
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
                      alert("관심종목 등록에 성공했습니다..");
                      location.href = "http://sdmain.sportsdiary.co.kr/sdmain/index.asp";
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
       
        
        iCode01s = "<%=iCode01s%>"
        iCode01sArr = iCode01s.split("^");

       //관심종목 데이터 조회하여 checked
        $(document).ready(function () {
    
          for (var i = 1; i < iCode01sArr.length + 1; i++) {
    
            $("input:checkbox[name='check']:checkbox[value='" + iCode01sArr[i] + "']").attr("checked", true);
    
          }
    
        });
           //우선 순위 데이터는 체크 박스 불가능
          
     $(document).ready(function () {

       $("input:checkbox[name ='check']:checkbox[value='" + iMost + "']").attr("checked", true);

     
     });
    
    
     $(document).ready(function () {

       $("input:checkbox[name ='check']:checkbox[value='" + iMost + "']").attr("disabled", true);

     
     });
    
                  

      </script>

</head>
<body>
<div class="l interestedCategory">
  <div class="l_content">
    <header class="m_jumboHeader">
    <h4 style="color:red">우선순위 외 관심종목을 선택하지 않으셨습니다.&nbsp우선순위 외 관심종목을 선택해주세요.</h4>
         <h1 class="m_jumboHeader__tit">
      
        <span class="m_jumboHeader__titPoint">관심종목</span>을 추가하여<br /> 나만을 위한 정보를 받아보세요.
      </h1>
      <p class="m_jumboHeader__subTxt">
        <span>설정</span> <span class="m_jumboHeader__subTxtGt">&gt;</span> <span>마이페이지</span> <span class="m_jumboHeader__subTxtGt">&gt;</span> <span>앱 알림 수신설정에서 변경 가능합니다.</span>
      </p>
    </header>

    <section class="m_jumboCon">
      <p class="m_jumboCon__txt">
        <span class="m_jumboCon__txtPoint">관심종목</span>을 선택해 주세요.
      </p>
      <span class="m_jumboCon__subTxt">(중복선택 가능)</span>

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
        <%
         LRs.MoveNext
           Loop
         End If
         
         %>

      </form>

      <div class="m_jumboCon__btns">
        <button id="submit" class="m_jumboCon__btn" >확인</button>
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