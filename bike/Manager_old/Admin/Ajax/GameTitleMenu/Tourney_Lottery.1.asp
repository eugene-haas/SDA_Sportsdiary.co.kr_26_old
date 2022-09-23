<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
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
'개인전 대진표

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameLevelDtlidx 
Dim strRound
Dim GroupGameGb

Dim NextstrRound

Dim strjson_dtl

REQ = Request("Req")
'REQ = "{""CMD"":5,""GameLevelDtlIDX"":""963"",""strRound"":""1""}"


Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "TotRound") = "ok" then
    If ISNull(oJSONoutput.TotRound) Or oJSONoutput.TotRound = "" Then
      TotRound = ""
      DEC_TotRound = ""
    Else
      TotRound = fInject(oJSONoutput.TotRound) 
      DEC_TotRound = fInject(oJSONoutput.TotRound)    
    End If
  Else  
    TotRound = ""
    DEC_TotRound = ""
End if	

If hasown(oJSONoutput, "GameType") = "ok" then
    If ISNull(oJSONoutput.GameType) Or oJSONoutput.GameType = "" Then
      GameType = ""
      DEC_GameType = ""
    Else
      GameType = fInject(oJSONoutput.GameType) 
      DEC_GameType = fInject(oJSONoutput.GameType)    
    End If
  Else  
    GameType = ""
    DEC_GameType = ""
End if	

If hasown(oJSONoutput, "GroupGameGb") = "ok" then
    If ISNull(oJSONoutput.GroupGameGb) Or oJSONoutput.GroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""
    Else
      GroupGameGb = fInject(oJSONoutput.GroupGameGb) 
      DEC_GroupGameGb = fInject(oJSONoutput.GroupGameGb)    
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
End if	


strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<table class="tourney_admin table-fix-head 64" id="tourney_admin">
  <thead>
    <tr id="DP_GangBtn">
		<%For k = 1 To Cint(GangCnt)%>
		<th style="padding:2px">
        <a href="" class="btn_a btn_func" data-collap="" id="DP_Gang<%=k%>">8강</a>
		</th>
		<%Next%>
    </tr>
  </thead>
</table>
<div class="scroll_box">
  <table class="table-fix-body tourn-table">
    <tbody>
      <tr id="DP_Tr">
				<td id="DP_Td_1">
<%

For i = 1 To Cint(TotRound)
	If i mod 2 = 1 Then
%>
	<div class='player'>
<%
	Else
%>
	<div class='player'>
<%
	End If
%>
    <div class='pre-num'><%=i%></div>
    <div class='tourney_ctr_btn redy' onclick=cli_tourneyinsert('1','<%=i%>','<%=GameType%>',this)>
    <ul class='team clearfix'>
    <li>
    <input type='hidden' name='Hidden_Data' id='Hidden_Data_1_<%=i%>'>
    <span class='player' name='DP_UserName' id='DP_UserName_1_<%=i%>'>
    </span>
    <span class='player' style='font-size:15px;'>
    </span>
    </li>
    </ul>
    <div class='chk_win_lose'>
    </div>
    </div>
    </div>
<%
Next
%>
				</td>
      </tr>				
    </tbody>			
  </table>		
</div>



				
