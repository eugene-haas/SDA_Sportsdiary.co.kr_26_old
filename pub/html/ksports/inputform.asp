<style>
/* ==== Accessibility ===== */
.aural {
  position: absolute;
}
.aural:focus {
  clip: rect(0, 0, 0, 0);
  font-size: 1em;
  height: auto;
  outline: thin dotted;
  position: static !important;
  width: auto;
  overflow: visible;
}
</style>



<form method="post"  name="sform" action="klist.asp">
<input type="hidden" name="p">

<%If idx <> "" then%> 
  <input type="hidden" id="idx" value="<%=idx%>">
<%End if%>
  <input type="hidden" id="emode" value="<%=emode%>"><!-- 쓰기, 수정 상태 모드 -->


		<ul id="ul_1">
			 <!-- #include virtual = "/pub/html/ksports/ul01.asp" -->
        </ul>


        <ul  id="ul_2">
          <li>
            <span class="txt">장소(지역)</span>
            <input type="hidden" id="zipcode" value="<%=zipcode%>">
            <input type="hidden" id="sido" value="<%=sido%>">
			<input type="text" name="gameaddr" id="gameaddr" placeholder="주소"  class="in_txt"  value="<%=gameaddr%>" onfocus="Postcode()"><!-- 포커스시 주소검색창 -->
          </li>
          <li>
            <span class="txt">경기장명</span>
            <input type="text" name="stadium" id="stadium" placeholder="경기장명을 입력해주세요." value="<%=stadium%>" class="in_txt">
          </li>
          <li>
            <span class="txt">&nbsp;</span>
            &nbsp;    
          </li>
        </ul>

        <ul  id="ul_3">
			 <!-- #include virtual = "/pub/html/ksports/ul03.asp" -->
        </ul>


        <ul class="swich_box"  id="ul_4">
			 <%If request("test") = "t" then%>
			 <!-- #include virtual = "/pub/html/ksports/ul04_ts.asp" -->
			 <%Else%>
			 <!-- #include virtual = "/pub/html/ksports/ul04_v2.asp" -->
			 <%End if%>
        </ul>
</form>	

 <!-- #include virtual = "/pub/html/ksports/modal.asp" -->




