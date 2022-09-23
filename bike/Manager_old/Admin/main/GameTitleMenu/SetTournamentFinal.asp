<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"--> 
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
  iLoginID = fInject(crypt.DecryptStringENC(Request.cookies(global_HP)("UserID")))
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>
  
<script type="text/javascript">

CMD_SEARCHGAMETITLE = 1
CMD_SEARCHGAMELEVELDTL = 2
CMD_UPDATEFINALTOURNAMNET = 3
$(document).ready(function(){
  init();
}); 

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SEARCHGAMELEVELDTL:
          if(dataType == "html")
          {
            $('#schDivResult').html(htmldata); 
          }break;

    case CMD_UPDATEFINALTOURNAMNET:
    if(dataType == "json")
    {
      alert("본선 생성 완료")
    }break;
    default:
      break;
  }
};

init = function(){
  initSearchControl();
};

function OnSearchClick(){
  Url = "/Ajax/GameTitleMenu/selGameLevelDtl_SetTournamentFinal.asp"
  var packet = {};
  packet.CMD = CMD_SEARCHGAMELEVELDTL;
  packet.tGameTitleIdx = $("#selGameTitleIdx").val();
  SendPacket(Url, packet);
}

function initSearchControl()
{
  $( "#strGameTtitle" ).autocomplete({
    source : function( request, response ) {
      $.ajax(
        {
            type: 'post',
            url: "../../Ajax/GameTitleMenu/searchGameTitle.asp",
            dataType: "json",
            data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term}) },
            success: function(data) {
                //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                response(
                    $.map(data, function(item) {
                        return {
                            label: item.gameTitleName + "(" + item.gameS + "~" + item.gameE + ")" + ", 번호 : " + item.uidx,
                            value: item.gameTitleName,
                            tidx : item.uidx,
                            gameTitleName : item.gameTitleName,
                            crypt_tidx : item.crypt_uidx
                        }
                    })
                );
            }
        }
      );
    },
        //조회를 위한 최소글자수
        minLength: 1,
        select: function( event, ui ) {
          var obj = {}
          obj.CMD = CMD_SEARCHGAMETITLE;
          obj.tIdx = ui.item.tidx;
          obj.crypt_tIdx = ui.item.crypt_tidx;
          obj.tGameTitleName = ui.item.gameTitleName;

          $("#selGameTitleIdx").val(obj.crypt_tIdx);
          OnSearchClick();
        }
    });
}

function InitTournamnetFinal () {
  Url = "/Ajax/GameTitleMenu/UpdateGameLevelDtl_SetTournamentFinal.asp"
  GameLevelDtlIdxTotalCnt = $("#GameLevelDtlIdxTotalCnt").val();
  
  var strGameLevelDtl = ""
  for (i = 1 ; i <= GameLevelDtlIdxTotalCnt ; i++)
  {
    strGameLevelDtl = strGameLevelDtl + $("#GameLevelDtlIdx_" + i ).html() + "^" +  $("#GroupGameGb_" + i ).val() + "%" ;
  }
  var packet = {};
  packet.CMD = CMD_UPDATEFINALTOURNAMNET;
  packet.tGameLevelDtlIdx = strGameLevelDtl;
  SendPacket(Url, packet);
}
  
  </script>
    <%
  'response.Write "NowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPage="&NowPage&"<br>"
  'response.Write "iTotalCountiTotalCountiTotalCountiTotalCountiTotalCountiTotalCount="&iTotalCount&"<br>"
  'response.Write "iTotalPageiTotalPageiTotalPageiTotalPageiTotalPageiTotalPage="&iTotalPage&"<br>" 
  'response.Write "PagePerDataPagePerDataPagePerDataPagePerDataPagePerDataPagePerData="&PagePerData&"<br>"  
  'response.Write "BlockPageBlockPageBlockPageBlockPageBlockPageBlockPageBlockPageBlockPage="&BlockPage&"<br>"  

  ' 게임 타입 ( 국제, 국내 대회 )
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B001'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameTitleType = LRs.getrows()
  End If
%>
    
    <!-- S: content -->
    <div id="content" class="gameTitle index"> 
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>대회</h2>
        
        <!-- S: 네비게이션 -->
        <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
          <ul>
        
          </ul>
        </div>
        <!-- E: 네비게이션 --> 
        
      </div>
      <!-- E: page_title --> 
      
      <!-- s: 등록하기 접기/펼치기 -->
     
      <!-- S: registration_btn -->
      <div class="registration_btn"> 
     
      <!-- e: 등록하기 접기/펼치기 --> 
      <!-- s: 서브 검색 -->
      <div class="sub_search clearfix">
        <div class="l_con">
          <ul class="clearfix">
          
            <li> <span class="l_txt">대회명</span>
              <input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
              <input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_ReqGameTitleIdx%>">
            </li>
          </ul>
        </div>
        <div class="r_search_btn">
          <%
         

            strjson = JSON.stringify(oJSONoutput)  
        %>
          <a class="btn btn-search" href='javascript:OnSearchClick();'>검색</a> </div>
      </div>
      <!-- e: 서브 검색 -->
      <a class="btn btn-search" href='javascript:InitTournamnetFinal();'>본선 생성</a> </div>
      <div id="schDivResult">
    
      
      <%
        if cdbl(iTotalCount) > 0 then
        %>
      <!-- S: page_index -->
      <div class="page_index"> 
        <!--#include file="../../dev/dist/CommonPaging_Admin.asp"--> 
      </div>
      <!-- E: page_index -->
      <%
          End If
        %>
      </div>
    </div>
  </div>
  <!-- E: content --> 
</div>
<!-- E: main --> 

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>
