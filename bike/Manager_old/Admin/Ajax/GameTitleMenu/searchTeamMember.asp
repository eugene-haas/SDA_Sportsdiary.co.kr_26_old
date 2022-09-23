<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":""5"",""SVAL"":""김"",""TeamIdx"":""774FC80ECB8B0D1D21F45EDB72AE3AFE""}"
  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
	tSVAL = Replace(fInject(oJSONoutput.SVAL),Chr(34), "")
  teamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.TeamIdx))

  IF LEN(tSVAL) = 1 Then
		top = "top 20"
	ELSEIF LEN(tSVAL) = 2 Then
		top = "top 20"
	END IF
  
  LSQL = " SELECT	Top 1 b.TeamNm, b.Team "
  LSQL = LSQL & "  FROM tblGameRequestTeam a  "
  LSQL = LSQL & "  LEFT JOIN tblTeamInfo b on a.Team = b.Team and b.DelYN ='N' "
  LSQL = LSQL & " WHERE a.DelYN = 'N' and GameRequestTeamIDX = " & teamIdx 
	
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL & "<br>"
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeam = LRS("Team")
      tTeamNm = LRS("TeamNm")

    
      
      LRs.MoveNext
    Loop
  End IF

  if tTeam <> "" Then

  LSQL = "SELECT Top 1 isnull(TeamType,'') as TeamType"
	LSQL =  LSQL & " FROM tblTeamInfo a " 
	LSQL =  LSQL & " Where Team = '" &  tTeam & "'"
  'Response.Write "LSQL : " & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    TeamType = LRs("TeamType")
  End If

	LSQL = "SELECT " & top & " MemberIDX, UserName,  b.TeamNM, B.EnterType, b.Team"
  LSQL =  LSQL & " ,Case When b.Sex = 'Man' Then  '남자팀' When b.Sex = 'Woman' Then  '여자팀'  When b.Sex = 'Mix' Then  '혼성팀'  ELSE '' END as TeamSex " 
  LSQL =  LSQL & " FROM tblMember a " 
  LSQL =  LSQL & " Left Join tblTeamInfo b on a.Team = b.Team and b.DelYN='N' " 
	LSQL =  LSQL & " Where a.UserName LIKE '" &  tSVAL & "%' And a.DelYN = 'N'  and b.PTeamIDX is not null "
  IF TeamType <> "sido" Then
  LSQL =  LSQL & " And b.Team = '" &  tTeam & "'"
  End IF
  'Response.Write "LSQL : " & LSQL & "<BR>"
  
  'Response.Write "LSQL : " & LSQL & "<BR>"
  
   Set rs = DBCon.Execute(LSQL)
'
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
        tMemberIdx = LIST(0,ar)
        tUserName = LIST(1,ar)
        tTeamNm  = LIST(2,ar)
        EnterType  = LIST(3,ar)
        tMemberTeam  = LIST(4,ar)
        tTeamSex = LIST(5,ar)

        

        If EnterType = "E" Then
          tEnterType = "엘리트" & "/" &  tMemberTeam & "/" & tTeamSex 
        ElseIf EnterType = "A" Then
          tEnterType = "생체" & "/" &  tMemberTeam & "/" & tTeamSex
        Else
          tEnterType = EnterType
        End If

        rsarr("uidx") = crypt.EncryptStringENC(tMemberIdx)
        rsarr("data") = tUserName
        rsarr("team") = crypt.EncryptStringENC(tTeam)
        rsarr("teamNm") = tTeamNm
        rsarr("tEnterType") = tEnterType
        
        'Response.WRite j & "<br>"
        Set JSONarr(j) = rsarr
        j  = j  + 1
      Next
    End If			
    jsonstr = toJSON(JSONarr)
    Response.Write CStr(jsonstr)
      End if
  End if

%>
