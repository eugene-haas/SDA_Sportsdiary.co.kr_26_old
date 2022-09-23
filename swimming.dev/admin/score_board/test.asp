<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/game_manager/include/head.asp"-->
	  <script defer src="/game_manager/js/pages/test.js<%=P_INDEX_VER%>"></script>
   </head>
   <body>
      <!--#include virtual="/game_manager/include/body_before.asp"-->
      <div class="l_wrap">
         <!-- S: 메인 영역 -->
<div>
<%
Response.write Cookies_adminDecode
%>
</div>
<div style="width:600px;height:800px;background:yellow;" id="res">
</div>


		 <main id="app" class="l_index">
			 <div>
                <a   @click="dlogin()" >다이빙로그인</a> / <a  @click="alogin()" >아티스틱로그인</a>
			   <button  class="l_index__login__btn-login" type="button">목록</button>
			   <button  class="l_index__login__btn-login" type="button">상세</button>
			</div>

            <!-- E: 모달창 영역 -->
         </main>
         <!-- E: 메인 영역 -->
         <!-- S: 공통 모달창 영역 -->
         <!--#include virtual="/game_manager/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/game_manager/include/body_after.asp"-->
   </body>
</html>
