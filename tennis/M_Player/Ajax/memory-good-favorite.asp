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


  Dim LRsCnt1, iAdtWell, iWriteDate, iWriteDatea, iGameRerdIDX, iTrRerdIDX, iGameTitleIDX, iTrRerdDate, iMemoryType, enciRerdIDX, enciType
  LRsCnt1 = 0

  iType = "3"
  iSportsGb = "judo"
  enciType = encode(3,0)

  LSQL = "EXEC Memory_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        
        iGameRerdIDX = LRs("GameRerdIDX")
        iTrRerdIDX = LRs("TrRerdIDX")
        iGameTitleIDX = LRs("GameTitleIDX")
        iTrRerdDate = LRs("TrRerdDate")
        iAdtWell = ReplaceTagReText(LRs("AdtWell"))
        iWriteDate = LRs("WriteDate")
        iMemoryType = LRs("MemoryType")
         
        if iWriteDate <> "" then
          iWriteDatea = Split(iWriteDate, "-")
        end if

        iWriteDate = iWriteDatea(0)&"."&iWriteDatea(1)&"."&iWriteDatea(2)
        
        if iMemoryType = "Tr" then
          enciRerdIDX = encode(iTrRerdIDX,0)
        elseif iMemoryType = "Gm" then
          enciRerdIDX = encode(iGameRerdIDX,0)
        end if
        
%>

<div class="panel panel-default">
  <div class="panel-heading" role="tab">
   <div class="panel-title">
    <span class="panel-ic-q sw-chara"><span onclick="javascript:iFavLink('<%=enciType %>','<%=enciRerdIDX %>','<%=iMemoryType %>');" class="icon-on-favorite">★</span></span>
    <a data-toggle="collapse" data-parent="#sub_table" href=".collapse<%=LRsCnt1 %>" aria-expanded="true" aria-controls="collapse<%=LRsCnt1 %>">
      <!--//<span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt="" /></span>-->
      <p class="panel-txt-q">
        [<%=iWriteDate %>] <%=iAdtWell %>
      </p>
      <p class="ic-caret sw"><span class="caret"></span></p>
    </a>
   </div>
  </div>
  <div class="collapse<%=LRsCnt1 %> panel-collapse collapse" role="tabpanel">
   <div class="panel-body">
    <!-- S: memory-txt 모아보기 설명 -->
    <div class="memory-txt container">
     <p class="user-cont">
       <%=replace(replace(iAdtWell, chr(10), "<br>"),Chr(32), "&nbsp;")%>
    </p>
    <!--<p class="reply">
      고맙다^^ <br>
      훈련은 어떤 종목을 추가로 하고 싶은지 다음 수업 때
      한번 얘기해보자꾸나. <br>
      열심히 하는 모습 너무 기특하다! <br>
      다음 경기때까지 열심히 해서 좋은 결과 받도록하자~
    </p>-->
    <div class="btn-list">
      <% if iMemoryType = "Gm" then %>
        <!--<a href="javascript:iPageMoveTr();" class="training-diary" style="display: none;">훈련일지보기</a>
        <a href="javascript:iPageMoveGm();" class="match-diary">대회일지보기</a>-->
      <a href="../Schedule/sche-match.asp?GameRerdIDX=<%=iGameRerdIDX %>&GameTitleIDX=<%=iGameTitleIDX %>" class="match-diary">대회일지보기</a>
      <% else %>
        <!--<a href="javascript:iPageMoveTr();" class="training-diary">훈련일지보기</a>
        <a href="javascript:iPageMoveGm();" class="match-diary" style="display: none;">대회일지보기</a>-->
      <a href="../Schedule/sche-train.asp?TrRerdIDX=<%=iTrRerdIDX %>&TrRerdDate=<%=iTrRerdDate %>" class="training-diary">훈련일지보기</a>
      <% end if %>
     </div>
    </div>
    <!-- E: memory-txt 모아보기 설명 -->
   </div>
  </div>
</div>

<!-- S: 사용 안함 -->
<form id="frmMenu">
  <% if iMemoryType = "Gm" then %>
    <input name="TrRerdIDX" id="GameRerdIDX" type="hidden" value="<%=iGameRerdIDX %>" />
    <input name="TrRerdDate" id="GameTitleIDX" type="hidden" value="<%=iGameTitleIDX %>" />
  <% else %>
    <input name="TrRerdIDX" id="TrRerdIDX" type="hidden" value="<%=iTrRerdIDX %>" />
    <input name="TrRerdDate" id="TrRerdDate" type="hidden" value="<%=iTrRerdDate %>" />
  <% end if %>
</form>
<!-- E: 사용 안함 -->

<%

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

  function iPageMoveTr() {
    $("#TrRerdIDX").attr("value");
    $("#TrRerdDate").attr("value");
    $("#frmMenu").attr({ action: "../Schedule/sche-train.asp", method: 'post' }).submit();
  }

</script>

