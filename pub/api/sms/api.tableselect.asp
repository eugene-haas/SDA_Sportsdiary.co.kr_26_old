
<!-- #include virtual = "/pub/api/sms/reqAjaxSms.asp" -->
<%

'#############################################
' 랭크 포인트 조회
'#############################################
	'request
    GameYears=""
    gametitle=""
    teamGb=""
    Level=""
    userName=""
    PaymentType=""
    
    If hasown(oJSONoutput, "GameYears") = "ok" then	
	    GameYears = oJSONoutput.GameYears
    end if 
    If hasown(oJSONoutput, "gametitle") = "ok" then	
	    gametitle = oJSONoutput.gametitle
    end if 
    If hasown(oJSONoutput, "teamGb") = "ok" then	
	    teamGb = oJSONoutput.teamGb
    end if 
    If hasown(oJSONoutput, "Level") = "ok" then	
	    Level = oJSONoutput.Level
    end if 
    If hasown(oJSONoutput, "userName") = "ok" then	
	    userName = oJSONoutput.userName
    end if  
    If hasown(oJSONoutput, "PaymentType") = "ok" then	
	    PaymentType = oJSONoutput.PaymentType
	    req_PaymentType = oJSONoutput.PaymentType
    end if 
 
	Set db = new clsDBHelper
 

	'사이트코드 (관리자생성, 메뉴관리)
	'스타몰 관리자 SITECODE = SDA01
	Select Case LCase(URL_HOST)
	Case "rtadmin.sportsdiary.co.kr","rt.sportsdiary.co.kr" : sitecode = "RTN01"
	Case "swadmin.sportsdiary.co.kr","sw.sportsdiary.co.kr" : sitecode = "SWN01"
	Case "ridingadmin.sportsdiary.co.kr","riding.sportsdiary.co.kr" : sitecode = "RDN01"
	Case "bikeadmin.sportsdiary.co.kr","bike.sportsdiary.co.kr" : sitecode = "BIKE01"
	Case "adm.sportsdiary.co.kr": sitecode = "ADN99"
	Case Else
	'"/cfg/cfg.pub.asp 에서 사이트 코드를 먼저 설정해주세요"
	'Response.end
	End Select


	'################################멀티사용
	Select Case sitecode
	Case "SWN01"  '수영
		ConStr = Replace(ConStr , "SD_Tennis", "SD_Swim")
		paysql = " (select top 1 VACCT_NO from SD_RookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar) ) as payok "	
	Case "RTN01"  '루키테니스
		ConStr = Replace(ConStr , "SD_Tennis", "SD_RookieTennis")
		paysql = " (select top 1 VACCT_NO from SD_RookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar) ) as payok "	
	Case Else

		paysql = " (select top 1 VACCT_NO from TB_RVAS_LIST where CUST_CD = a.RequestIDX) as payok "
	End Select 
	'################################멀티사용

    '생성 여부 확인하고 찍어준다.

    Sql = "select b.GameTitleIDX,b.GameTitleName,c.TeamGbNm,d.LevelNm"
    Sql = Sql & ",a.P1_PlayerIDX,a.P1_UserName,a.P1_UserPhone,a.P1_TeamNm,a.P1_TeamNm2 "
    Sql = Sql & ",a.P2_PlayerIDX,a.P2_UserName,a.P2_UserPhone,a.P2_TeamNm,a.P2_TeamNm2 "
    Sql = Sql & ", ROW_NUMBER() over(order by b.GameTitleIDX,c.TeamGb,d.Level,RequestIDX Asc ) num ,RequestIDX,PaymentType, "  & paysql 

    Sql = Sql&" from  tblGameRequest  a  " 
    Sql = Sql&" inner join sd_TennisTitle b on a.GameTitleIDX = b.GameTitleIDX and a.SportsGb = b.SportsGb and b.DelYN='N' and a.SportsGb='tennis' and a.DelYN='N' " 
    Sql = Sql&" inner join tblRGameLevel c  on a.GameTitleIDX = c.GameTitleIDX and b.SportsGb = c.SportsGb and c.Level = a.Level  and c.DelYN='N' " 
    Sql = Sql&" inner join tblLevelInfo d on c.SportsGb = d.SportsGb and c.TeamGb = d.TeamGb and c.Level = d.Level " 
    Sql = Sql&" left join tblPlayer p1 on a.P1_PlayerIDX = p1.PlayerIDX and a.P1_UserName =p1.UserName and p1.DelYN='N' " 
    Sql = Sql&" left join tblPlayer p2 on a.P2_PlayerIDX = p2.PlayerIDX and a.P2_UserName =p2.UserName and p2.DelYN='N' " 

    Sql = Sql& " where  a.GameTitleIDX not in( '24','39','') and b.ViewYn='Y' "

    if Years <> "" then 
        Sql = Sql & " and b.GameYear ='"&GameYears&"'" 
    end if
    if gametitle <> "" then 
        Sql = Sql & " and a.GameTitleIDX ='"&gametitle&"'" 
    end if

    if teamGb <> "" then 
        Sql = Sql & " and a.Level like '%'+left('"&teamGb&"',4)+'%'" 
    end if
    
    if Level <> "" then 
        Sql = Sql & " and a.Level ='"&Level&"'" 
    end if

    if PaymentType <> "" then 
		'Sql = Sql & " and a.PaymentType ='"&PaymentType&"'" 
    end if

    if userName <> "" then 
        Sql = Sql & " and (a.P1_UserName  like '%"&userName&"%' or a.P2_UserName like '%"&userName&"%') " 
    end if
    
	'Sql = Sql & "  ORDER By b.GameTitleIDX,b.GameTitleName,c.TeamGbNm,d.LevelNm ,a.RequestIDX Asc   " 
   	Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)
	
	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if  


    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "0" ) 
     
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"


'Response.write sql

    i=1
    If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
            GameTitleIDX	        =arrRS(0, ar) 
			GameTitleName			=arrRS(1, ar) 
			TeamGbNm			    =arrRS(2, ar)
			LevelNm			        =arrRS(3, ar)
             
			P1_PlayerIDX		    =arrRS(4, ar) 
			P1_UserName		        =arrRS(5, ar) 
			P1_UserPhone		    =arrRS(6, ar) 
			P1_TeamNm		        =arrRS(7, ar) 
			P1_TeamNm2		        =arrRS(8, ar) 

			P2_PlayerIDX		    =arrRS(9, ar) 
			P2_UserName			    =arrRS(10, ar) 
			P2_UserPhone			=arrRS(11, ar) 
			P2_TeamNm			    =arrRS(12, ar) 
			P2_TeamNm2			    =arrRS(13, ar) 
            num                     =arrRS(14, ar) 
            RequestIDX              =arrRS(15, ar) 
            PaymentType             =arrRS(16, ar) 

			payok = arrRS(17,ar)
				If payok = "" Or isNull(payok) = True  Then 'Or payok = "1"
					'미입금
					PaymentType = "N"
				Else
					'입금완료
					PaymentType = "<font color='red'>Y</font>"
				End If
			%>
			
			<%
			select case req_PaymentType
			Case ""
			%>
            <tr class="gametitle" id="Point_tr_<%=GameTitleIDX %>_<%=RequestIDX %>" style="cursor:pointer" >
                <td ><input  type="checkbox" id="chek<%=RequestIDX %>" style=" width:60%; height:60%;"/></td> 
		        <td ><%=num %></td> 
		        <td style="text-align:left;padding-left:10px;"><%=GameTitleName %></td>
		        <td style="color:#A43A1D;"><%=TeamGbNm %></td>
		        <td style="color:#A43A1D;"><%=LevelNm %></td>
                
		        <td ><span><%=P1_UserName %> [<%=P1_TeamNm %> / <%=P1_TeamNm2 %>]</span></td> 
		        <td ><span id="P1_UserPhone<%=RequestIDX %>"><%=P1_UserPhone %></span></td> 

                
		        <td ><span><%=P2_UserName %> [<%=P2_TeamNm %> / <%=P2_TeamNm2 %>]</span></td> 
		        <td ><span id="P2_UserPhone<%=RequestIDX %>"><%=P2_UserPhone %></span></td> 
                
		        <td ><span id="Span1"><%=PaymentType %></span></td> 
	        </tr>
			<%
            i=i+1
			Case "Y"
				If payok <> "" and isNull(payok) <> True  Then
				%>
				<tr class="gametitle" id="Point_tr_<%=GameTitleIDX %>_<%=RequestIDX %>" style="cursor:pointer" >
					<td ><input  type="checkbox" id="chek<%=RequestIDX %>" style=" width:60%; height:60%;"/></td> 
					<td ><%=num %></td> 
					<td style="text-align:left;padding-left:10px;"><%=GameTitleName %></td>
					<td style="color:#A43A1D;"><%=TeamGbNm %></td>
					<td style="color:#A43A1D;"><%=LevelNm %></td>
					
					<td ><span><%=P1_UserName %> [<%=P1_TeamNm %> / <%=P1_TeamNm2 %>]</span></td> 
					<td ><span id="P1_UserPhone<%=RequestIDX %>"><%=P1_UserPhone %></span></td> 

					
					<td ><span><%=P2_UserName %> [<%=P2_TeamNm %> / <%=P2_TeamNm2 %>]</span></td> 
					<td ><span id="P2_UserPhone<%=RequestIDX %>"><%=P2_UserPhone %></span></td> 
					
					<td ><span id="Span1"><%=PaymentType %></span></td> 
				</tr>				
				<%
				i = i + 1
				End if
			Case "N"
				If payok = "" Or isNull(payok) = True  Then
				%>
				<tr class="gametitle" id="Point_tr_<%=GameTitleIDX %>_<%=RequestIDX %>" style="cursor:pointer" >
					<td ><input  type="checkbox" id="chek<%=RequestIDX %>" style=" width:60%; height:60%;"/></td> 
					<td ><%=num %></td> 
					<td style="text-align:left;padding-left:10px;"><%=GameTitleName %></td>
					<td style="color:#A43A1D;"><%=TeamGbNm %></td>
					<td style="color:#A43A1D;"><%=LevelNm %></td>
					
					<td ><span><%=P1_UserName %> [<%=P1_TeamNm %> / <%=P1_TeamNm2 %>]</span></td> 
					<td ><span id="P1_UserPhone<%=RequestIDX %>"><%=P1_UserPhone %></span></td> 

					
					<td ><span><%=P2_UserName %> [<%=P2_TeamNm %> / <%=P2_TeamNm2 %>]</span></td> 
					<td ><span id="P2_UserPhone<%=RequestIDX %>"><%=P2_UserPhone %></span></td> 
					
					<td ><span id="Span1"><%=PaymentType %></span></td> 
				</tr>				
				<%
				i = i + 1
				End if
			End Select 
			%>
            <%
		Next
	end if
     
  
db.Dispose
Set db = Nothing
%>