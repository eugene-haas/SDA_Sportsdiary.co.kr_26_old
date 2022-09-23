<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<%
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim TeamNm    : TeamNm    = fInject(Request("TeamNm"))
   
   'CSQL = "   SELECT COUNT(*) AS CNT, Teamnm FROM tblPlayerTeamInfo "
    CSQL = "    select count(*)as cnt  from ( SELECT 0 AS CNT, Teamnm FROM tblPlayerTeamInfo "
    CSQL = CSQL & " WHERE DelYN = 'N' " 
    CSQL = CSQL & " AND DI = '"&sDupInfo&"' " 
    CSQL = CSQL & " group by Teamnm) a1  " 

    SET CRs_DI = DBcon.Execute(CSQL)
    
    if Not (CRs_DI.Eof Or CRs_DI.Bof) Then
    Do Until CRs_DI.Eof
    Club_cnt = CRs_DI("CNT")
    CRs_DI.MoveNext
    Loop
    End If
    CRs_DI.close
    
    CSQL = "    SELECT                "
    CSQL = CSQL & "    SidoIDX            "
    CSQL = CSQL & "   ,Sido             "
    CSQL = CSQL & "   ,SidoNm             "
    CSQL = CSQL & " FROM KoreaBadminton.DBO.tblSidoInfo "
    CSQL = CSQL & " WHERE DelYN = 'N' "
    CSQL = CSQL & " ORDER BY ORDERBYNUM ASC " 

    SET CRs = DBcon.Execute(CSQL) 
%>
<script language="javascript">
  //검색
  function chk_Submit(valType, valIDX, chkPage){
    //alert('1');
    var strAjaxUrl = '../../Ajax/PlayerTeaminfo.asp';    
    //    var SDate = $('#SDate').val();
    //    var EDate = $('#EDate').val();
    var TeamNm = $('#TeamNm').val();
    var sido = $('#sido').val();
    var sidogugun = $('#sidogugun').val();
    if(chkPage!='') $('#currPage').val(chkPage);

    var currPage = $('#currPage').val();

    if(valType=='VIEW'){
      $('#PTeamIDX').val(valIDX);   

      $('form[name=s_frm]').attr('action','/Main/PlayerMenu/PlayerWrite.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
         currPage  =""
        ,sido      =""
          ,sidogugun =""
        ,TeamNm    =""  
      }

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
           currPage      : currPage     
          ,sido          : sido
              ,sidogugun     : sidogugun
          ,TeamNm      : TeamNm  
        },    
        success: function(retDATA) {
          //console.log(retDATA);
          $('#board-contents').html(retDATA);       
        }, 
        error: function(xhr, status, error){           
          if(error!=''){
            alert ('오류발생! - 시스템관리자에게 문의하십시오!');
            return;
          }
        }
      });
    } 
  }

  $(document).ready(function(){
    chk_Submit('', '', 1);    
  });

  function sido_gubun_search(this_is)
  {
    //return;
    var strAjaxUrl = "/Ajax/enroll/ClubGubun.asp?sido="+escape(this_is.value);
    //location.href = strAjaxUrl
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
      },
      success: function (retDATA) {
        if (retDATA) {
        $('#sidogugun_div').html(retDATA);
        } else {
        $('#sidogugun_div').html("");
        }
      }, error: function (xhr, status, error) {
        if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
      }
    });
  }
</script> 
<!-- S : content -->

  <div id="content" class="player_team_info">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>클럽리스트</h2>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>회원관리</li>
          <li><a href="#">생활체육관리</a></li>
          <li><a href="./PlayerTeaminfo.asp">클럽리스트</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->
      </div>
      <!-- E: page_title -->

    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="hidden" id="PTeamIDX" name="PTeamIDX" class="user_list_input" />
      <div class="search_top community">
        <div class="search_box">
          <span class="tit">시/도</span>
          <select  id="sido" class="title_select" name="sido" onchange="javascript:sido_gubun_search(this);" class="title_select">
            <option value="">소속 시/도를 선택해주세요</option>
            <%
            if Not (CRs.Eof Or CRs.Bof) Then
            Do Until CRs.Eof
            %>
            <option value="<%=CRs("Sido")%>"><%=CRs("SidoNm")%></option>
            <%
            CRs.MoveNext
            Loop
            End If
             
            CRs.close
            %>
          </select>
          <span class="tit">구/군</span>
          <select id="sidogugun" name="sidogugun" class="title_select">
            <option value="">소속 구/군를 선택해주세요</option>
          </select>
          <span class="tit">클럽명</span>
          <input type="text" name="TeamNm" id="TeamNm" class="ipt-word" value="<%=TeamNm%>" placeholder="키워드 검색 [클럽명]" autocomplete="off" />
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
          <a href="javascript:chk_Submit('ALL','',1);" class="btn">전체목록</a> 
        </div>
        <!-- S : 리스트형 20개씩 노출 -->
        <div id="board-contents" class="table-list-wrap"> 
          <!-- S : table-list --> 
          <!-- E : table-list --> 
        </div>
        <!-- E : 리스트형 20개씩 노출 --> 
      </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../../include/footer.asp"-->