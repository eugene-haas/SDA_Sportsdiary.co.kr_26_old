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
     Set objRS = objConn.Execute("SELECT * FROM TB_JUDO_MEMBER where RowNum < 5")
       
      IF NOT (objRS.Eof Or objRS.Bof) Then
        arrayMember= objRS.getrows()
      End If
        
     
     If IsArray(arrayMember) Then
        For ar = LBound(arrayMember, 2) To UBound(arrayMember, 2) 
            LSQL = " SET NOCOUNT ON insert into TB_JUDO_MEMBER " 
            LSQL = LSQL & " ( USER_ID, USER_PASSWD, USER_NM, BIRTH_DT ,TELNUM, CELNUM, EMAIL, MAIL_YN, IPIN_YN, IPIN_DUPLICATE_INFO, CRT_ID, UDT_ID, CRT_DT,UDT_DT, JUMIN_NO, BIRTH_DT_FLAG, MAILTO, REAL_CERT, USER_IPIN, PROXY_NAME, PROXY_PHONE_NO, REG_DATE, REG_IP, ARIA_PASSWD, USER_PASSWD_TEMP, JUMIN_NO1 ,JUMIN_NO2, VNUMBER, DUPINFO, AGECODE, GENDERCODE, NATIONALINFO,CONNINFO,CIUPDATE) "
            LSQL = LSQL & " values ('" & arrayMember(1, ar) & "','" & arrayMember(2, ar) & "', '" & arrayMember(3, ar)  & "' ,'" & arrayMember(3, ar)  & "','" & arrayMember(4, ar)  & "','" & arrayMember(5, ar)  & "', '" & arrayMember(6, ar)  &"', '" & arrayMember(7, ar)  &"', '" & arrayMember(8, ar)  &"', '" & arrayMember(9, ar)  &"', '" & arrayMember(10, ar)  &"', '" & arrayMember(11, ar)  &"', '" & arrayMember(12, ar)  & "', '" & arrayMember(13, ar)  & "', '" & arrayMember(14, ar)  &"', '" & arrayMember(15, ar)  &"', '" & arrayMember(16, ar)  &"', '" & arrayMember(17, ar)  &"', '" & arrayMember(18, ar)  &"', '" & arrayMember(19, ar)  &"', '" & arrayMember(20, ar)  &"', '" & arrayMember(21, ar)  &"', '" & arrayMember(22, ar)  &"', '" & arrayMember(23, ar)  &"', '" & arrayMember(24, ar)  &"', '" &arrayMember(25, ar)  &"', '" & arrayMember(26, ar)  &"', '" & arrayMember(27, ar)  &"', '" & arrayMember(28, ar)  &"', '" & arrayMember(29, ar)  &"', '" & arrayMember(30, ar)  &"', '" & arrayMember(31, ar)  &"', '" & arrayMember(32, ar)  &"', '" & arrayMember(33, ar)  &"')" 
            LSQL = LSQL & " SELECT @@IDENTITY as IDX "
            Response.Write "SQL :" & LSQL & "<BR>"
            'Set LRs = DBCon.Execute(LSQL)
        Next
     End if

     'IF NOT (objRS.Eof Or objRS.Bof) Then
     '  Do While Not objRS.EOF
     '   Response.Write "<tr>"
     '     'For i = 0 To objRS.Fields.Count - 1
     '       'Response.Write "<td>" & objRS(i) & "</td>"
     
     '     'Next
     '   Response.Write "</tr>"
     '   objRS.MoveNext
     '  Loop
     'End If  
     'Response.Write "</table>"

     objRs.Close
     objConn.Close
     DBCon.Close

     
   %>
   </center>
   </body>
   </html>

