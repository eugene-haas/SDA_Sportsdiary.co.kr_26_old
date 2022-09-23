
<form method="post"  name="sform" action="<%=PAGENAME%>">
<input type="hidden" name="tidx" id="tidx" value="<%=tidx%>">
<input type="hidden" name="p" id="p">

<%If idx <> "" then%> 
  <input type="hidden" id="idx" value="<%=idx%>">
<%End if%>
  <input type="hidden" id="emode" value="<%=emode%>"><!-- 쓰기, 수정 상태 모드 -->


		<ul id="ul_1">
			 <!-- #include virtual = "/pub/html/bike/ul01_cl.asp" -->
        </ul>

</form>	

 <!-- #include virtual = "/pub/html/bike/modal.asp" -->




