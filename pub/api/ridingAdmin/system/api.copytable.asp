<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->     
<!-- #include virtual = "/pub/fn/fn.log.asp" -->    

<%
	If hasown(oJSONoutput, "TABLENAME") = "ok" Then  '테이블 명
		TABLENAME = chkStrRpl(oJSONoutput.TABLENAME,"")
	End If	

	Set db = new clsDBHelper

	copyTableName =  TABLENAME &"_"& Replace(date,"-","")&Mid(Replace(time,":",""),4)


	'1. 테이블을 생성하면서 테이블의 데이타 복사
		'select * into 생성될테이블명 from 원본테이블명

		'테이블 구조만 복사하겠다면
		'select * into 생성될테이블명 from 원본테이블명 where 1=2

	'2. 테이블이 이미 생성되어 있는경우 데이타만 복사
		'insert into 카피될테이블명 select * from 원본테이블명

		'특정 데이타만 복사 하겠다면
		'insert into 카피될테이블명 select * from 원본테이블명 where 검색조건

	SQL = "select * into " & copyTableName & " from " & TABLENAME
	Call db.execSQLRs(SQL , null, ConStr)		


	jstr = "{""result"":""1212""}"
	Response.write jstr

	db.Dispose
	Set db = Nothing

    Call CopySystemKey(TABLENAME, copyTableName)
    Call CopyDefaultValKey(TABLENAME, copyTableName)

    '---------------------------------------------------
    ' DB Table Primary Key copy
    '---------------------------------------------------
    function CopySystemKey(srcTable, dstTable)        
        Set db = new clsDBHelper

        'Primary Key check            

        strQuery = "SELECT CONSTRAINT_NAME As csName, COLUMN_NAME As cmName FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE "        
        strQuery = strQuery & "WHERE TABLE_NAME= " & strSqlVar(srcTable)
        strQuery = strQuery  & " And CONSTRAINT_NAME Like 'PK_%' " 
        strQuery = strQuery  & " Order By ORDINAL_POSITION"

        Set rs = db.ExecSQLReturnRS(strQuery , null, ConStr)  

        rsCnt = rs.RecordCount
        cntKey = 0
        strKey = ""
        
        Do Until rs.eof    
            If cntKey = 0 Then 
                strKey = strKey & "(" &  rs.Fields(1)            
            Else
                strKey = strKey & "," & rs.Fields(1) 
            End If

            If cntKey = rsCnt-1 Then strKey = strKey & ")" End If
            cntKey = cntKey + 1
            rs.movenext      
        Loop

        'Primary Key setting        
        If(strKey <> "") Then 
            strQuery = "Alter Table " &dstTable& " Add Primary Key " & strKey      
            db.execSQLRs strQuery , null, ConStr   
        End If

        db.Dispose 
    '
        Set rs = Nothing
        Set db = Nothing
    End Function

    '---------------------------------------------------
    ' DB Table Default val key copy
    '---------------------------------------------------
    function CopyDefaultValKey(srcTable, dstTable)        
        Set db = new clsDBHelper

        '  Default value check             
        strQuery = "SELECT COLUMN_NAME As cmName, COLUMN_DEFAULT As defVal FROM INFORMATION_SCHEMA.COLUMNS As a "
        strQuery = strQuery & " WHERE TABLE_NAME= " & strSqlVar(srcTable) & " And a.COLUMN_DEFAULT IS NOT NULL"
        
        Set rs = db.ExecSQLReturnRS(strQuery , null, ConStr)  

        '  Default value setting         
        Do Until rs.eof    
            defVal = replaceByRegEx("[(|'|)]", "", rs.Fields(1))  
            strQuery = "ALTER TABLE " & dstTable & " ADD DEFAULT " & strSqlVar(defVal) & " FOR " & rs.Fields(0)             
            db.execSQLRs strQuery , null, ConStr                           
                
            rs.movenext
        Loop     

        db.Dispose 
    '
        Set rs = Nothing
        Set db = Nothing
    End Function
%>