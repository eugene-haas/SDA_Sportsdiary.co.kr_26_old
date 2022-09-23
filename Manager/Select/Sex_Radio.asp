<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = LCase(fInject(Request("code")))

	m_check = ""
	f_check = ""
	If code = "man" Then 
		m_check = "checked"
	End If 

	If code = "woman" Then 
		f_check = "checked"
	End If 


selData = "<input type='radio' id='Sex-M' name='Sex_Type' "&m_check&" onclick=""chk_sex('Man')"" /> <label for='gender-man' style='margin-right:15px;'>남자</label>"
selData = selData&"<input type='radio' id='Sex-M' name='Sex_Type' "&f_check&"  onclick=""chk_sex('Woman')""/> <label for='gender-woman' style='margin-right:15px;'>여자</label>"
Response.Write selData

%>