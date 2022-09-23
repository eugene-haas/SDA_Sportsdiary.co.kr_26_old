<%
	tab = oJSONoutput.value("TAB") 
%>

<a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_DBBASIC})">기존형태</a>   <a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_DBBASIC,'TAB':2})">테니스</a>
<br>

<%If tab = "2" then%>
<img src="/img/table.jpg" usemap="#map">

<map name="map">
<area shape="rect" coords="81,211,294,282" href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'sd_TennisUser','DN':'Sportsdiary' })">
<area shape="rect" coords="82,378,291,436" href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'sd_TennisTitle','DN':'Sportsdiary' })" >
<area shape="rect" coords="83,474,290,579" href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'sd_TennisMember','DN':'Sportsdiary' })" >
</map>
<%else%>
<img src="/img/origin.png">
<%End if%>