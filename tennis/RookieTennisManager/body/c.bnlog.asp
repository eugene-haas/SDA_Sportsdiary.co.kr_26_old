<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  


  '대회그룹/등급
'  SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
'  Set rsg = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'  If Not rsg.EOF Then
'    arrRSG = rsg.GetRows()
'  End If
'
'  '계좌 사용량
'  SQL = "Select Count(*) from TB_RVAS_MAST where CUST_CD IS NOT NULL "'and sitecode = '"&sitecode&"'"
'  Set rscnt = db.ExecSQLReturnRS(SQL, null, ConStr)
'  vacUseCount = rscnt(0)

sex = request("sex")

gb = request("gb")

s = request("s")
e = request("e")
stype = request("t")

If sex = "" Then
	sex = "Man"
End if

If gb = "" Then
	gb = "tennis"
End if

If s = "" Then
s = "20190623"
End If
If e = "" Then
e = "20190722"
End If


Select Case stype 
Case "1"


'-- 배너 로그 유저
SQL = "select 	o.UserName,	o.Birthday,	o.Age, "
SQL = SQL & "	(case	"
SQL = SQL & "		when Age < 0"
SQL = SQL & "			then	'오류' "
SQL = SQL & "		when Age < 10 and Age >= 0 "
SQL = SQL & "			then '10대미만' "
SQL = SQL & "		when Age < 20 and Age >= 10 "
SQL = SQL & "			then '10대' "
SQL = SQL & "		when Age < 30 and Age >= 20 "
SQL = SQL & "			then '20대' "
SQL = SQL & "		when Age < 40 and Age >= 30 "
SQL = SQL & "			then '30대' "
SQL = SQL & "		when Age < 50 and Age >= 40 "
SQL = SQL & "			then '40대' "
SQL = SQL & "		else	'50대이상' "
SQL = SQL & "	end) as AgeTypeNm, "
SQL = SQL & "	o.Sex,"
SQL = SQL & "	o.WriteID "
SQL = SQL & "	from"
SQL = SQL & "	( "
SQL = SQL & "		select "
SQL = SQL & "			distinct "
SQL = SQL & "			b.UserName,"
SQL = SQL & "			left(b.Birthday,4) as Birthday,"
SQL = SQL & "			2018 - Convert(int,left(b.Birthday,4)) as Age,"
'SQL = SQL & "			--'1' as AgeTypeNm,"
SQL = SQL & "			b.Sex,"
SQL = SQL & "			a.WriteID"
SQL = SQL & "			FROM [SD_AD].[dbo].[tblADLog] a"
SQL = SQL & "			left join [SD_Member].[dbo].[tblMember] b on b.UserID = a.WriteID"
SQL = SQL & "			where a.DelYN = 'N' and a.sportsgb = '"&gb&"' and b.sex = '"&sex&"' " 
SQL = SQL & "						and a.WriteID <> '' "
SQL = SQL & "						and CONVERT(VARCHAR, a.WriteDate, 112) >= '"&s&"' "
SQL = SQL & "						and CONVERT(VARCHAR, a.WriteDate, 112) <= '"&e&"' "
SQL = SQL & "	) o"
SQL = SQL & "	order by o.UserName "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)


Case "2"


'-- 배너 로그 조회
SQL = " SELECT        [SportsGb]      ,[CateLocate1Nm]      ,[CateLocate2Nm]      ,[CateLocate3Nm]      ,[CateLocate4Nm]      ,[txtMemo]      ,[ADProductLocateTitle]      ,[Link]      ,[ImageTypeNm] "
SQL = SQL & "      ,REPLACE(DateProdS,'-','') as DateProdS "
SQL = SQL & "      ,REPLACE(DateProdE,'-','') as DateProdE "
SQL = SQL & "			,CONVERT(CHAR(2), WriteDate, 8) as WriteDate_Hour "
SQL = SQL & "			,CONVERT(VARCHAR, WriteDate, 112) as WriteDate "
SQL = SQL & "			,WriteID      ,[DelYN] "
SQL = SQL & "  FROM [SD_AD].[dbo].[tblADLog] "
SQL = SQL & "	where DelYN = 'N' "
SQL = SQL & "				and WriteID <> '' "
SQL = SQL & "				and CONVERT(VARCHAR, WriteDate, 112) >= '"&s&"' "
SQL = SQL & "				and CONVERT(VARCHAR, WriteDate, 112) <= '"&e&"' "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)


Case "3"
SQL = "select count(a.PlayerIDX) , '여' from (select PlayerIDX FROM sd_TennisMember where gubun = 1 and WriteDate > '2019-01-01'  and  teamgb in ('20101','20102') group by PlayerIDX) as a "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

SQL = "select count(a.PlayerIDX) , '남' from (select PlayerIDX FROM sd_TennisMember where gubun = 1 and WriteDate > '2019-01-01'  and  teamgb in ('20104','20105') group by PlayerIDX) as a "
Set rs2 = db.ExecSQLReturnRS(SQL, null, ConStr)


SQL = "select count(a.p), '여+'  from ( select distinct(y.PlayerIDX) as p from sd_TennisMember x inner join sd_TennisMember_partner as y on x.gameMemberIDX = y.gameMemberIDX  where y.lastupdate > '2019-01-01'  and y.PlayerIDX not in (select PlayerIDX FROM sd_TennisMember where gubun = 1 and WriteDate > '2019-01-01'  group by PlayerIDX) and x.TeamGb in ('20101','20102')   ) as a "
Set rs3 = db.ExecSQLReturnRS(SQL, null, ConStr)


SQL = "select count(a.p), '남+'  from ( select distinct(y.PlayerIDX) as p from sd_TennisMember x inner join sd_TennisMember_partner as y on x.gameMemberIDX = y.gameMemberIDX  where y.lastupdate > '2019-01-01'  and y.PlayerIDX not in (select PlayerIDX FROM sd_TennisMember where gubun = 1 and WriteDate > '2019-01-01'  group by PlayerIDX) and x.TeamGb in ('20104','20105')   ) as a "
Set rs4 = db.ExecSQLReturnRS(SQL, null, ConStr)



Case "4"

SQL = "SELECT "
SQL = SQL & "      [SportsGb] "
SQL = SQL & "      , COUNT(*) over(partition by adProductLocateTitle) cnt "
SQL = SQL & "      ,[CateLocate1Nm] "
SQL = SQL & "      ,[CateLocate2Nm] "
SQL = SQL & "      ,[CateLocate3Nm] "
SQL = SQL & "      ,[CateLocate4Nm] "
SQL = SQL & "      ,[txtMemo] "
SQL = SQL & "      ,[ADProductLocateTitle] "
SQL = SQL & "      ,[Link] "
SQL = SQL & "      ,[ImageTypeNm] "
SQL = SQL & "      ,REPLACE(DateProdS,'-','') as DateProdS "
SQL = SQL & "      ,REPLACE(DateProdE,'-','') as DateProdE "
SQL = SQL & "			,CONVERT(CHAR(2), a.WriteDate, 8) as WriteDate_Hour "
SQL = SQL & "			,CONVERT(VARCHAR, a.WriteDate, 112) as WriteDate "
SQL = SQL & "			,WriteID "
SQL = SQL & "      ,a.[DelYN] "
SQL = SQL & "      ,b.Sex "
SQL = SQL & "  FROM [SD_AD].[dbo].[tblADLog] a "
SQL = SQL & "  inner join sd_member.dbo.tblMember b on a.WriteID = b.UserID "
SQL = SQL & "	where a.DelYN = 'N' "
SQL = SQL & "				and WriteID <> '' "
SQL = SQL & "				and CONVERT(VARCHAR, a.WriteDate, 112) >= '"&s&"' "
SQL = SQL & "				and CONVERT(VARCHAR, a.WriteDate, 112) <= '"&e&"' "
SQL = SQL & "				and SportsGb = 'tennis' "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

End Select

%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회정보 <!-- (sd_TenisTitle) --></h1></div>



			<!-- s: 테이블 리스트 -->
			<div class="table_list contest">


			<%

			
			Call rsdrow(rs)


			If stype = "3"  then
			Call rsdrow(rs2)
			Call rsdrow(rs3)
			Call rsdrow(rs4)
			End if
			
			%>



			</div>
			<!-- e: 테이블 리스트 -->


		</div>
		<!-- s: 콘텐츠 끝 -->
