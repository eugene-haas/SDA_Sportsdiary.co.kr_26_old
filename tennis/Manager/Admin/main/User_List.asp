<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim SDate         : SDate       = fInject(Request("SDate"))
  dim EDate         : EDate       = fInject(Request("EDate")) 
  dim TypeRole      : TypeRole      = fInject(Request("TypeRole"))
  dim fnd_AuthType    : fnd_AuthType  = fInject(Request("fnd_AuthType"))  
  dim fnd_KeyWord   : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
%>
<script language="javascript">
  //검색
  function chk_Submit(valType, valIDX, chkPage){
    var fnd_Role = "";
    var strAjaxUrl = "../Ajax/admin_User_List.asp";    
    
    
    var SDate = $("#SDate").val();
    var EDate = $("#EDate").val();
    var fnd_KeyWord = $("#fnd_KeyWord").val();
    var fnd_KeyWordType = $("#fnd_KeyWordType").val();
    var fnd_AuthType = $("#fnd_AuthType").val();
  
    $('input:checkbox[name="TypeRole"]:checked').each(function() { 
      fnd_Role += "|" + $(this).val();
    });
    
    if(chkPage!="") $("#currPage").val(chkPage);
    
    var currPage = $("#currPage").val();
    
    if(valType=="VIEW"){
      $("#CIDX").val(valIDX);   
      
      $('form[name=s_frm]').attr('action',"./User_Mod.asp");
      $('form[name=s_frm]').submit(); 
    }
      else{ 
    
      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",     
        data: { 
          currPage        : currPage     
          ,SDate        : SDate
          ,EDate        : EDate
          ,fnd_KeyWordType    : fnd_KeyWordType  
          ,fnd_KeyWord      : fnd_KeyWord  
          ,fnd_Role     : fnd_Role
          ,fnd_AuthType   : fnd_AuthType
        },    
        success: function(retDATA) {
          $("#board-contents").html(retDATA);       
        }, 
        error: function(xhr, status, error){           
          if(error!=""){
            alert ("오류발생! - 시스템관리자에게 문의하십시오!");
            return;
          }
        }
      });
    } 
  }

  $(document).ready(function(){
    chk_Submit('', 1);    
  });
</script>
<!-- S : content -->
<section>
  <div id="content">
    <div class="navigation_box"> 회원관리 &gt; 회원명단</div>
    <!-- S : top-navi -->
    <!-- E : top-navi -->
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    <input type="text" id="CIDX" name="CIDX" class="user_list_input" />
      <div class="search_top community">
        <div class="search_box">
          <table class="sch-table">
            <tbody>
              <tr>
                <th scope="row">가입일</th>
                <td><input type="date" name="SDate" id="SDate" maxlength="10" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%> />
                  -
                  <input type="date" name="EDate" id="EDate" maxlength="10" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%> /></td>
                
                <th scope="row">인증방법</th>
                <td><Select name="fnd_AuthType" id="fnd_AuthType">
                  <option value="">=====전체=====</option>
                    <option value="MOBILE" <%IF fnd_AuthType = "MOBILE" Then response.Write "selected" End IF%>>휴대폰 안심 본인인증</option>
                    <option value="IPIN" <%IF fnd_AuthType = "IPIN" Then response.Write "selected" End IF%>>아이핀(I-PIN) 인증</option>
                    </Select>
                </td>
                <th scope="row">회원구분</th>
                <td>
                  <input type="checkbox" name="TypeRole" id="TypeRoleP" value="P" />
                    <label for="TypeRoleP" class="check_txet">엘리트선수</label>
                    <input type="checkbox" name="TypeRole" id="TypeRoleL" value="L" />
                    <label for="TypeRoleL" class="check_txet">지도자(감독)</label>
                    <input type="checkbox" name="TypeRole" id="TypeRoleD" value="D" />
                    <label for="TypeRoleD"  class="check_txet">관장</label>
                    <input type="checkbox" name="TypeRole" id="TypeRoleJ" value="J" />
                    <label for="TypeRoleJ"  class="check_txet">심판</label>
                    <input type="checkbox" name="TypeRole" id="TypeRoleU" value="U" />
                    <label for="TypeRoleU" class="check_txet">일반</label>
                </td>                
              </tr>
              <tr>
                <th>키워드</th>
                <td colspan="3"><input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
                <div id="div_InfoKeyWord">키워드 검색 [소속팀명, 회원명, 생년월일, 체육인번호, 아이디, 전화번호, 이메일]</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="btn-right-list"> <a href="javascript:chk_Submit();" class="btn" accesskey="s">검색(S)</a> </div>
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
<!--#include file="footer.asp"-->
