<%
	'request 처리##############
	tidx = oJSONoutput.TIDX
	title = oJSONoutput.TITLE
	noticetype = oJSONoutput.NOTICETYPE
	contents = oJSONoutput.CONTENTS

	contents = chkStrRpl(contents, "") 
	contents = Replace(contents,"'","''")		'htmlEncode(contents)

	Set db = new clsDBHelper

	SQL = "update sd_TennisTitle Set summary = '"&contents&"',noticetype= '"&noticetype&"' where gameTitleIDX = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing
%>