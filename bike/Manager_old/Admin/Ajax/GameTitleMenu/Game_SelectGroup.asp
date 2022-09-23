<!--#include file="../Library/config.asp"-->
<!--#include file="../Library/JSON_2.0.4.asp" -->
<!--#include file="../Library/JSON_UTIL_0.1.1.asp" -->
<!--#include file="../Library/json2.asp" -->
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
	Dim LSQL
	Dim LRs
	Dim strjson
	Dim strjson_sum

	Dim oJSONoutput_SUM
	Dim oJSONoutput

	Dim CMD  
	Dim GameTitleIDX 	

  REQ = Request("Req")
  'REQ = "{""CMD"":1,""GameTitleIDX"":""7CF03B23B9A19495C66E7DCEE4683D5E"",""GameDay"":""2018-03-30"",""StadiumIDX"":""7E2B6A8B1DAF27BFC004DF097801F4CE"",""StadiumNumber"":""1"",""PlayType"":null,""IngType"":""45E500538E0FD452A763FA5041E332C2""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "GameTitleIDX") = "ok" then
    GameTitleIDX = fInject(oJSONoutput.GameTitleIDX)
    DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameTitleIDX))
  Else  
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
  End if	

	If hasown(oJSONoutput, "GameDay") = "ok" then
    If ISNull(oJSONoutput.GameDay) Or oJSONoutput.GameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.GameDay)
      DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.GameDay))    
    End If
  Else  
    GameDay = ""
    DEC_GameDay = ""
	End if	

	If hasown(oJSONoutput, "StadiumIDX") = "ok" then
    If ISNull(oJSONoutput.StadiumIDX) Or oJSONoutput.StadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.StadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.StadiumIDX))    
    End If
  Else  
    StadiumIDX = ""
    DEC_StadiumIDX = ""
	End if	

	If hasown(oJSONoutput, "StadiumNumber") = "ok" then
    If ISNull(oJSONoutput.StadiumNumber) Or oJSONoutput.StadiumNumber = "" Then
      StadiumNumber = ""
      DEC_StadiumNumber = ""        
    Else
      StadiumNumber = fInject(oJSONoutput.StadiumNumber)
      DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.StadiumNumber))
    End If
  Else  
    StadiumNumber = ""
    DEC_StadiumNumber = ""
	End if	

	If hasown(oJSONoutput, "PlayType") = "ok" then
    If ISNull(oJSONoutput.PlayType) Or oJSONoutput.PlayType = "" Then
      PlayType = ""
      DEC_PlayType = ""        
      
    Else
      PlayType = fInject(oJSONoutput.PlayType)
      DEC_PlayType = fInject(crypt.DecryptStringENC(oJSONoutput.PlayType))
    End If
  Else  
    PlayType = ""
    DEC_PlayType = ""
	End if	    

	If hasown(oJSONoutput, "IngType") = "ok" then
    If ISNull(oJSONoutput.StadiumNumber) Or oJSONoutput.StadiumNumber = "" Then
    IngType = ""
    DEC_IngType = ""
    Else
    IngType = fInject(oJSONoutput.IngType)
    DEC_IngType = fInject(crypt.DecryptStringENC(oJSONoutput.IngType))    
    End If
  Else  
    IngType = ""
    DEC_IngType = ""
	End if	          


  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
        <ul class="sel_list clearfix">
          <!-- <li class="row_3 date sel_box sel_list"> -->
          <li class="row_3 date sel_box" id="li_GameDay">
            <select id="GameDay" name="GameDay" onchange="sch_SelectGroup();">
            <%

              LSQL = " SELECT GameDay"
              LSQL = LSQL & " FROM "
              LSQL = LSQL & " ("
              LSQL = LSQL & " SELECT GameDay"
              LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
              LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
              LSQL = LSQL & " WHERE A.DelYN = 'N'"
              LSQL = LSQL & " AND B.DelYN = 'N'"
              LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
              LSQL = LSQL & " AND GameDay IS NOT NULL"
              LSQL = LSQL & " "
              LSQL = LSQL & " UNION ALL"
              LSQL = LSQL & " "
              LSQL = LSQL & " SELECT GameDay"
              LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
              LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
              LSQL = LSQL & " WHERE A.DelYN = 'N'"
              LSQL = LSQL & " AND B.DelYN = 'N'"
              LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
              LSQL = LSQL & " AND GameDay IS NOT NULL"
              LSQL = LSQL & " ) AS AA"
              LSQL = LSQL & " GROUP BY AA.GameDay"

              Set LRs = Dbcon.Execute(LSQL)


              If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
              %>
                  <option value="<%=LRs("GameDay") %>" <%If GameDay = LRs("GameDay") Then%>selected<%End If%>><%=LRs("GameDay") %></option>
              <%
                  LRs.MoveNext
                Loop

              End If

              LRs.Close
              %>
              </select>

          </li>
          <li class="row_2 sel_box" id="li_StadiumIDX">
            <select id="StadiumIDX" name="StadiumIDX" onchange="sch_SelectGroup();">
              <%
                LSQL = " SELECT AA.StadiumIDX, AA.StadiumName"
                LSQL = LSQL & " FROM"
                LSQL = LSQL & " ("
                LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " FROM tblTourney A"
                LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N' "
                LSQL = LSQL & " AND B.DelYN = 'N'"
                LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
                LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
                LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
                LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " "
                LSQL = LSQL & " UNION ALL"
                LSQL = LSQL & " "
                LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " FROM tblTourneyTeam A"
                LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N' "
                LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
                LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
                LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
                LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " ) AA"
                LSQL = LSQL & " GROUP BY AA.StadiumIDX, AA.StadiumName"
              
                Set LRs = Dbcon.Execute(LSQL)

                If Not (LRs.Eof Or LRs.Bof) Then

                    Set oJSONoutput = jsArray()

                  Do Until LRs.Eof

                %>
                    <option value="<%=crypt.EncryptStringENC(LRs("StadiumIDX"))%>" <%If DEC_StadiumIDX = LRs("StadiumIDX") Then%>selected<%End If%>><%=LRs("StadiumName")%></option>
                <%

                    LRs.MoveNext
                  Loop

                Else

                End If            

                LRs.Close    
              %>
            </select>
          </li>
        </ul>
        <ul class="sel_list clearfix">
          <li class="row_3 sel_box" id="li_StadiumNumber">
            <select id="StadiumNumber" name="StadiumNumber" onchange="sch_SelectGroup();">
              <%
              LSQL = " SELECT StadiumNum"
              LSQL = LSQL & " FROM"
              LSQL = LSQL & " ("
              LSQL = LSQL & " SELECT StadiumNum"
              LSQL = LSQL & " FROM tblTourney "
              LSQL = LSQL & " WHERE DelYN = 'N' "
              LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
              LSQL = LSQL & " AND GameDay = '" & GameDay & "'"
              LSQL = LSQL & " AND StadiumIDX = '" & DEC_StadiumIDX & "'"
              LSQL = LSQL & " AND ISNULL(StadiumNum,'') <> ''"
              LSQL = LSQL & " GROUP BY StadiumNum"
              LSQL = LSQL & " "
              LSQL = LSQL & " UNION ALL"
              LSQL = LSQL & " "
              LSQL = LSQL & " SELECT StadiumNum"
              LSQL = LSQL & " FROM tblTourneyTeam "
              LSQL = LSQL & " WHERE DelYN = 'N' "
              LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
              LSQL = LSQL & " AND GameDay = '" & GameDay & "'"
              LSQL = LSQL & " AND StadiumIDX = '" & DEC_StadiumIDX & "'"
              LSQL = LSQL & " AND ISNULL(StadiumNum,'') <> ''"
              LSQL = LSQL & " GROUP BY StadiumNum"
              LSQL = LSQL & " ) AS AA"
              LSQL = LSQL & " GROUP BY StadiumNum"
              LSQL = LSQL & " ORDER BY CONVERT(Bigint,StadiumNum)"

              Set LRs = Dbcon.Execute(LSQL)

              If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
              %>
                  <option value="<%=LRs("StadiumNum") %>" <%If StadiumNumber = LRs("StadiumNum") Then%>selected<%End If%>><%=LRs("StadiumNum") %></option>
              <%
                  LRs.MoveNext
                Loop

              Else

              End If      

              LRs.Close        
              %>
            </select>
          </li>
          <li class="row_3 sel_box" onchange="sch_SelectGroup();">
            <select id="PlayType" name="PlayType">
              <%
                LSQL = " SELECT PlayLevelType, PlayLevelTypeNM"
                LSQL = LSQL & " FROM"
                LSQL = LSQL & " ("
                LSQL = LSQL & " SELECT PlayLevelType, KoreaBadminton.dbo.FN_NameSch(PlayLevelType,'PubCode') AS PlayLevelTypeNM"
                LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevelDtl A"
                LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblTourney B ON B.GameLevelDtlIDX = A.GameLevelDtlIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N'"
                LSQL = LSQL & " AND B.DelYN = 'N'"
                LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "' "
                LSQL = LSQL & " AND B.GameDay = '" & GameDay & "' "
                LSQL = LSQL & " AND B.StadiumNum = '" & StadiumNumber & "'"
                LSQL = LSQL & " "
                LSQL = LSQL & " UNION ALL"
                LSQL = LSQL & " "
                LSQL = LSQL & " SELECT PlayLevelType, KoreaBadminton.dbo.FN_NameSch(PlayLevelType,'PubCode') AS PlayLevelTypeNM"
                LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevelDtl A"
                LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblTourneyTeam B ON B.GameLevelDtlIDX = A.GameLevelDtlIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N'"
                LSQL = LSQL & " AND B.DelYN = 'N'"
                LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "' "
                LSQL = LSQL & " AND B.GameDay = '" & GameDay & "' "
                LSQL = LSQL & " AND B.StadiumNum = '" & StadiumNumber & "'"
                LSQL = LSQL & " ) AS AA"
                LSQL = LSQL & " GROUP BY AA.PlayLevelType, PlayLevelTypeNM"

                Set LRs = Dbcon.Execute(LSQL)      

                If Not (LRs.Eof Or LRs.Bof) Then

                  Do Until LRs.Eof

                  %>
                  <option value="<%=crypt.EncryptStringENC(LRs("PlayLevelType")) %>" <%If DEC_PlayType = LRs("PlayLevelType") Then%>selected<%End If%>><%=LRs("PlayLevelTypeNM") %></option>
                  <%

                    LRs.MoveNext

                  Loop

                Else

                End If    

                LRs.Close                    
              %>
            </select>
          </li>
          <li class="row_3 sel_box">
            <select id="IngType" name="IngType" onchange="sch_SelectGroup();">
              <option value="<%=crypt.EncryptStringENC("ALL")%>" <%If DEC_IngType = "ALL" Then%>selected<%End If%>>=전체=</option>
              <option value="<%=crypt.EncryptStringENC("GameEmpty")%>" <%If DEC_IngType = "GameEmpty" Then%>selected<%End If%>>경기입력</option>
              <option value="<%=crypt.EncryptStringENC("GameIng")%>" <%If DEC_IngType = "GameIng" Then%>selected<%End If%>>경기중</option>
              <option value="<%=crypt.EncryptStringENC("GameEnd")%>" <%If DEC_IngType = "GameEnd" Then%>selected<%End If%>>결과/수정</option>
            </select>
          </li>
        </ul>

<%

Set LRs = Nothing
DBClose()
  
%>