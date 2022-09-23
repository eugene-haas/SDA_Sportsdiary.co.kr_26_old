<%
datareq = True

If hasown(oJSONoutput, "classCode") = "ok" then
    classCode = oJSONoutput.classCode
    rsClassCD = classCode
Else
    datareq = False
End IF 

If datareq = False then
    Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
    Response.End	
End If

Set db = new clsDBHelper

'세부종별 불러오기
SQL = " SELECT idx, DetailType FROM k_detailTypeList WHERE ClassCode = '"&classCode&"' AND delYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

If Not rs.eof then
    arrDT = rs.getrows()
End If 

'종목선택 불러오기
SQL = "Select classIDX, classCode, className from tblClassList order by className ASC"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
    arrClass = rs.GetRows()
End If

'성별선택 불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameMemberGender'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
    arrGender = rs.GetRows()
End If

'학군선택 불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameAgeDistinct'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
    arrAge = rs.GetRows()
End If

'경기방식선택 불러오기 
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameMatchType'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
    arrMatch = rs.GetRows()
End If

'종별선택불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameGroupType'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
    arrGroup = rs.GetRows()
End If
%>

<!-- #include virtual = "/pub/html/ksports/gameinputform.asp" -->