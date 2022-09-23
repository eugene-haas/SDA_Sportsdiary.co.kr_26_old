<!DOCTYPE html>

<html lang="ko">

<head>

  <!-- #include file='./include/head.asp' -->
  <!--#include file="./include/config.asp"-->

  <%
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <style>
  #sortable1, #sortable2 {
    border: 1px solid #eee;
    width: 142px;
    min-height: 20px;
    list-style-type: none;
    margin: 0;
    padding: 5px 0 0 0;
    float: left;
    margin-right: 10px;
  }
  #sortable1 li, #sortable2 li {
    margin: 0 5px 5px 5px;
    padding: 5px;
    font-size: 1.2em;
    width: 120px;
  }
   .element:hover {
            cursor: move;
            cursor: -webkit-grab;
            cursor: grab;
        }
   .element.grabbing {
       cursor: grabbing;
       cursor: -webkit-grabbing;
   }
   </style>
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script src="js/Common_Js.js"></script>
  <script type="text/javascript">

    
    iLIMemberIDXG = "<%=iLIMemberIDXG%>";
    iUid = "<%=iUid%>";
    
    $(document).ready(function () {
    
      $("#btn").click(function () {
        var itmp = '';
       
         for (var i = 0; i < $('#sortable1').find('input').length; i++) {
           itmp += $('#sortable1').find('input').eq(i).val() + '^';
        }

        var tmp = itmp
        alert(tmp);
        
      if(confirm("우선 순위 관심종목 등록 하시겠습니까?") == true) {
          try {
    
            var strAjaxUrl = "./Ajax/fav_p.asp";    
    
            $.ajax({
              url: strAjaxUrl,
              type: 'post',
              data: {
    
                tmp: tmp,
                iLIMemberIDXG: iLIMemberIDXG,
                iUid: iUid,
                },
    
              dataType: 'html',
              success: function (retDATA) {
    
                if (retDATA != "Y") {
                  alert('관심종목 등록에 실패했습니다. 다시 선택 해주세요.');
                  location.href = "http://sdmain.sportsdiary.co.kr/sdmain/interested_category.asp";
                }
                else {
                  alert("관심메뉴 등록에 성공했습니다..");
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

     $( function() {
        $( "#sortable1" ).sortable({
          connectWith: ".connectedSortable"
        }).disableSelection();
      } );

              
  </script>

</head>
<body>
<div class="l interestedCategory">
  <div class="l_content">
    <header class="m_jumboHeader">
    <h4 style="color:red">우선 메뉴 종목을 선택해 주세요.</h4>
         <h1 class="m_jumboHeader__tit">
      
        <span class="m_jumboHeader__titPoint">우선 메뉴 종목</span>을 추가하여<br /> 나만을 위한 정보를 받아보세요.
      </h1>
      <p class="m_jumboHeader__subTxt">
        <span>설정</span> <span class="m_jumboHeader__subTxtGt">&gt;</span> <span>마이페이지</span> <span class="m_jumboHeader__subTxtGt">&gt;</span> <span>앱 알림 수신설정에서 변경 가능합니다.</span>
      </p>
    </header>

    <section class="m_jumboCon">
      <p class="m_jumboCon__txt">
        <span class="m_jumboCon__txtPoint">우선메뉴 종목부터</span>을 선택해 주세요.
      </p>
      
  <ul id="sortable1" class="connectedSortable">
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
  <li  class="ui-state-default"><input type="hidden" name="Most" value="<%=LRs("code01") %>" /><%=LRs("code01name") %></li>

<%
 LRs.MoveNext
   Loop
 End If
 
'%>

</ul>

      <div class="m_jumboCon__btns">
        <button type="button" id="btn" class="m_jumboCon__btn" >확인</button>
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