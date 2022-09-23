<header>
	<ul id="menutop">
	<li>&nbsp;</li>
    <li style="float:right;color:#ffffff;">
		<div style="float:left;margin-top:12px;height:33px;">&nbsp;</div>
		<div style="float:left;margin-top:10px;">&nbsp;</div>
		<div style="clear:both;"></div>
	</li>
	</ul>

	<ul id="menubar">
	  <li style="width:200px;height:29px;background:#000000;color:#ffffff;padding:5px 0 0 10px;" class="fa fa-folder-open fa-2x">&nbsp;</li>

<%
'menuarr = array(array("HOME",true),array("신청접수관리",false),array("연수평가관리",true),array("회계/배송관리",false),array("유저관리",false),array("게시물관리",true),array("통계조회",false),array("과정기초관리",true),array("내정보수정",true))
'
'For i = 0 To ubound(menuarr) -1
'	If user_lev = 3 And menuarr(i)(1) = false Then
'		Response.write ""
'	else
'		If (InStr(1,aem_data(7),"6") = 0 And user_lev=2) And i = 7 Then 
'			Response.write ""
'		else
'			Response.write "<li><a href=""javascript:main_move("&i&");"">"&menuarr(i)(0)&"</a></li>"
'		End if
'	End if
'Next
	Response.write "<li style=""float:right"">"
%>
	  </li>
	</ul>

</header>
