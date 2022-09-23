<!--#include file="../dev/dist/config.asp"-->
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<%
	Response.Expires = 0  
	Response.AddHeader "Pragma","no-cache"  
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"  

	dim sketch_idx 			: sketch_idx   	= Request("sketch_idx")	

	ControlSql =" exec Stadium_Sketch_admin_ajax @sketch_idx= '"&sketch_idx&"' "	
	'Response.write ControlSql

	SET CRs = DBCon7.Execute(ControlSql)	
%>

<%
	If Not(CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
%>
<div style="width:80%;">
	<span id="FN_iFile_1" class="btn_icon_delte" style="float:left; margin-left:-15px;">&nbsp;
		<a href="javascript:Sketch_Result('photo_delete','<%=CRs("Sketch_idx")%>','<%=CRs("idx")%>');">-</a>&nbsp;
	</span><br />

	<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/<%=CRs("Photo")%>" ><br>
</div>
<%
			CRs.MoveNext
		Loop 
	End If 
%>








































