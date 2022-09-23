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
Dim imageData, firstYN, lastYN
Dim currentImage, prevImage, nextImage
Dim Crownum, Cidx, CReadnum, CFilename, Prownum, Pidx, PReadnum, PFilename, Nrownum, Nidx, NReadnum, NFilename

imageData = request("data")
Set oJSONoutput = JSON.Parse(imageData)
Set currentImage = oJSONoutput.currentImage
Crownum = currentImage.rownum
Cidx = currentImage.idx
CReadNum = currentImage.readnum
CFilename = currentImage.filename

If oJSONoutput.prevImage = "" Then
  firstYN = "Y"
End If
If oJSONoutput.nextImage = "" Then
  lastYN = "Y"
End If

If firstYN <> "Y" Then
  Set prevImage = oJSONoutput.prevImage
  Prownum = prevImage.rownum
  Pidx = prevImage.idx
  PReadnum = prevImage.readnum
  PFilename = prevImage.filename
End If

If lastYN <> "Y" Then
  Set nextImage = oJSONoutput.nextImage
  Nrownum = nextImage.rownum
  Nidx = nextImage.idx
  NReadnum = nextImage.readnum
  NFilename = nextImage.filename
End If


%>
<% If firstYN <> "Y" Then %>
<div class="slider-content" rownum=<%=Prownum%>>
  <p class="t-img"><img src="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=PFilename%>" alt="" /></p>
  <div class="list-name">
    <p class="p-name">테스트</p>
    <p class="view-number">조회수 <span><%=Preadnum%></span>회</p>
    <% If instr(sUserAgent, "iPad") or instr(sUserAgent, "iPhone") Then %>
    <% Else%>
    <a href="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=PFilename%>" download='<%=PFilename%>' class="white-btn" >다운로드</a>
    <% End if %>
  </div>
</div>
<% End If %>

<div class="slider-content" rownum=<%=Crownum%>>
  <p class="t-img"><img src="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=CFilename%>" alt="" /></p>
  <div class="list-name">
    <p class="p-name">테스트</p>
    <p class="view-number">조회수 <span><%=Creadnum%></span>회</p>
    <% If instr(sUserAgent, "iPad") or instr(sUserAgent, "iPhone") Then %>
    <% Else%>
    <a href="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=CFilename%>" download='<%=CFilename%>' class="white-btn" >다운로드</a>
    <% End if %>
  </div>
</div>

<% If lastYN <> "Y" Then %>
<div class="slider-content" rownum=<%=Nrownum%>>
  <p class="t-img"><img src="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=NFilename%>" alt="" /></p>
  <div class="list-name">
    <p class="p-name">테스트</p>
    <p class="view-number">조회수 <span><%=Nreadnum%></span>회</p>
    <% If instr(sUserAgent, "iPad") or instr(sUserAgent, "iPhone") Then %>
    <% Else%>
    <a href="http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/<%=NFilename%>" download='<%=NFilename%>' class="white-btn" >다운로드</a>
    <% End if %>
  </div>
</div>
<% End If %>
