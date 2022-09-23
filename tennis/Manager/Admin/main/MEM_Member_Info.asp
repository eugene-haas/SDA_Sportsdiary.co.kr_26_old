<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "02MEMBER"	
%>
<!--#include file="CheckRole.asp"-->
<link href="../css/lib/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script src="../../front/dist/js/bootstrap.min.js" type="text/javascript"></script>
<%

	dim SDate : SDate = replace(request("SDate"),"/","-")
	dim EDate : EDate = replace(request("EDate"),"/","-")

 %>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script> 
<script language="javascript">
	//검색
	function chk_Submit(chkPage){
		
		var strAjaxUrl = "../Ajax/MEM_Member_Info.asp";    		
		var fnd_SEX = $("#fnd_SEX").val();
		var fnd_KeyWord = $("#fnd_KeyWord").val();
		var SDate = $("#SDate").val();
		var EDate = $("#EDate").val();
		
		if(chkPage!="") $("#currPage").val(chkPage);
		
		var currPage = $("#currPage").val();
	
		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",     
			data: { 
				currPage    	: currPage     
				,fnd_SEX     	: fnd_SEX        
				,fnd_KeyWord  	: fnd_KeyWord  
				,SDate			: SDate
				,EDate			: EDate
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
	
	$(document).ready(function(){
		$("#SDate").val('<%=SDate%>');
		$("#EDate").val('<%=EDate%>');
		
		chk_Submit(1);					   
	});
</script>
<section>
  <div id="content">
    <div class="loaction"> <strong>회원관리</strong> <span id="Depth_GameTitle"> 통합회원</span></div>
	 <div class="sch">
        <table class="sch-table">
          <tbody>
            <tr>
              <th scope="row">가입일</th>
              <td><input type="date" name="SDate" id="SDate" maxlength="10" value="<%=SDate%>" />-<input type="date" name="EDate" id="EDate" maxlength="10" value="<%=EDate%>" /></td>
              <td><select name="fnd_SEX" id="fnd_SEX">
                  <option value="" selected>===성별===</option><em></em>>
                  <option value="Man">남자</option>
                  <option value="WoMan">여자</option>
                </select></td>
              <td><input type="text" name="fnd_KeyWord" id="fnd_KeyWord" placeholder="이름, 이메일, 생년월일"></td>
            </tr>
          </tbody>
        </table>
      </div>  
    <%
	SportsType=""
	SEQ =0
	MON_SEQ =0
	YY=""
	MM=""
	num=3
	hidden ="hidden"

	TableSql = "			SELECT 0 num"
	TableSql = TableSql & "		,SportsType"
	TableSql = TableSql & "		,CONVERT(CHAR,CONVERT(DATE,SrtDATE),111) SrtDATE"
	TableSql = TableSql & "		,B.Sex"
	TableSql = TableSql & "		,ISNULL(PlayerReln,'') PlayerReln"
	TableSql = TableSql & "		,EnterType "
	TableSql = TableSql & "	FROM [SD_Tennis].[dbo].[tblmember] A"
	TableSql = TableSql & "		inner join [SD_Member].[dbo].[tblmember] B on A.SD_UserID = B.UserID AND B.DelYN = 'N'"
	TableSql = TableSql & "	WHERE A.delyn='N' AND A.SportsType = 'tennis'"

	TableSql1 = "				SELECT 1 num"
	TableSql1 = TableSql1 & "		,SportsType"
	TableSql1 = TableSql1 & "		,left(CONVERT(CHAR,CONVERT(DATE,SrtDATE),111),7) +' 소계' SrtDATE"
	TableSql1 = TableSql1 & "		,B.Sex"
	TableSql1 = TableSql1 & "		,ISNULL(PlayerReln,'')PlayerReln"
	TableSql1 = TableSql1 & "		,EnterType "
	TableSql1 = TableSql1 & "	FROM SD_Tennis.dbo.tblmember A"
	TableSql1 = TableSql1 & "		inner join SD_Member.dbo.tblmember B on A.SD_UserID = B.UserID AND B.DelYN = 'N'"
	TableSql1 = TableSql1 & "	WHERE A.delyn='N' AND A.SportsType = 'tennis'"

	TableSql2 = "				SELECT 2 num"
	TableSql2 = TableSql2 & "		,SportsType"
	TableSql2 = TableSql2 & "		,left(CONVERT(CHAR,CONVERT(DATE,SrtDATE),111),4) +'년 ' SrtDATE"
	TableSql2 = TableSql2 & "		,B.Sex"
	TableSql2 = TableSql2 & "		,ISNULL(PlayerReln,'')PlayerReln"
	TableSql2 = TableSql2 & "		,EnterType "
	TableSql2 = TableSql2 & "	FROM SD_Tennis.dbo.tblmember A"
	TableSql2 = TableSql2 & "		inner join SD_Member.dbo.tblmember B on A.SD_UserID = B.UserID AND B.DelYN = 'N'"
	TableSql2 = TableSql2 & "	WHERE A.delyn='N' AND A.SportsType = 'tennis' "

	TableSql3 = "				SELECT 3 num"
	TableSql3 = TableSql3 & "		,SportsType"
	TableSql3 = TableSql3 & "		,'총계' SrtDATE"
	TableSql3 = TableSql3 & "		,B.Sex"
	TableSql3 = TableSql3 & "		,ISNULL(PlayerReln,'')PlayerReln"
	TableSql3 = TableSql3 & "		,EnterType "
	TableSql3 = TableSql3 & "	FROM SD_Tennis.dbo.tblmember A"
	TableSql3 = TableSql3 & "		inner join SD_Member.dbo.tblmember B on A.SD_UserID = B.UserID AND B.DelYN = 'N'"
	TableSql3 = TableSql3 & "	WHERE A.delyn='N' AND A.SportsType = 'tennis'"


	TableSql =TableSql & " union all " & TableSql1  & " union all " & TableSql2 & " union all " & TableSql3

	SQL = "			SELECT num"
	SQL = SQL & "		,SportsType"
	SQL = SQL & "		,SrtDATE"
	SQL = SQL & "		,LEFT(SrtDATE,4) YY" 
	SQL = SQL & "		,RIGHT(LEFT(SrtDATE,7),2) MM"
	SQL = SQL & "		,COUNT(SrtDATE) cnt "
	SQL = SQL & "		,SUM(CASE SEX WHEN 'Man' THEN 1 ELSE 0 END) SEX_M "
	SQL = SQL & "		,SUM(CASE SEX WHEN 'WoMan' THEN 1 ELSE 0 END) SEX_W "
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'K' THEN 1 ELSE 0 END) EnterType_K" 	
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN 1 ELSE 0 END) EnterType_E" 
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE WHEN ISNULL(PlayerReln,'') IN ('R','') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_R" 
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE WHEN PlayerReln IN ('K','S') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_K "
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE WHEN PlayerReln IN ('A','B','Z') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_A "
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE PlayerReln WHEN 'T' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_T" 
'	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE PlayerReln WHEN 'D' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_D" 	
	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN 1 ELSE 0 END) EnterType_A "
	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE WHEN ISNULL(PlayerReln,'') IN ('R','') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_R "
	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE PlayerReln WHEN 'K' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_K "
	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE WHEN PlayerReln IN ('A','B','Z') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_A "
	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE PlayerReln WHEN 'T' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_T "
	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE PlayerReln WHEN 'D' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_D "
    SQL = SQL & "	FROM (" & TableSql & " ) a "
	SQL = SQL & "	GROUP BY num, SportsType ,SrtDATE"
	SQL = SQL & "	ORDER BY SportsType, SrtDATE DESC"
	   
	'Response.Write SQL
	   
	SET Rs = Dbcon.Execute(SQL)
	If Not(Rs.Eof Or Rs.Bof) Then 
		Do Until Rs.Eof 
			YY              = Rs("YY")
			SrtDate         = Rs("SrtDate")
			cnt             = formatnumber(Rs("cnt"), 0)
			SEX_M           = formatnumber(Rs("SEX_M"), 0)
			SEX_W           = formatnumber(Rs("SEX_W"), 0)

'			EnterType_K     = Rs("EnterType_K")
'			EnterType_E     = formatnumber(Rs("EnterType_E"), 0)
'			PlayerRelnE_R   = formatnumber(Rs("PlayerRelnE_R"), 0)
'			PlayerRelnE_K   = formatnumber(Rs("PlayerRelnE_K"), 0)
'			PlayerRelnE_A   = formatnumber(Rs("PlayerRelnE_A"), 0)
'			PlayerRelnE_T   = formatnumber(Rs("PlayerRelnE_T"), 0)
'			PlayerRelnE_D   = formatnumber(Rs("PlayerRelnE_D"), 0)

			EnterType_A     = formatnumber(Rs("EnterType_A"), 0)
			PlayerRelnA_R   = formatnumber(Rs("PlayerRelnA_R"), 0)
			PlayerRelnA_K   = formatnumber(Rs("PlayerRelnA_K"), 0)
			PlayerRelnA_A   = formatnumber(Rs("PlayerRelnA_A"), 0)
			PlayerRelnA_T   = formatnumber(Rs("PlayerRelnA_T"), 0)
			PlayerRelnA_D   = formatnumber(Rs("PlayerRelnA_D"), 0)
                
                 
			Color_TdSubTotal = ""
			
	 		IF SportsType  <> Rs("SportsType")  THEN 
				SportsType      = Rs("SportsType")
            %>
    <div class="table-list-wrap">
      <table class="table-list">
        <tr class="table-top">
          <td rowspan=2>가입일자</td>
          <td rowspan=2>총가입자수</td>
          <td colspan=2>성별</td>
          <!--<td colspan=6>엘리트</td>-->
          <td colspan=5>생활체육</td>
        </tr>
        <tr class="table-top">
          <td>남자</td>
          <td>여자</td>
 			<!--
          <td>소계</td> 			
          <td>등록선수</td>
          <td>비등록선수</td>
          <td>지도자</td>
          <td>보호자</td>
          <td>일반</td>
 			-->	
          <td>소계</td>
          <td>선수</td>
          <td>지도자</td>
          <td>보호자</td>
          <td>일반</td>
        </tr>
        <%
			MON_SEQ=0
			SEQ =0
	 
		END IF                     
		if Rs("num") = 1 then 
		%>
        <tr class="subtotal">
        <%
        elseif Rs("num") = 2 then 
         %>
        <tr class="total">
		<%
		elseif Rs("num") =3 then 
		%>
		<tr class="subtotal">
		<%
		'Color_TdSubTotal ="style='background-color: #dcede0'" 
		else
		%>
		<tr>
		<%
		Color_TdSubTotal ="style='background-color: #fbefe0'" 
		end if 
		%>
          <td><%=SrtDate%></td>
          <td><%=cnt%></td>
          <td><%=SEX_M%></td>
          <td><%=SEX_W%></td>
		<!--
          <td <%=Color_TdSubTotal %>><%=EnterType_E%></td>
          <td><%=PlayerRelnE_R%></td>
          <td><%=PlayerRelnE_K%></td>
          <td><%=PlayerRelnE_T%></td>
          <td><%=PlayerRelnE_A%></td>
          <td><%=PlayerRelnE_D%></td>
		-->
          <td <%=Color_TdSubTotal%>><%=EnterType_A%></td>
          <td><%=PlayerRelnA_R%></td>
          <td><%=PlayerRelnA_T%></td>
          <td><%=PlayerRelnA_A%></td>
          <td><%=PlayerRelnA_D%></td>
        </tr>
        <%
			Color_TdSubTotal =""
			MON_SEQ=MON_SEQ+1
			SEQ = SEQ+1
			num = Rs("num")
		   
			Rs.MoveNext
		Loop 
    End If 
    %>
      </table>
    </div>
  </div>
</section>
<!-- sticky --> 
<script src="./js/js.js"></script> 
<!-- E : container --> 
<!--#include file="footer.asp"-->