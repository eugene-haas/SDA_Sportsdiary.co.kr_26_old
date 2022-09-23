   <%@ Language=VBScript %>

   <%
    strConnect = "Provider=SQLOLEDB.1;Persist Security Info=True;"
    strConnect = strConnect & "Data Source=115.68.7.145;"  
    strConnect = strConnect & "User ID=devsql;"             
    strConnect = strConnect & "Password=ic)(*123;"             
    strConnect = strConnect & "Initial Catalog=JudoKorea_Oracle;" 
		Set DBCon = Server.CreateObject("ADODB.Connection")
		DBCon.CommandTimeout = 1000
		DBCon.Open strConnect


      
    'LSQL = " SELECT Top 1 * FROM TB_JUDO_MEMBER " 
    'Set LRs = DBCon.Execute(LSQL)
    'For i = 0 To LRs.Fields.Count - 1
    
    'Next
    'IF NOT (LRs.Eof Or LRs.Bof) Then
    '  Do Until LRs.Eof
    '    Cnt = LRs("Cnt")
    '  LRs.MoveNext
    '  Loop
    'End If  
    'LRs.Close
    'DBCon.Close
    'Response.Write Cnt

    
   %>

   <html>
   <head>
   <title>Oracle Test</title>
   </head>
   <body>
   <center>

   <%
     Set objConn = Server.CreateObject("ADODB.Connection")
     'objConn.Open "Provider=MSDAORA.1;DATA SOURCE=192.168.1.140:1521/Player;USER ID=judo;Password=judo007;"
     objConn.Open "Provider=OraOLEDB.Oracle;DATA SOURCE=192.168.1.140:1521/Player;USER ID=JUDO;Password=JUDO007;"
     Set objRs = objConn.Execute("SELECT Count(*) as Cnt FROM TB_JUDO_MEMBER ")

     Response.Write "<table border=1 cellpadding=4>"
     Response.Write "<tr>"

      For i = 0 To objRS.Fields.Count - 1
        Response.Write "<td><b>" & objRS(i).Name & "</b></td>"
      Next

     Response.Write "</tr>"
     IF NOT (objRS.Eof Or objRS.Bof) Then
       Do While Not objRS.EOF
        Response.Write "<tr>"
        Response.Write "<td>" & objRS("Cnt") & "</td>"
        Response.Write "</tr>"
        objRS.MoveNext
       Loop
     End If  
     Response.Write "</table>"

     Set objRs = objConn.Execute("SELECT * FROM TB_JUDO_MEMBER ")
     Response.Write "<table border=1 cellpadding=4>"
     Response.Write "<tr>"

      For i = 0 To objRS.Fields.Count - 1
        Response.Write "<td><b>" & objRS(i).Name & "</b></td>"
      Next
        Response.Write objRS.Fields.Count & "</b>"
     Response.Write "</tr>"
     IF NOT (objRS.Eof Or objRS.Bof) Then
       Do While Not objRS.EOF
        Response.Write "<tr>"
          'For i = 0 To objRS.Fields.Count - 1
            'Response.Write "<td>" & objRS(i) & "</td>"
            LSQL = " SET NOCOUNT ON insert into TB_JUDO_MEMBER " 
            LSQL = LSQL & " ( USER_ID, USER_PASSWD, USER_NM, BIRTH_DT ,TELNUM, CELNUM, EMAIL, MAIL_YN, IPIN_YN, IPIN_DUPLICATE_INFO, CRT_ID, UDT_ID, CRT_DT,UDT_DT, JUMIN_NO, BIRTH_DT_FLAG, MAILTO, REAL_CERT, USER_IPIN, PROXY_NAME, PROXY_PHONE_NO, REG_DATE, REG_IP, ARIA_PASSWD, USER_PASSWD_TEMP, JUMIN_NO1 ,JUMIN_NO2, VNUMBER, DUPINFO, AGECODE, GENDERCODE, NATIONALINFO,CONNINFO,CIUPDATE) "
            LSQL = LSQL & " values ('" & objRS(1) & "','" & objRS(2) & "', '" & objRS(3) & "' ,'" & objRS(4) & "','" & objRS(5) & "','" & objRS(6) & "', '" & objRS(7) &"', '" & objRS(8) &"', '" & objRS(9) &"', '" & objRS(10) &"', '" & objRS(11) &"', '" & objRS(12) &"', '" & objRS(13) & "', '" & objRS(14) & "', '" & objRS(15) &"', '" & objRS(16) &"', '" & objRS(17) &"', '" & objRS(18) &"', '" & objRS(19) &"', '" & objRS(20) &"', '" & objRS(21) &"', '" & objRS(22) &"', '" & objRS(23) &"', '" & objRS(24) &"', '" & objRS(25) &"', '" & objRS(26) &"', '" & objRS(27) &"', '" & objRS(28) &"', '" & objRS(29) &"', '" & objRS(30) &"', '" & objRS(31) &"', '" & objRS(32) &"', '" & objRS(33) &"', '" & objRS(34) &"')" 
            LSQL = LSQL & " SELECT @@IDENTITY as IDX "
            Response.Write "SQL :" & LSQL & "<BR>"
            'Set LRs = DBCon.Execute(LSQL)
          'Next
        Response.Write "</tr>"
        objRS.MoveNext
       Loop
     End If  
     Response.Write "</table>"

     objRs.Close
     objConn.Close

     
   %>
   </center>
   </body>
   </html>

