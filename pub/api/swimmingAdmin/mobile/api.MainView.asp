<%
'#############################################
'메인 뷰
'#############################################
	'request

  Set db = new clsDBHelper

  
		fld = " '1' as poplink, gametitlename as title, gametitleidx as id "
		fld = fld & " , (case when games > getdate() then 's_apply' when gamee < getdate() then 's_end' else 's_ing' end) as class  "
		fld = fld & " , (case when games > getdate() then '예정' when gamee < getdate() then '경기종료' else '경기중' end) as status  "
		fld = fld & " , (convert(char(10), games,23)) as dday  "

		SQL = "select top 4 "&fld&" from sd_gameTitle where delyn='N' and ViewStateM = 'Y' order by gamee desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			response.write "{""jlist"": ""nodata""}"
		else
			
			listarr = jsonTors_arr(rs)

			Set list = JSON.Parse( join(array(listarr)) )
			Call oJSONoutput.Set("gameinfo", list )	

			strjson = JSON.stringify(oJSONoutput)
			strjson = "{""jlist"":[" & strjson & "]}"
			Response.Write strjson
		End if

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	



%>
