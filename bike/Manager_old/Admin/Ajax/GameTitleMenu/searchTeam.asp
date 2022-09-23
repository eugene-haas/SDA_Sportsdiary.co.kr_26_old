<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":""5"",""SVAL"":""테""}"
  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
	tSVAL = Replace(fInject(oJSONoutput.SVAL),Chr(34), "")

  IF LEN(tSVAL) = 1 Then
		top = "top 20"
	ELSEIF LEN(tSVAL) = 2 Then
		top = "top 20"
	END IF
   
	LSQL = "SELECT " & top & " PTeamIDX, a.Team, a.TeamNm "
  LSQL =  LSQL & " ,Case When a.Sex = 'Man' Then  '남자팀' When a.Sex = 'Woman' Then  '여자팀'  When a.Sex = 'Mix' Then  '혼성팀'  ELSE '' END as TeamSex " 
	LSQL =  LSQL & " FROM tblTeamInfo a " 
	LSQL =  LSQL & " Where a.TeamNm LIKE '" &  tSVAL & "%' And a.DelYN = 'N'"

  'Response.Write "LSQL : " & LSQL & "<BR>"
  
  Set rs = DBCon.Execute(LSQL)
  'rs.CursorLocation = 3

  If rs.BOF = False and rs.Eof = False Then
    'Response.Write  "TotalCount : " & rs.RecordCount  & "<br>"  
    LIST = rs.GetRows()
    nCnt = UBound(LIST, 2 )
    ReDim JSONarr(nCnt )
    'Response.Write  "TotalCount : " & nCnt  & "<br>"
    rCnt = 0
    j = 0
    
    If IsArray(LIST) Then
      For ar = LBound(LIST, 2) To UBound(LIST, 2) 
        Set rsarr = jsObject() 
        tTeamIDX = LIST(0,ar)
        tTeam = LIST(1,ar)
        tTeamNm = LIST(2,ar)
        tTeamSex = LIST(3,ar)
        rsarr("teamidx") = crypt.EncryptStringENC(tTeamIDX)
        rsarr("teamNm") = tTeamNm & "/" & tTeamSex
        rsarr("team") = crypt.EncryptStringENC(tTeam)
        rsarr("teamCode") = tTeam
        'Response.WRite j & "<br>"
        Set JSONarr(j) = rsarr
        j  = j  + 1
      Next
    End If			

    jsonstr = toJSON(JSONarr)
    Response.Write CStr(jsonstr)
    
  End if

%>
