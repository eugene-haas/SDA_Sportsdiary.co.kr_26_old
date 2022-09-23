<!--#include virtual="/Manager/Common/common_header.asp"-->
<iframe id="aaa" width="480" height="270" src="http://www.youtube.com/embed/J45PTrERUhI?fs=1&showinfo=0&autoplay=1&start=60&end=120" frameborder="0"	allowfullscreen></iframe>


<script type="text/javascript">
//링크,녹화영상에서경기첫경기시작시간,1경기시작시간,1경기종료시간)
function chk_media(medialink,stime,etime){






	link_src = "http://www.youtube.com/embed/"+medialink+"?fs=1&showinfo=0&autoplay=1&start="+stime+"&end="+etime

	document.getElementById("aaa").src = link_src;

}
</script>
<%
  mediastart = (1*3600)+(33*60)+38 '대회경기 시작시간
  'Response.Write mediastart

	If mediaend = "" Then 
	 mediaend = mediastart + 600
	End If 
%>
<p>
<p>
<p>
<p>
<table border="1">
<!--
	경기 종료 시간 - 경기 시작 시간 경기 진행 시간을 초로 계산 
-->
<%
	

	Response.Write (a)
	
%>

	<%
		a = DateDiff("s", "2017-03-16 09:59:41", "2017-03-16 10:04:52")
	%>
	<tr>
		<td  height="30px;"><span onclick="chk_media('J45PTrERUhI','<%=mediastart%>','<%=a%>')">6경기장문윤호 VS 김태명남자고등부-81kg/77302/2017-03-16 09:59:41</span></td>

	<%
	  mediastart = mediastart + a
		a = DateDiff("s", "2017-03-16 10:04:52", "2017-03-16 10:10:21")
	%>	
	</tr>
	<tr>
		<td height="30px;"><span onclick="chk_media('J45PTrERUhI','<%=mediastart%>','<%=a%>')">6경기장권희상 VS 김장운남자고등부-81kg/77436/2017-03-16 10:04:52</span></td>
	</tr>
	<%
	  mediastart = mediastart + a
		a = DateDiff("s", "2017-03-16 10:04:52", "2017-03-16 10:11:07")
	%>	
	</tr>
	<tr>
		<td  height="30px;"><span onclick="chk_media('J45PTrERUhI','<%=mediastart%>','<%=a%>')">6경기장이재용 VS 이태민남자고등부-81kg/77876/2017-03-16 10:10:21</span></td>
	</tr>
</table>

<!--
<iframe width="480" height="270" src="http://www.youtube.com/embed/J45PTrERUhI" frameborder="0" allowfullscreen></iframe>
<iframe width="480" height="270" src="http://www.youtube.com/embed/OvXxJcB3nGs" frameborder="0" allowfullscreen></iframe>
<iframe width="480" height="270" src="http://www.youtube.com/embed/RUAeG-Ok0us" frameborder="0" allowfullscreen></iframe>
-->
