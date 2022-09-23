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



<form method="post"  name="sform" action="<%=PAGENAME%>">
<input type="hidden" name="p" id="p">

<%If idx <> "" then%>
  <input type="hidden" id="idx" value="<%=idx%>">
<%End if%>
  <input type="hidden" id="emode" value="<%=emode%>"><!-- 쓰기, 수정 상태 모드 -->

    <div class="search-box">
		<ul id="ul_1">
			 <!-- #include virtual = "/pub/html/bike/ul01_c2.asp" -->
        </ul>

        <ul  id="ul_2">
			 <!-- #include virtual = "/pub/html/bike/ul02_c2.asp" -->
        </ul>

        <ul  id="ul_3">
			 <!-- #include virtual = "/pub/html/bike/ul03_c2.asp" -->
        </ul>
    </div>
</form>

 <!-- #include virtual = "/pub/html/bike/modal.asp" -->
