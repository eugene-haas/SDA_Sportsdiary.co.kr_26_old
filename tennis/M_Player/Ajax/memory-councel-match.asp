<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iMemberIDX = fInject(Request("iMemberIDX"))
	GameTitleIDX = ""
	
	iMemberIDX = decode(iMemberIDX,0)

  'SDate = "2016-03-06"
  'EDate = "2017-03-10"
  'iPlayerIDX = "1403"


  Dim LRsCnt1, iAdtAdvice, iAdtAdviceCkYn, iWriteDate, iWriteDatea, iGameRerdIDX, iGameTitleIDX, iAdtAdviceRe
  dim CHK_NEWICON	
  
  LRsCnt1 = 0

  iType = "32"
  iSportsGb = "judo"
  enciType = encode(32,0)

  LSQL = "EXEC Memory_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        
        iGameRerdIDX = LRs("GameRerdIDX")
        iGameTitleIDX = LRs("GameTitleIDX")
        iAdtAdvice = ReplaceTagReText(LRs("AdtAdvice"))
        iAdtAdviceRe = replace(replace(ReplaceTagReText(LRs("AdtAdviceRe")), chr(10), "<br>"),Chr(32), "&nbsp;")
        iAdtAdviceCkYn = LRs("AdtAdviceCkYn")
        iWriteDate = LRs("WriteDate")
        
		If DateDiff("H", LRs("FWriteDate"), Now())<24 Then 
			CHK_NEWICON = TRUE
		Else
			CHK_NEWICON = FALSE	
		End IF
		
        if iWriteDate <> "" then
          iWriteDatea = Split(iWriteDate, "-")
        end if

        if iAdtAdviceCkYn <> "" then
          if iAdtAdviceCkYn = "Y" then
            iAdtAdviceCkYn = "on"
          else
            iAdtAdviceCkYn = "off"
          end if
        end if

        iWriteDate = iWriteDatea(0)&"."&iWriteDatea(1)&"."&iWriteDatea(2)
        enciGameRerdIDX = encode(iGameRerdIDX,0)
%>

<div class="panel panel-default">
  <div class="panel-heading" role="tab">
    <div class="panel-title">
      <p class="panel-ic-q sw-chara"><span onclick="javascript:iFavLink('<%=enciType %>','<%=enciGameRerdIDX %>','');" class="img-icon icon-<%=iAdtAdviceCkYn %>-favorite">★</span></p>
      <a data-toggle="collapse" data-parent="#sub_table" href=".collapse<%=LRsCnt1 %>" aria-expanded="true" aria-controls="collapse<%=LRsCnt1 %>">
      <p class="panel-txt-q"> [<%=iWriteDate %>] <%=iAdtAdvice %> <span class="ic-re" style="display:<%IF iAdtAdviceRe ="" Then response.Write "none" End IF%>">Re</span> <span class="ic-new" style="display:<%IF CHK_NEWICON = FALSE Then response.Write "none" End IF%>">N</span> </p>
      <p class="ic-caret sw"><span class="caret"></span></p>
      </a> </div>
  </div>
  <div class="collapse<%=LRsCnt1 %> panel-collapse collapse" role="tabpanel">
    <div class="panel-body">
      <!-- S: memory-txt 모아보기 설명 -->
      <div class="memory-txt container">
        <p class="user-cont"> <%=replace(replace(iAdtAdvice, chr(10), "<br>"),Chr(32), "&nbsp;")%> </p>
        <% if iAdtAdviceRe <> "" then %>
        <p class="reply"> <%=iAdtAdviceRe%> </p>
        <% end if %>
        <div class="btn-list">
          <!--<a href="javascript:iPageMoveTr();" class="training-diary" style="display: none;">훈련일지보기</a>
  	   <a href="javascript:iPageMoveGm();" class="match-diary">대회일지보기</a>-->
          <a href="../Schedule/sche-match.asp?GameRerdIDX=<%=iGameRerdIDX %>&GameTitleIDX=<%=iGameTitleIDX %>" class="match-diary">대회일지보기</a> </div>
      </div>
      <!-- E: memory-txt 모아보기 설명 -->
    </div>
  </div>
</div>
<!-- S: 사용 안함 -->
<form id="frmMenu">
  <input name="GameRerdIDX" id="GameRerdIDX" type="hidden" value="<%=iGameRerdIDX %>" />
  <input name="GameTitleIDX" id="GameTitleIDX" type="hidden" value="<%=iGameTitleIDX %>" />
</form>
<!-- E: 사용 안함 -->
<%
		iAdtAdviceRe = ""	
      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

%>
<script type="text/javascript">
  
  //동적으로 늘리거나 해야 해서 변경해야 함, 현재 사용 안함
  function iPageMoveGm() {
    $("#GameRerdIDX").attr("value");
    $("#GameTitleIDX").attr("value");
    $("#frmMenu").attr({ action: "../Schedule/sche-match.asp", method: 'post' }).submit();
  }

</script>
