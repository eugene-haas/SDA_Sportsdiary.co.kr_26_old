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
  REQ = Request("Req")
  'REQ = "{""CMD"":5,""tGameTitleIDX"":""C4F45D4766A741AF49900107ACE44658"",""tGameLevelDtlidx"":""090D6DAF05BA220EDE09B5392FA2E655"",""tRequestIDX"":""FEFAD3F366578919A2C0EE2AECFD4DBE"",""tGiftCheck"":""Y"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B""}"
  'REQ = "{""CMD"":1,""tGameTitleIdx"":""9832C70CDBBB6F8FB311345EF2AD1F2E""}"

  Dim constGroupGameGb_Person : constGroupGameGb_Person = "B0030001"
  Dim constGroupGameGb_Team : constGroupGameGb_Team = "B0030002"

  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGameLevelDtlidx") = "ok" then
    reqGameLevelDtlidx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlidx))
    crypt_reqGameLevelDtlidx =crypt.EncryptStringENC(reqGameLevelDtlidx)
  Else
    reqGameTitleIDX = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGameTitleIDX = ""
  End if	


  If hasown(oJSONoutput, "tGiftCheck") = "ok" then
    reqGiftCheck = fInject(oJSONoutput.tGiftCheck)
    crypt_reqGiftCheck = "" 
  End if	

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb= fInject(crypt.EncryptStringENC(reqGroupGameGb))
  End if	

  If hasown(oJSONoutput, "tRequestIDX") = "ok" then
    reqRequestIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tRequestIDX))
    crypt_reqRequestIDX= fInject(crypt.EncryptStringENC(reqRequestIDX))
  End if	
  
  If hasown(oJSONoutput, "tCanvasYN") = "ok" then
    reqCanvasYN = fInject(oJSONoutput.tCanvasYN)
  End if	
    
	LSQL = " SELECT	a.GameMedalIDX, a.GameTitleIDX,"
	LSQL = LSQL & "   a.GameLevelIDX,"
	LSQL = LSQL & "  a.GameLevelDtlIDX,"
	LSQL = LSQL & "  a.RequestIdx,"
	LSQL = LSQL & "  STUFF(("
	LSQL = LSQL & "  		SELECT  DISTINCT (  "
	LSQL = LSQL & "  SELECT  '|'   + UserName" 
	LSQL = LSQL & "  FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
	LSQL = LSQL & "  WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
	LSQL = LSQL & "  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
	LSQL = LSQL & "  AND DelYN = 'N'"
	LSQL = LSQL & "  FOR XML PATH('')  "
	LSQL = LSQL & "  )  "
	LSQL = LSQL & "  FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
	LSQL = LSQL & "  WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
	LSQL = LSQL & "  AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
	LSQL = LSQL & "  AND DelYN = 'N'"
	LSQL = LSQL & "  ),1,1,'') AS Players,"
	LSQL = LSQL & "  a.Team,"
	LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS TeamNM,"
	LSQL = LSQL & "  A.TeamDtl,"
	LSQL = LSQL & "  b.GroupGameGb,"
	LSQL = LSQL & "  dbo.FN_NameSch(b.GroupGameGb, 'PubCode') AS GroupGameGbNM,"
	LSQL = LSQL & "  b.Sex,"
	LSQL = LSQL & "  SexNm = (case b.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ),"
	LSQL = LSQL & "  b.PlayType,"
	LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(b.PlayType,'PubCode') AS PlayTypeNm,"
	LSQL = LSQL & "  b.TeamGb,"
	LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(b.TeamGb,'TeamGb') AS TeamGbNm, "
	LSQL = LSQL & "  b.Level,"
	LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(b.Level,'Level') AS LevelNm, "
	LSQL = LSQL & "  b.LevelJooName,"
	LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(b.LevelJooName,'PubCode') AS LevelJooNameNm, "
	LSQL = LSQL & "  b.LevelJooNum,"
	LSQL = LSQL & "  a.IsGIft,"
	LSQL = LSQL & "  ISNULL((Select Score From tblGameLevelScore c "
	LSQL = LSQL & "  	Where a.GameTitleIDX = c.GameTitleIdx and "
	LSQL = LSQL & "  		 a.GameRanking = c.Rank and "
	LSQL = LSQL & "  		 b.LevelJooName = c.Gubun),'0')as Score,"
	LSQL = LSQL & "  ISNULL(a.GameRanking,'0') AS GameRanking,"
	LSQL = LSQL & "  b.LevelJooName,"
  LSQL = LSQL & "  a.SignData"
	LSQL = LSQL & " FROM tblGameMedal a"
	LSQL = LSQL & " inner Join tblGameLevel b on a.GameLevelIDX = b.GameLevelidx and b.DelYN='N'"
	LSQL = LSQL & " WHERE A.DelYN = 'N' "
	LSQL = LSQL & " AND A.GameLevelDtlIDX = '" & reqGameLevelDtlidx & "' "
	LSQL = LSQL & " AND A.GroupGameGb = '" & reqGroupGameGb & "'"
	LSQL = LSQL & " AND A.RequestIDX = '" & reqRequestIDX & "'"

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    A_SexNM= LRs("SexNM")
    A_PlayTypeNM = LRs("PlayTypeNM")
    A_TeamGbNm= LRs("TeamGbNM")
    A_LevelNM= LRs("LevelNM")
    A_LevelJooNum= LRs("LevelJooNum")
    A_Team= LRs("Team")
    A_TeamNm= LRs("TeamNm")
    A_LevelJooName= LRs("LevelJooName")
    A_LevelJooNameNm= LRs("LevelJooNameNm")
    A_TeamDtl= LRs("TeamDtl")
    A_GameRanking = LRs("GameRanking")
    A_Players= LRs("Players")
    A_RequestIDX= LRs("RequestIDX")
    crypt_RequestIDX = crypt.EncryptStringENC(A_RequestIDX)
    A_GroupGameGb= LRs("GroupGameGb")
    crypt_GroupGameGb = crypt.EncryptStringENC(A_GroupGameGb)
    A_GameLevelDtlidx= LRs("GameLevelDtlidx")
    crypt_GameLevelDtlidx = crypt.EncryptStringENC(A_GameLevelDtlidx)
    IF A_Players <> "" Then
      Array_Players = Split(A_Players,"|")
    End IF
    A_IsGIft= LRs("IsGIft")
    A_ResultGangSu = GetGangSu(A_GameType, A_MaxRound,A_Round)
    A_Score= LRs("Score")
    SignData = LRs("SignData")

  End If

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"

  

%>
        <!-- S: modal-body -->
        <div class="modal-body">
         <!-- S: content-title -->
          <h3 class="content-title">
            <span class="redy">
              <%Response.Write A_SexNM & A_PlayTypeNM & A_TeamGbNm & " " & A_LevelNM %>
              <%
                IF A_LevelJooNameNm <> "" Then
                  RESPONSE.write  "-" & A_LevelJooNameNm  & A_LevelJooNum 
                End IF
              %> 
              <%
                IF A_GameRanking <> "0" and A_GameRanking <> "" Then
                  Response.Write " [" &A_GameRanking & "위]"
                End IF              
              %>              
              :
            </span> 
            <%
              IF ISARRAY(Array_Players) = true Then
                IF CDBL(UBound(Array_Players)) <> -1   Then
                  Response.Write Array_Players(0)
                End IF
              END if            
            %>            
            (<%=A_TeamNm%> <%IF LEN(A_TeamDtl) > 0 And A_TeamDtl <> "0" Then Response.Write A_TeamDtl End If%>)
            
						<!--<span>1번코트</span>
						<span>1경기</span>
            <span class="redy">혼합복식 40D123123213123213</span>
            <span class="redy">예선7조</span>-->
          </h3>
          <!-- E: content-title -->

          <!-- S: 마크업 -->
          
					<!-- S: 서명 -->
					<div class="sign_box">
            <span class="title">승자서명</span>
            <div id="DP_AREA_SIGN">
              <%If reqCanvasYN = "Y" Then%>
                <div class="sign_img">
                  <canvas id="DP_GiftSignature" width="370" height="160"></canvas>
                </div>
              <%Else%>

                <%If SignData <> "" AND NOT ISNULL(SignData) Then%>
                <a href="#" class="sign_delet_btn" onclick="PopupGiftSign('<%=crypt_GameLevelDtlidx%>','<%=crypt_RequestIDX%>','<%=crypt_GroupGameGb%>','Y')" >서명삭제<i class="fa fas fa-times"></i></a>
                <%End If%>

                <div class="sign_img">
                  <%If SignData = "" OR ISNULL(SignData) Then%>
                    <canvas id="DP_GiftSignature" width="370" height="160"></canvas>
                  <%Else%>
                    <img src="<%=SignData%>" width="370" height="160" alt="">
                  <%End If%>                
                </div>
              <%End If%>
            </div>

					</div>

          
					<!-- E: 서명 -->
					
          <!-- E: 마크업 -->
        </div>
        <!-- E: modal-body -->
        <!-- S: order-footer -->
        <div class="order-footer">
          <ul class="btn-list clearfix">
            <li><a href="#" class="btn btn-default" data-dismiss="modal">닫기</a></li>
            <li><a href="#" onclick="prc_GiftSignature('<%=crypt_GameLevelDtlidx%>','<%=crypt_RequestIDX%>','<%=crypt_GroupGameGb%>')" class="btn btn-red" data-dismiss="modal">수정</a></li>
          </ul>
        </div>        
  <%

  Set LRs = Nothing
  DBClose()
    
  %>  
  <%If SignData = "" OR ISNULL(SignData) OR reqCanvasYN = "Y" Then%>
  <script>
    /*--------------------싸인관련--------------------*/
    var canvas = document.getElementById('DP_GiftSignature');
   
    //canvas.width = screen.width;
    var context = canvas.getContext('2d');
    context.lineWidth = 10;
    context.lineCap = "round";
    $(canvas).bind({ "touchstart mousedown": function (event) {
        event.preventDefault();
        if (event.type == 'touchstart') {
            event = event.originalEvent.targetTouches[0];
        }
        $(this).data("flag", "1");
        var position = $(this).offset();
        var x = event.pageX - position.left;
        var y = event.pageY - position.top;
        console.log("start x: " + x + ", y: " + y);
        context.beginPath();
        context.moveTo(x, y);
    }, "mousemove touchmove": function (event) {
        event.preventDefault();
        if (event.type == 'touchmove') {
            event = event.originalEvent.targetTouches[0];
        }
        var flag = $(this).data("flag");
        if (flag == 1) {
            var position = $(this).offset();
            var x = event.pageX - position.left;
            var y = event.pageY - position.top;
            //console.log("move x: " + x + ", y: " + y);
        }
        context.lineTo(x, y);
        context.stroke();
    }, "mouseup touchend mouseleave": function (event) {
        event.preventDefault();
        console.log("type: " + event.type);
        if (event.type == 'touchend') {
            event = event.originalEvent.changedTouches[0];
        }
        $(this).data("flag", "0");
        var position = $(this).offset();
        var x = event.pageX - position.left;
        var y = event.pageY - position.top;
        console.log("end: " + x + ", y: " + y);
        //  context.lineTo(x, y);
        //  context.stroke();
    }
    });
    $("#id_clear").click(function () {
        canvas.width = canvas.width;
        context.lineWidth = 10;
        context.lineCap = "round";
    });

    //싸인 승인완료
    /*--------------------싸인관련--------------------*/  
</script>
<%End If%>