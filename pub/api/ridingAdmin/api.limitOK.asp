<%
	Response.End
	'일딴 막아두고 작업할때 풀자.


	'request 처리##############
	
	tidx = oJSONoutput.TIDX
	title = oJSONoutput.TITLE
	contents = oJSONoutput.CONTENTS

	contents = chkStrRpl(contents, "") 




contents = Replace(contents,"'","''")		'htmlEncode(contents)




	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	SQL = "update sd_TennisTitle Set summary = '"&contents&"' where gameTitleIDX = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing
%>