<%
	'request
	idx = oJSONoutput.IDX
	levelno  = oJSONoutput.levelno
	ridx  = oJSONoutput.ridx
	StrPwd  = oJSONoutput.StrPwd
	'strName  = oJSONoutput.strName
	'strPhone  = oJSONoutput.strPhone

	Set db = new clsDBHelper
 
       SQL=""
       SQL = SQL&"  select  case when isnull(UserPass,'')='' then ''  when isnull(UserPass,'')='null' then ''  else UserPass end UserPass ,isnull(UserName,'')UserName,isnull(UserPhone,'') UserPhone " 
       SQL = SQL&"  from tblGameRequest  " 
       'SQL = SQL&"  where GameTitleIDX = "&idx&"  and level = '"&levelno&"' and RequestIDX='"&ridx&"' and DelYN = 'N' " 
		SQL = SQL&"  where GameTitleIDX = "&idx&" and RequestIDX='"&ridx&"' and DelYN = 'N' " 

       Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
       i = 0
       If Not rs.EOF Then 
	        Do Until rs.eof
                UserPass  = rs("UserPass") 
                UserName  = rs("UserName") 
                UserPhone  = rs("UserPhone") 
	       i = i + 1
	       rs.movenext
	       Loop
     
           if Cstr(UserPass) = Cstr(StrPwd) then
                Call oJSONoutput.Set("result", "0" )
           else
                Call oJSONoutput.Set("result", "31" )
           end if 
       else
            Call oJSONoutput.Set("result", "1" )
       End if 
      
       Call oJSONoutput.Set("UserPass", UserPass )
       Call oJSONoutput.Set("UserName", UserName )
       Call oJSONoutput.Set("UserPhone", UserPhone )
       'Call oJSONoutput.Set("sql", SQL )

       strjson = JSON.stringify(oJSONoutput)
       Response.Write strjson
     
    db.Dispose
    Set db = Nothing


'"{"CMD":501,"IDX":"137","levelno":"","ridx":"38534","StrPwd":"6178","action":1,"result":"1","sql":"  "}"
%>

