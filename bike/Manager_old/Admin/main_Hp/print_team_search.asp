<!--#include file="../dev/dist/config.asp"-->
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/print_team_search.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 등록팀 주소 인쇄 검색
    '===================================================================================================================================
    Dim ListPage, ViewPage

    ' 로그인 체크
    Check_AdminLogin()

    ListPage    = "/Main_HP/print_team_search.asp"
    ViewPage    = "/Main_HP/print_team_info.asp"
%>
<!--#include file="../include/head.asp"-->
<script type="text/javascript">
<!--
    $(document).ready(function() {
		$('.l_con').children("input[type='checkbox']").eq(0).click(function() {
            if ($(this).attr("checked")) {
                $('.l_con').children("input[type='checkbox']").attr("checked", "checked");
            }else {
                $('.l_con').children("input[type='checkbox']").attr("checked", false);
            }
        });
	});

    function checkValue(oR, xAct) {
		if (!$('.l_con').children("input[type='checkbox']").is(':checked')) {
            alert('주소 인쇄 범위를 선택해 주세요.');
            return;
        }

		oR.action = xAct;
        oR.target = "pop";
		oR.submit();
	}
//-->
</script>
<!-- S : content association_News_list -->
<div id="content">
    <div class="page_title clearfix">
        <h2>등록팀 주소 인쇄</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>대회정보</li>
                <li>대회운영</li>
                <li><a href="<%=ListPage%>">등록팀 주소 인쇄</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->

        <div class="search_top community">
            <form name="s_frm" method="post">
            <table border="0" class="left-head view-table issued_box_table">
                <tbody>
                    <tr class="short-line">
                        <th>출력 범위</th>
                        <td>
                            <div class="issued_box">
                                <ul>
                                    <li>
                                        <span class="l_con">
                                            <input type="checkbox" name="PTeamGb" value="0" class="radio_in"> 전체 (초/중/고/대/실업 모두 포함)<br />
                                            <input type="checkbox" name="PTeamGb" value="11" class="radio_in"> 초등학교<br />
                                            <input type="checkbox" name="PTeamGb" value="12" class="radio_in"> 중학교<br />
                                            <input type="checkbox" name="PTeamGb" value="13" class="radio_in"> 고등학교<br />
                                            <input type="checkbox" name="PTeamGb" value="14" class="radio_in"> 대학교<br />
                                            <input type="checkbox" name="PTeamGb" value="15" class="radio_in">실업
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan=2 align=center>
							<div class="btn-list-center">
								<a href="javascript:;" onclick="checkValue(document.s_frm, '<%=ViewPage%>');" class="btn btn-confirm">인쇄</a> 
							</div>
						</td>
                    </tr>
                </tbody>
            </table>
            </form>

            <table border=1 cellpadding=5 cellspacing=1 width=510 class="left-head view-table issued_box_table">
                <tr>
                    <td><font color=red> ※ 프린트 하실때 여백은 <b>1page만&nbsp;&nbsp;&nbsp;- </b> 위:15mm, 아래/좌/우:0mm 으로 해주십시오.<br>
                    ※ 프린트 하실때 여백은 <b>2page부터 -</b> 위:8mm, 아래/좌/우:0mm 으로 해주십시오.</font></td>
                </tr>
            </table>
        </div>
    </div>
<!--#include file="../include/footer.asp"-->
<%DBClose()%>