<%
   Dim DB, SMSDB, LOGDB, ENC_DB 
   Dim DB_CONN, SMS_CONN, LOG_CONN, Cert_pw

   '=================================================================================
	'  Connection info 
	'================================================================================= 
   DB_CONN  = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=eval_rk3%rh4wl*ak;Password=eval_rr$A8%^kv94~*kn7Yh&YB;Initial Catalog=KS_Evaluation_DEV;Data Source=49.247.9.88\SQLExpress,1433;"
   SMS_CONN = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sms_Ek27fh4gk;Password=sms_VW&e@)&Py$5a^458bP*#e;Initial Catalog=SD_Tennis;Data Source=49.247.9.88\SQLExpress,1433;"

   Cert_pw = "pwdcerteval"
   '=================================================================================
	'  DB Open/Close 
	'================================================================================= 
   Sub DBOpen() 
      Err.Clear 

      Set DB = Server.CreateObject("ADODB.Connection")
      DB.CommandTimeout = 1000 
      DB.Open DB_CONN
   End Sub 

   Sub ENC_DBOpen() 
      Err.Clear 

      Set ENC_DB = Server.CreateObject("ADODB.Connection")
      ENC_DB.CommandTimeout = 1000 
      ENC_DB.Open DB_CONN

      ' 암호화 대칭키 Open 
      Call ExecuteUpdate("Exec UP_Open_Key '" & Cert_pw & "'", ENC_DB)
   End Sub

   Sub SMSDBOpen() 
      Err.Clear 

      Set SMSDB = Server.CreateObject("ADODB.Connection")
      SMSDB.CommandTimeout = 1000 
      SMSDB.Open SMS_CONN
   End Sub 

   Sub DBClose() 
      If DB.State = adStateOpen Then 
         DB.Close 
      End If 
      Set DB = Nothing 
   End Sub 

   Sub ENC_DBClose() 
      ' 암호화 대칭키 Close
      Call ExecuteUpdate("Exec UP_Close_Key", ENC_DB)

      If ENC_DB.State = adStateOpen Then 
         ENC_DB.Close 
      End If 
      Set DB = Nothing 
   End Sub 

   Sub SMSDBClose() 
      If SMSDB.State = adStateOpen Then 
         SMSDB.Close 
      End If 
      Set SMSDB = Nothing 
   End Sub 

   '=================================================================================
	'  Injection Check 
	'================================================================================= 
   Function InjectionChk(str)    '#### injection 확인
      Dim arrSQL, forNum
         arrSQL = Array("'","#","exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp ","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")
         If isEmpty(str) Or isNull(str) Then Exit Function
         str = Trim(str)
         For forNum = 0 To Ubound(arrSQL)
            str = Replace(str, arrSQL(forNum), "")
         Next
      InjectionChk = str
   End Function

   '=================================================================================
	'  반환값이 있는 Execute
	'================================================================================= 
   Function ExecuteReturn(sqlStr, DBConn)   
      Dim rs , RS_DATA 

      Set rs = DBConn.Execute(sqlStr)
      RS_DATA = Null 

      If Not rs.Eof Then 
         RS_DATA = rs.GetRows()
      End If 
      rs.Close 
      Set rs = Nothing 

      ExecuteReturn = RS_DATA
   End Function

   '=================================================================================
	'  반환값이 없는 Execute
	'================================================================================= 
   Function ExecuteUpdate(sqlStr, DBConn)   
      DBConn.Execute(sqlStr)
   End Function


%>
