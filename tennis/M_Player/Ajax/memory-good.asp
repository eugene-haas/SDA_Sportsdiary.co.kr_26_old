<!--#include file= "../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = ""
	
	iPlayerIDX = decode(iPlayerIDX,0)

  'SDate = "2016-03-06"
  'EDate = "2017-03-10"
  'iPlayerIDX = "1403"


  Dim LRsCnt1, iAdtWell, iAdtWellCkYn, iWriteDate, iWriteDatea, iTrRerdIDX, iTrRerdDate, enciTrRerdIDX, enciType
  LRsCnt1 = 0

  iType = "1"
  iSportsGb = "judo"
  enciType = encode(1,0)

  LSQL = "EXEC Memory_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1

        iTrRerdIDX = LRs("TrRerdIDX")
        iTrRerdDate = LRs("TrRerdDate")
		iAdtWell = ReplaceTagReText(LRs("AdtWell"))        
        iAdtWellCkYn = LRs("AdtWellCkYn")
        iWriteDate = LRs("WriteDate")
        
        if iWriteDate <> "" then
          iWriteDatea = Split(iWriteDate, "-")
        end if

        if iAdtWellCkYn <> "" then
          if iAdtWellCkYn = "Y" then
            iAdtWellCkYn = "on"
          else
            iAdtWellCkYn = "off"
          end if
        end if

        iWriteDate = iWriteDatea(0)&"."&iWriteDatea(1)&"."&iWriteDatea(2)
        enciTrRerdIDX = encode(iTrRerdIDX,0)
%>

<div class="panel panel-default">
  <div class="panel-heading" role="tab">
   <div class="panel-title">
    <p class="panel-ic-q sw-chara"><span onclick="javascript:iFavLink('<%=enciType %>','<%=enciTrRerdIDX %>','');" class="img-icon icon-<%=iAdtWellCkYn %>-favorite">★</span></p>
    <a data-toggle="collapse" data-parent="#sub_table" href=".collapse<%=LRsCnt1 %>" aria-expanded="true" aria-controls="collapse<%=LRsCnt1 %>">
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
  	   <!--<a href="javascript:iPageMoveTr();" class="training-diary">훈련일지보기</a>
  	   <a href="javascript:iPageMoveGm();" class="match-diary" style="display: none;">대회일지보기</a>-->
       <a href="../Schedule/sche-train.asp?TrRerdIDX=<%=iTrRerdIDX %>&TrRerdDate=<%=iTrRerdDate %>" class="training-diary">훈련일지보기</a>
     </div>
    </div>
    <!-- E: memory-txt 모아보기 설명 -->
   </div>
  </div>
</div>

<!-- S: 사용 안함 -->
<form id="frmMenu">
  <input name="TrRerdIDX" id="TrRerdIDX" type="hidden" value="<%=iTrRerdIDX %>" />
  <input name="TrRerdDate" id="TrRerdDate" type="hidden" value="<%=iTrRerdDate %>" />
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
  function iPageMoveTr() {
    //alert($("#TrRerdDate").attr("value"));
    $("#TrRerdIDX").attr("value");
    $("#TrRerdDate").attr("value");
    $("#frmMenu").attr({ action: "../Schedule/sche-train.asp", method: 'post' }).submit();
  }

</script>

