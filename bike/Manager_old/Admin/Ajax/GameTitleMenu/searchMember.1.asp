<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":""5"",""SVAL"":""김""}"
  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
	tSVAL = Replace(fInject(oJSONoutput.SVAL),Chr(34), "")

  IF LEN(tSVAL) = 1 Then
		top = "top 20"
	ELSEIF LEN(tSVAL) = 2 Then
		top = "top 20"
	END IF
   
	LSQL = "SELECT " & top & " MemberIDX, PlayerGb, UserName, UserPhone, Birthday, a.Sex, Level, a.Team, b.TeamNm "
	LSQL =  LSQL & " FROM tblMember a " 
  LSQL =  LSQL & " Left Join tblTeamInfo b on a.Team = b.Team and b.DelYN = 'N' " 
	LSQL =  LSQL & " Where UserName LIKE '" &  tSVAL & "%' And a.DelYN = 'N'"

  'Response.Write "LSQL : " & LSQL & "<BR>"
  
  Set rs = DBCon.Execute(LSQL)
  'rs.CursorLocation = 3

  If rs.BOF = False and rs.Eof = False Then
    'Response.Write  "TotalCount : " & rs.RecordCount  & "<br>"  
    LIST = rs.GetRows()
    nCnt = UBound(LIST, 2)
    ReDim JSONarr(nCnt )
    'Response.Write  "TotalCount : " & nCnt  & "<br>"
    rCnt = 0
    j = 0
    
    If IsArray(LIST) Then
      For ar = LBound(LIST, 2) To UBound(LIST, 2) 
      
        Set rsarr = jsObject() 
        rMemberIDX = LIST(0,ar)
        rPlayerGb = LIST(1,ar)
        rUserName = LIST(2,ar)
        rUserPhone = LIST(3,ar)
        rBirthday = LIST(4,ar)
        rSex = LIST(5,ar)
        rLevel = LIST(6,ar)
        rTeam = LIST(7,ar)
        rTeamNm = LIST(8,ar)
        rsarr("uidx") = crypt.EncryptStringENC(rMemberIDX)
        rsarr("data") = rUserName
        rsarr("team") = crypt.EncryptStringENC(rTeam)
        rsarr("teamNm") = rTeamNm
        'Response.WRite j & "<br>"
        Set JSONarr(j) = rsarr
        j  = j  + 1
      Next
    End If			

    jsonstr = toJSON(JSONarr)
    Response.Write CStr(jsonstr)
    
  End if

%>
