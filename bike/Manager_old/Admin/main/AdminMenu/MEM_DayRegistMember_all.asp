<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<% 
	RoleType = "01MEMBER"	
%>
<!--#include file="../../include/CheckRole.asp"-->
<%

DT_F    = fInject(Request("DT_F"))
DT_T    = fInject(Request("DT_T"))
SportsGB  = fInject(Request("SportsGB")) 
   

'Response.Write  "DT_F:"&DT_F &"</br>"
'Response.Write  "DT_T:"&DT_T&"</br>"
'Response.Write  "SportsGB:"&SportsGB&"</br>"
'response.end
 
if DT_F ="" then 
    DT_F=Dateadd("m",-1,Date())
end if 

if DT_T ="" then 
    DT_T=Date()
end if 

 %>
<section>
  <div id="content">
    <div class="loaction"> <strong>통계관리</strong> 회원가입 &gt; 일별 통합회원 가입자</div>
    <%
	SportsType=""
	SEQ =0
	MON_SEQ =0
	YY=""
	MM=""
	num=3
	hidden ="hidden"

	TableSql = "			SELECT 0 num"
	TableSql = TableSql & "		,'통합' SportsType"
	TableSql = TableSql & "		,CONVERT(CHAR,CONVERT(DATE,CONVERT(CHAR, WriteDate, 111)),111) SrtDATE"
	TableSql = TableSql & "		,Sex"		
	TableSql = TableSql & "	FROM [SD_Member].[dbo].[tblmember]"
	TableSql = TableSql & "	WHERE delyn='N'"

	TableSql1 = "				SELECT 1 num"
	TableSql1 = TableSql1 & "		,'통합' SportsType"
	TableSql1 = TableSql1 & "		,left(CONVERT(CHAR,CONVERT(DATE,CONVERT(CHAR, WriteDate, 111)),111),7) +' 소계' SrtDATE"
	TableSql1 = TableSql1 & "		,Sex"	
	TableSql1 = TableSql1 & "	FROM [SD_Member].[dbo].[tblmember]" 		
	TableSql1 = TableSql1 & "	WHERE delyn='N' "

	TableSql2 = "				SELECT 2 num"	
	TableSql2 = TableSql2 & "		,'통합' SportsType"
	TableSql2 = TableSql2 & "		,left(CONVERT(CHAR,CONVERT(DATE,CONVERT(CHAR, WriteDate, 111)),111),4) +'년 ' SrtDATE"
	TableSql2 = TableSql2 & "		,Sex"	
	TableSql2 = TableSql2 & "	FROM [SD_Member].[dbo].[tblmember]"
	TableSql2 = TableSql2 & "	WHERE Delyn='N'"

	TableSql3 = "				SELECT 3 num"
	TableSql3 = TableSql3 & "		,'통합' SportsType"
	TableSql3 = TableSql3 & "		,'총계' SrtDATE"
	TableSql3 = TableSql3 & "		,Sex"	
	TableSql3 = TableSql3 & "	FROM [SD_Member].[dbo].[tblmember]"
	TableSql3 = TableSql3 & "	WHERE delyn='N'"


	TableSql =TableSql & " union all " & TableSql1  & " union all " & TableSql2 & " union all " & TableSql3

	SQL = "			SELECT num"	
	SQL = SQL & "		,'통합' SportsType"
	SQL = SQL & "		,SrtDATE"
	SQL = SQL & "		,LEFT(SrtDATE,4) YY" 
	SQL = SQL & "		,RIGHT(LEFT(SrtDATE,7),2) MM"
	SQL = SQL & "		,COUNT(SrtDATE) cnt" 
	SQL = SQL & "		,SUM(CASE SEX WHEN 'Man' THEN 1 ELSE 0 END) SEX_M" 
	SQL = SQL & "		,SUM(CASE SEX WHEN 'WoMan' THEN 1 ELSE 0 END) SEX_W"
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
         
        </tr>
        <tr class="table-top">
          <td>남자</td>
          <td>여자</td>
        
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
<!-- E : container --> 
<!--#include file="../../Include/footer.asp"-->