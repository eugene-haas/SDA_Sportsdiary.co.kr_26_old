 <!--#include file="../dev/include/common_function.asp"-->
 
 <%
     iMemberIDX  = Request("MemberIDX")
 %>


 <!DOCTYPE html>

   <html>
   <head>
      <meta charset="utf-8" />
      <title></title>
      <script src="../Dev/js/Common_Js.js"></script>
      <script src="../Dev/js/jquery-3.3.1.js"></script>
      <script src="../Dev/js/jquery-migrate-1.4.1.js"></script>
      <script type="text/javascript">

        
        function checkAll(){
        if( $("#chk_all").is(':checked') ){
          $("input[name=check]").prop("checked", true);
          alert('ㅁ')
        }else{
          $("input[name=check]").prop("checked", false);
        }
        }

          
       $(document).ready(function () {

         $("#button1").click(function () {
           var items = [];
           $('input[name="check"]:checkbox:checked').each(function () { items.push($(this).val()); });
           var tmp = items.join(',');
           var cnt = $("input[name=check]:checkbox:checked").length;


           if (cnt < 1) {

           alert('관심종목을 선택하지 않으셨습니다.\n관심종목을 선택하여 주세요.');

          }
           
          else if (confirm("관심종목 등록 하시겠습니까?") == true) {
             try {

               var strAjaxUrl = "../Ajax/favtest_p.asp";
               var strmessage = "";
               var strtype = "";



               $.ajax({
                 url: strAjaxUrl,
                 type: 'POST',
                 dataType: 'html',
                 data: {
                   
                   tmp: tmp
                   

                 },
                 success: function (retDATA) {
                   var retarr = retDATA.split(',');

                   
                     alert('a');
                   
                 },
                 error: function (xhr, status, error) {
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
     
      </script>
        
      </head>
      <body>
        <h1>관심종목을 선택해주세요.</h1>
      
        <h5>(중복선택 가능)</h5>


       <input type="checkbox" id="chk_all" onclick="javascript: checkAll()"/>
        <input type="checkbox" id="bad" name="check" value="badminton" />배드민턴
           <input type="checkbox" id="judo" name="check" value="judo" />유도
           <input type="checkbox" id="tennis" name="check" value="tennis" />테니스
           <input type="checkbox" id="cycle" name="check" value="cycle" />자전거
           <input type="checkbox" id="swim" name="check" value="swim" />수영
           

           <input id="button1" type="button" value="확인" />
      </body>
       </html>