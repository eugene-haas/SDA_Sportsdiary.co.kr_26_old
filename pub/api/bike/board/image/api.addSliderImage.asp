<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){

	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%
Dim imageData, addRownum, addIdx, addFilename, addReadnum
imageData = request("data")
Set oJSONoutput = JSON.Parse(imageData)
addRownum = oJSONoutput.rownum
addIdx = oJSONoutput.idx
addFilename = oJSONoutput.filename
addReadnum = oJSONoutput.readnum
%>

<div class="slider-content" rownum=<%=addRownum%>>
  <p class="t-img"><img src="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=addFilename%>" alt="" /></p>
  <div class="list-name">
    <p class="p-name">테스트1</p>
    <p class="view-number">조회수 <span><%=addReadnum%></span>회</p>
    <% If instr(sUserAgent, "iPad") or instr(sUserAgent, "iPhone") Then %>
    <% Else%>
    <a href="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=addFilename%>" download='<%=addFilename%>' class="white-btn" >다운로드</a>
    <% End if %>
  </div>
</div>
