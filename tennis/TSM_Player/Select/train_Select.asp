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


   title=""
   id =element

	LSQL = "EXEC View_train_info '"&element&"','','"&attname&"','"&code&"'"
 
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

    if code ="01" then 
    title ="체력훈련"
    elseif  code ="02"then  
    title ="도복훈련"
    elseif  code ="03"then  
    title ="훈련구분"
    elseif  code ="04"then  
    title ="훈련장소"
    elseif  code ="05"then 
    title ="훈련목표"
    elseif  code ="06"then 
    title ="훈련 불참 사유"
    end  if

selData = "<select name='"&id&"' id='"&id&"'>"
selData = selData&"<option value=''>"&title&"</option>"			

	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
            if LRs("TraiMidCd") ="000" then
                selData = selData&"<option value='"&LRs("TraiMidCd")&"' selected>"&LRs("TraiMIdNm")&"</option>"	
            else
                selData = selData&"<option value='"&LRs("TraiMidCd")&"'>"&LRs("TraiMIdNm")&"</option>"	
            end if
				

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

Dbclose()
%>