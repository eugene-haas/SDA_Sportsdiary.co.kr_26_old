<% @CODEPAGE="65001" language="vbscript" %>
<%
	Response.ContentType = "text/html"
	Response.AddHeader "Content-Type", "text/html;charset=utf-8"
	Response.CodePage = "65001"
	Response.CharSet = "utf-8"
%>	

<script src="/Manager/Script/popup.js"></script>

<body style="background-color:#646464;">	
	<!--조회 효과 처리-->	  
  <div style="position:absolute;left:10px;top:8px;font-size:12px;font-weight:bold;color:#d3d3d3;">■ 상태 : </div>
  
  <div id="popup" style="position:absolute;left:57px;top:4px;z-index:99999;display:none;">
		<label id="popmsg" style="left:50px;font-size:12px;font-weight:bold;color:#ffffff;z-index:99999;"></label> <img src="/Manager/images/loading5.gif" />
  </div>  
</body>