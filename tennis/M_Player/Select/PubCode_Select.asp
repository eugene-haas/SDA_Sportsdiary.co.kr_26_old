<!--#include file="../Library/ajax_config.asp"-->
<%
    element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	'element = "train"
	'attname = "judo"
	'code    = "05"
   '    make_box("train", "judo", "01", "train_Code")
   '	exec [View_train_info] 'train','','judo','01'

	LSQL = "EXEC View_PubCode_info '"&attname&"','"&code&"'"
 
	Set LRs = Dbcon.Execute(LSQL)
    
	Dbclose()

    '헤더조회
    selData = "<select name='"&element&"' id='"&element&"'>"
    selData = selData&"<option value=''></option>"	
    		
    If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("PubCode") Then 
				selData = selData&"<option value='"&LRs("PubCode")&"' selected>"&LRs("PartName")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("PubCode")&"' >"&LRs("PartName")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 

selData = selData&"</select>"

Response.Write selData

%>