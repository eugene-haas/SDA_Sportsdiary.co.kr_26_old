<%
	'request
	idx = oJSONoutput.IDX
	levelno  = oJSONoutput.LevelNo
	ridx  = oJSONoutput.ridx
	ChekMode  = oJSONoutput.ChekMode

	Set db = new clsDBHelper
	'대회에 참여가 결정된 맴버 아이디목록 추출
	SQL ="select userName,gameMemberIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gamekey3 = " & levelno & "  and  delYN='N'  order by gameMemberIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrM = rs.GetRows()
	End if
    
   SQL=""
   SQL = SQL&"  select RequestIDX,SportsGb,GameTitleIDX,Level,EnterType,UserPass,UserName,isnull(UserPhone,'')UserPhone,txtMemo,PaymentDt,PaymentNm "
   SQL = SQL&" ,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_Team2,P1_TeamNm2,isnull(P1_UserPhone,'')P1_UserPhone ,P2_PlayerIDX,P2_UserName,P2_Team,P2_TeamNm,P2_Team2,P2_TeamNm2,isnull(P2_UserPhone,'')P2_UserPhone " 
   SQL = SQL&"  from tblGameRequest as a " 
   SQL = SQL&"  where GameTitleIDX = "&idx&"  and level = '"&levelno&"' and RequestIDX='"&ridx&"'  and DelYN = 'N' " 
 
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.EOF Then 
	Do Until rs.eof
        UserName =rs("UserName") 
        UserPhone =rs("UserPhone") 
        txtMemo =rs("txtMemo") 
        PaymentDt =rs("PaymentDt") 
        PaymentNm =rs("PaymentNm") 
        UserPhone =rs("UserPhone") 
        UserPass =rs("UserPass") 
	rs.movenext
	Loop
End if

UserPhone = replace(UserPhone,"-","") 
UserPhone1 = left(UserPhone,3)
if len(UserPhone)>=11 then 
    UserPhone2 = mid(UserPhone,4,4)
    UserPhone3 = right(UserPhone,4)
else
    UserPhone2 = mid(UserPhone,4,3)
    UserPhone3 = right(UserPhone,4)
end if 


Call oJSONoutput.Set("UserName", UserName)
Call oJSONoutput.Set("UserPhone", UserPhone)
Call oJSONoutput.Set("UserPhone1", UserPhone1 )
Call oJSONoutput.Set("UserPhone2", UserPhone2 )
Call oJSONoutput.Set("UserPhone3", UserPhone3 )
Call oJSONoutput.Set("txtMemo",txtMemo )
Call oJSONoutput.Set("PaymentDt", PaymentDt)
Call oJSONoutput.Set("PaymentNm", PaymentNm)
Call oJSONoutput.Set("UserPass", UserPass)

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("sql_se", SQL )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


If Not rs.EOF Then 
	i = 0
	Do Until rs.eof
	    %>


		<!-- s: 참가자정보 -->
		<h4 class="m_applicationForm__tit">참가자 정보 </h4>
		<ul>
			<li class="m_applicationForm__item">
				<span class="m_applicationForm__label">이 름</span>
				<span class="m_applicationForm__inputWrap">
                    <input  type="hidden" name="p1idx" id="p1idx" value="<%=rs("P1_PlayerIDX") %>"/>
					<input type="text" class="m_applicationForm__input" id="p1name" name="p1name" autocomplete="off" placeholder=":: 이름을 입력하세요 ::"    value="<%=rs("P1_UserName") %>" disabled/>
		            <input  type="hidden"  name="p1phone"  id="p1phone"value="<%=rs("P1_UserPhone")%>"/>
					<ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user" ></ul>
				</span>
			</li>
			
			<%If rs("P1_Team") = "개인" then%>
			<li class="m_applicationForm__item">
				<span class="m_applicationForm__label">개별신청자</span>
				<span class="m_applicationForm__inputWrap">&nbsp;</span>
			</li>
			<%else%>
			<li class="m_applicationForm__item">
				<span class="m_applicationForm__label">단체신청자</span>
				<span class="m_applicationForm__inputWrap">
                    <input  type="hidden" name="p1team1" id="p1team1" value="<%=rs("P1_Team") %>"/>
					<input type="text" class="m_applicationForm__input" id="p1team1txt" name="p1team1txt"  placeholder=":: 대표소속명을 입력하세요 ::" autocomplete="off" value="<%=rs("P1_TeamNm") %>" disabled/>
                    <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-team" ></ul>
				</span>
			</li>
			<%End if%>
		</ul>
		<!-- e: 참가자정보 -->




	    <%
	i = i + 1
	rs.movenext
	Loop
End if
 

db.Dispose
Set db = Nothing
%>