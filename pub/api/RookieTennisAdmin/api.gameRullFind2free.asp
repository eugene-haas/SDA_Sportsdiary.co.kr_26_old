<%
'#############################################

' 대회 정보 코드 생성용 조회

'#############################################
	'request
	tidx = oJSONoutput.FSTR
	fstr2 = oJSONoutput.FSTR2

	fstr2_str= CStr(Split(fstr2,",")(0))
    fstr2_str1= CStr(Split(fstr2,",")(1))

	Set db = new clsDBHelper

    '생성 여부 확인하고 찍어준다.
    SQL = "select top 1 * from sd_TennisKATARullMake where mxjoono = '" & CStr(tidx) & CStr(fstr2_str) & "' and sortno = 1"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
		
	If Not rs.eof Then 
		Do Until rs.eof

		p_attcnt		= rs("attcnt")
		p_seedcnt		= rs("seedcnt")
		p_jonocnt		= rs("jonocnt")
		p_boxorder		= rs("boxorder")
		p_saveinfo		=rs("saveinfo")

		rs.movenext
		Loop
 	end if 

	'타입 석어서 보내기
	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("attcnt", p_attcnt )
	Call oJSONoutput.Set("seedcnt", p_seedcnt )
	Call oJSONoutput.Set("jonocnt", p_jonocnt )
	Call oJSONoutput.Set("boxorder", p_boxorder )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"
	
	 
	 
	 
	 Response.write "내용 불러오기"
  

db.Dispose
Set db = Nothing
%>