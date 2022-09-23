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

.admin_content .info_serch ul li .txt {
	width: 85px;
}
.admin_content .info_serch ul li input {
	width: 220px;
}

</style>



<form method="post"  name="sform" action="kgameinfo.asp">
<input type="hidden" name="p">

<%If idx <> "" then%> 
  <input type="hidden" id="idx" value="<%=idx%>">
<%End if%>
  <input type="hidden" id="emode" value="<%=emode%>"><!-- 쓰기, 수정 상태 모드 -->


		<ul id="ul_1">
			 <!-- #include virtual = "/pub/html/ksports/gul01.asp" -->
        </ul>
		<ul id="ul_2" style="padding-top:10px;">
			<!-- #include virtual = "/pub/html/ksports/gul02.asp" -->
		</ul>
		<ul id="ul_3" style="width:1390px;">
			<!-- #include virtual = "/pub/html/ksports/gul03.asp" -->
		</ul>

</form>	

 <!-- #include virtual = "/pub/html/ksports/modal.asp" -->




