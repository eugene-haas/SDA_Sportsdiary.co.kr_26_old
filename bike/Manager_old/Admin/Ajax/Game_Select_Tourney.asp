
<!-- #include file="../dev/dist/config.asp"-->
<!-- #include file="../classes/JSON_2.0.4.asp" -->
<!-- #include file="../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../classes/json2.asp" -->
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


'REQ = Request("Req")
REQ = "{""CMD"":1,""GameTitleIDX"":""0B5EB9CEFAF1E107711072C78C2E36F8"",""GroupGameGb"":"""",""PlayType"":"""",""TeamGb"":"""",""Level"":""""}"


Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameTitleIDX") = "ok" then
  GameTitleIDX = fInject(oJSONoutput.GameTitleIDX)
  DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameTitleIDX))
Else
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
End if	   

If hasown(oJSONoutput, "GroupGameGb") = "ok" then
  GroupGameGb = fInject(oJSONoutput.GroupGameGb)
  DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.GroupGameGb))
Else
    GroupGameGb = ""
    DEC_GroupGameGb = ""
End if	   


If hasown(oJSONoutput, "PlayType") = "ok" then
    PlayType = fInject(oJSONoutput.PlayType)
    IF( PlayType = "") Then
      PlayType = "|"
    End if

Else
    PlayType = "|"
End if	   

If hasown(oJSONoutput, "TeamGb") = "ok" then
  TeamGb = fInject(oJSONoutput.TeamGb)
  DEC_TeamGbCode = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGb))
Else
    TeamGb = ""
    DEC_TeamGbCode = ""
End if	   

If hasown(oJSONoutput, "Level") = "ok" then
    Level = fInject(oJSONoutput.Level)
    DEC_Level = fInject(crypt.DecryptStringENC(oJSONoutput.Level))
Else
    Level = ""
    DEC_Level = ""
End if	   

Arr_PlayType = Split(PlayType,"|")

DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))

 strjson = JSON.stringify(oJSONoutput)
 Response.Write strjson
 Response.write "`##`"

%>

     <ul class="sel_list clearfix">
       <li class="row_2 sel_box">
         <select id="sel_GroupGameGb" onchange="sch_SelectGroup();">
          <%

            LSQL = " SELECT KoreaBadminton.dbo.FN_NameSch(GroupGameGb, 'PubCode') AS GroupGameGbNM, GroupGameGb"
            LSQL = LSQL & " FROM KoreaBadminton.dbo.tblgamelevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " GROUP BY GroupGameGb"
            LSQL = LSQL & " ORDER BY GroupGameGb"
            Response.Write "LSQL : " &  LSQL & "<BR>"
           
            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

              GroupGameGbCnt = 0 
                
              Do Until LRs.Eof

              If GroupGameGbCnt = 0 Then
                If DEC_GroupGameGb = "" Then
                  DEC_GroupGameGb = LRs("GroupGameGb")
                End If     
              End If         

          %>
           <option> </option>
          <%
                GroupGameGbCnt = GroupGameGbCnt+ 1

                LRs.MoveNext
              Loop

            End If

            LRs.Close       
       
          %>
         </select>
       </li>
       <%
       'RESPONSE.END
       %>
       <li class="row_2 sel_box">
         <select id="sel_LevelPlayType" onchange="sch_SelectGroup();">
          <%

            LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
            LSQL = LSQL & " FROM tblGameLevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
            LSQL = LSQL & " GROUP BY Sex, PlayType"
            Response.Write "LSQL" &  LSQL & "<BR>"
            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

              PlayTypeCnt = 0 

              Do Until LRs.Eof

              If PlayTypeCnt = 0 Then
                If DEC_Sex = "" Then
                  DEC_Sex = LRs("Sex")
                End If     
              End If      

              If PlayTypeCnt = 0 Then
                If DEC_PlayType = "" Then
                  DEC_PlayType = LRs("PlayType")
                End If     
              End If                    

          %>
           <option></option>
          <%
                PlayTypeCnt = PlayTypeCnt + 1
                LRs.MoveNext
              Loop

            End If

            LRs.Close
                      
          %>         
         </select>

       </li>
     </ul>
   
     <ul class="sel_list clearfix">
       <li class="row_2 sel_box">

         <select id="sel_TeamGb" onchange="sch_SelectGroup();">
          <%

            LSQL = " SELECT TeamGb, KoreaBadminton.dbo.FN_NameSch(TEamGb,'TeamGb') AS TeamGbNM"
            LSQL = LSQL & " FROM tblGameLevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
            LSQL = LSQL & " AND Sex = '" & DEC_Sex & "'"
            LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "'"
            LSQL = LSQL & " GROUP BY TeamGb, Sex"
            Response.Write "LSQL" &  LSQL & "<BR>"
            Set LRs = Dbcon.Execute(LSQL)

            TeamGbCnt = 0

            If Not (LRs.Eof Or LRs.Bof) Then

              

              Do Until LRs.Eof

                If TeamGbCnt = 0 Then

                  If DEC_TeamGbCode = "" Then
                    DEC_TeamGbCode = LRs("TeamGb")
                  End If     
                End If                  
          %>
           <option value="">asdasda</option>
          <%
                  TeamGbCnt = TeamGbCnt + 1
                LRs.MoveNext
              Loop

            End If

            LRs.Close          
          %>      
        
         </select>
         <%=LSQL%>
         <%=i%>

         

       </li>
     
       <li class="row_2 sel_box" >
         <select id="sel_Level" onchange="sch_SelectGroup();">
         <%
          LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNM , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNM, LevelJooName,"
          LSQL = LSQL & " LevelJooNum "
          LSQL = LSQL & " FROM tblGameLevel "
          LSQL = LSQL & " WHERE DelYN = 'N' "
          LSQL = LSQL & " AND UseYN = 'Y' "
          LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "
          LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "' "
          LSQL = LSQL & " AND Sex = '" & DEC_Sex & "' "
          LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "' "
          LSQL = LSQL & " AND TeamGb = '" & DEC_TeamGbCode & "' "
          LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"     

          Response.WRite "LSQL 문제 :" & LSQL & "<Br>"
     
   
     
  
          Dim LevelCnt : LevelCnt = 0 
          Set LRs = Dbcon.Execute(LSQL)
   
          If Not (LRs.Eof Or LRs.Bof) Then

            LevelCnt = 0

            Do Until LRs.Eof              

              If LevelCnt = 0 Then
                DEC_Level = LRs("Level")
                DEC_LevelJooName = LRs("LevelJooName")
                DEC_LevelJooNum = LRs("LevelJooNum")
              End If   
                                     
         %>
           <option><%=LevelCnt%></option>
         <%
              LevelCnt = LevelCnt + 1
               LRs.MoveNext
	          Loop      
          End IF   

          LRs.Close
         %>
         </select>

       </li>
       
     </ul>
<%

Set LRs = Nothing
DBClose()
%>