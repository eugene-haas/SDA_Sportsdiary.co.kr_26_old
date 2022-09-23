<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<%
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim Searchkey     : Searchkey   = fInject(Request("Searchkey"))
  dim Searchkeyword   : Searchkeyword = fInject(Request("Searchkeyword"))
   
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
  function chk_Submit(valType, MemberIDX, chkPage){
    //alert('1');
    var strAjaxUrl = '../../Ajax/PlayerMemberinfo.asp';    
    //    var SDate = $('#SDate').val();
    //    var EDate = $('#EDate').val();
    var SearchKey = $('#SearchKey').val();
    var Searchkeyword= $('#Searchkeyword').val();
    var sido = $('#sido').val();
    var sidogugun = $('#sidogugun').val();
    if(chkPage!='') $('#currPage').val(chkPage);

    var currPage = $('#currPage').val();

    if(valType=='VIEW'){
      $('#MemberIDX').val(MemberIDX);   

      $('form[name=s_frm]').attr('action','/Main/PlayerMenu/PlayerMemberWrite.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
         currPage   =""
        ,sido     =""
          ,sidogugun    =""
        ,SearchKey      =""  
        ,Searchkeyword  =""  
      }

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
           currPage      : currPage     
          ,sido          : sido
              ,sidogugun     : sidogugun
          ,SearchKey     : SearchKey  
          ,Searchkeyword : Searchkeyword  
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
    var strAjaxUrl = "/Ajax/enroll/ClubGubun.asp"
    //location.href = strAjaxUrl
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
    sido : escape(this_is.value)
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
  <div id="content" class="player_member">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>동호인리스트</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>회원관리</li>
            <li><a href="#">생활체육관리</a></li>
            <li><a href="./PlayerMember.asp">동호인리스트</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->
        </div>
        <!-- E: page_title -->

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="text" id="PTeamIDX" name="PTeamIDX" class="user_list_input" />
    <input type="text" id="MemberIDX" name="MemberIDX" class="user_list_input" />
    
      <div class="search_top player-member">
        <div class="search_box">
          <table>
            <tbody>
              <tr>
        <th>시/도</th>
        <td colspan="2"  style="width:250px;">
          <div class="sel_box">
            <select  id="sido" name="sido" onchange="javascript:sido_gubun_search(this);" style="width:200px;">
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
          </div>
        </td>
        <th >구/군&nbsp;</th>
        <td colspan="2"  style="width:250px;">
          <div class="sel_box" id="sidogugun_div">
            <select id="sidogugun" name="sidogugun" style="width:200px;">
              <option value="">소속 구/군를 선택해주세요</option>
            </select>
          </div>
        </td>
        <th >검색어&nbsp;</th>
                <th>
          <select id="SearchKey" name="SearchKey" style="width:150px;">
            <option value="">==선택==</option>
            <option value="TeamNm">클럽명</option>
            <option value="UserName">동호인명</option>
            <option value="AthleteCode">동호인코드</option>
            <option value="UserPhone">연락처</option>
          </select>
        </th>
                <td>
          <input type="text" name="Searchkeyword" id="Searchkeyword" value="<%=Searchkeyword%>" placeholder="키워드 검색 [제목, 내용]" style="width:200px;" autocomplete="off" />

        </td>
                
                <td>
          <a href="javascript:chk_Submit('FND','',1);" class="btn">검색</a> 
          <a href="javascript:chk_Submit('ALL','',1);" class="btn">전체목록</a> 
          <!--a href="./PlayerWrite.asp" class="btn">동호회등록</a-->
        </td>
              </tr>
            </tbody>
          </table>
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
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../../include/footer.asp"-->