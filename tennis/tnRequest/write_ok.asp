<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%
if  ChekMode = 0 then 
    CMD= 300    
else
    CMD= 300
end if 
ChekMode  = fInject(Request("ChekMode"))
ridx  = fInject(Request("ridx"))
Years     = fInject(Request("Years"))
Months     = fInject(Request("Months")) 
GameTitleIDX     = fInject(Request("GameTitleIDX"))
GameTitleName  = fInject(Request("GameTitleName"))
TeamGb  = fInject(Request("TeamGb"))
TeamGbNm  = fInject(Request("TeamGbNm"))
levelno  = fInject(Request("levelno"))
levelNm  = fInject(Request("levelNm"))
EntryCntGame  = fInject(Request("EntryCntGame"))
 
If GameTitleIDX = "" Then
    Response.redirect "./list.asp"
    Response.end
End if
If ridx = "" Then
    Response.redirect "./list.asp"
    Response.end
End if

'Response.Write "<br> ridx :" & ridx
'Response.Write "<br> ChekMode :" & ChekMode
'Response.Write "<br> GameTitleIDX :" & GameTitleIDX
'Response.Write "<br> GameTitleName :" & GameTitleName
'Response.Write "<br> TeamGb :" & TeamGb
'Response.Write "<br> TeamGbNm :" & TeamGbNm
'Response.Write "<br> levelno :" & levelno
'Response.Write "<br> levelNm :" & levelNm

''대회 정보 검색
 
if ridx <> "" and ChekMode=1 then
    SQL ="select EntryCntGame,cfg,SUBSTRING(cfg,2,1)Ch_i,SUBSTRING(cfg,3,1)Ch_u,SUBSTRING(cfg,4,1)Ch_d from tblRGameLevel where GameTitleIDX = '"&GameTitleIDX&"' and level='"&levelno&"' and  delYN='N' "
    Set Rs = Dbcon.Execute(SQL)
    If Not rs.EOF Then 
    Do Until rs.eof
        cfg = Rs("cfg")
        Ch_i = Rs("Ch_i")
        Ch_u = Rs("Ch_u")
        Ch_d = Rs("Ch_d")
    rs.movenext
    Loop
    End if
End if

%>
<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script> 
<script src="/pub/js/tennis_Request.js?ver=11" type="text/javascript"></script>
<script>
var Now = new Date();
var NowTime = Now.getFullYear();
var m = Now.getMonth() + 1;
if (m < 10) {
    NowTime += '-0' + m;
} else {
    NowTime += '-' + m;
}
NowTime += '-' + Now.getDate();

function chk_frm(val) {
    var sf = document.frm_in;

    if (val == 0) {
        sf.action = "./info_list.asp";
    }
    else if (val == 2) {
        //수정
        chek_form_data(val);
        $("#FormDelete").css("display", "none");
        $("#FormUpdate").css("display", "");
    }
    else if (val == 1) {
        //삭제
        $("#aTcommit").click();
        $("#FormDelete").css("display", "");
        $("#FormUpdate").css("display", "none");
    } else if (val == 10) {
        //대회목록
        sf.action = "./list.asp" + ver;
    } else if (val == 11) {
        //참가신청목록
        sf.action = "./list.asp" + ver;
    } else if (val == 12) {
        //참가신청목록
        sf.action = "./info_list.asp" + ver;
    } else if (val == 999) {
        //참가신청내역
        sf.action = "./info_list.asp" + ver;
    } else if (val == 888) {
        //참가신청 완료 후 확인창 이동
        sf.action = "./write_ok.asp" + ver;
    }
    sf.submit();
  
}

$(document).ready(function () {
<%if (Request.ServerVariables("REMOTE_ADDR"))   = "118.33.86.240" then%>
<%else%>
//	var obja = {};
//    obja.CMD = mx_player.CMD_Request_Edit_s1;
//    obja.IDX = $("#GameTitleIDX").val();
//    obja.levelno = $("#levelno").val();
//    obja.ridx = $("#ridx").val();
//    obja.ChekMode = $("#ChekMode").val();
//    mx_player.SendPacket("ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
<%end if%>
});

</script>
<title>KATA Tennis 대회 참가신청</title>
<body class="lack_bg" id="AppBody">
<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->
<iframe name="hiddenFrame" style="display:none"></iframe>
<div id="SmsFormSubmit" >

</div>
<form method="post" name="frm_in" id="frm_in" >  
    <input  type="hidden" name="Years" id="Years" value="<%=Years %>"/> 
    <input  type="hidden" name="Months" id="Months" value="<%=Months %>"/> 
    <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/> 
    <input  type="hidden" name="CMD" id="CMD" value="<%=CMD %>"/> 
    <input  type="hidden" name="ridx" id="ridx" value="<%=ridx %>"/>
    <input  type="hidden" name="TitleIDX" id="TitleIDX" value="<%=GameTitleIDX %>"/> 
    <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/> 
    <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/> 
    <input  type="hidden"  name="TeamGb" id="TeamGb" value="<%=TeamGb %>"/> 
    <input  type="hidden"  name="TeamGbNm" id="TeamGbNm" value="<%=TeamGbNm %>"/> 
    <input  type="hidden"  name="levelNm"  id="levelNm"value="<%=levelNm %>"/>    
    <input  type="hidden"  name="Fnd_Kw"  id="Fnd_Kw"value=""/>  

<div class="l_apply">
	<!-- s: 타이틀 박스 -->
	



<%
SQL = " select b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "   
SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg, max(b.fee) as fee, max(b.fund) as fund "  
SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d , d.lmsSendChk ,count(s.gameMemberIDX)MemberCnt"  
SQL = SQL &"  from tblRGameLevel b  "  
SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
SQL = SQL &"  inner join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' and d.RequestIDX= "&ridx
SQL = SQL &"  left JOIN sd_TennisMember s on d.GameTitleIDX = s.GameTitleIDX and d.Level = s.gamekey3 and s.DelYN='N' and d.P1_PlayerIDX= s.PlayerIDX and isnull(Round,0)=0"
SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&GameTitleIDX&"' and c.LevelNm not like '%최종%'  "
SQL = SQL &"  and  c.Level='"&levelno&"'"
SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg,   d.lmsSendChk "
Set rs = Dbcon.Execute(SQL)

If Not rs.EOF Then 
	MemberCnt = rs("MemberCnt") 
	fee = rs("fee")
	fund = rs("fund")
	acctotal = CDbl(fee) + CDbl(fund)
End if



If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만
		SQL = "Select VACCT_NO from TB_RVAS_MAST where CUST_CD = '" & ridx & "' "
		Set rs = Dbcon.Execute(SQL)

		If Not rs.eof Then
			acct = rs(0)
		End if
		%>
		<%if Cdbl(MemberCnt)<=0 then %>
			<div class="comp-guide waiting-guide">
				<div class="ic-deco">
					<i class="fa fa-check-circle"></i>
				</div>
				<h2>
					<span>"<%=GameTitleName %>"</span>
					<span class="green">참가 신청이 완료 되었습니다.</span>
				</h2>
				<p class="exp"><span class="redy">대기팀</span> 으로 등록 되었습니다.</p>
			</div>
		<%else%>
			<div class="comp-guide ">
				<h2>
					<span class="ic-deco">
						<i class="fa fa-check-circle"></i>
					</span>
					<span>"<%=GameTitleName %>"</span>
					<span class="green">참가 신청이 완료 되었습니다.</span>
				</h2>

				<dl>
					<dt>가상계좌 번호</dt>
					<dd><%=acct%> KEB하나은행</dd>
				</dl>
				<dl>
					<dt>참가비 금액</dt>
					<dd><%=acctotal%>원</dd>
				</dl>
			</div>
		<%End if%>
<%else%>
   <!-- S: 참가신청 완료 -->
    <div class="apply_Wrap">
        <img src="/images/tennis/icon/icon_ok.png" alt="ok"  style="width:50px;">
        <h1 class="apply_tit">"<%=GameTitleName %>"</h1>
        <p>참가 신청이 완료 되었습니다.</p>
            <%
            SQL = " select  convert(date,GameS)GameS,convert(date,GameE)GameE from sd_TennisTitle  where DelYN='N' and GameTitleIDX= '"&GameTitleIDX&"' "
            Set Rs = Dbcon.Execute(SQL)
            If Not(Rs.Eof Or Rs.Bof) Then 
            Do Until Rs.Eof   
            %>
		<p><%=Replace(Rs("GameS"),"-","/") %><span>(<%=weekDayName(weekDay(Rs("GameS"))) %>) ~ <%=Replace(Rs("GameE"),"-","/") %><span>(<%=weekDayName(weekDay(Rs("GameE"))) %>)</p>        
            <%
            Rs.MoveNext
            Loop 
            end if 
            %>
	</div>
    <!-- E: 참가신청 완료 -->
<%End if%>


	<!-- s: 참가자 정보 & 파트너 정보 -->
    <div class="deposit_info">
	    <span class="big_title">대회 신청 내역 확인</span>
    </div>
	<div class="participant_info">
        <dl>
            <dd>
            	<div class="info_list"> 
                <ul>
			            <li>
				            <span class="l_name">출전부</span>
				            <span class="r_con">
                                    <%
                                    SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "  
                                    SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg"  
                                    SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d"  
                                    SQL = SQL &"  from tblRGameLevel b  "  
                                    SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
                                    SQL = SQL &"  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "
                                    SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&GameTitleIDX&"' and c.LevelNm not like '%최종%'  "
                                    if levelno <>"" and ridx <>"" then
                                    SQL = SQL &"  and  c.Level='"&levelno&"'"
                                    end if 
                                    SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg  "
                                     %> 
					            <select class="ipt select_1" id="levelno" name="levelno" disabled>
                                    <%
                                        i = 0
                                        Set Rs = Dbcon.Execute(SQL)
                                        If Not(Rs.Eof Or Rs.Bof) Then 
                                        Do Until Rs.Eof  
                                            if ChekMode = 0 and ridx ="" then 
                                                if Rs("Ch_i") ="Y" then
                                                    i=i+1
                                                %>
						                        <option value="<%=Rs("Level") %>" <% if levelno =Rs("Level") then %> selected<% end if  %> ><%=Rs("TeamGbNm") %>(<%=Rs("LevelNm") %>) <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                                <%
                                                end if 
                                            else
                                            %>
						                    <option value="<%=Rs("Level") %>" <% if levelno =Rs("Level") then %> selected<% end if  %> ><%=Rs("TeamGbNm") %>(<%=Rs("LevelNm") %>) <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                            <%
                                            end if 
                                        Rs.MoveNext
                                        Loop  
                                        end if 

                                     %> 
					            </select>
                                <%
                                    if ChekMode = 0 and i = 0 then 
                                    %>
                                        <script type="text/javascript">
                                            alert("참가신청 기간이 아닙니다.");
                                            location.href = "./list.asp" + ver;
                                        </script>  
                                    <%
                                    end if 
                                 %>
				            </span>
			            </li>
                </ul>
                </div>
            </dd>
        </dl>
        <dl>
			<dd>
				<p class="c_title">신청자 정보</p>   <!-- s: 대회참가비 입금정보 -->
	            <div class="deposit_info">
		            <ul>
                        <li class="reqer">
	                        <span class="l_name">신청자 이름</span>
	                        <span class="r_con">
		                        <input type="text" class="ipt input_1 ui-autocomplete-input" id="attname" name="attname" placeholder=":: 이름을 입력하세요 ::"  autocomplete="off" value=""    onfocus="this.select()" disabled>
	                        </span>
                        </li>
                        <li>
	                        <span class="l_name">휴대폰 번호</span>
	                        <span class="r_con">
                                <input  type="hidden"  name="attphone" id="attphone" value=""/>  
		                        <select class="ipt col_1" id="attphone1" name="attphone1" disabled>
			                        <option value="010">010</option>
			                        <option value="011">011</option>
			                        <option value="016">016</option>
			                        <option value="017">017</option>
			                        <option value="018">018</option>
			                        <option value="019">019</option>
		                        </select>
		                        <span class="divn">-</span>
		                        <input type="password" class="ipt col_1 phone_line" id="attphone2" name="attphone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value=""onfocus="this.select()" autocomplete="off" disabled>
		                        <span class="divn">-</span>
		                        <input type="number" class="ipt col_1 phone_line" id="attphone3" name="attphone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value=""onfocus="this.select()" autocomplete="off" disabled>
	                        </span>
                        </li> 
			            <li>
				            <span class="l_name">입금자명</span>
				            <span class="r_con">
					            <input type="text" class="ipt input_1" id="inbankname" name="inbankname" value="" onfocus="this.select()"  placeholder=":: 이름을 입력하세요 ::"  autocomplete="off">
				            </span>
			            </li>
                        <li>
	                        <!-- s: 기타 건의내용 -->
	                        <div class="etx_con">
		                        <span class="c_title">기타 건의내용</span>
		                        <textarea id="attask" name="attask"></textarea>
	                        </div>
	                        <!-- e: 기타 건의내용 -->
                        </li>
		            </ul>
                </div>
			</dd>
        
        </dl>
		<dl id="ContentsList"> </dl>
	</div>
	<!-- e: 참가자 정보 & 파트너 정보 -->
	<!-- s: 버튼 리스트 -->
	<div class="btn_list" style="text-align:center;">   
		<a href="javascript:chk_frm('0');"  class="gray_btn"  style="float:none;display:inline-block;">신청내역 보기</a>
		<a href="javascript:chk_frm('10');"  class="green_btn"  style="float:none;display:inline-block;">신청하기</a>
	</div>
	<!-- s: 버튼리스트 --> 
</div>
</form>
<!-- E: main -->
<!--#include file = "./include/mfoot.asp" -->