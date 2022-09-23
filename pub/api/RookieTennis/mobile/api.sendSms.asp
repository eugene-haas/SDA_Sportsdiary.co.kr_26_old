<%
tidx = oJSONoutput.tidx
tidxNm = oJSONoutput.tidxNm

TeamGb = oJSONoutput.TeamGb
TeamGbNm = oJSONoutput.TeamGbNm

levelno =  oJSONoutput.levelno
levelNm =  oJSONoutput.levelNm

ridx =  oJSONoutput.ridx

'신청자
ph1 =  oJSONoutput.ph1
ph1nm =  oJSONoutput.ph1nm
ph1bnm =  oJSONoutput.ph1bnm

'참가자
ph2 =  oJSONoutput.ph2
ph2idx =  oJSONoutput.ph2idx
ph2nm =  oJSONoutput.ph2nm
ph2tnm =  oJSONoutput.ph2tnm
ph2t2nm =  oJSONoutput.ph2t2nm 

'파트너
ph3 =  oJSONoutput.ph3
ph3idx =  oJSONoutput.ph3idx 
ph3nm =  oJSONoutput.ph3nm
ph3tnm =  oJSONoutput.ph3tnm
ph3t2nm =  oJSONoutput.ph3t2nm 

'발송번호
phPhone =  oJSONoutput.phPhone 
phI =  oJSONoutput.phI 
phI_seq =  oJSONoutput.phI_seq 

toNumber = phPhone

SQL = " select b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "   
SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg, max(b.fee) as fee, max(b.fund) as fund "  
SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d , d.lmsSendChk ,count(s.gameMemberIDX)MemberCnt"  
SQL = SQL &"  from tblRGameLevel b  "  
SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
SQL = SQL &"  inner join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' and d.RequestIDX= "&ridx
SQL = SQL &"  left JOIN sd_TennisMember s on d.GameTitleIDX = s.GameTitleIDX and d.Level = s.gamekey3 and s.DelYN='N' and d.P1_PlayerIDX= s.PlayerIDX and isnull(Round,0)=0"
SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&tidx&"' and c.LevelNm not like '%최종%'  "
SQL = SQL &"  and  c.Level='"&levelno&"'"
SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg,   d.lmsSendChk "

Set db = new clsDBHelper

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.EOF Then 
	Do Until rs.eof
        TeamGbNm = rs("TeamGbNm") 
        levelNm = rs("LevelNm") 
        lmsSendChk = rs("lmsSendChk") 
        MemberCnt = rs("MemberCnt") 
        EntryCntGame= rs("EntryCntGame") 
		fee = rs("fee")
		fund = rs("fund")
		acctotal = CDbl(fee) + CDbl(fund)
	rs.movenext
	Loop
End if


if Cdbl(lmsSendChk) > 3 then 
    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "64" )
    Call oJSONoutput.Set("phI", phI )
    Call oJSONoutput.Set("phI_seq", phI_seq )
    Call oJSONoutput.Set("lmsSendChk", lmsSendChk )
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
    Response.End

end if 


'정보 다시 구하자 잘못가는경우가 있다는데 ㅡㅡ C foot
SQL = "select gametitlename from sd_tennisTitle where gametitleidx = " & tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.eof then
tidxNm = rs(0)
End if


SMS_Subject = "["&tidxNm&"]대회 신청 안내"
SMS_Msg = ""
SMS_Msg = SMS_Msg & ""&tidxNm&"  ("&TeamGbNm&" "&levelNm&")에 참가신청이 접수되었습니다.\n\n"

SMS_Msg = SMS_Msg & "- 신청자 : "&ph1nm&" \n"
SMS_Msg = SMS_Msg & "- 참가자 : "&ph2nm&"("&ph2tnm&","&ph2t2nm&")\n "

if ph3nm <> "" then
SMS_Msg = SMS_Msg & "- 파트너 : "&ph3nm&"("&ph3tnm&","&ph3t2nm&")\n\n"
end if  

if Cdbl(MemberCnt)<=0 then 
	SMS_Msg = SMS_Msg & " 현재 인원수 제한으로 참가 대기로 접수 되었습니다.  \n"
	SMS_Msg = SMS_Msg & " 문의 : SD고객센터(02-704-0282) \n\n"
Else '가상계좌

	If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만
		SQL = "Select VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '" & Left(sitecode,2) &  ridx & "' and sitecode = '"&sitecode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			SMS_Msg = SMS_Msg & "- 가상계좌: " & rs(0) & "\n"
			SMS_Msg = SMS_Msg & "- 은행: "&CONST_BANKNM & "\n"
			SMS_Msg = SMS_Msg & "- 참가비: " & acctotal & "원  \n"
		End if
	End if
end If


SMS_Msg = replace(SMS_Msg, "\n", "&#13;")						'줄바꿈 변환

contents = SMS_Msg
indexCode =  now() 'Replace(Date,"-","") & Replace(time,":","") ' now()
 
SQL = " update tblGameRequest  set lmsSendChk = lmsSendChk+1 "  
SQL = SQL &"  where DelYN='N' and GameTitleIDX='"&tidx&"'  and  Level='"&levelno&"' and RequestIDX= "&ridx
Call db.execSQLRs(SQL , null, ConStr)


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("fromid", "form"&phI&toNumber)
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

db.Dispose
Set db = Nothing
%>
<form id="form<%=phI %><%=toNumber %>" action='http://biz.moashot.com/EXT/URLASP/mssendutf.asp' method='post' target="hiddenFrame<%=phI %>">
	<input type='hidden' name='uid' value='rubin500' />
	<input type='hidden' name='pwd' value='rubin0907' />
	<input type='hidden' name='commType' value='0' /><!--보안설정 0-일반,1-MD5-->
	<input type='hidden' name='commCode' value='' /><!--보안코드(비밀번호를 MD5로 변환한값)-->
	<input type='hidden' name='sendType' value='5' /><!--전송구분 3-단문문자, 5-LMS(장문문자), 6-MMS(Image포함문자) -->
	<input type='hidden' name='title' value='<%=SMS_Subject%>' /><!--전송제목-->
	<input type='hidden' name='toNumber' id='toNumber' value='<%=toNumber%>' /><!--수신처 핸드폰 번호(동보 전송일 경우‘,’로 구분하여 입력)-->
	<input type='hidden' name='contents' id='contents' value='<%=contents%>' /><!--전송할 문자나 MMS 내용(문자 80byte, MMS 2000byte)-->
	<input type='hidden' name='fileName' value='' /><!--이미지 전송시 파일명(JPG이미지만 가능)-->
	<input type='hidden' name='fromNumber' value='027040282' /><!--발신자 번호(휴대폰,일반전화 번호 가능)-->
	<input type='hidden' name='nType' value='4' /><!--결과전송 타입 1. 전송건 접수 여부, 2. 전송건 성공 실패 여부(1~8), 3. 위 1,2 모두 확인, 4. 모두 확인 안함-->
	<input type='hidden' name='indexCode' value='<%=indexCode%>' /><!--전송건에 대한 고유 값(동보 전송일 경우 ‘,’로 구분하여 입력)-->
	<input type='hidden' name='returnUrl' id='returnUrl' value='' /><!--전송결과를 호출 받을 웹 페이지의 URL주소-->
	<input type='hidden' name='returnType' id='returnType' value='2' /><!--0 또는 NULL 호출페이지 Close, 1. 호출페이지 유지, 2. redirectUrl 에 입력한 경로로 이동합니다(Redirect)-->
	<input type='hidden' name='redirectUrl' id='redirectUrl' value='http://<%=URL_HOST%>/pub/_blank.html'><!--전송(접수)후 페이지 이동경로http:// 또는 https:// 를 포함한 풀경로를 입력합니다.-->
</form>
 
