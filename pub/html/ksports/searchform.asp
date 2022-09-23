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



<form method="post"  name="sform" action="ksearch.asp">
<input type="hidden" name="p">

<%If idx <> "" then%> 
  <input type="hidden" id="idx" value="<%=idx%>">
<%End if%>


		<ul id="ul_1">
			 <!-- #include virtual = "/pub/html/ksports/s.ul01.asp" -->
        </ul>
        <ul  id="ul_2">
			 <!-- #include virtual = "/pub/html/ksports/s.ul02.asp" -->
        </ul>
        <ul  id="ul_3">
			 <!-- #include virtual = "/pub/html/ksports/s.ul03.asp" -->
        </ul>
        <ul id="ul_4">
			<!-- #include virtual = "/pub/html/ksports/s.ul04.asp" -->
        </ul>
        <ul id="ul_5">
			<!-- #include virtual = "/pub/html/ksports/s.ul05.asp" -->
        </ul>
</form>	

 <!-- #include virtual = "/pub/html/ksports/modal.asp" -->




