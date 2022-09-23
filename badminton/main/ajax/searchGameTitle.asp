<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":""5"",""SVAL"":""가"", ""ENDGAME"":""1""}"
  
  Dim IsEndGame
  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
	tSVAL = Replace(fInject(oJSONoutput.SVAL),Chr(34), "")

  If( hasown(oJSONoutput, "ENDGAME") = "ok") Then 
    IsEndGame = oJSONoutput.ENDGAME
  Else 
    IsEndGame = "0"
  End If 

  If( hasown(oJSONoutput, "RECENTYEAR") = "ok") Then 
    nRecentYear = CDbl(oJSONoutput.RECENTYEAR)
  Else 
    nRecentYear = 0
  End If  

  IF LEN(tSVAL) = 1 Then
		top = "top 20"
	ELSEIF LEN(tSVAL) = 2 Then
		top = "top 20" 
	END IF
   
	LSQL = "SELECT " & top & " GameTitleIDX, GameTitleName, GameS, GameE, EnterType "
	LSQL =  LSQL & " FROM tblGameTitle a " 
	LSQL =  LSQL & " Where GameTitleName LIKE '%" &  tSVAL & "%' And a.DelYN = 'N'"

  If(nRecentYear > 0) Then 
    LSQL =  LSQL & " And DateDiff(Year, GameS, GetDate()) < " & nRecentYear
  End If 
  
  If(IsEndGame = 1) Then 
    LSQL =  LSQL & " And GameE < GetDate() "
  End If 
  LSQL =  LSQL & " Order by WriteDate Desc"

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
        rGameTitleIDX = LIST(0,ar)
        rGameTitleName = LIST(1,ar)
        rGameS = LIST(2,ar)
        rGameE = LIST(3,ar)
        rEnterType = LIST(4,ar)
        rsarr("uidx") = rGameTitleIDX
        rsarr("gameTitleName") = rGameTitleName
        rsarr("crypt_uidx") = crypt.EncryptStringENC(rGameTitleIDX)
        ' & " (" &  rGameS  & " ~ " & rGameE & " )"
        rsarr("gameS") =  rGameS 
        rsarr("gameE") =  rGameE 

        rsarr("EnterType") =  rEnterType 


        'Response.WRite j & "<br>"
        Set JSONarr(j) = rsarr
        j  = j  + 1
      Next
    End If			

    jsonstr = toJSON(JSONarr)
    Response.Write CStr(jsonstr)
    
  End if

%>
